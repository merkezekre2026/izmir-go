"""`izmirgo-ingest` command line."""

from __future__ import annotations

import json
import zipfile
from datetime import UTC, date, datetime
from pathlib import Path
from typing import Annotated

import httpx
import typer
from sqlalchemy import text

from izmirgo.core.config import get_settings
from izmirgo.core.logging import configure_logging
from izmirgo.core.servicetime import ISTANBUL
from izmirgo.db.session import get_engine
from izmirgo.ingestion import publish
from izmirgo.ingestion.fetch import FetchResult, fetch_source
from izmirgo.ingestion.merge import load_interchanges, load_stations
from izmirgo.ingestion.pipeline import run_pipeline
from izmirgo.ingestion.sources import GtfsSource, load_registry

app = typer.Typer(no_args_is_help=True, help="İzmir Go GTFS ingestion")
REPO_ROOT = Path(__file__).resolve().parents[4]
FIXTURE_DIR = REPO_ROOT / "backend" / "tests" / "fixtures"


def _today() -> date:
    return datetime.now(ISTANBUL).date()


@app.command()
def run(
    sources: Annotated[list[str] | None, typer.Option(help="Limit to these source ids")] = None,
    force: Annotated[bool, typer.Option(help="Publish even if inputs are unchanged")] = False,
    build_graph: Annotated[
        bool, typer.Option(help="Build and serve an OTP graph (Docker)")
    ] = False,
) -> None:
    """Fetch real feeds, validate, merge, stage and publish a new dataset version."""
    settings = get_settings()
    configure_logging(settings.log_level, settings.log_format)
    registry = load_registry(settings.sources_file)
    selected = [s for s in registry.gtfs if not sources or s.id in sources]
    raw_dir = settings.data_dir / "raw"
    builder = None
    if build_graph:
        from izmirgo.ingestion.otp_build import OtpGraphBuilder

        builder = OtpGraphBuilder.from_settings(settings)
    result = run_pipeline(
        get_engine(settings.database_url),
        selected,
        acquire=lambda s: fetch_source(s, raw_dir, user_agent=settings.user_agent),
        today=_today(),
        data_dir=settings.data_dir,
        bbox=settings.coverage_bbox,
        interchanges=load_interchanges(REPO_ROOT / "data" / "interchanges.csv"),
        stations=load_stations(REPO_ROOT / "data" / "stations.csv"),
        graph_builder=builder,
        after_activate=builder.retire_others if builder else None,
        force=force,
    )
    for d in result.decisions:
        typer.echo(f"{d.source:8} {'INCLUDED' if d.included else 'excluded':9} {d.reason}")
    typer.echo(f"result: {result.status} dataset={result.dataset_version_id} {result.error or ''}")
    raise typer.Exit(0 if result.status in ("published", "unchanged") else 1)


def fixture_sources() -> list[GtfsSource]:
    """Synthetic fixture feeds registered under real namespaces (see tests/fixtures)."""
    return [
        GtfsSource(
            id="metro", operator="Fixture Metro (SYNTHETIC)", mode="metro", url="fixture:fx_metro"
        ),
        GtfsSource(
            id="tram", operator="Fixture Tram (SYNTHETIC)", mode="tram", url="fixture:fx_tram"
        ),
        GtfsSource(
            id="eshot",
            operator="Fixture Bus (SYNTHETIC)",
            mode="bus",
            url="fixture:fx_bus_expired",
            route_grouping="by_short_name",
            times_approximate=True,
        ),
    ]


def fixture_acquirer(raw_dir: Path):  # type: ignore[no-untyped-def]
    import hashlib

    def acquire(source: GtfsSource) -> FetchResult:
        name = source.url.removeprefix("fixture:")
        src = FIXTURE_DIR / "gtfs" / "synthetic" / name
        raw_dir.mkdir(parents=True, exist_ok=True)
        tmp = raw_dir / f"{name}.zip"
        with zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as zf:
            for p in sorted(src.glob("*.txt")):
                info = zipfile.ZipInfo(
                    p.name, date_time=(2026, 1, 1, 0, 0, 0)
                )  # deterministic hash
                zf.writestr(info, p.read_bytes(), zipfile.ZIP_DEFLATED)
        digest = hashlib.sha256(tmp.read_bytes()).hexdigest()
        return FetchResult(
            source.id,
            source.url,
            False,
            tmp,
            digest,
            tmp.stat().st_size,
            None,
            None,
            datetime.now(UTC),
        )

    return acquire


