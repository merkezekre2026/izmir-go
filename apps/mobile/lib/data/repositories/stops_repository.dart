import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/core/time.dart';
import 'package:izmir_go/data/repositories/cache_policy.dart';
import 'package:izmir_go/data/repositories/catalog_repository.dart';
import 'package:izmir_go/data/services/api_client.dart';
import 'package:izmir_go/data/services/local/app_database.dart';
import 'package:izmir_go/domain/models/fresh.dart';
import 'package:izmir_go/domain/models/transit.dart';

class StopsRepository {
  StopsRepository(this._api, this._db, this._catalog, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final IzmirGoApi _api;
  final AppDatabase _db;
  final CatalogRepository _catalog;
  final DateTime Function() _clock;

  Future<Fresh<List<StopSummary>>> search(String query) async {
    try {
      final page = await _api.searchStops(q: query);
      return Fresh(page.items, fetchedAt: _clock().toUtc(), origin: DataOrigin.network);
    } on NetworkFailure {
      final local = await _catalog.searchStops(query);
      final synced = await _catalog.lastSync();
      if (synced == null) {
        rethrow;
      }
      return Fresh(local, fetchedAt: synced, origin: DataOrigin.cache);
    }
  }

  Future<Fresh<List<StopSummary>>> nearby(double lat, double lon, {int radiusM = 500}) async {
    try {
      final res = await _api.nearby(lat: lat, lon: lon, radiusM: radiusM);
      return Fresh(res.items, fetchedAt: _clock().toUtc(), origin: DataOrigin.network);
    } on NetworkFailure {
      final synced = await _catalog.lastSync();
      if (synced == null) {
        rethrow;
      }
      final local = await _catalog.nearby(lat, lon, radiusM: radiusM);
      return Fresh(local, fetchedAt: synced, origin: DataOrigin.cache);
    }
  }

  Future<Fresh<StopResponse>> stop(String id) => networkFirst(
    db: _db,
    cacheKey: 'stop:$id',
    fetch: () => _api.stop(id),
    toJson: (v) => v.toJson(),
    fromJson: StopResponse.fromJson,
    clock: _clock,
  );

  /// Scheduled departures. Cached copies are only reused for the same İzmir calendar day,
  /// and only departures still in the future are kept.
  Future<Fresh<DeparturesResponse>> departures(String stopId) async {
    final today = izmirNow(_clock());
    final key = 'dep:$stopId:${today.year}-${two(today.month)}-${two(today.day)}';
    final endOfDay = DateTime.utc(
      today.year,
      today.month,
      today.day,
      23,
      59,
    ).subtract(izmirUtcOffset);
    final result = await networkFirst(
      db: _db,
      cacheKey: key,
      fetch: () => _api.departures(stopId, limit: 30),
      toJson: (v) => v.toJson(),
      fromJson: DeparturesResponse.fromJson,
      expiresAt: endOfDay.add(const Duration(hours: 3)),
      clock: _clock,
    );
    if (!result.isCached) {
      return result;
    }
    final now = _clock();
    return result.map(
      (r) => r.copyWith(items: r.items.where((d) => d.scheduledDeparture.isAfter(now)).toList()),
    );
  }

  /// Live data is never cached or replayed.
  Future<LiveResponse> live(String stopId) => _api.approaching(stopId);
}
