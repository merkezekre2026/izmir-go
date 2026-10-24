"""Journey planning via OpenTripPlanner (timetable-based; never real-time)."""

from __future__ import annotations

import hashlib
import re
from datetime import date, datetime
from typing import Annotated, Literal

from fastapi import APIRouter, Query, Request, Response
from sqlalchemy import Connection, text
from starlette.concurrency import run_in_threadpool

from izmirgo.api.deps import Conn, build_meta, check_in_coverage, parse_modes, route_summary
from izmirgo.api.errors import ApiError, ErrorCode
from izmirgo.api.schemas import (
    IntermediateStop,
    Journey,
    JourneyLeg,
    JourneyPlace,
    JourneysResponse,
    RouteSummary,
    RoutingProblem,
)
from izmirgo.core.servicetime import ISTANBUL
from izmirgo.domain import catalog
from izmirgo.domain.catalog import ActiveDataset
from izmirgo.domain.ids import is_nsid
from izmirgo.providers.otp import (
    Endpoint,
    OtpClient,
    PlaceOut,
    PlanOut,
    PlanRequest,
    RoutingUnavailable,
    StopCallOut,
)

router = APIRouter(tags=["journeys"])
COORD_RE = re.compile(r"^\s*(-?\d{1,2}(?:\.\d+)?)\s*,\s*(-?\d{1,3}(?:\.\d+)?)\s*$")
WALK_SPEED = {"slow": 0.9, "normal": 1.33, "fast": 1.7}


def _endpoint(request: Request, value: str, field: str) -> Endpoint:
    m = COORD_RE.match(value)
    if m:
        lat, lon = float(m.group(1)), float(m.group(2))
        check_in_coverage(request, lat, lon)
        return Endpoint(lat=lat, lon=lon)
    if is_nsid(value):
        return Endpoint(stop_id=value)
    raise ApiError(
        ErrorCode.VALIDATION_ERROR, 422, f"{field} must be 'lat,lon' or a stop id like metro:6"
    )


def _enrichment(
    conn: Connection, dv: int, plan: PlanOut
) -> tuple[dict[str, RouteSummary], set[str], set[tuple[str, str]]]:
    route_ids = {leg.route_id for it in plan.itineraries for leg in it.legs if leg.route_id}
    trip_ids = {leg.trip_id for it in plan.itineraries for leg in it.legs if leg.trip_id}
    routes: dict[str, RouteSummary] = {}
    if route_ids:
        rows = conn.execute(
            text(  # constant column list; values are bound parameters
                f"SELECT {catalog.ROUTE_COLS} FROM route r WHERE r.dataset_version_id = :dv "  # noqa: S608
                "AND r.route_id = ANY(:ids)"
            ),
            {"dv": dv, "ids": list(route_ids)},
        ).mappings()
        routes = {r["route_id"]: route_summary(r) for r in rows}
    shaped = (
        set(
            conn.execute(
                text(
                    "SELECT trip_id FROM trip WHERE dataset_version_id = :dv AND trip_id = ANY(:ids) "
                    "AND shape_id IS NOT NULL"
                ),
                {"dv": dv, "ids": list(trip_ids)},
            ).scalars()
        )
        if trip_ids
        else set()
    )
    curated = {
        (r[0], r[1])
        for r in conn.execute(
            text("SELECT from_stop_id, to_stop_id FROM transfer WHERE dataset_version_id = :dv"),
            {"dv": dv},
        )
    }
    return routes, shaped, curated


def _journey_id(legs: list[JourneyLeg]) -> str:
    key = "|".join(f"{leg.mode}:{leg.trip_id or ''}:{leg.start.isoformat()}" for leg in legs)
    return "j_" + hashlib.sha1(key.encode(), usedforsecurity=False).hexdigest()[:16]


