// Immutable models that mirror the İzmir Go API contract (contracts/openapi.json).
// Contract tests in test/domain/contract_test.dart parse the backend's example responses
// (contracts/examples) so any drift between client and server fails CI.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transit.freezed.dart';
part 'transit.g.dart';

enum TransitMode {
  bus,
  metro,
  tram,
  rail,
  ferry,
  walk,
  @JsonValue('other')
  other,
}

@freezed
abstract class Notice with _$Notice {
  const factory Notice({required String code, required String message, String? source}) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);
}

@freezed
abstract class DatasetRef with _$DatasetRef {
  const factory DatasetRef({required int id, required String label, DateTime? publishedAt}) =
      _DatasetRef;

  factory DatasetRef.fromJson(Map<String, dynamic> json) => _$DatasetRefFromJson(json);
}

@freezed
abstract class SourceWindow with _$SourceWindow {
  const factory SourceWindow({required String source, DateTime? validFrom, DateTime? validTo}) =
      _SourceWindow;

  factory SourceWindow.fromJson(Map<String, dynamic> json) => _$SourceWindowFromJson(json);
}

@freezed
abstract class Meta with _$Meta {
  const factory Meta({
    required DatasetRef dataset,
    required DateTime generatedAt,
    @Default(<SourceWindow>[]) List<SourceWindow> sources,
    @Default(<Notice>[]) List<Notice> notices,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}

@freezed
abstract class RouteSummary with _$RouteSummary {
  const factory RouteSummary({
    required String id,
    required String lineKey,
    required TransitMode mode,
    required String source,
    required bool timesApproximate,
    String? shortName,
    String? longName,
    String? color,
    String? textColor,
  }) = _RouteSummary;

  const RouteSummary._();

  factory RouteSummary.fromJson(Map<String, dynamic> json) => _$RouteSummaryFromJson(json);

  /// Short label for badges: "M1", "32" or the long name for tram lines.
  String get label => (shortName?.isNotEmpty ?? false) ? shortName! : (longName ?? id);
}

@freezed
abstract class StopSummary with _$StopSummary {
  const factory StopSummary({
    required String id,
    required String name,
    required double lat,
    required double lon,
    required List<TransitMode> modes,
    required String kind,
    required String source,
    required bool hasSchedule,
    String? code,
    String? parentStation,
    @Default(<String>[]) List<String> lines,
    int? distanceM,
  }) = _StopSummary;

  const StopSummary._();

  factory StopSummary.fromJson(Map<String, dynamic> json) => _$StopSummaryFromJson(json);

  bool get isStation => kind == 'station';
}

@freezed
abstract class StopDetail with _$StopDetail {
  const factory StopDetail({
    required String id,
    required String name,
    required double lat,
    required double lon,
    required List<TransitMode> modes,
    required String kind,
    required String source,
    required bool hasSchedule,
    required bool liveSupported,
    String? code,
    String? parentStation,
    int? wheelchairBoarding,
    @Default(<String>[]) List<String> lines,
    @Default(<StopSummary>[]) List<StopSummary> children,
    @Default(<RouteSummary>[]) List<RouteSummary> routes,
  }) = _StopDetail;

  factory StopDetail.fromJson(Map<String, dynamic> json) => _$StopDetailFromJson(json);
}

@freezed
abstract class StopResponse with _$StopResponse {
  const factory StopResponse({required StopDetail stop, required Meta meta}) = _StopResponse;

  factory StopResponse.fromJson(Map<String, dynamic> json) => _$StopResponseFromJson(json);
}

@freezed
abstract class StopPage with _$StopPage {
  const factory StopPage({
    required List<StopSummary> items,
    required Meta meta,
    String? nextCursor,
  }) = _StopPage;

  factory StopPage.fromJson(Map<String, dynamic> json) => _$StopPageFromJson(json);
}

@freezed
abstract class NearbyResponse with _$NearbyResponse {
  const factory NearbyResponse({required List<StopSummary> items, required Meta meta}) =
      _NearbyResponse;

  factory NearbyResponse.fromJson(Map<String, dynamic> json) => _$NearbyResponseFromJson(json);
}

@freezed
abstract class Departure with _$Departure {
  const factory Departure({
    required String stopId,
    required RouteSummary route,
    required String tripId,
    required DateTime serviceDate,
    required DateTime scheduledDeparture,
    required String basis,
    required bool timesApproximate,
    String? headsign,
    int? directionId,
    int? wheelchairAccessible,
  }) = _Departure;

  factory Departure.fromJson(Map<String, dynamic> json) => _$DepartureFromJson(json);
}

@freezed
abstract class DeparturesResponse with _$DeparturesResponse {
  const factory DeparturesResponse({
    required String stopId,
    required DateTime fromTime,
    required List<Departure> items,
    required Meta meta,
  }) = _DeparturesResponse;

  factory DeparturesResponse.fromJson(Map<String, dynamic> json) =>
      _$DeparturesResponseFromJson(json);
}

@freezed
abstract class ApproachingVehicle with _$ApproachingVehicle {
  const factory ApproachingVehicle({
    required String lineNumber,
    required String lineName,
    required int remainingStops,
    String? routeId,
    String? color,
    int? direction,
    double? lat,
    double? lon,
    String? vehicleId,
    bool? wheelchairAccessible,
    bool? bikeRack,
  }) = _ApproachingVehicle;

  factory ApproachingVehicle.fromJson(Map<String, dynamic> json) =>
      _$ApproachingVehicleFromJson(json);
}

@freezed
abstract class LiveResponse with _$LiveResponse {
  const factory LiveResponse({
    required String stopId,
    required bool supported,
    required String basis,
    DateTime? fetchedAt,
    String? source,
    @Default(<ApproachingVehicle>[]) List<ApproachingVehicle> items,
    Notice? notice,
  }) = _LiveResponse;

  factory LiveResponse.fromJson(Map<String, dynamic> json) => _$LiveResponseFromJson(json);
}

@freezed
abstract class Pattern with _$Pattern {
  const factory Pattern({
    required int tripCount,
    required List<StopSummary> stops,
    required String geometryBasis,
    int? directionId,
    String? headsign,
    List<List<double>>? geometry,
  }) = _Pattern;

  factory Pattern.fromJson(Map<String, dynamic> json) => _$PatternFromJson(json);
}

@freezed
abstract class RouteDetail with _$RouteDetail {
  const factory RouteDetail({
    required String id,
    required String lineKey,
    required TransitMode mode,
    required String source,
    required bool timesApproximate,
    required List<Pattern> patterns,
    String? shortName,
    String? longName,
    String? color,
    String? textColor,
    String? agencyName,
  }) = _RouteDetail;

  factory RouteDetail.fromJson(Map<String, dynamic> json) => _$RouteDetailFromJson(json);
}

@freezed
abstract class RouteResponse with _$RouteResponse {
  const factory RouteResponse({required RouteDetail route, required Meta meta}) = _RouteResponse;

  factory RouteResponse.fromJson(Map<String, dynamic> json) => _$RouteResponseFromJson(json);
}

@freezed
abstract class RouteList with _$RouteList {
  const factory RouteList({required List<RouteSummary> items, required Meta meta}) = _RouteList;

  factory RouteList.fromJson(Map<String, dynamic> json) => _$RouteListFromJson(json);
}

@freezed
abstract class ScheduledTrip with _$ScheduledTrip {
  const factory ScheduledTrip({
    required String tripId,
    required DateTime firstDeparture,
    required DateTime lastArrival,
    int? directionId,
    String? headsign,
  }) = _ScheduledTrip;

  factory ScheduledTrip.fromJson(Map<String, dynamic> json) => _$ScheduledTripFromJson(json);
}

@freezed
abstract class ScheduleResponse with _$ScheduleResponse {
  const factory ScheduleResponse({
    required String routeId,
    required DateTime serviceDate,
    required List<ScheduledTrip> items,
    required Meta meta,
  }) = _ScheduleResponse;

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) => _$ScheduleResponseFromJson(json);
}

@freezed
abstract class SourceStatus with _$SourceStatus {
  const factory SourceStatus({
    required String source,
    required String status,
    required bool timesApproximate,
    required bool liveData,
    String? operator,
    TransitMode? mode,
    String? reason,
    DateTime? validFrom,
    DateTime? validTo,
    DateTime? fetchedAt,
    DateTime? lastAttemptAt,
    String? lastAttemptStatus,
    bool? hasCalendarExceptions,
  }) = _SourceStatus;

