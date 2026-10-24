"""Database schema.

Transit tables are keyed by `dataset_version_id`. A dataset version is staged in full, checked,
and then made active in one transaction (`dataset_version.status`). The previous version stays
until retention removes it, so a failed update never leaves a half-loaded catalog.
"""

from __future__ import annotations

from datetime import date, datetime
from typing import Any, ClassVar

from geoalchemy2 import Geometry
from sqlalchemy import (
    BigInteger,
    Boolean,
    Date,
    DateTime,
    ForeignKey,
    ForeignKeyConstraint,
    Index,
    Integer,
    MetaData,
    SmallInteger,
    String,
    Text,
    func,
    text,
)
from sqlalchemy.dialects.postgresql import ARRAY, JSONB
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column

NAMING = {
    "ix": "ix_%(column_0_label)s",
    "uq": "uq_%(table_name)s_%(column_0_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s",
}


class Base(DeclarativeBase):
    metadata = MetaData(naming_convention=NAMING)
    type_annotation_map: ClassVar[dict[Any, Any]] = {dict[str, Any]: JSONB}


DV_FK = "dataset_version.id"


class DatasetVersion(Base):
    __tablename__ = "dataset_version"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    label: Mapped[str] = mapped_column(String(64), unique=True)
    # staged | active | retired | failed
    status: Mapped[str] = mapped_column(String(16), index=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    published_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    merged_sha256: Mapped[str | None] = mapped_column(String(64))
    merged_path: Mapped[str | None] = mapped_column(Text)
    otp_graph_path: Mapped[str | None] = mapped_column(Text)
    otp_url: Mapped[str | None] = mapped_column(Text)
    summary: Mapped[dict[str, Any]] = mapped_column(server_default=text("'{}'::jsonb"))

    __table_args__ = (
        # At most one active dataset at any time.
        Index(
            "uq_dataset_version_one_active",
            "status",
            unique=True,
            postgresql_where=text("status = 'active'"),
        ),
    )


class SourceSnapshot(Base):
    """One fetch + validation of one upstream source, successful or not."""

    __tablename__ = "source_snapshot"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    source: Mapped[str] = mapped_column(String(32), index=True)
    fetched_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    origin_url: Mapped[str | None] = mapped_column(Text)
    is_mirror: Mapped[bool] = mapped_column(Boolean, default=False)
    http_etag: Mapped[str | None] = mapped_column(Text)
    http_last_modified: Mapped[str | None] = mapped_column(Text)
    sha256: Mapped[str | None] = mapped_column(String(64))
    raw_path: Mapped[str | None] = mapped_column(Text)
    feed_start: Mapped[date | None] = mapped_column(Date)
    feed_end: Mapped[date | None] = mapped_column(Date)
    # valid | expired | not_yet_valid | invalid | fetch_failed
    status: Mapped[str] = mapped_column(String(16))
    validation: Mapped[dict[str, Any]] = mapped_column(server_default=text("'{}'::jsonb"))
    error: Mapped[str | None] = mapped_column(Text)
    dataset_version_id: Mapped[int | None] = mapped_column(
        ForeignKey(DV_FK, ondelete="SET NULL"), index=True
    )


class IngestionRun(Base):
    __tablename__ = "ingestion_run"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    started_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    finished_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    # running | published | unchanged | failed
    status: Mapped[str] = mapped_column(String(16))
    dataset_version_id: Mapped[int | None] = mapped_column(ForeignKey(DV_FK, ondelete="SET NULL"))
    summary: Mapped[dict[str, Any]] = mapped_column(server_default=text("'{}'::jsonb"))


class Agency(Base):
    __tablename__ = "agency"

    dataset_version_id: Mapped[int] = mapped_column(
        ForeignKey(DV_FK, ondelete="CASCADE"), primary_key=True
    )
    agency_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    source: Mapped[str] = mapped_column(String(32))
    name: Mapped[str] = mapped_column(Text)
    url: Mapped[str | None] = mapped_column(Text)
    timezone: Mapped[str] = mapped_column(String(64))


class Stop(Base):
    __tablename__ = "stop"

    dataset_version_id: Mapped[int] = mapped_column(
        ForeignKey(DV_FK, ondelete="CASCADE"), primary_key=True
    )
    stop_id: Mapped[str] = mapped_column(String(80), primary_key=True)
    source: Mapped[str] = mapped_column(String(32))
    raw_id: Mapped[str] = mapped_column(String(64))
    code: Mapped[str | None] = mapped_column(String(32))
    name: Mapped[str] = mapped_column(Text)
    search_key: Mapped[str] = mapped_column(Text)
    lat: Mapped[float]
    lon: Mapped[float]
    geom: Mapped[Any] = mapped_column(Geometry("POINT", srid=4326, spatial_index=False))
    location_type: Mapped[int] = mapped_column(SmallInteger, default=0)
    parent_station: Mapped[str | None] = mapped_column(String(80))
    wheelchair_boarding: Mapped[int | None] = mapped_column(SmallInteger)
    # Modes served at this stop, filled after trips are loaded.
    modes: Mapped[list[str]] = mapped_column(ARRAY(String(16)), server_default=text("'{}'"))

    __table_args__ = (
        Index("ix_stop_geom", "geom", postgresql_using="gist"),
        Index(
            "ix_stop_search_trgm",
            "search_key",
            postgresql_using="gin",
            postgresql_ops={"search_key": "gin_trgm_ops"},
        ),
    )


class Route(Base):
    __tablename__ = "route"

    dataset_version_id: Mapped[int] = mapped_column(
        ForeignKey(DV_FK, ondelete="CASCADE"), primary_key=True
    )
    route_id: Mapped[str] = mapped_column(String(80), primary_key=True)
    source: Mapped[str] = mapped_column(String(32))
    raw_id: Mapped[str] = mapped_column(String(64))
    agency_id: Mapped[str | None] = mapped_column(String(64))
    short_name: Mapped[str | None] = mapped_column(String(32))
    long_name: Mapped[str | None] = mapped_column(Text)
    route_type: Mapped[int] = mapped_column(SmallInteger)
    mode: Mapped[str] = mapped_column(String(16), index=True)
    color: Mapped[str | None] = mapped_column(String(6))
    text_color: Mapped[str | None] = mapped_column(String(6))
    # Display grouping: Metro publishes M1 as two direction routes; both share line_key.
    line_key: Mapped[str] = mapped_column(String(80), index=True)
    search_key: Mapped[str] = mapped_column(Text)
    times_approximate: Mapped[bool] = mapped_column(Boolean, default=False)


class Trip(Base):
    __tablename__ = "trip"

    dataset_version_id: Mapped[int] = mapped_column(
        ForeignKey(DV_FK, ondelete="CASCADE"), primary_key=True
    )
    trip_id: Mapped[str] = mapped_column(String(96), primary_key=True)
    route_id: Mapped[str] = mapped_column(String(80))
    service_id: Mapped[str] = mapped_column(String(80))
    headsign: Mapped[str | None] = mapped_column(Text)
    direction_id: Mapped[int | None] = mapped_column(SmallInteger)
    shape_id: Mapped[str | None] = mapped_column(String(96))
    wheelchair_accessible: Mapped[int | None] = mapped_column(SmallInteger)
    bikes_allowed: Mapped[int | None] = mapped_column(SmallInteger)

    __table_args__ = (
        Index("ix_trip_route", "dataset_version_id", "route_id"),
        Index("ix_trip_service", "dataset_version_id", "service_id"),
    )


class StopTime(Base):
    __tablename__ = "stop_time"

    dataset_version_id: Mapped[int] = mapped_column(
        ForeignKey(DV_FK, ondelete="CASCADE"), primary_key=True
    )
    trip_id: Mapped[str] = mapped_column(String(96), primary_key=True)
    stop_sequence: Mapped[int] = mapped_column(Integer, primary_key=True)
    stop_id: Mapped[str] = mapped_column(String(80))
    # Seconds from the service-day reference (may exceed 86400). NULL = interpolated stop.
    arrival_s: Mapped[int | None] = mapped_column(Integer)
    departure_s: Mapped[int | None] = mapped_column(Integer)
    timepoint: Mapped[int | None] = mapped_column(SmallInteger)

    __table_args__ = (
        Index("ix_stop_time_stop_dep", "dataset_version_id", "stop_id", "departure_s"),
    )


class ServiceDate(Base):
    """Calendar × calendar_dates, pre-expanded to concrete dates."""

    __tablename__ = "service_date"

    dataset_version_id: Mapped[int] = mapped_column(
        ForeignKey(DV_FK, ondelete="CASCADE"), primary_key=True
    )
    service_id: Mapped[str] = mapped_column(String(80), primary_key=True)
    date: Mapped[date] = mapped_column(Date, primary_key=True)

    __table_args__ = (Index("ix_service_date_date", "dataset_version_id", "date"),)


class Shape(Base):
    __tablename__ = "shape"

    dataset_version_id: Mapped[int] = mapped_column(
        ForeignKey(DV_FK, ondelete="CASCADE"), primary_key=True
    )
    shape_id: Mapped[str] = mapped_column(String(96), primary_key=True)
    geom: Mapped[Any] = mapped_column(Geometry("LINESTRING", srid=4326, spatial_index=False))


class Transfer(Base):
    __tablename__ = "transfer"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    dataset_version_id: Mapped[int] = mapped_column(ForeignKey(DV_FK, ondelete="CASCADE"))
    from_stop_id: Mapped[str] = mapped_column(String(80))
    to_stop_id: Mapped[str] = mapped_column(String(80))
    transfer_type: Mapped[int] = mapped_column(SmallInteger)
    min_transfer_time: Mapped[int | None] = mapped_column(Integer)

    __table_args__ = (
        Index("ix_transfer_from", "dataset_version_id", "from_stop_id"),
        ForeignKeyConstraint(
            ["dataset_version_id", "from_stop_id"],
            ["stop.dataset_version_id", "stop.stop_id"],
            ondelete="CASCADE",
        ),
    )


class SourceCoverage(Base):
    """Which source snapshot fed which dataset version, with its validity window."""

    __tablename__ = "source_coverage"

    dataset_version_id: Mapped[int] = mapped_column(
        ForeignKey(DV_FK, ondelete="CASCADE"), primary_key=True
    )
    source: Mapped[str] = mapped_column(String(32), primary_key=True)
    snapshot_id: Mapped[int | None] = mapped_column(
        ForeignKey("source_snapshot.id", ondelete="SET NULL")
    )
    # included | excluded
    status: Mapped[str] = mapped_column(String(16))
    reason: Mapped[str | None] = mapped_column(Text)
    feed_start: Mapped[date | None] = mapped_column(Date)
    feed_end: Mapped[date | None] = mapped_column(Date)
    fetched_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    times_approximate: Mapped[bool] = mapped_column(Boolean, default=False)


class Announcement(Base):
    """Operator announcements (ESHOT line notices). Not GTFS-RT; scheduled notices with ranges."""

    __tablename__ = "announcement"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    source: Mapped[str] = mapped_column(String(32))
    line_short_name: Mapped[str | None] = mapped_column(String(32), index=True)
    title: Mapped[str] = mapped_column(Text)
    starts_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    ends_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    fetched_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
