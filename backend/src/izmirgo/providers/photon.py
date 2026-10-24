"""Photon geocoder adapter (https://github.com/komoot/photon).

Production should point at a self-hosted instance; the public photon.komoot.io instance is
fair-use only, throttled, and offers no availability guarantee (checked 2026-10-24).
Nominatim's public instance is NOT used: its policy forbids autocomplete.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

import httpx

from izmirgo.core.resilience import AsyncTTLCache, CircuitBreaker, CircuitOpen


class GeocoderUnavailable(RuntimeError):
    pass


@dataclass(frozen=True)
class GeoPlace:
    id: str
    name: str
    subtitle: str | None
    lat: float
    lon: float
    kind: str  # address | poi


def _subtitle(p: dict[str, Any]) -> str | None:
    parts = []
    street = p.get("street")
    if street:
        parts.append(f"{street} {p.get('housenumber', '')}".strip())
    for key in ("district", "locality", "city"):
        v = p.get(key)
        if v and v not in parts:
            parts.append(v)
    return ", ".join(parts) or None


def parse_features(payload: Any) -> list[GeoPlace]:
    out: list[GeoPlace] = []
    for f in (payload or {}).get("features", []) if isinstance(payload, dict) else []:
        try:
            lon, lat = f["geometry"]["coordinates"][:2]
            p = f.get("properties", {})
        except (KeyError, TypeError, ValueError):
            continue
        name = p.get("name") or (f"{p.get('street', '')} {p.get('housenumber', '')}".strip())
        if not name:
            continue
        osm = f"{p.get('osm_type', '?')}{p.get('osm_id', '')}"
        kind = (
            "address"
            if p.get("osm_key") in ("place", "highway", "building") or "housenumber" in p
            else "poi"
        )
        out.append(GeoPlace(f"photon:{osm}", name, _subtitle(p), float(lat), float(lon), kind))
    return out


class Photon:
    def __init__(
        self,
        base_url: str,
        bbox: tuple[float, float, float, float],
        *,
        client: httpx.AsyncClient | None = None,
        user_agent: str = "IzmirGo/0.1",
    ) -> None:
        self.base_url = base_url.rstrip("/")
        self.bbox = bbox
        self._client = client or httpx.AsyncClient(
            timeout=httpx.Timeout(4.0, connect=2.0), headers={"user-agent": user_agent}
        )
        self.breaker = CircuitBreaker("photon", threshold=3, reset_after_s=60.0)
        self._cache: AsyncTTLCache[list[GeoPlace]] = AsyncTTLCache(ttl_s=86400, max_entries=5000)

    async def aclose(self) -> None:
        await self._client.aclose()

    async def _get(self, path: str, params: dict[str, Any]) -> list[GeoPlace]:
        async def do() -> list[GeoPlace]:
            res = await self._client.get(f"{self.base_url}{path}", params=params)
            if res.status_code != 200:
                raise GeocoderUnavailable(f"HTTP {res.status_code}")
            return parse_features(res.json())

        try:
            return await self.breaker.call(do)
        except (httpx.HTTPError, ValueError, CircuitOpen) as exc:
            raise GeocoderUnavailable(str(exc)) from exc

    async def search(
        self, q: str, *, lat: float | None, lon: float | None, limit: int
    ) -> list[GeoPlace]:
        params: dict[str, Any] = {
            "q": q,
            "limit": limit,
            "bbox": ",".join(str(v) for v in self.bbox),
        }
        if lat is not None and lon is not None:
            params.update(lat=round(lat, 3), lon=round(lon, 3))
        key = f"s|{q.lower()}|{params.get('lat')}|{params.get('lon')}|{limit}"
        _, places = await self._cache.get_or_load(key, lambda: self._get("/api", params))
        return places

    async def reverse(self, lat: float, lon: float) -> list[GeoPlace]:
        params = {"lat": round(lat, 5), "lon": round(lon, 5), "limit": 1}
        key = f"r|{params['lat']}|{params['lon']}"
        _, places = await self._cache.get_or_load(key, lambda: self._get("/reverse", params))
        return places
