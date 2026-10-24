# Architecture decision records

The decisions below were taken in the research phase (2026-10-24). Each ADR file records its status. A decision is superseded by adding a new ADR, not by editing the old one.

## Decision summary

**C1. Flutter state management + DI — Riverpod 3** (`flutter_riverpod 3.4.3`, `riverpod_generator 4.0.9`)
- Alternatives: BLoC (`flutter_bloc 9.1.1`, last published 2025-05), plain `ChangeNotifier` + `provider` (the official guide's example).
- Why Riverpod: one tool covers both DI (repositories and services as providers, with overrides for tests and flavors) and async UI state (`AsyncValue`, with cancellation and invalidation). It maps cleanly onto the guide's View ↔ ViewModel(=`Notifier`) ↔ Repository ↔ Service layering. Less boilerplate than BLoC for many read-heavy screens.
- Trade-offs: code generation and the provider-lifecycle learning curve.
- Risk: Riverpod major-version churn. Mitigation: pin versions and keep providers thin.
- Would change if: the team has strong BLoC experience.

**C2. Navigation — go_router 18.1.1**, with `StatefulShellRoute` for the tabs and typed routes.
- Deep links: `izmirgo://stop/{id}`, `izmirgo://line/{id}`. https universal/app links are deferred until a domain exists.
- Alternative: auto_route. Go_router is first-party and its Flutter ≥ 3.44 requirement is satisfied.

**C3. Local persistence — Drift 2.35.3 (SQLite).**
- Alternatives: Isar/Hive (maintenance concerns), `shared_preferences` (settings only).
- Why Drift: relational cache of about 12k stops, typed queries, migration tooling with schema-dump tests, and the official offline-first recipe uses SQL.
- Note: `sqlite3_flutter_libs` is EOL, so follow Drift's current native-library setup (verify in Phase 5).

**C4. Networking/serialization:**
- **dio 5.11.1** with interceptors for timeouts, `Accept-Language: tr`, and an app-version header.
- **freezed 4.0.3 + json_serializable 6.15.2** for domain models.
- **API DTOs are generated** from the backend OpenAPI document into `packages/api_client`, so models are not duplicated by hand.
- Fallback: hand-written DTOs plus contract tests against `contracts/openapi.json`.

**C5. Backend — Python 3.13 + FastAPI 0.162 + Pydantic 2.14 + SQLAlchemy 2.1 + Alembic 1.20 + GeoAlchemy2 + psycopg 3 + httpx; uv for packaging.**
- Alternatives: NestJS/TypeScript, Kotlin/Spring.
- Why: ingestion is the hardest backend problem, and Python's GTFS/geo tooling (`gtfs-kit 13`, `pandas`, `shapely`) is strongest. One language means one model layer shared by the API and ingestion. Pydantic generates OpenAPI 3.1 automatically, and the sandbox already has Python 3.13.
- Trade-offs: lower raw throughput than Go/Java. That doesn't matter: journey compute happens in OTP, and catalog queries run in PostGIS.
- Would change if: the team is TypeScript-only, in which case the same design ports to NestJS.

**C6. Database — PostgreSQL 17 + PostGIS 3.6** (`postgis/postgis:17-3.6`, VERIFIED tag 2026-10-22).
- PostGIS is justified: nearby-stop KNN (`<->` on GiST), bbox map queries, and shape geometry.
- `pg_trgm` for fuzzy Turkish stop search over a pre-folded `search_key`.
- Redis is **deferred** until there is more than one API replica.

**C7. Maps — MapLibre (`maplibre_gl 0.27.1`) + OpenFreeMap vector style for dev and launch; self-hosted tiles as the scale-up path.**
- Alternatives:
  - Google Maps: API keys and billing. Its Places terms also restrict use with non-Google maps.
  - Mapbox: paid, with a token.
  - `flutter_map` 8.3.2: raster-first; its vector plugin `vector_map_tiles` was last published 2024-08.
- Why MapLibre: native GPU vector rendering on iOS and Android, no key, open source, and OSM attribution is built in.
- Risk: OpenFreeMap has no SLA. Mitigation: the style URL is remote config, so we can switch to self-hosted tiles without an app release.
- Offline tiles: **not** in v1. OFM limits bulk downloads to 3,000 tiles / 50 MB.

**C8. Geocoding — backend `/places/search` with adapters, in this order:**
1. Local stops and stations from PostGIS.
2. Local landmarks from İzmir open-data POI APIs (CC BY).
3. **Photon**: self-hosted in production; the public komoot instance only in dev, given fair use and no guarantees.

Nominatim's public instance is **excluded** because its policy forbids autocomplete. Reverse geocoding (map pin → label) goes through Photon `/reverse`, cached server-side.

**C9. GTFS ingestion:**
- Per-source fetch → validate → normalize. Then **merge into one namespaced GTFS** (`izmirgo-merged-{version}.zip`), produce a validator report, and **atomically publish** it to the DB and the OTP graph.
- Each source keeps its own last-known-good snapshot.
- Validation: MobilityData gtfs-validator (Java CLI; Java 21 available; pin the version in Phase 2) plus our own semantic checks.

**C10. Multimodal journey planning — OTP 2.10.0 behind a backend adapter** (GTFS GraphQL API).
- The backend maps OTP itineraries to the İzmir Go contract and attaches provenance, basis and coverage warnings.
- The OTP version is pinned. MOTIS is the fallback engine.

**C11. Hosting** (RECOMMENDATION, not chosen by research):
- **One Linux VM with 8–16 GB RAM running Docker Compose** (Caddy, API, Postgres/PostGIS, OTP, a scheduled ingestion job), plus off-site backups.
- PaaS options are poorly suited to OTP's multi-GB heap.
- The ingestion host must be able to reach `eshot.gov.tr`, so test a **Türkiye-region** VM first. That may also simplify KVKK data-transfer questions (legal review needed).
