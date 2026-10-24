"""ESHOT stop directory from the official stops CSV (refreshed twice daily by the publisher).

Columns (verified 2026-10-24): DURAK_ID;DURAK_ADI;ENLEM;BOYLAM;DURAKTAN_GECEN_HATLAR
Line numbers are separated by "-".
"""

from __future__ import annotations

import csv
import io
import json
from datetime import UTC, datetime

import httpx
from sqlalchemy import Engine, text

from izmirgo.core.logging import get_logger
from izmirgo.domain.ids import nsid
from izmirgo.domain.search_text import fold

log = get_logger("ingestion.stop_directory")
MIN_EXPECTED_ROWS = 1000  # the real list has ~12k stops; fewer means a broken download


class DirectoryError(RuntimeError):
    pass


def parse_eshot_stops(
    body: str, bbox: tuple[float, float, float, float]
) -> list[dict[str, object]]:
    x1, y1, x2, y2 = bbox
    out: list[dict[str, object]] = []
    seen: set[str] = set()
    for row in csv.DictReader(io.StringIO(body.lstrip("﻿")), delimiter=";"):
        raw = (row.get("DURAK_ID") or "").strip()
        if not raw.isdigit() or raw in seen:
            continue
        try:
            lat = float((row.get("ENLEM") or "").replace(",", "."))
            lon = float((row.get("BOYLAM") or "").replace(",", "."))
        except ValueError:
            continue
        if not (x1 <= lon <= x2 and y1 <= lat <= y2):
            continue
        seen.add(raw)
        name = (row.get("DURAK_ADI") or "").strip()
        lines = [
            p.strip() for p in (row.get("DURAKTAN_GECEN_HATLAR") or "").split("-") if p.strip()
        ]
        out.append(
            {
                "stop_id": nsid("eshot", raw),
                "raw_id": raw,
                "name": name,
                "search_key": fold(name),
                "lat": lat,
                "lon": lon,
                "lines": lines,
            }
        )
    return out


def refresh_eshot_directory(
    engine: Engine,
    url: str,
    bbox: tuple[float, float, float, float],
    *,
    client: httpx.Client | None = None,
) -> int:
    """Replace the ESHOT directory atomically; keep the old one if the download looks wrong."""
    owns = client is None
    client = client or httpx.Client(timeout=60.0, follow_redirects=True)
    try:
        res = client.get(url)
        res.raise_for_status()
        rows = parse_eshot_stops(res.content.decode("utf-8", errors="replace"), bbox)
    finally:
        if owns:
            client.close()
    if len(rows) < MIN_EXPECTED_ROWS:
        raise DirectoryError(f"only {len(rows)} stops parsed; keeping previous directory")
    now = datetime.now(UTC)
    with engine.begin() as conn:
        conn.execute(text("DELETE FROM directory_stop WHERE source = 'eshot'"))
        conn.execute(
            text(
                "INSERT INTO directory_stop (stop_id, source, raw_id, name, search_key, lat, lon, geom, lines, fetched_at) "
                "SELECT x.stop_id, 'eshot', x.raw_id, x.name, x.search_key, x.lat, x.lon, "
                "ST_SetSRID(ST_MakePoint(x.lon, x.lat), 4326), x.lines, :now "
                "FROM jsonb_to_recordset(CAST(:rows AS jsonb)) AS x("
                "stop_id text, raw_id text, name text, search_key text, lat float8, lon float8, lines varchar[])"
            ),
            {"rows": json.dumps(rows, ensure_ascii=False), "now": now},
        )
    log.info("directory_refreshed", source="eshot", stops=len(rows))
    return len(rows)
