import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:izmir_go/core/geo.dart';
import 'package:izmir_go/core/search_text.dart';
import 'package:izmir_go/data/services/api_client.dart';
import 'package:izmir_go/data/services/local/app_database.dart';
import 'package:izmir_go/domain/models/transit.dart';

enum CatalogSyncResult { updated, unchanged }

/// Keeps an offline copy of all stops and routes of the active dataset (ETag-revalidated).
class CatalogRepository {
  CatalogRepository(this._api, this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final IzmirGoApi _api;
  final AppDatabase _db;
  final DateTime Function() _clock;
  static const syncEvery = Duration(hours: 24);

  Future<DateTime?> lastSync() async {
    final v = await _db.readValue('catalog.synced_at');
    return v == null ? null : DateTime.parse(v);
  }

  Future<String?> datasetLabel() => _db.readValue('catalog.dataset');

  Future<bool> needsSync() async {
    final last = await lastSync();
    return last == null ||
        _clock().difference(last) > syncEvery ||
        await _db.catalogStopCount() == 0;
  }

  Future<CatalogSyncResult> sync() async {
    final etag = await _db.readValue('catalog.etag');
    final hasData = await _db.catalogStopCount() > 0;
    final result = await _api.catalog(etag: hasData ? etag : null);
    final now = _clock().toUtc();
    if (result == null) {
      await _db.writeValue('catalog.synced_at', now.toIso8601String());
      return CatalogSyncResult.unchanged;
    }
    final (snapshot, newEtag) = result;
    await _db.replaceCatalog(
      [
        for (final s in snapshot.stops)
          CatalogStopsCompanion.insert(
            id: s.id,
            name: s.name,
            searchKey: fold(s.name),
            lat: s.lat,
            lon: s.lon,
            modes: s.modes.map((m) => m.name).join(','),
            kind: s.kind,
            hasSchedule: s.hasSchedule,
            parentStation: Value(s.parentStation),
            lines: Value(s.lines.join(',')),
          ),
      ],
      [
        for (final r in snapshot.routes)
          CatalogRoutesCompanion.insert(
            id: r.id,
            mode: r.mode.name,
            searchKey: fold('${r.shortName ?? ''} ${r.longName ?? ''}'),
            json: jsonEncode(r.toJson()),
          ),
      ],
    );
    if (newEtag != null) {
      await _db.writeValue('catalog.etag', newEtag);
    }
    await _db.writeValue('catalog.dataset', snapshot.dataset.label);
    await _db.writeValue('catalog.synced_at', now.toIso8601String());
    return CatalogSyncResult.updated;
  }

  StopSummary _toSummary(CatalogStopRow row, {int? distanceM}) => StopSummary(
    id: row.id,
    name: row.name,
    lat: row.lat,
    lon: row.lon,
    modes: _modes(row.modes),
    kind: row.kind,
    source: row.id.split(':').first,
    hasSchedule: row.hasSchedule,
    parentStation: row.parentStation,
    lines: row.lines.isEmpty ? const [] : row.lines.split(','),
    distanceM: distanceM,
  );

  static List<TransitMode> _modes(String raw) => [
    for (final m in raw.split(',').where((m) => m.isNotEmpty))
      TransitMode.values.firstWhere((v) => v.name == m, orElse: () => TransitMode.other),
  ];

  /// Offline search: stations first, then prefix matches, then substring matches.
  Future<List<StopSummary>> searchStops(String query, {int limit = 20}) async {
    final key = fold(query);
    if (key.isEmpty) {
      return const [];
    }
    final rows =
        await (_db.select(_db.catalogStops)
              ..where(
                (t) =>
                    t.searchKey.like('%$key%') &
                    (t.parentStation.isNull() | t.kind.equals('station')),
              )
              ..limit(200))
            .get();
    int rank(CatalogStopRow r) =>
        (r.kind == 'station' ? 0 : 2) + (r.searchKey.startsWith(key) ? 0 : 1);
    rows.sort((a, b) {
      final c = rank(a).compareTo(rank(b));
      return c != 0 ? c : a.name.compareTo(b.name);
    });
    return rows.take(limit).map(_toSummary).toList();
  }

  /// Offline nearby: exact distances over the cached catalog.
  Future<List<StopSummary>> nearby(
    double lat,
    double lon, {
    int radiusM = 500,
    int limit = 20,
  }) async {
    const deg = 0.02; // ~2 km prefilter box
    final rows =
        await (_db.select(_db.catalogStops)..where(
              (t) =>
                  t.lat.isBetweenValues(lat - deg, lat + deg) &
                  t.lon.isBetweenValues(lon - deg, lon + deg) &
                  t.kind.equals('stop'),
            ))
            .get();
    final withDistance = [for (final r in rows) (r, haversineM(lat, lon, r.lat, r.lon).round())]
      ..retainWhere((e) => e.$2 <= radiusM)
      ..sort((a, b) => a.$2.compareTo(b.$2));
    return [for (final e in withDistance.take(limit)) _toSummary(e.$1, distanceM: e.$2)];
  }

  Future<StopSummary?> stopById(String id) async {
    final row = await (_db.select(
      _db.catalogStops,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toSummary(row);
  }

  Future<List<RouteSummary>> routes({String? query, TransitMode? mode}) async {
    final key = query == null ? '' : fold(query);
    final rows =
        await (_db.select(_db.catalogRoutes)..where((t) {
              Expression<bool> e = const Constant(true);
              if (key.isNotEmpty) {
                e = e & t.searchKey.like('%$key%');
              }
              if (mode != null) {
                e = e & t.mode.equals(mode.name);
              }
              return e;
            }))
            .get();
    return [
      for (final r in rows) RouteSummary.fromJson(jsonDecode(r.json) as Map<String, dynamic>),
    ];
  }
}
