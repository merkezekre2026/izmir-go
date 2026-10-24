"""Transit data status, readiness and attributions."""

from __future__ import annotations

from datetime import UTC, datetime

import httpx
from fastapi import APIRouter, Request, Response

from izmirgo.api.deps import LIVE_SOURCES, Conn, dataset_ref
from izmirgo.api.schemas import (
    Attribution,
    AttributionsResponse,
    Ready,
    SourceStatus,
    TransitStatus,
)
from izmirgo.domain import catalog

router = APIRouter(tags=["status"])


@router.get("/transit/status", response_model=TransitStatus, summary="Data freshness per source")
def transit_status(request: Request, conn: Conn, response: Response) -> TransitStatus:
    ds = catalog.active_dataset(conn)
    registry = request.app.state.registry
    by_id = {s.id: s for s in registry.gtfs}
    attempts = catalog.latest_attempts(conn)
    coverage = {c["source"]: c for c in catalog.source_coverage(conn, ds.id)} if ds else {}
    sources: list[SourceStatus] = []
    for sid in [s.id for s in registry.gtfs]:
        c = coverage.get(sid)
        a = attempts.get(sid)
        src = by_id.get(sid)
        sources.append(
            SourceStatus(
                source=sid,
                operator=src.operator if src else None,
                mode=src.mode if src else None,
                status="included" if c and c["status"] == "included" else "excluded",
                reason=c["reason"] if c else "no published dataset includes this source",
                valid_from=c["feed_start"] if c else None,
                valid_to=c["feed_end"] if c else None,
                fetched_at=c["fetched_at"] if c else None,
                last_attempt_at=a["fetched_at"] if a else None,
                last_attempt_status=a["status"] if a else None,
                times_approximate=bool(src and src.times_approximate),
                has_calendar_exceptions=(c["calendar_dates"] or 0) > 0
                if c and c["status"] == "included"
                else None,
                live_data=sid in LIVE_SOURCES,
            )
        )
    run = catalog.last_run(conn)
    response.headers["cache-control"] = "public, max-age=60"
    return TransitStatus(
        dataset=dataset_ref(ds) if ds else None,
        sources=sources,
        last_run_at=run["started_at"] if run else None,
        last_run_status=run["status"] if run else None,
        generated_at=datetime.now(UTC),
    )


@router.get("/health/ready", response_model=Ready, summary="Readiness: database, dataset, routing")
async def ready(request: Request, response: Response) -> Ready:
    response.headers["cache-control"] = "no-store"
    db_ok = has_dataset = False
    try:
        from starlette.concurrency import run_in_threadpool

        def check() -> bool:
            with request.app.state.engine.connect() as conn:
                return catalog.active_dataset(conn) is not None

        has_dataset = await run_in_threadpool(check)
        db_ok = True
    except Exception:
        db_ok = False
    routing = "not_configured"
    otp_url = request.app.state.settings.otp_url
    if otp_url:
        try:
            async with httpx.AsyncClient(timeout=2.0) as client:
                res = await client.get(f"{otp_url.rstrip('/')}/otp/")
            routing = "ok" if res.status_code < 500 else "unavailable"
        except httpx.HTTPError:
            routing = "unavailable"
    ok = db_ok and has_dataset
    if not ok:
        response.status_code = 503
    return Ready(
        status="ready" if ok and routing == "ok" else "degraded",
        database=db_ok,
        active_dataset=has_dataset,
        routing=routing,
    )


@router.get(
    "/meta/attributions", response_model=AttributionsResponse, summary="Licences and attribution"
)
def attributions(request: Request, response: Response) -> AttributionsResponse:
    attr = request.app.state.registry.attribution
    items = [
        Attribution(
            id="izmir_open_data",
            text=attr["izmir_open_data"]["text_tr"],
            licence=attr["izmir_open_data"]["licence"],
            url=attr["izmir_open_data"]["licence_url"],
        ),
        Attribution(
            id="openstreetmap",
            text=attr["openstreetmap"]["text"],
            licence=attr["openstreetmap"]["licence"],
            url=attr["openstreetmap"]["licence_url"],
        ),
    ]
    response.headers["cache-control"] = "public, max-age=86400"
    return AttributionsResponse(items=items)
