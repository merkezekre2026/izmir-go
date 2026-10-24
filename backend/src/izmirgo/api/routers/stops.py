"""Stops, nearby stops, scheduled departures and live approaching vehicles."""

from __future__ import annotations

from datetime import datetime
from typing import Annotated

from fastapi import APIRouter, Query, Request, Response
from starlette.concurrency import run_in_threadpool

from izmirgo.api.deps import (
    LIVE_SOURCES,
    Conn,
    Dataset,
    build_meta,
    check_in_coverage,
    parse_modes,
    route_summary,
    stop_summary,
    to_stop,
    unique,
)
from izmirgo.api.errors import ApiError, ErrorCode
from izmirgo.api.schemas import (
    ApproachingVehicle,
    Departure,
    DeparturesResponse,
    LiveResponse,
    NearbyResponse,
    NearbyStop,
    Notice,
    StopDetail,
    StopPage,
    StopResponse,
)
from izmirgo.core.servicetime import ISTANBUL
from izmirgo.domain import catalog
from izmirgo.domain.ids import is_nsid, split
from izmirgo.providers.izmir_openapi import IzmirOpenApi, UpstreamUnavailable

router = APIRouter(tags=["stops"])


@router.get("/stops", response_model=StopPage, summary="Search or browse stops and stations")
def list_stops(
    conn: Conn,
    ds: Dataset,
    response: Response,
    q: Annotated[
        str | None, Query(min_length=1, max_length=80, description="Name or stop code")
    ] = None,
    modes: Annotated[
        str | None, Query(description="Comma separated: bus,metro,tram,rail,ferry")
    ] = None,
    bbox: Annotated[
        str | None,
        Query(description="lon_min,lat_min,lon_max,lat_max", pattern=r"^[-\d.]+(,[-\d.]+){3}$"),
    ] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
    cursor: Annotated[str | None, Query(pattern=r"^\d{1,6}$")] = None,
) -> StopPage:
    box: tuple[float, float, float, float] | None = None
    if bbox:
        x1, y1, x2, y2 = (float(v) for v in bbox.split(","))
        if x2 <= x1 or y2 <= y1 or (x2 - x1) * (y2 - y1) > 1.0:
            raise ApiError(
                ErrorCode.VALIDATION_ERROR, 422, "bbox must be ordered and at most 1 square degree"
            )
        box = (x1, y1, x2, y2)
    offset = int(cursor or 0)
    rows = catalog.search_stops(
        conn, ds.id, q=q, modes=parse_modes(modes), bbox=box, limit=limit + 1, offset=offset
    )
    response.headers["cache-control"] = "public, max-age=300"
    return StopPage(
        items=[stop_summary(r) for r in rows[:limit]],
        next_cursor=str(offset + limit) if len(rows) > limit else None,
        meta=build_meta(conn, ds),
    )


@router.get("/stops/{stop_id}", response_model=StopResponse, summary="Stop or station detail")
def get_stop(stop_id: str, conn: Conn, ds: Dataset, response: Response) -> StopResponse:
    row = catalog.get_stop(conn, ds.id, stop_id)
    if row is None:
        raise ApiError(ErrorCode.NOT_FOUND, 404, f"stop {stop_id} not found")
    children = catalog.stop_children(conn, ds.id, stop_id) if row["location_type"] == 1 else []
    member_ids = [c["stop_id"] for c in children] or [stop_id]
    routes = catalog.routes_at_stops(conn, ds.id, member_ids)
    sources = {row["source"], *(c["source"] for c in children)}
    detail = StopDetail(
        **to_stop(row),
        children=[stop_summary(c) for c in children],
        routes=[route_summary(r) for r in routes],
        wheelchair_boarding=row["wheelchair_boarding"],
        live_supported=bool(sources & LIVE_SOURCES),
    )
    response.headers["cache-control"] = "public, max-age=3600"
    return StopResponse(stop=detail, meta=build_meta(conn, ds))


@router.get("/nearby-stops", response_model=NearbyResponse, summary="Stops near a point")
def nearby(
    request: Request,
    conn: Conn,
    ds: Dataset,
    response: Response,
    lat: Annotated[float, Query(ge=-90, le=90)],
    lon: Annotated[float, Query(ge=-180, le=180)],
    radius_m: Annotated[int, Query(ge=50, le=1500)] = 500,
    modes: str | None = None,
    limit: Annotated[int, Query(ge=1, le=30)] = 20,
) -> NearbyResponse:
    check_in_coverage(request, lat, lon)
    rows = catalog.nearby_stops(
        conn, ds.id, lat=lat, lon=lon, radius_m=radius_m, modes=parse_modes(modes), limit=limit
    )
    response.headers["cache-control"] = "public, max-age=300"
    return NearbyResponse(
        items=[NearbyStop(**to_stop(r, distance_m=r["distance_m"])) for r in rows],
        meta=build_meta(conn, ds),
    )