  factory SourceStatus.fromJson(Map<String, dynamic> json) => _$SourceStatusFromJson(json);
}

@freezed
abstract class TransitStatus with _$TransitStatus {
  const factory TransitStatus({
    required List<SourceStatus> sources,
    required DateTime generatedAt,
    DatasetRef? dataset,
    DateTime? lastRunAt,
    String? lastRunStatus,
  }) = _TransitStatus;

  factory TransitStatus.fromJson(Map<String, dynamic> json) => _$TransitStatusFromJson(json);
}

@freezed
abstract class Alert with _$Alert {
  const factory Alert({
    required String id,
    required String source,
    required List<String> routeIds,
    required String title,
    required DateTime fetchedAt,
    String? lineShortName,
    DateTime? startsAt,
    DateTime? endsAt,
  }) = _Alert;

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}

@freezed
abstract class AlertsResponse with _$AlertsResponse {
  const factory AlertsResponse({required List<Alert> items, required DateTime generatedAt}) =
      _AlertsResponse;

  factory AlertsResponse.fromJson(Map<String, dynamic> json) => _$AlertsResponseFromJson(json);
}

@freezed
abstract class CatalogStop with _$CatalogStop {
  const factory CatalogStop({
    required String id,
    required String name,
    required double lat,
    required double lon,
    required List<TransitMode> modes,
    required String kind,
    required bool hasSchedule,
    String? parentStation,
    @Default(<String>[]) List<String> lines,
  }) = _CatalogStop;

