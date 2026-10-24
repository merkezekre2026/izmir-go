"""Read queries over the active dataset. Pure SQL; no HTTP concerns."""

from __future__ import annotations

from collections.abc import Sequence
from dataclasses import dataclass
from datetime import date, datetime
from typing import Any

from sqlalchemy import Connection, RowMapping, text

from izmirgo.core.servicetime import service_days_for, to_datetime
from izmirgo.domain.search_text import fold

STOP_COLS = (
    "s.stop_id, s.name, s.code, s.lat, s.lon, s.modes, s.location_type, s.parent_station, s.source"
)
# Timetable stops and directory stops (known only from an operator's stop list) share one shape.
GTFS_STOP_COLS = STOP_COLS + ", true AS has_schedule, CAST('{}' AS varchar[]) AS lines"
DIR_STOP_COLS = (
    "d.stop_id, d.name, CAST(NULL AS varchar) AS code, d.lat, d.lon, "
    "CAST(ARRAY['bus'] AS varchar[]) AS modes, 0 AS location_type, "  # only ESHOT (bus) today
    "CAST(NULL AS varchar) AS parent_station, d.source, false AS has_schedule, d.lines"
)
ROUTE_COLS = (
    "r.route_id, r.line_key, r.short_name, r.long_name, r.mode, r.color, r.text_color, r.source, "
    "r.times_approximate"
)


@dataclass(frozen=True)
class ActiveDataset:
    id: int
    label: str
    published_at: datetime | None


def active_dataset(conn: Connection) -> ActiveDataset | None:
    row = conn.execute(
        text("SELECT id, label, published_at FROM dataset_version WHERE status = 'active'")
    ).first()
    return ActiveDataset(row.id, row.label, row.published_at) if row else None


def source_coverage(conn: Connection, dv: int) -> Sequence[RowMapping]:
    return (
        conn.execute(
            text(
                """
                SELECT sc.source, sc.status, sc.reason, sc.feed_start, sc.feed_end, sc.fetched_at,
                       sc.times_approximate,
                       (ss.validation -> 'stats' ->> 'calendar_dates')::int AS calendar_dates
                FROM source_coverage sc LEFT JOIN source_snapshot ss ON ss.id = sc.snapshot_id
                WHERE sc.dataset_version_id = :dv ORDER BY sc.source
                """
            ),
            {"dv": dv},
        )
        .mappings()
        .all()
    )


def latest_attempts(conn: Connection) -> dict[str, RowMapping]:
    rows = (
        conn.execute(
            text(
                """
                SELECT DISTINCT ON (source) source, fetched_at, status, error
                FROM source_snapshot ORDER BY source, fetched_at DESC
                """
            )
        )
        .mappings()
        .all()
    )
    return {r["source"]: r for r in rows}


def last_run(conn: Connection) -> RowMapping | None:
    return (
        conn.execute(
            text(
                "SELECT started_at, finished_at, status FROM ingestion_run ORDER BY id DESC LIMIT 1"
            )
        )
        .mappings()
        .first()
    )


def directory_sources(conn: Connection, dv: int) -> list[str]:
    """Sources whose directory stops should be exposed: those without timetable coverage."""
    return list(
        conn.execute(
            text(
                "SELECT DISTINCT source FROM directory_stop WHERE source NOT IN ("
                "SELECT source FROM source_coverage WHERE dataset_version_id = :dv AND status = 'included')"
            ),
            {"dv": dv},
        ).scalars()
    )


