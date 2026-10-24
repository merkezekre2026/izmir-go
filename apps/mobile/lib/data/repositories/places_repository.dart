import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/data/repositories/catalog_repository.dart';
import 'package:izmir_go/data/services/api_client.dart';
import 'package:izmir_go/data/services/local/app_database.dart';
import 'package:izmir_go/domain/models/transit.dart';

class PlacesRepository {
  PlacesRepository(this._api, this._db, this._catalog, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final IzmirGoApi _api;
  final AppDatabase _db;
  final CatalogRepository _catalog;
  final DateTime Function() _clock;

  /// Server search (stops + addresses); offline, only cached stops can be found.
  Future<(List<Place>, bool offline)> search(String q, {double? lat, double? lon}) async {
    try {
      final res = await _api.searchPlaces(q, lat: lat, lon: lon);
      return (res.items, false);
    } on NetworkFailure {
      final stops = await _catalog.searchStops(q, limit: 10);
      return (
        [
          for (final s in stops)
            Place(
              id: s.id,
              name: s.name,
              lat: s.lat,
              lon: s.lon,
              kind: s.kind,
              provider: 'catalog',
            ),
        ],
        true,
      );
    }
  }

  Future<Place?> reverse(double lat, double lon) async {
    final res = await _api.reverse(lat, lon);
    return res.items.isEmpty ? null : res.items.first;
  }

  Future<List<Place>> recent() async {
    final rows =
        await (_db.select(_db.recentPlaces)
              ..orderBy([(t) => _desc(t.usedAt)])
              ..limit(AppDatabase.maxRecentPlaces))
            .get();
    return [for (final r in rows) Place.fromJson(jsonDecode(r.json) as Map<String, dynamic>)];
  }

  Future<void> addRecent(Place place) async {
    if (place.id == 'current-location') {
      return; // never store the user's position as history
    }
    await _db
        .into(_db.recentPlaces)
        .insertOnConflictUpdate(
          RecentPlacesCompanion.insert(
            placeId: place.id,
            json: jsonEncode(place.toJson()),
            usedAt: _clock().toUtc(),
          ),
        );
    final rows = await (_db.select(_db.recentPlaces)..orderBy([(t) => _desc(t.usedAt)])).get();
    for (final r in rows.skip(AppDatabase.maxRecentPlaces)) {
      await (_db.delete(_db.recentPlaces)..where((t) => t.placeId.equals(r.placeId))).go();
    }
  }

  Future<void> clearRecent() => _db.delete(_db.recentPlaces).go();
}

OrderingTerm _desc(Expression<Object> e) => OrderingTerm.desc(e);
