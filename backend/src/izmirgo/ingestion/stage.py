"""Load a merged, namespaced GTFS feed into Postgres as a new *staged* dataset version.

Bulk data goes through COPY. Nothing becomes visible to the API until `publish.activate` flips
the version to active.
"""

from __future__ import annotations

import json
from collections.abc import Iterable, Sequence
from dataclasses import dataclass
from datetime import date, datetime, timedelta
from typing import Any

from sqlalchemy import Connection, Engine, text

from izmirgo.core.logging import get_logger
from izmirgo.core.servicetime import parse_gtfs_time
from izmirgo.domain.ids import split
from izmirgo.domain.modes import mode_for_route_type
from izmirgo.domain.search_text import fold
from izmirgo.ingestion.gtfs import GtfsFeed
from izmirgo.ingestion.sources import GtfsSource

log = get_logger("ingestion.stage")
WEEKDAYS = ("monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday")


@dataclass(frozen=True)
class CoverageRow:
    source: str
    snapshot_id: int | None
    status: str  # included | excluded
    reason: str | None
    feed_start: date | None
    feed_end: date | None
    fetched_at: datetime | None
    times_approximate: bool = False


def _int_or_none(value: str) -> int | None:
    try:
        return int(value) if value != "" else None
    except ValueError:
        return None


def _copy(
    conn: Connection, table: str, columns: Sequence[str], rows: Iterable[Sequence[Any]]
) -> int:
    raw = conn.connection.driver_connection
    count = 0
    with raw.cursor() as cur, cur.copy(f"COPY {table} ({', '.join(columns)}) FROM STDIN") as cp:  # type: ignore[union-attr]
        for row in rows:
            cp.write_row(row)
            count += 1
    return count


def expand_service_dates(feed: GtfsFeed) -> set[tuple[str, date]]:
    dates: set[tuple[str, date]] = set()
    for c in feed.iter_rows("calendar.txt"):
        start = datetime.strptime(c["start_date"], "%Y%m%d").date()  # noqa: DTZ007
        end = datetime.strptime(c["end_date"], "%Y%m%d").date()  # noqa: DTZ007
        active = [c[d] == "1" for d in WEEKDAYS]
        d = start
        while d <= end:
            if active[d.weekday()]:
                dates.add((c["service_id"], d))
            d += timedelta(days=1)
    for cd in feed.iter_rows("calendar_dates.txt"):
        d = datetime.strptime(cd["date"], "%Y%m%d").date()  # noqa: DTZ007
        if cd["exception_type"] == "1":
            dates.add((cd["service_id"], d))
        elif cd["exception_type"] == "2":
            dates.discard((cd["service_id"], d))
    return dates