def search_stops(
    conn: Connection,
    dv: int,
    *,
    q: str | None,
    modes: Sequence[str] | None,
    bbox: tuple[float, float, float, float] | None,
    limit: int,
    offset: int,
) -> Sequence[RowMapping]:
    where = ["(s.parent_station IS NULL OR s.location_type = 1)"]
    params: dict[str, Any] = {
        "dv": dv,
        "limit": limit,
        "offset": offset,
        "dirs": directory_sources(conn, dv),
    }
    order = "s.name, s.stop_id"
    if q:
        key = fold(q)
        params.update(key=key, prefix=f"{key}%", contains=f"% {key}%", raw=q.strip())
        where.append(
            "(s.search_key LIKE :prefix OR s.search_key LIKE :contains "
            "OR s.search_key % :key OR s.raw_id = :raw OR s.code = :raw)"
        )
        order = (
            "(s.raw_id = :raw OR s.code = :raw) DESC, (s.search_key LIKE :prefix) DESC, "
            "(s.location_type = 1) DESC, similarity(s.search_key, :key) DESC, s.name, s.stop_id"
        )
    if modes:
        where.append("s.modes && CAST(:modes AS varchar[])")
        params["modes"] = list(modes)
    if bbox:
        where.append("s.geom && ST_MakeEnvelope(:x1, :y1, :x2, :y2, 4326)")
        params.update(x1=bbox[0], y1=bbox[1], x2=bbox[2], y2=bbox[3])
    union = (
        f"SELECT {GTFS_STOP_COLS}, s.search_key, s.raw_id, s.geom FROM stop s "
        "WHERE s.dataset_version_id = :dv "
        f"UNION ALL SELECT {DIR_STOP_COLS}, d.search_key, d.raw_id, d.geom FROM directory_stop d "
        "WHERE d.source = ANY(:dirs)"
    )
    sql = (
        f"SELECT * FROM ({union}) s WHERE {' AND '.join(where)} "
        f"ORDER BY {order} LIMIT :limit OFFSET :offset"
    )
    return conn.execute(text(sql), params).mappings().all()


def get_stop(conn: Connection, dv: int, stop_id: str) -> RowMapping | None:
    row = (
        conn.execute(
            text(
                f"SELECT {GTFS_STOP_COLS}, s.wheelchair_boarding FROM stop s "
                "WHERE s.dataset_version_id = :dv AND s.stop_id = :id"
            ),
            {"dv": dv, "id": stop_id},
        )
        .mappings()
        .first()
    )
    if row is not None:
        return row
    return (
        conn.execute(
            text(
                f"SELECT {DIR_STOP_COLS}, CAST(NULL AS smallint) AS wheelchair_boarding "
                "FROM directory_stop d WHERE d.stop_id = :id AND d.source = ANY(:dirs)"
            ),
            {"id": stop_id, "dirs": directory_sources(conn, dv)},
        )
        .mappings()
        .first()
    )


def stop_children(conn: Connection, dv: int, station_id: str) -> Sequence[RowMapping]:
    return (
        conn.execute(
            text(
                f"SELECT {GTFS_STOP_COLS} FROM stop s WHERE s.dataset_version_id = :dv "
                "AND s.parent_station = :id ORDER BY s.source, s.name"
            ),
            {"dv": dv, "id": station_id},
        )
        .mappings()
        .all()
    )


def routes_at_stops(conn: Connection, dv: int, stop_ids: Sequence[str]) -> Sequence[RowMapping]:
    return (
        conn.execute(
            text(
                f"""
                SELECT DISTINCT {ROUTE_COLS} FROM route r
                WHERE r.dataset_version_id = :dv AND r.route_id IN (
                    SELECT t.route_id FROM stop_time st JOIN trip t
                      ON t.dataset_version_id = st.dataset_version_id AND t.trip_id = st.trip_id
                    WHERE st.dataset_version_id = :dv AND st.stop_id = ANY(:ids)
                )
                ORDER BY r.mode, r.short_name NULLS LAST, r.long_name
                """
            ),
            {"dv": dv, "ids": list(stop_ids)},
        )
        .mappings()
        .all()
    )


def nearby_stops(
    conn: Connection,
    dv: int,
    *,
    lat: float,
    lon: float,
    radius_m: int,
    modes: Sequence[str] | None,
    limit: int,
) -> Sequence[RowMapping]:
    params: dict[str, Any] = {"dv": dv, "lat": lat, "lon": lon, "r": radius_m, "limit": limit}
    mode_filter = ""
    if modes:
        mode_filter = "AND s.modes && CAST(:modes AS varchar[])"
        params["modes"] = list(modes)

    def knn(select_cols: str, table_filter: str) -> str:
        # KNN on the GiST index per table, then exact geography distance.
        return f"""
            WITH p AS (SELECT ST_SetSRID(ST_MakePoint(:lon, :lat), 4326) AS g),
            candidates AS (
                SELECT * FROM (SELECT {select_cols}, geom FROM {table_filter}) s, p
                WHERE true {mode_filter}
                ORDER BY s.geom <-> p.g LIMIT 200
            )
            SELECT c.*, round(ST_Distance(c.geom::geography, c.g::geography))::int AS distance_m
            FROM candidates c
            WHERE ST_DWithin(c.geom::geography, c.g::geography, :r)
            ORDER BY distance_m, c.stop_id LIMIT :limit
        """

    rows = list(
        conn.execute(
            text(
                knn(
                    GTFS_STOP_COLS,
                    "stop s WHERE s.dataset_version_id = :dv AND s.location_type = 0 "
                    "AND cardinality(s.modes) > 0",
                )
            ),
            params,
        ).mappings()
    )
    dirs = directory_sources(conn, dv)
    if dirs:
        params["dirs"] = dirs
        rows += list(
            conn.execute(
                text(knn(DIR_STOP_COLS, "directory_stop d WHERE d.source = ANY(:dirs)")), params
            ).mappings()
        )
    rows.sort(key=lambda r: (r["distance_m"], r["stop_id"]))
    return rows[:limit]


