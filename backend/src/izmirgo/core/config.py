"""Runtime configuration, read from environment variables prefixed with IZMIRGO_."""

from __future__ import annotations

from functools import lru_cache
from pathlib import Path
from typing import Literal

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_prefix="IZMIRGO_", env_file=".env", extra="ignore")

    env: Literal["dev", "test", "staging", "prod"] = "dev"
    database_url: str = "postgresql+psycopg://izmirgo:izmirgo@localhost:5432/izmirgo"
    otp_url: str = "http://localhost:8080"
    izmir_openapi_url: str = "https://openapi.izmir.bel.tr/api"
    photon_url: str = "https://photon.komoot.io"
    data_dir: Path = Path("./var")
    # Clipped İzmir OSM extract for OTP walking (scripts/fetch-osm.sh). Optional.
    osm_path: Path | None = None
    sources_file: Path = Path(__file__).resolve().parents[4] / "data" / "sources.yaml"
    log_format: Literal["json", "console"] = "console"
    log_level: str = "INFO"

    # Upstream HTTP behaviour
    upstream_connect_timeout_s: float = 3.0
    upstream_read_timeout_s: float = 5.0
    live_cache_ttl_s: float = Field(default=15.0, ge=1.0)

    # Coverage area: İzmir province bounding box (lon_min, lat_min, lon_max, lat_max)
    coverage_bbox: tuple[float, float, float, float] = (26.2, 37.8, 28.5, 39.4)

    user_agent: str = "IzmirGo/0.1 (+https://github.com/merkezekre2026/izmir-go)"


@lru_cache
def get_settings() -> Settings:
    return Settings()
