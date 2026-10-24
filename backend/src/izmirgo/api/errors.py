"""RFC 9457 problem+json errors with stable machine-readable codes."""

from __future__ import annotations

from enum import StrEnum
from typing import Any

from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from starlette.exceptions import HTTPException as StarletteHTTPException

PROBLEM_JSON = "application/problem+json"


class ErrorCode(StrEnum):
    VALIDATION_ERROR = "VALIDATION_ERROR"
    NOT_FOUND = "NOT_FOUND"
    OUTSIDE_COVERAGE_AREA = "OUTSIDE_COVERAGE_AREA"
    OUTSIDE_SERVICE_WINDOW = "OUTSIDE_SERVICE_WINDOW"
    NO_ACTIVE_DATASET = "NO_ACTIVE_DATASET"
    ROUTING_UNAVAILABLE = "ROUTING_UNAVAILABLE"
    UPSTREAM_UNAVAILABLE = "UPSTREAM_UNAVAILABLE"
    RATE_LIMITED = "RATE_LIMITED"
    INTERNAL = "INTERNAL"


_TITLES: dict[ErrorCode, str] = {
    ErrorCode.VALIDATION_ERROR: "Geçersiz istek",
    ErrorCode.NOT_FOUND: "Bulunamadı",
    ErrorCode.OUTSIDE_COVERAGE_AREA: "Konum hizmet alanı dışında",
    ErrorCode.OUTSIDE_SERVICE_WINDOW: "Bu tarih için tarife verisi yok",
    ErrorCode.NO_ACTIVE_DATASET: "Ulaşım verisi henüz yüklenmedi",
    ErrorCode.ROUTING_UNAVAILABLE: "Rota planlama şu anda kullanılamıyor",
    ErrorCode.UPSTREAM_UNAVAILABLE: "Kaynak veri servisine ulaşılamıyor",
    ErrorCode.RATE_LIMITED: "Çok fazla istek",
    ErrorCode.INTERNAL: "Beklenmeyen bir hata oluştu",
}


class ApiError(Exception):
    """Raise from routers or services to return a problem+json response."""

    def __init__(
        self,
        code: ErrorCode,
        status: int,
        detail: str | None = None,
        extra: dict[str, Any] | None = None,
    ) -> None:
        super().__init__(detail or code.value)
        self.code = code
        self.status = status
        self.detail = detail
        self.extra = extra or {}


def problem(
    code: ErrorCode,
    status: int,
    detail: str | None = None,
    request: Request | None = None,
    extra: dict[str, Any] | None = None,
) -> JSONResponse:
    body: dict[str, Any] = {
        "type": f"https://izmirgo.app/problems/{code.value.lower().replace('_', '-')}",
        "title": _TITLES[code],
        "status": status,
        "code": code.value,
    }
    if detail:
        body["detail"] = detail
    if request is not None:
        body["instance"] = request.url.path
        trace_id = getattr(request.state, "request_id", None)
        if trace_id:
            body["trace_id"] = trace_id
    if extra:
        body.update(extra)
    return JSONResponse(body, status_code=status, media_type=PROBLEM_JSON)


def install_error_handlers(app: FastAPI) -> None:
    @app.exception_handler(ApiError)
    async def _api_error(request: Request, exc: ApiError) -> JSONResponse:
        return problem(exc.code, exc.status, exc.detail, request, exc.extra)

    @app.exception_handler(RequestValidationError)
    async def _validation(request: Request, exc: RequestValidationError) -> JSONResponse:
        errors = [
            {"loc": [str(p) for p in e.get("loc", ())], "msg": e.get("msg", "")}
            for e in exc.errors()
        ]
        return problem(ErrorCode.VALIDATION_ERROR, 422, None, request, {"errors": errors})

    @app.exception_handler(StarletteHTTPException)
    async def _http(request: Request, exc: StarletteHTTPException) -> JSONResponse:
        if exc.status_code == 404:
            return problem(ErrorCode.NOT_FOUND, 404, None, request)
        if exc.status_code == 429:
            return problem(ErrorCode.RATE_LIMITED, 429, None, request)
        code = ErrorCode.VALIDATION_ERROR if exc.status_code < 500 else ErrorCode.INTERNAL
        return problem(code, exc.status_code, str(exc.detail), request)

    @app.exception_handler(Exception)
    async def _unhandled(request: Request, exc: Exception) -> JSONResponse:
        from izmirgo.core.logging import get_logger

        get_logger("api").exception("unhandled_error", path=request.url.path)
        return problem(ErrorCode.INTERNAL, 500, None, request)
