import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:izmir_go/app/providers.dart';
import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/data/services/api_client.dart';
import 'package:izmir_go/data/services/local/app_database.dart';
import 'package:izmir_go/data/services/location_service.dart';
import 'package:izmir_go/domain/models/transit.dart';

/// Backend example responses (contracts/examples), generated from the SYNTHETIC fixture
/// dataset by backend/tests/integration/test_contract_examples.py.
Map<String, dynamic> example(String name) =>
    jsonDecode(File('../../contracts/examples/$name.json').readAsStringSync())
        as Map<String, dynamic>;

/// Fixed "now": Wednesday 2026-10-28 07:55 in İzmir (04:55 UTC).
final fixedNow = DateTime.utc(2026, 10, 28, 4, 55);

/// API double backed by the contract examples. Set [offline] to simulate no connectivity.
class FakeApi extends IzmirGoApi {
  FakeApi() : super(Dio());

  bool offline = false;
  int liveCalls = 0;
  int journeyCalls = 0;
  String? lastJourneyFrom;
  String? catalogEtag;

  Future<T> _answer<T>(T Function() f) async {
    if (offline) {
      throw const NetworkFailure('offline');
    }
    return f();
  }

  @override
  Future<TransitStatus> transitStatus() =>
      _answer(() => TransitStatus.fromJson(example('transit_status')));

  @override
  Future<StopPage> searchStops({String? q, String? modes, int limit = 20, String? cursor}) =>
      _answer(() => StopPage.fromJson(example('stops_search')));

  @override
  Future<StopResponse> stop(String id) =>
      _answer(() => StopResponse.fromJson(example('stop_detail_station')));

  @override
  Future<NearbyResponse> nearby({
    required double lat,
    required double lon,
    int radiusM = 500,
    int limit = 20,
  }) => _answer(() => NearbyResponse.fromJson(example('nearby_stops')));

  @override
  Future<DeparturesResponse> departures(String stopId, {String? at, int limit = 20}) =>
      _answer(() => DeparturesResponse.fromJson(example('departures')));

  @override
  Future<LiveResponse> approaching(String stopId) => _answer(() {
    liveCalls++;
    return LiveResponse.fromJson(example('approaching_vehicles'));
  });

  @override
  Future<RouteList> routes({String? modes, String? q}) =>
      _answer(() => RouteList.fromJson(example('routes')));

  @override
  Future<RouteResponse> route(String id) =>
      _answer(() => RouteResponse.fromJson(example('route_detail')));

  @override
  Future<ScheduleResponse> schedule(String routeId, {String? date, int? direction}) =>
      _answer(() => ScheduleResponse.fromJson(example('route_schedule')));

  @override
  Future<AlertsResponse> alerts({String? route}) =>
      _answer(() => AlertsResponse.fromJson(example('alerts')));

  @override
  Future<PlacesResponse> searchPlaces(String q, {double? lat, double? lon}) =>
      _answer(() => PlacesResponse.fromJson(example('places_search')));

  @override
  Future<JourneysResponse> journeys({
    required String from,
    required String to,
    String? at,
    bool arriveBy = false,
    int limit = 3,
  }) => _answer(() {
    journeyCalls++;
    lastJourneyFrom = from;
    return JourneysResponse.fromJson(example('journeys'));
  });

  @override
  Future<(CatalogSnapshot, String?)?> catalog({String? etag}) => _answer(() {
    final snap = CatalogSnapshot.fromJson(example('catalog_snapshot'));
    final tag = '"${snap.dataset.label}"';
    if (etag == tag) {
      return null;
    }
    catalogEtag = tag;
    return (snap, tag);
  });
}

class FakeLocation extends LocationService {
  FakeLocation({this.permissionValue = LocationPermission.denied, this.position, this.failure});
  LocationPermission permissionValue;
  LatLon? position;
  LocationFailure? failure;
  int requests = 0;

  @override
  Future<LocationPermission> permission() async => permissionValue;

  @override
  Future<LatLon> current({bool requestIfNeeded = true}) async {
    requests++;
    if (failure != null) {
      throw failure!;
    }
    return position ?? const LatLon(38.4428, 27.1812);
  }
}

AppDatabase memoryDb() => AppDatabase(NativeDatabase.memory());

List<Override> testOverrides({
  required FakeApi api,
  required AppDatabase db,
  LocationService? location,
}) => [
  apiProvider.overrideWithValue(api),
  databaseProvider.overrideWithValue(db),
  mapsEnabledProvider.overrideWithValue(false),
  clockProvider.overrideWithValue(() => fixedNow),
  locationServiceProvider.overrideWithValue(location ?? FakeLocation()),
];
