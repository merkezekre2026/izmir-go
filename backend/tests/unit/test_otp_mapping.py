import json
from datetime import datetime

from izmirgo.core.servicetime import ISTANBUL
from izmirgo.providers.otp import (
    Endpoint,
    PlanRequest,
    decode_polyline,
    from_otp_id,
    parse_plan,
    to_otp_id,
)
from tests.conftest import FIXTURES

OTP = FIXTURES / "otp"


def test_ids_roundtrip() -> None:
    assert to_otp_id("metro:6") == "izm:metro:6"
    assert from_otp_id("izm:metro:6") == "metro:6"
    assert from_otp_id(None) is None


def test_decode_polyline_reference() -> None:
    # Reference example from Google's encoded polyline documentation.
    assert decode_polyline("_p~iF~ps|U_ulLnnqC_mqNvxq`@") == [
        (-120.2, 38.5),
        (-120.95, 40.7),
        (-126.453, 43.252),
    ]


def test_variables_depart_and_arrive() -> None:
    when = datetime(2026, 10, 28, 8, 0, tzinfo=ISTANBUL)
    req = PlanRequest(
        Endpoint(lat=38.44, lon=27.18),
        Endpoint(stop_id="tram:FXT3"),
        when,
        modes=("metro", "tram"),
        max_transfers=2,
        walk_speed_mps=1.33,
        wheelchair=True,
    )
    v = req.variables()
    assert v["origin"]["location"]["coordinate"] == {"latitude": 38.44, "longitude": 27.18}
    assert v["destination"]["location"]["stopLocation"]["stopLocationId"] == "izm:tram:FXT3"
    assert v["dateTime"] == {"earliestDeparture": "2026-10-28T08:00:00+03:00"}
    assert v["modes"]["transit"]["transit"] == [{"mode": "SUBWAY"}, {"mode": "TRAM"}]
    assert v["preferences"]["transit"]["transfer"]["maximumTransfers"] == 2
    assert v["preferences"]["accessibility"]["wheelchair"]["enabled"] is True
    arrive = PlanRequest(req.origin, req.destination, when, arrive_by=True).variables()
    assert "latestArrival" in arrive["dateTime"]


def test_parse_recorded_otp_plan() -> None:
    plan = parse_plan(json.loads((OTP / "plan_metro_tram.json").read_text()))
    assert plan.routing_errors == []
    it = plan.itineraries[0]
    assert [leg.mode for leg in it.legs] == ["metro", "walk", "tram"]
    metro, walk, tram = it.legs
    assert metro.route_id == "metro:FX1"
    assert metro.origin.stop_id == "metro:FXM1"
    assert metro.origin.station_id is None
    assert walk.is_transfer
    assert walk.origin.stop_id == "metro:FXM2"
    assert walk.destination.stop_id == "tram:FXT1"
    assert tram.start >= walk.end  # waits for the tram, never departs before arriving
    assert [s.stop_id for s in tram.intermediate_stops] == ["tram:FXT2"]
    assert it.transfers == 1


def test_parse_routing_error() -> None:
    plan = parse_plan(json.loads((OTP / "plan_outside_service.json").read_text()))
    assert plan.itineraries == []
    assert plan.routing_errors[0][0] == "OUTSIDE_SERVICE_PERIOD"
    assert "tarih" in plan.routing_errors[0][1]
