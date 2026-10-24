# Data sources

Last verified: **2026-10-24**. Re-verify whenever a source changes behaviour; ingestion runs record per-source status in `source_snapshot` and expose it at `GET /api/v1/transit/status`.

Labels: **VERIFIED** = observed directly · **REPORTED** = secondary source · **OPEN** = unresolved.

### B1. Source-of-truth matrix

| Operator | Dataset / API | Capabilities (verified) | Update frequency | Licence | Verification status | Fallback |
|---|---|---|---|---|---|---|
| **İzmir Metro** | GTFS `https://www.izmirmetro.com.tr/gtfs/rail-metro-gtfs.zip` | agency, calendar (WEEKDAY/SATURDAY/SUNDAY 2026-07-09→2027-07-09), calendar_dates **empty**, feed_info, routes (M1 split into 2 route_ids, one per direction), 24 stops (incl. Narlıdere), 844 trips, 19,416 stop_times, times up to 24:43. **No shapes, transfers, fares** | HTTP Last-Modified 2026-10-20; feed_version 2026-07-09 (re-uploads happen without content changes, so detect changes by hash) | CC BY 4.0 (portal licence) | **VERIFIED** (downloaded, parsed, referential integrity clean) | Mobility Database mirror mdb-1824 (VERIFIED identical size); OpenAPI `/api/metro/istasyonlar`, `/api/metro/sefersaatleri` (headway bands, VERIFIED) |
| **Tram İzmir** | GTFS `https://www.tramizmir.com/gtfs/rail-tramizmir-gtfs.zip` | 5 routes (Konak, Karşıyaka, Çiğli İç/Dış, Turuncu ring), 53 stops, 2,021 trips, 26,003 stop_times, calendar 2026-07-16→2027-07-16, calendar_dates empty, route colours. **No shapes/transfers/fares** | Last-Modified 2026-10-20 | CC BY 4.0 | **VERIFIED** | mdb-1829 mirror; OpenAPI `/api/tramvay/hatlar`, GeoJSON line geometry on portal |
| **ESHOT (bus)** | GTFS `https://www.eshot.gov.tr/gtfs/bus-eshot-gtfs.zip` | Inspected a Mobility Database copy dated 2026-09-26: 421 routes, 11,739 stops, 61,344 trips, 2.1M stop_times, **shapes.txt present**, wheelchair/bikes flags, calendar 2026-08-05→2026-10-05/09, **no calendar_dates, no feed_info**, all `timepoint=0` (approximate times), 22,874 times ≥ 24:00 | Rolling windows of about 2 months (MDB history: Jun–Aug, Aug–Oct 2026) | CC BY 4.0 | **Producer URL NOT reachable from sandbox** (TLS connection reset ×5; WebFetch 503). Contents **VERIFIED from the MDB mirror only**. Whether a newer post-Oct-5 feed exists is **OPEN** | Mobility Database `https://files.mobilitydatabase.org/mdb-1823/latest.zip` (VERIFIED reachable, but it lags and was already expired on the verification date) |
| ESHOT (bus) static CSVs | `openfiles.izmir.bel.tr/211488/docs/eshot-otobus-{duraklari,hatlari,hareketsaatleri,hat-guzergahlari,hat-duyurulari,baglantili-hatlar}.csv` | Stops (11,953; IDs match GTFS 11,732/11,739), lines (446), **terminal departure times only** (no per-stop times), line polylines, **service announcements** (title + start/end), transfer-linked lines | "günde iki kez" / daily (VERIFIED Last-Modified 2026-10-24) | CC BY 4.0 | **VERIFIED** (`;`-separated, UTF-8) | Can't replace GTFS for routing (no stop sequences or stop times). Used for announcements and as a cross-check |
| ESHOT live | `openapi.izmir.bel.tr/api/iztek/duragayaklasanotobusler/{durakId}`, `/hattinyaklasanotobusleri/{hatNo}/{durakId}`, `/hatotobuskonumlari/{hatNo}` | Approaching buses: `KalanDurakSayisi`, line, direction, coords, accessibility/bike flags, `OtobusId`. Vehicle positions per line. **No ETA, no timestamp, no trip_id.** Coordinates are strings with decimal commas; `KoorX`=latitude, `KoorY`=longitude (official PDF says double) | "sürekli" (continuous) | CC BY 4.0 | **VERIFIED**: anonymous, HTTP 200, no rate-limit headers, no key. The official PDF says "Servise anonim olarak erişilebilir" | If down: show the scheduled departures only, with the live section hidden and a "Canlı veri alınamadı" note |
| **İZBAN** | GTFS `https://www.izban.com.tr/gtfs/rail-izban-gtfs.zip` | 8 routes, 41 stops, 239 trips; calendar **2022-01-01→2025-01-01 (EXPIRED)**; file Last-Modified 2023-03-21 | Stale for 3+ years | CC BY 4.0 | **VERIFIED expired.** Must not be used for current routing | OpenAPI `/api/izban/istasyonlar` (VERIFIED), `/api/izban/sefersaatleri/{from}/{to}` (VERIFIED: returns current O-D departures/arrivals, **no day-type parameter**) |
| İZBAN fares | `/api/izban/tutarhesaplama/{from}/{to}/{transfer}/{htt}` | — | — | CC BY 4.0 | **FAILED** (connection reset) — OPEN | No fares in v1 |
| **İZDENİZ** | GTFS `https://www.izdeniz.com.tr/gtfs/ship-izdeniz-gtfs.zip` | Returns **HTML (a single-page-app shell), not a ZIP** | — | — | **VERIFIED broken** | OpenAPI `/api/izdeniz/iskeleler` (piers with coords, VERIFIED), `/api/izdeniz/gunler`, `/api/izdeniz/vapursaatleri/{from}/{to}/{gunId}/0` (O-D departures + arrivals + **`IptalMi` cancellation flag**, VERIFIED), `/api/izdeniz/iskelesefersaatleri/{iskeleId}/{gunId}` (departures with destination lists, VERIFIED). Not in Mobility Database |
| Nearby stops (municipal GIS) | `/api/ibb/cbs/noktayayakinduraklar?x&y&inCoordSys&outCoordSys` | Returned projected coordinates; the correct parameter values are undocumented here | — | CC BY 4.0 | PARTIAL | Not needed: we compute nearby stops in PostGIS |
| Fares (general) | `ulasim-ucret-tarifeleri` → HTML page on izmirimkart.com.tr | HTML only | irregular | — | Not parsed | Link out only |
| POIs | `/api/ibb/cbs/{muzeler,plajlar,meydanlar,fuar,...}` | Landmarks with coordinates | — | CC BY 4.0 | Listed, not fetched | Seed for local place search |
| Basemap | OpenFreeMap (openfreemap.org) | Free, no key, commercial use OK, **no SLA**, attribution required, MIT self-host | — | OSM ODbL + OFM | **VERIFIED** (terms page) | Self-host OpenFreeMap/Protomaps; MapTiler (paid) |
| Geocoding | Nominatim public (OSMF policy) | Max 1 req/s, **autocomplete forbidden** | — | ODbL | **VERIFIED policy** | Not usable for search-as-you-type |
| Geocoding | Photon (komoot) | Public instance is "fair use, throttled, no availability guarantee"; supports type-ahead; self-hostable | — | — | **VERIFIED terms page** (software licence not stated on page — OPEN) | Self-host Photon for production |
| Street network | OSM extract (Geofabrik `europe/turkey-latest.osm.pbf`) | Needed by OTP for walking | daily | ODbL | **FAILED from sandbox** (connection reset) — OPEN | Alternate extract mirrors / Overpass bbox export |

