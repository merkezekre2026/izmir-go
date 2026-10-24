"""Atomic activation, rollback and retention of dataset versions."""

from __future__ import annotations

from sqlalchemy import Engine, text

from izmirgo.core.logging import get_logger

log = get_logger("ingestion.publish")
KEEP_RETIRED = 1  # previous version kept for instant rollback


class PublishError(RuntimeError):
    pass


def activate(engine: Engine, dataset_version_id: int, *, otp_url: str | None = None) -> None:
    """Make a staged version active and retire the current one, in a single transaction."""
    with engine.begin() as conn:
        status = conn.execute(
            text("SELECT status FROM dataset_version WHERE id = :id FOR UPDATE"),
            {"id": dataset_version_id},
        ).scalar_one_or_none()
        if status != "staged":
            raise PublishError(f"dataset {dataset_version_id} is {status!r}, expected 'staged'")
        conn.execute(text("UPDATE dataset_version SET status = 'retired' WHERE status = 'active'"))
        conn.execute(
            text(
                "UPDATE dataset_version SET status = 'active', published_at = now(), "
                "otp_url = COALESCE(:otp, otp_url) WHERE id = :id"
            ),
            {"id": dataset_version_id, "otp": otp_url},
        )
    log.info("activated", dataset_version_id=dataset_version_id)


def mark_failed(engine: Engine, dataset_version_id: int) -> None:
    with engine.begin() as conn:
        conn.execute(
            text(
                "UPDATE dataset_version SET status = 'failed' WHERE id = :id AND status = 'staged'"
            ),
            {"id": dataset_version_id},
        )


def rollback(engine: Engine) -> int:
    """Re-activate the most recent retired version. Returns its id."""
    with engine.begin() as conn:
        previous = conn.execute(
            text(
                "SELECT id FROM dataset_version WHERE status = 'retired' "
                "ORDER BY published_at DESC NULLS LAST, id DESC LIMIT 1 FOR UPDATE"
            )
        ).scalar_one_or_none()
        if previous is None:
            raise PublishError("no retired dataset to roll back to")
        conn.execute(text("UPDATE dataset_version SET status = 'failed' WHERE status = 'active'"))
        conn.execute(
            text(
                "UPDATE dataset_version SET status = 'active', published_at = now() WHERE id = :id"
            ),
            {"id": previous},
        )
    log.warning("rolled_back", dataset_version_id=previous)
    return int(previous)


def apply_retention(engine: Engine, keep_retired: int = KEEP_RETIRED) -> list[int]:
    """Delete old retired/failed versions (cascades to all transit rows)."""
    with engine.begin() as conn:
        ids = [
            int(r)
            for r in conn.execute(
                text(
                    """
                    SELECT id FROM (
                        SELECT id, status, row_number() OVER (
                            PARTITION BY status ORDER BY published_at DESC NULLS LAST, id DESC
                        ) AS rn FROM dataset_version WHERE status IN ('retired', 'failed')
                    ) x WHERE (status = 'retired' AND rn > :keep) OR (status = 'failed' AND rn > 1)
                    """
                ),
                {"keep": keep_retired},
            ).scalars()
        ]
        if ids:
            conn.execute(text("DELETE FROM dataset_version WHERE id = ANY(:ids)"), {"ids": ids})
    if ids:
        log.info("retention_deleted", dataset_version_ids=ids)
    return ids


def active_dataset_id(engine: Engine) -> int | None:
    with engine.connect() as conn:
        value = conn.execute(
            text("SELECT id FROM dataset_version WHERE status = 'active'")
        ).scalar_one_or_none()
    return int(value) if value is not None else None
