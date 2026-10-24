import asyncio

import pytest

from izmirgo.core.resilience import (
    AsyncTTLCache,
    CircuitBreaker,
    CircuitOpen,
    FixedWindowRateLimiter,
)
from izmirgo.ingestion.announcements import parse_announcements
from izmirgo.providers.izmir_openapi import parse_approaching, parse_decimal
from izmirgo.providers.photon import parse_features


def test_parse_decimal_comma() -> None:
    assert parse_decimal("38,416885") == pytest.approx(38.416885)
    assert parse_decimal(27.1) == 27.1
    assert parse_decimal("x") is None
    assert parse_decimal(None) is None


def test_parse_approaching_drops_bad_rows_and_coords() -> None:
    rows = parse_approaching(
        [
            {"KalanDurakSayisi": 2, "HatNumarasi": 32, "KoorX": "0,0", "KoorY": "0,0"},
            {"HatNumarasi": 5},
            "garbage",
        ]
    )
    assert len(rows) == 1
    assert rows[0].lat is None
    assert rows[0].lon is None
    assert parse_approaching(None) == []


def test_circuit_breaker_opens_and_half_opens() -> None:
    now = [0.0]
    cb = CircuitBreaker("t", threshold=2, reset_after_s=10, clock=lambda: now[0])

    async def boom() -> None:
        raise RuntimeError

    for _ in range(2):
        with pytest.raises(RuntimeError):
            asyncio.run(cb.call(boom))
    assert cb.state == "open"
    with pytest.raises(CircuitOpen):
        cb.before_call()
    now[0] = 11
    assert cb.state == "half_open"


def test_single_flight_cache() -> None:
    calls = 0

    async def main() -> list[int]:
        cache: AsyncTTLCache[int] = AsyncTTLCache(ttl_s=5)

        async def load() -> int:
            nonlocal calls
            calls += 1
            await asyncio.sleep(0.01)
            return 42

        results = await asyncio.gather(*(cache.get_or_load("k", load) for _ in range(10)))
        return [v for _, v in results]

    assert asyncio.run(main()) == [42] * 10
    assert calls == 1


def test_rate_limiter() -> None:
    now = [0.0]
    lim = FixedWindowRateLimiter(limit=2, window_s=60, clock=lambda: now[0])
    assert lim.allow("a")[0]
    assert lim.allow("a")[0]
    allowed, retry = lim.allow("a")
    assert not allowed
    assert retry == 60
    assert lim.allow("b")[0]
    now[0] = 61
    assert lim.allow("a")[0]


def test_parse_announcements() -> None:
    body = (
        "﻿HAT_NO;BASLIK;BASLAMA_TARIHI;BITIS_TARIHI\n"
        "32;32 NO.LU HAT GEÇİCİ GÜZERGAH;2026-09-24 00:00:00;2026-11-06 00:00:00\n"
        ";;;\n"
    )
    (a,) = parse_announcements(body)
    assert a["line"] == "32"
    assert a["starts_at"].isoformat() == "2026-09-24T00:00:00+03:00"  # type: ignore[union-attr]


def test_parse_photon_features() -> None:
    payload = {
        "features": [
            {
                "geometry": {"coordinates": [27.14, 38.43]},
                "properties": {"name": "Kordon", "osm_type": "W", "osm_id": 1, "city": "İzmir"},
            },
            {"geometry": {}, "properties": {}},
        ]
    }
    (p,) = parse_features(payload)
    assert p.id == "photon:W1"
    assert p.lat == 38.43
    assert p.subtitle == "İzmir"


def test_parse_eshot_stop_directory() -> None:
    from izmirgo.ingestion.stop_directory import parse_eshot_stops

    body = (
        "DURAK_ID;DURAK_ADI;ENLEM;BOYLAM;DURAKTAN_GECEN_HATLAR\n"
        "10005;Bahribaba;38.41526836260150;27.12763952722090;32\n"
        "10007;Bahribaba;38.415144105211;27.12772009127190;29-30\n"
        "10007;Duplicate;38.4;27.1;1\n"
        "x;Bad id;38.4;27.1;1\n"
        "99;Outside;41.0;29.0;1\n"
    )
    rows = parse_eshot_stops(body, (26.2, 37.8, 28.5, 39.4))
    assert [r["stop_id"] for r in rows] == ["eshot:10005", "eshot:10007"]
    assert rows[1]["lines"] == ["29", "30"]
    assert rows[0]["search_key"] == "bahribaba"