def stage_dataset(
    engine: Engine,
    merged_path: Any,
    *,
    label: str,
    merged_sha256: str,
    sources: dict[str, GtfsSource],
    coverage: Sequence[CoverageRow],
) -> int:
    """Create a staged dataset_version and bulk-load the merged feed. Returns its id."""
    with engine.begin() as conn, GtfsFeed(merged_path) as feed:
        dv_id = conn.execute(
            text(
                "INSERT INTO dataset_version (label, status, merged_sha256, merged_path) "
                "VALUES (:label, 'staged', :sha, :path) RETURNING id"
            ),
            {"label": label, "sha": merged_sha256, "path": str(merged_path)},
        ).scalar_one()

        def ns(value: str) -> str:
            return split(value)[0]

        n_agency = _copy(
            conn,
            "agency",
            ("dataset_version_id", "agency_id", "source", "name", "url", "timezone"),
            (
                (
                    dv_id,
                    a["agency_id"],
                    ns(a["agency_id"]),
                    a["agency_name"],
                    a.get("agency_url"),
                    a["agency_timezone"],
                )
                for a in feed.iter_rows("agency.txt")
            ),
        )

        def stop_rows() -> Iterable[Sequence[Any]]:
            for s in feed.iter_rows("stops.txt"):
                lat, lon = float(s["stop_lat"]), float(s["stop_lon"])
                source, raw_id = split(s["stop_id"])
                yield (
                    dv_id,
                    s["stop_id"],
                    source,
                    raw_id,
                    s.get("stop_code") or None,
                    s.get("stop_name", ""),
                    fold(s.get("stop_name", "")),
                    lat,
                    lon,
                    f"SRID=4326;POINT({lon} {lat})",
                    _int_or_none(s.get("location_type", "")) or 0,
                    s.get("parent_station") or None,
                    _int_or_none(s.get("wheelchair_boarding", "")),
                )

        n_stops = _copy(
            conn,
            "stop",
            (
                "dataset_version_id",
                "stop_id",
                "source",
                "raw_id",
                "code",
                "name",
                "search_key",
                "lat",
                "lon",
                "geom",
                "location_type",
                "parent_station",
                "wheelchair_boarding",
            ),
            stop_rows(),
        )

        def route_rows() -> Iterable[Sequence[Any]]:
            for r in feed.iter_rows("routes.txt"):
                source, raw_id = split(r["route_id"])
                src = sources.get(source)
                short = r.get("route_short_name") or None
                long_name = r.get("route_long_name") or None
                grouping = src.route_grouping if src else "by_route_id"
                line_key = (
                    f"{source}:line:{short}"
                    if grouping == "by_short_name" and short
                    else r["route_id"]
                )
                yield (
                    dv_id,
                    r["route_id"],
                    source,
                    raw_id,
                    r.get("agency_id") or None,
                    short,
                    long_name,
                    int(r["route_type"]),
                    mode_for_route_type(int(r["route_type"])),
                    (r.get("route_color") or "").upper() or None,
                    (r.get("route_text_color") or "").upper() or None,
                    line_key,
                    fold(f"{short or ''} {long_name or ''}"),
                    bool(src and src.times_approximate),
                )

        n_routes = _copy(
            conn,
            "route",
            (
                "dataset_version_id",
                "route_id",
                "source",
                "raw_id",
                "agency_id",
                "short_name",
                "long_name",
                "route_type",
                "mode",
                "color",
                "text_color",
                "line_key",
                "search_key",
                "times_approximate",
            ),
            route_rows(),
        )

        n_trips = _copy(
            conn,
            "trip",
            (
                "dataset_version_id",
                "trip_id",
                "route_id",
                "service_id",
                "headsign",
                "direction_id",
                "shape_id",
                "wheelchair_accessible",
                "bikes_allowed",
            ),
            (
                (
                    dv_id,
                    t["trip_id"],
                    t["route_id"],
                    t["service_id"],
                    t.get("trip_headsign") or None,
                    _int_or_none(t.get("direction_id", "")),
                    t.get("shape_id") or None,
                    _int_or_none(t.get("wheelchair_accessible", "")),
                    _int_or_none(t.get("bikes_allowed", "")),
                )
                for t in feed.iter_rows("trips.txt")
            ),
        )

        def stop_time_rows() -> Iterable[Sequence[Any]]:
            for st in feed.iter_rows("stop_times.txt"):
                arr = st.get("arrival_time", "")
                dep = st.get("departure_time", "")
                yield (
                    dv_id,
                    st["trip_id"],
                    int(st["stop_sequence"]),
                    st["stop_id"],
                    parse_gtfs_time(arr) if arr else None,
                    parse_gtfs_time(dep) if dep else (parse_gtfs_time(arr) if arr else None),
                    _int_or_none(st.get("timepoint", "")),
                )

        n_stop_times = _copy(
            conn,
            "stop_time",
            (
                "dataset_version_id",
                "trip_id",
                "stop_sequence",
                "stop_id",
                "arrival_s",
                "departure_s",
                "timepoint",
            ),
            stop_time_rows(),
        )

        n_service_dates = _copy(
            conn,
            "service_date",
            ("dataset_version_id", "service_id", "date"),
            ((dv_id, sid, d) for sid, d in sorted(expand_service_dates(feed))),
        )

        n_shapes = 0
        if feed.has("shapes.txt"):
            conn.execute(
                text(
                    "CREATE TEMP TABLE tmp_shape_pt (shape_id text, seq int, lat float8, lon float8) "
                    "ON COMMIT DROP"
                )
            )
            _copy(
                conn,
                "tmp_shape_pt",
                ("shape_id", "seq", "lat", "lon"),
                (
                    (
                        p["shape_id"],
                        int(p["shape_pt_sequence"]),
                        float(p["shape_pt_lat"]),
                        float(p["shape_pt_lon"]),
                    )
                    for p in feed.iter_rows("shapes.txt")
                ),
            )
            n_shapes = conn.execute(
                text(
                    "INSERT INTO shape (dataset_version_id, shape_id, geom) "
                    "SELECT :dv, shape_id, ST_MakeLine(ST_SetSRID(ST_MakePoint(lon, lat), 4326) ORDER BY seq) "
                    "FROM tmp_shape_pt GROUP BY shape_id HAVING count(*) >= 2"
                ),
                {"dv": dv_id},
            ).rowcount

        n_transfers = _copy(
            conn,
            "transfer",
            (
                "dataset_version_id",
                "from_stop_id",
                "to_stop_id",
                "transfer_type",
                "min_transfer_time",
            ),
            (
                (
                    dv_id,
                    t["from_stop_id"],
                    t["to_stop_id"],
                    int(t.get("transfer_type") or 0),
                    _int_or_none(t.get("min_transfer_time", "")),
                )
                for t in feed.iter_rows("transfers.txt")
                if t.get("from_stop_id") and t.get("to_stop_id")
            ),
        )

        # Modes served per stop, then roll up to parent stations.
        conn.execute(
            text(
                """
                UPDATE stop s SET modes = m.modes FROM (
                    SELECT st.stop_id, array_agg(DISTINCT r.mode ORDER BY r.mode) AS modes
                    FROM stop_time st
                    JOIN trip t ON t.dataset_version_id = st.dataset_version_id AND t.trip_id = st.trip_id
                    JOIN route r ON r.dataset_version_id = t.dataset_version_id AND r.route_id = t.route_id
                    WHERE st.dataset_version_id = :dv GROUP BY st.stop_id
                ) m WHERE s.dataset_version_id = :dv AND s.stop_id = m.stop_id
                """
            ),
            {"dv": dv_id},
        )
        conn.execute(
            text(
                """
                UPDATE stop p SET modes = c.modes FROM (
                    SELECT parent_station, array_agg(DISTINCT mode ORDER BY mode) AS modes
                    FROM stop, unnest(modes) AS mode
                    WHERE dataset_version_id = :dv AND parent_station IS NOT NULL GROUP BY parent_station
                ) c WHERE p.dataset_version_id = :dv AND p.stop_id = c.parent_station
                """
            ),
            {"dv": dv_id},
        )

        for cov in coverage:
            conn.execute(
                text(
                    "INSERT INTO source_coverage (dataset_version_id, source, snapshot_id, status, reason, "
                    "feed_start, feed_end, fetched_at, times_approximate) VALUES "
                    "(:dv, :source, :snap, :status, :reason, :fs, :fe, :fa, :approx)"
                ),
                {
                    "dv": dv_id,
                    "source": cov.source,
                    "snap": cov.snapshot_id,
                    "status": cov.status,
                    "reason": cov.reason,
                    "fs": cov.feed_start,
                    "fe": cov.feed_end,
                    "fa": cov.fetched_at,
                    "approx": cov.times_approximate,
                },
            )
            if cov.snapshot_id is not None and cov.status == "included":
                conn.execute(
                    text("UPDATE source_snapshot SET dataset_version_id = :dv WHERE id = :id"),
                    {"dv": dv_id, "id": cov.snapshot_id},
                )

        summary = {
            "agencies": n_agency,
            "stops": n_stops,
            "routes": n_routes,
            "trips": n_trips,
            "stop_times": n_stop_times,
            "service_dates": n_service_dates,
            "shapes": n_shapes,
            "transfers": n_transfers,
        }
        conn.execute(
            text("UPDATE dataset_version SET summary = CAST(:s AS jsonb) WHERE id = :dv"),
            {"s": json.dumps(summary), "dv": dv_id},
        )
    with engine.connect() as c:
        c.execution_options(isolation_level="AUTOCOMMIT")
        for table in ("stop", "route", "trip", "stop_time", "service_date"):
            c.execute(text(f"ANALYZE {table}"))
    log.info("staged", dataset_version_id=dv_id, label=label, **summary)
    return int(dv_id)
