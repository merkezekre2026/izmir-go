import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izmir_go/core/config.dart';
import 'package:izmir_go/data/repositories/catalog_repository.dart';
import 'package:izmir_go/data/repositories/favorites_repository.dart';
import 'package:izmir_go/data/repositories/journeys_repository.dart';
import 'package:izmir_go/data/repositories/lines_repository.dart';
import 'package:izmir_go/data/repositories/places_repository.dart';
import 'package:izmir_go/data/repositories/status_repository.dart';
import 'package:izmir_go/data/repositories/stops_repository.dart';
import 'package:izmir_go/data/services/api_client.dart';
import 'package:izmir_go/data/services/local/app_database.dart';
import 'package:izmir_go/data/services/location_service.dart';

// Dependency injection: services and repositories are providers, overridden in tests.

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.fromEnvironment());

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Whether to render real native maps. Widget tests set this to false.
final mapsEnabledProvider = Provider<bool>((ref) => true);

final apiProvider = Provider<IzmirGoApi>(
  (ref) => IzmirGoApi.create(ref.watch(appConfigProvider).apiBaseUrl),
);

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepository(
    ref.watch(apiProvider),
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final stopsRepositoryProvider = Provider<StopsRepository>(
  (ref) => StopsRepository(
    ref.watch(apiProvider),
    ref.watch(databaseProvider),
    ref.watch(catalogRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final linesRepositoryProvider = Provider<LinesRepository>(
  (ref) => LinesRepository(
    ref.watch(apiProvider),
    ref.watch(databaseProvider),
    ref.watch(catalogRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final journeysRepositoryProvider = Provider<JourneysRepository>(
  (ref) => JourneysRepository(
    ref.watch(apiProvider),
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final placesRepositoryProvider = Provider<PlacesRepository>(
  (ref) => PlacesRepository(
    ref.watch(apiProvider),
    ref.watch(databaseProvider),
    ref.watch(catalogRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(ref.watch(databaseProvider), clock: ref.watch(clockProvider)),
);

final statusRepositoryProvider = Provider<StatusRepository>(
  (ref) => StatusRepository(ref.watch(apiProvider), ref.watch(databaseProvider)),
);
