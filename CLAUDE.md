# CLAUDE.md — working on İzmir Go

## Hard rules
1. **Never fabricate transport data.** No invented fares, ETAs, alerts, holidays or timetables. If a source doesn't provide it, the field is absent and the UI says so.
2. **Scheduled ≠ live ≠ cached.** Every departure or journey carries `basis` (`scheduled` | `live` | `cached`) plus source freshness. Live ESHOT data never modifies scheduled times.
3. **IDs are namespaced:** `{source}:{raw_id}` (`metro:6`, `tram:1`, `eshot:10005`, `izban:21`, `izdeniz:2`, `stn:halkapinar`). Never join operators by name.
4. **Expired feeds are not routed on.** A source outside its calendar window is excluded and produces a `SOURCE_OUT_OF_VALIDITY` warning.
5. **Generated code is not hand-edited:** `contracts/openapi.json`, `packages/api_client/`, `*.g.dart`, `*.freezed.dart`. Regenerate it instead.
6. **Tests use fixtures.** CI must not depend on live upstream services. Fixture data under `backend/tests/fixtures/gtfs/synthetic/` is synthetic and must stay labelled as such.
7. No secrets in the repo. `.env.example` holds placeholders only.

## Commands
| Task | Command |
|---|---|
| Install backend deps | `make backend-install` |
| Lint + types + tests | `make test` (ruff, mypy --strict, pytest) |
| Start PostGIS | `make db-up` |
| Migrations | `make migrate` / `cd backend && uv run alembic revision --autogenerate -m "..."` |
| Ingest real feeds | `make ingest` |
| Load fixtures | `make seed-fixtures` |
| Run API | `make api` |
| Regenerate contract | `make contracts` (CI fails if `contracts/openapi.json` drifts) |
| Mobile checks | `make mobile-check` (never run `dart format` on `*.g.dart` / `*.freezed.dart`: CI compares them with fresh build_runner output) |

## Layout
- `backend/src/izmirgo/core`: config, logging, HTTP (timeouts/retry/circuit breaker), cache, service-day time maths.
- `backend/src/izmirgo/db`: SQLAlchemy models and session. Alembic migrations live in `backend/migrations`.
- `backend/src/izmirgo/domain`: pure logic (IDs, Turkish search folding, departures, nearby, freshness).
- `backend/src/izmirgo/providers`: adapters for upstream systems (İzmir OpenAPI, OTP, geocoding).
- `backend/src/izmirgo/ingestion`: GTFS pipeline: fetch → validate → normalize → merge → stage → publish.
- `backend/src/izmirgo/api`: FastAPI routers, schemas and RFC 9457 errors.
- `apps/mobile/lib`: `ui/<feature>/{view_models,widgets}`, `data/{repositories,services}`, `domain/models`. This follows the official Flutter architecture guide.

## Data quirks worth remembering (verified 2026-10-24)
- ESHOT `route_id` ≠ public line number for many routes; use `route_short_name`.
- ESHOT live API: `KoorX` = latitude, `KoorY` = longitude, both strings with decimal commas.
- GTFS times go beyond 24:00 (up to 26:06). Departures must consider service days D and D-1.
- No current feed has `calendar_dates`, so public holidays are not represented.
- İZBAN GTFS expired 2025-01-01. The İZDENİZ GTFS URL serves HTML.
