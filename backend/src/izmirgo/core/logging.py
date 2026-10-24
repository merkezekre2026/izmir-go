"""Structured logging. Privacy: never log precise coordinates or full IPs."""

from __future__ import annotations

import logging
import sys

import structlog


def configure_logging(level: str = "INFO", fmt: str = "console") -> None:
    renderer: structlog.types.Processor = (
        structlog.processors.JSONRenderer()
        if fmt == "json"
        else structlog.dev.ConsoleRenderer(colors=False)
    )
    structlog.configure(
        processors=[
            structlog.contextvars.merge_contextvars,
            structlog.processors.add_log_level,
            structlog.processors.TimeStamper(fmt="iso", utc=True),
            structlog.processors.StackInfoRenderer(),
            structlog.processors.format_exc_info,
            renderer,
        ],
        wrapper_class=structlog.make_filtering_bound_logger(logging.getLevelName(level.upper())),
        logger_factory=structlog.PrintLoggerFactory(file=sys.stderr),
        cache_logger_on_first_use=True,
    )


def round_coord(value: float) -> float:
    """Reduce coordinate precision for logs (~100 m)."""
    return round(value, 3)


def truncate_ip(ip: str | None) -> str | None:
    """Keep only the network part of an IP address for logs."""
    if not ip:
        return None
    if ":" in ip:  # IPv6
        return ":".join(ip.split(":")[:3]) + "::"
    parts = ip.split(".")
    return ".".join([*parts[:3], "0"]) if len(parts) == 4 else None


def get_logger(name: str) -> structlog.stdlib.BoundLogger:
    return structlog.get_logger(name)  # type: ignore[no-any-return]
