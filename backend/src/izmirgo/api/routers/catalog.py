"""Compact offline catalog for the mobile app (ETag = dataset label)."""

from __future__ import annotations

from datetime import UTC, datetime

from fastapi import APIRouter, Request, Response

from izmirgo.api.deps import Conn, Dataset, build_meta, dataset_ref, route_summary
from izmirgo.api.schemas import CatalogSnapshot, CatalogStop
from izmirgo.domain import catalog

router = APIRouter(tags=["catalog"])


@router.get(
    "/catalog/snapshot",
    response_model=CatalogSnapshot,
    summary="All stops and routes of the active dataset, for offline use",
    responses={304: {"description": "Not modified (If-None-Match matched)"}},
)
def snapshot(
    request: Request, conn: Conn, ds: Dataset, response: Response
) -> CatalogSnapshot | Response:
    etag = f'"{ds.label}"'
    if request.headers.get("if-none-match") == etag:
        return Response(status_code=304, headers={"etag": etag})
    stops, routes = catalog.catalog(conn, ds.id)
    response.headers["etag"] = etag
    response.headers["cache-control"] = "public, max-age=3600"
    return CatalogSnapshot(
        dataset=dataset_ref(ds),
        generated_at=datetime.now(UTC),
        stops=[
            CatalogStop(
                id=s["stop_id"],
                name=s["name"],
                lat=round(s["lat"], 6),
                lon=round(s["lon"], 6),
                modes=list(s["modes"]),
                kind="station" if s["location_type"] == 1 else "stop",
                parent_station=s["parent_station"],
            )
            for s in stops
        ],
        routes=[route_summary(r) for r in routes],
        sources=build_meta(conn, ds).sources,
    )
