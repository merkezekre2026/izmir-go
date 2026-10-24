# İzmir Go

İzmir Go is a Turkish-first public transport companion for İzmir, Türkiye. It is a Flutter app for iOS and Android, backed by a Python API and a multimodal routing engine.

> **Bu uygulama resmî bir İzmir Büyükşehir Belediyesi, ESHOT, İzmir Metro, İZBAN, Tram İzmir veya İZDENİZ uygulaması değildir.**
> (This is not an official app of the municipality or any transport operator.)

## What it does

- Journey planning across metro, tram, bus (and ferry/İZBAN when verified data exists) plus walking.
- Stops, lines, scheduled departures and nearby stops.
- Local favorites, with no account required.
- Live ESHOT "approaching bus" information. It is clearly labelled live and never mixed into scheduled times.
- An offline stop and line catalog with visible timestamps.

The app never fabricates transport information. Every departure and journey is labelled with its data basis (`scheduled`, `live` or `cached`) and with the validity window of its source. See [`docs/data-sources.md`](docs/data-sources.md) for what each operator actually publishes.

## Repository layout

| Path | What lives there |
|---|---|
| `apps/mobile/` | Flutter app (iOS + Android) |
| `backend/` | Python 3.13 project: FastAPI service **and** the GTFS ingestion CLI (one shared model layer) |
| `contracts/openapi.json` | API contract generated from the backend (committed; CI checks it is in sync) |
| `packages/api_client/` | Dart client generated from the contract |
| `data/` | Source registry and curated transfer/station data |
| `infra/` | Docker Compose, OpenTripPlanner config, Caddy, ops scripts |
| `docs/` | Architecture, ADRs, data sources, runbooks |
| `scripts/` | Developer helper scripts |

## Quick start (backend)

Requirements: Docker, [uv](https://docs.astral.sh/uv/) ≥ 0.11 and Python 3.13.

```bash
cp .env.example .env          # placeholders only, nothing secret
make backend-install          # uv sync
make db-up                    # PostGIS in Docker
make migrate                  # alembic upgrade head
make seed-fixtures            # load the synthetic fixture dataset
make api                      # http://localhost:8000/api/v1/health
make test                     # lint + type check + tests
```

To ingest real feeds (this needs network access to the operators' servers):

```bash
make ingest                   # fetch → validate → merge → stage → publish
```

## Quick start (mobile)

Requirements: Flutter 3.47.x stable. iOS builds also need macOS with Xcode.

```bash
cd apps/mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define-from-file=config/dev.json
```

## Releases

Push a tag `vX.Y.Z` to build a release `.apk` and `.ipa` on a GitHub Release. See
[`docs/release.md`](docs/release.md) for signing secrets.

## Data attribution

Transit data comes from the İzmir Büyükşehir Belediyesi Open Data Portal (https://acikveri.bizizmir.com) and operator feeds, licensed under **CC BY 4.0**:
*"Atıf 4.0 Uluslararası (CC BY 4.0) kapsamında lisanslanan kamu sektörü bilgilerini içerir."*
Map data © OpenStreetMap contributors (ODbL). See [`docs/data-sources.md`](docs/data-sources.md).
