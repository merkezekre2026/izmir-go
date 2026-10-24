"""OpenTripPlanner 2.10 adapter (GTFS GraphQL API, `planConnection`).

OTP routes over the merged, namespaced feed loaded with feedId `izm`, so OTP ids look like
`izm:metro:6`. This module converts them back to İzmir Go ids and maps OTP itineraries onto a
small, explicit journey model. Real-time is never requested: there is no GTFS-RT for İzmir.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from importlib import resources
from typing import Any, Literal

import httpx

from izmirgo.core.resilience import CircuitBreaker, CircuitOpen

FEED_ID = "izm"
PLAN_QUERY = (
    resources.files("izmirgo.providers").joinpath("otp_queries/plan.graphql").read_text("utf-8")
)

OTP_MODE = {"bus": "BUS", "metro": "SUBWAY", "tram": "TRAM", "rail": "RAIL", "ferry": "FERRY"}
FROM_OTP_MODE = {
    "BUS": "bus",
    "TROLLEYBUS": "bus",
    "COACH": "bus",
    "SUBWAY": "metro",
    "MONORAIL": "metro",
    "TRAM": "tram",
    "RAIL": "rail",
    "FERRY": "ferry",
    "WALK": "walk",
}
ROUTING_ERROR_TR = {
    "NO_TRANSIT_CONNECTION": "Bu iki nokta arasında uygun toplu taşıma bağlantısı bulunamadı.",
    "NO_TRANSIT_CONNECTION_IN_SEARCH_WINDOW": "Seçilen saat aralığında uygun sefer bulunamadı.",
    "OUTSIDE_SERVICE_PERIOD": "Seçilen tarih için tarife verisi yok.",
    "OUTSIDE_BOUNDS": "Konum hizmet alanı dışında.",
    "LOCATION_NOT_FOUND": "Başlangıç veya varış noktası bulunamadı.",
    "NO_STOPS_IN_RANGE": "Yürüme mesafesinde durak bulunamadı.",
    "WALKING_BETTER_THAN_TRANSIT": "Bu mesafe için yürümek daha hızlı.",
}


class RoutingUnavailable(RuntimeError):
    pass


def to_otp_id(izm_id: str) -> str:
    return f"{FEED_ID}:{izm_id}"


def from_otp_id(otp_id: str | None) -> str | None:
    if not otp_id:
        return None
    prefix = f"{FEED_ID}:"
    return otp_id[len(prefix) :] if otp_id.startswith(prefix) else otp_id


def decode_polyline(encoded: str | None, precision: int = 5) -> list[tuple[float, float]]:
    """Decode a Google encoded polyline into [(lon, lat), ...]."""
    if not encoded:
        return []
    coords: list[tuple[float, float]] = []
    index = lat = lon = 0
    factor = 10**precision
    while index < len(encoded):
        deltas = []
        for _ in range(2):
            shift = result = 0
            while True:
                b = ord(encoded[index]) - 63
                index += 1
                result |= (b & 0x1F) << shift
                shift += 5
                if b < 0x20:
                    break
            deltas.append(~(result >> 1) if result & 1 else result >> 1)
        lat += deltas[0]
        lon += deltas[1]
        coords.append((round(lon / factor, 6), round(lat / factor, 6)))
    return coords


@dataclass(frozen=True)
class Endpoint:
    """Origin/destination: a coordinate or a stop id (namespaced)."""

    lat: float | None = None
    lon: float | None = None
    stop_id: str | None = None
    label: str | None = None

    def to_otp(self) -> dict[str, Any]:
        if self.stop_id:
            loc: dict[str, Any] = {"stopLocation": {"stopLocationId": to_otp_id(self.stop_id)}}
        else:
            loc = {"coordinate": {"latitude": self.lat, "longitude": self.lon}}
        out: dict[str, Any] = {"location": loc}
        if self.label:
            out["label"] = self.label
        return out


@dataclass(frozen=True)
class PlanRequest:
    origin: Endpoint
    destination: Endpoint
    when: datetime
    arrive_by: bool = False
    modes: tuple[str, ...] = ("bus", "metro", "tram", "rail", "ferry")
    max_transfers: int | None = None
    walk_speed_mps: float | None = None
    wheelchair: bool = False
    limit: int = 3

    def variables(self) -> dict[str, Any]:
        key = "latestArrival" if self.arrive_by else "earliestDeparture"
        prefs: dict[str, Any] = {}
        if self.walk_speed_mps:
            prefs.setdefault("street", {})["walk"] = {"speed": self.walk_speed_mps}
        if self.max_transfers is not None:
            prefs.setdefault("transit", {})["transfer"] = {"maximumTransfers": self.max_transfers}
        if self.wheelchair:
            prefs["accessibility"] = {"wheelchair": {"enabled": True}}
        variables: dict[str, Any] = {
            "origin": self.origin.to_otp(),
            "destination": self.destination.to_otp(),
            "dateTime": {key: self.when.isoformat()},
            "first": self.limit,
            "modes": {
                "direct": ["WALK"],
                "transit": {
                    "transit": [{"mode": OTP_MODE[m]} for m in self.modes if m in OTP_MODE]
                },
            },
        }
        if prefs:
            variables["preferences"] = prefs
        return variables


@dataclass
class PlaceOut:
    name: str
    lat: float
    lon: float
    stop_id: str | None
    station_id: str | None


@dataclass
class StopCallOut:
    stop_id: str
    name: str
    lat: float
    lon: float
    scheduled_departure: datetime | None


@dataclass
class LegOut:
    mode: str
    start: datetime
    end: datetime
    duration_s: int
    distance_m: int
    origin: PlaceOut
    destination: PlaceOut
    route_id: str | None
    trip_id: str | None
    headsign: str | None
    service_date: str | None
    geometry: list[tuple[float, float]]
    intermediate_stops: list[StopCallOut] = field(default_factory=list)
    is_transfer: bool = False


@dataclass
class ItineraryOut:
    start: datetime
    end: datetime
    duration_s: int
    transfers: int
    walk_distance_m: int
    legs: list[LegOut]


@dataclass
class PlanOut:
    itineraries: list[ItineraryOut]
    routing_errors: list[tuple[str, str]]  # (code, turkish message)


def _dt(value: str) -> datetime:
    return datetime.fromisoformat(value)


# OTP names unnamed coordinates in English.
_PLACE_NAMES_TR = {"Origin": "Başlangıç", "Destination": "Varış"}


def _place(p: dict[str, Any]) -> PlaceOut:
    stop = p.get("stop") or {}
    parent = stop.get("parentStation") or {}
    name = p.get("name") or ""
    return PlaceOut(
        name=_PLACE_NAMES_TR.get(name, name) if not stop else name,
        lat=float(p["lat"]),
        lon=float(p["lon"]),
        stop_id=from_otp_id(stop.get("gtfsId")),
        station_id=from_otp_id(parent.get("gtfsId")),
    )


def _intermediate(leg: dict[str, Any]) -> list[StopCallOut]:
    calls = leg.get("stopCalls") or []
    out: list[StopCallOut] = []
    for c in calls[1:-1]:  # first/last are board and alight stops
        s = c.get("stopLocation") or {}
        t = ((c.get("schedule") or {}).get("time") or {}) if c.get("schedule") else {}
        dep = t.get("departure") or t.get("arrival")
        if not s.get("gtfsId"):
            continue
        out.append(
            StopCallOut(
                stop_id=from_otp_id(s["gtfsId"]) or "",
                name=s.get("name") or "",
                lat=float(s.get("lat") or 0.0),
                lon=float(s.get("lon") or 0.0),
                scheduled_departure=_dt(dep) if isinstance(dep, str) else None,
            )
        )
    return out


def parse_plan(payload: dict[str, Any]) -> PlanOut:
    if payload.get("errors"):
        raise RoutingUnavailable(str(payload["errors"])[:500])
    pc = (payload.get("data") or {}).get("planConnection") or {}
    errors = [
        (e.get("code", ""), ROUTING_ERROR_TR.get(e.get("code", ""), "Rota bulunamadı."))
        for e in pc.get("routingErrors") or []
    ]
    itineraries: list[ItineraryOut] = []
    for edge in pc.get("edges") or []:
        node = edge["node"]
        legs: list[LegOut] = []
        for raw in node["legs"]:
            mode = FROM_OTP_MODE.get(raw["mode"], "other")
            start = str((raw.get("start") or {}).get("scheduledTime") or node["start"])
            end = str((raw.get("end") or {}).get("scheduledTime") or node["end"])
            route = raw.get("route") or {}
            trip = raw.get("trip") or {}
            legs.append(
                LegOut(
                    mode=mode,
                    start=_dt(start),
                    end=_dt(end),
                    duration_s=int(raw.get("duration") or 0),
                    distance_m=round(raw.get("distance") or 0),
                    origin=_place(raw["from"]),
                    destination=_place(raw["to"]),
                    route_id=from_otp_id(route.get("gtfsId")),
                    trip_id=from_otp_id(trip.get("gtfsId")),
                    headsign=raw.get("headsign") or trip.get("tripHeadsign"),
                    service_date=raw.get("serviceDate"),
                    geometry=decode_polyline((raw.get("legGeometry") or {}).get("points")),
                    intermediate_stops=_intermediate(raw) if raw.get("transitLeg") else [],
                )
            )
        for i, leg in enumerate(legs):
            if leg.mode == "walk" and 0 < i < len(legs) - 1:
                leg.is_transfer = True
        itineraries.append(
            ItineraryOut(
                start=_dt(node["start"]),
                end=_dt(node["end"]),
                duration_s=int(node["duration"]),
                transfers=int(node.get("numberOfTransfers") or 0),
                walk_distance_m=round(node.get("walkDistance") or 0),
                legs=legs,
            )
        )
    return PlanOut(itineraries=itineraries, routing_errors=errors)


class OtpClient:
    def __init__(self, *, client: httpx.AsyncClient | None = None, timeout_s: float = 10.0) -> None:
        self._client = client or httpx.AsyncClient(timeout=httpx.Timeout(timeout_s, connect=2.0))
        self.breaker = CircuitBreaker("otp", threshold=3, reset_after_s=20.0)

    async def aclose(self) -> None:
        await self._client.aclose()

    async def plan(self, base_url: str, request: PlanRequest) -> PlanOut:
        async def do() -> dict[str, Any]:
            res = await self._client.post(
                f"{base_url.rstrip('/')}/otp/gtfs/v1",
                json={"query": PLAN_QUERY, "variables": request.variables()},
            )
            if res.status_code != 200:
                raise RoutingUnavailable(f"HTTP {res.status_code}")
            data: dict[str, Any] = res.json()
            return data

        try:
            payload = await self.breaker.call(do)
        except (httpx.HTTPError, CircuitOpen, ValueError) as exc:
            raise RoutingUnavailable(str(exc)) from exc
        return parse_plan(payload)


GeometryBasis = Literal["shape", "stop_to_stop", "street_network", "straight_line"]
