import 'package:izmir_go/data/repositories/cache_policy.dart';
import 'package:izmir_go/data/services/api_client.dart';
import 'package:izmir_go/data/services/local/app_database.dart';
import 'package:izmir_go/domain/models/fresh.dart';
import 'package:izmir_go/domain/models/transit.dart';

class StatusRepository {
  StatusRepository(this._api, this._db);

  final IzmirGoApi _api;
  final AppDatabase _db;

  Future<Fresh<TransitStatus>> status() => networkFirst(
    db: _db,
    cacheKey: 'transit_status',
    fetch: _api.transitStatus,
    toJson: (v) => v.toJson(),
    fromJson: TransitStatus.fromJson,
  );
}
