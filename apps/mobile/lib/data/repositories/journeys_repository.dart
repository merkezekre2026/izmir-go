import 'dart:convert';

import 'package:izmir_go/data/services/api_client.dart';
import 'package:izmir_go/data/services/local/app_database.dart';
import 'package:izmir_go/domain/models/fresh.dart';
import 'package:izmir_go/domain/models/transit.dart';

/// Journey planning needs the server (and its routing engine): there is no offline planner.
/// Opened journeys are remembered until they end, so their details stay readable offline.
class JourneysRepository {
  JourneysRepository(this._api, this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final IzmirGoApi _api;
  final AppDatabase _db;
  final DateTime Function() _clock;

  Future<JourneysResponse> plan({
    required Place from,
    required Place to,
    String? at,
    bool arriveBy = false,
  }) => _api.journeys(
    from: from.journeyParam,
    to: to.journeyParam,
    at: at,
    arriveBy: arriveBy,
    limit: 5,
  );

  Future<void> remember(Journey journey) => _db.putCached(
    'journey:${journey.id}',
    jsonEncode(journey.toJson()),
    _clock().toUtc(),
    expiresAt: journey.end.toUtc().add(const Duration(hours: 1)),
  );

  Future<Fresh<Journey>?> remembered(String id) async {
    final row = await _db.cached('journey:$id');
    if (row == null) {
      return null;
    }
    return Fresh(
      Journey.fromJson(jsonDecode(row.json) as Map<String, dynamic>),
      fetchedAt: row.fetchedAt,
      origin: DataOrigin.cache,
    );
  }
}
