"""Download GTFS archives with integrity checks.

- Tries the producer URL first, then mirrors, in order.
- Rejects responses that are not ZIP archives (the İZDENİZ URL serves an HTML page with 200 OK).
- Caps download size, computes SHA-256, and stores raw files content-addressed.
"""

from __future__ import annotations

import hashlib
import shutil
import tempfile
import zipfile
from dataclasses import dataclass
from datetime import UTC, datetime
from pathlib import Path

import httpx

from izmirgo.core.logging import get_logger
from izmirgo.ingestion.sources import GtfsSource

MAX_ARCHIVE_BYTES = 100 * 1024 * 1024
MAX_UNCOMPRESSED_BYTES = 1024 * 1024 * 1024  # zip-bomb guard
ZIP_MAGIC = b"PK\x03\x04"

log = get_logger("ingestion.fetch")


class FetchError(RuntimeError):
    pass


@dataclass(frozen=True)
class FetchResult:
    source_id: str
    origin_url: str
    is_mirror: bool
    path: Path
    sha256: str
    size: int
    etag: str | None
    last_modified: str | None
    fetched_at: datetime


def _check_zip(path: Path) -> None:
    with path.open("rb") as fh:
        if fh.read(4) != ZIP_MAGIC:
            raise FetchError("response is not a ZIP archive")
    try:
        with zipfile.ZipFile(path) as zf:
            total = sum(i.file_size for i in zf.infolist())
            if total > MAX_UNCOMPRESSED_BYTES:
                raise FetchError(f"archive expands to {total} bytes, over the limit")
            bad = zf.testzip()
            if bad is not None:
                raise FetchError(f"corrupt member in archive: {bad}")
    except zipfile.BadZipFile as exc:
        raise FetchError(f"bad zip: {exc}") from exc


def _download(client: httpx.Client, url: str, dest: Path) -> tuple[str | None, str | None]:
    with client.stream("GET", url) as res:
        if res.status_code != 200:
            raise FetchError(f"HTTP {res.status_code}")
        declared = int(res.headers.get("content-length") or 0)
        if declared > MAX_ARCHIVE_BYTES:
            raise FetchError(f"declared size {declared} over limit")
        size = 0
        with dest.open("wb") as out:
            for chunk in res.iter_bytes(1 << 16):
                size += len(chunk)
                if size > MAX_ARCHIVE_BYTES:
                    raise FetchError("download exceeded size limit")
                out.write(chunk)
        return res.headers.get("etag"), res.headers.get("last-modified")


def _sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def fetch_source(
    source: GtfsSource,
    raw_dir: Path,
    *,
    client: httpx.Client | None = None,
    user_agent: str = "IzmirGo-Ingest/0.1",
) -> FetchResult:
    """Fetch the first working URL for `source`; raise FetchError if every URL fails."""
    owns_client = client is None
    client = client or httpx.Client(
        timeout=httpx.Timeout(60.0, connect=10.0),
        follow_redirects=True,
        headers={"user-agent": user_agent},
    )
    errors: list[str] = []
    try:
        for index, url in enumerate(source.urls):
            with tempfile.NamedTemporaryFile(delete=False, suffix=".zip") as tmp:
                tmp_path = Path(tmp.name)
            try:
                etag, last_modified = _download(client, url, tmp_path)
                _check_zip(tmp_path)
                digest = _sha256(tmp_path)
                target_dir = raw_dir / source.id
                target_dir.mkdir(parents=True, exist_ok=True)
                target = target_dir / f"{digest}.zip"
                if not target.exists():
                    shutil.move(tmp_path, target)
                log.info("fetched", source=source.id, url=url, sha256=digest[:12])
                return FetchResult(
                    source_id=source.id,
                    origin_url=url,
                    is_mirror=index > 0,
                    path=target,
                    sha256=digest,
                    size=target.stat().st_size,
                    etag=etag,
                    last_modified=last_modified,
                    fetched_at=datetime.now(UTC),
                )
            except (httpx.HTTPError, FetchError, OSError) as exc:
                errors.append(f"{url}: {exc}")
                log.warning("fetch_failed", source=source.id, url=url, error=str(exc))
            finally:
                tmp_path.unlink(missing_ok=True)
    finally:
        if owns_client:
            client.close()
    raise FetchError("; ".join(errors))
