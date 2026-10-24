"""FastAPI application factory."""

from __future__ import annotations

import time
import uuid
from collections.abc import Awaitable, Callable

from fastapi import FastAPI, Request, Response
from fastapi.middleware.gzip import GZipMiddleware

from izmirgo import __version__
from izmirgo.api.errors import install_error_handlers
from izmirgo.api.routers import health
from izmirgo.core.config import Settings, get_settings
from izmirgo.core.logging import configure_logging, get_logger, truncate_ip

API_PREFIX = "/api/v1"


def create_app(settings: Settings | None = None) -> FastAPI:
    settings = settings or get_settings()
    configure_logging(settings.log_level, settings.log_format)
    log = get_logger("api")

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
    )
    app.state.settings = settings
    app.add_middleware(GZipMiddleware, minimum_size=1024)

    @app.middleware("http")
    async def request_context(
        request: Request, call_next: Callable[[Request], Awaitable[Response]]
    ) -> Response:
        request_id = request.headers.get("x-request-id") or uuid.uuid4().hex[:16]
        request.state.request_id = request_id
        started = time.perf_counter()
        response = await call_next(request)
        response.headers["x-request-id"] = request_id
        log.info(
            "request",
            method=request.method,
            path=request.url.path,
            status=response.status_code,
            ms=round((time.perf_counter() - started) * 1000, 1),
            client=truncate_ip(request.client.host if request.client else None),
            request_id=request_id,
        )
        return response

    install_error_handlers(app)
    app.include_router(health.router, prefix=API_PREFIX)
    return app


def run() -> None:  # pragma: no cover - console entry point
    import uvicorn

    uvicorn.run("izmirgo.api.app:create_app", factory=True, host="0.0.0.0", port=8000)  # noqa: S104
