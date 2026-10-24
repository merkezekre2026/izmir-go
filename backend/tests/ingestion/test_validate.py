from datetime import date
from pathlib import Path

from izmirgo.ingestion.gtfs import GtfsFeed
from izmirgo.ingestion.validate import validate_feed
from tests.conftest import FIXTURE_TODAY, IZMIR_BBOX, SYNTHETIC


def _validate(path: Path, today: date = FIXTURE_TODAY, previous: dict[str, int] | None = None):  # type: ignore[no-untyped-def]
    with GtfsFeed(path) as feed:
        return validate_feed(feed, today=today, bbox=IZMIR_BBOX, previous_stats=previous)


def test_valid_metro_fixture(feed_zip) -> None:  # type: ignore[no-untyped-def]
    report = _validate(feed_zip("fx_metro"))
    assert report.ok, report.to_dict()
    assert report.usable
    assert report.validity == "valid"
    assert report.stats["stop_times_after_midnight"] > 0
    assert report.feed_start == date(2026, 1, 1)
    assert report.feed_end == date(2027, 12, 31)


def test_directory_input_works() -> None:
    assert _validate(SYNTHETIC / "fx_tram").usable


def test_missing_calendar_exceptions_is_a_warning() -> None:
    report = _validate(SYNTHETIC / "fx_tram")
    assert "no_calendar_exceptions" in report.issues
    assert report.issues["no_calendar_exceptions"].severity == "warning"


def test_expired_feed_is_not_usable() -> None:
    report = _validate(SYNTHETIC / "fx_bus_expired")
    assert report.ok
    assert report.validity == "expired"
    assert not report.usable


def test_not_yet_valid() -> None:
    report = _validate(SYNTHETIC / "fx_tram", today=date(2025, 6, 1))
    assert report.validity == "not_yet_valid"


def test_missing_column_is_error() -> None:
    report = _validate(SYNTHETIC / "broken_missing_column")
    assert not report.ok
    assert report.issues["missing_column"].examples == ["trips.txt:service_id"]
    assert report.validity == "invalid"


def test_small_orphan_share_is_repaired() -> None:
    report = _validate(SYNTHETIC / "broken_orphan")
    assert report.ok
    assert report.issues["stop_time_unknown_trip"].severity == "warning"
    assert report.orphan_trip_refs == {"GHOST"}
    assert "repaired_by_dropping_trips" in report.issues


def test_single_non_monotonic_trip_is_dropped() -> None:
    report = _validate(SYNTHETIC / "broken_non_monotonic")
    assert report.usable
    assert len(report.drop_trip_ids) == 1


def test_large_defect_share_is_fatal(monkeypatch) -> None:  # type: ignore[no-untyped-def]
    import izmirgo.ingestion.validate as v

    monkeypatch.setattr(v, "MAX_REPAIR_RATIO", 0.0001)
    report = _validate(SYNTHETIC / "broken_non_monotonic")
    assert not report.ok
    assert report.validity == "invalid"


def test_row_count_drop_quarantines() -> None:
    report = _validate(SYNTHETIC / "fx_tram", previous={"trips": 10_000})
    assert "row_count_drop" in report.issues
    assert not report.usable


def test_stop_outside_bbox_flagged() -> None:
    with GtfsFeed(SYNTHETIC / "fx_tram") as feed:
        report = validate_feed(feed, today=FIXTURE_TODAY, bbox=(0.0, 0.0, 1.0, 1.0))
    assert "many_stops_outside_coverage" in report.issues
