"""Structural and semantic GTFS validation.

This complements (does not replace) the MobilityData gtfs-validator: it enforces the invariants
İzmir Go relies on and decides whether a source is usable *today*.
"""

from __future__ import annotations

from collections import Counter, defaultdict
from dataclasses import dataclass, field
from datetime import date, datetime
from itertools import pairwise
from typing import Any, Literal

from izmirgo.core.servicetime import InvalidGtfsTime, parse_gtfs_time
from izmirgo.ingestion.gtfs import REQUIRED_COLUMNS, REQUIRED_FILES, GtfsFeed

Validity = Literal["valid", "expired", "not_yet_valid", "invalid"]
Severity = Literal["error", "warning"]

MAX_EXAMPLES = 5
MAX_TRIP_DURATION_S = 6 * 3600
ROW_DROP_QUARANTINE_RATIO = 0.30
# Trip-level defects affecting at most this share of trips are repaired by dropping the trips
# (recorded in the report) instead of rejecting the whole feed.
MAX_REPAIR_RATIO = 0.01
REPAIRABLE = {
    "stop_time_unknown_trip",
    "stop_time_unknown_stop",
    "trip_without_stop_times",
    "non_monotonic_times",
    "invalid_time",
}
VALID_ROUTE_TYPES = {0, 1, 2, 3, 4, 5, 6, 7, 11, 12} | set(range(100, 1800))


@dataclass
class Issue:
    code: str
    severity: Severity
    count: int = 0
    examples: list[str] = field(default_factory=list)

    def add(self, example: str) -> None:
        self.count += 1
        if len(self.examples) < MAX_EXAMPLES:
            self.examples.append(example)


@dataclass
class ValidationReport:
    issues: dict[str, Issue] = field(default_factory=dict)
    stats: dict[str, int] = field(default_factory=dict)
    feed_start: date | None = None
    feed_end: date | None = None
    validity: Validity = "invalid"
    # Trips to exclude when merging (repaired defects) and stop_time trip refs with no trip.
    drop_trip_ids: set[str] = field(default_factory=set)
    orphan_trip_refs: set[str] = field(default_factory=set)

    def flag(self, code: str, severity: Severity, example: str = "") -> None:
        issue = self.issues.setdefault(code, Issue(code, severity))
        issue.add(example)

    @property
    def errors(self) -> list[Issue]:
        return [i for i in self.issues.values() if i.severity == "error"]

    @property
    def warnings(self) -> list[Issue]:
        return [i for i in self.issues.values() if i.severity == "warning"]

    @property
    def ok(self) -> bool:
        return not self.errors

    @property
    def usable(self) -> bool:
        """Structurally sound *and* in service today."""
        return self.ok and self.validity == "valid"

    def to_dict(self) -> dict[str, Any]:
        return {
            "validity": self.validity,
            "feed_start": self.feed_start.isoformat() if self.feed_start else None,
            "feed_end": self.feed_end.isoformat() if self.feed_end else None,
            "stats": self.stats,
            "repairs": {
                "dropped_trips": len(self.drop_trip_ids),
                "orphan_stop_time_trip_refs": len(self.orphan_trip_refs),
            },
            "issues": [
                {"code": i.code, "severity": i.severity, "count": i.count, "examples": i.examples}
                for i in self.issues.values()
            ],
        }


def _apply_repair_policy(
    report: ValidationReport, *, trip_count: int, stop_time_count: int
) -> None:
    """Downgrade small trip-level defects to warnings; the merge step drops those trips."""
    repairable = [i for i in report.errors if i.code in REPAIRABLE]
    if not repairable or len(repairable) != len(report.errors):
        return  # nothing to repair, or other fatal errors exist anyway
    orphan_rows = report.issues.get("stop_time_unknown_trip")
    trips_ok = trip_count and len(report.drop_trip_ids) / trip_count <= MAX_REPAIR_RATIO
    rows_ok = stop_time_count and (orphan_rows.count if orphan_rows else 0) / stop_time_count <= (
        MAX_REPAIR_RATIO
    )
    if trips_ok and rows_ok:
        for issue in repairable:
            issue.severity = "warning"
        report.flag("repaired_by_dropping_trips", "warning", f"{len(report.drop_trip_ids)} trips")


