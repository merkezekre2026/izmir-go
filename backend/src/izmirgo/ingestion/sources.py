"""Load the upstream source registry (data/sources.yaml)."""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Literal

import yaml

Mode = Literal["metro", "tram", "bus", "rail", "ferry"]


@dataclass(frozen=True)
class GtfsSource:
    id: str
    operator: str
    mode: Mode
    url: str
    mirrors: tuple[str, ...] = ()
    licence: str = "CC-BY-4.0"
    route_grouping: Literal["by_short_name", "by_route_id"] = "by_route_id"
    times_approximate: bool = False

    @property
    def urls(self) -> tuple[str, ...]:
        return (self.url, *self.mirrors)


@dataclass(frozen=True)
class Registry:
    gtfs: tuple[GtfsSource, ...]
    attribution: dict[str, dict[str, str]] = field(default_factory=dict)
    api: dict[str, Any] = field(default_factory=dict)
    static_csv: dict[str, dict[str, str]] = field(default_factory=dict)

    def source(self, source_id: str) -> GtfsSource:
        for s in self.gtfs:
            if s.id == source_id:
                return s
        raise KeyError(source_id)


def load_registry(path: Path) -> Registry:
    raw = yaml.safe_load(path.read_text("utf-8"))
    gtfs = tuple(
        GtfsSource(
            id=item["id"],
            operator=item["operator"],
            mode=item["mode"],
            url=item["url"],
            mirrors=tuple(item.get("mirrors") or ()),
            licence=item.get("licence", "CC-BY-4.0"),
            route_grouping=item.get("route_grouping", "by_route_id"),
            times_approximate=bool(item.get("times_approximate", False)),
        )
        for item in raw.get("gtfs", [])
    )
    return Registry(
        gtfs=gtfs,
        attribution=raw.get("attribution", {}),
        api=raw.get("api", {}),
        static_csv=raw.get("static_csv", {}),
    )
