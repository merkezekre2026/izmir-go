# Architecture

## System overview

```mermaid
flowchart LR
  subgraph Device["Flutter app (iOS / Android)"]
    UI[Views] --> VM[ViewModels (Riverpod Notifiers)]
    VM --> REPO[Repositories]
    REPO --> APIC[api_client (generated, dio)]
    REPO --> DRIFT[(Drift SQLite: catalog cache, favorites, recent journeys)]
    REPO --> LOC[Location service (geolocator)]
    UI --> MAP[MapLibre view]
  end
  MAP -->|vector tiles + style| TILES[OpenFreeMap / self-hosted tiles]
  APIC -->|HTTPS /api/v1| CADDY[Caddy: TLS, rate limit, gzip]
  CADDY --> API[FastAPI service]
  API --> PG[(PostgreSQL + PostGIS: catalog, service_dates, stop_times, dataset versions, ingestion runs)]
  API -->|GraphQL| OTP[OpenTripPlanner 2.10 (graph = active dataset)]
  API --> CACHE[In-process TTL cache + single-flight]
  CACHE -->|timeouts, retry, circuit breaker| IZAPI[İzmir OpenAPI: ESHOT live, İZBAN, İZDENİZ]
  API --> GEO[Photon geocoder (self-hosted)]
  subgraph Pipeline["Ingestion job (scheduled CLI)"]
    FETCH[Fetch + hash] --> VAL[Validate (gtfs-validator + semantic checks)]
    VAL --> NORM[Normalize + namespace] --> MERGE[Merge + curated transfers]
    MERGE --> STAGE[Stage dataset vN in DB] --> BUILD[Build OTP graph vN]
    BUILD --> PUB[Health-check → atomic flip active_dataset]
  end
  SRC[Operator GTFS ZIPs, ESHOT CSVs, İZDENİZ/İZBAN APIs, Mobility DB mirror] --> FETCH
  OSM[OSM İzmir extract] --> BUILD
  PUB --> PG
  BUILD --> OTP
```

**Boundaries:**
- The app talks **only** to `/api/v1`, plus tile servers for map rendering.
- The API owns all upstream calls and response normalization. It is the only component that reads the active dataset pointer.
- The ingestion pipeline is the only writer of transit tables.
- OTP is stateless apart from its graph file. The API treats it as an unreliable dependency: on timeout it returns `ROUTING_UNAVAILABLE`, while the stop and line screens keep working from Postgres.

## Domain model & API contracts

**Identifiers:**
- Format: `{source}:{raw_id}`, e.g. `metro:6`, `tram:1`, `eshot:10005`, `izban:21`, `izdeniz:2`. Curated stations use `stn:halkapinar`.
- Sources: `metro, tram, eshot, izban, izdeniz`.
- Raw IDs are kept for upstream calls. The ESHOT public line number is `route_short_name`.
- IDs are stable across dataset versions as long as upstream keeps them; changes are detected and logged by ingestion.

**Entities (Postgres):**
- `dataset_version` (id, created_at, status staged/active/retired, merged_sha256, otp_graph_path, validator_report)
- `source_snapshot` (source, fetched_at, http_etag, last_modified, sha256, feed_start, feed_end, status, error, used_in_dataset)
- `agency`
- `stop` (dataset_version_id, id, name, search_key, geom Point 4326, mode set, parent_station, wheelchair)
- `route` (id, source, short_name, long_name, mode, color, text_color, display_line_id); Metro's two direction-routes are grouped under one display line
- `trip`
- `stop_time` (departure_s, arrival_s as seconds from service-day noon−12h)
- `service_date` (dataset_version_id, service_id, date): pre-expanded calendar × calendar_dates
- `shape` (LineString)
- `transfer`
- `announcement` (route, title, starts_at, ends_at, source)
- `ingestion_run`

**Indexes:**
- GiST `stop(geom)`
- GIN trigram `stop(search_key)`
- B-tree `stop_time(dataset_version_id, stop_id, departure_s)`
- `trip(dataset_version_id, route_id)`
- `service_date(dataset_version_id, date)`
- Partial indexes `WHERE dataset_version_id = active`, via a view.

