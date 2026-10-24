"""Golden scenarios against REAL İzmir feeds and OSM (nightly only; never in PR CI).

Needs network access to the operators, Docker, and IZMIRGO_OSM_PATH pointing at the clipped
İzmir extract (scripts/fetch-osm.sh). Run: uv run pytest -m "network and otp" -o addopts=""
"""

from __future__ import annotations

import os
import shutil
from collections.abc import Iterator
from datetime import date, timedelta
from pathlib import Path

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import Engine

from izmirgo.api.app import create_app
from izmirgo.core.config import Settings
from izmirgo.ingestion.fetch import fetch_source
from izmirgo.ingestion.merge import load_interchanges, load_stations
from izmirgo.ingestion.otp_build import OtpGraphBuilder, _docker
from izmirgo.ingestion.pipeline import run_pipeline
from izmirgo.ingestion.sources import load_registry

REPO = Path(__file__).resolve().parents[3]
OSM = Path(os.environ.get("IZMIRGO_OSM_PATH", REPO / "var/osm/izmir.osm.pbf"))

pytestmark = [
    pytest.mark.network,
    pytest.mark.otp,
    pytest.mark.db,
    pytest.mark.skipif(shutil.which("docker") is None, reason="needs Docker"),
    pytest.mark.skipif(not OSM.exists(), reason="needs the clipped İzmir OSM extract"),
]


def next_weekday(d: date) -> date:
    while d.weekday() >= 5:
        d += timedelta(days=1)
    return d


@pytest.fixture(scope="module")
def real_client(
    migrated_engine: Engine, database_url: str, tmp_path_factory: pytest.TempPathFactory
) -> Iterator[TestClient]:
    tmp = tmp_path_factory.mktemp("real")
    registry = load_registry(REPO / "data" / "sources.yaml")
    builder = OtpGraphBuilder(
        graphs_dir=tmp / "graphs",
        osm_path=OSM,
        slots=(("izmirgo-otp-real-a", 18281), ("izmirgo-otp-real-b", 18282)),
    )
    res = run_pipeline(
        migrated_engine,
        [s for s in registry.gtfs if s.id in ("metro", "tram")],
        acquire=lambda s: fetch_source(s, tmp / "raw"),
        today=date.today(),  # noqa: DTZ011 - feeds are judged against the real current date
        data_dir=tmp,
        bbox=(26.2, 37.8, 28.5, 39.4),
        interchanges=load_interchanges(REPO / "data" / "interchanges.csv"),
        stations=load_stations(REPO / "data" / "stations.csv"),
        graph_builder=builder,
        after_activate=builder.retire_others,
        force=True,
    )
    assert res.status == "published", res
    try:
        with TestClient(
            create_app(Settings(env="test", database_url=database_url, photon_url="", otp_url=""))
        ) as c:
            yield c
    finally:
        for name, _ in builder.slots:
            _docker("rm", "-f", name, timeout=60)


def test_r1_metro_to_tram_with_walking_transfer(real_client: TestClient) -> None:
    """Acceptance R1: Ege Üniversitesi (M1) → Alsancak Stadyumu area on a weekday at 08:00."""
    day = next_weekday(date.today() + timedelta(days=1))  # noqa: DTZ011
    body = real_client.get(
        "/api/v1/journeys",
        params={"from": "38.4600,27.2283", "to": "38.4381,27.1520", "at": f"{day}T08:00:00+03:00"},
    ).json()
    assert body["items"], body
    good = [
        j
        for j in body["items"]
        if any(leg["mode"] == "metro" and leg["route"]["short_name"] == "M1" for leg in j["legs"])
        and any(leg["mode"] == "tram" for leg in j["legs"])
    ]
    assert good, body
    for j in good:
        transfer = next(leg for leg in j["legs"] if leg["is_transfer"])
        assert transfer["distance_m"] <= 600
        assert j["basis"] == "scheduled"
    status = real_client.get("/api/v1/transit/status").json()
    by = {s["source"]: s for s in status["sources"]}
    assert by["metro"]["status"] == "included"
    assert by["tram"]["status"] == "included"
