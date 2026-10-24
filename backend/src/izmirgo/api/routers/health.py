"""Liveness endpoint. Readiness (DB + OTP + active dataset) is added with the database layer."""

from __future__ import annotations

from typing import Literal

from fastapi import APIRouter, Response
from pydantic import BaseModel

from izmirgo import __version__

router = APIRouter(tags=["health"])


class Health(BaseModel):
    status: Literal["ok"]
    version: str


@router.get("/health", response_model=Health, summary="Liveness check")
def health(response: Response) -> Health:
    response.headers["cache-control"] = "no-store"
    return Health(status="ok", version=__version__)
