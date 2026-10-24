"""End-to-end: fixture feeds → merged GTFS → real OTP 2.10 graph (Docker) → /api/v1/journeys.

Deterministic: SYNTHETIC timetables plus a small real OSM clip around Halkapınar.
Run with: uv run pytest -m otp -o addopts=""
"""

from __future__ import annotations

import itertools
import shutil
from collections.abc import Iterator
from pathlib import Path

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import Engine

from izmirgo.api.app import create_app
from izmirgo.core.config import Settings
from izmirgo.ingestion.cli import fixture_acquirer, fixture_sources
from izmirgo.ingestion.merge import load_interchanges, load_stations
from izmirgo.ingestion.otp_build import OtpGraphBuilder
from izmirgo.ingestion.pipeline import run_pipeline
from tests.conftest import FIXTURE_TODAY, FIXTURES, IZMIR_BBOX

pytestmark = [
    pytest.mark.otp,
    pytest.mark.db,
    pytest.mark.skipif(shutil.which("docker") is None, reason="needs Docker"),
]


@pytest.fixture
def otp_client(engine: Engine, database_url: str, tmp_path: Path) -> Iterator[TestClient]:
    builder = OtpGraphBuilder(
        graphs_dir=tmp_path / "graphs",
        osm_path=FIXTURES / "osm" / "halkapinar-walk.osm.pbf",
        build_heap="-Xmx1g",
        serve_heap="-Xmx1g",
        slots=(("izmirgo-otp-test-a", 18181), ("izmirgo-otp-test-b", 18182)),
        ready_timeout_s=240,
    )
    res = run_pipeline(
        engine,
        fixture_sources(),
        acquire=fixture_acquirer(tmp_path / "raw"),
        today=FIXTURE_TODAY,
        data_dir=tmp_path,
        bbox=IZMIR_BBOX,
        interchanges=load_interchanges(FIXTURES / "data" / "interchanges.csv"),
        stations=load_stations(FIXTURES / "data" / "stations.csv"),
        graph_builder=builder,
        after_activate=builder.retire_others,
    )
    assert res.status == "published", res.error
    settings = Settings(env="test", database_url=database_url, photon_url="", otp_url="")
    try:
        with TestClient(create_app(settings)) as c:
            yield c
    finally:
        for name, _ in builder.slots:
            from izmirgo.ingestion.otp_build import _docker

            _docker("rm", "-f", name, timeout=60)


def test_metro_walk_tram_from_coordinates(otp_client: TestClient) -> None:
    # Near Fixture Stadyum (metro) → near Fixture Alsancak Gar (tram), Wednesday 08:00.
    res = otp_client.get(
        "/api/v1/journeys",
        params={
            "from": "38.4428,27.1812",
            "to": "38.4394,27.1478",
            "at": "2026-10-28T08:00:00+03:00",
            "limit": 3,
        },
    )
    assert res.status_code == 200, res.text
    body = res.json()
    transit_journeys = [j for j in body["items"] if set(j["modes"]) - {"walk"}]
    walk_only = [j for j in body["items"] if j["modes"] == ["walk"]]
    assert len(transit_journeys) >= 2, body
    # OTP may also offer walking the whole way (about 3.9 km here); it must be labelled as such.
    assert all(len(j["legs"]) == 1 for j in walk_only)
    for journey in transit_journeys:
        transit = [leg for leg in journey["legs"] if leg["mode"] != "walk"]
        assert [leg["mode"] for leg in transit] == ["metro", "tram"]
        transfer = next(leg for leg in journey["legs"] if leg["is_transfer"])
        # 279 m straight line between the platforms; the street path is a bit longer.
        assert transfer["distance_m"] <= 500
        assert transfer["origin"]["stop_id"] == "metro:FXM2"
        assert transfer["destination"]["stop_id"] == "tram:FXT1"
        assert transfer["transfer_source"] == "curated"
        times = [(leg["start"], leg["end"]) for leg in journey["legs"]]
        assert all(a[1] <= b[0] for a, b in itertools.pairwise(times))
        assert journey["basis"] == "scheduled"
        # access walks follow real streets from the OSM clip
        assert journey["legs"][0]["mode"] == "walk"
        assert journey["legs"][0]["geometry_basis"] == "street_network"
        # the tram has a shape; the metro fixture does not
        assert {leg["mode"]: leg["geometry_basis"] for leg in transit} == {
            "metro": "stop_to_stop",
            "tram": "shape",
        }


def test_outside_service_period(otp_client: TestClient) -> None:
    body = otp_client.get(
        "/api/v1/journeys",
        params={"from": "metro:FXM1", "to": "tram:FXT3", "at": "2031-01-01T08:00:00+03:00"},
    ).json()
    # Walking is still possible, but no transit leg may be offered outside the timetable window.
    assert all(j["modes"] == ["walk"] for j in body["items"])
    assert any(e["code"] == "OUTSIDE_SERVICE_PERIOD" for e in body["routing_errors"])
    assert any(n["code"] == "SOURCE_OUT_OF_VALIDITY" for n in body["meta"]["notices"])