**Mobile domain types:**
- `DataBasis { scheduled, live, cached }`
- `Freshness { fetchedAt, validFrom/To, source }`
- Every departure, journey and vehicle carries both.

**Endpoints (`/api/v1`, JSON, `Accept-Language: tr`):**

| Endpoint | Purpose | Cache |
|---|---|---|
| `GET /health` (liveness), `GET /health/ready` (DB + OTP + active dataset) | ops | no-store |
| `GET /transit/status` | active dataset, per-source fetched_at / validity window / status / last error | 60 s |
| `GET /stops?q=&modes=&bbox=&limit≤50&cursor=` | search/browse | 1 h + ETag(dataset) |
| `GET /stops/{id}` | detail + serving lines + parent station | 1 h + ETag |
| `GET /nearby-stops?lat=&lon=&radius_m≤1500&modes=&limit≤30` | KNN + distance | 5 min |
| `GET /stops/{id}/departures?date=&from=HH:MM&limit≤50&route=` | **scheduled** departures (D and D-1 service days) | 60 s |
| `GET /stops/{id}/approaching-vehicles` | ESHOT live (separate provenance) | 15 s server TTL, no-store client |
| `GET /routes?modes=&q=` · `GET /routes/{id}` (directions, ordered stops, shape) · `GET /routes/{id}/schedule?date=&direction=` | lines | 1 h + ETag |
| `GET /journeys?from=&to=&datetime=&time_type=depart|arrive&modes=&max_walk_m≤2000&max_transfers≤4&wheelchair=&limit≤5` | OTP-backed planning | no-store |
| `GET /places/search?q=&lat=&lon=` · `GET /places/reverse?lat=&lon=` | geocoding | 1 day |
| `GET /alerts?route=` | ESHOT announcements, İZDENİZ cancellations | 5 min |
| `GET /catalog/snapshot` | compact gzipped stops+lines for offline; `ETag = dataset_version` | ETag |
| `GET /meta/attributions` | licence texts | 1 day |

- `from`/`to` accept `lat,lon` or `stop:{id}`.
- Coordinates outside the İzmir province bounding box return `OUTSIDE_COVERAGE_AREA`.

**Journey response (abridged):**
```json
{
  "journeys": [{
    "id": "j_…", "start": "2026-10-28T08:03:00+03:00", "end": "2026-10-28T08:41:00+03:00",
    "duration_s": 2280, "transfers": 1, "walk_m": 540,
    "basis": "scheduled",
    "legs": [
      {"mode":"walk","from":{"name":"Başlangıç","lat":38.46,"lon":27.22},"to":{"stop_id":"metro:11"},"distance_m":210,"duration_s":180,"geometry":"<polyline6>"},
      {"mode":"metro","route":{"id":"metro:1","short_name":"M1","color":"#0038EF"},"trip_id":"metro:WEEKDAY_0_0012","headsign":"Narlıdere Kaymakamlık",
       "board":{"stop_id":"metro:11","scheduled":"08:06"},"alight":{"stop_id":"metro:6","scheduled":"08:21"},
       "intermediate_stops":[…],"geometry":"<polyline6|null>","geometry_basis":"stop_to_stop","times_basis":"scheduled","times_approximate":false},
      {"mode":"walk","transfer":true,"from":{"stop_id":"metro:6"},"to":{"stop_id":"tram:1"},"distance_m":280,"duration_s":300,"transfer_source":"curated|street_network"}
    ]
  }],
  "coverage_warnings": [{"code":"SOURCE_OUT_OF_VALIDITY","source":"eshot","message":"Otobüs tarifesi bu tarih için mevcut değil."},
                        {"code":"NO_HOLIDAY_CALENDAR","message":"Resmî tatillerde sefer saatleri farklı olabilir."}],
  "meta": {"dataset_version":"2026-10-24T03:00Z-a1b2", "generated_at":"…", "sources":[{"id":"metro","valid_to":"2027-07-09"}]}
}
```

