"""Minimal streaming GTFS reader over a ZIP archive or a directory.

Small tables are read fully; large ones (stop_times, shapes) are iterated row by row, so a
2.1M-row ESHOT stop_times file never sits in memory as Python dicts.
"""

from __future__ import annotations

import csv
import io
import zipfile
from collections.abc import Iterator
from pathlib import Path
from types import TracebackType
from typing import Self

Row = dict[str, str]

REQUIRED_FILES = ("agency.txt", "stops.txt", "routes.txt", "trips.txt", "stop_times.txt")
REQUIRED_COLUMNS: dict[str, tuple[str, ...]] = {
    "agency.txt": ("agency_name", "agency_url", "agency_timezone"),
    "stops.txt": ("stop_id",),
    "routes.txt": ("route_id", "route_type"),
    "trips.txt": ("route_id", "service_id", "trip_id"),
    "stop_times.txt": ("trip_id", "stop_id", "stop_sequence"),
    "calendar.txt": (
        "service_id",
        "monday",
        "tuesday",
        "wednesday",
        "thursday",
        "friday",
        "saturday",
        "sunday",
        "start_date",
        "end_date",
    ),
    "calendar_dates.txt": ("service_id", "date", "exception_type"),
    "shapes.txt": ("shape_id", "shape_pt_lat", "shape_pt_lon", "shape_pt_sequence"),
    "transfers.txt": ("from_stop_id", "to_stop_id", "transfer_type"),
}


class GtfsFeed:
    """Read access to one GTFS feed. Use as a context manager."""

    def __init__(self, path: Path) -> None:
        self.path = path
        self._zip: zipfile.ZipFile | None = None
        self._names: dict[str, str] = {}

    def __enter__(self) -> Self:
        if self.path.is_dir():
            self._names = {p.name: p.name for p in self.path.iterdir() if p.suffix == ".txt"}
        else:
            self._zip = zipfile.ZipFile(self.path)
            # Some producers nest files in a folder; index by basename.
            for info in self._zip.infolist():
                base = info.filename.rsplit("/", 1)[-1]
                if base.endswith(".txt") and not info.is_dir():
                    self._names.setdefault(base, info.filename)
        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc: BaseException | None,
        tb: TracebackType | None,
    ) -> None:
        if self._zip is not None:
            self._zip.close()

    def has(self, name: str) -> bool:
        return name in self._names

    @property
    def files(self) -> list[str]:
        return sorted(self._names)

    def _open_text(self, name: str) -> io.TextIOBase:
        if self._zip is not None:
            raw = self._zip.open(self._names[name])
            return io.TextIOWrapper(raw, encoding="utf-8-sig", newline="")
        return (self.path / self._names[name]).open(encoding="utf-8-sig", newline="")

    def columns(self, name: str) -> list[str]:
        if not self.has(name):
            return []
        with self._open_text(name) as fh:
            header = next(csv.reader(fh), [])
        return [h.strip() for h in header]

    def iter_rows(self, name: str) -> Iterator[Row]:
        if not self.has(name):
            return
        with self._open_text(name) as fh:
            reader = csv.DictReader(fh)
            if reader.fieldnames:
                reader.fieldnames = [f.strip() for f in reader.fieldnames]
            for row in reader:
                yield {k: (v or "").strip() for k, v in row.items() if k is not None}

    def rows(self, name: str) -> list[Row]:
        return list(self.iter_rows(name))
