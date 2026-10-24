"""Shared fixtures for API integration tests (SYNTHETIC fixture dataset)."""

from __future__ import annotations

from collections.abc import Iterator
from pathlib import Path

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import Engine

from izmirgo.api.app import create_app
from izmirgo.core.config import Settings
from izmirgo.ingestion.cli import fixture_acquirer, fixture_sources
from izmirgo.ingestion.merge import load_interchanges, load_stations
from izmirgo.ingestion.pipeline import run_pipeline
from tests.conftest import FIXTURE_TODAY, FIXTURES, IZMIR_BBOX

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
