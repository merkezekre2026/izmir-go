from __future__ import annotations

import shutil
import zipfile
from datetime import date
from pathlib import Path

import pytest

from izmirgo.ingestion.sources import GtfsSource

FIXTURES = Path(__file__).parent / "fixtures"
SYNTHETIC = FIXTURES / "gtfs" / "synthetic"
IZMIR_BBOX = (26.2, 37.8, 28.5, 39.4)
# A fixed "today" inside the synthetic feeds' validity window (a Wednesday).
FIXTURE_TODAY = date(2026, 10, 28)


def zip_feed(name: str, dest_dir: Path) -> Path:
    src = SYNTHETIC / name
    out = dest_dir / f"{name}.zip"
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as zf:
        for p in sorted(src.glob("*.txt")):
            zf.write(p, p.name)
    return out


@pytest.fixture
def feed_zip(tmp_path: Path):  # type: ignore[no-untyped-def]
    def _make(name: str) -> Path:
        return zip_feed(name, tmp_path)

    return _make


@pytest.fixture
def fixture_sources() -> dict[str, GtfsSource]:
    return {
        "metro": GtfsSource(
            id="metro", operator="Fixture Metro", mode="metro", url="https://example.invalid/m.zip"
        ),
        "tram": GtfsSource(
            id="tram", operator="Fixture Tram", mode="tram", url="https://example.invalid/t.zip"
        ),
        "eshot": GtfsSource(
            id="eshot",
            operator="Fixture Bus",
            mode="bus",
            url="https://example.invalid/b.zip",
            route_grouping="by_short_name",
        ),
    }


@pytest.fixture
def copy_dir(tmp_path: Path):  # type: ignore[no-untyped-def]
    def _copy(name: str) -> Path:
        dst = tmp_path / name
        shutil.copytree(SYNTHETIC / name, dst)
        return dst

    return _copy


# --- database fixtures -----------------------------------------------------------------------
import os  # noqa: E402
from collections.abc import Iterator  # noqa: E402

from sqlalchemy import Engine, create_engine, text  # noqa: E402

TABLES = (
    "announcement",
    "source_coverage",
    "transfer",
    "shape",
    "service_date",
    "stop_time",
    "trip",
    "route",
    "stop",
    "agency",
    "ingestion_run",
    "source_snapshot",
    "dataset_version",
)


@pytest.fixture(scope="session")
def database_url() -> Iterator[str]:
    url = os.environ.get("IZMIRGO_TEST_DATABASE_URL")
    if url:
        yield url
        return
    from testcontainers.community.postgres import PostgresContainer

    with PostgresContainer("postgis/postgis:17-3.6", driver="psycopg") as pg:
        yield pg.get_connection_url()


@pytest.fixture(scope="session")
def migrated_engine(database_url: str) -> Iterator[Engine]:
    from alembic import command
    from alembic.config import Config

    cfg = Config(str(Path(__file__).resolve().parents[1] / "alembic.ini"))
    cfg.set_main_option("sqlalchemy.url", database_url)
    command.upgrade(cfg, "head")
    engine = create_engine(database_url)
    yield engine
    engine.dispose()


@pytest.fixture
def engine(migrated_engine: Engine) -> Iterator[Engine]:
    with migrated_engine.begin() as conn:
        conn.execute(text(f"TRUNCATE {', '.join(TABLES)} RESTART IDENTITY CASCADE"))
    yield migrated_engine
