"""Build an OpenTripPlanner graph for a staged dataset and serve it blue/green.

Flow for dataset version N:
1. var/otp/graphs/dv-N/ gets the merged GTFS, the OSM extract (if configured) and the config.
2. `opentripplanner --build --save` writes graph.obj (fails → pipeline marks N failed).
3. The *inactive* slot container is replaced with one serving dv-N.
4. A smoke check (feed present, stops indexed) must pass before the pipeline activates N.
5. After activation the other slot is stopped, so the previous graph stays available until the
   new one is live.
"""

from __future__ import annotations

import json
import shutil
import subprocess
import time
from dataclasses import dataclass, field
from pathlib import Path

import httpx

from izmirgo.core.config import Settings
from izmirgo.core.logging import get_logger
from izmirgo.providers.otp import FEED_ID

log = get_logger("ingestion.otp_build")
REPO_ROOT = Path(__file__).resolve().parents[4]
OTP_IMAGE = "opentripplanner/opentripplanner:2.10.0"


class GraphBuildError(RuntimeError):
    pass


def _docker(*args: str, timeout: float = 3600) -> subprocess.CompletedProcess[str]:
    docker = shutil.which("docker")
    if docker is None:
        raise GraphBuildError("docker CLI not found")
    return subprocess.run(  # noqa: S603 - fixed binary, arguments built from our own config
        [docker, *args], capture_output=True, text=True, timeout=timeout, check=False
    )


def build_config(has_osm: bool) -> dict[str, object]:
    config: dict[str, object] = json.loads((REPO_ROOT / "infra/otp/build-config.json").read_text())
    config["transitFeeds"] = [{"type": "gtfs", "source": "izmirgo.gtfs.zip", "feedId": FEED_ID}]
    if not has_osm:
        config.pop("osm", None)
    return config


@dataclass
class OtpGraphBuilder:
    graphs_dir: Path
    osm_path: Path | None = None
    image: str = OTP_IMAGE
    build_heap: str = "-Xmx6g"
    serve_heap: str = "-Xmx4g"
    slots: tuple[tuple[str, int], ...] = (("izmirgo-otp-blue", 8081), ("izmirgo-otp-green", 8082))
    public_host: str = "localhost"
    ready_timeout_s: float = 300.0
    _last_slot: str | None = field(default=None, init=False)

    @classmethod
    def from_settings(cls, settings: Settings) -> OtpGraphBuilder:
        return cls(
            graphs_dir=settings.data_dir / "otp" / "graphs",
            osm_path=settings.osm_path
            if settings.osm_path and settings.osm_path.exists()
            else None,
        )

    # -- build ------------------------------------------------------------------------------
    def build(self, dataset_version_id: int, merged_path: Path) -> Path:
        work = self.graphs_dir / f"dv-{dataset_version_id}"
        if work.exists():
            shutil.rmtree(work)
        work.mkdir(parents=True)
        shutil.copyfile(merged_path, work / "izmirgo.gtfs.zip")
        if self.osm_path:
            shutil.copyfile(self.osm_path, work / "izmir.osm.pbf")
        (work / "build-config.json").write_text(
            json.dumps(build_config(self.osm_path is not None), indent=2)
        )
        shutil.copyfile(REPO_ROOT / "infra/otp/router-config.json", work / "router-config.json")
        started = time.monotonic()
        proc = _docker(
            "run", "--rm",
            "-e", f"JAVA_TOOL_OPTIONS={self.build_heap}",
            "-v", f"{work.resolve()}:/var/opentripplanner",
            self.image, "--build", "--save",
        )  # fmt: skip
        (work / "build.log").write_text(proc.stdout + proc.stderr)
        if proc.returncode != 0 or not (work / "graph.obj").exists():
            raise GraphBuildError(
                f"OTP build failed (exit {proc.returncode}); see {work / 'build.log'}"
            )
        log.info(
            "otp_graph_built",
            dataset_version_id=dataset_version_id,
            seconds=round(time.monotonic() - started),
        )
        return work

    # -- serve ------------------------------------------------------------------------------
    def _running_slot(self) -> str | None:
        for name, _ in self.slots:
            proc = _docker("inspect", "-f", "{{.State.Running}}", name, timeout=30)
            if proc.returncode == 0 and proc.stdout.strip() == "true":
                return name
        return None

    def serve(self, work: Path) -> str:
        current = self._running_slot()
        name, port = next(((n, p) for n, p in self.slots if n != current), self.slots[0])
        _docker("rm", "-f", name, timeout=60)
        proc = _docker(
            "run", "-d", "--name", name,
            "-p", f"{port}:8080",
            "-e", f"JAVA_TOOL_OPTIONS={self.serve_heap}",
            "-v", f"{work.resolve()}:/var/opentripplanner:ro",
            self.image, "--load", "--serve",
        )  # fmt: skip
        if proc.returncode != 0:
            raise GraphBuildError(f"could not start {name}: {proc.stderr.strip()[:300]}")
        url = f"http://{self.public_host}:{port}"
        self._wait_ready(url)
        self._last_slot = name
        log.info("otp_serving", slot=name, url=url)
        return url

    def _wait_ready(self, url: str) -> None:
        deadline = time.monotonic() + self.ready_timeout_s
        query = {"query": "{ feeds { feedId } stops { gtfsId } }"}
        while time.monotonic() < deadline:
            try:
                res = httpx.post(f"{url}/otp/gtfs/v1", json=query, timeout=5.0)
                if res.status_code == 200:
                    data = res.json().get("data") or {}
                    feeds = {f["feedId"] for f in data.get("feeds") or []}
                    if FEED_ID in feeds and data.get("stops"):
                        return
                    raise GraphBuildError(f"OTP smoke check failed: feeds={feeds}")
            except httpx.HTTPError:
                pass
            time.sleep(2)
        raise GraphBuildError(f"OTP at {url} not ready after {self.ready_timeout_s}s")

    def retire_others(self) -> None:
        """Stop every slot except the one serving the newly activated dataset."""
        for name, _ in self.slots:
            if name != self._last_slot:
                _docker("rm", "-f", name, timeout=60)

    def __call__(self, dataset_version_id: int, merged_path: Path) -> str:
        return self.serve(self.build(dataset_version_id, merged_path))
