"""Public API response models (the contract the Flutter client is generated from)."""

from __future__ import annotations

from datetime import date, datetime
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field

Mode = Literal["bus", "metro", "tram", "rail", "ferry", "other"]
DataBasis = Literal["scheduled", "live", "cached"]


class Model(BaseModel):
    model_config = ConfigDict(frozen=True)


# --- shared --------------------------------------------------------------------------------


class Notice(Model):
    """A caveat the client must show next to the data it applies to."""

    code: Literal[
        "SOURCE_OUT_OF_VALIDITY",
        "SOURCE_EXCLUDED",
        "NO_HOLIDAY_CALENDAR",
        "TIMES_APPROXIMATE",
        "LIVE_UNAVAILABLE",
    ]
    message: str = Field(description="Turkish, user-facing text")
    source: str | None = None


class DatasetRef(Model):
    id: int
    label: str
    published_at: datetime | None


class SourceWindow(Model):
    source: str
    valid_from: date | None
    valid_to: date | None


class Meta(Model):
    dataset: DatasetRef
    generated_at: datetime
    sources: list[SourceWindow] = []
    notices: list[Notice] = []


# --- stops ---------------------------------------------------------------------------------


class StopSummary(Model):
    id: str = Field(examples=["metro:6"])
    name: str
    code: str | None = None
    lat: float
    lon: float
    modes: list[Mode]
    kind: Literal["stop", "station"]
    parent_station: str | None = None
    source: str
    has_schedule: bool = Field(
        description="False for stops known only from the operator's stop list (no valid timetable)"
    )
    lines: list[str] = Field(
        default=[], description="Line numbers from the operator's stop list (directory stops only)"
    )


class NearbyStop(StopSummary):
    distance_m: int


class RouteSummary(Model):
    id: str = Field(examples=["metro:1"])
    line_key: str
    short_name: str | None
    long_name: str | None
    mode: Mode
    color: str | None = Field(default=None, description="Hex RRGGBB without #")
    text_color: str | None = None
    source: str
    times_approximate: bool = Field(
        description="True when the operator marks stop times as approximate (timepoint=0)"
    )


class StopDetail(StopSummary):
    children: list[StopSummary] = []
    routes: list[RouteSummary] = []
    wheelchair_boarding: int | None = None
    live_supported: bool = Field(description="Whether live approaching-vehicle data exists here")


class StopPage(Model):
    items: list[StopSummary]
    next_cursor: str | None = None
    meta: Meta


class StopResponse(Model):
    stop: StopDetail
    meta: Meta


class NearbyResponse(Model):
    items: list[NearbyStop]
    meta: Meta


# --- departures ----------------------------------------------------------------------------


class Departure(Model):
    stop_id: str
    route: RouteSummary
    trip_id: str
    headsign: str | None
    direction_id: int | None
    service_date: date
    scheduled_departure: datetime
    basis: Literal["scheduled"] = "scheduled"
    times_approximate: bool
    wheelchair_accessible: int | None = None


class DeparturesResponse(Model):
    stop_id: str
    from_time: datetime
    items: list[Departure]
    meta: Meta


# --- live ----------------------------------------------------------------------------------


class ApproachingVehicle(Model):
    line_number: str
    line_name: str
    route_id: str | None = Field(
        description="Matching scheduled route, if the line is in the catalog"
    )
    color: str | None = None
    direction: int | None
    remaining_stops: int = Field(description="Stops away. NOT a time estimate.")
    lat: float | None
    lon: float | None
    vehicle_id: str | None
    wheelchair_accessible: bool | None
    bike_rack: bool | None


class LiveResponse(Model):
    stop_id: str
    supported: bool
    basis: Literal["live"] = "live"
    fetched_at: datetime | None
    source: str | None = None
    items: list[ApproachingVehicle] = []
    notice: Notice | None = None


# --- routes --------------------------------------------------------------------------------


class Pattern(Model):
    direction_id: int | None
    headsign: str | None
    trip_count: int
    stops: list[StopSummary]
    geometry: list[tuple[float, float]] | None = Field(
        description="[lon, lat] pairs from shapes.txt; null when the operator publishes no shape"
    )
    geometry_basis: Literal["shape", "stop_to_stop"]


class RouteDetail(RouteSummary):
    agency_name: str | None
    patterns: list[Pattern]


class RouteList(Model):
    items: list[RouteSummary]
    meta: Meta


class RouteResponse(Model):
    route: RouteDetail
    meta: Meta


class ScheduledTrip(Model):
    trip_id: str
    direction_id: int | None
    headsign: str | None
    first_departure: datetime
    last_arrival: datetime


class ScheduleResponse(Model):
    route_id: str
    service_date: date
    items: list[ScheduledTrip]
    meta: Meta


# --- status, alerts, catalog, places ---------------------------------------------------------


class SourceStatus(Model):
    source: str
    operator: str | None
    mode: Mode | None
    status: Literal["included", "excluded"]
    reason: str | None
    valid_from: date | None
    valid_to: date | None
    fetched_at: datetime | None
    last_attempt_at: datetime | None
    last_attempt_status: str | None
    times_approximate: bool
    has_calendar_exceptions: bool | None
    live_data: bool


class TransitStatus(Model):
    dataset: DatasetRef | None
    sources: list[SourceStatus]
    last_run_at: datetime | None
    last_run_status: str | None
    generated_at: datetime


class Alert(Model):
    id: str
    source: str
    line_short_name: str | None
    route_ids: list[str]
    title: str
    starts_at: datetime | None
    ends_at: datetime | None
    fetched_at: datetime
    kind: Literal["announcement"] = "announcement"


class AlertsResponse(Model):
    items: list[Alert]
    generated_at: datetime


class CatalogStop(Model):
    id: str
    name: str
    lat: float
    lon: float
    modes: list[Mode]
    kind: Literal["stop", "station"]
    parent_station: str | None
    has_schedule: bool
    lines: list[str] = []


class CatalogSnapshot(Model):
    dataset: DatasetRef
    generated_at: datetime
    stops: list[CatalogStop]
    routes: list[RouteSummary]
    sources: list[SourceWindow]


class Place(Model):
    id: str
    name: str
    subtitle: str | None
    lat: float
    lon: float
    kind: Literal["stop", "station", "address", "poi"]
    provider: Literal["catalog", "photon"]


class PlacesResponse(Model):
    items: list[Place]
    attribution: str | None = None


class Attribution(Model):
    id: str
    text: str
    licence: str
    url: str


class AttributionsResponse(Model):
    items: list[Attribution]


class Ready(Model):
    status: Literal["ready", "degraded"]
    database: bool
    active_dataset: bool
    routing: Literal["ok", "unavailable", "not_configured"]
