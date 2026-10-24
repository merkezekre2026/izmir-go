// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Notice _$NoticeFromJson(Map<String, dynamic> json) => _Notice(
  code: json['code'] as String,
  message: json['message'] as String,
  source: json['source'] as String?,
);

Map<String, dynamic> _$NoticeToJson(_Notice instance) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'source': instance.source,
};

_DatasetRef _$DatasetRefFromJson(Map<String, dynamic> json) => _DatasetRef(
  id: (json['id'] as num).toInt(),
  label: json['label'] as String,
  publishedAt: json['published_at'] == null ? null : DateTime.parse(json['published_at'] as String),
);

Map<String, dynamic> _$DatasetRefToJson(_DatasetRef instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'published_at': instance.publishedAt?.toIso8601String(),
};

_SourceWindow _$SourceWindowFromJson(Map<String, dynamic> json) => _SourceWindow(
  source: json['source'] as String,
  validFrom: json['valid_from'] == null ? null : DateTime.parse(json['valid_from'] as String),
  validTo: json['valid_to'] == null ? null : DateTime.parse(json['valid_to'] as String),
);

Map<String, dynamic> _$SourceWindowToJson(_SourceWindow instance) => <String, dynamic>{
  'source': instance.source,
  'valid_from': instance.validFrom?.toIso8601String(),
  'valid_to': instance.validTo?.toIso8601String(),
};

