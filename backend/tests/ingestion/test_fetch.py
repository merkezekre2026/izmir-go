from pathlib import Path

import httpx
import pytest
import respx

from izmirgo.ingestion.fetch import FetchError, fetch_source
from izmirgo.ingestion.sources import GtfsSource

SRC = GtfsSource(
    id="metro",
    operator="Fixture",
    mode="metro",
    url="https://producer.invalid/feed.zip",
    mirrors=("https://mirror.invalid/feed.zip",),
)


@respx.mock
def test_html_instead_of_zip_falls_back_to_mirror(tmp_path: Path, feed_zip) -> None:  # type: ignore[no-untyped-def]
    respx.get(SRC.url).mock(return_value=httpx.Response(200, text="<!doctype html><html></html>"))
    respx.get(SRC.mirrors[0]).mock(
        return_value=httpx.Response(
            200, content=feed_zip("fx_metro").read_bytes(), headers={"etag": '"x"'}
        )
    )
    res = fetch_source(SRC, tmp_path / "raw")
    assert res.is_mirror
    assert res.origin_url == SRC.mirrors[0]
    assert res.path.exists() and res.path.name == f"{res.sha256}.zip"
    assert res.etag == '"x"'


@respx.mock
def test_all_urls_failing_raises(tmp_path: Path) -> None:
    respx.get(SRC.url).mock(return_value=httpx.Response(503))
    respx.get(SRC.mirrors[0]).mock(side_effect=httpx.ConnectError("reset"))
    with pytest.raises(FetchError) as exc:
        fetch_source(SRC, tmp_path / "raw")
    assert "HTTP 503" in str(exc.value)
    assert "reset" in str(exc.value)


@respx.mock
def test_corrupt_zip_rejected(tmp_path: Path) -> None:
    respx.get(SRC.url).mock(return_value=httpx.Response(200, content=b"PK\x03\x04garbage"))
    respx.get(SRC.mirrors[0]).mock(return_value=httpx.Response(404))
    with pytest.raises(FetchError):
        fetch_source(SRC, tmp_path / "raw")
