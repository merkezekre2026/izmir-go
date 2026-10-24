"""API tests over the SYNTHETIC fixture dataset loaded into PostGIS."""

from __future__ import annotations

from collections.abc import Iterator
from pathlib import Path

import httpx
import pytest
import respx
from fastapi.testclient import TestClient
from sqlalchemy import Engine

from izmirgo.api.app import create_app
from izmirgo.core.config import Settings
from izmirgo.ingestion.cli import fixture_acquirer, fixture_sources
from izmirgo.ingestion.merge import load_interchanges, load_stations
from izmirgo.ingestion.pipeline import run_pipeline
from tests.conftest import FIXTURE_TODAY, FIXTURES, IZMIR_BBOX

pytestmark = pytest.mark.db
OPENAPI = "https://openapi.test.invalid/api"


@pytest.fixture
def client(engine: Engine, database_url: str, tmp_path: Path) -> Iterator[TestClient]:
    res = run_pipeline(
        engine,
        fixture_sources(),
        acquire=fixture_acquirer(tmp_path / "raw"),
        today=FIXTURE_TODAY,
        data_dir=tmp_path,
        bbox=IZMIR_BBOX,
        interchanges=load_interchanges(FIXTURES / "data" / "interchanges.csv"),
        stations=load_stations(FIXTURES / "data" / "stations.csv"),
    )
    assert res.status == "published", res.error
    settings = Settings(
        env="test",
        database_url=database_url,
        izmir_openapi_url=OPENAPI,
        photon_url="",
        otp_url="",
    )
    with TestClient(create_app(settings)) as c:
        yield c


def test_status_lists_every_registered_source(client: TestClient) -> None:
    body = client.get("/api/v1/transit/status").json()
    by = {s["source"]: s for s in body["sources"]}
    assert by["metro"]["status"] == "included"
    assert by["eshot"]["status"] == "excluded"
    assert by["eshot"]["live_data"] is True
    assert by["izdeniz"]["status"] == "excluded"  # not part of the fixture run at all


def test_search_turkish_folding_and_station_first(client: TestClient) -> None:
    body = client.get("/api/v1/stops", params={"q": "HALKAPINAR"}).json()
    ids = [s["id"] for s in body["items"]]
    assert ids[0] == "stn:fx-halkapinar"  # station first; its children are folded into it
    assert "metro:FXM2" not in ids
    codes = {n["code"] for n in body["meta"]["notices"]}
    assert {"SOURCE_EXCLUDED", "NO_HOLIDAY_CALENDAR"} <= codes


def test_pagination_cursor(client: TestClient) -> None:
    page1 = client.get("/api/v1/stops", params={"limit": 2}).json()
    assert len(page1["items"]) == 2
    assert page1["next_cursor"] == "2"
    page2 = client.get("/api/v1/stops", params={"limit": 2, "cursor": page1["next_cursor"]}).json()
    assert {s["id"] for s in page1["items"]}.isdisjoint({s["id"] for s in page2["items"]})


def test_station_detail(client: TestClient) -> None:
    stop = client.get("/api/v1/stops/stn:fx-halkapinar").json()["stop"]
    assert stop["kind"] == "station"
    assert {c["id"] for c in stop["children"]} == {"metro:FXM2", "tram:FXT1"}
    assert {r["mode"] for r in stop["routes"]} == {"metro", "tram"}
    assert stop["live_supported"] is False


def test_unknown_stop_is_problem_json(client: TestClient) -> None:
    res = client.get("/api/v1/stops/metro:NOPE")
    assert res.status_code == 404
    assert res.json()["code"] == "NOT_FOUND"


def test_departures_cross_midnight(client: TestClient) -> None:
    # Wednesday 2026-10-28 00:05: Tuesday's 24:10 and 24:20 trips still run.
    body = client.get(
        "/api/v1/stops/metro:FXM1/departures",
        params={"at": "2026-10-28T00:05:00+03:00", "limit": 3},
    ).json()
    items = body["items"]
    assert items, body
    assert items[0]["service_date"] == "2026-10-27"
    assert items[0]["scheduled_departure"].startswith("2026-10-28T00:10:00")
    assert all(i["basis"] == "scheduled" for i in items)