**Portal licence (VERIFIED, https://acikveri.bizizmir.com/tr/license):** CC BY 4.0 unless stated otherwise. Commercial use, adaptation and redistribution are allowed. **Attribution is required**; fallback wording: *"Atıf 4.0 Uluslararası (CC BY 4.0) kapsamında lisanslanan kamu sektörü bilgilerini içerir."* There is no warranty of accuracy or continuity. Every transit dataset above carries `license_id = Izmir-Metropolitan-Municipality-License`, verified via the CKAN API.

**Real-time summary:**
- There is **no GTFS-Realtime** (trip updates, vehicle positions or alerts) for any operator.
- The ESHOT live APIs are proprietary. `OtobusId` cannot be reliably matched to GTFS `trip_id`, so live data **must not adjust journey times**.
- İZDENİZ `IptalMi` gives scheduled cancellations, as a proprietary feed.
- ESHOT announcements are scheduled notices with date ranges, not GTFS-RT alerts.

### B2. Key integration findings (VERIFIED by data inspection)

1. **IDs collide across feeds.** 43 `stop_id` values appear in more than one feed (e.g. `1` = Tram Halkapınar and İZBAN Aliağa). Namespacing is mandatory.
2. **No inter-operator transfers exist in any feed.** Geographic pairs within 400 m:
   - İZBAN–Metro Halkapınar: 22 m
   - İZBAN Alsancak–Tram Alsancak Gar: 32 m
   - İZBAN Çiğli–Tram Semra Aksu: 66 m
   - Metro Konak–Tram Konak İskele: 166 m
   - Metro Çankaya–Tram Gazi Bulvarı: 185 m
   - Metro–Tram Fahrettin Altay: 274 m
   - Metro–Tram Halkapınar: 279 m
   - Metro–İZBAN Hilal: 285 m

   Names alone are unsafe: "Halkapınar" is three distinct stops, 22–279 m apart.
3. **ESHOT `route_id` ≠ public line number** for 137/421 routes (e.g. `route_id 9022` → line `691`). `route_short_name` is the key that matches the live API's `hatNo` and the CSV `HAT_NO`. 25 CSV lines are absent from the GTFS (OPEN: seasonal or retired?).
4. **After-midnight times** appear everywhere (Metro ≤24:43, Tram ≤25:07, İZBAN ≤25:50, ESHOT ≤26:06). The departures logic must look at both service day D and D-1.
5. **No `calendar_dates` in any current feed**, so public holidays (e.g. 29 Ekim) are **not represented**. We must not invent them. Show a holiday caution banner instead (see F).
6. Türkiye uses Europe/Istanbul, a fixed UTC+3 with no DST since 2016. This is background knowledge, not verified this session. Still implement GTFS "noon minus 12h" service-day semantics generically.
7. CKAN resource `last_modified` values (2022) are unreliable; real files changed in 2026. Detect changes with **ETag/Last-Modified + SHA-256 of the content**.
8. ESHOT stop_times are all `timepoint=0`, so the UI copy must say "yaklaşık" for intermediate bus stop times.

### B3. Routing-engine research

| Candidate | Fit | Evidence |
|---|---|---|
| **OpenTripPlanner 2.10.0** (RECOMMENDED) | Multimodal GTFS + OSM walking, RAPTOR, per-feed `feedId`, pre-computed street-network transfers (`maxTransferDuration`, `transferRequests`), `stopConsolidationFile`, GTFS GraphQL API; Docker image `opentripplanner/opentripplanner:2.10.0` | **VERIFIED**: changelog lists 2.10.0 (2026-09-09), 2.9.0 (2026-03-18); Docker tag 2.10.0 exists (~294 MB); BuildConfiguration docs fetched. Maven Central stops at 2.6.0, so use the Docker image |
| MOTIS 2 | Efficient C++ GTFS+OSM router, lower memory | Not researched in depth this session — fallback if OTP memory or cost is prohibitive |
| R5 (Conveyal) | Analysis-oriented, not a passenger journey API | Rejected |
| Custom RAPTOR | Feasible on clean GTFS, but would re-implement street routing, transfers and testing that OTP already provides | Rejected for v1 |

Importing several feeds into OTP does **not** create meaningful operator transfers by itself. OTP generates walking transfers only through the OSM street graph within `maxTransferDuration`, and GTFS `transfers.txt` is feed-scoped. → **Merge** all feeds into **one namespaced GTFS** with a curated `transfers.txt` and `parent_station` groupings, and still let OTP add OSM walking transfers.

### B4. Failed attempts / checks to complete later (Phase 0)

- `eshot.gov.tr` from a Türkiye-hosted or other host. Is the block geo/IP-based?
- Is there a post-2026-10-05 ESHOT feed?
- An İZDENİZ GTFS replacement: ask the operator / İBB open-data team.
- An updated İZBAN GTFS: ask the operator.
- The İZBAN fare API.
- An OSM extract download.
- CBS nearby-stops coordinate parameters (low priority).
- OpenAPI rate limits and terms of use. None are documented; the portal's separate Kullanım Koşulları page was **not reviewed**.
- The Photon licence.
- openapi-generator `dart-dio` + `json_serializable` support at the pinned version.
- Drift's current native SQLite setup (`sqlite3_flutter_libs` is now `0.6.0+eol`).

Sources: acikveri.bizizmir.com CKAN API (`package_show`, `package_search`); official web-service PDFs at openfiles.izmir.bel.tr (`iztek`, `izdeniz`, `izban`, `metro-tramvay` v1.0); https://mobilitydatabase.org/feeds/gtfs/mdb-1823 (+1824, 1828, 1829); https://docs.opentripplanner.org/en/v2.10.0/BuildConfiguration/; https://hub.docker.com/r/opentripplanner/opentripplanner; https://openfreemap.org/; https://operations.osmfoundation.org/policies/nominatim/; https://photon.komoot.io/; https://docs.flutter.dev/app-architecture/guide; https://docs.flutter.dev/app-architecture/design-patterns/offline-first; Flutter release JSON (current stable **3.47.8 / Dart 3.13.7**, 2026-10-23); pub.dev and PyPI package APIs.
