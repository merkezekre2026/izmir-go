import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/data/repositories/cache_policy.dart';
import 'package:izmir_go/data/repositories/catalog_repository.dart';
import 'package:izmir_go/data/services/api_client.dart';
import 'package:izmir_go/data/services/local/app_database.dart';
import 'package:izmir_go/domain/models/fresh.dart';
import 'package:izmir_go/domain/models/transit.dart';

class LinesRepository {
  LinesRepository(this._api, this._db, this._catalog, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final IzmirGoApi _api;
  final AppDatabase _db;
  final CatalogRepository _catalog;
  final DateTime Function() _clock;

  Future<Fresh<List<RouteSummary>>> routes() async {
    try {
      final list = await _api.routes();
      return Fresh(list.items, fetchedAt: _clock().toUtc(), origin: DataOrigin.network);
    } on NetworkFailure {
      final synced = await _catalog.lastSync();
      if (synced == null) {
        rethrow;
      }
      return Fresh(await _catalog.routes(), fetchedAt: synced, origin: DataOrigin.cache);
    }
  }

  Future<Fresh<RouteResponse>> route(String id) => networkFirst(
    db: _db,
    cacheKey: 'route:$id',
    fetch: () => _api.route(id),
    toJson: (v) => v.toJson(),
    fromJson: RouteResponse.fromJson,
    clock: _clock,
  );

  Future<ScheduleResponse> schedule(String id, {int? direction}) =>
      _api.schedule(id, direction: direction);

  Future<List<Alert>> alerts(String routeId) async {
    try {
      return (await _api.alerts(route: routeId)).items;
    } on AppFailure {
      return const [];
    }
  }
}
