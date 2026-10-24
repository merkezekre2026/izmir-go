import 'package:dio/dio.dart';
import 'package:izmir_go/core/failures.dart';
import 'package:izmir_go/domain/models/transit.dart';

/// Thin, stateless wrapper over the İzmir Go REST API (`/api/v1`).
/// One method per endpoint; errors are converted to [AppFailure].
class IzmirGoApi {
  IzmirGoApi(this._dio);

  factory IzmirGoApi.create(String baseUrl, {String appVersion = '0.1.0'}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept-Language': 'tr', 'X-App-Version': appVersion},
        // Treat 304 as success so ETag revalidation works.
        validateStatus: (s) => s != null && (s < 300 || s == 304),
      ),
    );
    return IzmirGoApi(dio);
  }

  final Dio _dio;

  Future<Map<String, dynamic>> _get(String path, [Map<String, Object?>? query]) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: {
          for (final e in (query ?? const {}).entries)
            if (e.value != null) e.key: e.value,
        },
      );
      return res.data ?? const {};
    } on DioException catch (e) {
      throw failureFromDio(e);
    }
  }

  Future<TransitStatus> transitStatus() async =>
      TransitStatus.fromJson(await _get('/transit/status'));

  Future<StopPage> searchStops({String? q, String? modes, int limit = 20, String? cursor}) async =>
      StopPage.fromJson(
        await _get('/stops', {'q': q, 'modes': modes, 'limit': limit, 'cursor': cursor}),
      );

  Future<StopResponse> stop(String id) async =>
      StopResponse.fromJson(await _get('/stops/${Uri.encodeComponent(id)}'));

  Future<NearbyResponse> nearby({
    required double lat,
    required double lon,
    int radiusM = 500,
    int limit = 20,
  }) async => NearbyResponse.fromJson(
    await _get('/nearby-stops', {'lat': lat, 'lon': lon, 'radius_m': radiusM, 'limit': limit}),
  );

  Future<DeparturesResponse> departures(String stopId, {String? at, int limit = 20}) async =>
      DeparturesResponse.fromJson(
        await _get('/stops/${Uri.encodeComponent(stopId)}/departures', {'at': at, 'limit': limit}),
      );

  Future<LiveResponse> approaching(String stopId) async => LiveResponse.fromJson(
    await _get('/stops/${Uri.encodeComponent(stopId)}/approaching-vehicles'),
  );

  Future<RouteList> routes({String? modes, String? q}) async =>
      RouteList.fromJson(await _get('/routes', {'modes': modes, 'q': q}));

  Future<RouteResponse> route(String id) async =>
      RouteResponse.fromJson(await _get('/routes/${Uri.encodeComponent(id)}'));

  Future<ScheduleResponse> schedule(String routeId, {String? date, int? direction}) async =>
      ScheduleResponse.fromJson(
        await _get('/routes/${Uri.encodeComponent(routeId)}/schedule', {
          'date': date,
          'direction': direction,
        }),
      );

  Future<AlertsResponse> alerts({String? route}) async =>
      AlertsResponse.fromJson(await _get('/alerts', {'route': route}));

  Future<PlacesResponse> searchPlaces(String q, {double? lat, double? lon}) async =>
      PlacesResponse.fromJson(await _get('/places/search', {'q': q, 'lat': lat, 'lon': lon}));

  Future<PlacesResponse> reverse(double lat, double lon) async =>
      PlacesResponse.fromJson(await _get('/places/reverse', {'lat': lat, 'lon': lon}));

  Future<JourneysResponse> journeys({
    required String from,
    required String to,
    String? at,
    bool arriveBy = false,
    int limit = 3,
  }) async => JourneysResponse.fromJson(
    await _get('/journeys', {
      'from': from,
      'to': to,
      'at': at,
      'time_type': arriveBy ? 'arrive' : 'depart',
      'limit': limit,
    }),
  );

  /// Returns null when the server answers 304 Not Modified for [etag].
  Future<(CatalogSnapshot, String?)?> catalog({String? etag}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/catalog/snapshot',
        options: Options(headers: {'If-None-Match': ?etag}),
      );
      if (res.statusCode == 304 || res.data == null) {
        return null;
      }
      return (CatalogSnapshot.fromJson(res.data!), res.headers.value('etag'));
    } on DioException catch (e) {
      throw failureFromDio(e);
    }
  }
}