_Meta _$MetaFromJson(Map<String, dynamic> json) => _Meta(
  dataset: DatasetRef.fromJson(json['dataset'] as Map<String, dynamic>),
  generatedAt: DateTime.parse(json['generated_at'] as String),
  sources:
      (json['sources'] as List<dynamic>?)
          ?.map((e) => SourceWindow.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SourceWindow>[],
  notices:
      (json['notices'] as List<dynamic>?)
          ?.map((e) => Notice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Notice>[],
);

Map<String, dynamic> _$MetaToJson(_Meta instance) => <String, dynamic>{
  'dataset': instance.dataset.toJson(),
  'generated_at': instance.generatedAt.toIso8601String(),
  'sources': instance.sources.map((e) => e.toJson()).toList(),
  'notices': instance.notices.map((e) => e.toJson()).toList(),
};

_RouteSummary _$RouteSummaryFromJson(Map<String, dynamic> json) => _RouteSummary(
  id: json['id'] as String,
  lineKey: json['line_key'] as String,
  mode: $enumDecode(_$TransitModeEnumMap, json['mode']),
  source: json['source'] as String,
  timesApproximate: json['times_approximate'] as bool,
  shortName: json['short_name'] as String?,
  longName: json['long_name'] as String?,
  color: json['color'] as String?,
  textColor: json['text_color'] as String?,
);

Map<String, dynamic> _$RouteSummaryToJson(_RouteSummary instance) => <String, dynamic>{
  'id': instance.id,
  'line_key': instance.lineKey,
  'mode': _$TransitModeEnumMap[instance.mode]!,
  'source': instance.source,
  'times_approximate': instance.timesApproximate,
  'short_name': instance.shortName,
  'long_name': instance.longName,
  'color': instance.color,
  'text_color': instance.textColor,
};

const _$TransitModeEnumMap = {
  TransitMode.bus: 'bus',
  TransitMode.metro: 'metro',
  TransitMode.tram: 'tram',
  TransitMode.rail: 'rail',
  TransitMode.ferry: 'ferry',
  TransitMode.walk: 'walk',
  TransitMode.other: 'other',
};

_StopSummary _$StopSummaryFromJson(Map<String, dynamic> json) => _StopSummary(
  id: json['id'] as String,
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  modes: (json['modes'] as List<dynamic>).map((e) => $enumDecode(_$TransitModeEnumMap, e)).toList(),
  kind: json['kind'] as String,
  source: json['source'] as String,
  hasSchedule: json['has_schedule'] as bool,
  code: json['code'] as String?,
  parentStation: json['parent_station'] as String?,
  lines: (json['lines'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  distanceM: (json['distance_m'] as num?)?.toInt(),
);

Map<String, dynamic> _$StopSummaryToJson(_StopSummary instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lat': instance.lat,
  'lon': instance.lon,
  'modes': instance.modes.map((e) => _$TransitModeEnumMap[e]!).toList(),
  'kind': instance.kind,
  'source': instance.source,
  'has_schedule': instance.hasSchedule,
  'code': instance.code,
  'parent_station': instance.parentStation,
  'lines': instance.lines,
  'distance_m': instance.distanceM,
};

_StopDetail _$StopDetailFromJson(Map<String, dynamic> json) => _StopDetail(
  id: json['id'] as String,
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  modes: (json['modes'] as List<dynamic>).map((e) => $enumDecode(_$TransitModeEnumMap, e)).toList(),
  kind: json['kind'] as String,
  source: json['source'] as String,
  hasSchedule: json['has_schedule'] as bool,
  liveSupported: json['live_supported'] as bool,
  code: json['code'] as String?,
  parentStation: json['parent_station'] as String?,
  wheelchairBoarding: (json['wheelchair_boarding'] as num?)?.toInt(),
  lines: (json['lines'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => StopSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <StopSummary>[],
  routes:
      (json['routes'] as List<dynamic>?)
          ?.map((e) => RouteSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RouteSummary>[],
);

Map<String, dynamic> _$StopDetailToJson(_StopDetail instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lat': instance.lat,
  'lon': instance.lon,
  'modes': instance.modes.map((e) => _$TransitModeEnumMap[e]!).toList(),
  'kind': instance.kind,
  'source': instance.source,
  'has_schedule': instance.hasSchedule,
  'live_supported': instance.liveSupported,
  'code': instance.code,
  'parent_station': instance.parentStation,
  'wheelchair_boarding': instance.wheelchairBoarding,
  'lines': instance.lines,
  'children': instance.children.map((e) => e.toJson()).toList(),
  'routes': instance.routes.map((e) => e.toJson()).toList(),
};

_StopResponse _$StopResponseFromJson(Map<String, dynamic> json) => _StopResponse(
  stop: StopDetail.fromJson(json['stop'] as Map<String, dynamic>),
  meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StopResponseToJson(_StopResponse instance) => <String, dynamic>{
  'stop': instance.stop.toJson(),
  'meta': instance.meta.toJson(),
};

_StopPage _$StopPageFromJson(Map<String, dynamic> json) => _StopPage(
  items: (json['items'] as List<dynamic>)
      .map((e) => StopSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$StopPageToJson(_StopPage instance) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
  'next_cursor': instance.nextCursor,
};

_NearbyResponse _$NearbyResponseFromJson(Map<String, dynamic> json) => _NearbyResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => StopSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NearbyResponseToJson(_NearbyResponse instance) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};

_Departure _$DepartureFromJson(Map<String, dynamic> json) => _Departure(
  stopId: json['stop_id'] as String,
  route: RouteSummary.fromJson(json['route'] as Map<String, dynamic>),
  tripId: json['trip_id'] as String,
  serviceDate: DateTime.parse(json['service_date'] as String),
  scheduledDeparture: DateTime.parse(json['scheduled_departure'] as String),
  basis: json['basis'] as String,
  timesApproximate: json['times_approximate'] as bool,
  headsign: json['headsign'] as String?,
  directionId: (json['direction_id'] as num?)?.toInt(),
  wheelchairAccessible: (json['wheelchair_accessible'] as num?)?.toInt(),
);

Map<String, dynamic> _$DepartureToJson(_Departure instance) => <String, dynamic>{
  'stop_id': instance.stopId,
  'route': instance.route.toJson(),
  'trip_id': instance.tripId,
  'service_date': instance.serviceDate.toIso8601String(),
  'scheduled_departure': instance.scheduledDeparture.toIso8601String(),
  'basis': instance.basis,
  'times_approximate': instance.timesApproximate,
  'headsign': instance.headsign,
  'direction_id': instance.directionId,
  'wheelchair_accessible': instance.wheelchairAccessible,
};

_DeparturesResponse _$DeparturesResponseFromJson(Map<String, dynamic> json) => _DeparturesResponse(
  stopId: json['stop_id'] as String,
  fromTime: DateTime.parse(json['from_time'] as String),
  items: (json['items'] as List<dynamic>)
      .map((e) => Departure.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DeparturesResponseToJson(_DeparturesResponse instance) => <String, dynamic>{
  'stop_id': instance.stopId,
  'from_time': instance.fromTime.toIso8601String(),
  'items': instance.items.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};

_ApproachingVehicle _$ApproachingVehicleFromJson(Map<String, dynamic> json) => _ApproachingVehicle(
  lineNumber: json['line_number'] as String,
  lineName: json['line_name'] as String,
  remainingStops: (json['remaining_stops'] as num).toInt(),
  routeId: json['route_id'] as String?,
  color: json['color'] as String?,
  direction: (json['direction'] as num?)?.toInt(),
  lat: (json['lat'] as num?)?.toDouble(),
  lon: (json['lon'] as num?)?.toDouble(),
  vehicleId: json['vehicle_id'] as String?,
  wheelchairAccessible: json['wheelchair_accessible'] as bool?,
  bikeRack: json['bike_rack'] as bool?,
);

Map<String, dynamic> _$ApproachingVehicleToJson(_ApproachingVehicle instance) => <String, dynamic>{
  'line_number': instance.lineNumber,
  'line_name': instance.lineName,
  'remaining_stops': instance.remainingStops,
  'route_id': instance.routeId,
  'color': instance.color,
  'direction': instance.direction,
  'lat': instance.lat,
  'lon': instance.lon,
  'vehicle_id': instance.vehicleId,
  'wheelchair_accessible': instance.wheelchairAccessible,
  'bike_rack': instance.bikeRack,
};

_LiveResponse _$LiveResponseFromJson(Map<String, dynamic> json) => _LiveResponse(
  stopId: json['stop_id'] as String,
  supported: json['supported'] as bool,
  basis: json['basis'] as String,
  fetchedAt: json['fetched_at'] == null ? null : DateTime.parse(json['fetched_at'] as String),
  source: json['source'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ApproachingVehicle.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ApproachingVehicle>[],
  notice: json['notice'] == null ? null : Notice.fromJson(json['notice'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LiveResponseToJson(_LiveResponse instance) => <String, dynamic>{
  'stop_id': instance.stopId,
  'supported': instance.supported,
  'basis': instance.basis,
  'fetched_at': instance.fetchedAt?.toIso8601String(),
  'source': instance.source,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'notice': instance.notice?.toJson(),
};

_Pattern _$PatternFromJson(Map<String, dynamic> json) => _Pattern(
  tripCount: (json['trip_count'] as num).toInt(),
  stops: (json['stops'] as List<dynamic>)
      .map((e) => StopSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  geometryBasis: json['geometry_basis'] as String,
  directionId: (json['direction_id'] as num?)?.toInt(),
  headsign: json['headsign'] as String?,
  geometry: (json['geometry'] as List<dynamic>?)
      ?.map((e) => (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
      .toList(),
);

Map<String, dynamic> _$PatternToJson(_Pattern instance) => <String, dynamic>{
  'trip_count': instance.tripCount,
  'stops': instance.stops.map((e) => e.toJson()).toList(),
  'geometry_basis': instance.geometryBasis,
  'direction_id': instance.directionId,
  'headsign': instance.headsign,
  'geometry': instance.geometry,
};

_RouteDetail _$RouteDetailFromJson(Map<String, dynamic> json) => _RouteDetail(
  id: json['id'] as String,
  lineKey: json['line_key'] as String,
  mode: $enumDecode(_$TransitModeEnumMap, json['mode']),
  source: json['source'] as String,
  timesApproximate: json['times_approximate'] as bool,
  patterns: (json['patterns'] as List<dynamic>)
      .map((e) => Pattern.fromJson(e as Map<String, dynamic>))
      .toList(),
  shortName: json['short_name'] as String?,
  longName: json['long_name'] as String?,
  color: json['color'] as String?,
  textColor: json['text_color'] as String?,
  agencyName: json['agency_name'] as String?,
);

Map<String, dynamic> _$RouteDetailToJson(_RouteDetail instance) => <String, dynamic>{
  'id': instance.id,
  'line_key': instance.lineKey,
  'mode': _$TransitModeEnumMap[instance.mode]!,
  'source': instance.source,
  'times_approximate': instance.timesApproximate,
  'patterns': instance.patterns.map((e) => e.toJson()).toList(),
  'short_name': instance.shortName,
  'long_name': instance.longName,
  'color': instance.color,
  'text_color': instance.textColor,
  'agency_name': instance.agencyName,
};

_RouteResponse _$RouteResponseFromJson(Map<String, dynamic> json) => _RouteResponse(
  route: RouteDetail.fromJson(json['route'] as Map<String, dynamic>),
  meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RouteResponseToJson(_RouteResponse instance) => <String, dynamic>{
  'route': instance.route.toJson(),
  'meta': instance.meta.toJson(),
};

_RouteList _$RouteListFromJson(Map<String, dynamic> json) => _RouteList(
  items: (json['items'] as List<dynamic>)
      .map((e) => RouteSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RouteListToJson(_RouteList instance) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};

_ScheduledTrip _$ScheduledTripFromJson(Map<String, dynamic> json) => _ScheduledTrip(
  tripId: json['trip_id'] as String,
  firstDeparture: DateTime.parse(json['first_departure'] as String),
  lastArrival: DateTime.parse(json['last_arrival'] as String),
  directionId: (json['direction_id'] as num?)?.toInt(),
  headsign: json['headsign'] as String?,
);

Map<String, dynamic> _$ScheduledTripToJson(_ScheduledTrip instance) => <String, dynamic>{
  'trip_id': instance.tripId,
  'first_departure': instance.firstDeparture.toIso8601String(),
  'last_arrival': instance.lastArrival.toIso8601String(),
  'direction_id': instance.directionId,
  'headsign': instance.headsign,
};

_ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) => _ScheduleResponse(
  routeId: json['route_id'] as String,
  serviceDate: DateTime.parse(json['service_date'] as String),
  items: (json['items'] as List<dynamic>)
      .map((e) => ScheduledTrip.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduleResponseToJson(_ScheduleResponse instance) => <String, dynamic>{
  'route_id': instance.routeId,
  'service_date': instance.serviceDate.toIso8601String(),
  'items': instance.items.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};

_SourceStatus _$SourceStatusFromJson(Map<String, dynamic> json) => _SourceStatus(
  source: json['source'] as String,
  status: json['status'] as String,
  timesApproximate: json['times_approximate'] as bool,
  liveData: json['live_data'] as bool,
  operator: json['operator'] as String?,
  mode: $enumDecodeNullable(_$TransitModeEnumMap, json['mode']),
  reason: json['reason'] as String?,
  validFrom: json['valid_from'] == null ? null : DateTime.parse(json['valid_from'] as String),
  validTo: json['valid_to'] == null ? null : DateTime.parse(json['valid_to'] as String),
  fetchedAt: json['fetched_at'] == null ? null : DateTime.parse(json['fetched_at'] as String),
  lastAttemptAt: json['last_attempt_at'] == null
      ? null
      : DateTime.parse(json['last_attempt_at'] as String),
  lastAttemptStatus: json['last_attempt_status'] as String?,
  hasCalendarExceptions: json['has_calendar_exceptions'] as bool?,
);

Map<String, dynamic> _$SourceStatusToJson(_SourceStatus instance) => <String, dynamic>{
  'source': instance.source,
  'status': instance.status,
  'times_approximate': instance.timesApproximate,
  'live_data': instance.liveData,
  'operator': instance.operator,
  'mode': _$TransitModeEnumMap[instance.mode],
  'reason': instance.reason,
  'valid_from': instance.validFrom?.toIso8601String(),
  'valid_to': instance.validTo?.toIso8601String(),
  'fetched_at': instance.fetchedAt?.toIso8601String(),
  'last_attempt_at': instance.lastAttemptAt?.toIso8601String(),
  'last_attempt_status': instance.lastAttemptStatus,
  'has_calendar_exceptions': instance.hasCalendarExceptions,
};

_TransitStatus _$TransitStatusFromJson(Map<String, dynamic> json) => _TransitStatus(
  sources: (json['sources'] as List<dynamic>)
      .map((e) => SourceStatus.fromJson(e as Map<String, dynamic>))
      .toList(),
  generatedAt: DateTime.parse(json['generated_at'] as String),
  dataset: json['dataset'] == null
      ? null
      : DatasetRef.fromJson(json['dataset'] as Map<String, dynamic>),
  lastRunAt: json['last_run_at'] == null ? null : DateTime.parse(json['last_run_at'] as String),
  lastRunStatus: json['last_run_status'] as String?,
);

Map<String, dynamic> _$TransitStatusToJson(_TransitStatus instance) => <String, dynamic>{
  'sources': instance.sources.map((e) => e.toJson()).toList(),
  'generated_at': instance.generatedAt.toIso8601String(),
  'dataset': instance.dataset?.toJson(),
  'last_run_at': instance.lastRunAt?.toIso8601String(),
  'last_run_status': instance.lastRunStatus,
};

_Alert _$AlertFromJson(Map<String, dynamic> json) => _Alert(
  id: json['id'] as String,
  source: json['source'] as String,
  routeIds: (json['route_ids'] as List<dynamic>).map((e) => e as String).toList(),
  title: json['title'] as String,
  fetchedAt: DateTime.parse(json['fetched_at'] as String),
  lineShortName: json['line_short_name'] as String?,
  startsAt: json['starts_at'] == null ? null : DateTime.parse(json['starts_at'] as String),
  endsAt: json['ends_at'] == null ? null : DateTime.parse(json['ends_at'] as String),
);

Map<String, dynamic> _$AlertToJson(_Alert instance) => <String, dynamic>{
  'id': instance.id,
  'source': instance.source,
  'route_ids': instance.routeIds,
  'title': instance.title,
  'fetched_at': instance.fetchedAt.toIso8601String(),
  'line_short_name': instance.lineShortName,
  'starts_at': instance.startsAt?.toIso8601String(),
  'ends_at': instance.endsAt?.toIso8601String(),
};

_AlertsResponse _$AlertsResponseFromJson(Map<String, dynamic> json) => _AlertsResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => Alert.fromJson(e as Map<String, dynamic>))
      .toList(),
  generatedAt: DateTime.parse(json['generated_at'] as String),
);

Map<String, dynamic> _$AlertsResponseToJson(_AlertsResponse instance) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'generated_at': instance.generatedAt.toIso8601String(),
};

_CatalogStop _$CatalogStopFromJson(Map<String, dynamic> json) => _CatalogStop(
  id: json['id'] as String,
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  modes: (json['modes'] as List<dynamic>).map((e) => $enumDecode(_$TransitModeEnumMap, e)).toList(),
  kind: json['kind'] as String,
  hasSchedule: json['has_schedule'] as bool,
  parentStation: json['parent_station'] as String?,
  lines: (json['lines'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$CatalogStopToJson(_CatalogStop instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lat': instance.lat,
  'lon': instance.lon,
  'modes': instance.modes.map((e) => _$TransitModeEnumMap[e]!).toList(),
  'kind': instance.kind,
  'has_schedule': instance.hasSchedule,
  'parent_station': instance.parentStation,
  'lines': instance.lines,
};

_CatalogSnapshot _$CatalogSnapshotFromJson(Map<String, dynamic> json) => _CatalogSnapshot(
  dataset: DatasetRef.fromJson(json['dataset'] as Map<String, dynamic>),
  generatedAt: DateTime.parse(json['generated_at'] as String),
  stops: (json['stops'] as List<dynamic>)
      .map((e) => CatalogStop.fromJson(e as Map<String, dynamic>))
      .toList(),
  routes: (json['routes'] as List<dynamic>)
      .map((e) => RouteSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
  sources: (json['sources'] as List<dynamic>)
      .map((e) => SourceWindow.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CatalogSnapshotToJson(_CatalogSnapshot instance) => <String, dynamic>{
  'dataset': instance.dataset.toJson(),
  'generated_at': instance.generatedAt.toIso8601String(),
  'stops': instance.stops.map((e) => e.toJson()).toList(),
  'routes': instance.routes.map((e) => e.toJson()).toList(),
  'sources': instance.sources.map((e) => e.toJson()).toList(),
};

_Place _$PlaceFromJson(Map<String, dynamic> json) => _Place(
  id: json['id'] as String,
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  kind: json['kind'] as String,
  provider: json['provider'] as String,
  subtitle: json['subtitle'] as String?,
);

Map<String, dynamic> _$PlaceToJson(_Place instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lat': instance.lat,
  'lon': instance.lon,
  'kind': instance.kind,
  'provider': instance.provider,
  'subtitle': instance.subtitle,
};

_PlacesResponse _$PlacesResponseFromJson(Map<String, dynamic> json) => _PlacesResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => Place.fromJson(e as Map<String, dynamic>))
      .toList(),
  attribution: json['attribution'] as String?,
);

Map<String, dynamic> _$PlacesResponseToJson(_PlacesResponse instance) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'attribution': instance.attribution,
};

_JourneyPlace _$JourneyPlaceFromJson(Map<String, dynamic> json) => _JourneyPlace(
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  stopId: json['stop_id'] as String?,
  stationId: json['station_id'] as String?,
);

Map<String, dynamic> _$JourneyPlaceToJson(_JourneyPlace instance) => <String, dynamic>{
  'name': instance.name,
  'lat': instance.lat,
  'lon': instance.lon,
  'stop_id': instance.stopId,
  'station_id': instance.stationId,
};

_IntermediateStop _$IntermediateStopFromJson(Map<String, dynamic> json) => _IntermediateStop(
  stopId: json['stop_id'] as String,
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  scheduledDeparture: json['scheduled_departure'] == null
      ? null
      : DateTime.parse(json['scheduled_departure'] as String),
);

Map<String, dynamic> _$IntermediateStopToJson(_IntermediateStop instance) => <String, dynamic>{
  'stop_id': instance.stopId,
  'name': instance.name,
  'lat': instance.lat,
  'lon': instance.lon,
  'scheduled_departure': instance.scheduledDeparture?.toIso8601String(),
};

_JourneyLeg _$JourneyLegFromJson(Map<String, dynamic> json) => _JourneyLeg(
  mode: $enumDecode(_$TransitModeEnumMap, json['mode']),
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  durationS: (json['duration_s'] as num).toInt(),
  distanceM: (json['distance_m'] as num).toInt(),
  origin: JourneyPlace.fromJson(json['origin'] as Map<String, dynamic>),
  destination: JourneyPlace.fromJson(json['destination'] as Map<String, dynamic>),
  geometry: (json['geometry'] as List<dynamic>)
      .map((e) => (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
      .toList(),
  geometryBasis: json['geometry_basis'] as String,
  basis: json['basis'] as String,
  timesApproximate: json['times_approximate'] as bool,
  isTransfer: json['is_transfer'] as bool? ?? false,
  route: json['route'] == null
      ? null
      : RouteSummary.fromJson(json['route'] as Map<String, dynamic>),
  tripId: json['trip_id'] as String?,
  headsign: json['headsign'] as String?,
  serviceDate: json['service_date'] == null ? null : DateTime.parse(json['service_date'] as String),
  intermediateStops:
      (json['intermediate_stops'] as List<dynamic>?)
          ?.map((e) => IntermediateStop.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <IntermediateStop>[],
  transferSource: json['transfer_source'] as String?,
);

Map<String, dynamic> _$JourneyLegToJson(_JourneyLeg instance) => <String, dynamic>{
  'mode': _$TransitModeEnumMap[instance.mode]!,
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
  'duration_s': instance.durationS,
  'distance_m': instance.distanceM,
  'origin': instance.origin.toJson(),
  'destination': instance.destination.toJson(),
  'geometry': instance.geometry,
  'geometry_basis': instance.geometryBasis,
  'basis': instance.basis,
  'times_approximate': instance.timesApproximate,
  'is_transfer': instance.isTransfer,
  'route': instance.route?.toJson(),
  'trip_id': instance.tripId,
  'headsign': instance.headsign,
  'service_date': instance.serviceDate?.toIso8601String(),
  'intermediate_stops': instance.intermediateStops.map((e) => e.toJson()).toList(),
  'transfer_source': instance.transferSource,
};

_Journey _$JourneyFromJson(Map<String, dynamic> json) => _Journey(
  id: json['id'] as String,
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  durationS: (json['duration_s'] as num).toInt(),
  transfers: (json['transfers'] as num).toInt(),
  walkDistanceM: (json['walk_distance_m'] as num).toInt(),
  modes: (json['modes'] as List<dynamic>).map((e) => e as String).toList(),
  legs: (json['legs'] as List<dynamic>)
      .map((e) => JourneyLeg.fromJson(e as Map<String, dynamic>))
      .toList(),
  basis: json['basis'] as String,
);

Map<String, dynamic> _$JourneyToJson(_Journey instance) => <String, dynamic>{
  'id': instance.id,
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
  'duration_s': instance.durationS,
  'transfers': instance.transfers,
  'walk_distance_m': instance.walkDistanceM,
  'modes': instance.modes,
  'legs': instance.legs.map((e) => e.toJson()).toList(),
  'basis': instance.basis,
};

_RoutingProblem _$RoutingProblemFromJson(Map<String, dynamic> json) =>
    _RoutingProblem(code: json['code'] as String, message: json['message'] as String);

Map<String, dynamic> _$RoutingProblemToJson(_RoutingProblem instance) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
};

_JourneysResponse _$JourneysResponseFromJson(Map<String, dynamic> json) => _JourneysResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => Journey.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
  routingErrors:
      (json['routing_errors'] as List<dynamic>?)
          ?.map((e) => RoutingProblem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RoutingProblem>[],
);

Map<String, dynamic> _$JourneysResponseToJson(_JourneysResponse instance) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
  'routing_errors': instance.routingErrors.map((e) => e.toJson()).toList(),
};
