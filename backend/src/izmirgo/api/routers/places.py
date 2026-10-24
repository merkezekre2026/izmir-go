"""Place search: catalog stops first, then addresses/POIs from Photon."""

from __future__ import annotations

from typing import Annotated

from fastapi import APIRouter, Query, Request, Response
from starlette.concurrency import run_in_threadpool

from izmirgo.api.deps import Conn, check_in_coverage
from izmirgo.api.errors import ApiError, ErrorCode
from izmirgo.api.schemas import Place, PlacesResponse
from izmirgo.domain import catalog
from izmirgo.providers.photon import GeocoderUnavailable, Photon

router = APIRouter(tags=["places"])
OSM_ATTRIBUTION = "Adres verisi © OpenStreetMap katkıcıları (Photon)"


@router.get(
    "/places/search", response_model=PlacesResponse, summary="Search stops, places and addresses"
)
async def search(
    request: Request,
    conn: Conn,
    response: Response,
    q: Annotated[str, Query(min_length=2, max_length=80)],
    lat: Annotated[float | None, Query(ge=-90, le=90)] = None,
    lon: Annotated[float | None, Query(ge=-180, le=180)] = None,
    limit: Annotated[int, Query(ge=1, le=20)] = 10,
) -> PlacesResponse:
    ds = await run_in_threadpool(catalog.active_dataset, conn)
    items: list[Place] = []
    if ds is not None:
        rows = await run_in_threadpool(
            lambda: catalog.search_stops(
                conn, ds.id, q=q, modes=None, bbox=None, limit=limit, offset=0
            )
        )
        for r in rows:
            kind = "station" if r["location_type"] == 1 else "stop"
            items.append(
                Place(
                    id=r["stop_id"],
                    name=r["name"],
                    subtitle=", ".join(r["modes"]) or None,
                    lat=r["lat"],
                    lon=r["lon"],
                    kind=kind,
                    provider="catalog",
                )
            )
    attribution = None
    remaining = limit - len(items)
    photon: Photon | None = request.app.state.photon
    if photon is not None and remaining > 0:
        try:
            geo = await photon.search(q, lat=lat, lon=lon, limit=remaining)
            attribution = OSM_ATTRIBUTION
            items.extend(
                Place(
                    id=g.id,
                    name=g.name,
                    subtitle=g.subtitle,
                    lat=g.lat,
                    lon=g.lon,
                    kind=g.kind,
                    provider="photon",
                )
                for g in geo
            )
        except GeocoderUnavailable:
            pass  # stops still answer; addresses are best-effort
    response.headers["cache-control"] = "public, max-age=300"
    return PlacesResponse(items=items[:limit], attribution=attribution)


@router.get("/places/reverse", response_model=PlacesResponse, summary="Label for a map point")
async def reverse(
    request: Request,
    response: Response,
    lat: Annotated[float, Query(ge=-90, le=90)],
    lon: Annotated[float, Query(ge=-180, le=180)],
) -> PlacesResponse:
    check_in_coverage(request, lat, lon)
    photon: Photon | None = request.app.state.photon
    if photon is None:
        raise ApiError(ErrorCode.UPSTREAM_UNAVAILABLE, 503, "Adres servisi yapılandırılmamış.")
    try:
        geo = await photon.reverse(lat, lon)
    except GeocoderUnavailable as exc:
        raise ApiError(ErrorCode.UPSTREAM_UNAVAILABLE, 503, "Adres servisine ulaşılamadı.") from exc
    response.headers["cache-control"] = "public, max-age=86400"
    return PlacesResponse(
        items=[
            Place(
                id=g.id,
                name=g.name,
                subtitle=g.subtitle,
                lat=g.lat,
                lon=g.lon,
                kind=g.kind,
                provider="photon",
            )
            for g in geo
        ],
        attribution=OSM_ATTRIBUTION,
    )
