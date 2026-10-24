// Parses every backend example response with the app's models. If the backend contract
// changes (contracts/openapi.json + examples), this test fails until the app is updated.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:izmir_go/domain/models/transit.dart';

import '../helpers/fakes.dart';

void main() {
  final parsers = <String, Object Function(Map<String, dynamic>)>{
    'transit_status': TransitStatus.fromJson,
    'stops_search': StopPage.fromJson,
    'stop_detail_station': StopResponse.fromJson,
    'nearby_stops': NearbyResponse.fromJson,
    'departures': DeparturesResponse.fromJson,
    'approaching_vehicles': LiveResponse.fromJson,
    'routes': RouteList.fromJson,
    'route_detail': RouteResponse.fromJson,
    'route_schedule': ScheduleResponse.fromJson,
    'catalog_snapshot': CatalogSnapshot.fromJson,
    'places_search': PlacesResponse.fromJson,
    'alerts': AlertsResponse.fromJson,
    'journeys': JourneysResponse.fromJson,
  };

  test('every backend example has a parser', () {
    final files = Directory('../../contracts/examples')
        .listSync()
        .whereType<File>()
        .map((f) => f.uri.pathSegments.last.replaceAll('.json', ''))
        .toSet();
    expect(files, parsers.keys.toSet());
  });

  for (final entry in parsers.entries) {
    test('parses ${entry.key}', () {
      expect(() => entry.value(example(entry.key)), returnsNormally);
    });
  }

  test('journey example keeps the honesty fields', () {
    final res = JourneysResponse.fromJson(example('journeys'));
    final j = res.items.first;
    expect(j.basis, 'scheduled');
    expect(j.legs.map((l) => l.mode), [TransitMode.metro, TransitMode.walk, TransitMode.tram]);
    final walk = j.legs[1];
    expect(walk.isTransfer, isTrue);
    expect(walk.transferSource, 'curated');
    expect(j.legs.first.geometryBasis, 'stop_to_stop');
    expect(j.legs.last.geometryBasis, 'shape');
  });

  test('live example reports stops, not minutes', () {
    final live = LiveResponse.fromJson(example('approaching_vehicles'));
    expect(live.basis, 'live');
    expect(live.items.single.remainingStops, 2);
  });
}