**Errors:** RFC 9457 `application/problem+json` with `code`. Codes:
- `VALIDATION_ERROR` (422)
- `NOT_FOUND` (404)
- `OUTSIDE_COVERAGE_AREA` (422)
- `OUTSIDE_SERVICE_WINDOW` (200 with warning, or 422 when no source covers the date)
- `ROUTING_UNAVAILABLE` (503)
- `UPSTREAM_UNAVAILABLE` (503, live endpoints only)
- `RATE_LIMITED` (429 + `Retry-After`)
- `INTERNAL` (500, with `trace_id`)

**Rules and policies:**
- **No fares, ETAs or alerts are invented.** Fields for data we don't have are absent, not null-filled guesses.
- Rate limiting: Caddy per-IP limits (e.g. 60 req/min for `/journeys`, 300/min elsewhere; tune later) plus `slowapi` as defence in depth.
- Upstream calls: httpx with 3 s connect / 5 s read timeouts, 1 retry with jitter on idempotent GETs, and a circuit breaker per upstream host (open after 5 failures for 30 s). Single-flight coalescing stops one stop's popularity from fanning out to İzmir's API.
- Observability: structlog JSON logs (coordinates rounded to 3 decimals, IPs truncated), Prometheus `/metrics`, and request IDs.
- Versioning: `/api/v1` is frozen once the mobile app ships. Breaking changes go to `/api/v2`, and the app sends `X-App-Version` for deprecation messaging.
- No auth in v1. Endpoints are public read-only. Admin/ingestion is the CLI only, with no HTTP admin surface.

## User journeys & screen inventory

**Navigation:**
- 4 tabs (Material `NavigationBar` on Android, Cupertino-style tab bar on iOS):
  1. **Rota**: home, journey search
  2. **Yakınımda**: nearby + map
  3. **Hatlar**: lines
  4. **Kaydedilenler**: favorites
- **Ayarlar** opens from the home app bar.
- Pushed routes: place picker (full-screen modal), journey results, journey detail, stop detail, line detail, data sources.

**Core flow:** Rota → pick origin (default "Konumum" only if permission is already granted; otherwise text) → pick destination → time ("Şimdi / Kalkış / Varış") → results → detail (map + timeline) → optionally save the stop/place.

**Screens:**
1. **Rota / Home**: origin/destination fields with swap, a time selector, favorites chips, recent places (local only, can be cleared), and a holiday caution banner when the date is a public holiday.
2. **Place picker**: debounced search (stops first, then landmarks, then addresses) and a "Haritadan seç" map pin. Permission-denied state shows manual search without nagging.
3. **Journey results**:
   - Each card shows departure–arrival, duration, a mode/line badge sequence, walking distance, transfers, and a "Tarifeye göre" tag.
   - Coverage warnings appear on top.
   - Empty state: "Bu saatte uygun sefer bulunamadı" plus suggestions (change time, increase walk distance).
4. **Journey detail**: a map with polylines (stop-to-stop straight segments are visually distinguished when no shape exists) and a synchronized leg timeline. Transfer callouts ("Halkapınar'da yaklaşık 280 m yürüyün"). Board/alight stops and intermediate stops are collapsible.
5. **Map (Yakınımda)**: current location, stop markers clustered by mode, tap → stop sheet. The map never hides the list; the bottom sheet takes 40% by default.
6. **Stop detail**:
   - Scheduled departures grouped by line, from today's service days.
   - ESHOT stops get a separate "Canlı" section: "3 durak uzakta", with the fetch time shown.
   - Plus the serving lines and a favorite toggle.
7. **Hatlar / line detail**: lines grouped by mode with search; direction toggle, ordered stops, shape on the map, today's schedule, and announcements.
8. **Nearby list**: stops within 500 m (adjustable) with the next scheduled departures.
9. **Kaydedilenler**: favorite stops, lines and places (Ev/İş labels), stored locally.
10. **Ayarlar / Veri kaynakları**:
    - Per-source validity window, last update, live/scheduled explanation, licences and attribution.
    - Text-size preview, reduced-motion toggle (also follows the OS), clear local data, and a privacy notice.

**Screen states:**
- Each ViewModel exposes a sealed `ScreenState<T>`: `initial | loading(previous?) | success(data, freshness) | empty | failure(failure, cached?) | stale(data, asOf)`.
- `stale` and `cached` always render a `FreshnessBanner` ("Son güncelleme 14:05 · çevrimdışı").
- Live widgets never render from cache.