def departures(
    conn: Connection,
    dv: int,
    *,
    stop_ids: Sequence[str],
    moment: datetime,
    limit: int,
    window_s: int,
    route_id: str | None = None,
) -> list[dict[str, Any]]:
    """Scheduled departures from `stop_ids` after `moment`, across service days D and D-1."""
    days = service_days_for(moment, lookback_days=1)
    rows: list[dict[str, Any]] = []
    route_filter = "AND t.route_id = :route" if route_id else ""
    for service_date, now_s in days:
        params: dict[str, Any] = {
            "dv": dv,
            "ids": list(stop_ids),
            "d": service_date,
            "from_s": now_s,
            "to_s": now_s + window_s,
            "limit": limit,
            "route": route_id,
        }
        result = conn.execute(
            text(
                f"""
                SELECT st.stop_id, st.trip_id, st.departure_s, t.headsign, t.direction_id,
                       t.wheelchair_accessible, {ROUTE_COLS}
                FROM stop_time st
                JOIN trip t ON t.dataset_version_id = st.dataset_version_id AND t.trip_id = st.trip_id
                JOIN service_date sd ON sd.dataset_version_id = t.dataset_version_id
                     AND sd.service_id = t.service_id AND sd.date = :d
                JOIN route r ON r.dataset_version_id = t.dataset_version_id AND r.route_id = t.route_id
                WHERE st.dataset_version_id = :dv AND st.stop_id = ANY(:ids)
                  AND st.departure_s >= :from_s AND st.departure_s < :to_s {route_filter}
                  -- no boarding at the final stop of a trip
                  AND EXISTS (
                      SELECT 1 FROM stop_time nx WHERE nx.dataset_version_id = st.dataset_version_id
                        AND nx.trip_id = st.trip_id AND nx.stop_sequence > st.stop_sequence
                  )
                ORDER BY st.departure_s LIMIT :limit
                """
            ),
            params,
        ).mappings()
        for r in result:
            item = dict(r)
            item["service_date"] = service_date
            item["scheduled_departure"] = to_datetime(service_date, r["departure_s"])
            rows.append(item)
    rows.sort(key=lambda x: (x["scheduled_departure"], x["route_id"], x["trip_id"]))
    return rows[:limit]


def list_routes(
    conn: Connection, dv: int, *, modes: Sequence[str] | None, q: str | None
) -> Sequence[RowMapping]:
    where = ["r.dataset_version_id = :dv"]
    params: dict[str, Any] = {"dv": dv}
    if modes:
        where.append("r.mode = ANY(:modes)")
        params["modes"] = list(modes)
    if q:
        params["key"] = f"%{fold(q)}%"
        where.append("r.search_key LIKE :key")
    sql = (
        f"SELECT {ROUTE_COLS} FROM route r WHERE {' AND '.join(where)} "
        "ORDER BY r.mode, length(r.short_name) NULLS LAST, r.short_name, r.long_name, r.route_id"
    )
    return conn.execute(text(sql), params).mappings().all()


def get_route(conn: Connection, dv: int, route_id: str) -> RowMapping | None:
    return (
        conn.execute(
            text(
                f"SELECT {ROUTE_COLS}, a.name AS agency_name FROM route r "
                "LEFT JOIN agency a ON a.dataset_version_id = r.dataset_version_id AND a.agency_id = r.agency_id "
                "WHERE r.dataset_version_id = :dv AND r.route_id = :id"
            ),
            {"dv": dv, "id": route_id},
        )
        .mappings()
        .first()
    )


