"""Transport modes derived from GTFS route_type (basic and extended types)."""

from __future__ import annotations

from typing import Final, Literal

Mode = Literal["tram", "metro", "rail", "bus", "ferry", "other"]
MODES: Final[tuple[Mode, ...]] = ("bus", "metro", "tram", "rail", "ferry")

_BASIC: Final[dict[int, Mode]] = {0: "tram", 1: "metro", 2: "rail", 3: "bus", 4: "ferry", 11: "bus"}


def mode_for_route_type(route_type: int) -> Mode:
    if route_type in _BASIC:
        return _BASIC[route_type]
    if 100 <= route_type < 200:
        return "rail"
    if 200 <= route_type < 300 or 700 <= route_type < 800:
        return "bus"
    if 400 <= route_type < 500:
        return "metro"
    if 900 <= route_type < 1000:
        return "tram"
    if 1000 <= route_type < 1300:
        return "ferry"
    return "other"