@router.get(
    "/stops/{stop_id}/departures",
    response_model=DeparturesResponse,
    summary="Scheduled departures (timetable data, never live)",
)
def stop_departures(
    stop_id: str,
    conn: Conn,
    ds: Dataset,
    response: Response,
    at: Annotated[datetime | None, Query(description="ISO 8601; defaults to now")] = None,
    route: Annotated[str | None, Query(description="Only this route id")] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
    window_min: Annotated[int, Query(ge=10, le=720)] = 180,
) -> DeparturesResponse:
    row = catalog.get_stop(conn, ds.id, stop_id)
    if row is None:
        raise ApiError(ErrorCode.NOT_FOUND, 404, f"stop {stop_id} not found")
    if at is None:
        moment = datetime.now(ISTANBUL)
    elif at.tzinfo is None:
        moment = at.replace(tzinfo=ISTANBUL)  # naive times are İzmir local time
    else:
        moment = at.astimezone(ISTANBUL)
    ids = [stop_id]
    if row["location_type"] == 1:
        ids = unique([c["stop_id"] for c in catalog.stop_children(conn, ds.id, stop_id)])
    rows = catalog.departures(
        conn,
        ds.id,
        stop_ids=ids,
        moment=moment,
        limit=limit,
        window_s=window_min * 60,
        route_id=route,
    )
    items = [
        Departure(
            stop_id=r["stop_id"],
            route=route_summary(r),
            trip_id=r["trip_id"],
            headsign=r["headsign"],
            direction_id=r["direction_id"],
            service_date=r["service_date"],
            scheduled_departure=r["scheduled_departure"],
            times_approximate=r["times_approximate"],
            wheelchair_accessible=r["wheelchair_accessible"],
        )
        for r in rows
    ]
    meta = build_meta(conn, ds, on_date=moment.date())
    if any(i.times_approximate for i in items):
        meta = meta.model_copy(
            update={
                "notices": [
                    *meta.notices,
                    Notice(code="TIMES_APPROXIMATE", message="Ara durak saatleri yaklaşıktır."),
                ]
            }
        )
    response.headers["cache-control"] = "public, max-age=60"
    return DeparturesResponse(stop_id=stop_id, from_time=moment, items=items, meta=meta)


@router.get(
    "/stops/{stop_id}/approaching-vehicles",
    response_model=LiveResponse,
    summary="Live approaching buses (ESHOT only). Remaining stops, not minutes.",
)
async def approaching(
    stop_id: str, request: Request, conn: Conn, response: Response
) -> LiveResponse:
    response.headers["cache-control"] = "no-store"
    if not is_nsid(stop_id):
        raise ApiError(
            ErrorCode.VALIDATION_ERROR, 422, "stop id must be namespaced, e.g. eshot:10005"
        )
    source, raw = split(stop_id)
    if source not in LIVE_SOURCES:
        return LiveResponse(
            stop_id=stop_id,
            supported=False,
            fetched_at=None,
            notice=Notice(
                code="LIVE_UNAVAILABLE", message="Bu durak için canlı veri yayımlanmıyor."
            ),
        )
    provider: IzmirOpenApi = request.app.state.izmir
    try:
        live = await provider.approaching_buses(raw)
    except UpstreamUnavailable as exc:
        raise ApiError(ErrorCode.UPSTREAM_UNAVAILABLE, 503, "Canlı veri alınamadı.") from exc

    ds = await run_in_threadpool(catalog.active_dataset, conn)
    by_line: dict[str, tuple[str, str | None]] = {}
    if ds is not None:
        for r in await run_in_threadpool(catalog.list_routes, conn, ds.id, modes=["bus"], q=None):
            if r["source"] == "eshot" and r["short_name"]:
                by_line.setdefault(r["short_name"], (r["route_id"], r["color"]))
    return LiveResponse(
        stop_id=stop_id,
        supported=True,
        fetched_at=live.fetched_at,
        source="ESHOT · İzmir Büyükşehir Belediyesi Açık Veri (CC BY 4.0)",
        items=[
            ApproachingVehicle(
                line_number=b.line_number,
                line_name=b.line_name,
                route_id=by_line.get(b.line_number, (None, None))[0],
                color=by_line.get(b.line_number, (None, None))[1],
                direction=b.direction,
                remaining_stops=b.remaining_stops,
                lat=b.lat,
                lon=b.lon,
                vehicle_id=b.vehicle_id,
                wheelchair_accessible=b.wheelchair_accessible,
                bike_rack=b.bike_rack,
            )
            for b in live.items
        ],
    )
