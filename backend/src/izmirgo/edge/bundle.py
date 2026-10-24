"""Build the static data bundle served by the Cloudflare Worker (edge/).

The free Cloudflare plan has no database for this workload, so the API is precomputed:
static JSON responses (same shapes as the FastAPI contract), per-stop departure tables,
nearby-stop tiles, a search index and a compact timetable for in-Worker journey planning.

Everything comes from the same validated, merged, namespaced GTFS the main backend uses.
"""

from __future__ import annotations

import json
import math
import re
import shutil
from collections import defaultdict
from collections.abc import Iterable, Sequence
from dataclasses import dataclass, field
from datetime import UTC, date, datetime
from pathlib import Path
from typing import Any

from izmirgo.core.servicetime import parse_gtfs_time
from izmirgo.domain.ids import split
from izmirgo.domain.modes import mode_for_route_type
from izmirgo.domain.search_text import fold
from izmirgo.ingestion.gtfs import GtfsFeed
from izmirgo.ingestion.merge import haversine_m
from izmirgo.ingestion.sources import GtfsSource
from izmirgo.ingestion.stage import expand_service_dates

SOURCE_LABELS = {
    "metro": "İzmir Metro",
    "tram": "Tram İzmir",
    "eshot": "ESHOT otobüs",
    "izban": "İZBAN",
    "izdeniz": "İZDENİZ vapur",
}
LIVE_SOURCES = {"eshot"}
TILE_DEG = 0.01  # ~1.1 km
WALK_SPEED_MPS = 1.33
DETOUR = 1.3  # straight line -> street distance estimate
MAX_COMPUTED_TRANSFER_M = 500
_SAFE = re.compile(r"[^A-Za-z0-9_-]")


def file_key(value: str) -> str:
    """Filesystem/URL-safe name for an id. Mirrored by edge/src/keys.ts."""
    return _SAFE.sub(lambda m: f"~{ord(m.group(0)):x}", value)


def tile_key(lat: float, lon: float) -> str:
    return f"{math.floor(lat / TILE_DEG)}_{math.floor(lon / TILE_DEG)}"


@dataclass
class Coverage:
    source: str
    operator: str
    mode: str
    included: bool
    reason: str
    valid_from: date | None = None
    valid_to: date | None = None
    fetched_at: datetime | None = None
    times_approximate: bool = False
    calendar_dates: int = 0


@dataclass
class BundleInput:
    merged_path: Path
    label: str
    coverage: list[Coverage]
    sources: dict[str, GtfsSource]
    directory_csv: str | None = None
    announcements_csv: str | None = None
    attribution: dict[str, dict[str, str]] = field(default_factory=dict)


def _write(path: Path, obj: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, separators=(",", ":")), "utf-8")


