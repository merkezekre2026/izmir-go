"""GTFS service-day time arithmetic.

GTFS times are measured from "noon minus 12h" of the service day in the agency timezone and may
exceed 24:00:00 for trips running past midnight (İzmir feeds go up to 26:06). Europe/Istanbul has
had no DST since 2016, but we keep the generic definition so the code stays correct if that
changes.
"""

from __future__ import annotations

import re
from datetime import date, datetime, time, timedelta
from zoneinfo import ZoneInfo

ISTANBUL = ZoneInfo("Europe/Istanbul")
_TIME_RE = re.compile(r"^\s*(\d{1,3}):([0-5]\d):([0-5]\d)\s*$")
MAX_SERVICE_SECONDS = 48 * 3600  # sanity bound; anything above is treated as invalid


class InvalidGtfsTime(ValueError):
    pass


def parse_gtfs_time(value: str) -> int:
    """'25:07:19' → seconds since service-day reference (90439)."""
    m = _TIME_RE.match(value)
    if not m:
        raise InvalidGtfsTime(f"invalid GTFS time: {value!r}")
    h, mi, s = (int(x) for x in m.groups())
    seconds = h * 3600 + mi * 60 + s
    if seconds >= MAX_SERVICE_SECONDS:
        raise InvalidGtfsTime(f"GTFS time beyond 48h: {value!r}")
    return seconds


def format_gtfs_time(seconds: int) -> str:
    h, rem = divmod(seconds, 3600)
    m, s = divmod(rem, 60)
    return f"{h:02d}:{m:02d}:{s:02d}"


def service_day_reference(service_date: date, tz: ZoneInfo = ISTANBUL) -> datetime:
    """Noon minus 12 hours on the service date, in local time (equals midnight without DST)."""
    noon = datetime.combine(service_date, time(12, 0), tzinfo=tz)
    return noon - timedelta(hours=12)


def to_datetime(service_date: date, seconds: int, tz: ZoneInfo = ISTANBUL) -> datetime:
    """Absolute local datetime for a GTFS time on a given service date."""
    return (service_day_reference(service_date, tz) + timedelta(seconds=seconds)).astimezone(tz)


def service_days_for(moment: datetime, lookback_days: int = 1) -> list[tuple[date, int]]:
    """Service days that can have departures at `moment`, with the GTFS seconds of `moment` in each.

    At 00:30 on Tuesday a trip may belong to Monday's service day at 24:30, so we return
    [(Tuesday, 1800), (Monday, 88200)].
    """
    local = moment.astimezone(ISTANBUL)
    out: list[tuple[date, int]] = []
    for back in range(lookback_days + 1):
        d = local.date() - timedelta(days=back)
        ref = service_day_reference(d)
        out.append((d, int((local - ref).total_seconds())))
    return out
