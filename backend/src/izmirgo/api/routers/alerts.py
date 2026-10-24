"""Operator announcements (scheduled notices, not real-time alerts)."""

from __future__ import annotations

from datetime import UTC, datetime
from typing import Annotated

from fastapi import APIRouter, Query, Response
from sqlalchemy import text

from izmirgo.api.deps import Conn
from izmirgo.api.schemas import Alert, AlertsResponse
from izmirgo.domain import catalog

router = APIRouter(tags=["alerts"])


@router.get("/alerts", response_model=AlertsResponse, summary="Current operator announcements")
def alerts(
    conn: Conn,
    response: Response,
    route: Annotated[str | None, Query(description="Only announcements for this route id")] = None,
) -> AlertsResponse:
    ds = catalog.active_dataset(conn)
    lines: dict[str, list[str]] = {}
    if ds is not None:
        for r in catalog.list_routes(conn, ds.id, modes=["bus"], q=None):
            if r["source"] == "eshot" and r["short_name"]:
                lines.setdefault(r["short_name"], []).append(r["route_id"])
    rows = conn.execute(
        text(
            "SELECT id, source, line_short_name, title, starts_at, ends_at, fetched_at FROM announcement "
            "WHERE (ends_at IS NULL OR ends_at >= now()) ORDER BY starts_at DESC NULLS LAST, id"
        )
    ).mappings()
    items = []
    for r in rows:
        route_ids = lines.get(r["line_short_name"] or "", [])
        if route and route not in route_ids:
            continue
        items.append(
            Alert(
                id=f"{r['source']}:{r['id']}",
                source=r["source"],
                line_short_name=r["line_short_name"],
                route_ids=route_ids,
                title=r["title"],
                starts_at=r["starts_at"],
                ends_at=r["ends_at"],
                fetched_at=r["fetched_at"],
            )
        )
    response.headers["cache-control"] = "public, max-age=300"
    return AlertsResponse(items=items, generated_at=datetime.now(UTC))
