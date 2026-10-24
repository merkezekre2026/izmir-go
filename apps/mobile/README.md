# İzmir Go: mobile app

A Flutter app for iOS and Android, Turkish-first. It talks only to the İzmir Go API (`/api/v1`) and to a map style host.

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed / json / drift code
flutter run --dart-define-from-file=config/dev.json         # dev talks to http://10.0.2.2:8000
```

`config/{dev,staging,prod}.json` set `FLAVOR`, `API_BASE_URL` and `MAP_STYLE_URL`. None of them hold secrets.

## Structure

This follows the official Flutter architecture guide: views → view models → repositories → services.

- `lib/ui/<feature>/`: screens and their Riverpod view models (`Notifier`/`AsyncNotifier`).
- `lib/ui/core/design_system/`: badges, data-basis tags, state views, tiles. Tokens live in `lib/app/theme/tokens.dart`.
- `lib/data/repositories/`: the source of truth. Reads go to the network first and fall back to the cache; cached data is always labelled with its time.
- `lib/data/services/`: the API client (dio), local database (Drift/SQLite) and location (geolocator).
- `lib/domain/models/`: immutable models mirroring the API contract.
- `lib/app/`: DI providers, router (go_router, 4 tabs), theme.

## Before release (not done yet)

- **Bundle id / applicationId:** currently `com.example.izmir_go`, a placeholder that the stores reject. Choose the real id first.
- **Android release signing and the iOS team/provisioning profile.**
- **Native flavors:** not set up yet. Environments are switched with `--dart-define-from-file`.
