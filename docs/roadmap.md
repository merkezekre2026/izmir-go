# Roadmap

## Phased implementation plan

Dependency order:

0 → 1 → 2 → 3 → 4 → 6 → 7 → 8 → 9

Phase 5 can start after Phase 1 (plus a contract draft from 3a) and run alongside 3–4. That is optional, not forced.

### Phase 0 — Environment & external prerequisites
- **Objective:** remove the blockers found in research before writing code.
- **Tasks:**
  - From a candidate production host (Türkiye region recommended), confirm downloads of `eshot.gov.tr` GTFS and an OSM extract.
  - Fetch the current ESHOT feed and record its validity window.
  - Contact the İBB open-data team / İZDENİZ / İZBAN about updated GTFS (non-blocking).
  - Read the portal's Terms of Use.
  - Install Flutter 3.47.x in dev environments, and arrange macOS + Xcode access for iOS.
  - Decide bundle IDs and the developer accounts' owner.
- **Files:** none in the repo (findings go into `docs/data-sources.md` in Phase 1).
- **Acceptance:** every B4 item has been either verified or explicitly assigned a fallback.
- **Risk:** ESHOT unreachable from any affordable host → use the Mobility Database mirror with strict expiry handling, and surface "bus data may be outdated" in status.

### Phase 1 — Repository foundation & tooling
- **Files:**
  - Root: `README.md`, `CLAUDE.md`, `.gitignore`, `.editorconfig`, `.env.example`, `Makefile`.
  - `docs/architecture.md`, `docs/data-sources.md`, `docs/adr/0001-monorepo.md` … `0012-*.md` (one per C-decision).
  - `data/sources.yaml`.
  - `backend/pyproject.toml` (ruff, mypy strict, pytest), `backend/src/izmirgo/core/config.py`, `backend/src/izmirgo/api/app.py` (health only), `backend/Dockerfile`.
  - `infra/compose/compose.yaml` (postgis, api), `compose.dev.yaml`.
  - `.github/workflows/backend.yml`, `.github/workflows/contracts.yml` (skeleton).
  - `scripts/bootstrap.sh`, `scripts/dev-up.sh`.
- **Tasks:**
  - Pin tool versions.
  - CLAUDE.md documents the commands and the hard rules: no fabricated data; namespaced IDs; generated code is never hand-edited; tests use fixtures.
- **Validation:** `make lint test` → `uv run ruff check`, `uv run mypy src`, `uv run pytest`; `docker compose up` → `curl :8000/api/v1/health` returns 200.
- **Acceptance:** a fresh clone gets a running health endpoint and green CI with one command sequence documented in the README.

### Phase 2 — Transit data discovery, fixtures & ingestion
- **Files:**
  - `backend/src/izmirgo/ingestion/*`, `backend/src/izmirgo/db/models/*`, `backend/migrations/versions/0001_transit_catalog.py`.
  - `backend/src/izmirgo/domain/{ids,search_text}.py`.
  - `data/interchanges.csv`, `data/stations.csv`.
  - `backend/tests/fixtures/gtfs/synthetic/{mini-metro,mini-tram,mini-bus,broken-*,expired}/`.
  - `backend/tests/ingestion/*`.