def route_patterns(conn: Connection, dv: int, route_id: str) -> list[dict[str, Any]]:
    """Most common stop sequence per direction, with its shape if one exists."""
    patterns = (
        conn.execute(
            text(
                """
                WITH seqs AS (
                    SELECT t.trip_id, t.direction_id, t.headsign, t.shape_id,
                           string_agg(st.stop_id, '|' ORDER BY st.stop_sequence) AS seq
                    FROM trip t JOIN stop_time st
                      ON st.dataset_version_id = t.dataset_version_id AND st.trip_id = t.trip_id
                    WHERE t.dataset_version_id = :dv AND t.route_id = :id
                    GROUP BY t.trip_id, t.direction_id, t.headsign, t.shape_id
                ), ranked AS (
                    SELECT direction_id, seq, count(*) AS n, mode() WITHIN GROUP (ORDER BY headsign) AS headsign,
                           mode() WITHIN GROUP (ORDER BY shape_id) AS shape_id,
                           row_number() OVER (PARTITION BY direction_id ORDER BY count(*) DESC, seq) AS rk
                    FROM seqs GROUP BY direction_id, seq
                )
                SELECT r.direction_id, r.seq, r.n, r.headsign, ST_AsGeoJSON(sh.geom)::json AS shape
                FROM ranked r LEFT JOIN shape sh ON sh.dataset_version_id = :dv AND sh.shape_id = r.shape_id
                WHERE r.rk = 1 ORDER BY r.direction_id NULLS FIRST
                """
            ),
            {"dv": dv, "id": route_id},
        )
        .mappings()
        .all()
    )
    out: list[dict[str, Any]] = []
    for p in patterns:
        stop_ids = p["seq"].split("|")
        stops = {
            r["stop_id"]: r
            for r in conn.execute(
                text(
                    f"SELECT {GTFS_STOP_COLS} FROM stop s WHERE s.dataset_version_id = :dv AND s.stop_id = ANY(:ids)"
                ),
                {"dv": dv, "ids": stop_ids},
            ).mappings()
        }
        shape = p["shape"]
        out.append(
            {
                "direction_id": p["direction_id"],
                "headsign": p["headsign"],
                "trip_count": p["n"],
                "stops": [stops[s] for s in stop_ids if s in stops],
                "geometry": [tuple(c) for c in shape["coordinates"]] if shape else None,
            }
        )
    return out


def route_schedule(
    conn: Connection, dv: int, route_id: str, service_date: date, direction_id: int | None
) -> list[dict[str, Any]]:
    params: dict[str, Any] = {"dv": dv, "id": route_id, "d": service_date, "dir": direction_id}
    dir_filter = "AND t.direction_id = :dir" if direction_id is not None else ""
    rows = conn.execute(
        text(
            f"""
            SELECT t.trip_id, t.direction_id, t.headsign,
                   min(st.departure_s) AS first_s, max(coalesce(st.arrival_s, st.departure_s)) AS last_s
            FROM trip t
            JOIN service_date sd ON sd.dataset_version_id = t.dataset_version_id
                 AND sd.service_id = t.service_id AND sd.date = :d
            JOIN stop_time st ON st.dataset_version_id = t.dataset_version_id AND st.trip_id = t.trip_id
            WHERE t.dataset_version_id = :dv AND t.route_id = :id {dir_filter}
            GROUP BY t.trip_id, t.direction_id, t.headsign
            ORDER BY first_s, t.trip_id
            """
        ),
        params,
    ).mappings()
    return [
        {
            "trip_id": r["trip_id"],
            "direction_id": r["direction_id"],
            "headsign": r["headsign"],
            "first_departure": to_datetime(service_date, r["first_s"]),
            "last_arrival": to_datetime(service_date, r["last_s"]),
        }
        for r in rows
        if r["first_s"] is not None
    ]


def catalog(conn: Connection, dv: int) -> tuple[Sequence[RowMapping], Sequence[RowMapping]]:
    stops = (
        conn.execute(
            text(
                f"SELECT {GTFS_STOP_COLS} FROM stop s WHERE s.dataset_version_id = :dv "
                "AND (cardinality(s.modes) > 0) "
                f"UNION ALL SELECT {DIR_STOP_COLS} FROM directory_stop d WHERE d.source = ANY(:dirs) "
                "ORDER BY stop_id"
            ),
            {"dv": dv, "dirs": directory_sources(conn, dv)},
        )
        .mappings()
        .all()
    )
    routes = list_routes(conn, dv, modes=None, q=None)
    return stops, routes