def _parse_date(value: str) -> date | None:
    try:
        return datetime.strptime(value, "%Y%m%d").date()  # noqa: DTZ007 - calendar date, no tz
    except ValueError:
        return None


def validate_feed(
    feed: GtfsFeed,
    *,
    today: date,
    bbox: tuple[float, float, float, float],
    previous_stats: dict[str, int] | None = None,
) -> ValidationReport:
    report = ValidationReport()

    # --- files & columns -------------------------------------------------------------------
    for name in REQUIRED_FILES:
        if not feed.has(name):
            report.flag("missing_file", "error", name)
    if not feed.has("calendar.txt") and not feed.has("calendar_dates.txt"):
        report.flag("missing_file", "error", "calendar.txt|calendar_dates.txt")
    for name, required in REQUIRED_COLUMNS.items():
        if feed.has(name):
            cols = set(feed.columns(name))
            for col in required:
                if col not in cols:
                    report.flag("missing_column", "error", f"{name}:{col}")
    if report.errors:
        return report  # cannot safely continue

    # --- agency ----------------------------------------------------------------------------
    agencies = feed.rows("agency.txt")
    for a in agencies:
        if a.get("agency_timezone") != "Europe/Istanbul":
            report.flag("unexpected_timezone", "warning", a.get("agency_timezone", ""))

    # --- stops -----------------------------------------------------------------------------
    stop_ids: set[str] = set()
    lon_min, lat_min, lon_max, lat_max = bbox
    outside = 0
    for s in feed.iter_rows("stops.txt"):
        sid = s["stop_id"]
        if not sid:
            report.flag("empty_id", "error", "stops.txt")
            continue
        if sid in stop_ids:
            report.flag("duplicate_stop_id", "error", sid)
        stop_ids.add(sid)
        try:
            lat, lon = float(s.get("stop_lat", "")), float(s.get("stop_lon", ""))
        except ValueError:
            if s.get("location_type", "0") in ("", "0", "1"):
                report.flag("invalid_coordinates", "error", sid)
            continue
        if not (lat_min <= lat <= lat_max and lon_min <= lon <= lon_max):
            outside += 1
            report.flag("stop_outside_coverage", "warning", f"{sid} ({lat},{lon})")
    if stop_ids and outside / len(stop_ids) > 0.05:
        report.flag("many_stops_outside_coverage", "error", f"{outside}/{len(stop_ids)}")

    # --- routes ----------------------------------------------------------------------------
    route_ids: set[str] = set()
    for r in feed.iter_rows("routes.txt"):
        if r["route_id"] in route_ids:
            report.flag("duplicate_route_id", "error", r["route_id"])
        route_ids.add(r["route_id"])
        try:
            if int(r["route_type"]) not in VALID_ROUTE_TYPES:
                raise ValueError
        except ValueError:
            report.flag("invalid_route_type", "error", f"{r['route_id']}:{r['route_type']}")

    # --- calendars -------------------------------------------------------------------------
    service_ids: set[str] = set()
    starts: list[date] = []
    ends: list[date] = []
    for c in feed.iter_rows("calendar.txt"):
        service_ids.add(c["service_id"])
        start, end = _parse_date(c["start_date"]), _parse_date(c["end_date"])
        if start is None or end is None or end < start:
            report.flag("invalid_calendar_range", "error", c["service_id"])
            continue
        starts.append(start)
        ends.append(end)
    calendar_dates = 0
    for cd in feed.iter_rows("calendar_dates.txt"):
        calendar_dates += 1
        service_ids.add(cd["service_id"])
        d = _parse_date(cd["date"])
        if d is None or cd["exception_type"] not in ("1", "2"):
            report.flag("invalid_calendar_date", "error", f"{cd['service_id']}:{cd['date']}")
        elif cd["exception_type"] == "1":
            starts.append(d)
            ends.append(d)
    if calendar_dates == 0:
        report.flag("no_calendar_exceptions", "warning", "public holidays are not represented")

    # --- trips -----------------------------------------------------------------------------
    trip_ids: set[str] = set()
    trips_per_service: Counter[str] = Counter()
    for t in feed.iter_rows("trips.txt"):
        tid = t["trip_id"]
        if tid in trip_ids:
            report.flag("duplicate_trip_id", "error", tid)
        trip_ids.add(tid)
        if t["route_id"] not in route_ids:
            report.flag("trip_unknown_route", "error", f"{tid}->{t['route_id']}")
        if t["service_id"] not in service_ids:
            report.flag("trip_unknown_service", "error", f"{tid}->{t['service_id']}")
        trips_per_service[t["service_id"]] += 1

    # --- stop_times (streamed) -------------------------------------------------------------
    st_rows = 0
    after_midnight = 0
    trip_times: dict[str, list[tuple[int, int]]] = defaultdict(list)
    for st in feed.iter_rows("stop_times.txt"):
        st_rows += 1
        tid = st["trip_id"]
        if tid not in trip_ids:
            report.flag("stop_time_unknown_trip", "error", tid)
            report.orphan_trip_refs.add(tid)
            continue
        if st["stop_id"] not in stop_ids:
            report.flag("stop_time_unknown_stop", "error", f"{tid}:{st['stop_id']}")
            report.drop_trip_ids.add(tid)
        raw_time = st.get("departure_time") or st.get("arrival_time") or ""
        try:
            seq = int(st["stop_sequence"])
        except ValueError:
            report.flag("invalid_stop_sequence", "error", f"{tid}:{st['stop_sequence']}")
            continue
        if not raw_time:
            continue  # interpolated stop; allowed by GTFS when timepoint=0
        try:
            secs = parse_gtfs_time(raw_time)
        except InvalidGtfsTime:
            report.flag("invalid_time", "error", f"{tid}:{raw_time}")
            report.drop_trip_ids.add(tid)
            continue
        if secs >= 24 * 3600:
            after_midnight += 1
        trip_times[tid].append((seq, secs))

    for tid, seq_times in trip_times.items():
        seq_times.sort()
        times = [t for _, t in seq_times]
        if any(b < a for a, b in pairwise(times)):
            report.flag("non_monotonic_times", "error", tid)
            report.drop_trip_ids.add(tid)
        if times and times[-1] - times[0] > MAX_TRIP_DURATION_S:
            report.flag("implausible_trip_duration", "warning", tid)
        if len(seq_times) < 2:
            report.flag("trip_too_few_stops", "warning", tid)
    for tid in trip_ids - trip_times.keys():
        report.flag("trip_without_stop_times", "error", tid)
        report.drop_trip_ids.add(tid)

    _apply_repair_policy(report, trip_count=len(trip_ids), stop_time_count=st_rows)

    # --- stats & deltas --------------------------------------------------------------------
    report.stats = {
        "agencies": len(agencies),
        "stops": len(stop_ids),
        "routes": len(route_ids),
        "trips": len(trip_ids),
        "stop_times": st_rows,
        "stop_times_after_midnight": after_midnight,
        "services": len(service_ids),
        "calendar_dates": calendar_dates,
        "has_shapes": int(feed.has("shapes.txt")),
    }
    if previous_stats:
        for key in ("stops", "routes", "trips", "stop_times"):
            prev = previous_stats.get(key, 0)
            cur = report.stats[key]
            if prev and (prev - cur) / prev > ROW_DROP_QUARANTINE_RATIO:
                report.flag("row_count_drop", "error", f"{key}: {prev} -> {cur}")

    # --- validity window -------------------------------------------------------------------
    if starts and ends:
        report.feed_start, report.feed_end = min(starts), max(ends)
        if report.feed_end < today:
            report.validity = "expired"
        elif report.feed_start > today:
            report.validity = "not_yet_valid"
        else:
            report.validity = "valid"
    else:
        report.flag("no_service_dates", "error", "")
    if report.errors:
        report.validity = "invalid"
    return report
