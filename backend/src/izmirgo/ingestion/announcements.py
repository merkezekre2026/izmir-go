"""ESHOT line announcements (official CSV, refreshed twice a day by the publisher).

These are scheduled notices with a validity range (route changes, etc.). They are not GTFS-RT
service alerts and are shown as "Duyuru" with their source.
"""

from __future__ import annotations

import csv
import io
from datetime import UTC, datetime

import httpx
from sqlalchemy import Engine, text

from izmirgo.core.logging import get_logger
from izmirgo.core.servicetime import ISTANBUL

log = get_logger("ingestion.announcements")


def _parse_dt(value: str) -> datetime | None:
    value = (value or "").strip()
    if not value:
        return None
    for fmt in ("%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M", "%Y-%m-%d"):
        try:
            return datetime.strptime(value, fmt).replace(tzinfo=ISTANBUL)
        except ValueError:
            continue
    return None


def parse_announcements(body: str) -> list[dict[str, object]]:
    reader = csv.DictReader(io.StringIO(body.lstrip("﻿")), delimiter=";")
    out: list[dict[str, object]] = []
    for row in reader:
        title = (row.get("BASLIK") or "").strip()
        if not title:
            continue
        out.append(
            {
                "line": (row.get("HAT_NO") or "").strip() or None,
                "title": title,
                "starts_at": _parse_dt(row.get("BASLAMA_TARIHI", "")),
                "ends_at": _parse_dt(row.get("BITIS_TARIHI", "")),
            }
        )
    return out


def refresh_announcements(engine: Engine, url: str, *, client: httpx.Client | None = None) -> int:
    """Replace ESHOT announcements atomically. On failure the previous set stays."""
    owns = client is None
    client = client or httpx.Client(timeout=30.0, follow_redirects=True)
    try:
        res = client.get(url)
        res.raise_for_status()
        items = parse_announcements(res.content.decode("utf-8", errors="replace"))
    finally:
        if owns:
            client.close()
    now = datetime.now(UTC)
    with engine.begin() as conn:
        conn.execute(text("DELETE FROM announcement WHERE source = 'eshot'"))
        for a in items:
            conn.execute(
                text(
                    "INSERT INTO announcement (source, line_short_name, title, starts_at, ends_at, fetched_at) "
                    "VALUES ('eshot', :line, :title, :s, :e, :f)"
                ),
                {
                    "line": a["line"],
                    "title": a["title"],
                    "s": a["starts_at"],
                    "e": a["ends_at"],
                    "f": now,
                },
            )
    log.info("announcements_refreshed", count=len(items))
    return len(items)