  factory CatalogStop.fromJson(Map<String, dynamic> json) => _$CatalogStopFromJson(json);
}

@freezed
abstract class CatalogSnapshot with _$CatalogSnapshot {
  const factory CatalogSnapshot({
    required DatasetRef dataset,
    required DateTime generatedAt,
    required List<CatalogStop> stops,
    required List<RouteSummary> routes,
    required List<SourceWindow> sources,
  }) = _CatalogSnapshot;

  factory CatalogSnapshot.fromJson(Map<String, dynamic> json) => _$CatalogSnapshotFromJson(json);
}

@freezed
abstract class Place with _$Place {
  const factory Place({
    required String id,
    required String name,
    required double lat,
    required double lon,
    required String kind,
    required String provider,
    String? subtitle,
  }) = _Place;

  const Place._();

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  bool get isStop => kind == 'stop' || kind == 'station';

  /// Value for the journeys API: stop id for catalog stops, otherwise "lat,lon".
  String get journeyParam =>
      isStop && provider == 'catalog' ? id : '${lat.toStringAsFixed(6)},${lon.toStringAsFixed(6)}';
}

@freezed
abstract class PlacesResponse with _$PlacesResponse {
  const factory PlacesResponse({required List<Place> items, String? attribution}) = _PlacesResponse;

  factory PlacesResponse.fromJson(Map<String, dynamic> json) => _$PlacesResponseFromJson(json);
}

@freezed
abstract class JourneyPlace with _$JourneyPlace {
  const factory JourneyPlace({
    required String name,
    required double lat,
    required double lon,
    String? stopId,
    String? stationId,
  }) = _JourneyPlace;

  factory JourneyPlace.fromJson(Map<String, dynamic> json) => _$JourneyPlaceFromJson(json);
}

@freezed
abstract class IntermediateStop with _$IntermediateStop {
  const factory IntermediateStop({
    required String stopId,
    required String name,
    required double lat,
    required double lon,
    DateTime? scheduledDeparture,
  }) = _IntermediateStop;

  factory IntermediateStop.fromJson(Map<String, dynamic> json) => _$IntermediateStopFromJson(json);
}

@freezed
abstract class JourneyLeg with _$JourneyLeg {
  const factory JourneyLeg({
    required TransitMode mode,
    required DateTime start,
    required DateTime end,
    required int durationS,
    required int distanceM,
    required JourneyPlace origin,
    required JourneyPlace destination,
    required List<List<double>> geometry,
    required String geometryBasis,
    required String basis,
    required bool timesApproximate,
    @Default(false) bool isTransfer,
    RouteSummary? route,
    String? tripId,
    String? headsign,
    DateTime? serviceDate,
    @Default(<IntermediateStop>[]) List<IntermediateStop> intermediateStops,
    String? transferSource,
  }) = _JourneyLeg;

  const JourneyLeg._();

  factory JourneyLeg.fromJson(Map<String, dynamic> json) => _$JourneyLegFromJson(json);

  bool get isWalk => mode == TransitMode.walk;
}

@freezed
abstract class Journey with _$Journey {
  const factory Journey({
    required String id,
    required DateTime start,
    required DateTime end,
    required int durationS,
    required int transfers,
    required int walkDistanceM,
    required List<String> modes,
    required List<JourneyLeg> legs,
    required String basis,
  }) = _Journey;

  const Journey._();

  factory Journey.fromJson(Map<String, dynamic> json) => _$JourneyFromJson(json);

  bool get isWalkOnly => legs.every((l) => l.isWalk);
  List<JourneyLeg> get transitLegs => legs.where((l) => !l.isWalk).toList();
}

@freezed
abstract class RoutingProblem with _$RoutingProblem {
  const factory RoutingProblem({required String code, required String message}) = _RoutingProblem;

  factory RoutingProblem.fromJson(Map<String, dynamic> json) => _$RoutingProblemFromJson(json);
}

@freezed
abstract class JourneysResponse with _$JourneysResponse {
  const factory JourneysResponse({
    required List<Journey> items,
    required Meta meta,
    @Default(<RoutingProblem>[]) List<RoutingProblem> routingErrors,
  }) = _JourneysResponse;

  factory JourneysResponse.fromJson(Map<String, dynamic> json) => _$JourneysResponseFromJson(json);
}