def test_departures_respect_calendar_exception(client: TestClient) -> None:
    # 2026-10-29 removes weekday service and adds weekend service (every 20 min from 07:00).
    items = client.get(
        "/api/v1/stops/metro:FXM1/departures",
        params={"at": "2026-10-29T06:00:00+03:00", "limit": 2},
    ).json()["items"]
    assert items[0]["scheduled_departure"].startswith("2026-10-29T07:00:00")


def test_no_boarding_at_terminal(client: TestClient) -> None:
    items = client.get(
        "/api/v1/stops/metro:FXM3/departures",
        params={"at": "2026-10-28T08:00:00+03:00", "limit": 20},
    ).json()["items"]
    assert items
    assert all(i["direction_id"] == 1 for i in items)  # only trips starting here


def test_departures_outside_validity_warn(client: TestClient) -> None:
    body = client.get(
        "/api/v1/stops/metro:FXM1/departures", params={"at": "2028-03-01T08:00:00+03:00"}
    ).json()
    assert body["items"] == []
    assert any(n["code"] == "SOURCE_OUT_OF_VALIDITY" for n in body["meta"]["notices"])


def test_nearby(client: TestClient) -> None:
    body = client.get(
        "/api/v1/nearby-stops", params={"lat": 38.4340, "lon": 27.1712, "radius_m": 400}
    ).json()
    ids = [s["id"] for s in body["items"]]
    assert ids[:2] == ["tram:FXT1", "metro:FXM2"]
    assert body["items"][0]["distance_m"] < body["items"][1]["distance_m"]


def test_nearby_outside_izmir(client: TestClient) -> None:
    res = client.get("/api/v1/nearby-stops", params={"lat": 41.0, "lon": 29.0})
    assert res.status_code == 422
    assert res.json()["code"] == "OUTSIDE_COVERAGE_AREA"


def test_validation_errors_are_problem_json(client: TestClient) -> None:
    res = client.get("/api/v1/nearby-stops", params={"lat": "x", "lon": 27})
    assert res.status_code == 422
    assert res.headers["content-type"].startswith("application/problem+json")
    assert res.json()["code"] == "VALIDATION_ERROR"
    bad_mode = client.get("/api/v1/stops", params={"modes": "spaceship"})
    assert bad_mode.json()["code"] == "VALIDATION_ERROR"


def test_route_detail_with_shape(client: TestClient) -> None:
    route = client.get("/api/v1/routes/tram:FXK").json()["route"]
    assert route["mode"] == "tram"
    assert {p["geometry_basis"] for p in route["patterns"]} == {"shape"}
    assert len(route["patterns"]) == 2
    metro = client.get("/api/v1/routes/metro:FX1").json()["route"]
    assert {p["geometry_basis"] for p in metro["patterns"]} == {"stop_to_stop"}


def test_route_schedule(client: TestClient) -> None:
    body = client.get(
        "/api/v1/routes/metro:FX1/schedule", params={"date": "2026-10-28", "direction": 0}
    ).json()
    assert body["items"][0]["first_departure"].startswith("2026-10-28T06:00:00")
    assert body["items"][-1]["first_departure"].startswith("2026-10-29T00:20:00")


def test_catalog_etag(client: TestClient) -> None:
    res = client.get("/api/v1/catalog/snapshot")
    assert res.status_code == 200
    etag = res.headers["etag"]
    assert len(res.json()["stops"]) == 7
    cached = client.get("/api/v1/catalog/snapshot", headers={"if-none-match": etag})
    assert cached.status_code == 304


