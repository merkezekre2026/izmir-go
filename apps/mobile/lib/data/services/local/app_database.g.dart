// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CatalogStopsTable extends CatalogStops with TableInfo<$CatalogStopsTable, CatalogStopRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogStopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchKeyMeta = const VerificationMeta('searchKey');
  @override
  late final GeneratedColumn<String> searchKey = GeneratedColumn<String>(
    'search_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modesMeta = const VerificationMeta('modes');
  @override
  late final GeneratedColumn<String> modes = GeneratedColumn<String>(
    'modes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasScheduleMeta = const VerificationMeta('hasSchedule');
  @override
  late final GeneratedColumn<bool> hasSchedule = GeneratedColumn<bool>(
    'has_schedule',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("has_schedule" IN (0, 1))'),
  );
  static const VerificationMeta _parentStationMeta = const VerificationMeta('parentStation');
  @override
  late final GeneratedColumn<String> parentStation = GeneratedColumn<String>(
    'parent_station',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linesMeta = const VerificationMeta('lines');
  @override
  late final GeneratedColumn<String> lines = GeneratedColumn<String>(
    'lines',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    searchKey,
    lat,
    lon,
    modes,
    kind,
    hasSchedule,
    parentStation,
    lines,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_stops';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogStopRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('search_key')) {
      context.handle(
        _searchKeyMeta,
        searchKey.isAcceptableOrUnknown(data['search_key']!, _searchKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_searchKeyMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(_latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(_lonMeta, lon.isAcceptableOrUnknown(data['lon']!, _lonMeta));
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('modes')) {
      context.handle(_modesMeta, modes.isAcceptableOrUnknown(data['modes']!, _modesMeta));
    } else if (isInserting) {
      context.missing(_modesMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(_kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('has_schedule')) {
      context.handle(
        _hasScheduleMeta,
        hasSchedule.isAcceptableOrUnknown(data['has_schedule']!, _hasScheduleMeta),
      );
    } else if (isInserting) {
      context.missing(_hasScheduleMeta);
    }
    if (data.containsKey('parent_station')) {
      context.handle(
        _parentStationMeta,
        parentStation.isAcceptableOrUnknown(data['parent_station']!, _parentStationMeta),
      );
    }
    if (data.containsKey('lines')) {
      context.handle(_linesMeta, lines.isAcceptableOrUnknown(data['lines']!, _linesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogStopRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogStopRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      searchKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_key'],
      )!,
      lat: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}lat'])!,
      lon: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}lon'])!,
      modes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modes'],
      )!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      hasSchedule: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_schedule'],
      )!,
      parentStation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_station'],
      ),
      lines: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lines'],
      )!,
    );
  }

  @override
  $CatalogStopsTable createAlias(String alias) {
    return $CatalogStopsTable(attachedDatabase, alias);
  }
}

class CatalogStopRow extends DataClass implements Insertable<CatalogStopRow> {
  final String id;
  final String name;
  final String searchKey;
  final double lat;
  final double lon;
  final String modes;
  final String kind;
  final bool hasSchedule;
  final String? parentStation;
  final String lines;
  const CatalogStopRow({
    required this.id,
    required this.name,
    required this.searchKey,
    required this.lat,
    required this.lon,
    required this.modes,
    required this.kind,
    required this.hasSchedule,
    this.parentStation,
    required this.lines,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['search_key'] = Variable<String>(searchKey);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    map['modes'] = Variable<String>(modes);
    map['kind'] = Variable<String>(kind);
    map['has_schedule'] = Variable<bool>(hasSchedule);
    if (!nullToAbsent || parentStation != null) {
      map['parent_station'] = Variable<String>(parentStation);
    }
    map['lines'] = Variable<String>(lines);
    return map;
  }

  CatalogStopsCompanion toCompanion(bool nullToAbsent) {
    return CatalogStopsCompanion(
      id: Value(id),
      name: Value(name),
      searchKey: Value(searchKey),
      lat: Value(lat),
      lon: Value(lon),
      modes: Value(modes),
      kind: Value(kind),
      hasSchedule: Value(hasSchedule),
      parentStation: parentStation == null && nullToAbsent
          ? const Value.absent()
          : Value(parentStation),
      lines: Value(lines),
    );
  }

  factory CatalogStopRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogStopRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      searchKey: serializer.fromJson<String>(json['searchKey']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      modes: serializer.fromJson<String>(json['modes']),
      kind: serializer.fromJson<String>(json['kind']),
      hasSchedule: serializer.fromJson<bool>(json['hasSchedule']),
      parentStation: serializer.fromJson<String?>(json['parentStation']),
      lines: serializer.fromJson<String>(json['lines']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'searchKey': serializer.toJson<String>(searchKey),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'modes': serializer.toJson<String>(modes),
      'kind': serializer.toJson<String>(kind),
      'hasSchedule': serializer.toJson<bool>(hasSchedule),
      'parentStation': serializer.toJson<String?>(parentStation),
      'lines': serializer.toJson<String>(lines),
    };
  }

  CatalogStopRow copyWith({
    String? id,
    String? name,
    String? searchKey,
    double? lat,
    double? lon,
    String? modes,
    String? kind,
    bool? hasSchedule,
    Value<String?> parentStation = const Value.absent(),
    String? lines,
  }) => CatalogStopRow(
    id: id ?? this.id,
    name: name ?? this.name,
    searchKey: searchKey ?? this.searchKey,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    modes: modes ?? this.modes,
    kind: kind ?? this.kind,
    hasSchedule: hasSchedule ?? this.hasSchedule,
    parentStation: parentStation.present ? parentStation.value : this.parentStation,
    lines: lines ?? this.lines,
  );
  CatalogStopRow copyWithCompanion(CatalogStopsCompanion data) {
    return CatalogStopRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      searchKey: data.searchKey.present ? data.searchKey.value : this.searchKey,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      modes: data.modes.present ? data.modes.value : this.modes,
      kind: data.kind.present ? data.kind.value : this.kind,
      hasSchedule: data.hasSchedule.present ? data.hasSchedule.value : this.hasSchedule,
      parentStation: data.parentStation.present ? data.parentStation.value : this.parentStation,
      lines: data.lines.present ? data.lines.value : this.lines,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogStopRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('searchKey: $searchKey, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('modes: $modes, ')
          ..write('kind: $kind, ')
          ..write('hasSchedule: $hasSchedule, ')
          ..write('parentStation: $parentStation, ')
          ..write('lines: $lines')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, searchKey, lat, lon, modes, kind, hasSchedule, parentStation, lines);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogStopRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.searchKey == this.searchKey &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.modes == this.modes &&
          other.kind == this.kind &&
          other.hasSchedule == this.hasSchedule &&
          other.parentStation == this.parentStation &&
          other.lines == this.lines);
}

class CatalogStopsCompanion extends UpdateCompanion<CatalogStopRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> searchKey;
  final Value<double> lat;
  final Value<double> lon;
  final Value<String> modes;
  final Value<String> kind;
  final Value<bool> hasSchedule;
  final Value<String?> parentStation;
  final Value<String> lines;
  final Value<int> rowid;
  const CatalogStopsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.searchKey = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.modes = const Value.absent(),
    this.kind = const Value.absent(),
    this.hasSchedule = const Value.absent(),
    this.parentStation = const Value.absent(),
    this.lines = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogStopsCompanion.insert({
    required String id,
    required String name,
    required String searchKey,
    required double lat,
    required double lon,
    required String modes,
    required String kind,
    required bool hasSchedule,
    this.parentStation = const Value.absent(),
    this.lines = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       searchKey = Value(searchKey),
       lat = Value(lat),
       lon = Value(lon),
       modes = Value(modes),
       kind = Value(kind),
       hasSchedule = Value(hasSchedule);
  static Insertable<CatalogStopRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? searchKey,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<String>? modes,
    Expression<String>? kind,
    Expression<bool>? hasSchedule,
    Expression<String>? parentStation,
    Expression<String>? lines,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (searchKey != null) 'search_key': searchKey,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (modes != null) 'modes': modes,
      if (kind != null) 'kind': kind,
      if (hasSchedule != null) 'has_schedule': hasSchedule,
      if (parentStation != null) 'parent_station': parentStation,
      if (lines != null) 'lines': lines,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogStopsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? searchKey,
    Value<double>? lat,
    Value<double>? lon,
    Value<String>? modes,
    Value<String>? kind,
    Value<bool>? hasSchedule,
    Value<String?>? parentStation,
    Value<String>? lines,
    Value<int>? rowid,
  }) {
    return CatalogStopsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      searchKey: searchKey ?? this.searchKey,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      modes: modes ?? this.modes,
      kind: kind ?? this.kind,
      hasSchedule: hasSchedule ?? this.hasSchedule,
      parentStation: parentStation ?? this.parentStation,
      lines: lines ?? this.lines,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (searchKey.present) {
      map['search_key'] = Variable<String>(searchKey.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (modes.present) {
      map['modes'] = Variable<String>(modes.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (hasSchedule.present) {
      map['has_schedule'] = Variable<bool>(hasSchedule.value);
    }
    if (parentStation.present) {
      map['parent_station'] = Variable<String>(parentStation.value);
    }
    if (lines.present) {
      map['lines'] = Variable<String>(lines.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogStopsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('searchKey: $searchKey, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('modes: $modes, ')
          ..write('kind: $kind, ')
          ..write('hasSchedule: $hasSchedule, ')
          ..write('parentStation: $parentStation, ')
          ..write('lines: $lines, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogRoutesTable extends CatalogRoutes
    with TableInfo<$CatalogRoutesTable, CatalogRouteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogRoutesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchKeyMeta = const VerificationMeta('searchKey');
  @override
  late final GeneratedColumn<String> searchKey = GeneratedColumn<String>(
    'search_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, mode, searchKey, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_routes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogRouteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(_modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('search_key')) {
      context.handle(
        _searchKeyMeta,
        searchKey.isAcceptableOrUnknown(data['search_key']!, _searchKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_searchKeyMeta);
    }
    if (data.containsKey('json')) {
      context.handle(_jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogRouteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogRouteRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      mode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      searchKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_key'],
      )!,
      json: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}json'])!,
    );
  }

  @override
  $CatalogRoutesTable createAlias(String alias) {
    return $CatalogRoutesTable(attachedDatabase, alias);
  }
}

class CatalogRouteRow extends DataClass implements Insertable<CatalogRouteRow> {
  final String id;
  final String mode;
  final String searchKey;
  final String json;
  const CatalogRouteRow({
    required this.id,
    required this.mode,
    required this.searchKey,
    required this.json,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mode'] = Variable<String>(mode);
    map['search_key'] = Variable<String>(searchKey);
    map['json'] = Variable<String>(json);
    return map;
  }

  CatalogRoutesCompanion toCompanion(bool nullToAbsent) {
    return CatalogRoutesCompanion(
      id: Value(id),
      mode: Value(mode),
      searchKey: Value(searchKey),
      json: Value(json),
    );
  }

  factory CatalogRouteRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogRouteRow(
      id: serializer.fromJson<String>(json['id']),
      mode: serializer.fromJson<String>(json['mode']),
      searchKey: serializer.fromJson<String>(json['searchKey']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mode': serializer.toJson<String>(mode),
      'searchKey': serializer.toJson<String>(searchKey),
      'json': serializer.toJson<String>(json),
    };
  }

  CatalogRouteRow copyWith({String? id, String? mode, String? searchKey, String? json}) =>
      CatalogRouteRow(
        id: id ?? this.id,
        mode: mode ?? this.mode,
        searchKey: searchKey ?? this.searchKey,
        json: json ?? this.json,
      );
  CatalogRouteRow copyWithCompanion(CatalogRoutesCompanion data) {
    return CatalogRouteRow(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      searchKey: data.searchKey.present ? data.searchKey.value : this.searchKey,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogRouteRow(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('searchKey: $searchKey, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mode, searchKey, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogRouteRow &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.searchKey == this.searchKey &&
          other.json == this.json);
}

class CatalogRoutesCompanion extends UpdateCompanion<CatalogRouteRow> {
  final Value<String> id;
  final Value<String> mode;
  final Value<String> searchKey;
  final Value<String> json;
  final Value<int> rowid;
  const CatalogRoutesCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.searchKey = const Value.absent(),
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogRoutesCompanion.insert({
    required String id,
    required String mode,
    required String searchKey,
    required String json,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mode = Value(mode),
       searchKey = Value(searchKey),
       json = Value(json);
  static Insertable<CatalogRouteRow> custom({
    Expression<String>? id,
    Expression<String>? mode,
    Expression<String>? searchKey,
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (searchKey != null) 'search_key': searchKey,
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogRoutesCompanion copyWith({
    Value<String>? id,
    Value<String>? mode,
    Value<String>? searchKey,
    Value<String>? json,
    Value<int>? rowid,
  }) {
    return CatalogRoutesCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      searchKey: searchKey ?? this.searchKey,
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (searchKey.present) {
      map['search_key'] = Variable<String>(searchKey.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogRoutesCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('searchKey: $searchKey, ')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KeyValuesTable extends KeyValues with TableInfo<$KeyValuesTable, KeyValueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeyValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'key_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<KeyValueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  KeyValueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeyValueRow(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $KeyValuesTable createAlias(String alias) {
    return $KeyValuesTable(attachedDatabase, alias);
  }
}

class KeyValueRow extends DataClass implements Insertable<KeyValueRow> {
  final String key;
  final String value;
  const KeyValueRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  KeyValuesCompanion toCompanion(bool nullToAbsent) {
    return KeyValuesCompanion(key: Value(key), value: Value(value));
  }

  factory KeyValueRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeyValueRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  KeyValueRow copyWith({String? key, String? value}) =>
      KeyValueRow(key: key ?? this.key, value: value ?? this.value);
  KeyValueRow copyWithCompanion(KeyValuesCompanion data) {
    return KeyValueRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeyValueRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeyValueRow && other.key == this.key && other.value == this.value);
}

class KeyValuesCompanion extends UpdateCompanion<KeyValueRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const KeyValuesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeyValuesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<KeyValueRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeyValuesCompanion copyWith({Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return KeyValuesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeyValuesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoriteStopsTable extends FavoriteStops
    with TableInfo<$FavoriteStopsTable, FavoriteStopRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteStopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _stopIdMeta = const VerificationMeta('stopId');
  @override
  late final GeneratedColumn<String> stopId = GeneratedColumn<String>(
    'stop_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modesMeta = const VerificationMeta('modes');
  @override
  late final GeneratedColumn<String> modes = GeneratedColumn<String>(
    'modes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [stopId, name, modes, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_stops';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteStopRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('stop_id')) {
      context.handle(_stopIdMeta, stopId.isAcceptableOrUnknown(data['stop_id']!, _stopIdMeta));
    } else if (isInserting) {
      context.missing(_stopIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('modes')) {
      context.handle(_modesMeta, modes.isAcceptableOrUnknown(data['modes']!, _modesMeta));
    } else if (isInserting) {
      context.missing(_modesMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta, addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {stopId};
  @override
  FavoriteStopRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteStopRow(
      stopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stop_id'],
      )!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      modes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modes'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $FavoriteStopsTable createAlias(String alias) {
    return $FavoriteStopsTable(attachedDatabase, alias);
  }
}

class FavoriteStopRow extends DataClass implements Insertable<FavoriteStopRow> {
  final String stopId;
  final String name;
  final String modes;
  final DateTime addedAt;
  const FavoriteStopRow({
    required this.stopId,
    required this.name,
    required this.modes,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['stop_id'] = Variable<String>(stopId);
    map['name'] = Variable<String>(name);
    map['modes'] = Variable<String>(modes);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  FavoriteStopsCompanion toCompanion(bool nullToAbsent) {
    return FavoriteStopsCompanion(
      stopId: Value(stopId),
      name: Value(name),
      modes: Value(modes),
      addedAt: Value(addedAt),
    );
  }

  factory FavoriteStopRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteStopRow(
      stopId: serializer.fromJson<String>(json['stopId']),
      name: serializer.fromJson<String>(json['name']),
      modes: serializer.fromJson<String>(json['modes']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'stopId': serializer.toJson<String>(stopId),
      'name': serializer.toJson<String>(name),
      'modes': serializer.toJson<String>(modes),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  FavoriteStopRow copyWith({String? stopId, String? name, String? modes, DateTime? addedAt}) =>
      FavoriteStopRow(
        stopId: stopId ?? this.stopId,
        name: name ?? this.name,
        modes: modes ?? this.modes,
        addedAt: addedAt ?? this.addedAt,
      );
  FavoriteStopRow copyWithCompanion(FavoriteStopsCompanion data) {
    return FavoriteStopRow(
      stopId: data.stopId.present ? data.stopId.value : this.stopId,
      name: data.name.present ? data.name.value : this.name,
      modes: data.modes.present ? data.modes.value : this.modes,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteStopRow(')
          ..write('stopId: $stopId, ')
          ..write('name: $name, ')
          ..write('modes: $modes, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(stopId, name, modes, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteStopRow &&
          other.stopId == this.stopId &&
          other.name == this.name &&
          other.modes == this.modes &&
          other.addedAt == this.addedAt);
}

class FavoriteStopsCompanion extends UpdateCompanion<FavoriteStopRow> {
  final Value<String> stopId;
  final Value<String> name;
  final Value<String> modes;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const FavoriteStopsCompanion({
    this.stopId = const Value.absent(),
    this.name = const Value.absent(),
    this.modes = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteStopsCompanion.insert({
    required String stopId,
    required String name,
    required String modes,
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : stopId = Value(stopId),
       name = Value(name),
       modes = Value(modes),
       addedAt = Value(addedAt);
  static Insertable<FavoriteStopRow> custom({
    Expression<String>? stopId,
    Expression<String>? name,
    Expression<String>? modes,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (stopId != null) 'stop_id': stopId,
      if (name != null) 'name': name,
      if (modes != null) 'modes': modes,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteStopsCompanion copyWith({
    Value<String>? stopId,
    Value<String>? name,
    Value<String>? modes,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return FavoriteStopsCompanion(
      stopId: stopId ?? this.stopId,
      name: name ?? this.name,
      modes: modes ?? this.modes,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (stopId.present) {
      map['stop_id'] = Variable<String>(stopId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (modes.present) {
      map['modes'] = Variable<String>(modes.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteStopsCompanion(')
          ..write('stopId: $stopId, ')
          ..write('name: $name, ')
          ..write('modes: $modes, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoriteLinesTable extends FavoriteLines
    with TableInfo<$FavoriteLinesTable, FavoriteLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _routeIdMeta = const VerificationMeta('routeId');
  @override
  late final GeneratedColumn<String> routeId = GeneratedColumn<String>(
    'route_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [routeId, json, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('route_id')) {
      context.handle(_routeIdMeta, routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta));
    } else if (isInserting) {
      context.missing(_routeIdMeta);
    }
    if (data.containsKey('json')) {
      context.handle(_jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta, addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {routeId};
  @override
  FavoriteLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteLineRow(
      routeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_id'],
      )!,
      json: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}json'])!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $FavoriteLinesTable createAlias(String alias) {
    return $FavoriteLinesTable(attachedDatabase, alias);
  }
}

class FavoriteLineRow extends DataClass implements Insertable<FavoriteLineRow> {
  final String routeId;
  final String json;
  final DateTime addedAt;
  const FavoriteLineRow({required this.routeId, required this.json, required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['route_id'] = Variable<String>(routeId);
    map['json'] = Variable<String>(json);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  FavoriteLinesCompanion toCompanion(bool nullToAbsent) {
    return FavoriteLinesCompanion(
      routeId: Value(routeId),
      json: Value(json),
      addedAt: Value(addedAt),
    );
  }

  factory FavoriteLineRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteLineRow(
      routeId: serializer.fromJson<String>(json['routeId']),
      json: serializer.fromJson<String>(json['json']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'routeId': serializer.toJson<String>(routeId),
      'json': serializer.toJson<String>(json),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  FavoriteLineRow copyWith({String? routeId, String? json, DateTime? addedAt}) => FavoriteLineRow(
    routeId: routeId ?? this.routeId,
    json: json ?? this.json,
    addedAt: addedAt ?? this.addedAt,
  );
  FavoriteLineRow copyWithCompanion(FavoriteLinesCompanion data) {
    return FavoriteLineRow(
      routeId: data.routeId.present ? data.routeId.value : this.routeId,
      json: data.json.present ? data.json.value : this.json,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteLineRow(')
          ..write('routeId: $routeId, ')
          ..write('json: $json, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(routeId, json, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteLineRow &&
          other.routeId == this.routeId &&
          other.json == this.json &&
          other.addedAt == this.addedAt);
}

class FavoriteLinesCompanion extends UpdateCompanion<FavoriteLineRow> {
  final Value<String> routeId;
  final Value<String> json;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const FavoriteLinesCompanion({
    this.routeId = const Value.absent(),
    this.json = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteLinesCompanion.insert({
    required String routeId,
    required String json,
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : routeId = Value(routeId),
       json = Value(json),
       addedAt = Value(addedAt);
  static Insertable<FavoriteLineRow> custom({
    Expression<String>? routeId,
    Expression<String>? json,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (routeId != null) 'route_id': routeId,
      if (json != null) 'json': json,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteLinesCompanion copyWith({
    Value<String>? routeId,
    Value<String>? json,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return FavoriteLinesCompanion(
      routeId: routeId ?? this.routeId,
      json: json ?? this.json,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (routeId.present) {
      map['route_id'] = Variable<String>(routeId.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteLinesCompanion(')
          ..write('routeId: $routeId, ')
          ..write('json: $json, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecentPlacesTable extends RecentPlaces with TableInfo<$RecentPlacesTable, RecentPlaceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentPlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _placeIdMeta = const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usedAtMeta = const VerificationMeta('usedAt');
  @override
  late final GeneratedColumn<DateTime> usedAt = GeneratedColumn<DateTime>(
    'used_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [placeId, json, usedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_places';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentPlaceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta, placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('json')) {
      context.handle(_jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('used_at')) {
      context.handle(_usedAtMeta, usedAt.isAcceptableOrUnknown(data['used_at']!, _usedAtMeta));
    } else if (isInserting) {
      context.missing(_usedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId};
  @override
  RecentPlaceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentPlaceRow(
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      )!,
      json: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}json'])!,
      usedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}used_at'],
      )!,
    );
  }

  @override
  $RecentPlacesTable createAlias(String alias) {
    return $RecentPlacesTable(attachedDatabase, alias);
  }
}

class RecentPlaceRow extends DataClass implements Insertable<RecentPlaceRow> {
  final String placeId;
  final String json;
  final DateTime usedAt;
  const RecentPlaceRow({required this.placeId, required this.json, required this.usedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<String>(placeId);
    map['json'] = Variable<String>(json);
    map['used_at'] = Variable<DateTime>(usedAt);
    return map;
  }

  RecentPlacesCompanion toCompanion(bool nullToAbsent) {
    return RecentPlacesCompanion(placeId: Value(placeId), json: Value(json), usedAt: Value(usedAt));
  }

  factory RecentPlaceRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentPlaceRow(
      placeId: serializer.fromJson<String>(json['placeId']),
      json: serializer.fromJson<String>(json['json']),
      usedAt: serializer.fromJson<DateTime>(json['usedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<String>(placeId),
      'json': serializer.toJson<String>(json),
      'usedAt': serializer.toJson<DateTime>(usedAt),
    };
  }

  RecentPlaceRow copyWith({String? placeId, String? json, DateTime? usedAt}) => RecentPlaceRow(
    placeId: placeId ?? this.placeId,
    json: json ?? this.json,
    usedAt: usedAt ?? this.usedAt,
  );
  RecentPlaceRow copyWithCompanion(RecentPlacesCompanion data) {
    return RecentPlaceRow(
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      json: data.json.present ? data.json.value : this.json,
      usedAt: data.usedAt.present ? data.usedAt.value : this.usedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentPlaceRow(')
          ..write('placeId: $placeId, ')
          ..write('json: $json, ')
          ..write('usedAt: $usedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(placeId, json, usedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentPlaceRow &&
          other.placeId == this.placeId &&
          other.json == this.json &&
          other.usedAt == this.usedAt);
}

class RecentPlacesCompanion extends UpdateCompanion<RecentPlaceRow> {
  final Value<String> placeId;
  final Value<String> json;
  final Value<DateTime> usedAt;
  final Value<int> rowid;
  const RecentPlacesCompanion({
    this.placeId = const Value.absent(),
    this.json = const Value.absent(),
    this.usedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentPlacesCompanion.insert({
    required String placeId,
    required String json,
    required DateTime usedAt,
    this.rowid = const Value.absent(),
  }) : placeId = Value(placeId),
       json = Value(json),
       usedAt = Value(usedAt);
  static Insertable<RecentPlaceRow> custom({
    Expression<String>? placeId,
    Expression<String>? json,
    Expression<DateTime>? usedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (json != null) 'json': json,
      if (usedAt != null) 'used_at': usedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentPlacesCompanion copyWith({
    Value<String>? placeId,
    Value<String>? json,
    Value<DateTime>? usedAt,
    Value<int>? rowid,
  }) {
    return RecentPlacesCompanion(
      placeId: placeId ?? this.placeId,
      json: json ?? this.json,
      usedAt: usedAt ?? this.usedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (usedAt.present) {
      map['used_at'] = Variable<DateTime>(usedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentPlacesCompanion(')
          ..write('placeId: $placeId, ')
          ..write('json: $json, ')
          ..write('usedAt: $usedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedResponsesTable extends CachedResponses
    with TableInfo<$CachedResponsesTable, CachedResponseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedResponsesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, json, fetchedAt, expiresAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_responses';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedResponseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('json')) {
      context.handle(_jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CachedResponseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedResponseRow(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      json: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}json'])!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $CachedResponsesTable createAlias(String alias) {
    return $CachedResponsesTable(attachedDatabase, alias);
  }
}

class CachedResponseRow extends DataClass implements Insertable<CachedResponseRow> {
  final String key;
  final String json;
  final DateTime fetchedAt;
  final DateTime? expiresAt;
  const CachedResponseRow({
    required this.key,
    required this.json,
    required this.fetchedAt,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['json'] = Variable<String>(json);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  CachedResponsesCompanion toCompanion(bool nullToAbsent) {
    return CachedResponsesCompanion(
      key: Value(key),
      json: Value(json),
      fetchedAt: Value(fetchedAt),
      expiresAt: expiresAt == null && nullToAbsent ? const Value.absent() : Value(expiresAt),
    );
  }

  factory CachedResponseRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedResponseRow(
      key: serializer.fromJson<String>(json['key']),
      json: serializer.fromJson<String>(json['json']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'json': serializer.toJson<String>(json),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  CachedResponseRow copyWith({
    String? key,
    String? json,
    DateTime? fetchedAt,
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => CachedResponseRow(
    key: key ?? this.key,
    json: json ?? this.json,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  CachedResponseRow copyWithCompanion(CachedResponsesCompanion data) {
    return CachedResponseRow(
      key: data.key.present ? data.key.value : this.key,
      json: data.json.present ? data.json.value : this.json,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedResponseRow(')
          ..write('key: $key, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, json, fetchedAt, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedResponseRow &&
          other.key == this.key &&
          other.json == this.json &&
          other.fetchedAt == this.fetchedAt &&
          other.expiresAt == this.expiresAt);
}

class CachedResponsesCompanion extends UpdateCompanion<CachedResponseRow> {
  final Value<String> key;
  final Value<String> json;
  final Value<DateTime> fetchedAt;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const CachedResponsesCompanion({
    this.key = const Value.absent(),
    this.json = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedResponsesCompanion.insert({
    required String key,
    required String json,
    required DateTime fetchedAt,
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       json = Value(json),
       fetchedAt = Value(fetchedAt);
  static Insertable<CachedResponseRow> custom({
    Expression<String>? key,
    Expression<String>? json,
    Expression<DateTime>? fetchedAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (json != null) 'json': json,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedResponsesCompanion copyWith({
    Value<String>? key,
    Value<String>? json,
    Value<DateTime>? fetchedAt,
    Value<DateTime?>? expiresAt,
    Value<int>? rowid,
  }) {
    return CachedResponsesCompanion(
      key: key ?? this.key,
      json: json ?? this.json,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedResponsesCompanion(')
          ..write('key: $key, ')
          ..write('json: $json, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatalogStopsTable catalogStops = $CatalogStopsTable(this);
  late final $CatalogRoutesTable catalogRoutes = $CatalogRoutesTable(this);
  late final $KeyValuesTable keyValues = $KeyValuesTable(this);
  late final $FavoriteStopsTable favoriteStops = $FavoriteStopsTable(this);
  late final $FavoriteLinesTable favoriteLines = $FavoriteLinesTable(this);
  late final $RecentPlacesTable recentPlaces = $RecentPlacesTable(this);
  late final $CachedResponsesTable cachedResponses = $CachedResponsesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catalogStops,
    catalogRoutes,
    keyValues,
    favoriteStops,
    favoriteLines,
    recentPlaces,
    cachedResponses,
  ];
}

typedef $$CatalogStopsTableCreateCompanionBuilder = CatalogStopsCompanion Function({
  required String id,
  required String name,
  required String searchKey,
  required double lat,
  required double lon,
  required String modes,
  required String kind,
  required bool hasSchedule,
  Value<String?> parentStation,
  Value<String> lines,
  Value<int> rowid,
});
typedef $$CatalogStopsTableUpdateCompanionBuilder = CatalogStopsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> searchKey,
  Value<double> lat,
  Value<double> lon,
  Value<String> modes,
  Value<String> kind,
  Value<bool> hasSchedule,
  Value<String?> parentStation,
  Value<String> lines,
  Value<int> rowid,
});

class $$CatalogStopsTableFilterComposer extends Composer<_$AppDatabase, $CatalogStopsTable> {
  $$CatalogStopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modes =>
      $composableBuilder(column: $table.modes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasSchedule =>
      $composableBuilder(column: $table.hasSchedule, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentStation =>
      $composableBuilder(column: $table.parentStation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lines =>
      $composableBuilder(column: $table.lines, builder: (column) => ColumnFilters(column));
}

class $$CatalogStopsTableOrderingComposer extends Composer<_$AppDatabase, $CatalogStopsTable> {
  $$CatalogStopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modes =>
      $composableBuilder(column: $table.modes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasSchedule =>
      $composableBuilder(column: $table.hasSchedule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentStation => $composableBuilder(
    column: $table.parentStation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lines =>
      $composableBuilder(column: $table.lines, builder: (column) => ColumnOrderings(column));
}

class $$CatalogStopsTableAnnotationComposer extends Composer<_$AppDatabase, $CatalogStopsTable> {
  $$CatalogStopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<String> get modes =>
      $composableBuilder(column: $table.modes, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<bool> get hasSchedule =>
      $composableBuilder(column: $table.hasSchedule, builder: (column) => column);

  GeneratedColumn<String> get parentStation =>
      $composableBuilder(column: $table.parentStation, builder: (column) => column);

  GeneratedColumn<String> get lines =>
      $composableBuilder(column: $table.lines, builder: (column) => column);
}

class $$CatalogStopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogStopsTable,
          CatalogStopRow,
          $$CatalogStopsTableFilterComposer,
          $$CatalogStopsTableOrderingComposer,
          $$CatalogStopsTableAnnotationComposer,
          $$CatalogStopsTableCreateCompanionBuilder,
          $$CatalogStopsTableUpdateCompanionBuilder,
          (CatalogStopRow, BaseReferences<_$AppDatabase, $CatalogStopsTable, CatalogStopRow>),
          CatalogStopRow,
          PrefetchHooks Function()
        > {
  $$CatalogStopsTableTableManager(_$AppDatabase db, $CatalogStopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$CatalogStopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$CatalogStopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogStopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> searchKey = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<String> modes = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<bool> hasSchedule = const Value.absent(),
                Value<String?> parentStation = const Value.absent(),
                Value<String> lines = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogStopsCompanion(
                id: id,
                name: name,
                searchKey: searchKey,
                lat: lat,
                lon: lon,
                modes: modes,
                kind: kind,
                hasSchedule: hasSchedule,
                parentStation: parentStation,
                lines: lines,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String searchKey,
                required double lat,
                required double lon,
                required String modes,
                required String kind,
                required bool hasSchedule,
                Value<String?> parentStation = const Value.absent(),
                Value<String> lines = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogStopsCompanion.insert(
                id: id,
                name: name,
                searchKey: searchKey,
                lat: lat,
                lon: lon,
                modes: modes,
                kind: kind,
                hasSchedule: hasSchedule,
                parentStation: parentStation,
                lines: lines,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CatalogStopsTable, CatalogStopRow>(table),
                  BaseReferences<_$AppDatabase, $CatalogStopsTable, CatalogStopRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogStopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogStopsTable,
      CatalogStopRow,
      $$CatalogStopsTableFilterComposer,
      $$CatalogStopsTableOrderingComposer,
      $$CatalogStopsTableAnnotationComposer,
      $$CatalogStopsTableCreateCompanionBuilder,
      $$CatalogStopsTableUpdateCompanionBuilder,
      (CatalogStopRow, BaseReferences<_$AppDatabase, $CatalogStopsTable, CatalogStopRow>),
      CatalogStopRow,
      PrefetchHooks Function()
    >;
typedef $$CatalogRoutesTableCreateCompanionBuilder = CatalogRoutesCompanion Function({
  required String id,
  required String mode,
  required String searchKey,
  required String json,
  Value<int> rowid,
});
typedef $$CatalogRoutesTableUpdateCompanionBuilder = CatalogRoutesCompanion Function({
  Value<String> id,
  Value<String> mode,
  Value<String> searchKey,
  Value<String> json,
  Value<int> rowid,
});

class $$CatalogRoutesTableFilterComposer extends Composer<_$AppDatabase, $CatalogRoutesTable> {
  $$CatalogRoutesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => ColumnFilters(column));
}

class $$CatalogRoutesTableOrderingComposer extends Composer<_$AppDatabase, $CatalogRoutesTable> {
  $$CatalogRoutesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => ColumnOrderings(column));
}

class $$CatalogRoutesTableAnnotationComposer extends Composer<_$AppDatabase, $CatalogRoutesTable> {
  $$CatalogRoutesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get searchKey =>
      $composableBuilder(column: $table.searchKey, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$CatalogRoutesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogRoutesTable,
          CatalogRouteRow,
          $$CatalogRoutesTableFilterComposer,
          $$CatalogRoutesTableOrderingComposer,
          $$CatalogRoutesTableAnnotationComposer,
          $$CatalogRoutesTableCreateCompanionBuilder,
          $$CatalogRoutesTableUpdateCompanionBuilder,
          (CatalogRouteRow, BaseReferences<_$AppDatabase, $CatalogRoutesTable, CatalogRouteRow>),
          CatalogRouteRow,
          PrefetchHooks Function()
        > {
  $$CatalogRoutesTableTableManager(_$AppDatabase db, $CatalogRoutesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$CatalogRoutesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogRoutesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogRoutesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> searchKey = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogRoutesCompanion(
                id: id,
                mode: mode,
                searchKey: searchKey,
                json: json,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mode,
                required String searchKey,
                required String json,
                Value<int> rowid = const Value.absent(),
              }) => CatalogRoutesCompanion.insert(
                id: id,
                mode: mode,
                searchKey: searchKey,
                json: json,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CatalogRoutesTable, CatalogRouteRow>(table),
                  BaseReferences<_$AppDatabase, $CatalogRoutesTable, CatalogRouteRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogRoutesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogRoutesTable,
      CatalogRouteRow,
      $$CatalogRoutesTableFilterComposer,
      $$CatalogRoutesTableOrderingComposer,
      $$CatalogRoutesTableAnnotationComposer,
      $$CatalogRoutesTableCreateCompanionBuilder,
      $$CatalogRoutesTableUpdateCompanionBuilder,
      (CatalogRouteRow, BaseReferences<_$AppDatabase, $CatalogRoutesTable, CatalogRouteRow>),
      CatalogRouteRow,
      PrefetchHooks Function()
    >;
typedef $$KeyValuesTableCreateCompanionBuilder = KeyValuesCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$KeyValuesTableUpdateCompanionBuilder = KeyValuesCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$KeyValuesTableFilterComposer extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$KeyValuesTableOrderingComposer extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$KeyValuesTableAnnotationComposer extends Composer<_$AppDatabase, $KeyValuesTable> {
  $$KeyValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$KeyValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeyValuesTable,
          KeyValueRow,
          $$KeyValuesTableFilterComposer,
          $$KeyValuesTableOrderingComposer,
          $$KeyValuesTableAnnotationComposer,
          $$KeyValuesTableCreateCompanionBuilder,
          $$KeyValuesTableUpdateCompanionBuilder,
          (KeyValueRow, BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValueRow>),
          KeyValueRow,
          PrefetchHooks Function()
        > {
  $$KeyValuesTableTableManager(_$AppDatabase db, $KeyValuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$KeyValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$KeyValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeyValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => KeyValuesCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => KeyValuesCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KeyValuesTable, KeyValueRow>(table),
                  BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValueRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KeyValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeyValuesTable,
      KeyValueRow,
      $$KeyValuesTableFilterComposer,
      $$KeyValuesTableOrderingComposer,
      $$KeyValuesTableAnnotationComposer,
      $$KeyValuesTableCreateCompanionBuilder,
      $$KeyValuesTableUpdateCompanionBuilder,
      (KeyValueRow, BaseReferences<_$AppDatabase, $KeyValuesTable, KeyValueRow>),
      KeyValueRow,
      PrefetchHooks Function()
    >;
typedef $$FavoriteStopsTableCreateCompanionBuilder = FavoriteStopsCompanion Function({
  required String stopId,
  required String name,
  required String modes,
  required DateTime addedAt,
  Value<int> rowid,
});
typedef $$FavoriteStopsTableUpdateCompanionBuilder = FavoriteStopsCompanion Function({
  Value<String> stopId,
  Value<String> name,
  Value<String> modes,
  Value<DateTime> addedAt,
  Value<int> rowid,
});

class $$FavoriteStopsTableFilterComposer extends Composer<_$AppDatabase, $FavoriteStopsTable> {
  $$FavoriteStopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get stopId =>
      $composableBuilder(column: $table.stopId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modes =>
      $composableBuilder(column: $table.modes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => ColumnFilters(column));
}

class $$FavoriteStopsTableOrderingComposer extends Composer<_$AppDatabase, $FavoriteStopsTable> {
  $$FavoriteStopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get stopId =>
      $composableBuilder(column: $table.stopId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modes =>
      $composableBuilder(column: $table.modes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => ColumnOrderings(column));
}

class $$FavoriteStopsTableAnnotationComposer extends Composer<_$AppDatabase, $FavoriteStopsTable> {
  $$FavoriteStopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get stopId =>
      $composableBuilder(column: $table.stopId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get modes =>
      $composableBuilder(column: $table.modes, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$FavoriteStopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoriteStopsTable,
          FavoriteStopRow,
          $$FavoriteStopsTableFilterComposer,
          $$FavoriteStopsTableOrderingComposer,
          $$FavoriteStopsTableAnnotationComposer,
          $$FavoriteStopsTableCreateCompanionBuilder,
          $$FavoriteStopsTableUpdateCompanionBuilder,
          (FavoriteStopRow, BaseReferences<_$AppDatabase, $FavoriteStopsTable, FavoriteStopRow>),
          FavoriteStopRow,
          PrefetchHooks Function()
        > {
  $$FavoriteStopsTableTableManager(_$AppDatabase db, $FavoriteStopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$FavoriteStopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteStopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteStopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> stopId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> modes = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriteStopsCompanion(
                stopId: stopId,
                name: name,
                modes: modes,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String stopId,
                required String name,
                required String modes,
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => FavoriteStopsCompanion.insert(
                stopId: stopId,
                name: name,
                modes: modes,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FavoriteStopsTable, FavoriteStopRow>(table),
                  BaseReferences<_$AppDatabase, $FavoriteStopsTable, FavoriteStopRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoriteStopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoriteStopsTable,
      FavoriteStopRow,
      $$FavoriteStopsTableFilterComposer,
      $$FavoriteStopsTableOrderingComposer,
      $$FavoriteStopsTableAnnotationComposer,
      $$FavoriteStopsTableCreateCompanionBuilder,
      $$FavoriteStopsTableUpdateCompanionBuilder,
      (FavoriteStopRow, BaseReferences<_$AppDatabase, $FavoriteStopsTable, FavoriteStopRow>),
      FavoriteStopRow,
      PrefetchHooks Function()
    >;
typedef $$FavoriteLinesTableCreateCompanionBuilder = FavoriteLinesCompanion Function({
  required String routeId,
  required String json,
  required DateTime addedAt,
  Value<int> rowid,
});
typedef $$FavoriteLinesTableUpdateCompanionBuilder = FavoriteLinesCompanion Function({
  Value<String> routeId,
  Value<String> json,
  Value<DateTime> addedAt,
  Value<int> rowid,
});

class $$FavoriteLinesTableFilterComposer extends Composer<_$AppDatabase, $FavoriteLinesTable> {
  $$FavoriteLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get routeId =>
      $composableBuilder(column: $table.routeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => ColumnFilters(column));
}

class $$FavoriteLinesTableOrderingComposer extends Composer<_$AppDatabase, $FavoriteLinesTable> {
  $$FavoriteLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get routeId =>
      $composableBuilder(column: $table.routeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => ColumnOrderings(column));
}

class $$FavoriteLinesTableAnnotationComposer extends Composer<_$AppDatabase, $FavoriteLinesTable> {
  $$FavoriteLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get routeId =>
      $composableBuilder(column: $table.routeId, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$FavoriteLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoriteLinesTable,
          FavoriteLineRow,
          $$FavoriteLinesTableFilterComposer,
          $$FavoriteLinesTableOrderingComposer,
          $$FavoriteLinesTableAnnotationComposer,
          $$FavoriteLinesTableCreateCompanionBuilder,
          $$FavoriteLinesTableUpdateCompanionBuilder,
          (FavoriteLineRow, BaseReferences<_$AppDatabase, $FavoriteLinesTable, FavoriteLineRow>),
          FavoriteLineRow,
          PrefetchHooks Function()
        > {
  $$FavoriteLinesTableTableManager(_$AppDatabase db, $FavoriteLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$FavoriteLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> routeId = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriteLinesCompanion(
                routeId: routeId,
                json: json,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String routeId,
                required String json,
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => FavoriteLinesCompanion.insert(
                routeId: routeId,
                json: json,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FavoriteLinesTable, FavoriteLineRow>(table),
                  BaseReferences<_$AppDatabase, $FavoriteLinesTable, FavoriteLineRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoriteLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoriteLinesTable,
      FavoriteLineRow,
      $$FavoriteLinesTableFilterComposer,
      $$FavoriteLinesTableOrderingComposer,
      $$FavoriteLinesTableAnnotationComposer,
      $$FavoriteLinesTableCreateCompanionBuilder,
      $$FavoriteLinesTableUpdateCompanionBuilder,
      (FavoriteLineRow, BaseReferences<_$AppDatabase, $FavoriteLinesTable, FavoriteLineRow>),
      FavoriteLineRow,
      PrefetchHooks Function()
    >;
typedef $$RecentPlacesTableCreateCompanionBuilder = RecentPlacesCompanion Function({
  required String placeId,
  required String json,
  required DateTime usedAt,
  Value<int> rowid,
});
typedef $$RecentPlacesTableUpdateCompanionBuilder = RecentPlacesCompanion Function({
  Value<String> placeId,
  Value<String> json,
  Value<DateTime> usedAt,
  Value<int> rowid,
});

class $$RecentPlacesTableFilterComposer extends Composer<_$AppDatabase, $RecentPlacesTable> {
  $$RecentPlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get usedAt =>
      $composableBuilder(column: $table.usedAt, builder: (column) => ColumnFilters(column));
}

class $$RecentPlacesTableOrderingComposer extends Composer<_$AppDatabase, $RecentPlacesTable> {
  $$RecentPlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get usedAt =>
      $composableBuilder(column: $table.usedAt, builder: (column) => ColumnOrderings(column));
}

class $$RecentPlacesTableAnnotationComposer extends Composer<_$AppDatabase, $RecentPlacesTable> {
  $$RecentPlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get usedAt =>
      $composableBuilder(column: $table.usedAt, builder: (column) => column);
}

class $$RecentPlacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentPlacesTable,
          RecentPlaceRow,
          $$RecentPlacesTableFilterComposer,
          $$RecentPlacesTableOrderingComposer,
          $$RecentPlacesTableAnnotationComposer,
          $$RecentPlacesTableCreateCompanionBuilder,
          $$RecentPlacesTableUpdateCompanionBuilder,
          (RecentPlaceRow, BaseReferences<_$AppDatabase, $RecentPlacesTable, RecentPlaceRow>),
          RecentPlaceRow,
          PrefetchHooks Function()
        > {
  $$RecentPlacesTableTableManager(_$AppDatabase db, $RecentPlacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$RecentPlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$RecentPlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentPlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> placeId = const Value.absent(),
            Value<String> json = const Value.absent(),
            Value<DateTime> usedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => RecentPlacesCompanion(placeId: placeId, json: json, usedAt: usedAt, rowid: rowid),
          createCompanionCallback:
              ({
                required String placeId,
                required String json,
                required DateTime usedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecentPlacesCompanion.insert(
                placeId: placeId,
                json: json,
                usedAt: usedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecentPlacesTable, RecentPlaceRow>(table),
                  BaseReferences<_$AppDatabase, $RecentPlacesTable, RecentPlaceRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecentPlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentPlacesTable,
      RecentPlaceRow,
      $$RecentPlacesTableFilterComposer,
      $$RecentPlacesTableOrderingComposer,
      $$RecentPlacesTableAnnotationComposer,
      $$RecentPlacesTableCreateCompanionBuilder,
      $$RecentPlacesTableUpdateCompanionBuilder,
      (RecentPlaceRow, BaseReferences<_$AppDatabase, $RecentPlacesTable, RecentPlaceRow>),
      RecentPlaceRow,
      PrefetchHooks Function()
    >;
typedef $$CachedResponsesTableCreateCompanionBuilder = CachedResponsesCompanion Function({
  required String key,
  required String json,
  required DateTime fetchedAt,
  Value<DateTime?> expiresAt,
  Value<int> rowid,
});
typedef $$CachedResponsesTableUpdateCompanionBuilder = CachedResponsesCompanion Function({
  Value<String> key,
  Value<String> json,
  Value<DateTime> fetchedAt,
  Value<DateTime?> expiresAt,
  Value<int> rowid,
});

class $$CachedResponsesTableFilterComposer extends Composer<_$AppDatabase, $CachedResponsesTable> {
  $$CachedResponsesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => ColumnFilters(column));
}

class $$CachedResponsesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedResponsesTable> {
  $$CachedResponsesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedResponsesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedResponsesTable> {
  $$CachedResponsesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$CachedResponsesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedResponsesTable,
          CachedResponseRow,
          $$CachedResponsesTableFilterComposer,
          $$CachedResponsesTableOrderingComposer,
          $$CachedResponsesTableAnnotationComposer,
          $$CachedResponsesTableCreateCompanionBuilder,
          $$CachedResponsesTableUpdateCompanionBuilder,
          (
            CachedResponseRow,
            BaseReferences<_$AppDatabase, $CachedResponsesTable, CachedResponseRow>,
          ),
          CachedResponseRow,
          PrefetchHooks Function()
        > {
  $$CachedResponsesTableTableManager(_$AppDatabase db, $CachedResponsesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedResponsesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedResponsesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedResponsesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedResponsesCompanion(
                key: key,
                json: json,
                fetchedAt: fetchedAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String json,
                required DateTime fetchedAt,
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedResponsesCompanion.insert(
                key: key,
                json: json,
                fetchedAt: fetchedAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedResponsesTable, CachedResponseRow>(table),
                  BaseReferences<_$AppDatabase, $CachedResponsesTable, CachedResponseRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedResponsesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedResponsesTable,
      CachedResponseRow,
      $$CachedResponsesTableFilterComposer,
      $$CachedResponsesTableOrderingComposer,
      $$CachedResponsesTableAnnotationComposer,
      $$CachedResponsesTableCreateCompanionBuilder,
      $$CachedResponsesTableUpdateCompanionBuilder,
      (CachedResponseRow, BaseReferences<_$AppDatabase, $CachedResponsesTable, CachedResponseRow>),
      CachedResponseRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatalogStopsTableTableManager get catalogStops =>
      $$CatalogStopsTableTableManager(_db, _db.catalogStops);
  $$CatalogRoutesTableTableManager get catalogRoutes =>
      $$CatalogRoutesTableTableManager(_db, _db.catalogRoutes);
  $$KeyValuesTableTableManager get keyValues => $$KeyValuesTableTableManager(_db, _db.keyValues);
  $$FavoriteStopsTableTableManager get favoriteStops =>
      $$FavoriteStopsTableTableManager(_db, _db.favoriteStops);
  $$FavoriteLinesTableTableManager get favoriteLines =>
      $$FavoriteLinesTableTableManager(_db, _db.favoriteLines);
  $$RecentPlacesTableTableManager get recentPlaces =>
      $$RecentPlacesTableTableManager(_db, _db.recentPlaces);
  $$CachedResponsesTableTableManager get cachedResponses =>
      $$CachedResponsesTableTableManager(_db, _db.cachedResponses);
}
