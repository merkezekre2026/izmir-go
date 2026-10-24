import 'dart:convert';

import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/data/services/local/app_database.dart';
import 'package:izmir_go/domain/models/fresh.dart';

/// Network first; on [NetworkFailure] fall back to the last cached copy (labelled as cached).
/// API problems (4xx/5xx with a problem document) are *not* masked by cache: they are real
/// answers the user should see.
Future<Fresh<T>> networkFirst<T>({
  required AppDatabase db,
  required String cacheKey,
  required Future<T> Function() fetch,
  required Map<String, dynamic> Function(T) toJson,
  required T Function(Map<String, dynamic>) fromJson,
  DateTime? expiresAt,
  DateTime Function() clock = DateTime.now,
}) async {
  try {
    final value = await fetch();
    final now = clock().toUtc();
    await db.putCached(cacheKey, jsonEncode(toJson(value)), now, expiresAt: expiresAt?.toUtc());
    return Fresh(value, fetchedAt: now, origin: DataOrigin.network);
  } on NetworkFailure {
    final row = await db.cached(cacheKey);
    final expired = row?.expiresAt != null && row!.expiresAt!.isBefore(clock().toUtc());
    if (row == null || expired) {
      rethrow;
    }
    return Fresh(
      fromJson(jsonDecode(row.json) as Map<String, dynamic>),
      fetchedAt: row.fetchedAt,
      origin: DataOrigin.cache,
    );
  }
}
