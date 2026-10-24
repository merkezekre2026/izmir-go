"""Request dependencies and shared row → schema mappers."""

from __future__ import annotations

from collections.abc import Iterator, Sequence
from datetime import UTC, date, datetime
from typing import Annotated, Any

from fastapi import Depends, Request
from sqlalchemy import Connection, Engine

from izmirgo.api.errors import ApiError, ErrorCode
from izmirgo.api.schemas import (
    DatasetRef,
    Meta,
    Notice,
    RouteSummary,
    SourceWindow,
    StopSummary,
)
from izmirgo.domain import catalog
from izmirgo.domain.catalog import ActiveDataset

SOURCE_LABELS: dict[str, str] = {
    "metro": "İzmir Metro",
    "tram": "Tram İzmir",
    "eshot": "ESHOT otobüs",
    "izban": "İZBAN",
    "izdeniz": "İZDENİZ vapur",
}
# Sources with a live API wired into İzmir Go.
LIVE_SOURCES = frozenset({"eshot"})


def get_engine(request: Request) -> Engine:
    engine: Engine = request.app.state.engine
    return engine


def get_conn(engine: Annotated[Engine, Depends(get_engine)]) -> Iterator[Connection]:
    with engine.connect() as conn:
        yield conn


Conn = Annotated[Connection, Depends(get_conn)]


def require_dataset(conn: Conn) -> ActiveDataset:
    ds = catalog.active_dataset(conn)
    if ds is None:
        raise ApiError(ErrorCode.NO_ACTIVE_DATASET, 503)
    return ds


Dataset = Annotated[ActiveDataset, Depends(require_dataset)]


def dataset_ref(ds: ActiveDataset) -> DatasetRef:
    return DatasetRef(id=ds.id, label=ds.label, published_at=ds.published_at)


def _excluded_reason_tr(reason: str | None) -> str:
    r = (reason or "").lower()
    if "expired" in r:
        return "tarife geçerlilik süresi dolmuş"
    if "not_yet_valid" in r:
        return "tarife henüz yürürlükte değil"
    if "fetch failed" in r:
        return "kaynağa ulaşılamadı"
    if "invalid" in r:
        return "veri doğrulamadan geçmedi"
    return "kaynak şu anda kullanılamıyor"


def build_meta(conn: Connection, ds: ActiveDataset, *, on_date: date | None = None) -> Meta:
    coverage = catalog.source_coverage(conn, ds.id)
    windows: list[SourceWindow] = []
    notices: list[Notice] = []
    missing_holidays = False
    for c in coverage:
        label = SOURCE_LABELS.get(c["source"], c["source"])
        if c["status"] != "included":
            notices.append(
                Notice(
                    code="SOURCE_EXCLUDED",
                    source=c["source"],
                    message=f"{label} tarifeleri dahil değil: {_excluded_reason_tr(c['reason'])}.",
                )
            )
            continue
        windows.append(
            SourceWindow(source=c["source"], valid_from=c["feed_start"], valid_to=c["feed_end"])
        )
        if (c["calendar_dates"] or 0) == 0:
            missing_holidays = True
        if (
            on_date
            and c["feed_start"]
            and c["feed_end"]
            and not (c["feed_start"] <= on_date <= c["feed_end"])
        ):
            notices.append(
                Notice(
                    code="SOURCE_OUT_OF_VALIDITY",
                    source=c["source"],
                    message=f"{label} tarifesi {on_date:%d.%m.%Y} için mevcut değil.",
                )
            )
    if missing_holidays:
        notices.append(
            Notice(
                code="NO_HOLIDAY_CALENDAR",
                message="Resmî tatillerde sefer saatleri farklı olabilir; operatörler tatil takvimi yayımlamıyor.",
            )
        )
    return Meta(
        dataset=dataset_ref(ds), generated_at=datetime.now(UTC), sources=windows, notices=notices
    )


def to_stop(row: Any, **extra: Any) -> dict[str, Any]:
    return {
        "id": row["stop_id"],
        "name": row["name"],
        "code": row["code"],
        "lat": row["lat"],
        "lon": row["lon"],
        "modes": list(row["modes"] or []),
        "kind": "station" if row["location_type"] == 1 else "stop",
        "parent_station": row["parent_station"],
        "source": row["source"],
        **extra,
    }


def stop_summary(row: Any) -> StopSummary:
    return StopSummary(**to_stop(row))


def route_summary(row: Any) -> RouteSummary:
    return RouteSummary(
        id=row["route_id"],
        line_key=row["line_key"],
        short_name=row["short_name"],
        long_name=row["long_name"],
        mode=row["mode"],
        color=row["color"],
        text_color=row["text_color"],
        source=row["source"],
        times_approximate=row["times_approximate"],
    )


def parse_modes(raw: str | None) -> list[str] | None:
    if not raw:
        return None
    allowed = {"bus", "metro", "tram", "rail", "ferry"}
    modes = [m.strip() for m in raw.split(",") if m.strip()]
    bad = [m for m in modes if m not in allowed]
    if bad:
        raise ApiError(ErrorCode.VALIDATION_ERROR, 422, f"unknown modes: {', '.join(bad)}")
    return modes


def check_in_coverage(request: Request, lat: float, lon: float) -> None:
    x1, y1, x2, y2 = request.app.state.settings.coverage_bbox
    if not (x1 <= lon <= x2 and y1 <= lat <= y2):
        raise ApiError(
            ErrorCode.OUTSIDE_COVERAGE_AREA, 422, "İzmir il sınırları dışında bir konum."
        )


def unique(seq: Sequence[str]) -> list[str]:
    return list(dict.fromkeys(seq))
