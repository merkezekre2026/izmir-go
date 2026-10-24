"""Namespaced identifiers: `{source}:{raw_id}`.

Raw operator IDs collide across feeds (e.g. stop `1` is a tram stop in one feed and an İZBAN
station in another), so every entity crossing the ingestion boundary is namespaced.
"""

from __future__ import annotations

import re
from typing import Final

SOURCES: Final = ("metro", "tram", "eshot", "izban", "izdeniz")
STATION_NS: Final = "stn"
_SOURCE_RE: Final = re.compile(r"^[a-z][a-z0-9_]{1,15}$")
_NSID_RE: Final = re.compile(r"^(?P<ns>[a-z][a-z0-9_]{1,15}):(?P<raw>[^\s:][^\s]*)$")


class InvalidId(ValueError):
    pass


def nsid(source: str, raw_id: str) -> str:
    """Build a namespaced ID. Raw IDs are trimmed; empty IDs are rejected."""
    if not _SOURCE_RE.match(source):
        raise InvalidId(f"invalid source namespace: {source!r}")
    raw = raw_id.strip()
    if not raw or any(c.isspace() for c in raw):
        raise InvalidId(f"invalid raw id: {raw_id!r}")
    return f"{source}:{raw}"


def split(value: str) -> tuple[str, str]:
    """Split a namespaced ID into (namespace, raw_id)."""
    m = _NSID_RE.match(value)
    if not m:
        raise InvalidId(f"not a namespaced id: {value!r}")
    return m.group("ns"), m.group("raw")


def is_nsid(value: str) -> bool:
    return bool(_NSID_RE.match(value))