def build_bundle(inp: BundleInput, out: Path, *, now: datetime | None = None) -> dict[str, int]:
    now = now or datetime.now(UTC)
    if out.exists():
        shutil.rmtree(out)
    out.mkdir(parents=True)
    generated_at = now.isoformat()
    dataset = {"id": int(now.timestamp()), "label": inp.label, "published_at": generated_at}

    included = [c for c in inp.coverage if c.included]
    windows = [
        {
            "source": c.source,
            "valid_from": c.valid_from.isoformat() if c.valid_from else None,
            "valid_to": c.valid_to.isoformat() if c.valid_to else None,
        }
        for c in included
    ]
    notices: list[dict[str, Any]] = []
    for c in inp.coverage:
        if not c.included:
            reason = c.reason.lower()
            why = (
                "tarife geçerlilik süresi dolmuş"
                if "expired" in reason
                else "kaynağa ulaşılamadı"
                if "fetch failed" in reason
                else "veri doğrulamadan geçmedi"
                if "invalid" in reason
                else "kaynak şu anda kullanılamıyor"
            )
            label = SOURCE_LABELS.get(c.source, c.source)
            notices.append(
                {
                    "code": "SOURCE_EXCLUDED",
                    "source": c.source,
                    "message": f"{label} tarifeleri dahil değil: {why}.",
                }
            )
    if any(c.calendar_dates == 0 for c in included):
        notices.append(
            {
                "code": "NO_HOLIDAY_CALENDAR",
                "message": "Resmî tatillerde sefer saatleri farklı olabilir; operatörler tatil takvimi yayımlamıyor.",
            }
        )
    meta = {
        "dataset": dataset,
        "generated_at": generated_at,
        "sources": windows,
        "notices": notices,
    }
    _write(
        out / "manifest.json",
        {
            "dataset": dataset,
            "generated_at": generated_at,
            "sources": windows,
            "notices": notices,
            "approximate_sources": [c.source for c in included if c.times_approximate],
            "walk_speed_mps": WALK_SPEED_MPS,
            "detour": DETOUR,
        },
    )

    with GtfsFeed(inp.merged_path) as feed:
        stops = {s["stop_id"]: s for s in feed.iter_rows("stops.txt")}
        agencies = {a["agency_id"]: a for a in feed.iter_rows("agency.txt")}
        routes_raw = feed.rows("routes.txt")
        trips = {t["trip_id"]: t for t in feed.iter_rows("trips.txt")}
        st_by_trip: dict[str, list[tuple[int, str, int | None, int | None]]] = defaultdict(list)
        for st in feed.iter_rows("stop_times.txt"):
            arr = st.get("arrival_time") or ""
            dep = st.get("departure_time") or ""
            arr_s = parse_gtfs_time(arr) if arr else None
            dep_s = parse_gtfs_time(dep) if dep else arr_s
            st_by_trip[st["trip_id"]].append(
                (int(st["stop_sequence"]), st["stop_id"], arr_s, dep_s)
            )
        shapes: dict[str, list[tuple[int, float, float]]] = defaultdict(list)
        for p in feed.iter_rows("shapes.txt"):
            shapes[p["shape_id"]].append(
                (int(p["shape_pt_sequence"]), float(p["shape_pt_lon"]), float(p["shape_pt_lat"]))
            )
        transfers_raw = feed.rows("transfers.txt")
        service_dates = expand_service_dates(feed)

    for seq in st_by_trip.values():
        seq.sort()

    # ---- routes -----------------------------------------------------------------------------
    route_summary: dict[str, dict[str, Any]] = {}
    for r in routes_raw:
        source, _raw_id = split(r["route_id"])
        src = inp.sources.get(source)
        short = r.get("route_short_name") or None
        grouping = src.route_grouping if src else "by_route_id"
        route_summary[r["route_id"]] = {
            "id": r["route_id"],
            "line_key": f"{source}:line:{short}"
            if grouping == "by_short_name" and short
            else r["route_id"],
            "short_name": short,
            "long_name": r.get("route_long_name") or None,
            "mode": mode_for_route_type(int(r["route_type"])),
            "color": (r.get("route_color") or "").upper() or None,
            "text_color": (r.get("route_text_color") or "").upper() or None,
            "source": source,
            "times_approximate": bool(src and src.times_approximate),
            "_agency": agencies.get(r.get("agency_id", ""), {}).get("agency_name"),
        }

    def public_route(rid: str) -> dict[str, Any]:
        return {k: v for k, v in route_summary[rid].items() if not k.startswith("_")}

    mode_order = {"metro": 0, "tram": 1, "rail": 2, "ferry": 3, "bus": 4}
    sorted_routes = sorted(
        route_summary,
        key=lambda rid: (
            mode_order.get(route_summary[rid]["mode"], 9),
            len(route_summary[rid]["short_name"] or ""),
            route_summary[rid]["short_name"] or "",
            route_summary[rid]["long_name"] or "",
            rid,
        ),
    )

    # ---- stops: modes and serving routes ----------------------------------------------------
    stop_modes: dict[str, set[str]] = defaultdict(set)
    stop_routes: dict[str, set[str]] = defaultdict(set)
    for tid, seq in st_by_trip.items():
        rid = trips[tid]["route_id"]
        for _, sid, _, _ in seq:
            stop_modes[sid].add(route_summary[rid]["mode"])
            stop_routes[sid].add(rid)
    children: dict[str, list[str]] = defaultdict(list)
    for sid, s in stops.items():
        if s.get("parent_station"):
            children[s["parent_station"]].append(sid)
            stop_modes[s["parent_station"]] |= stop_modes[sid]

    def summary(sid: str, **extra: Any) -> dict[str, Any]:
        s = stops[sid]
        return {
            "id": sid,
            "name": s.get("stop_name", ""),
            "code": s.get("stop_code") or None,
            "lat": round(float(s["stop_lat"]), 6),
            "lon": round(float(s["stop_lon"]), 6),
            "modes": sorted(stop_modes[sid]),
            "kind": "station" if s.get("location_type") == "1" else "stop",
            "parent_station": s.get("parent_station") or None,
            "source": split(sid)[0],
            "has_schedule": True,
            "lines": [],
            **extra,
        }

    active_stops = [sid for sid in stops if stop_modes[sid]]

    # ---- directory stops (ESHOT stop list) when the source has no timetable -----------------
    excluded_sources = {c.source for c in inp.coverage if not c.included}
    directory: list[dict[str, Any]] = []
    if inp.directory_csv and "eshot" in excluded_sources:
        from izmirgo.ingestion.stop_directory import parse_eshot_stops

        for row in parse_eshot_stops(inp.directory_csv, (26.2, 37.8, 28.5, 39.4)):
            directory.append(
                {
                    "id": row["stop_id"],
                    "name": row["name"],
                    "code": None,
                    "lat": round(float(row["lat"]), 6),  # type: ignore[arg-type]
                    "lon": round(float(row["lon"]), 6),  # type: ignore[arg-type]
                    "modes": ["bus"],
                    "kind": "stop",
                    "parent_station": None,
                    "source": "eshot",
                    "has_schedule": False,
                    "lines": row["lines"],
                }
            )

    # ---- static JSON responses --------------------------------------------------------------
    api = out / "api"
    _write(api / "routes.json", {"items": [public_route(r) for r in sorted_routes], "meta": meta})

    # Stop details: timetable stops/stations get a file; directory stops are bucketed.
    for sid in active_stops:
        kids = children.get(sid, [])
        members = kids or [sid]
        rids = sorted({r for m in members for r in stop_routes[m]}, key=sorted_routes.index)
        sources = {split(m)[0] for m in [sid, *kids]}
        detail = summary(sid) | {
            "wheelchair_boarding": int(stops[sid]["wheelchair_boarding"])
            if stops[sid].get("wheelchair_boarding")
            else None,
            "children": [summary(k) for k in kids],
            "routes": [public_route(r) for r in rids],
            "live_supported": bool(sources & LIVE_SOURCES),
        }
        _write(api / "stops" / f"{file_key(sid)}.json", {"stop": detail, "meta": meta})
    buckets: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for ds in directory:
        buckets[str(int(split(ds["id"])[1]) // 100)].append(ds)
    for b, items in buckets.items():
        _write(out / "dir" / f"{b}.json", items)

    # Nearby tiles (stops only, not stations) and the search index.
    tiles: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for sid in active_stops:
        summ = summary(sid)
        if summ["kind"] == "stop":
            tiles[tile_key(summ["lat"], summ["lon"])].append(summ)
    for ds in directory:
        tiles[tile_key(ds["lat"], ds["lon"])].append(ds)
    for k, items in tiles.items():
        _write(out / "tiles" / f"{k}.json", items)
    search_lines = []
    for sid in active_stops:
        summ = summary(sid)
        if summ["parent_station"] is None or summ["kind"] == "station":
            search_lines.append(
                (sid, fold(summ["name"]), summ["kind"], summ["code"] or "", split(sid)[1])
            )
    for ds in directory:
        search_lines.append((ds["id"], fold(ds["name"]), "stop", "", split(ds["id"])[1]))
    (out / "search.tsv").write_text("\n".join("\t".join(x) for x in search_lines) + "\n", "utf-8")
    search_rows = {sid: summary(sid) for sid, *_ in search_lines if sid in stops}
    search_rows |= {ds["id"]: ds for ds in directory}
    # Summaries for search results, split in 64 buckets by a stable hash of the id.
    sbuckets: dict[int, dict[str, Any]] = defaultdict(dict)
    for sid, row in search_rows.items():
        sbuckets[_bucket(sid)][sid] = row
    for sb, sitems in sbuckets.items():
        _write(out / "summaries" / f"{sb}.json", sitems)

    # Catalog snapshot (offline copy for the app).
    _write(
        api / "catalog.json",
        {
            "dataset": dataset,
            "generated_at": generated_at,
            "stops": [
                {
                    k: summary(sid)[k]
                    for k in (
                        "id",
                        "name",
                        "lat",
                        "lon",
                        "modes",
                        "kind",
                        "parent_station",
                        "has_schedule",
                        "lines",
                    )
                }
                for sid in sorted(active_stops)
            ]
            + [
                {
                    k: ds[k]
                    for k in (
                        "id",
                        "name",
                        "lat",
                        "lon",
                        "modes",
                        "kind",
                        "parent_station",
                        "has_schedule",
                        "lines",
                    )
                }
                for ds in directory
            ],
            "routes": [public_route(r) for r in sorted_routes],
            "sources": windows,
        },
    )

    # ---- patterns per route (route detail) and per-route trip lists (schedule) ---------------
    trips_by_route: dict[str, list[str]] = defaultdict(list)
    for tid, t in trips.items():
        if tid in st_by_trip:
            trips_by_route[t["route_id"]].append(tid)
    for rid in sorted_routes:
        by_seq: dict[tuple[Any, tuple[str, ...]], list[str]] = defaultdict(list)
        for tid in trips_by_route[rid]:
            dir_ = trips[tid].get("direction_id") or None
            by_seq[(dir_, tuple(s for _, s, _, _ in st_by_trip[tid]))].append(tid)
        best: dict[Any, tuple[tuple[str, ...], list[str]]] = {}
        for (dir_, stop_seq), tids in by_seq.items():
            if dir_ not in best or len(tids) > len(best[dir_][1]):
                best[dir_] = (stop_seq, tids)
        patterns = []
        for dir_, (stop_seq, tids) in sorted(
            best.items(), key=lambda kv: (kv[0] is not None, kv[0] or "")
        ):
            headsigns = [trips[t].get("trip_headsign") or "" for t in tids]
            shape_ids = [trips[t].get("shape_id") or "" for t in tids]
            shape_id = max(set(shape_ids), key=shape_ids.count)
            pts = sorted(shapes.get(shape_id, []))
            patterns.append(
                {
                    "direction_id": int(dir_) if dir_ not in (None, "") else None,
                    "headsign": max(set(headsigns), key=headsigns.count) or None,
                    "trip_count": len(tids),
                    "stops": [summary(s) for s in stop_seq if s in stops],
                    "geometry": [[lon, lat] for _, lon, lat in pts] if len(pts) >= 2 else None,
                    "geometry_basis": "shape" if len(pts) >= 2 else "stop_to_stop",
                }
            )
        r = route_summary[rid]
        _write(
            api / "routes" / f"{file_key(rid)}.json",
            {
                "route": public_route(rid) | {"agency_name": r["_agency"], "patterns": patterns},
                "meta": meta,
            },
        )
        rows = []
        for tid in trips_by_route[rid]:
            tseq = st_by_trip[tid]
            dep_times = [dt for *_rest, dt in tseq if dt is not None]
            arrs = [at if at is not None else dt for *_r, at, dt in tseq]
            arrs_known = [x for x in arrs if x is not None]
            if not dep_times:
                continue
            trip_row = trips[tid]
            rows.append(
                [
                    tid,
                    int(trip_row["direction_id"]) if trip_row.get("direction_id") else None,
                    trip_row.get("trip_headsign") or None,
                    trip_row["service_id"],
                    min(dep_times),
                    max(arrs_known),
                ]
            )
        rows.sort(key=lambda x: (x[4], x[0]))
        _write(out / "route_trips" / f"{file_key(rid)}.json", rows)

    # ---- departures per stop -----------------------------------------------------------------
    deps: dict[str, list[list[Any]]] = defaultdict(list)
    for tid, seq in st_by_trip.items():
        trip_row = trips[tid]
        for i, (_seq_no, sid, _arr, dep_at) in enumerate(seq):
            if dep_at is None or i == len(seq) - 1:
                continue  # no boarding at the last stop
            deps[sid].append(
                [
                    dep_at,
                    trip_row["route_id"],
                    tid,
                    trip_row.get("trip_headsign") or None,
                    int(trip_row["direction_id"]) if trip_row.get("direction_id") else None,
                    trip_row["service_id"],
                    int(trip_row["wheelchair_accessible"])
                    if trip_row.get("wheelchair_accessible")
                    else None,
                ]
            )
    for sid, rows in deps.items():
        rows.sort(key=lambda x: (x[0], x[1], x[2]))
        _write(out / "departures" / f"{file_key(sid)}.json", rows)

    services: dict[str, list[int]] = defaultdict(list)
    for sid, svc_date in sorted(service_dates):
        services[sid].append(int(svc_date.strftime("%Y%m%d")))
    _write(out / "services.json", services)
    _write(out / "route_summaries.json", {rid: public_route(rid) for rid in sorted_routes})

    # ---- journey-planning timetable ---------------------------------------------------------
    timetable = _timetable(active_stops, stops, trips, st_by_trip, transfers_raw, summary, children)
    _write(out / "timetable.json", timetable)

    # ---- status, attributions, alerts -------------------------------------------------------
    _write(
        api / "status.json",
        {
            "dataset": dataset,
            "sources": [
                {
                    "source": c.source,
                    "operator": c.operator,
                    "mode": {"rail": "rail"}.get(c.mode, c.mode),
                    "status": "included" if c.included else "excluded",
                    "reason": c.reason,
                    "valid_from": c.valid_from.isoformat() if c.valid_from else None,
                    "valid_to": c.valid_to.isoformat() if c.valid_to else None,
                    "fetched_at": c.fetched_at.isoformat() if c.fetched_at else None,
                    "last_attempt_at": c.fetched_at.isoformat() if c.fetched_at else generated_at,
                    "last_attempt_status": "valid" if c.included else c.reason[:40],
                    "times_approximate": c.times_approximate,
                    "has_calendar_exceptions": (c.calendar_dates > 0) if c.included else None,
                    "live_data": c.source in LIVE_SOURCES,
                }
                for c in inp.coverage
            ],
            "last_run_at": generated_at,
            "last_run_status": "published",
            "generated_at": generated_at,
        },
    )
    attr = inp.attribution
    _write(
        api / "attributions.json",
        {
            "items": [
                {
                    "id": "izmir_open_data",
                    "text": attr.get("izmir_open_data", {}).get("text_tr", ""),
                    "licence": attr.get("izmir_open_data", {}).get("licence", "CC-BY-4.0"),
                    "url": attr.get("izmir_open_data", {}).get("licence_url", ""),
                },
                {
                    "id": "openstreetmap",
                    "text": attr.get("openstreetmap", {}).get(
                        "text", "© OpenStreetMap contributors"
                    ),
                    "licence": attr.get("openstreetmap", {}).get("licence", "ODbL-1.0"),
                    "url": attr.get("openstreetmap", {}).get("licence_url", ""),
                },
            ]
        },
    )
    alerts = []
    if inp.announcements_csv:
        from izmirgo.ingestion.announcements import parse_announcements

        lines: dict[str, list[str]] = defaultdict(list)
        for rid in sorted_routes:
            r = route_summary[rid]
            if r["source"] == "eshot" and r["short_name"]:
                lines[r["short_name"]].append(rid)
        for i, ann in enumerate(parse_announcements(inp.announcements_csv)):
            ends = ann["ends_at"]
            if isinstance(ends, datetime) and ends < now:
                continue
            starts = ann["starts_at"]
            alerts.append(
                {
                    "id": f"eshot:{i + 1}",
                    "source": "eshot",
                    "line_short_name": ann["line"],
                    "route_ids": lines.get(str(ann["line"] or ""), []),
                    "title": ann["title"],
                    "starts_at": starts.isoformat() if isinstance(starts, datetime) else None,
                    "ends_at": ends.isoformat() if isinstance(ends, datetime) else None,
                    "fetched_at": generated_at,
                    "kind": "announcement",
                }
            )
    _write(api / "alerts.json", {"items": alerts, "generated_at": generated_at})

    files = sum(1 for _ in out.rglob("*") if _.is_file())
    return {
        "files": files,
        "stops": len(active_stops),
        "directory_stops": len(directory),
        "routes": len(route_summary),
        "trips": len(st_by_trip),
        "alerts": len(alerts),
    }


def _bucket(stop_id: str) -> int:
    """Stable 0..63 bucket for an id (FNV-1a). Mirrored by edge/src/keys.ts."""
    h = 0x811C9DC5
    for b in stop_id.encode("utf-8"):
        h ^= b
        h = (h * 0x01000193) & 0xFFFFFFFF
    return h % 64


def _timetable(
    active_stops: Sequence[str],
    stops: dict[str, dict[str, str]],
    trips: dict[str, dict[str, str]],
    st_by_trip: dict[str, list[tuple[int, str, int | None, int | None]]],
    transfers_raw: Iterable[dict[str, str]],
    summary: Any,
    children: dict[str, list[str]],
) -> dict[str, Any]:
    """Compact timetable for RAPTOR.

    Patterns group trips with the same stop sequence; trips inside a pattern are split further
    so that no trip overtakes another (RAPTOR requires FIFO order at every stop).
    """
    platform_stops = [s for s in active_stops if stops[s].get("location_type") != "1"]
    index = {sid: i for i, sid in enumerate(platform_stops)}
    stop_rows = [
        [
            sid,
            stops[sid].get("stop_name", ""),
            round(float(stops[sid]["stop_lat"]), 6),
            round(float(stops[sid]["stop_lon"]), 6),
            stops[sid].get("parent_station") or None,
        ]
        for sid in platform_stops
    ]
    services: list[str] = []
    service_index: dict[str, int] = {}

    groups: dict[tuple[str, tuple[str, ...]], list[str]] = defaultdict(list)
    for tid, seq in st_by_trip.items():
        if any(a is None and d is None for _, _, a, d in seq):
            continue  # interpolated times are not used for routing
        groups[(trips[tid]["route_id"], tuple(s for _, s, _, _ in seq))].append(tid)

    patterns: list[dict[str, Any]] = []
    for (rid, stop_seq), tids in groups.items():

        def times(tid: str) -> list[int]:
            out: list[int] = []
            for _, _, a, d in st_by_trip[tid]:
                arr = a if a is not None else d
                dep = d if d is not None else a
                out += [int(arr), int(dep)]  # type: ignore[arg-type]
            return out

        rows = sorted(((times(t), t) for t in tids), key=lambda x: x[0][1])
        lanes: list[list[tuple[list[int], str]]] = []
        for tt, tid in rows:
            for lane in lanes:
                prev = lane[-1][0]
                if all(tt[k] >= prev[k] for k in range(len(tt))):
                    lane.append((tt, tid))
                    break
            else:
                lanes.append([(tt, tid)])
        for lane in lanes:
            svc = []
            for _, tid in lane:
                s = trips[tid]["service_id"]
                if s not in service_index:
                    service_index[s] = len(services)
                    services.append(s)
                svc.append(service_index[s])
            patterns.append(
                {
                    "route": rid,
                    "stops": [index[x] for x in stop_seq],
                    "trips": [tid for _, tid in lane],
                    "headsigns": [trips[tid].get("trip_headsign") or None for _, tid in lane],
                    "services": svc,
                    "times": [x for tt, _ in lane for x in tt],
                }
            )

    # Footpaths: curated transfers (from transfers.txt) plus short computed walks.
    curated: dict[tuple[int, int], int] = {}
    for t in transfers_raw:
        a, b = t.get("from_stop_id", ""), t.get("to_stop_id", "")
        if a in index and b in index and t.get("min_transfer_time"):
            curated[(index[a], index[b])] = int(t["min_transfer_time"])
    footpaths: list[list[int]] = []
    coords = [
        (float(stops[sid]["stop_lat"]), float(stops[sid]["stop_lon"])) for sid in platform_stops
    ]
    for i, (la, lo) in enumerate(coords):
        for j, (lb, lob) in enumerate(coords):
            if i == j:
                continue
            dist = haversine_m(la, lo, lb, lob)
            if (i, j) in curated:
                footpaths.append([i, j, curated[(i, j)], round(dist * DETOUR), 1])
            elif dist <= MAX_COMPUTED_TRANSFER_M:
                footpaths.append(
                    [i, j, math.ceil(dist * DETOUR / WALK_SPEED_MPS) + 60, round(dist * DETOUR), 0]
                )
    return {"stops": stop_rows, "services": services, "patterns": patterns, "footpaths": footpaths}
