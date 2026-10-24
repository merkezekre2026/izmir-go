"""Merge several operator feeds into one namespaced GTFS feed.

Why merge: GTFS `transfers.txt` and `parent_station` are scoped to a single feed. Cross-operator
interchanges (e.g. Metro Halkapınar ↔ Tram Halkapınar, 279 m apart) can only be expressed
explicitly if every operator lives in the same feed. All IDs become `{source}:{raw}` so feeds
whose raw IDs collide (43 stop_ids did on 2026-10-24) can coexist.
"""

from __future__ import annotations

import csv
import io
import math
import zipfile
from collections.abc import Iterable, Iterator, Sequence
from dataclasses import dataclass, field
from datetime import date
from pathlib import Path

from izmirgo.core.logging import get_logger
from izmirgo.domain.ids import nsid
from izmirgo.ingestion.gtfs import GtfsFeed, Row
from izmirgo.ingestion.sources import GtfsSource

log = get_logger("ingestion.merge")

# Columns holding IDs that must be namespaced, per GTFS file.
ID_COLUMNS: dict[str, tuple[str, ...]] = {
    "agency.txt": ("agency_id",),
    "stops.txt": ("stop_id", "parent_station", "zone_id", "level_id"),
    "routes.txt": ("route_id", "agency_id"),
    "trips.txt": ("route_id", "service_id", "trip_id", "shape_id", "block_id"),
    "stop_times.txt": ("trip_id", "stop_id"),
    "calendar.txt": ("service_id",),
    "calendar_dates.txt": ("service_id",),
    "shapes.txt": ("shape_id",),
    "frequencies.txt": ("trip_id",),
    "transfers.txt": (
        "from_stop_id",
        "to_stop_id",
        "from_route_id",
        "to_route_id",
        "from_trip_id",
        "to_trip_id",
    ),
}
MERGED_FILES = tuple(ID_COLUMNS)
DEFAULT_AGENCY = "agency"


@dataclass(frozen=True)
class SourceInput:
    source: GtfsSource
    path: Path
    feed_start: date
    feed_end: date
    # Raw trip IDs removed by the validator's repair policy.
    drop_trip_ids: frozenset[str] = frozenset()


@dataclass(frozen=True)
class Interchange:
    from_stop_id: str
    to_stop_id: str
    min_transfer_time_s: int
    evidence: str


@dataclass(frozen=True)
class Station:
    station_id: str
    name: str
    member_stop_ids: tuple[str, ...]


@dataclass
class MergeResult:
    path: Path
    sources: list[str]
    counts: dict[str, dict[str, int]] = field(default_factory=dict)
    skipped_interchanges: list[str] = field(default_factory=list)
    stations_added: int = 0
    transfers_added: int = 0


def load_interchanges(path: Path) -> list[Interchange]:
    if not path.exists():
        return []
    with path.open(encoding="utf-8", newline="") as fh:
        return [
            Interchange(
                r["from_stop_id"].strip(),
                r["to_stop_id"].strip(),
                int(r["min_transfer_time_s"]),
                r.get("evidence", "").strip(),
            )
            for r in csv.DictReader(fh)
            if not r["from_stop_id"].startswith("#")
        ]


def load_stations(path: Path) -> list[Station]:
    if not path.exists():
        return []
    with path.open(encoding="utf-8", newline="") as fh:
        return [
            Station(r["station_id"].strip(), r["name"].strip(), tuple(r["member_stop_ids"].split()))
            for r in csv.DictReader(fh)
            if not r["station_id"].startswith("#")
        ]


def _namespace_row(source_id: str, filename: str, row: Row) -> Row:
    out = dict(row)
    for col in ID_COLUMNS.get(filename, ()):
        value = out.get(col, "")
        if value:
            out[col] = nsid(source_id, value)
        elif col == "agency_id" and filename in ("agency.txt", "routes.txt"):
            # agency_id may be blank in single-agency feeds; make it explicit after merging.
            out[col] = nsid(source_id, DEFAULT_AGENCY)
    return out


