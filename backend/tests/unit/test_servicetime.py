from datetime import date, datetime

import pytest

from izmirgo.core.servicetime import (
    ISTANBUL,
    InvalidGtfsTime,
    format_gtfs_time,
    parse_gtfs_time,
    service_days_for,
    to_datetime,
)


def test_parse_after_midnight() -> None:
    assert parse_gtfs_time("25:07:19") == 25 * 3600 + 7 * 60 + 19
    assert parse_gtfs_time(" 6:00:00 ") == 21600
    assert format_gtfs_time(90439) == "25:07:19"


@pytest.mark.parametrize("bad", ["", "6:00", "06:60:00", "ab:cd:ef", "48:00:00"])
def test_parse_rejects(bad: str) -> None:
    with pytest.raises(InvalidGtfsTime):
        parse_gtfs_time(bad)


def test_to_datetime_crosses_midnight() -> None:
    dt = to_datetime(date(2026, 10, 27), parse_gtfs_time("24:30:00"))
    assert dt == datetime(2026, 10, 28, 0, 30, tzinfo=ISTANBUL)


def test_service_days_for_early_morning() -> None:
    moment = datetime(2026, 10, 28, 0, 30, tzinfo=ISTANBUL)
    assert service_days_for(moment) == [(date(2026, 10, 28), 1800), (date(2026, 10, 27), 88200)]
