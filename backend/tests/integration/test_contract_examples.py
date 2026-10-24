"""Example API responses shared with the Flutter client (contracts/examples/*.json).

- Normal runs: every committed example must still validate against the current response
  models, so examples can't silently go stale.
- IZMIRGO_WRITE_CONTRACT_EXAMPLES=1: regenerate the examples from the SYNTHETIC fixture
  dataset (plus a recorded OTP response and a mocked live response).

The Flutter test suite parses the same files with the app's models.
"""

from __future__ import annotations

import json
import os
from collections.abc import Iterator
from pathlib import Path

import httpx
import pytest
import respx
from fastapi.testclient import TestClient
from pydantic import BaseModel
from sqlalchemy import Engine, text

from izmirgo.api import schemas
from tests.conftest import FIXTURES

pytestmark = pytest.mark.db
EXAMPLES = Path(__file__).resolve().parents[3] / "contracts" / "examples"
WRITE = os.environ.get("IZMIRGO_WRITE_CONTRACT_EXAMPLES") == "1"
OPENAPI = "https://openapi.test.invalid/api"

CASES: dict[str, tuple[str, dict[str, str], type[BaseModel]]] = {
    "transit_status": ("/api/v1/transit/status", {}, schemas.TransitStatus),
    "stops_search": ("/api/v1/stops", {"q": "halkapinar"}, schemas.StopPage),
    "stop_detail_station": ("/api/v1/stops/stn:fx-halkapinar", {}, schemas.StopResponse),
    "nearby_stops": (
        "/api/v1/nearby-stops",
        {"lat": "38.434", "lon": "27.1712"},
        schemas.NearbyResponse,
    ),
    "departures": (
        "/api/v1/stops/stn:fx-halkapinar/departures",
        {"at": "2026-10-28T23:55:00+03:00", "limit": "6"},
        schemas.DeparturesResponse,
    ),
    "approaching_vehicles": (
        "/api/v1/stops/eshot:10005/approaching-vehicles",
        {},
        schemas.LiveResponse,
    ),
    "routes": ("/api/v1/routes", {}, schemas.RouteList),
    "route_detail": ("/api/v1/routes/tram:FXK", {}, schemas.RouteResponse),
    "route_schedule": (
        "/api/v1/routes/metro:FX1/schedule",
        {"date": "2026-10-28", "direction": "0"},
        schemas.ScheduleResponse,
    ),
    "catalog_snapshot": ("/api/v1/catalog/snapshot", {}, schemas.CatalogSnapshot),
    "places_search": ("/api/v1/places/search", {"q": "alsancak"}, schemas.PlacesResponse),
    "alerts": ("/api/v1/alerts", {}, schemas.AlertsResponse),
    "journeys": (
        "/api/v1/journeys",
        {"from": "metro:FXM1", "to": "tram:FXT3", "at": "2026-10-28T08:00:00+03:00"},
        schemas.JourneysResponse,
    ),
}


@pytest.fixture
def example_client(client: TestClient, engine: Engine) -> Iterator[TestClient]:
    with engine.begin() as conn:
        conn.execute(text("UPDATE dataset_version SET otp_url = 'http://otp.test.invalid'"))
        conn.execute(
            text(
                "INSERT INTO directory_stop (stop_id, source, raw_id, name, search_key, lat, lon, geom, lines, fetched_at) "
                "VALUES ('eshot:50011', 'eshot', '50011', 'Fixture Otobüs Durağı', 'fixture otobus duragi', "
                "38.4341, 27.1713, ST_SetSRID(ST_MakePoint(27.1713, 38.4341), 4326), ARRAY['32'], now())"
            )
        )
        conn.execute(
            text(
                "INSERT INTO announcement (source, line_short_name, title, starts_at, ends_at, fetched_at) "
                "VALUES ('eshot', '990', 'SYNTHETIC: Fixture hat güzergah değişikliği', now(), now() + interval '7 days', now())"
            )
        )
    recorded = json.loads((FIXTURES / "otp" / "plan_metro_tram.json").read_text())
    live = [
        {"KalanDurakSayisi": 2, "HattinYonu": 1, "KoorY": "27,1713", "KoorX": "38,4352",
         "BisikletAparatliMi": False, "EngelliMi": True, "HatNumarasi": 32,
         "HatAdi": "SYNTHETIC FIXTURE", "OtobusId": 1},
    ]  # fmt: skip
    with respx.mock(assert_all_called=False) as mock:
        mock.post("http://otp.test.invalid/otp/gtfs/v1").mock(
            return_value=httpx.Response(200, json=recorded)
        )
        mock.get(f"{OPENAPI}/iztek/duragayaklasanotobusler/10005").mock(
            return_value=httpx.Response(200, json=live)
        )
        yield client


@pytest.mark.skipif(not WRITE, reason="set IZMIRGO_WRITE_CONTRACT_EXAMPLES=1 to regenerate")
def test_write_examples(example_client: TestClient) -> None:
    EXAMPLES.mkdir(parents=True, exist_ok=True)
    for name, (path, params, model) in CASES.items():
        res = example_client.get(path, params=params)
        assert res.status_code == 200, (name, res.text)
        model.model_validate(res.json())
        (EXAMPLES / f"{name}.json").write_text(
            json.dumps(res.json(), ensure_ascii=False, indent=2) + "\n", "utf-8"
        )


@pytest.mark.parametrize("name", sorted(CASES))
def test_examples_match_current_schema(name: str) -> None:
    path = EXAMPLES / f"{name}.json"
    assert path.exists(), (
        f"missing example {path}; regenerate with IZMIRGO_WRITE_CONTRACT_EXAMPLES=1"
    )
    CASES[name][2].model_validate(json.loads(path.read_text("utf-8")))
