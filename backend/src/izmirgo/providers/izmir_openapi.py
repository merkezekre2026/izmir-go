"""Adapter for the İzmir Büyükşehir Belediyesi OpenAPI (https://openapi.izmir.bel.tr/api).

Access is anonymous (official web-service PDFs v1.0). Quirks verified on 2026-10-24:
- ESHOT coordinates come as *strings with decimal commas* ("38,416885"), although the PDF says
  double. `KoorX` is latitude and `KoorY` is longitude.
- 204 No Content means "nothing approaching".
- Responses carry no timestamp, so freshness is the time *we* fetched them.
- "Approaching" gives the number of stops remaining (`KalanDurakSayisi`), not minutes.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime
from typing import Any

import httpx

from izmirgo.core.logging import get_logger
from izmirgo.core.resilience import AsyncTTLCache, CircuitBreaker, CircuitOpen

log = get_logger("providers.izmir_openapi")


class UpstreamUnavailable(RuntimeError):
    pass


@dataclass(frozen=True)
class ApproachingBus:
    line_number: str
    line_name: str
    direction: int | None
    remaining_stops: int
    lat: float | None
    lon: float | None
    vehicle_id: str | None
    wheelchair_accessible: bool | None
    bike_rack: bool | None


@dataclass(frozen=True)
class LiveResult[T]:
    items: list[T]
    fetched_at: datetime


def parse_decimal(value: Any) -> float | None:
    """Parse '38,416885' or 38.416885 into a float; None if unusable."""
    if value is None:
        return None
    if isinstance(value, int | float):
        return float(value)
    try:
        return float(str(value).strip().replace(",", "."))
    except ValueError:
        return None


def _bool(value: Any) -> bool | None:
    return value if isinstance(value, bool) else None


def parse_approaching(payload: Any) -> list[ApproachingBus]:
    if not isinstance(payload, list):
        return []
    out: list[ApproachingBus] = []
    for item in payload:
        if not isinstance(item, dict):
            continue
        remaining = item.get("KalanDurakSayisi")
        line = item.get("HatNumarasi")
        if not isinstance(remaining, int) or line is None:
            continue
        lat, lon = parse_decimal(item.get("KoorX")), parse_decimal(item.get("KoorY"))
        if lat is not None and lon is not None and not (36 < lat < 40 and 25 < lon < 29):
            lat = lon = None  # drop implausible coordinates rather than show them
        direction = item.get("HattinYonu")
        vehicle = item.get("OtobusId")
        out.append(
            ApproachingBus(
                line_number=str(line),
                line_name=str(item.get("HatAdi") or ""),
                direction=direction if isinstance(direction, int) else None,
                remaining_stops=remaining,
                lat=lat,
                lon=lon,
                vehicle_id=str(vehicle) if vehicle is not None else None,
                wheelchair_accessible=_bool(item.get("EngelliMi")),
                bike_rack=_bool(item.get("BisikletAparatliMi")),
            )
        )
    out.sort(key=lambda b: (b.remaining_stops, b.line_number))
    return out


class IzmirOpenApi:
    def __init__(
        self,
        base_url: str,
        *,
        client: httpx.AsyncClient | None = None,
        connect_timeout_s: float = 3.0,
        read_timeout_s: float = 5.0,
        cache_ttl_s: float = 15.0,
        user_agent: str = "IzmirGo/0.1",
    ) -> None:
        self.base_url = base_url.rstrip("/")
        self._client = client or httpx.AsyncClient(
            timeout=httpx.Timeout(read_timeout_s, connect=connect_timeout_s),
            headers={"user-agent": user_agent, "accept": "application/json"},
        )
        self.breaker = CircuitBreaker("izmir_openapi", threshold=5, reset_after_s=30.0)
        self._approaching_cache: AsyncTTLCache[list[ApproachingBus]] = AsyncTTLCache(cache_ttl_s)

    async def aclose(self) -> None:
        await self._client.aclose()

    async def _get_json(self, path: str) -> Any:
        url = f"{self.base_url}{path}"

        async def do() -> Any:
            last_exc: Exception | None = None
            for attempt in range(2):  # one retry on transport errors only
                try:
                    res = await self._client.get(url)
                except httpx.TransportError as exc:
                    last_exc = exc
                    log.warning(
                        "upstream_transport_error", path=path, attempt=attempt, error=str(exc)
                    )
                    continue
                if res.status_code == 204:
                    return None
                if res.status_code >= 500:
                    raise UpstreamUnavailable(f"HTTP {res.status_code}")
                if res.status_code != 200:
                    raise UpstreamUnavailable(f"HTTP {res.status_code}")
                return res.json()
            raise UpstreamUnavailable(str(last_exc))

        try:
            return await self.breaker.call(do)
        except CircuitOpen as exc:
            raise UpstreamUnavailable("circuit open") from exc
        except ValueError as exc:  # invalid JSON
            raise UpstreamUnavailable("invalid JSON") from exc

    async def approaching_buses(self, eshot_stop_raw_id: str) -> LiveResult[ApproachingBus]:
        if not eshot_stop_raw_id.isdigit():
            return LiveResult([], datetime.now(UTC))

        async def load() -> list[ApproachingBus]:
            payload = await self._get_json(f"/iztek/duragayaklasanotobusler/{eshot_stop_raw_id}")
            return parse_approaching(payload)

        stored_at, items = await self._approaching_cache.get_or_load(eshot_stop_raw_id, load)
        # Convert the monotonic cache timestamp to wall-clock age.
        age = max(0.0, self._approaching_cache.now() - stored_at)
        fetched_at = datetime.fromtimestamp(datetime.now(UTC).timestamp() - age, UTC)
        return LiveResult(items, fetched_at)