- **Tasks:**
  1. `sources.yaml`-driven fetcher with conditional GET (ETag), size cap (100 MB), content-type/ZIP magic check (catches İZDENİZ's HTML), SHA-256, and a raw archive store.
  2. Structural validation: required files and columns, parseable times, referential integrity. Then run the MobilityData gtfs-validator; ERROR-level notices block the source.
  3. Semantic checks:
     - calendar window covers today (otherwise the source is marked `expired` and excluded from routing)
     - stop coords inside the İzmir bbox
     - monotonic stop_times
     - plausible trip durations
     - duplicate trips
     - row-count deltas versus the previous snapshot (>30% drop → quarantine)
  4. Normalize: namespace IDs; map ESHOT `route_short_name` to the display line; group Metro's direction routes; Turkish search folding (ç→c, ğ→g, ı/İ→i, ö→o, ş→s, ü→u).
  5. Merge into one GTFS plus curated `transfers.txt` and `parent_station` (hand-curated `interchanges.csv` with distances measured from verified coordinates).
  6. Stage into Postgres under a new `dataset_version`, pre-expand `service_date`, and run post-load checks. The active pointer is *not* flipped yet (Phase 4 adds the OTP gate).
  7. **Gated spike — İZDENİZ derived GTFS** from `iskelesefersaatleri` + `vapursaatleri`. Gate: every derived trip has consistent O-D times, matches the API for a sample of pairs/days, passes the validator, and is labelled `derived` in provenance. Otherwise ferries are timetable-only.
  8. **Gated spike — İZBAN derived GTFS** from `sefersaatleri`. Expected to fail the gate, because the API has no day-type and no trip identity. Default: timetable-only.
  9. Ingest ESHOT announcements CSV.
- **Validation:** `uv run pytest tests/ingestion`; `uv run izmirgo-ingest run --sources data/sources.yaml --dry-run` against real feeds (manual / nightly).
- **Acceptance:**
  - Fixture tests cover after-midnight trips, an expired calendar, a missing column, an orphan stop_time, colliding IDs, HTML-instead-of-ZIP, and last-known-good retention on failure.
  - A real run produces a merged feed with zero validator ERRORs for metro + tram.
- **Risks:** ESHOT feed size (≈18 MB zip / 97 MB unzipped / 2.1M rows) → stream with COPY, never with ORM inserts.

### Phase 3 — Backend API & database
- **Files:**
  - `backend/src/izmirgo/api/routers/{status,stops,routes,departures,nearby,alerts,catalog,places}.py`, `api/schemas/*`, `api/errors.py`.
  - `domain/{departures,nearby,freshness}.py`.
  - `providers/izmir_openapi/*`, `providers/geocoding/*`.
  - `core/{http,cache}.py`.
  - `contracts/openapi.json`, `scripts/gen-contracts.sh`.
  - `backend/tests/{unit,integration,contract}/*`, `tests/fixtures/upstream/*.json` (recorded, verified responses).
- **Tasks:**
  - Implement all non-journey endpoints.
  - ESHOT live adapter: decimal-comma parsing, X/Y swap, `204` → empty.
  - Departures across D/D-1, problem+json errors, Caddy and slowapi limits, `/metrics`.
  - Generate OpenAPI, and CI diffs the committed copy.
- **Validation:** `uv run pytest -m "not otp"` (integration tests use testcontainers PostGIS); `scripts/gen-contracts.sh && git diff --exit-code contracts/`.
- **Acceptance:**
  - A departures test at 00:30 returns previous-service-day trips (from the 24:xx fixture).
  - Nearby returns correct ordering.
  - Upstream-failure tests show circuit-open behaviour and the live section degrading to `UPSTREAM_UNAVAILABLE` while scheduled data still returns.

### Phase 4 — Routing engine integration & journey correctness
- **Files:**
  - `infra/otp/{build-config,router-config,otp-config}.json`.
  - `backend/src/izmirgo/ingestion/{otp_build,publish}.py`.
  - `providers/otp/{client.py,mapper.py,queries/plan.graphql}`, `api/routers/journeys.py`.
  - `scripts/fetch-osm.sh` (download + `osmium extract` to the İzmir province bbox).
  - `backend/tests/fixtures/osm/*.pbf`, `backend/tests/integration/test_journeys_otp.py`.
- **Tasks:**
  - Graph build per dataset version (`opentripplanner:2.10.0 --build --save`).
  - Blue/green OTP container swap, then `/health/ready` passes, then a single-transaction flip of `active_dataset` (+ OTP URL). Roll back to the previous version on failure.
  - Map OTP itineraries to the contract and add coverage warnings.
  - Measure build/serve memory with real data and record it in an ADR.
- **Validation:** `make test-otp` (compose.test with a fixture GTFS + small OSM clip).
- **Acceptance (fixture):**
  - Origin near fixture-Metro stop A, destination near fixture-Tram stop D, Wednesday 08:00. The best journey has a metro leg and then a tram leg, with a walk transfer of ≤ 400 m using the curated interchange.
  - Times are monotonic, and every trip_id exists in the active dataset.
  - With the bus source marked expired, bus legs never appear and the `SOURCE_OUT_OF_VALIDITY` warning does.
- **Risk:** OTP heap with full ESHOT data. Measure it. Fallbacks: lower `maxTransferDuration`, a bigger VM, or evaluate MOTIS.

### Phase 5 — Flutter foundation & design system
- **Files:**
  - `apps/mobile/**` (created with `flutter create --org <org> --platforms ios,android`), `packages/api_client/` (generated).
  - `lib/app/*`, `lib/core/*`, `lib/ui/core/design_system/*`, `lib/l10n/app_tr.arb`.
  - Flavor config in `android/app/build.gradle.kts` and iOS xcconfigs/schemes.
  - `analysis_options.yaml` (strict-casts, strict-inference, strict-raw-types, plus a lint set).
  - `.github/workflows/mobile.yml`.
- **Tasks:**
  - Riverpod ProviderScope with overridable service providers.
  - go_router shell with 4 tabs.
  - Theme from tokens.
  - Component gallery (a dev-only route).
  - Drift DB v1 (catalog, favorites, recent_places, cached_journeys) with a schema dump.
  - `ScreenState`, `AppFailure` mapping from problem+json.
- **Validation:** `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test`, `dart run build_runner build --delete-conflicting-outputs` (clean diff), `flutter build apk --flavor dev --debug`.
- **Acceptance:** the app runs on Android/iOS simulators with tabs and empty states. Component widget tests pass, including semantics labels and 48dp tap targets (`meetsGuideline(androidTapTargetGuideline)`, `textContrastGuideline`, `labeledTapTargetGuideline`).

### Phase 6 — Search, maps & journey results
- **Files:** `lib/ui/{journey_search,place_picker,journey_results,journey_detail,map}/**`, `lib/data/repositories/{journeys,places}_repository.dart`, `lib/data/services/location_service.dart`, matching tests.
- **Tasks:**
  - Place search with debounce and cancellation.
  - Location permission requested only on "Konumum" or the map's locate button.
  - MapLibre with a configurable style URL, polylines, and markers.
  - Synchronized map/timeline.
  - Coverage-warning rendering.
- **Validation:** widget tests with a fake `ApiService`; `integration_test/journey_flow_test.dart` against `compose.test` on an Android emulator (nightly).
- **Acceptance:** the deterministic fixture journey (Phase 4) renders as 2+ alternatives. Detail shows metro → walk → tram with the "Tarifeye göre" tag. Permission denial still allows manual search.

### Phase 7 — Stops, schedules, favorites & offline
- **Files:** `lib/ui/{stop_detail,lines,line_detail,nearby,favorites,settings,data_sources}/**`, `lib/data/repositories/{stops,lines,departures,favorites,catalog_sync,transit_status}_repository.dart`, Drift DAOs plus migration tests.
- **Tasks:**
  - Catalog sync via `/catalog/snapshot` ETag: on launch if older than 24 h, plus a manual refresh.
  - Local-then-remote streams (the official offline-first pattern).
  - Departures cached only for their service date, and shown as "Önbellek · 14:05".
  - Live approaching-vehicles polled every 20 s only while the screen is visible (lifecycle-aware).
  - Favorites stored local-only.
  - Storage budget about 20 MB, with LRU for cached journeys (max 10, dropped after their end time).
  - Schema change → Drift migration. If the catalog format changes → wipe and re-sync the catalog, keeping favorites.
- **Acceptance:**
  - Airplane-mode test: stops, lines and favorites work; journey search shows an offline error; no "live" badge appears.
  - A favorite whose stop ID disappears in a new dataset is flagged as "artık mevcut değil" rather than silently dropped.

### Phase 8 — Integration testing, security, accessibility, performance
- **Tasks:**
  - OWASP API review: input bounds and bbox limits, no SSRF (provider URLs fixed in config), dependency audit (`pip-audit`, `flutter pub outdated`), container scan.
  - TalkBack and VoiceOver manual pass, 200% text scale, reduced motion.
  - API p95 latency targets: catalog < 150 ms, journeys < 2 s.
  - App cold start < 2.5 s on a mid-range Android.
  - Nightly real-data job (`data-nightly.yml`): fetch, validate, plan 5 golden real journeys, and report only — no publish from CI.
- **Acceptance:** all CI checks green; an accessibility checklist in `docs/` signed off; load test (k6 or locust) on staging.

### Phase 9 — Release preparation & deployment
- **Files:** `infra/compose/compose.yaml` (prod profile), `infra/caddy/Caddyfile`, `infra/ops/*`, `docs/release.md`, `docs/privacy-kvkk.md`, store metadata in Turkish.
- **Tasks:**
  - VM provisioning runbook.
  - Daily `pg_dump` plus raw-feed archive to off-site object storage, with restore drill. Targets: RPO 24 h; RTO 4 h.
  - Ingestion timer at 03:00 and 15:00 Europe/Istanbul.
  - Uptime check on `/health/ready` and an alert on dataset age / source expiry ≤ 7 days.
  - Android: release keystore (kept outside the repo; Play App Signing), meet current Play target-API requirement (verify at release), data-safety form.
  - iOS: Apple Developer Program, App ID, provisioning, privacy nutrition labels, Turkish location usage string.
  - Privacy policy URL; "resmî uygulama değildir" disclaimer; no İBB/operator logos.
- **Acceptance:** TestFlight and Play internal-testing builds pointing at production show the real active dataset in "Veri kaynakları".

## First-release acceptance criteria

1. **Deterministic fixture E2E** (CI, synthetic data, labelled as such):
   - The app searches from fixture point A to fixture point D on fixture Wednesday 08:00.
   - It shows ≥ 2 alternatives, and the first is metro + curated walk transfer + tram.
   - Detail opens with a map polyline and timeline. All times show "Tarifeye göre".
2. **Real-data multimodal scenario** (staging, against the active dataset built from **verified Metro + Tram feeds**):
   - From Ege Üniversitesi metro (38.4600, 27.2283) to Alsancak Stadyumu tram area, on a weekday at 08:00 within the feed validity window.
   - It returns ≥ 1 journey containing an `M1` leg and a Tram leg joined by a walk transfer of ≤ 400 m (Halkapınar or Çankaya–Gazi Bulvarı).
   - Every trip_id resolves in `dataset_version`.
   - `/transit/status` shows `metro` and `tram` valid to 2027-07.
   - Mock data does **not** count for this criterion.
3. **Bus (conditional):** if a current ESHOT feed is active, a Narlıdere → Bornova journey includes ≥ 1 ESHOT leg. If the feed is expired, journeys carry `SOURCE_OUT_OF_VALIDITY` and contain no bus legs.
4. **Stop detail** for an ESHOT stop shows scheduled departures, plus a separately labelled live section from the real API, or a "Canlı veri alınamadı" state.
5. **Offline:** with the network off, the cached catalog and favorites work, every cached item shows its timestamp, and nothing is labelled live.
6. **Data honesty audit:** no screen shows fares, minute-ETAs, or alerts not sourced from an upstream. "Veri kaynakları" lists each source's validity and attribution, including CC BY 4.0 and OSM ODbL.
7. **Operations:** a failed ingestion (simulated corrupt ZIP) leaves the previous dataset active and visible as stale in status.

## Decision register

**Made confidently:**
- MVVM with Riverpod 3, go_router, Drift, dio, freezed.
- FastAPI + PostGIS; OTP 2.10 behind an adapter.
- Merged, namespaced GTFS with curated transfers.
- MapLibre with a remote-configurable style.
- Live data kept separate from schedules.
- No accounts in v1; local favorites.
- CC BY 4.0 attribution; no fares in v1.

**Need further research (scheduled in a phase):**
- ESHOT reachability and current feed (P0).
- Ferry/İZBAN derived feeds (P2 gates).
- OTP memory with full bus data (P4).
- Photon licence and self-host size (P3).
- Drift native SQLite setup and openapi-generator Dart options (P1/P5).
- İzmir OpenAPI rate limits/terms (P0).
- KVKK: whether coordinates in transient requests plus IP logs count as personal data needing an aydınlatma metni, and VERBİS obligations. This goes to **professional legal review**; the plan minimizes data either way.

**Need user input (defaults proposed):**
1. App identifier / org: default `com.example.izmirgo` placeholder until provided.
2. Hosting region and budget: default one Türkiye-region 8–16 GB VM.
3. Store accounts owner (Apple/Google): required before Phase 9.
4. Expired-timetable behaviour: default never route on expired feeds; show a warning instead.
5. Whether to approach İBB/operators about feed fixes: default yes, non-blocking.
6. Brand identity (name clearance for "İzmir Go", colors): default neutral "Körfez" blue/teal tokens with mode colors taken from the data.
