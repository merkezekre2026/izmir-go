"""Routes (lines), their patterns and daily schedules."""

from __future__ import annotations

from datetime import date, datetime
from typing import Annotated

from fastapi import APIRouter, Query, Response

from izmirgo.api.deps import Conn, Dataset, build_meta, parse_modes, route_summary, stop_summary
from izmirgo.api.errors import ApiError, ErrorCode
from izmirgo.api.schemas import (
    Pattern,
    RouteDetail,
    RouteList,
    RouteResponse,
    ScheduledTrip,
    ScheduleResponse,
)
from izmirgo.core.servicetime import ISTANBUL
from izmirgo.domain import catalog

router = APIRouter(tags=["routes"])


@router.get("/routes", response_model=RouteList, summary="List routes")
def list_routes(
    conn: Conn,
    ds: Dataset,
    response: Response,
    modes: str | None = None,
    q: Annotated[str | None, Query(min_length=1, max_length=80)] = None,
) -> RouteList:
    rows = catalog.list_routes(conn, ds.id, modes=parse_modes(modes), q=q)
    response.headers["cache-control"] = "public, max-age=3600"
    return RouteList(items=[route_summary(r) for r in rows], meta=build_meta(conn, ds))


@router.get(
    "/routes/{route_id}", response_model=RouteResponse, summary="Route detail with stop patterns"
)
def get_route(route_id: str, conn: Conn, ds: Dataset, response: Response) -> RouteResponse:
    row = catalog.get_route(conn, ds.id, route_id)
    if row is None:
        raise ApiError(ErrorCode.NOT_FOUND, 404, f"route {route_id} not found")
    patterns = [
        Pattern(
            direction_id=p["direction_id"],
            headsign=p["headsign"],
            trip_count=p["trip_count"],
            stops=[stop_summary(s) for s in p["stops"]],
            geometry=p["geometry"],
            geometry_basis="shape" if p["geometry"] else "stop_to_stop",
        )
        for p in catalog.route_patterns(conn, ds.id, route_id)
    ]
    detail = RouteDetail(
        **route_summary(row).model_dump(), agency_name=row["agency_name"], patterns=patterns
    )
    response.headers["cache-control"] = "public, max-age=3600"
    return RouteResponse(route=detail, meta=build_meta(conn, ds))


@router.get(
    "/routes/{route_id}/schedule",
    response_model=ScheduleResponse,
    summary="Trips on a service date",
)
def route_schedule(
    route_id: str,
    conn: Conn,
    ds: Dataset,
    response: Response,
    service_date: Annotated[date | None, Query(alias="date")] = None,
    direction: Annotated[int | None, Query(ge=0, le=1)] = None,
) -> ScheduleResponse:
    if catalog.get_route(conn, ds.id, route_id) is None:
        raise ApiError(ErrorCode.NOT_FOUND, 404, f"route {route_id} not found")
    d = service_date or datetime.now(ISTANBUL).date()
    items = [
        ScheduledTrip(**t) for t in catalog.route_schedule(conn, ds.id, route_id, d, direction)
    ]
    response.headers["cache-control"] = "public, max-age=600"
    return ScheduleResponse(
        route_id=route_id, service_date=d, items=items, meta=build_meta(conn, ds, on_date=d)
    )
