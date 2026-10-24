import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:izmir_go/data/services/local/app_database.dart';
import 'package:izmir_go/domain/models/transit.dart';

class FavoriteStop {
  const FavoriteStop(this.stopId, this.name, this.modes);
  final String stopId;
  final String name;
  final List<TransitMode> modes;
}

/// Favorites live only on this device (no account needed).
class FavoritesRepository {
  FavoritesRepository(this._db, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  Stream<List<FavoriteStop>> watchStops() =>
      (_db.select(_db.favoriteStops)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch().map(
        (rows) => [
          for (final r in rows)
            FavoriteStop(r.stopId, r.name, [
              for (final m in r.modes.split(',').where((m) => m.isNotEmpty))
                TransitMode.values.firstWhere((v) => v.name == m, orElse: () => TransitMode.other),
            ]),
        ],
      );

  Stream<List<RouteSummary>> watchLines() => _db
      .select(_db.favoriteLines)
      .watch()
      .map(
        (rows) => [
          for (final r in rows) RouteSummary.fromJson(jsonDecode(r.json) as Map<String, dynamic>),
        ],
      );

  Stream<bool> watchIsFavoriteStop(String id) => (_db.select(
    _db.favoriteStops,
  )..where((t) => t.stopId.equals(id))).watchSingleOrNull().map((r) => r != null);

  Stream<bool> watchIsFavoriteLine(String id) => (_db.select(
    _db.favoriteLines,
  )..where((t) => t.routeId.equals(id))).watchSingleOrNull().map((r) => r != null);

  Future<void> toggleStop(String id, String name, List<TransitMode> modes) async {
    final existing = await (_db.select(
      _db.favoriteStops,
    )..where((t) => t.stopId.equals(id))).getSingleOrNull();
    if (existing != null) {
      await (_db.delete(_db.favoriteStops)..where((t) => t.stopId.equals(id))).go();
    } else {
      await _db
          .into(_db.favoriteStops)
          .insert(
            FavoriteStopsCompanion.insert(
              stopId: id,
              name: name,
              modes: modes.map((m) => m.name).join(','),
              addedAt: _clock().toUtc(),
            ),
          );
    }
  }

  Future<void> toggleLine(RouteSummary route) async {
    final existing = await (_db.select(
      _db.favoriteLines,
    )..where((t) => t.routeId.equals(route.id))).getSingleOrNull();
    if (existing != null) {
      await (_db.delete(_db.favoriteLines)..where((t) => t.routeId.equals(route.id))).go();
    } else {
      await _db
          .into(_db.favoriteLines)
          .insert(
            FavoriteLinesCompanion.insert(
              routeId: route.id,
              json: jsonEncode(route.toJson()),
              addedAt: _clock().toUtc(),
            ),
          );
    }
  }
}