def test_live_approaching_buses(client: TestClient) -> None:
    payload = [
        {
            "KalanDurakSayisi": 3,
            "HattinYonu": 1,
            "KoorY": "27,12608",
            "BisikletAparatliMi": False,
            "KoorX": "38,416885",
            "EngelliMi": True,
            "HatNumarasi": 32,
            "HatAdi": "ÇİMENTEPE - KONAK",
            "OtobusId": 10060,
        },
        {
            "KalanDurakSayisi": 1,
            "HattinYonu": 0,
            "KoorY": "27,1",
            "KoorX": "38,4",
            "HatNumarasi": 5,
            "HatAdi": "NARLIDERE",
            "OtobusId": 2,
        },
    ]
    with respx.mock(assert_all_called=True) as mock:
        mock.get(f"{OPENAPI}/iztek/duragayaklasanotobusler/10005").mock(
            return_value=httpx.Response(200, json=payload)
        )
        body = client.get("/api/v1/stops/eshot:10005/approaching-vehicles").json()
    assert body["supported"] is True
    assert body["basis"] == "live"
    assert [v["remaining_stops"] for v in body["items"]] == [1, 3]
    assert body["items"][1]["lat"] == pytest.approx(38.416885)
    assert body["items"][1]["lon"] == pytest.approx(27.12608)


def test_live_upstream_down(client: TestClient) -> None:
    with respx.mock() as mock:
        mock.get(f"{OPENAPI}/iztek/duragayaklasanotobusler/10006").mock(
            return_value=httpx.Response(502)
        )
        res = client.get("/api/v1/stops/eshot:10006/approaching-vehicles")
    assert res.status_code == 503
    assert res.json()["code"] == "UPSTREAM_UNAVAILABLE"


def test_live_not_supported_for_metro(client: TestClient) -> None:
    body = client.get("/api/v1/stops/metro:FXM1/approaching-vehicles").json()
    assert body["supported"] is False
    assert body["notice"]["code"] == "LIVE_UNAVAILABLE"


def test_places_search_without_geocoder(client: TestClient) -> None:
    body = client.get("/api/v1/places/search", params={"q": "alsancak"}).json()
    assert [p["id"] for p in body["items"]] == ["tram:FXT3"]
    assert body["items"][0]["provider"] == "catalog"


def test_attributions(client: TestClient) -> None:
    items = client.get("/api/v1/meta/attributions").json()["items"]
    assert {i["licence"] for i in items} == {"CC-BY-4.0", "ODbL-1.0"}


def test_directory_stops_fill_in_when_bus_timetable_is_excluded(
    client: TestClient, engine: Engine
) -> None:
    from sqlalchemy import text

    with engine.begin() as conn:
        conn.execute(
            text(
                "INSERT INTO directory_stop (stop_id, source, raw_id, name, search_key, lat, lon, geom, lines, fetched_at) "
                "VALUES ('eshot:50011', 'eshot', '50011', 'Fixture Otobüs Durağı', 'fixture otobus duragi', "
                "38.4340, 27.1712, ST_SetSRID(ST_MakePoint(27.1712, 38.4340), 4326), ARRAY['32','5'], now())"
            )
        )
    near = client.get("/api/v1/nearby-stops", params={"lat": 38.4340, "lon": 27.1712}).json()
    first = near["items"][0]
    assert first["id"] == "eshot:50011"
    assert first["has_schedule"] is False
    assert first["lines"] == ["32", "5"]
    assert next(s for s in near["items"] if s["id"] == "tram:FXT1")["has_schedule"] is True

    detail = client.get("/api/v1/stops/eshot:50011").json()["stop"]
    assert detail["live_supported"] is True
    assert detail["routes"] == []
    found = client.get("/api/v1/stops", params={"q": "otobus duragi"}).json()["items"]
    assert [s["id"] for s in found] == ["eshot:50011"]
    deps = client.get("/api/v1/stops/eshot:50011/departures").json()
    assert deps["items"] == []
    assert any(
        n["code"] == "SOURCE_EXCLUDED" and n["source"] == "eshot" for n in deps["meta"]["notices"]
    )
    snapshot = client.get("/api/v1/catalog/snapshot").json()
    assert any(s["id"] == "eshot:50011" and not s["has_schedule"] for s in snapshot["stops"])
