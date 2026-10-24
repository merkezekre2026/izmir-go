"""End-to-end ingestion: acquire → validate → choose → merge → stage → (build graph) → activate.

Failure semantics:
- A source that fails to download or validate falls back to its last known-good snapshot, but
  only if that snapshot is still inside its calendar window. Otherwise it is excluded and the
  exclusion is recorded in `source_coverage` (and shown in /transit/status).
- Any failure after staging marks the staged version `failed`; the active version is untouched.
"""

from __future__ import annotations

import hashlib
from collections.abc import Callable, Sequence
from dataclasses import dataclass, field
from datetime import UTC, date, datetime
from pathlib import Path
from typing import Any

from sqlalchemy import Engine, select, text
from sqlalchemy.orm import Session

from izmirgo.core.logging import get_logger
from izmirgo.db.models import IngestionRun, SourceSnapshot
from izmirgo.ingestion.fetch import FetchError, FetchResult
from izmirgo.ingestion.gtfs import GtfsFeed
from izmirgo.ingestion.merge import Interchange, SourceInput, Station, merge_feeds
from izmirgo.ingestion.publish import activate, apply_retention, mark_failed
from izmirgo.ingestion.sources import GtfsSource
from izmirgo.ingestion.stage import CoverageRow, stage_dataset
from izmirgo.ingestion.validate import ValidationReport, validate_feed

log = get_logger("ingestion.pipeline")

Acquire = Callable[[GtfsSource], FetchResult]
# Builds a routing graph for a staged dataset; returns the routing base URL to record.
GraphBuilder = Callable[[int, Path], str | None]
AfterActivate = Callable[[], None]


@dataclass
class SourceDecision:
    source: str
    included: bool
    reason: str
    snapshot_id: int | None = None
    sha256: str | None = None
    report: ValidationReport | None = None
    input: SourceInput | None = None


@dataclass
class RunResult:
    status: str  # published | unchanged | failed
    dataset_version_id: int | None = None
    decisions: list[SourceDecision] = field(default_factory=list)
    error: str | None = None


def _sha_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def _validate(
    path: Path, today: date, bbox: tuple[float, float, float, float], prev: dict[str, int] | None
) -> ValidationReport:
    with GtfsFeed(path) as feed:
        return validate_feed(feed, today=today, bbox=bbox, previous_stats=prev)


def _previous_included(session: Session, source: str) -> SourceSnapshot | None:
    return session.scalars(
        select(SourceSnapshot)
        .where(
            SourceSnapshot.source == source,
            SourceSnapshot.status == "valid",
            SourceSnapshot.raw_path.is_not(None),
        )
        .order_by(SourceSnapshot.fetched_at.desc())
        .limit(1)
    ).first()


def _decide_source(
    session: Session,
    source: GtfsSource,
    acquire: Acquire,
    *,
    today: date,
    bbox: tuple[float, float, float, float],
) -> SourceDecision:
    previous = _previous_included(session, source.id)
    prev_stats: dict[str, int] | None = (
        (previous.validation or {}).get("stats") if previous else None
    )
    current_problem: str
    try:
        fetched = acquire(source)
    except FetchError as exc:
        session.add(
            SourceSnapshot(
                source=source.id,
                fetched_at=datetime.now(UTC),
                status="fetch_failed",
                error=str(exc)[:2000],
            )
        )
        session.flush()
        current_problem = f"fetch failed: {exc}"
    else:
        report = _validate(fetched.path, today, bbox, prev_stats)
        snap = SourceSnapshot(
            source=source.id,
            fetched_at=fetched.fetched_at,
            origin_url=fetched.origin_url,
            is_mirror=fetched.is_mirror,
            http_etag=fetched.etag,
            http_last_modified=fetched.last_modified,
            sha256=fetched.sha256,
            raw_path=str(fetched.path),
            feed_start=report.feed_start,
            feed_end=report.feed_end,
            status=report.validity,
            validation=report.to_dict(),
        )
        session.add(snap)
        session.flush()
        if report.usable and report.feed_start and report.feed_end:
            reason = "mirror copy" if fetched.is_mirror else "producer feed"
            return SourceDecision(
                source.id,
                True,
                reason,
                snap.id,
                fetched.sha256,
                report,
                SourceInput(
                    source,
                    fetched.path,
                    report.feed_start,
                    report.feed_end,
                    frozenset(report.drop_trip_ids),
                ),
            )
        current_problem = f"current feed {report.validity}"
        if report.errors:
            current_problem += ": " + ", ".join(i.code for i in report.errors)

    # Fall back to the last known-good snapshot if it still covers today.
    if previous and previous.raw_path and Path(previous.raw_path).exists():
        report = _validate(Path(previous.raw_path), today, bbox, None)
        if report.usable and report.feed_start and report.feed_end:
            return SourceDecision(
                source.id,
                True,
                f"last known good from {previous.fetched_at:%Y-%m-%d} ({current_problem})",
                previous.id,
                previous.sha256,
                report,
                SourceInput(
                    source,
                    Path(previous.raw_path),
                    report.feed_start,
                    report.feed_end,
                    frozenset(report.drop_trip_ids),
                ),
            )
    return SourceDecision(source.id, False, current_problem)