@app.command("seed-fixtures")
def seed_fixtures(
    today: Annotated[str, typer.Option(help="Pretend date (YYYY-MM-DD)")] = "",
    force: bool = True,
) -> None:
    """Load the SYNTHETIC fixture dataset (no network). For local development and tests."""
    settings = get_settings()
    configure_logging(settings.log_level, settings.log_format)
    result = run_pipeline(
        get_engine(settings.database_url),
        fixture_sources(),
        acquire=fixture_acquirer(settings.data_dir / "raw-fixtures"),
        today=date.fromisoformat(today) if today else _today(),
        data_dir=settings.data_dir,
        bbox=settings.coverage_bbox,
        interchanges=load_interchanges(FIXTURE_DIR / "data" / "interchanges.csv"),
        stations=load_stations(FIXTURE_DIR / "data" / "stations.csv"),
        force=force,
    )
    typer.echo(f"result: {result.status} dataset={result.dataset_version_id} {result.error or ''}")
    raise typer.Exit(0 if result.status in ("published", "unchanged") else 1)


@app.command()
def status() -> None:
    """Show dataset versions and the coverage of the active one."""
    settings = get_settings()
    with get_engine(settings.database_url).connect() as conn:
        for row in conn.execute(
            text(
                "SELECT id, label, status, published_at, summary FROM dataset_version ORDER BY id DESC LIMIT 10"
            )
        ):
            typer.echo(
                f"{row.id:4} {row.status:8} {row.label} {row.published_at} {json.dumps(row.summary)}"
            )
        for row in conn.execute(
            text(
                "SELECT sc.source, sc.status, sc.reason, sc.feed_start, sc.feed_end FROM source_coverage sc "
                "JOIN dataset_version dv ON dv.id = sc.dataset_version_id AND dv.status = 'active'"
            )
        ):
            typer.echo(
                f"  {row.source:8} {row.status:9} {row.feed_start}..{row.feed_end} {row.reason}"
            )


@app.command()
def announcements() -> None:
    """Refresh ESHOT line announcements from the official CSV."""
    from izmirgo.ingestion.announcements import refresh_announcements

    settings = get_settings()
    configure_logging(settings.log_level, settings.log_format)
    url = load_registry(settings.sources_file).static_csv["eshot_announcements"]["url"]
    try:
        count = refresh_announcements(get_engine(settings.database_url), url)
    except httpx.HTTPError as exc:
        typer.echo(f"announcements: fetch failed ({exc}); previous announcements kept", err=True)
        raise typer.Exit(1) from exc
    typer.echo(f"announcements: {count}")


@app.command("stop-directory")
def stop_directory() -> None:
    """Refresh the ESHOT stop directory from the official stops CSV."""
    from izmirgo.ingestion.stop_directory import DirectoryError, refresh_eshot_directory

    settings = get_settings()
    configure_logging(settings.log_level, settings.log_format)
    url = load_registry(settings.sources_file).static_csv["eshot_stops"]["url"]
    try:
        count = refresh_eshot_directory(
            get_engine(settings.database_url), url, settings.coverage_bbox
        )
    except (httpx.HTTPError, DirectoryError) as exc:
        typer.echo(f"stop-directory: {exc}; previous directory kept", err=True)
        raise typer.Exit(1) from exc
    typer.echo(f"stop-directory: {count} ESHOT stops")


@app.command()
def rollback() -> None:
    """Re-activate the previous dataset version."""
    settings = get_settings()
    typer.echo(f"active dataset is now {publish.rollback(get_engine(settings.database_url))}")


if __name__ == "__main__":
    app()
