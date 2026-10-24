"""FastAPI application factory."""

from __future__ import annotations

import time
import uuid
from collections.abc import AsyncIterator, Awaitable, Callable
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request, Response
from fastapi.middleware.gzip import GZipMiddleware

from izmirgo import __version__
from izmirgo.api.errors import ErrorCode, install_error_handlers, problem
from izmirgo.api.routers import alerts, catalog, health, journeys, places, routes, status, stops
from izmirgo.core.config import Settings, get_settings
from izmirgo.core.logging import configure_logging, get_logger, truncate_ip
from izmirgo.core.resilience import FixedWindowRateLimiter
from izmirgo.db.session import get_engine
from izmirgo.ingestion.sources import load_registry
from izmirgo.providers.izmir_openapi import IzmirOpenApi
from izmirgo.providers.otp import OtpClient
from izmirgo.providers.photon import Photon

API_PREFIX = "/api/v1"
# Expensive paths (upstream or routing engine behind them) get a tighter per-IP limit.
RATE_LIMITED_PATHS = ("/journeys", "/approaching-vehicles", "/places/")


def create_app(settings: Settings | None = None) -> FastAPI:
    settings = settings or get_settings()
    configure_logging(settings.log_level, settings.log_format)
    log = get_logger("api")

    @asynccontextmanager
    async def lifespan(app: FastAPI) -> AsyncIterator[None]:
        app.state.izmir = IzmirOpenApi(
            settings.izmir_openapi_url,
            connect_timeout_s=settings.upstream_connect_timeout_s,
            read_timeout_s=settings.upstream_read_timeout_s,
            cache_ttl_s=settings.live_cache_ttl_s,
            user_agent=settings.user_agent,
        )
        app.state.otp = OtpClient()
        app.state.photon = (
            Photon(settings.photon_url, settings.coverage_bbox, user_agent=settings.user_agent)
            if settings.photon_url
            else None
        )
        try:
            yield
        finally:
            await app.state.izmir.aclose()
            await app.state.otp.aclose()
            if app.state.photon is not None:
                await app.state.photon.aclose()

    app = FastAPI(
        title="İzmir Go API",
        version=__version__,
        summary="Scheduled and live public transport information for İzmir.",
        description=(
            "Every departure and journey carries a `basis` (scheduled | live | cached) and "
            "source freshness. Transit data: İzmir Büyükşehir Belediyesi Open Data Portal, "
            "CC BY 4.0. Map/street data © OpenStreetMap contributors (ODbL)."
        ),
        openapi_url=f"{API_PREFIX}/openapi.json",
        docs_url=f"{API_PREFIX}/docs",
        redoc_url=None,
        lifespan=lifespan,
    )
    app.state.settings = settings
    app.state.engine = get_engine(settings.database_url)
    app.state.registry = load_registry(settings.sources_file)
    app.add_middleware(GZipMiddleware, minimum_size=1024)
    limiter = FixedWindowRateLimiter(limit=60, window_s=60.0)

    @app.middleware("http")
    async def request_context(
        request: Request, call_next: Callable[[Request], Awaitable[Response]]
    ) -> Response:
        request_id = request.headers.get("x-request-id") or uuid.uuid4().hex[:16]
        request.state.request_id = request_id
        started = time.perf_counter()
        client_ip = request.client.host if request.client else "unknown"
        path = request.url.path
        if any(p in path for p in RATE_LIMITED_PATHS):
            allowed, retry_after = limiter.allow(client_ip)
            if not allowed:
                res = problem(ErrorCode.RATE_LIMITED, 429, None, request)
                res.headers["retry-after"] = str(retry_after)
                return res
        response = await call_next(request)
        response.headers["x-request-id"] = request_id
        log.info(
            "request",
            method=request.method,
            path=path,
            status=response.status_code,
            ms=round((time.perf_counter() - started) * 1000, 1),
            client=truncate_ip(client_ip),
            request_id=request_id,
        )
        return response

    install_error_handlers(app)
    for module in (health, status, stops, routes, journeys, catalog, alerts, places):
        app.include_router(module.router, prefix=API_PREFIX)
    return app


def run() -> None:  # pragma: no cover - console entry point
    import uvicorn

    uvicorn.run("izmirgo.api.app:create_app", factory=True, host="0.0.0.0", port=8000)  # noqa: S104