def haversine_m(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    r = 6371008.8
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp, dl = p2 - p1, math.radians(lon2 - lon1)
    h = math.sin(dp / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    return 2 * r * math.asin(math.sqrt(h))


class _Writer:
    """Streams rows for one file; the header is the union of all inputs' columns."""

    def __init__(self, zf: zipfile.ZipFile, name: str, header: Sequence[str]) -> None:
        self._raw = zf.open(name, "w", force_zip64=True)
        self._text = io.TextIOWrapper(self._raw, encoding="utf-8", newline="")
        self._csv = csv.DictWriter(self._text, fieldnames=list(header), extrasaction="ignore")
        self._csv.writeheader()
        self.count = 0

    def write(self, row: Row) -> None:
        self._csv.writerow(row)
        self.count += 1

    def close(self) -> None:
        self._text.flush()
        self._text.close()


def _ordered_union(columns: Iterable[Sequence[str]], required: Sequence[str] = ()) -> list[str]:
    seen: dict[str, None] = dict.fromkeys(required)
    for cols in columns:
        for c in cols:
            seen.setdefault(c, None)
    return list(seen)


def merge_feeds(
    inputs: Sequence[SourceInput],
    out_path: Path,
    *,
    version_label: str,
    interchanges: Sequence[Interchange] = (),
    stations: Sequence[Station] = (),
    attribution_url: str = "https://acikveri.bizizmir.com/tr/license",
) -> MergeResult:
    if not inputs:
        raise ValueError("no usable sources to merge")
    out_path.parent.mkdir(parents=True, exist_ok=True)
    result = MergeResult(path=out_path, sources=[i.source.id for i in inputs])

    feeds = {i.source.id: GtfsFeed(i.path).__enter__() for i in inputs}
    drops = {i.source.id: i.drop_trip_ids for i in inputs}
    try:
        # Pass 1: stop coordinates for curated data (small table).
        stops_by_id: dict[str, Row] = {}
        for sid, feed in feeds.items():
            for row in feed.iter_rows("stops.txt"):
                ns_row = _namespace_row(sid, "stops.txt", row)
                stops_by_id[ns_row["stop_id"]] = ns_row

        # Curated stations: only when at least two members exist in this merge.
        parent_of: dict[str, str] = {}
        station_rows: list[Row] = []
        for st in stations:
            members = [
                m
                for m in st.member_stop_ids
                if m in stops_by_id
                and stops_by_id[m].get("location_type", "0") in ("", "0")
                and not stops_by_id[m].get("parent_station")
            ]
            if len(members) < 2:
                continue
            lat = sum(float(stops_by_id[m]["stop_lat"]) for m in members) / len(members)
            lon = sum(float(stops_by_id[m]["stop_lon"]) for m in members) / len(members)
            station_rows.append(
                {
                    "stop_id": st.station_id,
                    "stop_name": st.name,
                    "stop_lat": f"{lat:.6f}",
                    "stop_lon": f"{lon:.6f}",
                    "location_type": "1",
                }
            )
            for m in members:
                parent_of[m] = st.station_id
        result.stations_added = len(station_rows)

        with zipfile.ZipFile(out_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
            for filename in MERGED_FILES:
                headers = [f.columns(filename) for f in feeds.values() if f.has(filename)]
                extra: list[str] = []
                if filename == "stops.txt":
                    extra = ["location_type", "parent_station"]
                if filename == "transfers.txt":
                    extra = ["from_stop_id", "to_stop_id", "transfer_type", "min_transfer_time"]
                if not headers and not (filename == "transfers.txt" and interchanges):
                    continue
                writer = _Writer(zf, filename, _ordered_union(headers, extra))
                for sid, feed in feeds.items():
                    before = writer.count
                    for row in _iter_namespaced(sid, filename, feed, drops[sid]):
                        if filename == "stops.txt" and row["stop_id"] in parent_of:
                            row["parent_station"] = parent_of[row["stop_id"]]
                        writer.write(row)
                    result.counts.setdefault(sid, {})[filename] = writer.count - before
                if filename == "stops.txt":
                    for row in station_rows:
                        writer.write(row)
                if filename == "transfers.txt":
                    result.transfers_added = _write_interchanges(
                        writer, interchanges, stops_by_id, result.skipped_interchanges
                    )
                writer.close()

            _write_small(
                zf,
                "feed_info.txt",
                [
                    "feed_publisher_name",
                    "feed_publisher_url",
                    "feed_lang",
                    "feed_start_date",
                    "feed_end_date",
                    "feed_version",
                ],
                [
                    {
                        "feed_publisher_name": "İzmir Go (merged from İzmir open data feeds)",
                        "feed_publisher_url": "https://github.com/merkezekre2026/izmir-go",
                        "feed_lang": "tr",
                        "feed_start_date": min(i.feed_start for i in inputs).strftime("%Y%m%d"),
                        "feed_end_date": max(i.feed_end for i in inputs).strftime("%Y%m%d"),
                        "feed_version": version_label,
                    }
                ],
            )
            _write_small(
                zf,
                "attributions.txt",
                [
                    "attribution_id",
                    "agency_id",
                    "organization_name",
                    "is_producer",
                    "attribution_url",
                ],
                [
                    {
                        "attribution_id": f"attr:{i.source.id}",
                        "agency_id": "",
                        "organization_name": i.source.operator,
                        "is_producer": "1",
                        "attribution_url": attribution_url,
                    }
                    for i in inputs
                ],
            )
    finally:
        for feed in feeds.values():
            feed.__exit__(None, None, None)

    log.info(
        "merged",
        sources=result.sources,
        stations=result.stations_added,
        transfers=result.transfers_added,
        skipped_interchanges=len(result.skipped_interchanges),
    )
    return result


_TRIP_FILES = ("trips.txt", "stop_times.txt", "frequencies.txt")


def _iter_namespaced(
    source_id: str, filename: str, feed: GtfsFeed, drop_trip_ids: frozenset[str]
) -> Iterator[Row]:
    filter_trips = filename in _TRIP_FILES and drop_trip_ids
    for row in feed.iter_rows(filename):
        if filter_trips and row.get("trip_id", "") in drop_trip_ids:
            continue
        yield _namespace_row(source_id, filename, row)


def _write_interchanges(
    writer: _Writer,
    interchanges: Sequence[Interchange],
    stops_by_id: dict[str, Row],
    skipped: list[str],
) -> int:
    written = 0
    for ic in interchanges:
        if ic.from_stop_id not in stops_by_id or ic.to_stop_id not in stops_by_id:
            skipped.append(f"{ic.from_stop_id}<->{ic.to_stop_id}")
            continue
        for a, b in ((ic.from_stop_id, ic.to_stop_id), (ic.to_stop_id, ic.from_stop_id)):
            writer.write(
                {
                    "from_stop_id": a,
                    "to_stop_id": b,
                    "transfer_type": "2",
                    "min_transfer_time": str(ic.min_transfer_time_s),
                }
            )
            written += 1
    return written


def _write_small(zf: zipfile.ZipFile, name: str, header: list[str], rows: list[Row]) -> None:
    buf = io.StringIO()
    w = csv.DictWriter(buf, fieldnames=header)
    w.writeheader()
    w.writerows(rows)
    zf.writestr(name, buf.getvalue())