def _active_signature(engine: Engine) -> set[tuple[str, str]] | None:
    with engine.connect() as conn:
        rows = conn.execute(
            text(
                """
                SELECT sc.source, ss.sha256 FROM source_coverage sc
                JOIN dataset_version dv ON dv.id = sc.dataset_version_id AND dv.status = 'active'
                LEFT JOIN source_snapshot ss ON ss.id = sc.snapshot_id
                WHERE sc.status = 'included'
                """
            )
        ).all()
    return {(r[0], r[1]) for r in rows} if rows else None


def run_pipeline(
    engine: Engine,
    sources: Sequence[GtfsSource],
    *,
    acquire: Acquire,
    today: date,
    data_dir: Path,
    bbox: tuple[float, float, float, float],
    interchanges: Sequence[Interchange] = (),
    stations: Sequence[Station] = (),
    graph_builder: GraphBuilder | None = None,
    after_activate: AfterActivate | None = None,
    force: bool = False,
) -> RunResult:
    with Session(engine) as session:
        run = IngestionRun(status="running")
        session.add(run)
        session.commit()
        run_id = run.id

        decisions = [_decide_source(session, s, acquire, today=today, bbox=bbox) for s in sources]
        session.commit()

    result = RunResult(status="failed", decisions=decisions)
    included = [d for d in decisions if d.included and d.input is not None]
    summary: dict[str, Any] = {
        "sources": {d.source: {"included": d.included, "reason": d.reason} for d in decisions}
    }
    dv_id: int | None = None
    try:
        if not included:
            raise RuntimeError("no usable sources")

        signature = {(d.source, d.sha256 or "") for d in included}
        if not force and _active_signature(engine) == signature:
            result.status = "unchanged"
            return result

        merged_dir = data_dir / "merged"
        tmp_path = merged_dir / f"tmp-{run_id}.zip"
        merge = merge_feeds(
            [d.input for d in included if d.input],
            tmp_path,
            version_label=f"run-{run_id}",
            interchanges=interchanges,
            stations=stations,
        )
        sha = _sha_file(tmp_path)
        label = f"{datetime.now(UTC):%Y%m%dT%H%MZ}-{sha[:8]}"
        merged_path = merged_dir / f"{label}.zip"
        tmp_path.replace(merged_path)
        summary["merge"] = {
            "stations_added": merge.stations_added,
            "transfers_added": merge.transfers_added,
            "skipped_interchanges": merge.skipped_interchanges,
        }

        src_by_id = {s.id: s for s in sources}
        coverage = [
            CoverageRow(
                source=d.source,
                snapshot_id=d.snapshot_id,
                status="included" if d.included else "excluded",
                reason=d.reason,
                feed_start=d.input.feed_start if d.input else None,
                feed_end=d.input.feed_end if d.input else None,
                fetched_at=None,
                times_approximate=src_by_id[d.source].times_approximate,
            )
            for d in decisions
        ]
        dv_id = stage_dataset(
            engine,
            merged_path,
            label=label,
            merged_sha256=sha,
            sources=src_by_id,
            coverage=coverage,
        )
        with engine.begin() as conn:
            conn.execute(
                text(
                    "UPDATE source_coverage sc SET fetched_at = ss.fetched_at FROM source_snapshot ss "
                    "WHERE sc.dataset_version_id = :dv AND ss.id = sc.snapshot_id"
                ),
                {"dv": dv_id},
            )
        otp_url = graph_builder(dv_id, merged_path) if graph_builder else None
        activate(engine, dv_id, otp_url=otp_url)
        if after_activate:
            after_activate()
        summary["retention_deleted"] = apply_retention(engine)
        result.status = "published"
        result.dataset_version_id = dv_id
        return result
    except Exception as exc:
        result.error = str(exc)
        log.exception("pipeline_failed", run_id=run_id)
        if dv_id is not None:
            mark_failed(engine, dv_id)
        return result
    finally:
        with Session(engine) as session:
            run_row = session.get(IngestionRun, run_id)
            if run_row is not None:
                run_row.status = result.status
                run_row.finished_at = datetime.now(UTC)
                run_row.dataset_version_id = result.dataset_version_id
                summary["error"] = result.error
                run_row.summary = summary
                session.commit()
