import 'package:flutter_test/flutter_test.dart';
import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/data/repositories/catalog_repository.dart';
import 'package:izmir_go/data/repositories/favorites_repository.dart';
import 'package:izmir_go/data/repositories/journeys_repository.dart';
import 'package:izmir_go/data/repositories/places_repository.dart';
import 'package:izmir_go/data/repositories/stops_repository.dart';
import 'package:izmir_go/data/services/local/app_database.dart';
import 'package:izmir_go/domain/models/fresh.dart';
import 'package:izmir_go/domain/models/transit.dart';

import '../helpers/fakes.dart';

void main() {
  late FakeApi api;
  late AppDatabase db;
  late CatalogRepository catalog;

  setUp(() {
    api = FakeApi();
    db = memoryDb();
    catalog = CatalogRepository(api, db, clock: () => fixedNow);
  });
  tearDown(() => db.close());

  group('catalog', () {
    test('sync stores stops and revalidates with ETag', () async {
      expect(await catalog.needsSync(), isTrue);
      expect(await catalog.sync(), CatalogSyncResult.updated);
      expect(await db.catalogStopCount(), greaterThan(5));
      expect(await catalog.sync(), CatalogSyncResult.unchanged);
      expect(await catalog.needsSync(), isFalse);
    });

    test('offline search folds Turkish text and puts stations first', () async {
      await catalog.sync();
      final hits = await catalog.searchStops('HALKAPINAR');
      expect(hits.first.id, 'stn:fx-halkapinar');
      expect(hits.map((s) => s.id), isNot(contains('metro:FXM2')));
    });

    test('offline nearby computes distances and includes directory stops', () async {
      await catalog.sync();
      final near = await catalog.nearby(38.434, 27.1712, radiusM: 300);
      expect(near.first.distanceM, lessThan(30));
      expect(near.any((s) => !s.hasSchedule), isTrue); // ESHOT directory stop, live only
    });
  });

  group('stops', () {
    test('falls back to the catalog when offline and labels it cached', () async {
      final repo = StopsRepository(api, db, catalog, clock: () => fixedNow);
      await catalog.sync();
      api.offline = true;
      final res = await repo.nearby(38.434, 27.1712);
      expect(res.origin, DataOrigin.cache);
      expect(res.data, isNotEmpty);
    });

    test('offline without any cache surfaces the network failure', () async {
      final repo = StopsRepository(api, db, catalog, clock: () => fixedNow);
      api.offline = true;
      expect(() => repo.search('x'), throwsA(isA<NetworkFailure>()));
    });

    test('cached departures keep only future departures', () async {
      // The example starts at 2026-10-29 00:00; pretend it is now 00:05 that night.
      final late = DateTime.utc(2026, 10, 28, 21, 5);
      final repo = StopsRepository(api, db, catalog, clock: () => late);
      final online = await repo.departures('stn:fx-halkapinar');
      expect(online.origin, DataOrigin.network);
      api.offline = true;
      final offline = await repo.departures('stn:fx-halkapinar');
      expect(offline.origin, DataOrigin.cache);
      expect(offline.data.items.length, lessThan(online.data.items.length));
      expect(offline.data.items.every((d) => d.scheduledDeparture.isAfter(late)), isTrue);
    });

    test('live data is never served from cache', () async {
      final repo = StopsRepository(api, db, catalog, clock: () => fixedNow);
      await repo.live('eshot:10005');
      api.offline = true;
      expect(() => repo.live('eshot:10005'), throwsA(isA<NetworkFailure>()));
    });
  });

  test('favorites toggle and stream', () async {
    final favs = FavoritesRepository(db, clock: () => fixedNow);
    final stream = favs.watchIsFavoriteStop('metro:FXM1');
    expect(await stream.first, isFalse);
    await favs.toggleStop('metro:FXM1', 'Fixture Stadyum', const [TransitMode.metro]);
    expect(await favs.watchIsFavoriteStop('metro:FXM1').first, isTrue);
    expect((await favs.watchStops().first).single.modes, [TransitMode.metro]);
    await favs.toggleStop('metro:FXM1', 'Fixture Stadyum', const [TransitMode.metro]);
    expect(await favs.watchStops().first, isEmpty);
  });

  test('recent places never store the device location and stay bounded', () async {
    final places = PlacesRepository(api, db, catalog, clock: () => fixedNow);
    await places.addRecent(
      const Place(
        id: 'current-location',
        name: 'Konumum',
        lat: 1,
        lon: 1,
        kind: 'address',
        provider: 'device',
      ),
    );
    for (var i = 0; i < 15; i++) {
      await places.addRecent(
        Place(id: 'p$i', name: 'P$i', lat: 38.4, lon: 27.1, kind: 'poi', provider: 'photon'),
      );
    }
    final recent = await places.recent();
    expect(recent.length, AppDatabase.maxRecentPlaces);
    expect(recent.any((p) => p.id == 'current-location'), isFalse);
  });

  test('journeys are remembered until they end', () async {
    final repo = JourneysRepository(api, db, clock: () => fixedNow);
    final res = await repo.plan(
      from: const Place(
        id: 'metro:FXM1',
        name: 'A',
        lat: 0,
        lon: 0,
        kind: 'stop',
        provider: 'catalog',
      ),
      to: const Place(
        id: 'x',
        name: 'B',
        lat: 38.4394,
        lon: 27.1478,
        kind: 'address',
        provider: 'photon',
      ),
    );
    expect(api.lastJourneyFrom, 'metro:FXM1'); // catalog stops are sent by id
    await repo.remember(res.items.first);
    final again = await repo.remembered(res.items.first.id);
    expect(again!.isCached, isTrue);
    expect(again.data.id, res.items.first.id);
  });
}