@router.get("/journeys", response_model=JourneysResponse, summary="Plan journeys (timetable-based)")
async def journeys(
    request: Request,
    conn: Conn,
    response: Response,
    from_: Annotated[str, Query(alias="from", description="'lat,lon' or a stop id")],
    to: Annotated[str, Query(description="'lat,lon' or a stop id")],
    at: Annotated[datetime | None, Query(description="ISO 8601; defaults to now")] = None,
    time_type: Annotated[Literal["depart", "arrive"], Query()] = "depart",
    modes: Annotated[str | None, Query(description="Comma separated transit modes")] = None,
    max_transfers: Annotated[int | None, Query(ge=0, le=4)] = None,
    walk_speed: Annotated[Literal["slow", "normal", "fast"], Query()] = "normal",
    wheelchair: bool = False,
    limit: Annotated[int, Query(ge=1, le=5)] = 3,
) -> JourneysResponse:
    response.headers["cache-control"] = "no-store"
    origin = _endpoint(request, from_, "from")
    destination = _endpoint(request, to, "to")
    if at is None:
        when = datetime.now(ISTANBUL)
    elif at.tzinfo is None:
        when = at.replace(tzinfo=ISTANBUL)
    else:
        when = at.astimezone(ISTANBUL)
    mode_list = parse_modes(modes) or ["bus", "metro", "tram", "rail", "ferry"]

    ds: ActiveDataset | None = await run_in_threadpool(catalog.active_dataset, conn)
    if ds is None:
        raise ApiError(ErrorCode.NO_ACTIVE_DATASET, 503)
    otp_url = await run_in_threadpool(_otp_url, conn, ds.id, request.app.state.settings.otp_url)
    if not otp_url:
        raise ApiError(ErrorCode.ROUTING_UNAVAILABLE, 503, "Rota planlama yapılandırılmamış.")

    otp: OtpClient = request.app.state.otp
    try:
        plan = await otp.plan(
            otp_url,
            PlanRequest(
                origin=origin,
                destination=destination,
                when=when,
                arrive_by=time_type == "arrive",
                modes=tuple(mode_list),
                max_transfers=max_transfers,
                walk_speed_mps=WALK_SPEED[walk_speed],
                wheelchair=wheelchair,
                limit=limit,
            ),
        )
    except RoutingUnavailable as exc:
        raise ApiError(
            ErrorCode.ROUTING_UNAVAILABLE, 503, "Rota planlama şu anda kullanılamıyor."
        ) from exc

    routes, shaped, curated = await run_in_threadpool(_enrichment, conn, ds.id, plan)
    meta = await run_in_threadpool(lambda: build_meta(conn, ds, on_date=when.date()))

    items: list[Journey] = []
    for it in plan.itineraries:
        legs: list[JourneyLeg] = []
        for leg in it.legs:
            route = routes.get(leg.route_id or "")
            geometry = leg.geometry
            if leg.mode == "walk":
                basis = "street_network" if len(geometry) > 2 else "straight_line"
            else:
                basis = "shape" if leg.trip_id in shaped else "stop_to_stop"
            if len(geometry) < 2:
                # OTP gave no geometry (e.g. no street data): draw exactly what we know.
                points: list[PlaceOut | StopCallOut] = [
                    leg.origin,
                    *leg.intermediate_stops,
                    leg.destination,
                ]
                geometry = [(p.lon, p.lat) for p in points]
            transfer_source = None
            if leg.is_transfer:
                pair = (leg.origin.stop_id or "", leg.destination.stop_id or "")
                transfer_source = "curated" if pair in curated else "computed"
            legs.append(
                JourneyLeg(
                    mode=leg.mode,
                    start=leg.start,
                    end=leg.end,
                    duration_s=leg.duration_s,
                    distance_m=leg.distance_m,
                    origin=JourneyPlace(**vars(leg.origin)),
                    destination=JourneyPlace(**vars(leg.destination)),
                    route=route,
                    trip_id=leg.trip_id,
                    headsign=leg.headsign,
                    service_date=date.fromisoformat(leg.service_date) if leg.service_date else None,
                    intermediate_stops=[
                        IntermediateStop(**vars(s)) for s in leg.intermediate_stops
                    ],
                    geometry=geometry,
                    geometry_basis=basis,
                    is_transfer=leg.is_transfer,
                    transfer_source=transfer_source,
                    times_approximate=bool(route and route.times_approximate),
                )
            )
        items.append(
            Journey(
                id=_journey_id(legs),
                start=it.start,
                end=it.end,
                duration_s=it.duration_s,
                transfers=it.transfers,
                walk_distance_m=it.walk_distance_m,
                modes=list(dict.fromkeys(leg.mode for leg in legs)),
                legs=legs,
            )
        )
    return JourneysResponse(
        items=items,
        routing_errors=[RoutingProblem(code=c, message=m) for c, m in plan.routing_errors],
        meta=meta,
    )


def _otp_url(conn: Connection, dv: int, fallback: str) -> str | None:
    value = conn.execute(
        text("SELECT otp_url FROM dataset_version WHERE id = :id"), {"id": dv}
    ).scalar_one_or_none()
    return value or fallback or None
