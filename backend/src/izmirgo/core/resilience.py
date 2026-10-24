"""Resilience helpers for upstream calls: circuit breaker, TTL cache with single-flight, rate limit."""

from __future__ import annotations

import asyncio
import time
from collections import OrderedDict
from collections.abc import Awaitable, Callable
from dataclasses import dataclass


class CircuitOpen(RuntimeError):
    """Raised instead of calling an upstream that has been failing."""


@dataclass
class CircuitBreaker:
    """Opens after `threshold` consecutive failures; half-opens after `reset_after_s`."""

    name: str
    threshold: int = 5
    reset_after_s: float = 30.0
    clock: Callable[[], float] = time.monotonic
    _failures: int = 0
    _opened_at: float | None = None

    @property
    def state(self) -> str:
        if self._opened_at is None:
            return "closed"
        if self.clock() - self._opened_at >= self.reset_after_s:
            return "half_open"
        return "open"

    def before_call(self) -> None:
        if self.state == "open":
            raise CircuitOpen(self.name)

    def record_success(self) -> None:
        self._failures = 0
        self._opened_at = None

    def record_failure(self) -> None:
        self._failures += 1
        if self._failures >= self.threshold or self.state == "half_open":
            self._opened_at = self.clock()

    async def call[T](self, fn: Callable[[], Awaitable[T]]) -> T:
        self.before_call()
        try:
            result = await fn()
        except Exception:
            self.record_failure()
            raise
        self.record_success()
        return result


class AsyncTTLCache[T]:
    """Small in-process TTL cache. Concurrent misses for one key share a single upstream call."""

    def __init__(
        self, ttl_s: float, max_entries: int = 2048, clock: Callable[[], float] = time.monotonic
    ) -> None:
        self.ttl_s = ttl_s
        self.max_entries = max_entries
        self._clock = clock
        self._data: OrderedDict[str, tuple[float, T]] = OrderedDict()
        self._inflight: dict[str, asyncio.Future[T]] = {}

    def now(self) -> float:
        return self._clock()

    def peek(self, key: str) -> tuple[float, T] | None:
        """Return (stored_at, value) if fresh."""
        item = self._data.get(key)
        if item and self._clock() - item[0] < self.ttl_s:
            return item
        return None

    async def get_or_load(self, key: str, loader: Callable[[], Awaitable[T]]) -> tuple[float, T]:
        hit = self.peek(key)
        if hit is not None:
            return hit
        if key in self._inflight:
            value = await self._inflight[key]
            return self._data.get(key, (self._clock(), value))
        future: asyncio.Future[T] = asyncio.get_running_loop().create_future()
        self._inflight[key] = future
        try:
            value = await loader()
        except BaseException as exc:
            future.set_exception(exc)
            future.exception()  # mark retrieved so waiters-less failures don't warn
            raise
        else:
            stored = (self._clock(), value)
            self._data[key] = stored
            self._data.move_to_end(key)
            while len(self._data) > self.max_entries:
                self._data.popitem(last=False)
            future.set_result(value)
            return stored
        finally:
            self._inflight.pop(key, None)


class FixedWindowRateLimiter:
    """Per-key fixed-window limiter (defence in depth; the edge proxy is the primary limiter)."""

    def __init__(
        self, limit: int, window_s: float = 60.0, clock: Callable[[], float] = time.monotonic
    ) -> None:
        self.limit = limit
        self.window_s = window_s
        self._clock = clock
        self._counts: dict[str, tuple[float, int]] = {}

    def allow(self, key: str) -> tuple[bool, int]:
        """Return (allowed, retry_after_seconds)."""
        now = self._clock()
        start, count = self._counts.get(key, (now, 0))
        if now - start >= self.window_s:
            start, count = now, 0
        if count >= self.limit:
            return False, max(1, int(self.window_s - (now - start)))
        self._counts[key] = (start, count + 1)
        if len(self._counts) > 50_000:  # crude bound on memory
            cutoff = now - self.window_s
            self._counts = {k: v for k, v in self._counts.items() if v[0] >= cutoff}
        return True, 0
