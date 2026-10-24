import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Offline copy of the API catalog (stops/stations, incl. stops without a timetable).
@DataClassName('CatalogStopRow')
class CatalogStops extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get searchKey => text()();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  TextColumn get modes => text()(); // comma separated
  TextColumn get kind => text()();
  BoolColumn get hasSchedule => boolean()();
  TextColumn get parentStation => text().nullable()();
  TextColumn get lines => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CatalogRouteRow')
class CatalogRoutes extends Table {
  TextColumn get id => text()();
  TextColumn get mode => text()();
  TextColumn get searchKey => text()();
  TextColumn get json => text()(); // RouteSummary JSON

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Small key/value store (catalog ETag, dataset label, sync timestamps, settings).
@DataClassName('KeyValueRow')
class KeyValues extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DataClassName('FavoriteStopRow')
class FavoriteStops extends Table {
  TextColumn get stopId => text()();
  TextColumn get name => text()();
  TextColumn get modes => text()();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {stopId};
}

@DataClassName('FavoriteLineRow')
class FavoriteLines extends Table {
  TextColumn get routeId => text()();
  TextColumn get json => text()(); // RouteSummary JSON
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {routeId};
}

@DataClassName('RecentPlaceRow')
class RecentPlaces extends Table {
  TextColumn get placeId => text()();
  TextColumn get json => text()(); // Place JSON
  DateTimeColumn get usedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {placeId};
}

/// Cached API responses with the time they were fetched. Never shown as live.
@DataClassName('CachedResponseRow')
class CachedResponses extends Table {
  TextColumn get key => text()();
  TextColumn get json => text()();
  DateTimeColumn get fetchedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    CatalogStops,
    CatalogRoutes,
    KeyValues,
    FavoriteStops,
    FavoriteLines,
    RecentPlaces,
    CachedResponses,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'izmir_go'));

  static const maxRecentPlaces = 10;
  static const maxCachedResponses = 200;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // Future schema versions add explicit steps here (see docs/offline.md). Catalog tables
    // can always be dropped and re-synced; favorites and saved places must be migrated.
    onUpgrade: (m, from, to) async {},
  );

  // --- key/value ---------------------------------------------------------------------------
  Future<String?> readValue(String key) async =>
      (await (select(keyValues)..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> writeValue(String key, String value) =>
      into(keyValues).insertOnConflictUpdate(KeyValuesCompanion.insert(key: key, value: value));

  // --- catalog -----------------------------------------------------------------------------
  Future<void> replaceCatalog(
    List<CatalogStopsCompanion> stops,
    List<CatalogRoutesCompanion> routes,
  ) async {
    await transaction(() async {
      await delete(catalogStops).go();
      await delete(catalogRoutes).go();
      await batch((b) {
        b
          ..insertAll(catalogStops, stops)
          ..insertAll(catalogRoutes, routes);
      });
    });
  }

  Future<int> catalogStopCount() async {
    final count = catalogStops.id.count();
    final row = await (selectOnly(catalogStops)..addColumns([count])).getSingle();
    return row.read<int>(count) ?? 0;
  }

  // --- cache -------------------------------------------------------------------------------
  Future<CachedResponseRow?> cached(String key) =>
      (select(cachedResponses)..where((t) => t.key.equals(key))).getSingleOrNull();

  Future<void> putCached(String key, String json, DateTime fetchedAt, {DateTime? expiresAt}) async {
    await into(cachedResponses).insertOnConflictUpdate(
      CachedResponsesCompanion.insert(
        key: key,
        json: json,
        fetchedAt: fetchedAt,
        expiresAt: Value(expiresAt),
      ),
    );
    // Keep storage bounded: drop expired rows, then the oldest beyond the limit.
    await (delete(
      cachedResponses,
    )..where((t) => t.expiresAt.isSmallerThanValue(DateTime.now().toUtc()))).go();
    final rows = await (select(
      cachedResponses,
    )..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])).get();
    if (rows.length > maxCachedResponses) {
      final stale = rows.skip(maxCachedResponses).map((r) => r.key).toList();
      await (delete(cachedResponses)..where((t) => t.key.isIn(stale))).go();
    }
  }

  /// Removes everything except favorites and recent places.
  Future<void> clearCaches() async {
    await transaction(() async {
      await delete(catalogStops).go();
      await delete(catalogRoutes).go();
      await delete(cachedResponses).go();
      await delete(keyValues).go();
    });
  }

  Future<void> clearAll() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}
