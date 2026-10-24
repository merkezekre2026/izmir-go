"""Pipeline tests against a real PostGIS database (synthetic fixture feeds only)."""

from pathlib import Path

import pytest
from sqlalchemy import Engine, text

from izmirgo.ingestion.cli import fixture_acquirer, fixture_sources
from izmirgo.ingestion.fetch import FetchError, FetchResult
from izmirgo.ingestion.merge import load_interchanges, load_stations
from izmirgo.ingestion.pipeline import run_pipeline
from izmirgo.ingestion.publish import active_dataset_id, rollback
from izmirgo.ingestion.sources import GtfsSource
from tests.conftest import FIXTURE_TODAY, FIXTURES, IZMIR_BBOX

pytestmark = pytest.mark.db


def _run(engine: Engine, tmp_path: Path, acquire=None, force: bool = False):  # type: ignore[no-untyped-def]
    return run_pipeline(
        engine,
        fixture_sources(),
        acquire=acquire or fixture_acquirer(tmp_path / "raw"),
        today=FIXTURE_TODAY,
        data_dir=tmp_path,
        bbox=IZMIR_BBOX,
        interchanges=load_interchanges(FIXTURES / "data" / "interchanges.csv"),
        stations=load_stations(FIXTURES / "data" / "stations.csv"),
        force=force,
    )


def test_publish_fixture_dataset(engine: Engine, tmp_path: Path) -> None:
    res = _run(engine, tmp_path)
    assert res.status == "published", res.error
    by_source = {d.source: d for d in res.decisions}
    assert by_source["metro"].included and by_source["tram"].included
    assert not by_source["eshot"].included
    assert "expired" in by_source["eshot"].reason

    dv = active_dataset_id(engine)
    assert dv == res.dataset_version_id
    with engine.connect() as c:
        stops = dict(
            c.execute(
                text("SELECT stop_id, modes FROM stop WHERE dataset_version_id=:d"), {"d": dv}
            ).all()
        )
        assert stops["metro:FXM2"] == ["metro"]
        assert stops["stn:fx-halkapinar"] == ["metro", "tram"]
        assert (
            c.execute(
                text("SELECT count(*) FROM shape WHERE dataset_version_id=:d"), {"d": dv}
            ).scalar()
            == 2
        )
        assert (
            c.execute(
                text("SELECT count(*) FROM transfer WHERE dataset_version_id=:d"), {"d": dv}
            ).scalar()
            == 2
        )
        # After-midnight departures are stored as seconds beyond 24h.
        assert (
            c.execute(
                text("SELECT max(departure_s) FROM stop_time WHERE dataset_version_id=:d"),
                {"d": dv},
            ).scalar()
            > 86400
        )
        # calendar_dates exception: WD removed and WE added on 2026-10-29.
        rows = (
            c.execute(
                text(
                    "SELECT service_id FROM service_date WHERE dataset_version_id=:d AND date='2026-10-29' ORDER BY 1"
                ),
                {"d": dv},
            )
            .scalars()
            .all()
        )
        assert "metro:WD" not in rows and "metro:WE" in rows
        cov = dict(
            c.execute(
                text("SELECT source, status FROM source_coverage WHERE dataset_version_id=:d"),
                {"d": dv},
            ).all()
        )
        assert cov == {"metro": "included", "tram": "included", "eshot": "excluded"}
        search = (
            c.execute(
                text(
                    "SELECT stop_id FROM stop WHERE dataset_version_id=:d AND search_key LIKE '%halkapinar%' ORDER BY 1"
                ),
                {"d": dv},
            )
            .scalars()
            .all()
        )
        assert search == ["metro:FXM2", "stn:fx-halkapinar", "tram:FXT1"]


def test_unchanged_inputs_do_not_republish(engine: Engine, tmp_path: Path) -> None:
    assert _run(engine, tmp_path).status == "published"
    assert _run(engine, tmp_path).status == "unchanged"


def test_fetch_failure_keeps_last_known_good(engine: Engine, tmp_path: Path) -> None:
    first = _run(engine, tmp_path)
    good = fixture_acquirer(tmp_path / "raw")

    def flaky(source: GtfsSource) -> FetchResult:
        if source.id == "tram":
            raise FetchError("connection reset")
        return good(source)

    second = _run(engine, tmp_path, acquire=flaky, force=True)
    assert second.status == "published"
    tram = next(d for d in second.decisions if d.source == "tram")
    assert tram.included
    assert tram.reason.startswith("last known good")
    assert second.dataset_version_id != first.dataset_version_id


def test_total_failure_keeps_previous_active(engine: Engine, tmp_path: Path) -> None:
    first = _run(engine, tmp_path)

    def broken(source: GtfsSource) -> FetchResult:
        raise FetchError("down")

    # Last-known-good snapshots still exist, so wipe them to simulate a cold failure.
    with engine.begin() as c:
        c.execute(text("UPDATE source_snapshot SET raw_path = NULL"))
    res = _run(engine, tmp_path, acquire=broken, force=True)
    assert res.status == "failed"
    assert active_dataset_id(engine) == first.dataset_version_id


def test_rollback_and_retention(engine: Engine, tmp_path: Path) -> None:
    a = _run(engine, tmp_path).dataset_version_id
    b = _run(engine, tmp_path, force=True).dataset_version_id
    c_ = _run(engine, tmp_path, force=True).dataset_version_id
    with engine.connect() as c:
        statuses = dict(c.execute(text("SELECT id, status FROM dataset_version")).all())
    assert statuses == {b: "retired", c_: "active"}  # a was removed by retention
    assert a not in statuses
    assert rollback(engine) == b
    assert active_dataset_id(engine) == b
