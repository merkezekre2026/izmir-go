// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Notice {

 String get code; String get message; String? get source;
/// Create a copy of Notice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoticeCopyWith<Notice> get copyWith => _$NoticeCopyWithImpl<Notice>(this as Notice, _$identity);

  /// Serializes this Notice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Notice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Notice&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.source, _this.source) || other.source == _this.source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Notice;
  return Object.hash(runtimeType,_this.code,_this.message,_this.source);
}

@override
String toString() {
  final _this = this as Notice;
  return 'Notice(code: ${_this.code}, message: ${_this.message}, source: ${_this.source})';
}


}

/// @nodoc
abstract mixin class $NoticeCopyWith<$Res>  {
  factory $NoticeCopyWith(Notice value, $Res Function(Notice) _then) = _$NoticeCopyWithImpl;
@useResult
$Res call({
 String code, String message, String? source
});




}
/// @nodoc
class _$NoticeCopyWithImpl<$Res>
    implements $NoticeCopyWith<$Res> {
  _$NoticeCopyWithImpl(this._self, this._then);

  final Notice _self;
  final $Res Function(Notice) _then;

/// Create a copy of Notice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? source = freezed,}) {
  return _then(Notice(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Notice].
extension NoticePatterns on Notice {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Notice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Notice() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Notice value)  $default,){
final _that = this;
switch (_that) {
case _Notice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Notice value)?  $default,){
final _that = this;
switch (_that) {
case _Notice() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  String? source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Notice() when $default != null:
return $default(_that.code,_that.message,_that.source);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  String? source)  $default,) {final _that = this;
switch (_that) {
case _Notice():
return $default(_that.code,_that.message,_that.source);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  String? source)?  $default,) {final _that = this;
switch (_that) {
case _Notice() when $default != null:
return $default(_that.code,_that.message,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Notice implements Notice {
  const _Notice({required this.code, required this.message, this.source});
  factory _Notice.fromJson(Map<String, dynamic> json) => _$NoticeFromJson(json);

@override final  String code;
@override final  String message;
@override final  String? source;

/// Create a copy of Notice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoticeCopyWith<_Notice> get copyWith => __$NoticeCopyWithImpl<_Notice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoticeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Notice&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,message,source);
}

@override
String toString() {
    return 'Notice(code: $code, message: $message, source: $source)';
}


}

/// @nodoc
abstract mixin class _$NoticeCopyWith<$Res> implements $NoticeCopyWith<$Res> {
  factory _$NoticeCopyWith(_Notice value, $Res Function(_Notice) _then) = __$NoticeCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, String? source
});




}
/// @nodoc
class __$NoticeCopyWithImpl<$Res>
    implements _$NoticeCopyWith<$Res> {
  __$NoticeCopyWithImpl(this._self, this._then);

  final _Notice _self;
  final $Res Function(_Notice) _then;

/// Create a copy of Notice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? source = freezed,}) {
  return _then(_Notice(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DatasetRef {

 int get id; String get label; DateTime? get publishedAt;
/// Create a copy of DatasetRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatasetRefCopyWith<DatasetRef> get copyWith => _$DatasetRefCopyWithImpl<DatasetRef>(this as DatasetRef, _$identity);

  /// Serializes this DatasetRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DatasetRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DatasetRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DatasetRef;
  return Object.hash(runtimeType,_this.id,_this.label,_this.publishedAt);
}

@override
String toString() {
  final _this = this as DatasetRef;
  return 'DatasetRef(id: ${_this.id}, label: ${_this.label}, publishedAt: ${_this.publishedAt})';
}


}

/// @nodoc
abstract mixin class $DatasetRefCopyWith<$Res>  {
  factory $DatasetRefCopyWith(DatasetRef value, $Res Function(DatasetRef) _then) = _$DatasetRefCopyWithImpl;
@useResult
$Res call({
 int id, String label, DateTime? publishedAt
});




}
/// @nodoc
class _$DatasetRefCopyWithImpl<$Res>
    implements $DatasetRefCopyWith<$Res> {
  _$DatasetRefCopyWithImpl(this._self, this._then);

  final DatasetRef _self;
  final $Res Function(DatasetRef) _then;

/// Create a copy of DatasetRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? publishedAt = freezed,}) {
  return _then(DatasetRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DatasetRef].
extension DatasetRefPatterns on DatasetRef {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DatasetRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DatasetRef() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DatasetRef value)  $default,){
final _that = this;
switch (_that) {
case _DatasetRef():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DatasetRef value)?  $default,){
final _that = this;
switch (_that) {
case _DatasetRef() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String label,  DateTime? publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DatasetRef() when $default != null:
return $default(_that.id,_that.label,_that.publishedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String label,  DateTime? publishedAt)  $default,) {final _that = this;
switch (_that) {
case _DatasetRef():
return $default(_that.id,_that.label,_that.publishedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String label,  DateTime? publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _DatasetRef() when $default != null:
return $default(_that.id,_that.label,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DatasetRef implements DatasetRef {
  const _DatasetRef({required this.id, required this.label, this.publishedAt});
  factory _DatasetRef.fromJson(Map<String, dynamic> json) => _$DatasetRefFromJson(json);

@override final  int id;
@override final  String label;
@override final  DateTime? publishedAt;

/// Create a copy of DatasetRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatasetRefCopyWith<_DatasetRef> get copyWith => __$DatasetRefCopyWithImpl<_DatasetRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DatasetRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DatasetRef&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,label,publishedAt);
}

@override
String toString() {
    return 'DatasetRef(id: $id, label: $label, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$DatasetRefCopyWith<$Res> implements $DatasetRefCopyWith<$Res> {
  factory _$DatasetRefCopyWith(_DatasetRef value, $Res Function(_DatasetRef) _then) = __$DatasetRefCopyWithImpl;
@override @useResult
$Res call({
 int id, String label, DateTime? publishedAt
});




}
/// @nodoc
class __$DatasetRefCopyWithImpl<$Res>
    implements _$DatasetRefCopyWith<$Res> {
  __$DatasetRefCopyWithImpl(this._self, this._then);

  final _DatasetRef _self;
  final $Res Function(_DatasetRef) _then;

/// Create a copy of DatasetRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? publishedAt = freezed,}) {
  return _then(_DatasetRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SourceWindow {

 String get source; DateTime? get validFrom; DateTime? get validTo;
/// Create a copy of SourceWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SourceWindowCopyWith<SourceWindow> get copyWith => _$SourceWindowCopyWithImpl<SourceWindow>(this as SourceWindow, _$identity);

  /// Serializes this SourceWindow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SourceWindow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SourceWindow&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.validFrom, _this.validFrom) || other.validFrom == _this.validFrom)&&(identical(other.validTo, _this.validTo) || other.validTo == _this.validTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SourceWindow;
  return Object.hash(runtimeType,_this.source,_this.validFrom,_this.validTo);
}

@override
String toString() {
  final _this = this as SourceWindow;
  return 'SourceWindow(source: ${_this.source}, validFrom: ${_this.validFrom}, validTo: ${_this.validTo})';
}


}

/// @nodoc
abstract mixin class $SourceWindowCopyWith<$Res>  {
  factory $SourceWindowCopyWith(SourceWindow value, $Res Function(SourceWindow) _then) = _$SourceWindowCopyWithImpl;
@useResult
$Res call({
 String source, DateTime? validFrom, DateTime? validTo
});




}
/// @nodoc
class _$SourceWindowCopyWithImpl<$Res>
    implements $SourceWindowCopyWith<$Res> {
  _$SourceWindowCopyWithImpl(this._self, this._then);

  final SourceWindow _self;
  final $Res Function(SourceWindow) _then;

/// Create a copy of SourceWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? validFrom = freezed,Object? validTo = freezed,}) {
  return _then(SourceWindow(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SourceWindow].
extension SourceWindowPatterns on SourceWindow {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SourceWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SourceWindow() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SourceWindow value)  $default,){
final _that = this;
switch (_that) {
case _SourceWindow():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SourceWindow value)?  $default,){
final _that = this;
switch (_that) {
case _SourceWindow() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String source,  DateTime? validFrom,  DateTime? validTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SourceWindow() when $default != null:
return $default(_that.source,_that.validFrom,_that.validTo);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String source,  DateTime? validFrom,  DateTime? validTo)  $default,) {final _that = this;
switch (_that) {
case _SourceWindow():
return $default(_that.source,_that.validFrom,_that.validTo);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String source,  DateTime? validFrom,  DateTime? validTo)?  $default,) {final _that = this;
switch (_that) {
case _SourceWindow() when $default != null:
return $default(_that.source,_that.validFrom,_that.validTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SourceWindow implements SourceWindow {
  const _SourceWindow({required this.source, this.validFrom, this.validTo});
  factory _SourceWindow.fromJson(Map<String, dynamic> json) => _$SourceWindowFromJson(json);

@override final  String source;
@override final  DateTime? validFrom;
@override final  DateTime? validTo;

/// Create a copy of SourceWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SourceWindowCopyWith<_SourceWindow> get copyWith => __$SourceWindowCopyWithImpl<_SourceWindow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SourceWindowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SourceWindow&&(identical(other.source, source) || other.source == source)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTo, validTo) || other.validTo == validTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,source,validFrom,validTo);
}

@override
String toString() {
    return 'SourceWindow(source: $source, validFrom: $validFrom, validTo: $validTo)';
}


}

/// @nodoc
abstract mixin class _$SourceWindowCopyWith<$Res> implements $SourceWindowCopyWith<$Res> {
  factory _$SourceWindowCopyWith(_SourceWindow value, $Res Function(_SourceWindow) _then) = __$SourceWindowCopyWithImpl;
@override @useResult
$Res call({
 String source, DateTime? validFrom, DateTime? validTo
});




}
/// @nodoc
class __$SourceWindowCopyWithImpl<$Res>
    implements _$SourceWindowCopyWith<$Res> {
  __$SourceWindowCopyWithImpl(this._self, this._then);

  final _SourceWindow _self;
  final $Res Function(_SourceWindow) _then;

/// Create a copy of SourceWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? validFrom = freezed,Object? validTo = freezed,}) {
  return _then(_SourceWindow(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Meta {

 DatasetRef get dataset; DateTime get generatedAt; List<SourceWindow> get sources; List<Notice> get notices;
/// Create a copy of Meta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetaCopyWith<Meta> get copyWith => _$MetaCopyWithImpl<Meta>(this as Meta, _$identity);

  /// Serializes this Meta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Meta;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Meta&&(identical(other.dataset, _this.dataset) || other.dataset == _this.dataset)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt)&&const DeepCollectionEquality().equals(other.sources, _this.sources)&&const DeepCollectionEquality().equals(other.notices, _this.notices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Meta;
  return Object.hash(runtimeType,_this.dataset,_this.generatedAt,const DeepCollectionEquality().hash(_this.sources),const DeepCollectionEquality().hash(_this.notices));
}

@override
String toString() {
  final _this = this as Meta;
  return 'Meta(dataset: ${_this.dataset}, generatedAt: ${_this.generatedAt}, sources: ${_this.sources}, notices: ${_this.notices})';
}


}

/// @nodoc
abstract mixin class $MetaCopyWith<$Res>  {
  factory $MetaCopyWith(Meta value, $Res Function(Meta) _then) = _$MetaCopyWithImpl;
@useResult
$Res call({
 DatasetRef dataset, DateTime generatedAt, List<SourceWindow> sources, List<Notice> notices
});


$DatasetRefCopyWith<$Res> get dataset;

}
/// @nodoc
class _$MetaCopyWithImpl<$Res>
    implements $MetaCopyWith<$Res> {
  _$MetaCopyWithImpl(this._self, this._then);

  final Meta _self;
  final $Res Function(Meta) _then;

/// Create a copy of Meta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dataset = null,Object? generatedAt = null,Object? sources = null,Object? notices = null,}) {
  return _then(Meta(
dataset: null == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as DatasetRef,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<SourceWindow>,notices: null == notices ? _self.notices : notices // ignore: cast_nullable_to_non_nullable
as List<Notice>,
  ));
}
/// Create a copy of Meta
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DatasetRefCopyWith<$Res> get dataset {
  
  return $DatasetRefCopyWith<$Res>(_self.dataset, (value) {
    return _then(_self.copyWith(dataset: value));
  });
}
}


/// Adds pattern-matching-related methods to [Meta].
extension MetaPatterns on Meta {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Meta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Meta() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Meta value)  $default,){
final _that = this;
switch (_that) {
case _Meta():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Meta value)?  $default,){
final _that = this;
switch (_that) {
case _Meta() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DatasetRef dataset,  DateTime generatedAt,  List<SourceWindow> sources,  List<Notice> notices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Meta() when $default != null:
return $default(_that.dataset,_that.generatedAt,_that.sources,_that.notices);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DatasetRef dataset,  DateTime generatedAt,  List<SourceWindow> sources,  List<Notice> notices)  $default,) {final _that = this;
switch (_that) {
case _Meta():
return $default(_that.dataset,_that.generatedAt,_that.sources,_that.notices);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DatasetRef dataset,  DateTime generatedAt,  List<SourceWindow> sources,  List<Notice> notices)?  $default,) {final _that = this;
switch (_that) {
case _Meta() when $default != null:
return $default(_that.dataset,_that.generatedAt,_that.sources,_that.notices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Meta implements Meta {
  const _Meta({required this.dataset, required this.generatedAt,  List<SourceWindow> sources = const <SourceWindow>[],  List<Notice> notices = const <Notice>[]}): _sources = sources,_notices = notices;
  factory _Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

@override final  DatasetRef dataset;
@override final  DateTime generatedAt;
 final  List<SourceWindow> _sources;
@override@JsonKey() List<SourceWindow> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

 final  List<Notice> _notices;
@override@JsonKey() List<Notice> get notices {
  if (_notices is EqualUnmodifiableListView) return _notices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notices);
}


/// Create a copy of Meta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetaCopyWith<_Meta> get copyWith => __$MetaCopyWithImpl<_Meta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Meta&&(identical(other.dataset, dataset) || other.dataset == dataset)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other.sources, _sources)&&const DeepCollectionEquality().equals(other.notices, _notices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dataset,generatedAt,const DeepCollectionEquality().hash(_sources),const DeepCollectionEquality().hash(_notices));
}

@override
String toString() {
    return 'Meta(dataset: $dataset, generatedAt: $generatedAt, sources: $sources, notices: $notices)';
}


}

/// @nodoc
abstract mixin class _$MetaCopyWith<$Res> implements $MetaCopyWith<$Res> {
  factory _$MetaCopyWith(_Meta value, $Res Function(_Meta) _then) = __$MetaCopyWithImpl;
@override @useResult
$Res call({
 DatasetRef dataset, DateTime generatedAt, List<SourceWindow> sources, List<Notice> notices
});


@override $DatasetRefCopyWith<$Res> get dataset;

}
/// @nodoc
class __$MetaCopyWithImpl<$Res>
    implements _$MetaCopyWith<$Res> {
  __$MetaCopyWithImpl(this._self, this._then);

  final _Meta _self;
  final $Res Function(_Meta) _then;

/// Create a copy of Meta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dataset = null,Object? generatedAt = null,Object? sources = null,Object? notices = null,}) {
  return _then(_Meta(
dataset: null == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as DatasetRef,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<SourceWindow>,notices: null == notices ? _self._notices : notices // ignore: cast_nullable_to_non_nullable
as List<Notice>,
  ));
}

/// Create a copy of Meta
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DatasetRefCopyWith<$Res> get dataset {
  
  return $DatasetRefCopyWith<$Res>(_self.dataset, (value) {
    return _then(_self.copyWith(dataset: value));
  });
}
}


/// @nodoc
mixin _$RouteSummary {

 String get id; String get lineKey; TransitMode get mode; String get source; bool get timesApproximate; String? get shortName; String? get longName; String? get color; String? get textColor;
/// Create a copy of RouteSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteSummaryCopyWith<RouteSummary> get copyWith => _$RouteSummaryCopyWithImpl<RouteSummary>(this as RouteSummary, _$identity);

  /// Serializes this RouteSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.lineKey, _this.lineKey) || other.lineKey == _this.lineKey)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.timesApproximate, _this.timesApproximate) || other.timesApproximate == _this.timesApproximate)&&(identical(other.shortName, _this.shortName) || other.shortName == _this.shortName)&&(identical(other.longName, _this.longName) || other.longName == _this.longName)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.textColor, _this.textColor) || other.textColor == _this.textColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteSummary;
  return Object.hash(runtimeType,_this.id,_this.lineKey,_this.mode,_this.source,_this.timesApproximate,_this.shortName,_this.longName,_this.color,_this.textColor);
}

@override
String toString() {
  final _this = this as RouteSummary;
  return 'RouteSummary(id: ${_this.id}, lineKey: ${_this.lineKey}, mode: ${_this.mode}, source: ${_this.source}, timesApproximate: ${_this.timesApproximate}, shortName: ${_this.shortName}, longName: ${_this.longName}, color: ${_this.color}, textColor: ${_this.textColor})';
}


}

/// @nodoc
abstract mixin class $RouteSummaryCopyWith<$Res>  {
  factory $RouteSummaryCopyWith(RouteSummary value, $Res Function(RouteSummary) _then) = _$RouteSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String lineKey, TransitMode mode, String source, bool timesApproximate, String? shortName, String? longName, String? color, String? textColor
});




}
/// @nodoc
class _$RouteSummaryCopyWithImpl<$Res>
    implements $RouteSummaryCopyWith<$Res> {
  _$RouteSummaryCopyWithImpl(this._self, this._then);

  final RouteSummary _self;
  final $Res Function(RouteSummary) _then;

/// Create a copy of RouteSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lineKey = null,Object? mode = null,Object? source = null,Object? timesApproximate = null,Object? shortName = freezed,Object? longName = freezed,Object? color = freezed,Object? textColor = freezed,}) {
  return _then(RouteSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lineKey: null == lineKey ? _self.lineKey : lineKey // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransitMode,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,timesApproximate: null == timesApproximate ? _self.timesApproximate : timesApproximate // ignore: cast_nullable_to_non_nullable
as bool,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String?,longName: freezed == longName ? _self.longName : longName // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteSummary].
extension RouteSummaryPatterns on RouteSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteSummary value)  $default,){
final _that = this;
switch (_that) {
case _RouteSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RouteSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String lineKey,  TransitMode mode,  String source,  bool timesApproximate,  String? shortName,  String? longName,  String? color,  String? textColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteSummary() when $default != null:
return $default(_that.id,_that.lineKey,_that.mode,_that.source,_that.timesApproximate,_that.shortName,_that.longName,_that.color,_that.textColor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String lineKey,  TransitMode mode,  String source,  bool timesApproximate,  String? shortName,  String? longName,  String? color,  String? textColor)  $default,) {final _that = this;
switch (_that) {
case _RouteSummary():
return $default(_that.id,_that.lineKey,_that.mode,_that.source,_that.timesApproximate,_that.shortName,_that.longName,_that.color,_that.textColor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String lineKey,  TransitMode mode,  String source,  bool timesApproximate,  String? shortName,  String? longName,  String? color,  String? textColor)?  $default,) {final _that = this;
switch (_that) {
case _RouteSummary() when $default != null:
return $default(_that.id,_that.lineKey,_that.mode,_that.source,_that.timesApproximate,_that.shortName,_that.longName,_that.color,_that.textColor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteSummary extends RouteSummary {
  const _RouteSummary({required this.id, required this.lineKey, required this.mode, required this.source, required this.timesApproximate, this.shortName, this.longName, this.color, this.textColor}): super._();
  factory _RouteSummary.fromJson(Map<String, dynamic> json) => _$RouteSummaryFromJson(json);

@override final  String id;
@override final  String lineKey;
@override final  TransitMode mode;
@override final  String source;
@override final  bool timesApproximate;
@override final  String? shortName;
@override final  String? longName;
@override final  String? color;
@override final  String? textColor;

/// Create a copy of RouteSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteSummaryCopyWith<_RouteSummary> get copyWith => __$RouteSummaryCopyWithImpl<_RouteSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.lineKey, lineKey) || other.lineKey == lineKey)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.source, source) || other.source == source)&&(identical(other.timesApproximate, timesApproximate) || other.timesApproximate == timesApproximate)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.longName, longName) || other.longName == longName)&&(identical(other.color, color) || other.color == color)&&(identical(other.textColor, textColor) || other.textColor == textColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,lineKey,mode,source,timesApproximate,shortName,longName,color,textColor);
}

@override
String toString() {
    return 'RouteSummary(id: $id, lineKey: $lineKey, mode: $mode, source: $source, timesApproximate: $timesApproximate, shortName: $shortName, longName: $longName, color: $color, textColor: $textColor)';
}


}

/// @nodoc
abstract mixin class _$RouteSummaryCopyWith<$Res> implements $RouteSummaryCopyWith<$Res> {
  factory _$RouteSummaryCopyWith(_RouteSummary value, $Res Function(_RouteSummary) _then) = __$RouteSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String lineKey, TransitMode mode, String source, bool timesApproximate, String? shortName, String? longName, String? color, String? textColor
});




}
/// @nodoc
class __$RouteSummaryCopyWithImpl<$Res>
    implements _$RouteSummaryCopyWith<$Res> {
  __$RouteSummaryCopyWithImpl(this._self, this._then);

  final _RouteSummary _self;
  final $Res Function(_RouteSummary) _then;

/// Create a copy of RouteSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lineKey = null,Object? mode = null,Object? source = null,Object? timesApproximate = null,Object? shortName = freezed,Object? longName = freezed,Object? color = freezed,Object? textColor = freezed,}) {
  return _then(_RouteSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lineKey: null == lineKey ? _self.lineKey : lineKey // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransitMode,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,timesApproximate: null == timesApproximate ? _self.timesApproximate : timesApproximate // ignore: cast_nullable_to_non_nullable
as bool,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String?,longName: freezed == longName ? _self.longName : longName // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StopSummary {

 String get id; String get name; double get lat; double get lon; List<TransitMode> get modes; String get kind; String get source; bool get hasSchedule; String? get code; String? get parentStation; List<String> get lines; int? get distanceM;
/// Create a copy of StopSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopSummaryCopyWith<StopSummary> get copyWith => _$StopSummaryCopyWithImpl<StopSummary>(this as StopSummary, _$identity);

  /// Serializes this StopSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StopSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lon, _this.lon) || other.lon == _this.lon)&&const DeepCollectionEquality().equals(other.modes, _this.modes)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.hasSchedule, _this.hasSchedule) || other.hasSchedule == _this.hasSchedule)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.parentStation, _this.parentStation) || other.parentStation == _this.parentStation)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StopSummary;
  return Object.hash(runtimeType,_this.id,_this.name,_this.lat,_this.lon,const DeepCollectionEquality().hash(_this.modes),_this.kind,_this.source,_this.hasSchedule,_this.code,_this.parentStation,const DeepCollectionEquality().hash(_this.lines),_this.distanceM);
}

@override
String toString() {
  final _this = this as StopSummary;
  return 'StopSummary(id: ${_this.id}, name: ${_this.name}, lat: ${_this.lat}, lon: ${_this.lon}, modes: ${_this.modes}, kind: ${_this.kind}, source: ${_this.source}, hasSchedule: ${_this.hasSchedule}, code: ${_this.code}, parentStation: ${_this.parentStation}, lines: ${_this.lines}, distanceM: ${_this.distanceM})';
}


}

/// @nodoc
abstract mixin class $StopSummaryCopyWith<$Res>  {
  factory $StopSummaryCopyWith(StopSummary value, $Res Function(StopSummary) _then) = _$StopSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, double lat, double lon, List<TransitMode> modes, String kind, String source, bool hasSchedule, String? code, String? parentStation, List<String> lines, int? distanceM
});




}
/// @nodoc
class _$StopSummaryCopyWithImpl<$Res>
    implements $StopSummaryCopyWith<$Res> {
  _$StopSummaryCopyWithImpl(this._self, this._then);

  final StopSummary _self;
  final $Res Function(StopSummary) _then;

/// Create a copy of StopSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lon = null,Object? modes = null,Object? kind = null,Object? source = null,Object? hasSchedule = null,Object? code = freezed,Object? parentStation = freezed,Object? lines = null,Object? distanceM = freezed,}) {
  return _then(StopSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,modes: null == modes ? _self.modes : modes // ignore: cast_nullable_to_non_nullable
as List<TransitMode>,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,hasSchedule: null == hasSchedule ? _self.hasSchedule : hasSchedule // ignore: cast_nullable_to_non_nullable
as bool,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,parentStation: freezed == parentStation ? _self.parentStation : parentStation // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<String>,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [StopSummary].
extension StopSummaryPatterns on StopSummary {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StopSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StopSummary() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StopSummary value)  $default,){
final _that = this;
switch (_that) {
case _StopSummary():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StopSummary value)?  $default,){
final _that = this;
switch (_that) {
case _StopSummary() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lon,  List<TransitMode> modes,  String kind,  String source,  bool hasSchedule,  String? code,  String? parentStation,  List<String> lines,  int? distanceM)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StopSummary() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.modes,_that.kind,_that.source,_that.hasSchedule,_that.code,_that.parentStation,_that.lines,_that.distanceM);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lon,  List<TransitMode> modes,  String kind,  String source,  bool hasSchedule,  String? code,  String? parentStation,  List<String> lines,  int? distanceM)  $default,) {final _that = this;
switch (_that) {
case _StopSummary():
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.modes,_that.kind,_that.source,_that.hasSchedule,_that.code,_that.parentStation,_that.lines,_that.distanceM);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double lat,  double lon,  List<TransitMode> modes,  String kind,  String source,  bool hasSchedule,  String? code,  String? parentStation,  List<String> lines,  int? distanceM)?  $default,) {final _that = this;
switch (_that) {
case _StopSummary() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.modes,_that.kind,_that.source,_that.hasSchedule,_that.code,_that.parentStation,_that.lines,_that.distanceM);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StopSummary extends StopSummary {
  const _StopSummary({required this.id, required this.name, required this.lat, required this.lon, required  List<TransitMode> modes, required this.kind, required this.source, required this.hasSchedule, this.code, this.parentStation,  List<String> lines = const <String>[], this.distanceM}): _modes = modes,_lines = lines,super._();
  factory _StopSummary.fromJson(Map<String, dynamic> json) => _$StopSummaryFromJson(json);

@override final  String id;
@override final  String name;
@override final  double lat;
@override final  double lon;
 final  List<TransitMode> _modes;
@override List<TransitMode> get modes {
  if (_modes is EqualUnmodifiableListView) return _modes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modes);
}

@override final  String kind;
@override final  String source;
@override final  bool hasSchedule;
@override final  String? code;
@override final  String? parentStation;
 final  List<String> _lines;
@override@JsonKey() List<String> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override final  int? distanceM;

/// Create a copy of StopSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StopSummaryCopyWith<_StopSummary> get copyWith => __$StopSummaryCopyWithImpl<_StopSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StopSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&const DeepCollectionEquality().equals(other.modes, _modes)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.source, source) || other.source == source)&&(identical(other.hasSchedule, hasSchedule) || other.hasSchedule == hasSchedule)&&(identical(other.code, code) || other.code == code)&&(identical(other.parentStation, parentStation) || other.parentStation == parentStation)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,lat,lon,const DeepCollectionEquality().hash(_modes),kind,source,hasSchedule,code,parentStation,const DeepCollectionEquality().hash(_lines),distanceM);
}

@override
String toString() {
    return 'StopSummary(id: $id, name: $name, lat: $lat, lon: $lon, modes: $modes, kind: $kind, source: $source, hasSchedule: $hasSchedule, code: $code, parentStation: $parentStation, lines: $lines, distanceM: $distanceM)';
}


}

/// @nodoc
abstract mixin class _$StopSummaryCopyWith<$Res> implements $StopSummaryCopyWith<$Res> {
  factory _$StopSummaryCopyWith(_StopSummary value, $Res Function(_StopSummary) _then) = __$StopSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double lat, double lon, List<TransitMode> modes, String kind, String source, bool hasSchedule, String? code, String? parentStation, List<String> lines, int? distanceM
});




}
/// @nodoc
class __$StopSummaryCopyWithImpl<$Res>
    implements _$StopSummaryCopyWith<$Res> {
  __$StopSummaryCopyWithImpl(this._self, this._then);

  final _StopSummary _self;
  final $Res Function(_StopSummary) _then;

/// Create a copy of StopSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lon = null,Object? modes = null,Object? kind = null,Object? source = null,Object? hasSchedule = null,Object? code = freezed,Object? parentStation = freezed,Object? lines = null,Object? distanceM = freezed,}) {
  return _then(_StopSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,modes: null == modes ? _self._modes : modes // ignore: cast_nullable_to_non_nullable
as List<TransitMode>,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,hasSchedule: null == hasSchedule ? _self.hasSchedule : hasSchedule // ignore: cast_nullable_to_non_nullable
as bool,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,parentStation: freezed == parentStation ? _self.parentStation : parentStation // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<String>,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$StopDetail {

 String get id; String get name; double get lat; double get lon; List<TransitMode> get modes; String get kind; String get source; bool get hasSchedule; bool get liveSupported; String? get code; String? get parentStation; int? get wheelchairBoarding; List<String> get lines; List<StopSummary> get children; List<RouteSummary> get routes;
/// Create a copy of StopDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopDetailCopyWith<StopDetail> get copyWith => _$StopDetailCopyWithImpl<StopDetail>(this as StopDetail, _$identity);

  /// Serializes this StopDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StopDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lon, _this.lon) || other.lon == _this.lon)&&const DeepCollectionEquality().equals(other.modes, _this.modes)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.hasSchedule, _this.hasSchedule) || other.hasSchedule == _this.hasSchedule)&&(identical(other.liveSupported, _this.liveSupported) || other.liveSupported == _this.liveSupported)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.parentStation, _this.parentStation) || other.parentStation == _this.parentStation)&&(identical(other.wheelchairBoarding, _this.wheelchairBoarding) || other.wheelchairBoarding == _this.wheelchairBoarding)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&const DeepCollectionEquality().equals(other.children, _this.children)&&const DeepCollectionEquality().equals(other.routes, _this.routes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StopDetail;
  return Object.hash(runtimeType,_this.id,_this.name,_this.lat,_this.lon,const DeepCollectionEquality().hash(_this.modes),_this.kind,_this.source,_this.hasSchedule,_this.liveSupported,_this.code,_this.parentStation,_this.wheelchairBoarding,const DeepCollectionEquality().hash(_this.lines),const DeepCollectionEquality().hash(_this.children),const DeepCollectionEquality().hash(_this.routes));
}

@override
String toString() {
  final _this = this as StopDetail;
  return 'StopDetail(id: ${_this.id}, name: ${_this.name}, lat: ${_this.lat}, lon: ${_this.lon}, modes: ${_this.modes}, kind: ${_this.kind}, source: ${_this.source}, hasSchedule: ${_this.hasSchedule}, liveSupported: ${_this.liveSupported}, code: ${_this.code}, parentStation: ${_this.parentStation}, wheelchairBoarding: ${_this.wheelchairBoarding}, lines: ${_this.lines}, children: ${_this.children}, routes: ${_this.routes})';
}


}

/// @nodoc
abstract mixin class $StopDetailCopyWith<$Res>  {
  factory $StopDetailCopyWith(StopDetail value, $Res Function(StopDetail) _then) = _$StopDetailCopyWithImpl;
@useResult
$Res call({
 String id, String name, double lat, double lon, List<TransitMode> modes, String kind, String source, bool hasSchedule, bool liveSupported, String? code, String? parentStation, int? wheelchairBoarding, List<String> lines, List<StopSummary> children, List<RouteSummary> routes
});




}
/// @nodoc
class _$StopDetailCopyWithImpl<$Res>
    implements $StopDetailCopyWith<$Res> {
  _$StopDetailCopyWithImpl(this._self, this._then);

  final StopDetail _self;
  final $Res Function(StopDetail) _then;

/// Create a copy of StopDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lon = null,Object? modes = null,Object? kind = null,Object? source = null,Object? hasSchedule = null,Object? liveSupported = null,Object? code = freezed,Object? parentStation = freezed,Object? wheelchairBoarding = freezed,Object? lines = null,Object? children = null,Object? routes = null,}) {
  return _then(StopDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,modes: null == modes ? _self.modes : modes // ignore: cast_nullable_to_non_nullable
as List<TransitMode>,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,hasSchedule: null == hasSchedule ? _self.hasSchedule : hasSchedule // ignore: cast_nullable_to_non_nullable
as bool,liveSupported: null == liveSupported ? _self.liveSupported : liveSupported // ignore: cast_nullable_to_non_nullable
as bool,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,parentStation: freezed == parentStation ? _self.parentStation : parentStation // ignore: cast_nullable_to_non_nullable
as String?,wheelchairBoarding: freezed == wheelchairBoarding ? _self.wheelchairBoarding : wheelchairBoarding // ignore: cast_nullable_to_non_nullable
as int?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<String>,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<StopSummary>,routes: null == routes ? _self.routes : routes // ignore: cast_nullable_to_non_nullable
as List<RouteSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [StopDetail].
extension StopDetailPatterns on StopDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StopDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StopDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StopDetail value)  $default,){
final _that = this;
switch (_that) {
case _StopDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StopDetail value)?  $default,){
final _that = this;
switch (_that) {
case _StopDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lon,  List<TransitMode> modes,  String kind,  String source,  bool hasSchedule,  bool liveSupported,  String? code,  String? parentStation,  int? wheelchairBoarding,  List<String> lines,  List<StopSummary> children,  List<RouteSummary> routes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StopDetail() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.modes,_that.kind,_that.source,_that.hasSchedule,_that.liveSupported,_that.code,_that.parentStation,_that.wheelchairBoarding,_that.lines,_that.children,_that.routes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lon,  List<TransitMode> modes,  String kind,  String source,  bool hasSchedule,  bool liveSupported,  String? code,  String? parentStation,  int? wheelchairBoarding,  List<String> lines,  List<StopSummary> children,  List<RouteSummary> routes)  $default,) {final _that = this;
switch (_that) {
case _StopDetail():
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.modes,_that.kind,_that.source,_that.hasSchedule,_that.liveSupported,_that.code,_that.parentStation,_that.wheelchairBoarding,_that.lines,_that.children,_that.routes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double lat,  double lon,  List<TransitMode> modes,  String kind,  String source,  bool hasSchedule,  bool liveSupported,  String? code,  String? parentStation,  int? wheelchairBoarding,  List<String> lines,  List<StopSummary> children,  List<RouteSummary> routes)?  $default,) {final _that = this;
switch (_that) {
case _StopDetail() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.modes,_that.kind,_that.source,_that.hasSchedule,_that.liveSupported,_that.code,_that.parentStation,_that.wheelchairBoarding,_that.lines,_that.children,_that.routes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StopDetail implements StopDetail {
  const _StopDetail({required this.id, required this.name, required this.lat, required this.lon, required  List<TransitMode> modes, required this.kind, required this.source, required this.hasSchedule, required this.liveSupported, this.code, this.parentStation, this.wheelchairBoarding,  List<String> lines = const <String>[],  List<StopSummary> children = const <StopSummary>[],  List<RouteSummary> routes = const <RouteSummary>[]}): _modes = modes,_lines = lines,_children = children,_routes = routes;
  factory _StopDetail.fromJson(Map<String, dynamic> json) => _$StopDetailFromJson(json);

@override final  String id;
@override final  String name;
@override final  double lat;
@override final  double lon;
 final  List<TransitMode> _modes;
@override List<TransitMode> get modes {
  if (_modes is EqualUnmodifiableListView) return _modes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modes);
}

@override final  String kind;
@override final  String source;
@override final  bool hasSchedule;
@override final  bool liveSupported;
@override final  String? code;
@override final  String? parentStation;
@override final  int? wheelchairBoarding;
 final  List<String> _lines;
@override@JsonKey() List<String> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

 final  List<StopSummary> _children;
@override@JsonKey() List<StopSummary> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

 final  List<RouteSummary> _routes;
@override@JsonKey() List<RouteSummary> get routes {
  if (_routes is EqualUnmodifiableListView) return _routes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routes);
}


/// Create a copy of StopDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StopDetailCopyWith<_StopDetail> get copyWith => __$StopDetailCopyWithImpl<_StopDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StopDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&const DeepCollectionEquality().equals(other.modes, _modes)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.source, source) || other.source == source)&&(identical(other.hasSchedule, hasSchedule) || other.hasSchedule == hasSchedule)&&(identical(other.liveSupported, liveSupported) || other.liveSupported == liveSupported)&&(identical(other.code, code) || other.code == code)&&(identical(other.parentStation, parentStation) || other.parentStation == parentStation)&&(identical(other.wheelchairBoarding, wheelchairBoarding) || other.wheelchairBoarding == wheelchairBoarding)&&const DeepCollectionEquality().equals(other.lines, _lines)&&const DeepCollectionEquality().equals(other.children, _children)&&const DeepCollectionEquality().equals(other.routes, _routes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,lat,lon,const DeepCollectionEquality().hash(_modes),kind,source,hasSchedule,liveSupported,code,parentStation,wheelchairBoarding,const DeepCollectionEquality().hash(_lines),const DeepCollectionEquality().hash(_children),const DeepCollectionEquality().hash(_routes));
}

@override
String toString() {
    return 'StopDetail(id: $id, name: $name, lat: $lat, lon: $lon, modes: $modes, kind: $kind, source: $source, hasSchedule: $hasSchedule, liveSupported: $liveSupported, code: $code, parentStation: $parentStation, wheelchairBoarding: $wheelchairBoarding, lines: $lines, children: $children, routes: $routes)';
}


}

/// @nodoc
abstract mixin class _$StopDetailCopyWith<$Res> implements $StopDetailCopyWith<$Res> {
  factory _$StopDetailCopyWith(_StopDetail value, $Res Function(_StopDetail) _then) = __$StopDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double lat, double lon, List<TransitMode> modes, String kind, String source, bool hasSchedule, bool liveSupported, String? code, String? parentStation, int? wheelchairBoarding, List<String> lines, List<StopSummary> children, List<RouteSummary> routes
});




}
/// @nodoc
class __$StopDetailCopyWithImpl<$Res>
    implements _$StopDetailCopyWith<$Res> {
  __$StopDetailCopyWithImpl(this._self, this._then);

  final _StopDetail _self;
  final $Res Function(_StopDetail) _then;

/// Create a copy of StopDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lon = null,Object? modes = null,Object? kind = null,Object? source = null,Object? hasSchedule = null,Object? liveSupported = null,Object? code = freezed,Object? parentStation = freezed,Object? wheelchairBoarding = freezed,Object? lines = null,Object? children = null,Object? routes = null,}) {
  return _then(_StopDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,modes: null == modes ? _self._modes : modes // ignore: cast_nullable_to_non_nullable
as List<TransitMode>,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,hasSchedule: null == hasSchedule ? _self.hasSchedule : hasSchedule // ignore: cast_nullable_to_non_nullable
as bool,liveSupported: null == liveSupported ? _self.liveSupported : liveSupported // ignore: cast_nullable_to_non_nullable
as bool,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,parentStation: freezed == parentStation ? _self.parentStation : parentStation // ignore: cast_nullable_to_non_nullable
as String?,wheelchairBoarding: freezed == wheelchairBoarding ? _self.wheelchairBoarding : wheelchairBoarding // ignore: cast_nullable_to_non_nullable
as int?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<String>,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<StopSummary>,routes: null == routes ? _self._routes : routes // ignore: cast_nullable_to_non_nullable
as List<RouteSummary>,
  ));
}


}


/// @nodoc
mixin _$StopResponse {

 StopDetail get stop; Meta get meta;
/// Create a copy of StopResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopResponseCopyWith<StopResponse> get copyWith => _$StopResponseCopyWithImpl<StopResponse>(this as StopResponse, _$identity);

  /// Serializes this StopResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StopResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopResponse&&(identical(other.stop, _this.stop) || other.stop == _this.stop)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StopResponse;
  return Object.hash(runtimeType,_this.stop,_this.meta);
}

@override
String toString() {
  final _this = this as StopResponse;
  return 'StopResponse(stop: ${_this.stop}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $StopResponseCopyWith<$Res>  {
  factory $StopResponseCopyWith(StopResponse value, $Res Function(StopResponse) _then) = _$StopResponseCopyWithImpl;
@useResult
$Res call({
 StopDetail stop, Meta meta
});


$StopDetailCopyWith<$Res> get stop;$MetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$StopResponseCopyWithImpl<$Res>
    implements $StopResponseCopyWith<$Res> {
  _$StopResponseCopyWithImpl(this._self, this._then);

  final StopResponse _self;
  final $Res Function(StopResponse) _then;

/// Create a copy of StopResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stop = null,Object? meta = null,}) {
  return _then(StopResponse(
stop: null == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as StopDetail,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}
/// Create a copy of StopResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopDetailCopyWith<$Res> get stop {
  
  return $StopDetailCopyWith<$Res>(_self.stop, (value) {
    return _then(_self.copyWith(stop: value));
  });
}/// Create a copy of StopResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [StopResponse].
extension StopResponsePatterns on StopResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StopResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StopResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StopResponse value)  $default,){
final _that = this;
switch (_that) {
case _StopResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StopResponse value)?  $default,){
final _that = this;
switch (_that) {
case _StopResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StopDetail stop,  Meta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StopResponse() when $default != null:
return $default(_that.stop,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StopDetail stop,  Meta meta)  $default,) {final _that = this;
switch (_that) {
case _StopResponse():
return $default(_that.stop,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StopDetail stop,  Meta meta)?  $default,) {final _that = this;
switch (_that) {
case _StopResponse() when $default != null:
return $default(_that.stop,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StopResponse implements StopResponse {
  const _StopResponse({required this.stop, required this.meta});
  factory _StopResponse.fromJson(Map<String, dynamic> json) => _$StopResponseFromJson(json);

@override final  StopDetail stop;
@override final  Meta meta;

/// Create a copy of StopResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StopResponseCopyWith<_StopResponse> get copyWith => __$StopResponseCopyWithImpl<_StopResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StopResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopResponse&&(identical(other.stop, stop) || other.stop == stop)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,stop,meta);
}

@override
String toString() {
    return 'StopResponse(stop: $stop, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$StopResponseCopyWith<$Res> implements $StopResponseCopyWith<$Res> {
  factory _$StopResponseCopyWith(_StopResponse value, $Res Function(_StopResponse) _then) = __$StopResponseCopyWithImpl;
@override @useResult
$Res call({
 StopDetail stop, Meta meta
});


@override $StopDetailCopyWith<$Res> get stop;@override $MetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$StopResponseCopyWithImpl<$Res>
    implements _$StopResponseCopyWith<$Res> {
  __$StopResponseCopyWithImpl(this._self, this._then);

  final _StopResponse _self;
  final $Res Function(_StopResponse) _then;

/// Create a copy of StopResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stop = null,Object? meta = null,}) {
  return _then(_StopResponse(
stop: null == stop ? _self.stop : stop // ignore: cast_nullable_to_non_nullable
as StopDetail,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}

/// Create a copy of StopResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StopDetailCopyWith<$Res> get stop {
  
  return $StopDetailCopyWith<$Res>(_self.stop, (value) {
    return _then(_self.copyWith(stop: value));
  });
}/// Create a copy of StopResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$StopPage {

 List<StopSummary> get items; Meta get meta; String? get nextCursor;
/// Create a copy of StopPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopPageCopyWith<StopPage> get copyWith => _$StopPageCopyWithImpl<StopPage>(this as StopPage, _$identity);

  /// Serializes this StopPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StopPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopPage&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.meta, _this.meta) || other.meta == _this.meta)&&(identical(other.nextCursor, _this.nextCursor) || other.nextCursor == _this.nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StopPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.meta,_this.nextCursor);
}

@override
String toString() {
  final _this = this as StopPage;
  return 'StopPage(items: ${_this.items}, meta: ${_this.meta}, nextCursor: ${_this.nextCursor})';
}


}

/// @nodoc
abstract mixin class $StopPageCopyWith<$Res>  {
  factory $StopPageCopyWith(StopPage value, $Res Function(StopPage) _then) = _$StopPageCopyWithImpl;
@useResult
$Res call({
 List<StopSummary> items, Meta meta, String? nextCursor
});


$MetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$StopPageCopyWithImpl<$Res>
    implements $StopPageCopyWith<$Res> {
  _$StopPageCopyWithImpl(this._self, this._then);

  final StopPage _self;
  final $Res Function(StopPage) _then;

/// Create a copy of StopPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? meta = null,Object? nextCursor = freezed,}) {
  return _then(StopPage(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StopSummary>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of StopPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [StopPage].
extension StopPagePatterns on StopPage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StopPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StopPage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StopPage value)  $default,){
final _that = this;
switch (_that) {
case _StopPage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StopPage value)?  $default,){
final _that = this;
switch (_that) {
case _StopPage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StopSummary> items,  Meta meta,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StopPage() when $default != null:
return $default(_that.items,_that.meta,_that.nextCursor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StopSummary> items,  Meta meta,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _StopPage():
return $default(_that.items,_that.meta,_that.nextCursor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StopSummary> items,  Meta meta,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _StopPage() when $default != null:
return $default(_that.items,_that.meta,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StopPage implements StopPage {
  const _StopPage({required  List<StopSummary> items, required this.meta, this.nextCursor}): _items = items;
  factory _StopPage.fromJson(Map<String, dynamic> json) => _$StopPageFromJson(json);

 final  List<StopSummary> _items;
@override List<StopSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Meta meta;
@override final  String? nextCursor;

/// Create a copy of StopPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StopPageCopyWith<_StopPage> get copyWith => __$StopPageCopyWithImpl<_StopPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StopPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopPage&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta,nextCursor);
}

@override
String toString() {
    return 'StopPage(items: $items, meta: $meta, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$StopPageCopyWith<$Res> implements $StopPageCopyWith<$Res> {
  factory _$StopPageCopyWith(_StopPage value, $Res Function(_StopPage) _then) = __$StopPageCopyWithImpl;
@override @useResult
$Res call({
 List<StopSummary> items, Meta meta, String? nextCursor
});


@override $MetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$StopPageCopyWithImpl<$Res>
    implements _$StopPageCopyWith<$Res> {
  __$StopPageCopyWithImpl(this._self, this._then);

  final _StopPage _self;
  final $Res Function(_StopPage) _then;

/// Create a copy of StopPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,Object? nextCursor = freezed,}) {
  return _then(_StopPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<StopSummary>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of StopPage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$NearbyResponse {

 List<StopSummary> get items; Meta get meta;
/// Create a copy of NearbyResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyResponseCopyWith<NearbyResponse> get copyWith => _$NearbyResponseCopyWithImpl<NearbyResponse>(this as NearbyResponse, _$identity);

  /// Serializes this NearbyResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NearbyResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyResponse&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NearbyResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.meta);
}

@override
String toString() {
  final _this = this as NearbyResponse;
  return 'NearbyResponse(items: ${_this.items}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $NearbyResponseCopyWith<$Res>  {
  factory $NearbyResponseCopyWith(NearbyResponse value, $Res Function(NearbyResponse) _then) = _$NearbyResponseCopyWithImpl;
@useResult
$Res call({
 List<StopSummary> items, Meta meta
});


$MetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$NearbyResponseCopyWithImpl<$Res>
    implements $NearbyResponseCopyWith<$Res> {
  _$NearbyResponseCopyWithImpl(this._self, this._then);

  final NearbyResponse _self;
  final $Res Function(NearbyResponse) _then;

/// Create a copy of NearbyResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? meta = null,}) {
  return _then(NearbyResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StopSummary>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}
/// Create a copy of NearbyResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [NearbyResponse].
extension NearbyResponsePatterns on NearbyResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearbyResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearbyResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearbyResponse value)  $default,){
final _that = this;
switch (_that) {
case _NearbyResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearbyResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NearbyResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StopSummary> items,  Meta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearbyResponse() when $default != null:
return $default(_that.items,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StopSummary> items,  Meta meta)  $default,) {final _that = this;
switch (_that) {
case _NearbyResponse():
return $default(_that.items,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StopSummary> items,  Meta meta)?  $default,) {final _that = this;
switch (_that) {
case _NearbyResponse() when $default != null:
return $default(_that.items,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NearbyResponse implements NearbyResponse {
  const _NearbyResponse({required  List<StopSummary> items, required this.meta}): _items = items;
  factory _NearbyResponse.fromJson(Map<String, dynamic> json) => _$NearbyResponseFromJson(json);

 final  List<StopSummary> _items;
@override List<StopSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Meta meta;

/// Create a copy of NearbyResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearbyResponseCopyWith<_NearbyResponse> get copyWith => __$NearbyResponseCopyWithImpl<_NearbyResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NearbyResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearbyResponse&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta);
}

@override
String toString() {
    return 'NearbyResponse(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$NearbyResponseCopyWith<$Res> implements $NearbyResponseCopyWith<$Res> {
  factory _$NearbyResponseCopyWith(_NearbyResponse value, $Res Function(_NearbyResponse) _then) = __$NearbyResponseCopyWithImpl;
@override @useResult
$Res call({
 List<StopSummary> items, Meta meta
});


@override $MetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$NearbyResponseCopyWithImpl<$Res>
    implements _$NearbyResponseCopyWith<$Res> {
  __$NearbyResponseCopyWithImpl(this._self, this._then);

  final _NearbyResponse _self;
  final $Res Function(_NearbyResponse) _then;

/// Create a copy of NearbyResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,}) {
  return _then(_NearbyResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<StopSummary>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}

/// Create a copy of NearbyResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$Departure {

 String get stopId; RouteSummary get route; String get tripId; DateTime get serviceDate; DateTime get scheduledDeparture; String get basis; bool get timesApproximate; String? get headsign; int? get directionId; int? get wheelchairAccessible;
/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartureCopyWith<Departure> get copyWith => _$DepartureCopyWithImpl<Departure>(this as Departure, _$identity);

  /// Serializes this Departure to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Departure;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Departure&&(identical(other.stopId, _this.stopId) || other.stopId == _this.stopId)&&(identical(other.route, _this.route) || other.route == _this.route)&&(identical(other.tripId, _this.tripId) || other.tripId == _this.tripId)&&(identical(other.serviceDate, _this.serviceDate) || other.serviceDate == _this.serviceDate)&&(identical(other.scheduledDeparture, _this.scheduledDeparture) || other.scheduledDeparture == _this.scheduledDeparture)&&(identical(other.basis, _this.basis) || other.basis == _this.basis)&&(identical(other.timesApproximate, _this.timesApproximate) || other.timesApproximate == _this.timesApproximate)&&(identical(other.headsign, _this.headsign) || other.headsign == _this.headsign)&&(identical(other.directionId, _this.directionId) || other.directionId == _this.directionId)&&(identical(other.wheelchairAccessible, _this.wheelchairAccessible) || other.wheelchairAccessible == _this.wheelchairAccessible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Departure;
  return Object.hash(runtimeType,_this.stopId,_this.route,_this.tripId,_this.serviceDate,_this.scheduledDeparture,_this.basis,_this.timesApproximate,_this.headsign,_this.directionId,_this.wheelchairAccessible);
}

@override
String toString() {
  final _this = this as Departure;
  return 'Departure(stopId: ${_this.stopId}, route: ${_this.route}, tripId: ${_this.tripId}, serviceDate: ${_this.serviceDate}, scheduledDeparture: ${_this.scheduledDeparture}, basis: ${_this.basis}, timesApproximate: ${_this.timesApproximate}, headsign: ${_this.headsign}, directionId: ${_this.directionId}, wheelchairAccessible: ${_this.wheelchairAccessible})';
}


}

/// @nodoc
abstract mixin class $DepartureCopyWith<$Res>  {
  factory $DepartureCopyWith(Departure value, $Res Function(Departure) _then) = _$DepartureCopyWithImpl;
@useResult
$Res call({
 String stopId, RouteSummary route, String tripId, DateTime serviceDate, DateTime scheduledDeparture, String basis, bool timesApproximate, String? headsign, int? directionId, int? wheelchairAccessible
});


$RouteSummaryCopyWith<$Res> get route;

}
/// @nodoc
class _$DepartureCopyWithImpl<$Res>
    implements $DepartureCopyWith<$Res> {
  _$DepartureCopyWithImpl(this._self, this._then);

  final Departure _self;
  final $Res Function(Departure) _then;

/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stopId = null,Object? route = null,Object? tripId = null,Object? serviceDate = null,Object? scheduledDeparture = null,Object? basis = null,Object? timesApproximate = null,Object? headsign = freezed,Object? directionId = freezed,Object? wheelchairAccessible = freezed,}) {
  return _then(Departure(
stopId: null == stopId ? _self.stopId : stopId // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteSummary,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,serviceDate: null == serviceDate ? _self.serviceDate : serviceDate // ignore: cast_nullable_to_non_nullable
as DateTime,scheduledDeparture: null == scheduledDeparture ? _self.scheduledDeparture : scheduledDeparture // ignore: cast_nullable_to_non_nullable
as DateTime,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as String,timesApproximate: null == timesApproximate ? _self.timesApproximate : timesApproximate // ignore: cast_nullable_to_non_nullable
as bool,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,directionId: freezed == directionId ? _self.directionId : directionId // ignore: cast_nullable_to_non_nullable
as int?,wheelchairAccessible: freezed == wheelchairAccessible ? _self.wheelchairAccessible : wheelchairAccessible // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryCopyWith<$Res> get route {
  
  return $RouteSummaryCopyWith<$Res>(_self.route, (value) {
    return _then(_self.copyWith(route: value));
  });
}
}


/// Adds pattern-matching-related methods to [Departure].
extension DeparturePatterns on Departure {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Departure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Departure() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Departure value)  $default,){
final _that = this;
switch (_that) {
case _Departure():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Departure value)?  $default,){
final _that = this;
switch (_that) {
case _Departure() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stopId,  RouteSummary route,  String tripId,  DateTime serviceDate,  DateTime scheduledDeparture,  String basis,  bool timesApproximate,  String? headsign,  int? directionId,  int? wheelchairAccessible)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Departure() when $default != null:
return $default(_that.stopId,_that.route,_that.tripId,_that.serviceDate,_that.scheduledDeparture,_that.basis,_that.timesApproximate,_that.headsign,_that.directionId,_that.wheelchairAccessible);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stopId,  RouteSummary route,  String tripId,  DateTime serviceDate,  DateTime scheduledDeparture,  String basis,  bool timesApproximate,  String? headsign,  int? directionId,  int? wheelchairAccessible)  $default,) {final _that = this;
switch (_that) {
case _Departure():
return $default(_that.stopId,_that.route,_that.tripId,_that.serviceDate,_that.scheduledDeparture,_that.basis,_that.timesApproximate,_that.headsign,_that.directionId,_that.wheelchairAccessible);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stopId,  RouteSummary route,  String tripId,  DateTime serviceDate,  DateTime scheduledDeparture,  String basis,  bool timesApproximate,  String? headsign,  int? directionId,  int? wheelchairAccessible)?  $default,) {final _that = this;
switch (_that) {
case _Departure() when $default != null:
return $default(_that.stopId,_that.route,_that.tripId,_that.serviceDate,_that.scheduledDeparture,_that.basis,_that.timesApproximate,_that.headsign,_that.directionId,_that.wheelchairAccessible);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Departure implements Departure {
  const _Departure({required this.stopId, required this.route, required this.tripId, required this.serviceDate, required this.scheduledDeparture, required this.basis, required this.timesApproximate, this.headsign, this.directionId, this.wheelchairAccessible});
  factory _Departure.fromJson(Map<String, dynamic> json) => _$DepartureFromJson(json);

@override final  String stopId;
@override final  RouteSummary route;
@override final  String tripId;
@override final  DateTime serviceDate;
@override final  DateTime scheduledDeparture;
@override final  String basis;
@override final  bool timesApproximate;
@override final  String? headsign;
@override final  int? directionId;
@override final  int? wheelchairAccessible;

/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartureCopyWith<_Departure> get copyWith => __$DepartureCopyWithImpl<_Departure>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartureToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Departure&&(identical(other.stopId, stopId) || other.stopId == stopId)&&(identical(other.route, route) || other.route == route)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.serviceDate, serviceDate) || other.serviceDate == serviceDate)&&(identical(other.scheduledDeparture, scheduledDeparture) || other.scheduledDeparture == scheduledDeparture)&&(identical(other.basis, basis) || other.basis == basis)&&(identical(other.timesApproximate, timesApproximate) || other.timesApproximate == timesApproximate)&&(identical(other.headsign, headsign) || other.headsign == headsign)&&(identical(other.directionId, directionId) || other.directionId == directionId)&&(identical(other.wheelchairAccessible, wheelchairAccessible) || other.wheelchairAccessible == wheelchairAccessible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,stopId,route,tripId,serviceDate,scheduledDeparture,basis,timesApproximate,headsign,directionId,wheelchairAccessible);
}

@override
String toString() {
    return 'Departure(stopId: $stopId, route: $route, tripId: $tripId, serviceDate: $serviceDate, scheduledDeparture: $scheduledDeparture, basis: $basis, timesApproximate: $timesApproximate, headsign: $headsign, directionId: $directionId, wheelchairAccessible: $wheelchairAccessible)';
}


}

/// @nodoc
abstract mixin class _$DepartureCopyWith<$Res> implements $DepartureCopyWith<$Res> {
  factory _$DepartureCopyWith(_Departure value, $Res Function(_Departure) _then) = __$DepartureCopyWithImpl;
@override @useResult
$Res call({
 String stopId, RouteSummary route, String tripId, DateTime serviceDate, DateTime scheduledDeparture, String basis, bool timesApproximate, String? headsign, int? directionId, int? wheelchairAccessible
});


@override $RouteSummaryCopyWith<$Res> get route;

}
/// @nodoc
class __$DepartureCopyWithImpl<$Res>
    implements _$DepartureCopyWith<$Res> {
  __$DepartureCopyWithImpl(this._self, this._then);

  final _Departure _self;
  final $Res Function(_Departure) _then;

/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stopId = null,Object? route = null,Object? tripId = null,Object? serviceDate = null,Object? scheduledDeparture = null,Object? basis = null,Object? timesApproximate = null,Object? headsign = freezed,Object? directionId = freezed,Object? wheelchairAccessible = freezed,}) {
  return _then(_Departure(
stopId: null == stopId ? _self.stopId : stopId // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteSummary,tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,serviceDate: null == serviceDate ? _self.serviceDate : serviceDate // ignore: cast_nullable_to_non_nullable
as DateTime,scheduledDeparture: null == scheduledDeparture ? _self.scheduledDeparture : scheduledDeparture // ignore: cast_nullable_to_non_nullable
as DateTime,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as String,timesApproximate: null == timesApproximate ? _self.timesApproximate : timesApproximate // ignore: cast_nullable_to_non_nullable
as bool,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,directionId: freezed == directionId ? _self.directionId : directionId // ignore: cast_nullable_to_non_nullable
as int?,wheelchairAccessible: freezed == wheelchairAccessible ? _self.wheelchairAccessible : wheelchairAccessible // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Departure
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryCopyWith<$Res> get route {
  
  return $RouteSummaryCopyWith<$Res>(_self.route, (value) {
    return _then(_self.copyWith(route: value));
  });
}
}


/// @nodoc
mixin _$DeparturesResponse {

 String get stopId; DateTime get fromTime; List<Departure> get items; Meta get meta;
/// Create a copy of DeparturesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeparturesResponseCopyWith<DeparturesResponse> get copyWith => _$DeparturesResponseCopyWithImpl<DeparturesResponse>(this as DeparturesResponse, _$identity);

  /// Serializes this DeparturesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeparturesResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeparturesResponse&&(identical(other.stopId, _this.stopId) || other.stopId == _this.stopId)&&(identical(other.fromTime, _this.fromTime) || other.fromTime == _this.fromTime)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeparturesResponse;
  return Object.hash(runtimeType,_this.stopId,_this.fromTime,const DeepCollectionEquality().hash(_this.items),_this.meta);
}

@override
String toString() {
  final _this = this as DeparturesResponse;
  return 'DeparturesResponse(stopId: ${_this.stopId}, fromTime: ${_this.fromTime}, items: ${_this.items}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $DeparturesResponseCopyWith<$Res>  {
  factory $DeparturesResponseCopyWith(DeparturesResponse value, $Res Function(DeparturesResponse) _then) = _$DeparturesResponseCopyWithImpl;
@useResult
$Res call({
 String stopId, DateTime fromTime, List<Departure> items, Meta meta
});


$MetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$DeparturesResponseCopyWithImpl<$Res>
    implements $DeparturesResponseCopyWith<$Res> {
  _$DeparturesResponseCopyWithImpl(this._self, this._then);

  final DeparturesResponse _self;
  final $Res Function(DeparturesResponse) _then;

/// Create a copy of DeparturesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stopId = null,Object? fromTime = null,Object? items = null,Object? meta = null,}) {
  return _then(DeparturesResponse(
stopId: null == stopId ? _self.stopId : stopId // ignore: cast_nullable_to_non_nullable
as String,fromTime: null == fromTime ? _self.fromTime : fromTime // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Departure>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}
/// Create a copy of DeparturesResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeparturesResponse].
extension DeparturesResponsePatterns on DeparturesResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeparturesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeparturesResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeparturesResponse value)  $default,){
final _that = this;
switch (_that) {
case _DeparturesResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeparturesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DeparturesResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stopId,  DateTime fromTime,  List<Departure> items,  Meta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeparturesResponse() when $default != null:
return $default(_that.stopId,_that.fromTime,_that.items,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stopId,  DateTime fromTime,  List<Departure> items,  Meta meta)  $default,) {final _that = this;
switch (_that) {
case _DeparturesResponse():
return $default(_that.stopId,_that.fromTime,_that.items,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stopId,  DateTime fromTime,  List<Departure> items,  Meta meta)?  $default,) {final _that = this;
switch (_that) {
case _DeparturesResponse() when $default != null:
return $default(_that.stopId,_that.fromTime,_that.items,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeparturesResponse implements DeparturesResponse {
  const _DeparturesResponse({required this.stopId, required this.fromTime, required  List<Departure> items, required this.meta}): _items = items;
  factory _DeparturesResponse.fromJson(Map<String, dynamic> json) => _$DeparturesResponseFromJson(json);

@override final  String stopId;
@override final  DateTime fromTime;
 final  List<Departure> _items;
@override List<Departure> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Meta meta;

/// Create a copy of DeparturesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeparturesResponseCopyWith<_DeparturesResponse> get copyWith => __$DeparturesResponseCopyWithImpl<_DeparturesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeparturesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeparturesResponse&&(identical(other.stopId, stopId) || other.stopId == stopId)&&(identical(other.fromTime, fromTime) || other.fromTime == fromTime)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,stopId,fromTime,const DeepCollectionEquality().hash(_items),meta);
}

@override
String toString() {
    return 'DeparturesResponse(stopId: $stopId, fromTime: $fromTime, items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$DeparturesResponseCopyWith<$Res> implements $DeparturesResponseCopyWith<$Res> {
  factory _$DeparturesResponseCopyWith(_DeparturesResponse value, $Res Function(_DeparturesResponse) _then) = __$DeparturesResponseCopyWithImpl;
@override @useResult
$Res call({
 String stopId, DateTime fromTime, List<Departure> items, Meta meta
});


@override $MetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$DeparturesResponseCopyWithImpl<$Res>
    implements _$DeparturesResponseCopyWith<$Res> {
  __$DeparturesResponseCopyWithImpl(this._self, this._then);

  final _DeparturesResponse _self;
  final $Res Function(_DeparturesResponse) _then;

/// Create a copy of DeparturesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stopId = null,Object? fromTime = null,Object? items = null,Object? meta = null,}) {
  return _then(_DeparturesResponse(
stopId: null == stopId ? _self.stopId : stopId // ignore: cast_nullable_to_non_nullable
as String,fromTime: null == fromTime ? _self.fromTime : fromTime // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Departure>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}

/// Create a copy of DeparturesResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$ApproachingVehicle {

 String get lineNumber; String get lineName; int get remainingStops; String? get routeId; String? get color; int? get direction; double? get lat; double? get lon; String? get vehicleId; bool? get wheelchairAccessible; bool? get bikeRack;
/// Create a copy of ApproachingVehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApproachingVehicleCopyWith<ApproachingVehicle> get copyWith => _$ApproachingVehicleCopyWithImpl<ApproachingVehicle>(this as ApproachingVehicle, _$identity);

  /// Serializes this ApproachingVehicle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ApproachingVehicle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApproachingVehicle&&(identical(other.lineNumber, _this.lineNumber) || other.lineNumber == _this.lineNumber)&&(identical(other.lineName, _this.lineName) || other.lineName == _this.lineName)&&(identical(other.remainingStops, _this.remainingStops) || other.remainingStops == _this.remainingStops)&&(identical(other.routeId, _this.routeId) || other.routeId == _this.routeId)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.direction, _this.direction) || other.direction == _this.direction)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lon, _this.lon) || other.lon == _this.lon)&&(identical(other.vehicleId, _this.vehicleId) || other.vehicleId == _this.vehicleId)&&(identical(other.wheelchairAccessible, _this.wheelchairAccessible) || other.wheelchairAccessible == _this.wheelchairAccessible)&&(identical(other.bikeRack, _this.bikeRack) || other.bikeRack == _this.bikeRack));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ApproachingVehicle;
  return Object.hash(runtimeType,_this.lineNumber,_this.lineName,_this.remainingStops,_this.routeId,_this.color,_this.direction,_this.lat,_this.lon,_this.vehicleId,_this.wheelchairAccessible,_this.bikeRack);
}

@override
String toString() {
  final _this = this as ApproachingVehicle;
  return 'ApproachingVehicle(lineNumber: ${_this.lineNumber}, lineName: ${_this.lineName}, remainingStops: ${_this.remainingStops}, routeId: ${_this.routeId}, color: ${_this.color}, direction: ${_this.direction}, lat: ${_this.lat}, lon: ${_this.lon}, vehicleId: ${_this.vehicleId}, wheelchairAccessible: ${_this.wheelchairAccessible}, bikeRack: ${_this.bikeRack})';
}


}

/// @nodoc
abstract mixin class $ApproachingVehicleCopyWith<$Res>  {
  factory $ApproachingVehicleCopyWith(ApproachingVehicle value, $Res Function(ApproachingVehicle) _then) = _$ApproachingVehicleCopyWithImpl;
@useResult
$Res call({
 String lineNumber, String lineName, int remainingStops, String? routeId, String? color, int? direction, double? lat, double? lon, String? vehicleId, bool? wheelchairAccessible, bool? bikeRack
});




}
/// @nodoc
class _$ApproachingVehicleCopyWithImpl<$Res>
    implements $ApproachingVehicleCopyWith<$Res> {
  _$ApproachingVehicleCopyWithImpl(this._self, this._then);

  final ApproachingVehicle _self;
  final $Res Function(ApproachingVehicle) _then;

/// Create a copy of ApproachingVehicle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lineNumber = null,Object? lineName = null,Object? remainingStops = null,Object? routeId = freezed,Object? color = freezed,Object? direction = freezed,Object? lat = freezed,Object? lon = freezed,Object? vehicleId = freezed,Object? wheelchairAccessible = freezed,Object? bikeRack = freezed,}) {
  return _then(ApproachingVehicle(
lineNumber: null == lineNumber ? _self.lineNumber : lineNumber // ignore: cast_nullable_to_non_nullable
as String,lineName: null == lineName ? _self.lineName : lineName // ignore: cast_nullable_to_non_nullable
as String,remainingStops: null == remainingStops ? _self.remainingStops : remainingStops // ignore: cast_nullable_to_non_nullable
as int,routeId: freezed == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,direction: freezed == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as int?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,vehicleId: freezed == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String?,wheelchairAccessible: freezed == wheelchairAccessible ? _self.wheelchairAccessible : wheelchairAccessible // ignore: cast_nullable_to_non_nullable
as bool?,bikeRack: freezed == bikeRack ? _self.bikeRack : bikeRack // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApproachingVehicle].
extension ApproachingVehiclePatterns on ApproachingVehicle {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApproachingVehicle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApproachingVehicle() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApproachingVehicle value)  $default,){
final _that = this;
switch (_that) {
case _ApproachingVehicle():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApproachingVehicle value)?  $default,){
final _that = this;
switch (_that) {
case _ApproachingVehicle() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lineNumber,  String lineName,  int remainingStops,  String? routeId,  String? color,  int? direction,  double? lat,  double? lon,  String? vehicleId,  bool? wheelchairAccessible,  bool? bikeRack)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApproachingVehicle() when $default != null:
return $default(_that.lineNumber,_that.lineName,_that.remainingStops,_that.routeId,_that.color,_that.direction,_that.lat,_that.lon,_that.vehicleId,_that.wheelchairAccessible,_that.bikeRack);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lineNumber,  String lineName,  int remainingStops,  String? routeId,  String? color,  int? direction,  double? lat,  double? lon,  String? vehicleId,  bool? wheelchairAccessible,  bool? bikeRack)  $default,) {final _that = this;
switch (_that) {
case _ApproachingVehicle():
return $default(_that.lineNumber,_that.lineName,_that.remainingStops,_that.routeId,_that.color,_that.direction,_that.lat,_that.lon,_that.vehicleId,_that.wheelchairAccessible,_that.bikeRack);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lineNumber,  String lineName,  int remainingStops,  String? routeId,  String? color,  int? direction,  double? lat,  double? lon,  String? vehicleId,  bool? wheelchairAccessible,  bool? bikeRack)?  $default,) {final _that = this;
switch (_that) {
case _ApproachingVehicle() when $default != null:
return $default(_that.lineNumber,_that.lineName,_that.remainingStops,_that.routeId,_that.color,_that.direction,_that.lat,_that.lon,_that.vehicleId,_that.wheelchairAccessible,_that.bikeRack);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApproachingVehicle implements ApproachingVehicle {
  const _ApproachingVehicle({required this.lineNumber, required this.lineName, required this.remainingStops, this.routeId, this.color, this.direction, this.lat, this.lon, this.vehicleId, this.wheelchairAccessible, this.bikeRack});
  factory _ApproachingVehicle.fromJson(Map<String, dynamic> json) => _$ApproachingVehicleFromJson(json);

@override final  String lineNumber;
@override final  String lineName;
@override final  int remainingStops;
@override final  String? routeId;
@override final  String? color;
@override final  int? direction;
@override final  double? lat;
@override final  double? lon;
@override final  String? vehicleId;
@override final  bool? wheelchairAccessible;
@override final  bool? bikeRack;

/// Create a copy of ApproachingVehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApproachingVehicleCopyWith<_ApproachingVehicle> get copyWith => __$ApproachingVehicleCopyWithImpl<_ApproachingVehicle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApproachingVehicleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApproachingVehicle&&(identical(other.lineNumber, lineNumber) || other.lineNumber == lineNumber)&&(identical(other.lineName, lineName) || other.lineName == lineName)&&(identical(other.remainingStops, remainingStops) || other.remainingStops == remainingStops)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.color, color) || other.color == color)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.wheelchairAccessible, wheelchairAccessible) || other.wheelchairAccessible == wheelchairAccessible)&&(identical(other.bikeRack, bikeRack) || other.bikeRack == bikeRack));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,lineNumber,lineName,remainingStops,routeId,color,direction,lat,lon,vehicleId,wheelchairAccessible,bikeRack);
}

@override
String toString() {
    return 'ApproachingVehicle(lineNumber: $lineNumber, lineName: $lineName, remainingStops: $remainingStops, routeId: $routeId, color: $color, direction: $direction, lat: $lat, lon: $lon, vehicleId: $vehicleId, wheelchairAccessible: $wheelchairAccessible, bikeRack: $bikeRack)';
}


}

/// @nodoc
abstract mixin class _$ApproachingVehicleCopyWith<$Res> implements $ApproachingVehicleCopyWith<$Res> {
  factory _$ApproachingVehicleCopyWith(_ApproachingVehicle value, $Res Function(_ApproachingVehicle) _then) = __$ApproachingVehicleCopyWithImpl;
@override @useResult
$Res call({
 String lineNumber, String lineName, int remainingStops, String? routeId, String? color, int? direction, double? lat, double? lon, String? vehicleId, bool? wheelchairAccessible, bool? bikeRack
});




}
/// @nodoc
class __$ApproachingVehicleCopyWithImpl<$Res>
    implements _$ApproachingVehicleCopyWith<$Res> {
  __$ApproachingVehicleCopyWithImpl(this._self, this._then);

  final _ApproachingVehicle _self;
  final $Res Function(_ApproachingVehicle) _then;

/// Create a copy of ApproachingVehicle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lineNumber = null,Object? lineName = null,Object? remainingStops = null,Object? routeId = freezed,Object? color = freezed,Object? direction = freezed,Object? lat = freezed,Object? lon = freezed,Object? vehicleId = freezed,Object? wheelchairAccessible = freezed,Object? bikeRack = freezed,}) {
  return _then(_ApproachingVehicle(
lineNumber: null == lineNumber ? _self.lineNumber : lineNumber // ignore: cast_nullable_to_non_nullable
as String,lineName: null == lineName ? _self.lineName : lineName // ignore: cast_nullable_to_non_nullable
as String,remainingStops: null == remainingStops ? _self.remainingStops : remainingStops // ignore: cast_nullable_to_non_nullable
as int,routeId: freezed == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,direction: freezed == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as int?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,vehicleId: freezed == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String?,wheelchairAccessible: freezed == wheelchairAccessible ? _self.wheelchairAccessible : wheelchairAccessible // ignore: cast_nullable_to_non_nullable
as bool?,bikeRack: freezed == bikeRack ? _self.bikeRack : bikeRack // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$LiveResponse {

 String get stopId; bool get supported; String get basis; DateTime? get fetchedAt; String? get source; List<ApproachingVehicle> get items; Notice? get notice;
/// Create a copy of LiveResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveResponseCopyWith<LiveResponse> get copyWith => _$LiveResponseCopyWithImpl<LiveResponse>(this as LiveResponse, _$identity);

  /// Serializes this LiveResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LiveResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveResponse&&(identical(other.stopId, _this.stopId) || other.stopId == _this.stopId)&&(identical(other.supported, _this.supported) || other.supported == _this.supported)&&(identical(other.basis, _this.basis) || other.basis == _this.basis)&&(identical(other.fetchedAt, _this.fetchedAt) || other.fetchedAt == _this.fetchedAt)&&(identical(other.source, _this.source) || other.source == _this.source)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.notice, _this.notice) || other.notice == _this.notice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LiveResponse;
  return Object.hash(runtimeType,_this.stopId,_this.supported,_this.basis,_this.fetchedAt,_this.source,const DeepCollectionEquality().hash(_this.items),_this.notice);
}

@override
String toString() {
  final _this = this as LiveResponse;
  return 'LiveResponse(stopId: ${_this.stopId}, supported: ${_this.supported}, basis: ${_this.basis}, fetchedAt: ${_this.fetchedAt}, source: ${_this.source}, items: ${_this.items}, notice: ${_this.notice})';
}


}

/// @nodoc
abstract mixin class $LiveResponseCopyWith<$Res>  {
  factory $LiveResponseCopyWith(LiveResponse value, $Res Function(LiveResponse) _then) = _$LiveResponseCopyWithImpl;
@useResult
$Res call({
 String stopId, bool supported, String basis, DateTime? fetchedAt, String? source, List<ApproachingVehicle> items, Notice? notice
});


$NoticeCopyWith<$Res>? get notice;

}
/// @nodoc
class _$LiveResponseCopyWithImpl<$Res>
    implements $LiveResponseCopyWith<$Res> {
  _$LiveResponseCopyWithImpl(this._self, this._then);

  final LiveResponse _self;
  final $Res Function(LiveResponse) _then;

/// Create a copy of LiveResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stopId = null,Object? supported = null,Object? basis = null,Object? fetchedAt = freezed,Object? source = freezed,Object? items = null,Object? notice = freezed,}) {
  return _then(LiveResponse(
stopId: null == stopId ? _self.stopId : stopId // ignore: cast_nullable_to_non_nullable
as String,supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as String,fetchedAt: freezed == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ApproachingVehicle>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as Notice?,
  ));
}
/// Create a copy of LiveResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoticeCopyWith<$Res>? get notice {
    if (_self.notice == null) {
    return null;
  }

  return $NoticeCopyWith<$Res>(_self.notice!, (value) {
    return _then(_self.copyWith(notice: value));
  });
}
}


/// Adds pattern-matching-related methods to [LiveResponse].
extension LiveResponsePatterns on LiveResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveResponse value)  $default,){
final _that = this;
switch (_that) {
case _LiveResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LiveResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stopId,  bool supported,  String basis,  DateTime? fetchedAt,  String? source,  List<ApproachingVehicle> items,  Notice? notice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveResponse() when $default != null:
return $default(_that.stopId,_that.supported,_that.basis,_that.fetchedAt,_that.source,_that.items,_that.notice);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stopId,  bool supported,  String basis,  DateTime? fetchedAt,  String? source,  List<ApproachingVehicle> items,  Notice? notice)  $default,) {final _that = this;
switch (_that) {
case _LiveResponse():
return $default(_that.stopId,_that.supported,_that.basis,_that.fetchedAt,_that.source,_that.items,_that.notice);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stopId,  bool supported,  String basis,  DateTime? fetchedAt,  String? source,  List<ApproachingVehicle> items,  Notice? notice)?  $default,) {final _that = this;
switch (_that) {
case _LiveResponse() when $default != null:
return $default(_that.stopId,_that.supported,_that.basis,_that.fetchedAt,_that.source,_that.items,_that.notice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LiveResponse implements LiveResponse {
  const _LiveResponse({required this.stopId, required this.supported, required this.basis, this.fetchedAt, this.source,  List<ApproachingVehicle> items = const <ApproachingVehicle>[], this.notice}): _items = items;
  factory _LiveResponse.fromJson(Map<String, dynamic> json) => _$LiveResponseFromJson(json);

@override final  String stopId;
@override final  bool supported;
@override final  String basis;
@override final  DateTime? fetchedAt;
@override final  String? source;
 final  List<ApproachingVehicle> _items;
@override@JsonKey() List<ApproachingVehicle> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Notice? notice;

/// Create a copy of LiveResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveResponseCopyWith<_LiveResponse> get copyWith => __$LiveResponseCopyWithImpl<_LiveResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LiveResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveResponse&&(identical(other.stopId, stopId) || other.stopId == stopId)&&(identical(other.supported, supported) || other.supported == supported)&&(identical(other.basis, basis) || other.basis == basis)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.notice, notice) || other.notice == notice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,stopId,supported,basis,fetchedAt,source,const DeepCollectionEquality().hash(_items),notice);
}

@override
String toString() {
    return 'LiveResponse(stopId: $stopId, supported: $supported, basis: $basis, fetchedAt: $fetchedAt, source: $source, items: $items, notice: $notice)';
}


}

/// @nodoc
abstract mixin class _$LiveResponseCopyWith<$Res> implements $LiveResponseCopyWith<$Res> {
  factory _$LiveResponseCopyWith(_LiveResponse value, $Res Function(_LiveResponse) _then) = __$LiveResponseCopyWithImpl;
@override @useResult
$Res call({
 String stopId, bool supported, String basis, DateTime? fetchedAt, String? source, List<ApproachingVehicle> items, Notice? notice
});


@override $NoticeCopyWith<$Res>? get notice;

}
/// @nodoc
class __$LiveResponseCopyWithImpl<$Res>
    implements _$LiveResponseCopyWith<$Res> {
  __$LiveResponseCopyWithImpl(this._self, this._then);

  final _LiveResponse _self;
  final $Res Function(_LiveResponse) _then;

/// Create a copy of LiveResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stopId = null,Object? supported = null,Object? basis = null,Object? fetchedAt = freezed,Object? source = freezed,Object? items = null,Object? notice = freezed,}) {
  return _then(_LiveResponse(
stopId: null == stopId ? _self.stopId : stopId // ignore: cast_nullable_to_non_nullable
as String,supported: null == supported ? _self.supported : supported // ignore: cast_nullable_to_non_nullable
as bool,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as String,fetchedAt: freezed == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ApproachingVehicle>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as Notice?,
  ));
}

/// Create a copy of LiveResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoticeCopyWith<$Res>? get notice {
    if (_self.notice == null) {
    return null;
  }

  return $NoticeCopyWith<$Res>(_self.notice!, (value) {
    return _then(_self.copyWith(notice: value));
  });
}
}


/// @nodoc
mixin _$Pattern {

 int get tripCount; List<StopSummary> get stops; String get geometryBasis; int? get directionId; String? get headsign; List<List<double>>? get geometry;
/// Create a copy of Pattern
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatternCopyWith<Pattern> get copyWith => _$PatternCopyWithImpl<Pattern>(this as Pattern, _$identity);

  /// Serializes this Pattern to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Pattern;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pattern&&(identical(other.tripCount, _this.tripCount) || other.tripCount == _this.tripCount)&&const DeepCollectionEquality().equals(other.stops, _this.stops)&&(identical(other.geometryBasis, _this.geometryBasis) || other.geometryBasis == _this.geometryBasis)&&(identical(other.directionId, _this.directionId) || other.directionId == _this.directionId)&&(identical(other.headsign, _this.headsign) || other.headsign == _this.headsign)&&const DeepCollectionEquality().equals(other.geometry, _this.geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Pattern;
  return Object.hash(runtimeType,_this.tripCount,const DeepCollectionEquality().hash(_this.stops),_this.geometryBasis,_this.directionId,_this.headsign,const DeepCollectionEquality().hash(_this.geometry));
}

@override
String toString() {
  final _this = this as Pattern;
  return 'Pattern(tripCount: ${_this.tripCount}, stops: ${_this.stops}, geometryBasis: ${_this.geometryBasis}, directionId: ${_this.directionId}, headsign: ${_this.headsign}, geometry: ${_this.geometry})';
}


}

/// @nodoc
abstract mixin class $PatternCopyWith<$Res>  {
  factory $PatternCopyWith(Pattern value, $Res Function(Pattern) _then) = _$PatternCopyWithImpl;
@useResult
$Res call({
 int tripCount, List<StopSummary> stops, String geometryBasis, int? directionId, String? headsign, List<List<double>>? geometry
});




}
/// @nodoc
class _$PatternCopyWithImpl<$Res>
    implements $PatternCopyWith<$Res> {
  _$PatternCopyWithImpl(this._self, this._then);

  final Pattern _self;
  final $Res Function(Pattern) _then;

/// Create a copy of Pattern
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tripCount = null,Object? stops = null,Object? geometryBasis = null,Object? directionId = freezed,Object? headsign = freezed,Object? geometry = freezed,}) {
  return _then(Pattern(
tripCount: null == tripCount ? _self.tripCount : tripCount // ignore: cast_nullable_to_non_nullable
as int,stops: null == stops ? _self.stops : stops // ignore: cast_nullable_to_non_nullable
as List<StopSummary>,geometryBasis: null == geometryBasis ? _self.geometryBasis : geometryBasis // ignore: cast_nullable_to_non_nullable
as String,directionId: freezed == directionId ? _self.directionId : directionId // ignore: cast_nullable_to_non_nullable
as int?,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,geometry: freezed == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as List<List<double>>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Pattern].
extension PatternPatterns on Pattern {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pattern value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pattern() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pattern value)  $default,){
final _that = this;
switch (_that) {
case _Pattern():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pattern value)?  $default,){
final _that = this;
switch (_that) {
case _Pattern() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tripCount,  List<StopSummary> stops,  String geometryBasis,  int? directionId,  String? headsign,  List<List<double>>? geometry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pattern() when $default != null:
return $default(_that.tripCount,_that.stops,_that.geometryBasis,_that.directionId,_that.headsign,_that.geometry);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tripCount,  List<StopSummary> stops,  String geometryBasis,  int? directionId,  String? headsign,  List<List<double>>? geometry)  $default,) {final _that = this;
switch (_that) {
case _Pattern():
return $default(_that.tripCount,_that.stops,_that.geometryBasis,_that.directionId,_that.headsign,_that.geometry);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tripCount,  List<StopSummary> stops,  String geometryBasis,  int? directionId,  String? headsign,  List<List<double>>? geometry)?  $default,) {final _that = this;
switch (_that) {
case _Pattern() when $default != null:
return $default(_that.tripCount,_that.stops,_that.geometryBasis,_that.directionId,_that.headsign,_that.geometry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pattern implements Pattern {
  const _Pattern({required this.tripCount, required  List<StopSummary> stops, required this.geometryBasis, this.directionId, this.headsign,  List<List<double>>? geometry}): _stops = stops,_geometry = geometry;
  factory _Pattern.fromJson(Map<String, dynamic> json) => _$PatternFromJson(json);

@override final  int tripCount;
 final  List<StopSummary> _stops;
@override List<StopSummary> get stops {
  if (_stops is EqualUnmodifiableListView) return _stops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stops);
}

@override final  String geometryBasis;
@override final  int? directionId;
@override final  String? headsign;
 final  List<List<double>>? _geometry;
@override List<List<double>>? get geometry {
  final value = _geometry;
  if (value == null) return null;
  if (_geometry is EqualUnmodifiableListView) return _geometry;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Pattern
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatternCopyWith<_Pattern> get copyWith => __$PatternCopyWithImpl<_Pattern>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatternToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pattern&&(identical(other.tripCount, tripCount) || other.tripCount == tripCount)&&const DeepCollectionEquality().equals(other.stops, _stops)&&(identical(other.geometryBasis, geometryBasis) || other.geometryBasis == geometryBasis)&&(identical(other.directionId, directionId) || other.directionId == directionId)&&(identical(other.headsign, headsign) || other.headsign == headsign)&&const DeepCollectionEquality().equals(other.geometry, _geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tripCount,const DeepCollectionEquality().hash(_stops),geometryBasis,directionId,headsign,const DeepCollectionEquality().hash(_geometry));
}

@override
String toString() {
    return 'Pattern(tripCount: $tripCount, stops: $stops, geometryBasis: $geometryBasis, directionId: $directionId, headsign: $headsign, geometry: $geometry)';
}


}

/// @nodoc
abstract mixin class _$PatternCopyWith<$Res> implements $PatternCopyWith<$Res> {
  factory _$PatternCopyWith(_Pattern value, $Res Function(_Pattern) _then) = __$PatternCopyWithImpl;
@override @useResult
$Res call({
 int tripCount, List<StopSummary> stops, String geometryBasis, int? directionId, String? headsign, List<List<double>>? geometry
});




}
/// @nodoc
class __$PatternCopyWithImpl<$Res>
    implements _$PatternCopyWith<$Res> {
  __$PatternCopyWithImpl(this._self, this._then);

  final _Pattern _self;
  final $Res Function(_Pattern) _then;

/// Create a copy of Pattern
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tripCount = null,Object? stops = null,Object? geometryBasis = null,Object? directionId = freezed,Object? headsign = freezed,Object? geometry = freezed,}) {
  return _then(_Pattern(
tripCount: null == tripCount ? _self.tripCount : tripCount // ignore: cast_nullable_to_non_nullable
as int,stops: null == stops ? _self._stops : stops // ignore: cast_nullable_to_non_nullable
as List<StopSummary>,geometryBasis: null == geometryBasis ? _self.geometryBasis : geometryBasis // ignore: cast_nullable_to_non_nullable
as String,directionId: freezed == directionId ? _self.directionId : directionId // ignore: cast_nullable_to_non_nullable
as int?,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,geometry: freezed == geometry ? _self._geometry : geometry // ignore: cast_nullable_to_non_nullable
as List<List<double>>?,
  ));
}


}


/// @nodoc
mixin _$RouteDetail {

 String get id; String get lineKey; TransitMode get mode; String get source; bool get timesApproximate; List<Pattern> get patterns; String? get shortName; String? get longName; String? get color; String? get textColor; String? get agencyName;
/// Create a copy of RouteDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteDetailCopyWith<RouteDetail> get copyWith => _$RouteDetailCopyWithImpl<RouteDetail>(this as RouteDetail, _$identity);

  /// Serializes this RouteDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.lineKey, _this.lineKey) || other.lineKey == _this.lineKey)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.timesApproximate, _this.timesApproximate) || other.timesApproximate == _this.timesApproximate)&&const DeepCollectionEquality().equals(other.patterns, _this.patterns)&&(identical(other.shortName, _this.shortName) || other.shortName == _this.shortName)&&(identical(other.longName, _this.longName) || other.longName == _this.longName)&&(identical(other.color, _this.color) || other.color == _this.color)&&(identical(other.textColor, _this.textColor) || other.textColor == _this.textColor)&&(identical(other.agencyName, _this.agencyName) || other.agencyName == _this.agencyName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteDetail;
  return Object.hash(runtimeType,_this.id,_this.lineKey,_this.mode,_this.source,_this.timesApproximate,const DeepCollectionEquality().hash(_this.patterns),_this.shortName,_this.longName,_this.color,_this.textColor,_this.agencyName);
}

@override
String toString() {
  final _this = this as RouteDetail;
  return 'RouteDetail(id: ${_this.id}, lineKey: ${_this.lineKey}, mode: ${_this.mode}, source: ${_this.source}, timesApproximate: ${_this.timesApproximate}, patterns: ${_this.patterns}, shortName: ${_this.shortName}, longName: ${_this.longName}, color: ${_this.color}, textColor: ${_this.textColor}, agencyName: ${_this.agencyName})';
}


}

/// @nodoc
abstract mixin class $RouteDetailCopyWith<$Res>  {
  factory $RouteDetailCopyWith(RouteDetail value, $Res Function(RouteDetail) _then) = _$RouteDetailCopyWithImpl;
@useResult
$Res call({
 String id, String lineKey, TransitMode mode, String source, bool timesApproximate, List<Pattern> patterns, String? shortName, String? longName, String? color, String? textColor, String? agencyName
});




}
/// @nodoc
class _$RouteDetailCopyWithImpl<$Res>
    implements $RouteDetailCopyWith<$Res> {
  _$RouteDetailCopyWithImpl(this._self, this._then);

  final RouteDetail _self;
  final $Res Function(RouteDetail) _then;

/// Create a copy of RouteDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lineKey = null,Object? mode = null,Object? source = null,Object? timesApproximate = null,Object? patterns = null,Object? shortName = freezed,Object? longName = freezed,Object? color = freezed,Object? textColor = freezed,Object? agencyName = freezed,}) {
  return _then(RouteDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lineKey: null == lineKey ? _self.lineKey : lineKey // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransitMode,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,timesApproximate: null == timesApproximate ? _self.timesApproximate : timesApproximate // ignore: cast_nullable_to_non_nullable
as bool,patterns: null == patterns ? _self.patterns : patterns // ignore: cast_nullable_to_non_nullable
as List<Pattern>,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String?,longName: freezed == longName ? _self.longName : longName // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as String?,agencyName: freezed == agencyName ? _self.agencyName : agencyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteDetail].
extension RouteDetailPatterns on RouteDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteDetail value)  $default,){
final _that = this;
switch (_that) {
case _RouteDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteDetail value)?  $default,){
final _that = this;
switch (_that) {
case _RouteDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String lineKey,  TransitMode mode,  String source,  bool timesApproximate,  List<Pattern> patterns,  String? shortName,  String? longName,  String? color,  String? textColor,  String? agencyName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteDetail() when $default != null:
return $default(_that.id,_that.lineKey,_that.mode,_that.source,_that.timesApproximate,_that.patterns,_that.shortName,_that.longName,_that.color,_that.textColor,_that.agencyName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String lineKey,  TransitMode mode,  String source,  bool timesApproximate,  List<Pattern> patterns,  String? shortName,  String? longName,  String? color,  String? textColor,  String? agencyName)  $default,) {final _that = this;
switch (_that) {
case _RouteDetail():
return $default(_that.id,_that.lineKey,_that.mode,_that.source,_that.timesApproximate,_that.patterns,_that.shortName,_that.longName,_that.color,_that.textColor,_that.agencyName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String lineKey,  TransitMode mode,  String source,  bool timesApproximate,  List<Pattern> patterns,  String? shortName,  String? longName,  String? color,  String? textColor,  String? agencyName)?  $default,) {final _that = this;
switch (_that) {
case _RouteDetail() when $default != null:
return $default(_that.id,_that.lineKey,_that.mode,_that.source,_that.timesApproximate,_that.patterns,_that.shortName,_that.longName,_that.color,_that.textColor,_that.agencyName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteDetail implements RouteDetail {
  const _RouteDetail({required this.id, required this.lineKey, required this.mode, required this.source, required this.timesApproximate, required  List<Pattern> patterns, this.shortName, this.longName, this.color, this.textColor, this.agencyName}): _patterns = patterns;
  factory _RouteDetail.fromJson(Map<String, dynamic> json) => _$RouteDetailFromJson(json);

@override final  String id;
@override final  String lineKey;
@override final  TransitMode mode;
@override final  String source;
@override final  bool timesApproximate;
 final  List<Pattern> _patterns;
@override List<Pattern> get patterns {
  if (_patterns is EqualUnmodifiableListView) return _patterns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_patterns);
}

@override final  String? shortName;
@override final  String? longName;
@override final  String? color;
@override final  String? textColor;
@override final  String? agencyName;

/// Create a copy of RouteDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteDetailCopyWith<_RouteDetail> get copyWith => __$RouteDetailCopyWithImpl<_RouteDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.lineKey, lineKey) || other.lineKey == lineKey)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.source, source) || other.source == source)&&(identical(other.timesApproximate, timesApproximate) || other.timesApproximate == timesApproximate)&&const DeepCollectionEquality().equals(other.patterns, _patterns)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.longName, longName) || other.longName == longName)&&(identical(other.color, color) || other.color == color)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.agencyName, agencyName) || other.agencyName == agencyName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,lineKey,mode,source,timesApproximate,const DeepCollectionEquality().hash(_patterns),shortName,longName,color,textColor,agencyName);
}

@override
String toString() {
    return 'RouteDetail(id: $id, lineKey: $lineKey, mode: $mode, source: $source, timesApproximate: $timesApproximate, patterns: $patterns, shortName: $shortName, longName: $longName, color: $color, textColor: $textColor, agencyName: $agencyName)';
}


}

/// @nodoc
abstract mixin class _$RouteDetailCopyWith<$Res> implements $RouteDetailCopyWith<$Res> {
  factory _$RouteDetailCopyWith(_RouteDetail value, $Res Function(_RouteDetail) _then) = __$RouteDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String lineKey, TransitMode mode, String source, bool timesApproximate, List<Pattern> patterns, String? shortName, String? longName, String? color, String? textColor, String? agencyName
});




}
/// @nodoc
class __$RouteDetailCopyWithImpl<$Res>
    implements _$RouteDetailCopyWith<$Res> {
  __$RouteDetailCopyWithImpl(this._self, this._then);

  final _RouteDetail _self;
  final $Res Function(_RouteDetail) _then;

/// Create a copy of RouteDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lineKey = null,Object? mode = null,Object? source = null,Object? timesApproximate = null,Object? patterns = null,Object? shortName = freezed,Object? longName = freezed,Object? color = freezed,Object? textColor = freezed,Object? agencyName = freezed,}) {
  return _then(_RouteDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lineKey: null == lineKey ? _self.lineKey : lineKey // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransitMode,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,timesApproximate: null == timesApproximate ? _self.timesApproximate : timesApproximate // ignore: cast_nullable_to_non_nullable
as bool,patterns: null == patterns ? _self._patterns : patterns // ignore: cast_nullable_to_non_nullable
as List<Pattern>,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String?,longName: freezed == longName ? _self.longName : longName // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as String?,agencyName: freezed == agencyName ? _self.agencyName : agencyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RouteResponse {

 RouteDetail get route; Meta get meta;
/// Create a copy of RouteResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteResponseCopyWith<RouteResponse> get copyWith => _$RouteResponseCopyWithImpl<RouteResponse>(this as RouteResponse, _$identity);

  /// Serializes this RouteResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteResponse&&(identical(other.route, _this.route) || other.route == _this.route)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteResponse;
  return Object.hash(runtimeType,_this.route,_this.meta);
}

@override
String toString() {
  final _this = this as RouteResponse;
  return 'RouteResponse(route: ${_this.route}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $RouteResponseCopyWith<$Res>  {
  factory $RouteResponseCopyWith(RouteResponse value, $Res Function(RouteResponse) _then) = _$RouteResponseCopyWithImpl;
@useResult
$Res call({
 RouteDetail route, Meta meta
});


$RouteDetailCopyWith<$Res> get route;$MetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$RouteResponseCopyWithImpl<$Res>
    implements $RouteResponseCopyWith<$Res> {
  _$RouteResponseCopyWithImpl(this._self, this._then);

  final RouteResponse _self;
  final $Res Function(RouteResponse) _then;

/// Create a copy of RouteResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? route = null,Object? meta = null,}) {
  return _then(RouteResponse(
route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteDetail,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}
/// Create a copy of RouteResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteDetailCopyWith<$Res> get route {
  
  return $RouteDetailCopyWith<$Res>(_self.route, (value) {
    return _then(_self.copyWith(route: value));
  });
}/// Create a copy of RouteResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteResponse].
extension RouteResponsePatterns on RouteResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteResponse value)  $default,){
final _that = this;
switch (_that) {
case _RouteResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RouteResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RouteDetail route,  Meta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteResponse() when $default != null:
return $default(_that.route,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RouteDetail route,  Meta meta)  $default,) {final _that = this;
switch (_that) {
case _RouteResponse():
return $default(_that.route,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RouteDetail route,  Meta meta)?  $default,) {final _that = this;
switch (_that) {
case _RouteResponse() when $default != null:
return $default(_that.route,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteResponse implements RouteResponse {
  const _RouteResponse({required this.route, required this.meta});
  factory _RouteResponse.fromJson(Map<String, dynamic> json) => _$RouteResponseFromJson(json);

@override final  RouteDetail route;
@override final  Meta meta;

/// Create a copy of RouteResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteResponseCopyWith<_RouteResponse> get copyWith => __$RouteResponseCopyWithImpl<_RouteResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteResponse&&(identical(other.route, route) || other.route == route)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,route,meta);
}

@override
String toString() {
    return 'RouteResponse(route: $route, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$RouteResponseCopyWith<$Res> implements $RouteResponseCopyWith<$Res> {
  factory _$RouteResponseCopyWith(_RouteResponse value, $Res Function(_RouteResponse) _then) = __$RouteResponseCopyWithImpl;
@override @useResult
$Res call({
 RouteDetail route, Meta meta
});


@override $RouteDetailCopyWith<$Res> get route;@override $MetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$RouteResponseCopyWithImpl<$Res>
    implements _$RouteResponseCopyWith<$Res> {
  __$RouteResponseCopyWithImpl(this._self, this._then);

  final _RouteResponse _self;
  final $Res Function(_RouteResponse) _then;

/// Create a copy of RouteResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? route = null,Object? meta = null,}) {
  return _then(_RouteResponse(
route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteDetail,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}

/// Create a copy of RouteResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteDetailCopyWith<$Res> get route {
  
  return $RouteDetailCopyWith<$Res>(_self.route, (value) {
    return _then(_self.copyWith(route: value));
  });
}/// Create a copy of RouteResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$RouteList {

 List<RouteSummary> get items; Meta get meta;
/// Create a copy of RouteList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteListCopyWith<RouteList> get copyWith => _$RouteListCopyWithImpl<RouteList>(this as RouteList, _$identity);

  /// Serializes this RouteList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RouteList;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteList&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RouteList;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.meta);
}

@override
String toString() {
  final _this = this as RouteList;
  return 'RouteList(items: ${_this.items}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $RouteListCopyWith<$Res>  {
  factory $RouteListCopyWith(RouteList value, $Res Function(RouteList) _then) = _$RouteListCopyWithImpl;
@useResult
$Res call({
 List<RouteSummary> items, Meta meta
});


$MetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$RouteListCopyWithImpl<$Res>
    implements $RouteListCopyWith<$Res> {
  _$RouteListCopyWithImpl(this._self, this._then);

  final RouteList _self;
  final $Res Function(RouteList) _then;

/// Create a copy of RouteList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? meta = null,}) {
  return _then(RouteList(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<RouteSummary>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}
/// Create a copy of RouteList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [RouteList].
extension RouteListPatterns on RouteList {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteList() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteList value)  $default,){
final _that = this;
switch (_that) {
case _RouteList():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteList value)?  $default,){
final _that = this;
switch (_that) {
case _RouteList() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RouteSummary> items,  Meta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteList() when $default != null:
return $default(_that.items,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RouteSummary> items,  Meta meta)  $default,) {final _that = this;
switch (_that) {
case _RouteList():
return $default(_that.items,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RouteSummary> items,  Meta meta)?  $default,) {final _that = this;
switch (_that) {
case _RouteList() when $default != null:
return $default(_that.items,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteList implements RouteList {
  const _RouteList({required  List<RouteSummary> items, required this.meta}): _items = items;
  factory _RouteList.fromJson(Map<String, dynamic> json) => _$RouteListFromJson(json);

 final  List<RouteSummary> _items;
@override List<RouteSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Meta meta;

/// Create a copy of RouteList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteListCopyWith<_RouteList> get copyWith => __$RouteListCopyWithImpl<_RouteList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteListToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteList&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta);
}

@override
String toString() {
    return 'RouteList(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$RouteListCopyWith<$Res> implements $RouteListCopyWith<$Res> {
  factory _$RouteListCopyWith(_RouteList value, $Res Function(_RouteList) _then) = __$RouteListCopyWithImpl;
@override @useResult
$Res call({
 List<RouteSummary> items, Meta meta
});


@override $MetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$RouteListCopyWithImpl<$Res>
    implements _$RouteListCopyWith<$Res> {
  __$RouteListCopyWithImpl(this._self, this._then);

  final _RouteList _self;
  final $Res Function(_RouteList) _then;

/// Create a copy of RouteList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,}) {
  return _then(_RouteList(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<RouteSummary>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}

/// Create a copy of RouteList
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$ScheduledTrip {

 String get tripId; DateTime get firstDeparture; DateTime get lastArrival; int? get directionId; String? get headsign;
/// Create a copy of ScheduledTrip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduledTripCopyWith<ScheduledTrip> get copyWith => _$ScheduledTripCopyWithImpl<ScheduledTrip>(this as ScheduledTrip, _$identity);

  /// Serializes this ScheduledTrip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduledTrip;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduledTrip&&(identical(other.tripId, _this.tripId) || other.tripId == _this.tripId)&&(identical(other.firstDeparture, _this.firstDeparture) || other.firstDeparture == _this.firstDeparture)&&(identical(other.lastArrival, _this.lastArrival) || other.lastArrival == _this.lastArrival)&&(identical(other.directionId, _this.directionId) || other.directionId == _this.directionId)&&(identical(other.headsign, _this.headsign) || other.headsign == _this.headsign));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduledTrip;
  return Object.hash(runtimeType,_this.tripId,_this.firstDeparture,_this.lastArrival,_this.directionId,_this.headsign);
}

@override
String toString() {
  final _this = this as ScheduledTrip;
  return 'ScheduledTrip(tripId: ${_this.tripId}, firstDeparture: ${_this.firstDeparture}, lastArrival: ${_this.lastArrival}, directionId: ${_this.directionId}, headsign: ${_this.headsign})';
}


}

/// @nodoc
abstract mixin class $ScheduledTripCopyWith<$Res>  {
  factory $ScheduledTripCopyWith(ScheduledTrip value, $Res Function(ScheduledTrip) _then) = _$ScheduledTripCopyWithImpl;
@useResult
$Res call({
 String tripId, DateTime firstDeparture, DateTime lastArrival, int? directionId, String? headsign
});




}
/// @nodoc
class _$ScheduledTripCopyWithImpl<$Res>
    implements $ScheduledTripCopyWith<$Res> {
  _$ScheduledTripCopyWithImpl(this._self, this._then);

  final ScheduledTrip _self;
  final $Res Function(ScheduledTrip) _then;

/// Create a copy of ScheduledTrip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tripId = null,Object? firstDeparture = null,Object? lastArrival = null,Object? directionId = freezed,Object? headsign = freezed,}) {
  return _then(ScheduledTrip(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,firstDeparture: null == firstDeparture ? _self.firstDeparture : firstDeparture // ignore: cast_nullable_to_non_nullable
as DateTime,lastArrival: null == lastArrival ? _self.lastArrival : lastArrival // ignore: cast_nullable_to_non_nullable
as DateTime,directionId: freezed == directionId ? _self.directionId : directionId // ignore: cast_nullable_to_non_nullable
as int?,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduledTrip].
extension ScheduledTripPatterns on ScheduledTrip {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduledTrip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduledTrip() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduledTrip value)  $default,){
final _that = this;
switch (_that) {
case _ScheduledTrip():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduledTrip value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduledTrip() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tripId,  DateTime firstDeparture,  DateTime lastArrival,  int? directionId,  String? headsign)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduledTrip() when $default != null:
return $default(_that.tripId,_that.firstDeparture,_that.lastArrival,_that.directionId,_that.headsign);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tripId,  DateTime firstDeparture,  DateTime lastArrival,  int? directionId,  String? headsign)  $default,) {final _that = this;
switch (_that) {
case _ScheduledTrip():
return $default(_that.tripId,_that.firstDeparture,_that.lastArrival,_that.directionId,_that.headsign);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tripId,  DateTime firstDeparture,  DateTime lastArrival,  int? directionId,  String? headsign)?  $default,) {final _that = this;
switch (_that) {
case _ScheduledTrip() when $default != null:
return $default(_that.tripId,_that.firstDeparture,_that.lastArrival,_that.directionId,_that.headsign);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduledTrip implements ScheduledTrip {
  const _ScheduledTrip({required this.tripId, required this.firstDeparture, required this.lastArrival, this.directionId, this.headsign});
  factory _ScheduledTrip.fromJson(Map<String, dynamic> json) => _$ScheduledTripFromJson(json);

@override final  String tripId;
@override final  DateTime firstDeparture;
@override final  DateTime lastArrival;
@override final  int? directionId;
@override final  String? headsign;

/// Create a copy of ScheduledTrip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduledTripCopyWith<_ScheduledTrip> get copyWith => __$ScheduledTripCopyWithImpl<_ScheduledTrip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduledTripToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduledTrip&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.firstDeparture, firstDeparture) || other.firstDeparture == firstDeparture)&&(identical(other.lastArrival, lastArrival) || other.lastArrival == lastArrival)&&(identical(other.directionId, directionId) || other.directionId == directionId)&&(identical(other.headsign, headsign) || other.headsign == headsign));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tripId,firstDeparture,lastArrival,directionId,headsign);
}

@override
String toString() {
    return 'ScheduledTrip(tripId: $tripId, firstDeparture: $firstDeparture, lastArrival: $lastArrival, directionId: $directionId, headsign: $headsign)';
}


}

/// @nodoc
abstract mixin class _$ScheduledTripCopyWith<$Res> implements $ScheduledTripCopyWith<$Res> {
  factory _$ScheduledTripCopyWith(_ScheduledTrip value, $Res Function(_ScheduledTrip) _then) = __$ScheduledTripCopyWithImpl;
@override @useResult
$Res call({
 String tripId, DateTime firstDeparture, DateTime lastArrival, int? directionId, String? headsign
});




}
/// @nodoc
class __$ScheduledTripCopyWithImpl<$Res>
    implements _$ScheduledTripCopyWith<$Res> {
  __$ScheduledTripCopyWithImpl(this._self, this._then);

  final _ScheduledTrip _self;
  final $Res Function(_ScheduledTrip) _then;

/// Create a copy of ScheduledTrip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tripId = null,Object? firstDeparture = null,Object? lastArrival = null,Object? directionId = freezed,Object? headsign = freezed,}) {
  return _then(_ScheduledTrip(
tripId: null == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String,firstDeparture: null == firstDeparture ? _self.firstDeparture : firstDeparture // ignore: cast_nullable_to_non_nullable
as DateTime,lastArrival: null == lastArrival ? _self.lastArrival : lastArrival // ignore: cast_nullable_to_non_nullable
as DateTime,directionId: freezed == directionId ? _self.directionId : directionId // ignore: cast_nullable_to_non_nullable
as int?,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ScheduleResponse {

 String get routeId; DateTime get serviceDate; List<ScheduledTrip> get items; Meta get meta;
/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleResponseCopyWith<ScheduleResponse> get copyWith => _$ScheduleResponseCopyWithImpl<ScheduleResponse>(this as ScheduleResponse, _$identity);

  /// Serializes this ScheduleResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleResponse&&(identical(other.routeId, _this.routeId) || other.routeId == _this.routeId)&&(identical(other.serviceDate, _this.serviceDate) || other.serviceDate == _this.serviceDate)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.meta, _this.meta) || other.meta == _this.meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleResponse;
  return Object.hash(runtimeType,_this.routeId,_this.serviceDate,const DeepCollectionEquality().hash(_this.items),_this.meta);
}

@override
String toString() {
  final _this = this as ScheduleResponse;
  return 'ScheduleResponse(routeId: ${_this.routeId}, serviceDate: ${_this.serviceDate}, items: ${_this.items}, meta: ${_this.meta})';
}


}

/// @nodoc
abstract mixin class $ScheduleResponseCopyWith<$Res>  {
  factory $ScheduleResponseCopyWith(ScheduleResponse value, $Res Function(ScheduleResponse) _then) = _$ScheduleResponseCopyWithImpl;
@useResult
$Res call({
 String routeId, DateTime serviceDate, List<ScheduledTrip> items, Meta meta
});


$MetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$ScheduleResponseCopyWithImpl<$Res>
    implements $ScheduleResponseCopyWith<$Res> {
  _$ScheduleResponseCopyWithImpl(this._self, this._then);

  final ScheduleResponse _self;
  final $Res Function(ScheduleResponse) _then;

/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? routeId = null,Object? serviceDate = null,Object? items = null,Object? meta = null,}) {
  return _then(ScheduleResponse(
routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,serviceDate: null == serviceDate ? _self.serviceDate : serviceDate // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ScheduledTrip>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}
/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleResponse].
extension ScheduleResponsePatterns on ScheduleResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleResponse value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String routeId,  DateTime serviceDate,  List<ScheduledTrip> items,  Meta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
return $default(_that.routeId,_that.serviceDate,_that.items,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String routeId,  DateTime serviceDate,  List<ScheduledTrip> items,  Meta meta)  $default,) {final _that = this;
switch (_that) {
case _ScheduleResponse():
return $default(_that.routeId,_that.serviceDate,_that.items,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String routeId,  DateTime serviceDate,  List<ScheduledTrip> items,  Meta meta)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
return $default(_that.routeId,_that.serviceDate,_that.items,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleResponse implements ScheduleResponse {
  const _ScheduleResponse({required this.routeId, required this.serviceDate, required  List<ScheduledTrip> items, required this.meta}): _items = items;
  factory _ScheduleResponse.fromJson(Map<String, dynamic> json) => _$ScheduleResponseFromJson(json);

@override final  String routeId;
@override final  DateTime serviceDate;
 final  List<ScheduledTrip> _items;
@override List<ScheduledTrip> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Meta meta;

/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleResponseCopyWith<_ScheduleResponse> get copyWith => __$ScheduleResponseCopyWithImpl<_ScheduleResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleResponse&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.serviceDate, serviceDate) || other.serviceDate == serviceDate)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,routeId,serviceDate,const DeepCollectionEquality().hash(_items),meta);
}

@override
String toString() {
    return 'ScheduleResponse(routeId: $routeId, serviceDate: $serviceDate, items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$ScheduleResponseCopyWith<$Res> implements $ScheduleResponseCopyWith<$Res> {
  factory _$ScheduleResponseCopyWith(_ScheduleResponse value, $Res Function(_ScheduleResponse) _then) = __$ScheduleResponseCopyWithImpl;
@override @useResult
$Res call({
 String routeId, DateTime serviceDate, List<ScheduledTrip> items, Meta meta
});


@override $MetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$ScheduleResponseCopyWithImpl<$Res>
    implements _$ScheduleResponseCopyWith<$Res> {
  __$ScheduleResponseCopyWithImpl(this._self, this._then);

  final _ScheduleResponse _self;
  final $Res Function(_ScheduleResponse) _then;

/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? routeId = null,Object? serviceDate = null,Object? items = null,Object? meta = null,}) {
  return _then(_ScheduleResponse(
routeId: null == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as String,serviceDate: null == serviceDate ? _self.serviceDate : serviceDate // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ScheduledTrip>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,
  ));
}

/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$SourceStatus {

 String get source; String get status; bool get timesApproximate; bool get liveData; String? get operator; TransitMode? get mode; String? get reason; DateTime? get validFrom; DateTime? get validTo; DateTime? get fetchedAt; DateTime? get lastAttemptAt; String? get lastAttemptStatus; bool? get hasCalendarExceptions;
/// Create a copy of SourceStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SourceStatusCopyWith<SourceStatus> get copyWith => _$SourceStatusCopyWithImpl<SourceStatus>(this as SourceStatus, _$identity);

  /// Serializes this SourceStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SourceStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SourceStatus&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.timesApproximate, _this.timesApproximate) || other.timesApproximate == _this.timesApproximate)&&(identical(other.liveData, _this.liveData) || other.liveData == _this.liveData)&&(identical(other.operator, _this.operator) || other.operator == _this.operator)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.validFrom, _this.validFrom) || other.validFrom == _this.validFrom)&&(identical(other.validTo, _this.validTo) || other.validTo == _this.validTo)&&(identical(other.fetchedAt, _this.fetchedAt) || other.fetchedAt == _this.fetchedAt)&&(identical(other.lastAttemptAt, _this.lastAttemptAt) || other.lastAttemptAt == _this.lastAttemptAt)&&(identical(other.lastAttemptStatus, _this.lastAttemptStatus) || other.lastAttemptStatus == _this.lastAttemptStatus)&&(identical(other.hasCalendarExceptions, _this.hasCalendarExceptions) || other.hasCalendarExceptions == _this.hasCalendarExceptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SourceStatus;
  return Object.hash(runtimeType,_this.source,_this.status,_this.timesApproximate,_this.liveData,_this.operator,_this.mode,_this.reason,_this.validFrom,_this.validTo,_this.fetchedAt,_this.lastAttemptAt,_this.lastAttemptStatus,_this.hasCalendarExceptions);
}

@override
String toString() {
  final _this = this as SourceStatus;
  return 'SourceStatus(source: ${_this.source}, status: ${_this.status}, timesApproximate: ${_this.timesApproximate}, liveData: ${_this.liveData}, operator: ${_this.operator}, mode: ${_this.mode}, reason: ${_this.reason}, validFrom: ${_this.validFrom}, validTo: ${_this.validTo}, fetchedAt: ${_this.fetchedAt}, lastAttemptAt: ${_this.lastAttemptAt}, lastAttemptStatus: ${_this.lastAttemptStatus}, hasCalendarExceptions: ${_this.hasCalendarExceptions})';
}


}

/// @nodoc
abstract mixin class $SourceStatusCopyWith<$Res>  {
  factory $SourceStatusCopyWith(SourceStatus value, $Res Function(SourceStatus) _then) = _$SourceStatusCopyWithImpl;
@useResult
$Res call({
 String source, String status, bool timesApproximate, bool liveData, String? operator, TransitMode? mode, String? reason, DateTime? validFrom, DateTime? validTo, DateTime? fetchedAt, DateTime? lastAttemptAt, String? lastAttemptStatus, bool? hasCalendarExceptions
});




}
/// @nodoc
class _$SourceStatusCopyWithImpl<$Res>
    implements $SourceStatusCopyWith<$Res> {
  _$SourceStatusCopyWithImpl(this._self, this._then);

  final SourceStatus _self;
  final $Res Function(SourceStatus) _then;

/// Create a copy of SourceStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? status = null,Object? timesApproximate = null,Object? liveData = null,Object? operator = freezed,Object? mode = freezed,Object? reason = freezed,Object? validFrom = freezed,Object? validTo = freezed,Object? fetchedAt = freezed,Object? lastAttemptAt = freezed,Object? lastAttemptStatus = freezed,Object? hasCalendarExceptions = freezed,}) {
  return _then(SourceStatus(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,timesApproximate: null == timesApproximate ? _self.timesApproximate : timesApproximate // ignore: cast_nullable_to_non_nullable
as bool,liveData: null == liveData ? _self.liveData : liveData // ignore: cast_nullable_to_non_nullable
as bool,operator: freezed == operator ? _self.operator : operator // ignore: cast_nullable_to_non_nullable
as String?,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransitMode?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as DateTime?,fetchedAt: freezed == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAttemptAt: freezed == lastAttemptAt ? _self.lastAttemptAt : lastAttemptAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAttemptStatus: freezed == lastAttemptStatus ? _self.lastAttemptStatus : lastAttemptStatus // ignore: cast_nullable_to_non_nullable
as String?,hasCalendarExceptions: freezed == hasCalendarExceptions ? _self.hasCalendarExceptions : hasCalendarExceptions // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [SourceStatus].
extension SourceStatusPatterns on SourceStatus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SourceStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SourceStatus() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SourceStatus value)  $default,){
final _that = this;
switch (_that) {
case _SourceStatus():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SourceStatus value)?  $default,){
final _that = this;
switch (_that) {
case _SourceStatus() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String source,  String status,  bool timesApproximate,  bool liveData,  String? operator,  TransitMode? mode,  String? reason,  DateTime? validFrom,  DateTime? validTo,  DateTime? fetchedAt,  DateTime? lastAttemptAt,  String? lastAttemptStatus,  bool? hasCalendarExceptions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SourceStatus() when $default != null:
return $default(_that.source,_that.status,_that.timesApproximate,_that.liveData,_that.operator,_that.mode,_that.reason,_that.validFrom,_that.validTo,_that.fetchedAt,_that.lastAttemptAt,_that.lastAttemptStatus,_that.hasCalendarExceptions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String source,  String status,  bool timesApproximate,  bool liveData,  String? operator,  TransitMode? mode,  String? reason,  DateTime? validFrom,  DateTime? validTo,  DateTime? fetchedAt,  DateTime? lastAttemptAt,  String? lastAttemptStatus,  bool? hasCalendarExceptions)  $default,) {final _that = this;
switch (_that) {
case _SourceStatus():
return $default(_that.source,_that.status,_that.timesApproximate,_that.liveData,_that.operator,_that.mode,_that.reason,_that.validFrom,_that.validTo,_that.fetchedAt,_that.lastAttemptAt,_that.lastAttemptStatus,_that.hasCalendarExceptions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String source,  String status,  bool timesApproximate,  bool liveData,  String? operator,  TransitMode? mode,  String? reason,  DateTime? validFrom,  DateTime? validTo,  DateTime? fetchedAt,  DateTime? lastAttemptAt,  String? lastAttemptStatus,  bool? hasCalendarExceptions)?  $default,) {final _that = this;
switch (_that) {
case _SourceStatus() when $default != null:
return $default(_that.source,_that.status,_that.timesApproximate,_that.liveData,_that.operator,_that.mode,_that.reason,_that.validFrom,_that.validTo,_that.fetchedAt,_that.lastAttemptAt,_that.lastAttemptStatus,_that.hasCalendarExceptions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SourceStatus implements SourceStatus {
  const _SourceStatus({required this.source, required this.status, required this.timesApproximate, required this.liveData, this.operator, this.mode, this.reason, this.validFrom, this.validTo, this.fetchedAt, this.lastAttemptAt, this.lastAttemptStatus, this.hasCalendarExceptions});
  factory _SourceStatus.fromJson(Map<String, dynamic> json) => _$SourceStatusFromJson(json);

@override final  String source;
@override final  String status;
@override final  bool timesApproximate;
@override final  bool liveData;
@override final  String? operator;
@override final  TransitMode? mode;
@override final  String? reason;
@override final  DateTime? validFrom;
@override final  DateTime? validTo;
@override final  DateTime? fetchedAt;
@override final  DateTime? lastAttemptAt;
@override final  String? lastAttemptStatus;
@override final  bool? hasCalendarExceptions;

/// Create a copy of SourceStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SourceStatusCopyWith<_SourceStatus> get copyWith => __$SourceStatusCopyWithImpl<_SourceStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SourceStatusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SourceStatus&&(identical(other.source, source) || other.source == source)&&(identical(other.status, status) || other.status == status)&&(identical(other.timesApproximate, timesApproximate) || other.timesApproximate == timesApproximate)&&(identical(other.liveData, liveData) || other.liveData == liveData)&&(identical(other.operator, operator) || other.operator == operator)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTo, validTo) || other.validTo == validTo)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.lastAttemptAt, lastAttemptAt) || other.lastAttemptAt == lastAttemptAt)&&(identical(other.lastAttemptStatus, lastAttemptStatus) || other.lastAttemptStatus == lastAttemptStatus)&&(identical(other.hasCalendarExceptions, hasCalendarExceptions) || other.hasCalendarExceptions == hasCalendarExceptions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,source,status,timesApproximate,liveData,operator,mode,reason,validFrom,validTo,fetchedAt,lastAttemptAt,lastAttemptStatus,hasCalendarExceptions);
}

@override
String toString() {
    return 'SourceStatus(source: $source, status: $status, timesApproximate: $timesApproximate, liveData: $liveData, operator: $operator, mode: $mode, reason: $reason, validFrom: $validFrom, validTo: $validTo, fetchedAt: $fetchedAt, lastAttemptAt: $lastAttemptAt, lastAttemptStatus: $lastAttemptStatus, hasCalendarExceptions: $hasCalendarExceptions)';
}


}

/// @nodoc
abstract mixin class _$SourceStatusCopyWith<$Res> implements $SourceStatusCopyWith<$Res> {
  factory _$SourceStatusCopyWith(_SourceStatus value, $Res Function(_SourceStatus) _then) = __$SourceStatusCopyWithImpl;
@override @useResult
$Res call({
 String source, String status, bool timesApproximate, bool liveData, String? operator, TransitMode? mode, String? reason, DateTime? validFrom, DateTime? validTo, DateTime? fetchedAt, DateTime? lastAttemptAt, String? lastAttemptStatus, bool? hasCalendarExceptions
});




}
/// @nodoc
class __$SourceStatusCopyWithImpl<$Res>
    implements _$SourceStatusCopyWith<$Res> {
  __$SourceStatusCopyWithImpl(this._self, this._then);

  final _SourceStatus _self;
  final $Res Function(_SourceStatus) _then;

/// Create a copy of SourceStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? status = null,Object? timesApproximate = null,Object? liveData = null,Object? operator = freezed,Object? mode = freezed,Object? reason = freezed,Object? validFrom = freezed,Object? validTo = freezed,Object? fetchedAt = freezed,Object? lastAttemptAt = freezed,Object? lastAttemptStatus = freezed,Object? hasCalendarExceptions = freezed,}) {
  return _then(_SourceStatus(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,timesApproximate: null == timesApproximate ? _self.timesApproximate : timesApproximate // ignore: cast_nullable_to_non_nullable
as bool,liveData: null == liveData ? _self.liveData : liveData // ignore: cast_nullable_to_non_nullable
as bool,operator: freezed == operator ? _self.operator : operator // ignore: cast_nullable_to_non_nullable
as String?,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransitMode?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as DateTime?,fetchedAt: freezed == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAttemptAt: freezed == lastAttemptAt ? _self.lastAttemptAt : lastAttemptAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAttemptStatus: freezed == lastAttemptStatus ? _self.lastAttemptStatus : lastAttemptStatus // ignore: cast_nullable_to_non_nullable
as String?,hasCalendarExceptions: freezed == hasCalendarExceptions ? _self.hasCalendarExceptions : hasCalendarExceptions // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$TransitStatus {

 List<SourceStatus> get sources; DateTime get generatedAt; DatasetRef? get dataset; DateTime? get lastRunAt; String? get lastRunStatus;
/// Create a copy of TransitStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransitStatusCopyWith<TransitStatus> get copyWith => _$TransitStatusCopyWithImpl<TransitStatus>(this as TransitStatus, _$identity);

  /// Serializes this TransitStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransitStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransitStatus&&const DeepCollectionEquality().equals(other.sources, _this.sources)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt)&&(identical(other.dataset, _this.dataset) || other.dataset == _this.dataset)&&(identical(other.lastRunAt, _this.lastRunAt) || other.lastRunAt == _this.lastRunAt)&&(identical(other.lastRunStatus, _this.lastRunStatus) || other.lastRunStatus == _this.lastRunStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransitStatus;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.sources),_this.generatedAt,_this.dataset,_this.lastRunAt,_this.lastRunStatus);
}

@override
String toString() {
  final _this = this as TransitStatus;
  return 'TransitStatus(sources: ${_this.sources}, generatedAt: ${_this.generatedAt}, dataset: ${_this.dataset}, lastRunAt: ${_this.lastRunAt}, lastRunStatus: ${_this.lastRunStatus})';
}


}

/// @nodoc
abstract mixin class $TransitStatusCopyWith<$Res>  {
  factory $TransitStatusCopyWith(TransitStatus value, $Res Function(TransitStatus) _then) = _$TransitStatusCopyWithImpl;
@useResult
$Res call({
 List<SourceStatus> sources, DateTime generatedAt, DatasetRef? dataset, DateTime? lastRunAt, String? lastRunStatus
});


$DatasetRefCopyWith<$Res>? get dataset;

}
/// @nodoc
class _$TransitStatusCopyWithImpl<$Res>
    implements $TransitStatusCopyWith<$Res> {
  _$TransitStatusCopyWithImpl(this._self, this._then);

  final TransitStatus _self;
  final $Res Function(TransitStatus) _then;

/// Create a copy of TransitStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sources = null,Object? generatedAt = null,Object? dataset = freezed,Object? lastRunAt = freezed,Object? lastRunStatus = freezed,}) {
  return _then(TransitStatus(
sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<SourceStatus>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,dataset: freezed == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as DatasetRef?,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRunStatus: freezed == lastRunStatus ? _self.lastRunStatus : lastRunStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TransitStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DatasetRefCopyWith<$Res>? get dataset {
    if (_self.dataset == null) {
    return null;
  }

  return $DatasetRefCopyWith<$Res>(_self.dataset!, (value) {
    return _then(_self.copyWith(dataset: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransitStatus].
extension TransitStatusPatterns on TransitStatus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransitStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransitStatus() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransitStatus value)  $default,){
final _that = this;
switch (_that) {
case _TransitStatus():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransitStatus value)?  $default,){
final _that = this;
switch (_that) {
case _TransitStatus() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SourceStatus> sources,  DateTime generatedAt,  DatasetRef? dataset,  DateTime? lastRunAt,  String? lastRunStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransitStatus() when $default != null:
return $default(_that.sources,_that.generatedAt,_that.dataset,_that.lastRunAt,_that.lastRunStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SourceStatus> sources,  DateTime generatedAt,  DatasetRef? dataset,  DateTime? lastRunAt,  String? lastRunStatus)  $default,) {final _that = this;
switch (_that) {
case _TransitStatus():
return $default(_that.sources,_that.generatedAt,_that.dataset,_that.lastRunAt,_that.lastRunStatus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SourceStatus> sources,  DateTime generatedAt,  DatasetRef? dataset,  DateTime? lastRunAt,  String? lastRunStatus)?  $default,) {final _that = this;
switch (_that) {
case _TransitStatus() when $default != null:
return $default(_that.sources,_that.generatedAt,_that.dataset,_that.lastRunAt,_that.lastRunStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransitStatus implements TransitStatus {
  const _TransitStatus({required  List<SourceStatus> sources, required this.generatedAt, this.dataset, this.lastRunAt, this.lastRunStatus}): _sources = sources;
  factory _TransitStatus.fromJson(Map<String, dynamic> json) => _$TransitStatusFromJson(json);

 final  List<SourceStatus> _sources;
@override List<SourceStatus> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override final  DateTime generatedAt;
@override final  DatasetRef? dataset;
@override final  DateTime? lastRunAt;
@override final  String? lastRunStatus;

/// Create a copy of TransitStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransitStatusCopyWith<_TransitStatus> get copyWith => __$TransitStatusCopyWithImpl<_TransitStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransitStatusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransitStatus&&const DeepCollectionEquality().equals(other.sources, _sources)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.dataset, dataset) || other.dataset == dataset)&&(identical(other.lastRunAt, lastRunAt) || other.lastRunAt == lastRunAt)&&(identical(other.lastRunStatus, lastRunStatus) || other.lastRunStatus == lastRunStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_sources),generatedAt,dataset,lastRunAt,lastRunStatus);
}

@override
String toString() {
    return 'TransitStatus(sources: $sources, generatedAt: $generatedAt, dataset: $dataset, lastRunAt: $lastRunAt, lastRunStatus: $lastRunStatus)';
}


}

/// @nodoc
abstract mixin class _$TransitStatusCopyWith<$Res> implements $TransitStatusCopyWith<$Res> {
  factory _$TransitStatusCopyWith(_TransitStatus value, $Res Function(_TransitStatus) _then) = __$TransitStatusCopyWithImpl;
@override @useResult
$Res call({
 List<SourceStatus> sources, DateTime generatedAt, DatasetRef? dataset, DateTime? lastRunAt, String? lastRunStatus
});


@override $DatasetRefCopyWith<$Res>? get dataset;

}
/// @nodoc
class __$TransitStatusCopyWithImpl<$Res>
    implements _$TransitStatusCopyWith<$Res> {
  __$TransitStatusCopyWithImpl(this._self, this._then);

  final _TransitStatus _self;
  final $Res Function(_TransitStatus) _then;

/// Create a copy of TransitStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sources = null,Object? generatedAt = null,Object? dataset = freezed,Object? lastRunAt = freezed,Object? lastRunStatus = freezed,}) {
  return _then(_TransitStatus(
sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<SourceStatus>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,dataset: freezed == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as DatasetRef?,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRunStatus: freezed == lastRunStatus ? _self.lastRunStatus : lastRunStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TransitStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DatasetRefCopyWith<$Res>? get dataset {
    if (_self.dataset == null) {
    return null;
  }

  return $DatasetRefCopyWith<$Res>(_self.dataset!, (value) {
    return _then(_self.copyWith(dataset: value));
  });
}
}


/// @nodoc
mixin _$Alert {

 String get id; String get source; List<String> get routeIds; String get title; DateTime get fetchedAt; String? get lineShortName; DateTime? get startsAt; DateTime? get endsAt;
/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertCopyWith<Alert> get copyWith => _$AlertCopyWithImpl<Alert>(this as Alert, _$identity);

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Alert;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Alert&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.source, _this.source) || other.source == _this.source)&&const DeepCollectionEquality().equals(other.routeIds, _this.routeIds)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.fetchedAt, _this.fetchedAt) || other.fetchedAt == _this.fetchedAt)&&(identical(other.lineShortName, _this.lineShortName) || other.lineShortName == _this.lineShortName)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Alert;
  return Object.hash(runtimeType,_this.id,_this.source,const DeepCollectionEquality().hash(_this.routeIds),_this.title,_this.fetchedAt,_this.lineShortName,_this.startsAt,_this.endsAt);
}

@override
String toString() {
  final _this = this as Alert;
  return 'Alert(id: ${_this.id}, source: ${_this.source}, routeIds: ${_this.routeIds}, title: ${_this.title}, fetchedAt: ${_this.fetchedAt}, lineShortName: ${_this.lineShortName}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt})';
}


}

/// @nodoc
abstract mixin class $AlertCopyWith<$Res>  {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) _then) = _$AlertCopyWithImpl;
@useResult
$Res call({
 String id, String source, List<String> routeIds, String title, DateTime fetchedAt, String? lineShortName, DateTime? startsAt, DateTime? endsAt
});




}
/// @nodoc
class _$AlertCopyWithImpl<$Res>
    implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._self, this._then);

  final Alert _self;
  final $Res Function(Alert) _then;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? routeIds = null,Object? title = null,Object? fetchedAt = null,Object? lineShortName = freezed,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(Alert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,routeIds: null == routeIds ? _self.routeIds : routeIds // ignore: cast_nullable_to_non_nullable
as List<String>,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lineShortName: freezed == lineShortName ? _self.lineShortName : lineShortName // ignore: cast_nullable_to_non_nullable
as String?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Alert].
extension AlertPatterns on Alert {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Alert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Alert value)  $default,){
final _that = this;
switch (_that) {
case _Alert():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Alert value)?  $default,){
final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String source,  List<String> routeIds,  String title,  DateTime fetchedAt,  String? lineShortName,  DateTime? startsAt,  DateTime? endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that.id,_that.source,_that.routeIds,_that.title,_that.fetchedAt,_that.lineShortName,_that.startsAt,_that.endsAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String source,  List<String> routeIds,  String title,  DateTime fetchedAt,  String? lineShortName,  DateTime? startsAt,  DateTime? endsAt)  $default,) {final _that = this;
switch (_that) {
case _Alert():
return $default(_that.id,_that.source,_that.routeIds,_that.title,_that.fetchedAt,_that.lineShortName,_that.startsAt,_that.endsAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String source,  List<String> routeIds,  String title,  DateTime fetchedAt,  String? lineShortName,  DateTime? startsAt,  DateTime? endsAt)?  $default,) {final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that.id,_that.source,_that.routeIds,_that.title,_that.fetchedAt,_that.lineShortName,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Alert implements Alert {
  const _Alert({required this.id, required this.source, required  List<String> routeIds, required this.title, required this.fetchedAt, this.lineShortName, this.startsAt, this.endsAt}): _routeIds = routeIds;
  factory _Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

@override final  String id;
@override final  String source;
 final  List<String> _routeIds;
@override List<String> get routeIds {
  if (_routeIds is EqualUnmodifiableListView) return _routeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routeIds);
}

@override final  String title;
@override final  DateTime fetchedAt;
@override final  String? lineShortName;
@override final  DateTime? startsAt;
@override final  DateTime? endsAt;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertCopyWith<_Alert> get copyWith => __$AlertCopyWithImpl<_Alert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Alert&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other.routeIds, _routeIds)&&(identical(other.title, title) || other.title == title)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.lineShortName, lineShortName) || other.lineShortName == lineShortName)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,source,const DeepCollectionEquality().hash(_routeIds),title,fetchedAt,lineShortName,startsAt,endsAt);
}

@override
String toString() {
    return 'Alert(id: $id, source: $source, routeIds: $routeIds, title: $title, fetchedAt: $fetchedAt, lineShortName: $lineShortName, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$AlertCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$AlertCopyWith(_Alert value, $Res Function(_Alert) _then) = __$AlertCopyWithImpl;
@override @useResult
$Res call({
 String id, String source, List<String> routeIds, String title, DateTime fetchedAt, String? lineShortName, DateTime? startsAt, DateTime? endsAt
});




}
/// @nodoc
class __$AlertCopyWithImpl<$Res>
    implements _$AlertCopyWith<$Res> {
  __$AlertCopyWithImpl(this._self, this._then);

  final _Alert _self;
  final $Res Function(_Alert) _then;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? routeIds = null,Object? title = null,Object? fetchedAt = null,Object? lineShortName = freezed,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(_Alert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,routeIds: null == routeIds ? _self._routeIds : routeIds // ignore: cast_nullable_to_non_nullable
as List<String>,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lineShortName: freezed == lineShortName ? _self.lineShortName : lineShortName // ignore: cast_nullable_to_non_nullable
as String?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AlertsResponse {

 List<Alert> get items; DateTime get generatedAt;
/// Create a copy of AlertsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertsResponseCopyWith<AlertsResponse> get copyWith => _$AlertsResponseCopyWithImpl<AlertsResponse>(this as AlertsResponse, _$identity);

  /// Serializes this AlertsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlertsResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertsResponse&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlertsResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.generatedAt);
}

@override
String toString() {
  final _this = this as AlertsResponse;
  return 'AlertsResponse(items: ${_this.items}, generatedAt: ${_this.generatedAt})';
}


}

/// @nodoc
abstract mixin class $AlertsResponseCopyWith<$Res>  {
  factory $AlertsResponseCopyWith(AlertsResponse value, $Res Function(AlertsResponse) _then) = _$AlertsResponseCopyWithImpl;
@useResult
$Res call({
 List<Alert> items, DateTime generatedAt
});




}
/// @nodoc
class _$AlertsResponseCopyWithImpl<$Res>
    implements $AlertsResponseCopyWith<$Res> {
  _$AlertsResponseCopyWithImpl(this._self, this._then);

  final AlertsResponse _self;
  final $Res Function(AlertsResponse) _then;

/// Create a copy of AlertsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? generatedAt = null,}) {
  return _then(AlertsResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Alert>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertsResponse].
extension AlertsResponsePatterns on AlertsResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertsResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertsResponse value)  $default,){
final _that = this;
switch (_that) {
case _AlertsResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AlertsResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Alert> items,  DateTime generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertsResponse() when $default != null:
return $default(_that.items,_that.generatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Alert> items,  DateTime generatedAt)  $default,) {final _that = this;
switch (_that) {
case _AlertsResponse():
return $default(_that.items,_that.generatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Alert> items,  DateTime generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AlertsResponse() when $default != null:
return $default(_that.items,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlertsResponse implements AlertsResponse {
  const _AlertsResponse({required  List<Alert> items, required this.generatedAt}): _items = items;
  factory _AlertsResponse.fromJson(Map<String, dynamic> json) => _$AlertsResponseFromJson(json);

 final  List<Alert> _items;
@override List<Alert> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  DateTime generatedAt;

/// Create a copy of AlertsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertsResponseCopyWith<_AlertsResponse> get copyWith => __$AlertsResponseCopyWithImpl<_AlertsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertsResponse&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),generatedAt);
}

@override
String toString() {
    return 'AlertsResponse(items: $items, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$AlertsResponseCopyWith<$Res> implements $AlertsResponseCopyWith<$Res> {
  factory _$AlertsResponseCopyWith(_AlertsResponse value, $Res Function(_AlertsResponse) _then) = __$AlertsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Alert> items, DateTime generatedAt
});




}
/// @nodoc
class __$AlertsResponseCopyWithImpl<$Res>
    implements _$AlertsResponseCopyWith<$Res> {
  __$AlertsResponseCopyWithImpl(this._self, this._then);

  final _AlertsResponse _self;
  final $Res Function(_AlertsResponse) _then;

/// Create a copy of AlertsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? generatedAt = null,}) {
  return _then(_AlertsResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Alert>,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CatalogStop {

 String get id; String get name; double get lat; double get lon; List<TransitMode> get modes; String get kind; bool get hasSchedule; String? get parentStation; List<String> get lines;
/// Create a copy of CatalogStop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogStopCopyWith<CatalogStop> get copyWith => _$CatalogStopCopyWithImpl<CatalogStop>(this as CatalogStop, _$identity);

  /// Serializes this CatalogStop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogStop;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogStop&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lon, _this.lon) || other.lon == _this.lon)&&const DeepCollectionEquality().equals(other.modes, _this.modes)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.hasSchedule, _this.hasSchedule) || other.hasSchedule == _this.hasSchedule)&&(identical(other.parentStation, _this.parentStation) || other.parentStation == _this.parentStation)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogStop;
  return Object.hash(runtimeType,_this.id,_this.name,_this.lat,_this.lon,const DeepCollectionEquality().hash(_this.modes),_this.kind,_this.hasSchedule,_this.parentStation,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as CatalogStop;
  return 'CatalogStop(id: ${_this.id}, name: ${_this.name}, lat: ${_this.lat}, lon: ${_this.lon}, modes: ${_this.modes}, kind: ${_this.kind}, hasSchedule: ${_this.hasSchedule}, parentStation: ${_this.parentStation}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $CatalogStopCopyWith<$Res>  {
  factory $CatalogStopCopyWith(CatalogStop value, $Res Function(CatalogStop) _then) = _$CatalogStopCopyWithImpl;
@useResult
$Res call({
 String id, String name, double lat, double lon, List<TransitMode> modes, String kind, bool hasSchedule, String? parentStation, List<String> lines
});




}
/// @nodoc
class _$CatalogStopCopyWithImpl<$Res>
    implements $CatalogStopCopyWith<$Res> {
  _$CatalogStopCopyWithImpl(this._self, this._then);

  final CatalogStop _self;
  final $Res Function(CatalogStop) _then;

/// Create a copy of CatalogStop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lon = null,Object? modes = null,Object? kind = null,Object? hasSchedule = null,Object? parentStation = freezed,Object? lines = null,}) {
  return _then(CatalogStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,modes: null == modes ? _self.modes : modes // ignore: cast_nullable_to_non_nullable
as List<TransitMode>,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,hasSchedule: null == hasSchedule ? _self.hasSchedule : hasSchedule // ignore: cast_nullable_to_non_nullable
as bool,parentStation: freezed == parentStation ? _self.parentStation : parentStation // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogStop].
extension CatalogStopPatterns on CatalogStop {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogStop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogStop() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogStop value)  $default,){
final _that = this;
switch (_that) {
case _CatalogStop():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogStop value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogStop() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lon,  List<TransitMode> modes,  String kind,  bool hasSchedule,  String? parentStation,  List<String> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogStop() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.modes,_that.kind,_that.hasSchedule,_that.parentStation,_that.lines);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lon,  List<TransitMode> modes,  String kind,  bool hasSchedule,  String? parentStation,  List<String> lines)  $default,) {final _that = this;
switch (_that) {
case _CatalogStop():
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.modes,_that.kind,_that.hasSchedule,_that.parentStation,_that.lines);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double lat,  double lon,  List<TransitMode> modes,  String kind,  bool hasSchedule,  String? parentStation,  List<String> lines)?  $default,) {final _that = this;
switch (_that) {
case _CatalogStop() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.modes,_that.kind,_that.hasSchedule,_that.parentStation,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogStop implements CatalogStop {
  const _CatalogStop({required this.id, required this.name, required this.lat, required this.lon, required  List<TransitMode> modes, required this.kind, required this.hasSchedule, this.parentStation,  List<String> lines = const <String>[]}): _modes = modes,_lines = lines;
  factory _CatalogStop.fromJson(Map<String, dynamic> json) => _$CatalogStopFromJson(json);

@override final  String id;
@override final  String name;
@override final  double lat;
@override final  double lon;
 final  List<TransitMode> _modes;
@override List<TransitMode> get modes {
  if (_modes is EqualUnmodifiableListView) return _modes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modes);
}

@override final  String kind;
@override final  bool hasSchedule;
@override final  String? parentStation;
 final  List<String> _lines;
@override@JsonKey() List<String> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of CatalogStop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogStopCopyWith<_CatalogStop> get copyWith => __$CatalogStopCopyWithImpl<_CatalogStop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogStopToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogStop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&const DeepCollectionEquality().equals(other.modes, _modes)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.hasSchedule, hasSchedule) || other.hasSchedule == hasSchedule)&&(identical(other.parentStation, parentStation) || other.parentStation == parentStation)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,lat,lon,const DeepCollectionEquality().hash(_modes),kind,hasSchedule,parentStation,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'CatalogStop(id: $id, name: $name, lat: $lat, lon: $lon, modes: $modes, kind: $kind, hasSchedule: $hasSchedule, parentStation: $parentStation, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$CatalogStopCopyWith<$Res> implements $CatalogStopCopyWith<$Res> {
  factory _$CatalogStopCopyWith(_CatalogStop value, $Res Function(_CatalogStop) _then) = __$CatalogStopCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double lat, double lon, List<TransitMode> modes, String kind, bool hasSchedule, String? parentStation, List<String> lines
});




}
/// @nodoc
class __$CatalogStopCopyWithImpl<$Res>
    implements _$CatalogStopCopyWith<$Res> {
  __$CatalogStopCopyWithImpl(this._self, this._then);

  final _CatalogStop _self;
  final $Res Function(_CatalogStop) _then;

/// Create a copy of CatalogStop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lon = null,Object? modes = null,Object? kind = null,Object? hasSchedule = null,Object? parentStation = freezed,Object? lines = null,}) {
  return _then(_CatalogStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,modes: null == modes ? _self._modes : modes // ignore: cast_nullable_to_non_nullable
as List<TransitMode>,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,hasSchedule: null == hasSchedule ? _self.hasSchedule : hasSchedule // ignore: cast_nullable_to_non_nullable
as bool,parentStation: freezed == parentStation ? _self.parentStation : parentStation // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$CatalogSnapshot {

 DatasetRef get dataset; DateTime get generatedAt; List<CatalogStop> get stops; List<RouteSummary> get routes; List<SourceWindow> get sources;
/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogSnapshotCopyWith<CatalogSnapshot> get copyWith => _$CatalogSnapshotCopyWithImpl<CatalogSnapshot>(this as CatalogSnapshot, _$identity);

  /// Serializes this CatalogSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogSnapshot&&(identical(other.dataset, _this.dataset) || other.dataset == _this.dataset)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt)&&const DeepCollectionEquality().equals(other.stops, _this.stops)&&const DeepCollectionEquality().equals(other.routes, _this.routes)&&const DeepCollectionEquality().equals(other.sources, _this.sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogSnapshot;
  return Object.hash(runtimeType,_this.dataset,_this.generatedAt,const DeepCollectionEquality().hash(_this.stops),const DeepCollectionEquality().hash(_this.routes),const DeepCollectionEquality().hash(_this.sources));
}

@override
String toString() {
  final _this = this as CatalogSnapshot;
  return 'CatalogSnapshot(dataset: ${_this.dataset}, generatedAt: ${_this.generatedAt}, stops: ${_this.stops}, routes: ${_this.routes}, sources: ${_this.sources})';
}


}

/// @nodoc
abstract mixin class $CatalogSnapshotCopyWith<$Res>  {
  factory $CatalogSnapshotCopyWith(CatalogSnapshot value, $Res Function(CatalogSnapshot) _then) = _$CatalogSnapshotCopyWithImpl;
@useResult
$Res call({
 DatasetRef dataset, DateTime generatedAt, List<CatalogStop> stops, List<RouteSummary> routes, List<SourceWindow> sources
});


$DatasetRefCopyWith<$Res> get dataset;

}
/// @nodoc
class _$CatalogSnapshotCopyWithImpl<$Res>
    implements $CatalogSnapshotCopyWith<$Res> {
  _$CatalogSnapshotCopyWithImpl(this._self, this._then);

  final CatalogSnapshot _self;
  final $Res Function(CatalogSnapshot) _then;

/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dataset = null,Object? generatedAt = null,Object? stops = null,Object? routes = null,Object? sources = null,}) {
  return _then(CatalogSnapshot(
dataset: null == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as DatasetRef,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stops: null == stops ? _self.stops : stops // ignore: cast_nullable_to_non_nullable
as List<CatalogStop>,routes: null == routes ? _self.routes : routes // ignore: cast_nullable_to_non_nullable
as List<RouteSummary>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<SourceWindow>,
  ));
}
/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DatasetRefCopyWith<$Res> get dataset {
  
  return $DatasetRefCopyWith<$Res>(_self.dataset, (value) {
    return _then(_self.copyWith(dataset: value));
  });
}
}


/// Adds pattern-matching-related methods to [CatalogSnapshot].
extension CatalogSnapshotPatterns on CatalogSnapshot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _CatalogSnapshot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DatasetRef dataset,  DateTime generatedAt,  List<CatalogStop> stops,  List<RouteSummary> routes,  List<SourceWindow> sources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
return $default(_that.dataset,_that.generatedAt,_that.stops,_that.routes,_that.sources);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DatasetRef dataset,  DateTime generatedAt,  List<CatalogStop> stops,  List<RouteSummary> routes,  List<SourceWindow> sources)  $default,) {final _that = this;
switch (_that) {
case _CatalogSnapshot():
return $default(_that.dataset,_that.generatedAt,_that.stops,_that.routes,_that.sources);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DatasetRef dataset,  DateTime generatedAt,  List<CatalogStop> stops,  List<RouteSummary> routes,  List<SourceWindow> sources)?  $default,) {final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
return $default(_that.dataset,_that.generatedAt,_that.stops,_that.routes,_that.sources);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogSnapshot implements CatalogSnapshot {
  const _CatalogSnapshot({required this.dataset, required this.generatedAt, required  List<CatalogStop> stops, required  List<RouteSummary> routes, required  List<SourceWindow> sources}): _stops = stops,_routes = routes,_sources = sources;
  factory _CatalogSnapshot.fromJson(Map<String, dynamic> json) => _$CatalogSnapshotFromJson(json);

@override final  DatasetRef dataset;
@override final  DateTime generatedAt;
 final  List<CatalogStop> _stops;
@override List<CatalogStop> get stops {
  if (_stops is EqualUnmodifiableListView) return _stops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stops);
}

 final  List<RouteSummary> _routes;
@override List<RouteSummary> get routes {
  if (_routes is EqualUnmodifiableListView) return _routes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routes);
}

 final  List<SourceWindow> _sources;
@override List<SourceWindow> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}


/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogSnapshotCopyWith<_CatalogSnapshot> get copyWith => __$CatalogSnapshotCopyWithImpl<_CatalogSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogSnapshot&&(identical(other.dataset, dataset) || other.dataset == dataset)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other.stops, _stops)&&const DeepCollectionEquality().equals(other.routes, _routes)&&const DeepCollectionEquality().equals(other.sources, _sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dataset,generatedAt,const DeepCollectionEquality().hash(_stops),const DeepCollectionEquality().hash(_routes),const DeepCollectionEquality().hash(_sources));
}

@override
String toString() {
    return 'CatalogSnapshot(dataset: $dataset, generatedAt: $generatedAt, stops: $stops, routes: $routes, sources: $sources)';
}


}

/// @nodoc
abstract mixin class _$CatalogSnapshotCopyWith<$Res> implements $CatalogSnapshotCopyWith<$Res> {
  factory _$CatalogSnapshotCopyWith(_CatalogSnapshot value, $Res Function(_CatalogSnapshot) _then) = __$CatalogSnapshotCopyWithImpl;
@override @useResult
$Res call({
 DatasetRef dataset, DateTime generatedAt, List<CatalogStop> stops, List<RouteSummary> routes, List<SourceWindow> sources
});


@override $DatasetRefCopyWith<$Res> get dataset;

}
/// @nodoc
class __$CatalogSnapshotCopyWithImpl<$Res>
    implements _$CatalogSnapshotCopyWith<$Res> {
  __$CatalogSnapshotCopyWithImpl(this._self, this._then);

  final _CatalogSnapshot _self;
  final $Res Function(_CatalogSnapshot) _then;

/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dataset = null,Object? generatedAt = null,Object? stops = null,Object? routes = null,Object? sources = null,}) {
  return _then(_CatalogSnapshot(
dataset: null == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as DatasetRef,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stops: null == stops ? _self._stops : stops // ignore: cast_nullable_to_non_nullable
as List<CatalogStop>,routes: null == routes ? _self._routes : routes // ignore: cast_nullable_to_non_nullable
as List<RouteSummary>,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<SourceWindow>,
  ));
}

/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DatasetRefCopyWith<$Res> get dataset {
  
  return $DatasetRefCopyWith<$Res>(_self.dataset, (value) {
    return _then(_self.copyWith(dataset: value));
  });
}
}


/// @nodoc
mixin _$Place {

 String get id; String get name; double get lat; double get lon; String get kind; String get provider; String? get subtitle;
/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceCopyWith<Place> get copyWith => _$PlaceCopyWithImpl<Place>(this as Place, _$identity);

  /// Serializes this Place to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Place;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Place&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lon, _this.lon) || other.lon == _this.lon)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.subtitle, _this.subtitle) || other.subtitle == _this.subtitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Place;
  return Object.hash(runtimeType,_this.id,_this.name,_this.lat,_this.lon,_this.kind,_this.provider,_this.subtitle);
}

@override
String toString() {
  final _this = this as Place;
  return 'Place(id: ${_this.id}, name: ${_this.name}, lat: ${_this.lat}, lon: ${_this.lon}, kind: ${_this.kind}, provider: ${_this.provider}, subtitle: ${_this.subtitle})';
}


}

/// @nodoc
abstract mixin class $PlaceCopyWith<$Res>  {
  factory $PlaceCopyWith(Place value, $Res Function(Place) _then) = _$PlaceCopyWithImpl;
@useResult
$Res call({
 String id, String name, double lat, double lon, String kind, String provider, String? subtitle
});




}
/// @nodoc
class _$PlaceCopyWithImpl<$Res>
    implements $PlaceCopyWith<$Res> {
  _$PlaceCopyWithImpl(this._self, this._then);

  final Place _self;
  final $Res Function(Place) _then;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lon = null,Object? kind = null,Object? provider = null,Object? subtitle = freezed,}) {
  return _then(Place(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Place].
extension PlacePatterns on Place {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Place value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Place value)  $default,){
final _that = this;
switch (_that) {
case _Place():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Place value)?  $default,){
final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lon,  String kind,  String provider,  String? subtitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.kind,_that.provider,_that.subtitle);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lon,  String kind,  String provider,  String? subtitle)  $default,) {final _that = this;
switch (_that) {
case _Place():
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.kind,_that.provider,_that.subtitle);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double lat,  double lon,  String kind,  String provider,  String? subtitle)?  $default,) {final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lon,_that.kind,_that.provider,_that.subtitle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Place extends Place {
  const _Place({required this.id, required this.name, required this.lat, required this.lon, required this.kind, required this.provider, this.subtitle}): super._();
  factory _Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

@override final  String id;
@override final  String name;
@override final  double lat;
@override final  double lon;
@override final  String kind;
@override final  String provider;
@override final  String? subtitle;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceCopyWith<_Place> get copyWith => __$PlaceCopyWithImpl<_Place>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Place&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,lat,lon,kind,provider,subtitle);
}

@override
String toString() {
    return 'Place(id: $id, name: $name, lat: $lat, lon: $lon, kind: $kind, provider: $provider, subtitle: $subtitle)';
}


}

/// @nodoc
abstract mixin class _$PlaceCopyWith<$Res> implements $PlaceCopyWith<$Res> {
  factory _$PlaceCopyWith(_Place value, $Res Function(_Place) _then) = __$PlaceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double lat, double lon, String kind, String provider, String? subtitle
});




}
/// @nodoc
class __$PlaceCopyWithImpl<$Res>
    implements _$PlaceCopyWith<$Res> {
  __$PlaceCopyWithImpl(this._self, this._then);

  final _Place _self;
  final $Res Function(_Place) _then;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lon = null,Object? kind = null,Object? provider = null,Object? subtitle = freezed,}) {
  return _then(_Place(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PlacesResponse {

 List<Place> get items; String? get attribution;
/// Create a copy of PlacesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlacesResponseCopyWith<PlacesResponse> get copyWith => _$PlacesResponseCopyWithImpl<PlacesResponse>(this as PlacesResponse, _$identity);

  /// Serializes this PlacesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlacesResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlacesResponse&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.attribution, _this.attribution) || other.attribution == _this.attribution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlacesResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.attribution);
}

@override
String toString() {
  final _this = this as PlacesResponse;
  return 'PlacesResponse(items: ${_this.items}, attribution: ${_this.attribution})';
}


}

/// @nodoc
abstract mixin class $PlacesResponseCopyWith<$Res>  {
  factory $PlacesResponseCopyWith(PlacesResponse value, $Res Function(PlacesResponse) _then) = _$PlacesResponseCopyWithImpl;
@useResult
$Res call({
 List<Place> items, String? attribution
});




}
/// @nodoc
class _$PlacesResponseCopyWithImpl<$Res>
    implements $PlacesResponseCopyWith<$Res> {
  _$PlacesResponseCopyWithImpl(this._self, this._then);

  final PlacesResponse _self;
  final $Res Function(PlacesResponse) _then;

/// Create a copy of PlacesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? attribution = freezed,}) {
  return _then(PlacesResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Place>,attribution: freezed == attribution ? _self.attribution : attribution // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlacesResponse].
extension PlacesResponsePatterns on PlacesResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlacesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlacesResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlacesResponse value)  $default,){
final _that = this;
switch (_that) {
case _PlacesResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlacesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PlacesResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Place> items,  String? attribution)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlacesResponse() when $default != null:
return $default(_that.items,_that.attribution);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Place> items,  String? attribution)  $default,) {final _that = this;
switch (_that) {
case _PlacesResponse():
return $default(_that.items,_that.attribution);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Place> items,  String? attribution)?  $default,) {final _that = this;
switch (_that) {
case _PlacesResponse() when $default != null:
return $default(_that.items,_that.attribution);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlacesResponse implements PlacesResponse {
  const _PlacesResponse({required  List<Place> items, this.attribution}): _items = items;
  factory _PlacesResponse.fromJson(Map<String, dynamic> json) => _$PlacesResponseFromJson(json);

 final  List<Place> _items;
@override List<Place> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? attribution;

/// Create a copy of PlacesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlacesResponseCopyWith<_PlacesResponse> get copyWith => __$PlacesResponseCopyWithImpl<_PlacesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlacesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlacesResponse&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.attribution, attribution) || other.attribution == attribution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),attribution);
}

@override
String toString() {
    return 'PlacesResponse(items: $items, attribution: $attribution)';
}


}

/// @nodoc
abstract mixin class _$PlacesResponseCopyWith<$Res> implements $PlacesResponseCopyWith<$Res> {
  factory _$PlacesResponseCopyWith(_PlacesResponse value, $Res Function(_PlacesResponse) _then) = __$PlacesResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Place> items, String? attribution
});




}
/// @nodoc
class __$PlacesResponseCopyWithImpl<$Res>
    implements _$PlacesResponseCopyWith<$Res> {
  __$PlacesResponseCopyWithImpl(this._self, this._then);

  final _PlacesResponse _self;
  final $Res Function(_PlacesResponse) _then;

/// Create a copy of PlacesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? attribution = freezed,}) {
  return _then(_PlacesResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Place>,attribution: freezed == attribution ? _self.attribution : attribution // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$JourneyPlace {

 String get name; double get lat; double get lon; String? get stopId; String? get stationId;
/// Create a copy of JourneyPlace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyPlaceCopyWith<JourneyPlace> get copyWith => _$JourneyPlaceCopyWithImpl<JourneyPlace>(this as JourneyPlace, _$identity);

  /// Serializes this JourneyPlace to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JourneyPlace;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneyPlace&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lon, _this.lon) || other.lon == _this.lon)&&(identical(other.stopId, _this.stopId) || other.stopId == _this.stopId)&&(identical(other.stationId, _this.stationId) || other.stationId == _this.stationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JourneyPlace;
  return Object.hash(runtimeType,_this.name,_this.lat,_this.lon,_this.stopId,_this.stationId);
}

@override
String toString() {
  final _this = this as JourneyPlace;
  return 'JourneyPlace(name: ${_this.name}, lat: ${_this.lat}, lon: ${_this.lon}, stopId: ${_this.stopId}, stationId: ${_this.stationId})';
}


}

/// @nodoc
abstract mixin class $JourneyPlaceCopyWith<$Res>  {
  factory $JourneyPlaceCopyWith(JourneyPlace value, $Res Function(JourneyPlace) _then) = _$JourneyPlaceCopyWithImpl;
@useResult
$Res call({
 String name, double lat, double lon, String? stopId, String? stationId
});




}
/// @nodoc
class _$JourneyPlaceCopyWithImpl<$Res>
    implements $JourneyPlaceCopyWith<$Res> {
  _$JourneyPlaceCopyWithImpl(this._self, this._then);

  final JourneyPlace _self;
  final $Res Function(JourneyPlace) _then;

/// Create a copy of JourneyPlace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? lat = null,Object? lon = null,Object? stopId = freezed,Object? stationId = freezed,}) {
  return _then(JourneyPlace(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,stopId: freezed == stopId ? _self.stopId : stopId // ignore: cast_nullable_to_non_nullable
as String?,stationId: freezed == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JourneyPlace].
extension JourneyPlacePatterns on JourneyPlace {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneyPlace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneyPlace() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneyPlace value)  $default,){
final _that = this;
switch (_that) {
case _JourneyPlace():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneyPlace value)?  $default,){
final _that = this;
switch (_that) {
case _JourneyPlace() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double lat,  double lon,  String? stopId,  String? stationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JourneyPlace() when $default != null:
return $default(_that.name,_that.lat,_that.lon,_that.stopId,_that.stationId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double lat,  double lon,  String? stopId,  String? stationId)  $default,) {final _that = this;
switch (_that) {
case _JourneyPlace():
return $default(_that.name,_that.lat,_that.lon,_that.stopId,_that.stationId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double lat,  double lon,  String? stopId,  String? stationId)?  $default,) {final _that = this;
switch (_that) {
case _JourneyPlace() when $default != null:
return $default(_that.name,_that.lat,_that.lon,_that.stopId,_that.stationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JourneyPlace implements JourneyPlace {
  const _JourneyPlace({required this.name, required this.lat, required this.lon, this.stopId, this.stationId});
  factory _JourneyPlace.fromJson(Map<String, dynamic> json) => _$JourneyPlaceFromJson(json);

@override final  String name;
@override final  double lat;
@override final  double lon;
@override final  String? stopId;
@override final  String? stationId;

/// Create a copy of JourneyPlace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyPlaceCopyWith<_JourneyPlace> get copyWith => __$JourneyPlaceCopyWithImpl<_JourneyPlace>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyPlaceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneyPlace&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.stopId, stopId) || other.stopId == stopId)&&(identical(other.stationId, stationId) || other.stationId == stationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,lat,lon,stopId,stationId);
}

@override
String toString() {
    return 'JourneyPlace(name: $name, lat: $lat, lon: $lon, stopId: $stopId, stationId: $stationId)';
}


}

/// @nodoc
abstract mixin class _$JourneyPlaceCopyWith<$Res> implements $JourneyPlaceCopyWith<$Res> {
  factory _$JourneyPlaceCopyWith(_JourneyPlace value, $Res Function(_JourneyPlace) _then) = __$JourneyPlaceCopyWithImpl;
@override @useResult
$Res call({
 String name, double lat, double lon, String? stopId, String? stationId
});




}
/// @nodoc
class __$JourneyPlaceCopyWithImpl<$Res>
    implements _$JourneyPlaceCopyWith<$Res> {
  __$JourneyPlaceCopyWithImpl(this._self, this._then);

  final _JourneyPlace _self;
  final $Res Function(_JourneyPlace) _then;

/// Create a copy of JourneyPlace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? lat = null,Object? lon = null,Object? stopId = freezed,Object? stationId = freezed,}) {
  return _then(_JourneyPlace(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,stopId: freezed == stopId ? _self.stopId : stopId // ignore: cast_nullable_to_non_nullable
as String?,stationId: freezed == stationId ? _self.stationId : stationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$IntermediateStop {

 String get stopId; String get name; double get lat; double get lon; DateTime? get scheduledDeparture;
/// Create a copy of IntermediateStop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntermediateStopCopyWith<IntermediateStop> get copyWith => _$IntermediateStopCopyWithImpl<IntermediateStop>(this as IntermediateStop, _$identity);

  /// Serializes this IntermediateStop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as IntermediateStop;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntermediateStop&&(identical(other.stopId, _this.stopId) || other.stopId == _this.stopId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.lat, _this.lat) || other.lat == _this.lat)&&(identical(other.lon, _this.lon) || other.lon == _this.lon)&&(identical(other.scheduledDeparture, _this.scheduledDeparture) || other.scheduledDeparture == _this.scheduledDeparture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as IntermediateStop;
  return Object.hash(runtimeType,_this.stopId,_this.name,_this.lat,_this.lon,_this.scheduledDeparture);
}

@override
String toString() {
  final _this = this as IntermediateStop;
  return 'IntermediateStop(stopId: ${_this.stopId}, name: ${_this.name}, lat: ${_this.lat}, lon: ${_this.lon}, scheduledDeparture: ${_this.scheduledDeparture})';
}


}

/// @nodoc
abstract mixin class $IntermediateStopCopyWith<$Res>  {
  factory $IntermediateStopCopyWith(IntermediateStop value, $Res Function(IntermediateStop) _then) = _$IntermediateStopCopyWithImpl;
@useResult
$Res call({
 String stopId, String name, double lat, double lon, DateTime? scheduledDeparture
});




}
/// @nodoc
class _$IntermediateStopCopyWithImpl<$Res>
    implements $IntermediateStopCopyWith<$Res> {
  _$IntermediateStopCopyWithImpl(this._self, this._then);

  final IntermediateStop _self;
  final $Res Function(IntermediateStop) _then;

/// Create a copy of IntermediateStop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stopId = null,Object? name = null,Object? lat = null,Object? lon = null,Object? scheduledDeparture = freezed,}) {
  return _then(IntermediateStop(
stopId: null == stopId ? _self.stopId : stopId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,scheduledDeparture: freezed == scheduledDeparture ? _self.scheduledDeparture : scheduledDeparture // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [IntermediateStop].
extension IntermediateStopPatterns on IntermediateStop {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IntermediateStop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IntermediateStop() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IntermediateStop value)  $default,){
final _that = this;
switch (_that) {
case _IntermediateStop():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IntermediateStop value)?  $default,){
final _that = this;
switch (_that) {
case _IntermediateStop() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stopId,  String name,  double lat,  double lon,  DateTime? scheduledDeparture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IntermediateStop() when $default != null:
return $default(_that.stopId,_that.name,_that.lat,_that.lon,_that.scheduledDeparture);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stopId,  String name,  double lat,  double lon,  DateTime? scheduledDeparture)  $default,) {final _that = this;
switch (_that) {
case _IntermediateStop():
return $default(_that.stopId,_that.name,_that.lat,_that.lon,_that.scheduledDeparture);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stopId,  String name,  double lat,  double lon,  DateTime? scheduledDeparture)?  $default,) {final _that = this;
switch (_that) {
case _IntermediateStop() when $default != null:
return $default(_that.stopId,_that.name,_that.lat,_that.lon,_that.scheduledDeparture);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IntermediateStop implements IntermediateStop {
  const _IntermediateStop({required this.stopId, required this.name, required this.lat, required this.lon, this.scheduledDeparture});
  factory _IntermediateStop.fromJson(Map<String, dynamic> json) => _$IntermediateStopFromJson(json);

@override final  String stopId;
@override final  String name;
@override final  double lat;
@override final  double lon;
@override final  DateTime? scheduledDeparture;

/// Create a copy of IntermediateStop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntermediateStopCopyWith<_IntermediateStop> get copyWith => __$IntermediateStopCopyWithImpl<_IntermediateStop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntermediateStopToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IntermediateStop&&(identical(other.stopId, stopId) || other.stopId == stopId)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.scheduledDeparture, scheduledDeparture) || other.scheduledDeparture == scheduledDeparture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,stopId,name,lat,lon,scheduledDeparture);
}

@override
String toString() {
    return 'IntermediateStop(stopId: $stopId, name: $name, lat: $lat, lon: $lon, scheduledDeparture: $scheduledDeparture)';
}


}

/// @nodoc
abstract mixin class _$IntermediateStopCopyWith<$Res> implements $IntermediateStopCopyWith<$Res> {
  factory _$IntermediateStopCopyWith(_IntermediateStop value, $Res Function(_IntermediateStop) _then) = __$IntermediateStopCopyWithImpl;
@override @useResult
$Res call({
 String stopId, String name, double lat, double lon, DateTime? scheduledDeparture
});




}
/// @nodoc
class __$IntermediateStopCopyWithImpl<$Res>
    implements _$IntermediateStopCopyWith<$Res> {
  __$IntermediateStopCopyWithImpl(this._self, this._then);

  final _IntermediateStop _self;
  final $Res Function(_IntermediateStop) _then;

/// Create a copy of IntermediateStop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stopId = null,Object? name = null,Object? lat = null,Object? lon = null,Object? scheduledDeparture = freezed,}) {
  return _then(_IntermediateStop(
stopId: null == stopId ? _self.stopId : stopId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,scheduledDeparture: freezed == scheduledDeparture ? _self.scheduledDeparture : scheduledDeparture // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$JourneyLeg {

 TransitMode get mode; DateTime get start; DateTime get end; int get durationS; int get distanceM; JourneyPlace get origin; JourneyPlace get destination; List<List<double>> get geometry; String get geometryBasis; String get basis; bool get timesApproximate; bool get isTransfer; RouteSummary? get route; String? get tripId; String? get headsign; DateTime? get serviceDate; List<IntermediateStop> get intermediateStops; String? get transferSource;
/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyLegCopyWith<JourneyLeg> get copyWith => _$JourneyLegCopyWithImpl<JourneyLeg>(this as JourneyLeg, _$identity);

  /// Serializes this JourneyLeg to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JourneyLeg;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneyLeg&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.durationS, _this.durationS) || other.durationS == _this.durationS)&&(identical(other.distanceM, _this.distanceM) || other.distanceM == _this.distanceM)&&(identical(other.origin, _this.origin) || other.origin == _this.origin)&&(identical(other.destination, _this.destination) || other.destination == _this.destination)&&const DeepCollectionEquality().equals(other.geometry, _this.geometry)&&(identical(other.geometryBasis, _this.geometryBasis) || other.geometryBasis == _this.geometryBasis)&&(identical(other.basis, _this.basis) || other.basis == _this.basis)&&(identical(other.timesApproximate, _this.timesApproximate) || other.timesApproximate == _this.timesApproximate)&&(identical(other.isTransfer, _this.isTransfer) || other.isTransfer == _this.isTransfer)&&(identical(other.route, _this.route) || other.route == _this.route)&&(identical(other.tripId, _this.tripId) || other.tripId == _this.tripId)&&(identical(other.headsign, _this.headsign) || other.headsign == _this.headsign)&&(identical(other.serviceDate, _this.serviceDate) || other.serviceDate == _this.serviceDate)&&const DeepCollectionEquality().equals(other.intermediateStops, _this.intermediateStops)&&(identical(other.transferSource, _this.transferSource) || other.transferSource == _this.transferSource));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JourneyLeg;
  return Object.hash(runtimeType,_this.mode,_this.start,_this.end,_this.durationS,_this.distanceM,_this.origin,_this.destination,const DeepCollectionEquality().hash(_this.geometry),_this.geometryBasis,_this.basis,_this.timesApproximate,_this.isTransfer,_this.route,_this.tripId,_this.headsign,_this.serviceDate,const DeepCollectionEquality().hash(_this.intermediateStops),_this.transferSource);
}

@override
String toString() {
  final _this = this as JourneyLeg;
  return 'JourneyLeg(mode: ${_this.mode}, start: ${_this.start}, end: ${_this.end}, durationS: ${_this.durationS}, distanceM: ${_this.distanceM}, origin: ${_this.origin}, destination: ${_this.destination}, geometry: ${_this.geometry}, geometryBasis: ${_this.geometryBasis}, basis: ${_this.basis}, timesApproximate: ${_this.timesApproximate}, isTransfer: ${_this.isTransfer}, route: ${_this.route}, tripId: ${_this.tripId}, headsign: ${_this.headsign}, serviceDate: ${_this.serviceDate}, intermediateStops: ${_this.intermediateStops}, transferSource: ${_this.transferSource})';
}


}

/// @nodoc
abstract mixin class $JourneyLegCopyWith<$Res>  {
  factory $JourneyLegCopyWith(JourneyLeg value, $Res Function(JourneyLeg) _then) = _$JourneyLegCopyWithImpl;
@useResult
$Res call({
 TransitMode mode, DateTime start, DateTime end, int durationS, int distanceM, JourneyPlace origin, JourneyPlace destination, List<List<double>> geometry, String geometryBasis, String basis, bool timesApproximate, bool isTransfer, RouteSummary? route, String? tripId, String? headsign, DateTime? serviceDate, List<IntermediateStop> intermediateStops, String? transferSource
});


$JourneyPlaceCopyWith<$Res> get origin;$JourneyPlaceCopyWith<$Res> get destination;$RouteSummaryCopyWith<$Res>? get route;

}
/// @nodoc
class _$JourneyLegCopyWithImpl<$Res>
    implements $JourneyLegCopyWith<$Res> {
  _$JourneyLegCopyWithImpl(this._self, this._then);

  final JourneyLeg _self;
  final $Res Function(JourneyLeg) _then;

/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? start = null,Object? end = null,Object? durationS = null,Object? distanceM = null,Object? origin = null,Object? destination = null,Object? geometry = null,Object? geometryBasis = null,Object? basis = null,Object? timesApproximate = null,Object? isTransfer = null,Object? route = freezed,Object? tripId = freezed,Object? headsign = freezed,Object? serviceDate = freezed,Object? intermediateStops = null,Object? transferSource = freezed,}) {
  return _then(JourneyLeg(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransitMode,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as JourneyPlace,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as JourneyPlace,geometry: null == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as List<List<double>>,geometryBasis: null == geometryBasis ? _self.geometryBasis : geometryBasis // ignore: cast_nullable_to_non_nullable
as String,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as String,timesApproximate: null == timesApproximate ? _self.timesApproximate : timesApproximate // ignore: cast_nullable_to_non_nullable
as bool,isTransfer: null == isTransfer ? _self.isTransfer : isTransfer // ignore: cast_nullable_to_non_nullable
as bool,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteSummary?,tripId: freezed == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String?,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,serviceDate: freezed == serviceDate ? _self.serviceDate : serviceDate // ignore: cast_nullable_to_non_nullable
as DateTime?,intermediateStops: null == intermediateStops ? _self.intermediateStops : intermediateStops // ignore: cast_nullable_to_non_nullable
as List<IntermediateStop>,transferSource: freezed == transferSource ? _self.transferSource : transferSource // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JourneyPlaceCopyWith<$Res> get origin {
  
  return $JourneyPlaceCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JourneyPlaceCopyWith<$Res> get destination {
  
  return $JourneyPlaceCopyWith<$Res>(_self.destination, (value) {
    return _then(_self.copyWith(destination: value));
  });
}/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryCopyWith<$Res>? get route {
    if (_self.route == null) {
    return null;
  }

  return $RouteSummaryCopyWith<$Res>(_self.route!, (value) {
    return _then(_self.copyWith(route: value));
  });
}
}


/// Adds pattern-matching-related methods to [JourneyLeg].
extension JourneyLegPatterns on JourneyLeg {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneyLeg value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneyLeg() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneyLeg value)  $default,){
final _that = this;
switch (_that) {
case _JourneyLeg():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneyLeg value)?  $default,){
final _that = this;
switch (_that) {
case _JourneyLeg() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransitMode mode,  DateTime start,  DateTime end,  int durationS,  int distanceM,  JourneyPlace origin,  JourneyPlace destination,  List<List<double>> geometry,  String geometryBasis,  String basis,  bool timesApproximate,  bool isTransfer,  RouteSummary? route,  String? tripId,  String? headsign,  DateTime? serviceDate,  List<IntermediateStop> intermediateStops,  String? transferSource)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JourneyLeg() when $default != null:
return $default(_that.mode,_that.start,_that.end,_that.durationS,_that.distanceM,_that.origin,_that.destination,_that.geometry,_that.geometryBasis,_that.basis,_that.timesApproximate,_that.isTransfer,_that.route,_that.tripId,_that.headsign,_that.serviceDate,_that.intermediateStops,_that.transferSource);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransitMode mode,  DateTime start,  DateTime end,  int durationS,  int distanceM,  JourneyPlace origin,  JourneyPlace destination,  List<List<double>> geometry,  String geometryBasis,  String basis,  bool timesApproximate,  bool isTransfer,  RouteSummary? route,  String? tripId,  String? headsign,  DateTime? serviceDate,  List<IntermediateStop> intermediateStops,  String? transferSource)  $default,) {final _that = this;
switch (_that) {
case _JourneyLeg():
return $default(_that.mode,_that.start,_that.end,_that.durationS,_that.distanceM,_that.origin,_that.destination,_that.geometry,_that.geometryBasis,_that.basis,_that.timesApproximate,_that.isTransfer,_that.route,_that.tripId,_that.headsign,_that.serviceDate,_that.intermediateStops,_that.transferSource);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransitMode mode,  DateTime start,  DateTime end,  int durationS,  int distanceM,  JourneyPlace origin,  JourneyPlace destination,  List<List<double>> geometry,  String geometryBasis,  String basis,  bool timesApproximate,  bool isTransfer,  RouteSummary? route,  String? tripId,  String? headsign,  DateTime? serviceDate,  List<IntermediateStop> intermediateStops,  String? transferSource)?  $default,) {final _that = this;
switch (_that) {
case _JourneyLeg() when $default != null:
return $default(_that.mode,_that.start,_that.end,_that.durationS,_that.distanceM,_that.origin,_that.destination,_that.geometry,_that.geometryBasis,_that.basis,_that.timesApproximate,_that.isTransfer,_that.route,_that.tripId,_that.headsign,_that.serviceDate,_that.intermediateStops,_that.transferSource);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JourneyLeg extends JourneyLeg {
  const _JourneyLeg({required this.mode, required this.start, required this.end, required this.durationS, required this.distanceM, required this.origin, required this.destination, required  List<List<double>> geometry, required this.geometryBasis, required this.basis, required this.timesApproximate, this.isTransfer = false, this.route, this.tripId, this.headsign, this.serviceDate,  List<IntermediateStop> intermediateStops = const <IntermediateStop>[], this.transferSource}): _geometry = geometry,_intermediateStops = intermediateStops,super._();
  factory _JourneyLeg.fromJson(Map<String, dynamic> json) => _$JourneyLegFromJson(json);

@override final  TransitMode mode;
@override final  DateTime start;
@override final  DateTime end;
@override final  int durationS;
@override final  int distanceM;
@override final  JourneyPlace origin;
@override final  JourneyPlace destination;
 final  List<List<double>> _geometry;
@override List<List<double>> get geometry {
  if (_geometry is EqualUnmodifiableListView) return _geometry;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_geometry);
}

@override final  String geometryBasis;
@override final  String basis;
@override final  bool timesApproximate;
@override@JsonKey() final  bool isTransfer;
@override final  RouteSummary? route;
@override final  String? tripId;
@override final  String? headsign;
@override final  DateTime? serviceDate;
 final  List<IntermediateStop> _intermediateStops;
@override@JsonKey() List<IntermediateStop> get intermediateStops {
  if (_intermediateStops is EqualUnmodifiableListView) return _intermediateStops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_intermediateStops);
}

@override final  String? transferSource;

/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyLegCopyWith<_JourneyLeg> get copyWith => __$JourneyLegCopyWithImpl<_JourneyLeg>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyLegToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneyLeg&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.destination, destination) || other.destination == destination)&&const DeepCollectionEquality().equals(other.geometry, _geometry)&&(identical(other.geometryBasis, geometryBasis) || other.geometryBasis == geometryBasis)&&(identical(other.basis, basis) || other.basis == basis)&&(identical(other.timesApproximate, timesApproximate) || other.timesApproximate == timesApproximate)&&(identical(other.isTransfer, isTransfer) || other.isTransfer == isTransfer)&&(identical(other.route, route) || other.route == route)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.headsign, headsign) || other.headsign == headsign)&&(identical(other.serviceDate, serviceDate) || other.serviceDate == serviceDate)&&const DeepCollectionEquality().equals(other.intermediateStops, _intermediateStops)&&(identical(other.transferSource, transferSource) || other.transferSource == transferSource));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,mode,start,end,durationS,distanceM,origin,destination,const DeepCollectionEquality().hash(_geometry),geometryBasis,basis,timesApproximate,isTransfer,route,tripId,headsign,serviceDate,const DeepCollectionEquality().hash(_intermediateStops),transferSource);
}

@override
String toString() {
    return 'JourneyLeg(mode: $mode, start: $start, end: $end, durationS: $durationS, distanceM: $distanceM, origin: $origin, destination: $destination, geometry: $geometry, geometryBasis: $geometryBasis, basis: $basis, timesApproximate: $timesApproximate, isTransfer: $isTransfer, route: $route, tripId: $tripId, headsign: $headsign, serviceDate: $serviceDate, intermediateStops: $intermediateStops, transferSource: $transferSource)';
}


}

/// @nodoc
abstract mixin class _$JourneyLegCopyWith<$Res> implements $JourneyLegCopyWith<$Res> {
  factory _$JourneyLegCopyWith(_JourneyLeg value, $Res Function(_JourneyLeg) _then) = __$JourneyLegCopyWithImpl;
@override @useResult
$Res call({
 TransitMode mode, DateTime start, DateTime end, int durationS, int distanceM, JourneyPlace origin, JourneyPlace destination, List<List<double>> geometry, String geometryBasis, String basis, bool timesApproximate, bool isTransfer, RouteSummary? route, String? tripId, String? headsign, DateTime? serviceDate, List<IntermediateStop> intermediateStops, String? transferSource
});


@override $JourneyPlaceCopyWith<$Res> get origin;@override $JourneyPlaceCopyWith<$Res> get destination;@override $RouteSummaryCopyWith<$Res>? get route;

}
/// @nodoc
class __$JourneyLegCopyWithImpl<$Res>
    implements _$JourneyLegCopyWith<$Res> {
  __$JourneyLegCopyWithImpl(this._self, this._then);

  final _JourneyLeg _self;
  final $Res Function(_JourneyLeg) _then;

/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? start = null,Object? end = null,Object? durationS = null,Object? distanceM = null,Object? origin = null,Object? destination = null,Object? geometry = null,Object? geometryBasis = null,Object? basis = null,Object? timesApproximate = null,Object? isTransfer = null,Object? route = freezed,Object? tripId = freezed,Object? headsign = freezed,Object? serviceDate = freezed,Object? intermediateStops = null,Object? transferSource = freezed,}) {
  return _then(_JourneyLeg(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TransitMode,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,distanceM: null == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as JourneyPlace,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as JourneyPlace,geometry: null == geometry ? _self._geometry : geometry // ignore: cast_nullable_to_non_nullable
as List<List<double>>,geometryBasis: null == geometryBasis ? _self.geometryBasis : geometryBasis // ignore: cast_nullable_to_non_nullable
as String,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as String,timesApproximate: null == timesApproximate ? _self.timesApproximate : timesApproximate // ignore: cast_nullable_to_non_nullable
as bool,isTransfer: null == isTransfer ? _self.isTransfer : isTransfer // ignore: cast_nullable_to_non_nullable
as bool,route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as RouteSummary?,tripId: freezed == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as String?,headsign: freezed == headsign ? _self.headsign : headsign // ignore: cast_nullable_to_non_nullable
as String?,serviceDate: freezed == serviceDate ? _self.serviceDate : serviceDate // ignore: cast_nullable_to_non_nullable
as DateTime?,intermediateStops: null == intermediateStops ? _self._intermediateStops : intermediateStops // ignore: cast_nullable_to_non_nullable
as List<IntermediateStop>,transferSource: freezed == transferSource ? _self.transferSource : transferSource // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JourneyPlaceCopyWith<$Res> get origin {
  
  return $JourneyPlaceCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JourneyPlaceCopyWith<$Res> get destination {
  
  return $JourneyPlaceCopyWith<$Res>(_self.destination, (value) {
    return _then(_self.copyWith(destination: value));
  });
}/// Create a copy of JourneyLeg
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RouteSummaryCopyWith<$Res>? get route {
    if (_self.route == null) {
    return null;
  }

  return $RouteSummaryCopyWith<$Res>(_self.route!, (value) {
    return _then(_self.copyWith(route: value));
  });
}
}


/// @nodoc
mixin _$Journey {

 String get id; DateTime get start; DateTime get end; int get durationS; int get transfers; int get walkDistanceM; List<String> get modes; List<JourneyLeg> get legs; String get basis;
/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyCopyWith<Journey> get copyWith => _$JourneyCopyWithImpl<Journey>(this as Journey, _$identity);

  /// Serializes this Journey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Journey;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Journey&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.durationS, _this.durationS) || other.durationS == _this.durationS)&&(identical(other.transfers, _this.transfers) || other.transfers == _this.transfers)&&(identical(other.walkDistanceM, _this.walkDistanceM) || other.walkDistanceM == _this.walkDistanceM)&&const DeepCollectionEquality().equals(other.modes, _this.modes)&&const DeepCollectionEquality().equals(other.legs, _this.legs)&&(identical(other.basis, _this.basis) || other.basis == _this.basis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Journey;
  return Object.hash(runtimeType,_this.id,_this.start,_this.end,_this.durationS,_this.transfers,_this.walkDistanceM,const DeepCollectionEquality().hash(_this.modes),const DeepCollectionEquality().hash(_this.legs),_this.basis);
}

@override
String toString() {
  final _this = this as Journey;
  return 'Journey(id: ${_this.id}, start: ${_this.start}, end: ${_this.end}, durationS: ${_this.durationS}, transfers: ${_this.transfers}, walkDistanceM: ${_this.walkDistanceM}, modes: ${_this.modes}, legs: ${_this.legs}, basis: ${_this.basis})';
}


}

/// @nodoc
abstract mixin class $JourneyCopyWith<$Res>  {
  factory $JourneyCopyWith(Journey value, $Res Function(Journey) _then) = _$JourneyCopyWithImpl;
@useResult
$Res call({
 String id, DateTime start, DateTime end, int durationS, int transfers, int walkDistanceM, List<String> modes, List<JourneyLeg> legs, String basis
});




}
/// @nodoc
class _$JourneyCopyWithImpl<$Res>
    implements $JourneyCopyWith<$Res> {
  _$JourneyCopyWithImpl(this._self, this._then);

  final Journey _self;
  final $Res Function(Journey) _then;

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? start = null,Object? end = null,Object? durationS = null,Object? transfers = null,Object? walkDistanceM = null,Object? modes = null,Object? legs = null,Object? basis = null,}) {
  return _then(Journey(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,transfers: null == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as int,walkDistanceM: null == walkDistanceM ? _self.walkDistanceM : walkDistanceM // ignore: cast_nullable_to_non_nullable
as int,modes: null == modes ? _self.modes : modes // ignore: cast_nullable_to_non_nullable
as List<String>,legs: null == legs ? _self.legs : legs // ignore: cast_nullable_to_non_nullable
as List<JourneyLeg>,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Journey].
extension JourneyPatterns on Journey {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Journey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Journey() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Journey value)  $default,){
final _that = this;
switch (_that) {
case _Journey():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Journey value)?  $default,){
final _that = this;
switch (_that) {
case _Journey() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime start,  DateTime end,  int durationS,  int transfers,  int walkDistanceM,  List<String> modes,  List<JourneyLeg> legs,  String basis)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Journey() when $default != null:
return $default(_that.id,_that.start,_that.end,_that.durationS,_that.transfers,_that.walkDistanceM,_that.modes,_that.legs,_that.basis);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime start,  DateTime end,  int durationS,  int transfers,  int walkDistanceM,  List<String> modes,  List<JourneyLeg> legs,  String basis)  $default,) {final _that = this;
switch (_that) {
case _Journey():
return $default(_that.id,_that.start,_that.end,_that.durationS,_that.transfers,_that.walkDistanceM,_that.modes,_that.legs,_that.basis);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime start,  DateTime end,  int durationS,  int transfers,  int walkDistanceM,  List<String> modes,  List<JourneyLeg> legs,  String basis)?  $default,) {final _that = this;
switch (_that) {
case _Journey() when $default != null:
return $default(_that.id,_that.start,_that.end,_that.durationS,_that.transfers,_that.walkDistanceM,_that.modes,_that.legs,_that.basis);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Journey extends Journey {
  const _Journey({required this.id, required this.start, required this.end, required this.durationS, required this.transfers, required this.walkDistanceM, required  List<String> modes, required  List<JourneyLeg> legs, required this.basis}): _modes = modes,_legs = legs,super._();
  factory _Journey.fromJson(Map<String, dynamic> json) => _$JourneyFromJson(json);

@override final  String id;
@override final  DateTime start;
@override final  DateTime end;
@override final  int durationS;
@override final  int transfers;
@override final  int walkDistanceM;
 final  List<String> _modes;
@override List<String> get modes {
  if (_modes is EqualUnmodifiableListView) return _modes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modes);
}

 final  List<JourneyLeg> _legs;
@override List<JourneyLeg> get legs {
  if (_legs is EqualUnmodifiableListView) return _legs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_legs);
}

@override final  String basis;

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyCopyWith<_Journey> get copyWith => __$JourneyCopyWithImpl<_Journey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Journey&&(identical(other.id, id) || other.id == id)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.durationS, durationS) || other.durationS == durationS)&&(identical(other.transfers, transfers) || other.transfers == transfers)&&(identical(other.walkDistanceM, walkDistanceM) || other.walkDistanceM == walkDistanceM)&&const DeepCollectionEquality().equals(other.modes, _modes)&&const DeepCollectionEquality().equals(other.legs, _legs)&&(identical(other.basis, basis) || other.basis == basis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,start,end,durationS,transfers,walkDistanceM,const DeepCollectionEquality().hash(_modes),const DeepCollectionEquality().hash(_legs),basis);
}

@override
String toString() {
    return 'Journey(id: $id, start: $start, end: $end, durationS: $durationS, transfers: $transfers, walkDistanceM: $walkDistanceM, modes: $modes, legs: $legs, basis: $basis)';
}


}

/// @nodoc
abstract mixin class _$JourneyCopyWith<$Res> implements $JourneyCopyWith<$Res> {
  factory _$JourneyCopyWith(_Journey value, $Res Function(_Journey) _then) = __$JourneyCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime start, DateTime end, int durationS, int transfers, int walkDistanceM, List<String> modes, List<JourneyLeg> legs, String basis
});




}
/// @nodoc
class __$JourneyCopyWithImpl<$Res>
    implements _$JourneyCopyWith<$Res> {
  __$JourneyCopyWithImpl(this._self, this._then);

  final _Journey _self;
  final $Res Function(_Journey) _then;

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? start = null,Object? end = null,Object? durationS = null,Object? transfers = null,Object? walkDistanceM = null,Object? modes = null,Object? legs = null,Object? basis = null,}) {
  return _then(_Journey(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,durationS: null == durationS ? _self.durationS : durationS // ignore: cast_nullable_to_non_nullable
as int,transfers: null == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as int,walkDistanceM: null == walkDistanceM ? _self.walkDistanceM : walkDistanceM // ignore: cast_nullable_to_non_nullable
as int,modes: null == modes ? _self._modes : modes // ignore: cast_nullable_to_non_nullable
as List<String>,legs: null == legs ? _self._legs : legs // ignore: cast_nullable_to_non_nullable
as List<JourneyLeg>,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RoutingProblem {

 String get code; String get message;
/// Create a copy of RoutingProblem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoutingProblemCopyWith<RoutingProblem> get copyWith => _$RoutingProblemCopyWithImpl<RoutingProblem>(this as RoutingProblem, _$identity);

  /// Serializes this RoutingProblem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RoutingProblem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoutingProblem&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.message, _this.message) || other.message == _this.message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RoutingProblem;
  return Object.hash(runtimeType,_this.code,_this.message);
}

@override
String toString() {
  final _this = this as RoutingProblem;
  return 'RoutingProblem(code: ${_this.code}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $RoutingProblemCopyWith<$Res>  {
  factory $RoutingProblemCopyWith(RoutingProblem value, $Res Function(RoutingProblem) _then) = _$RoutingProblemCopyWithImpl;
@useResult
$Res call({
 String code, String message
});




}
/// @nodoc
class _$RoutingProblemCopyWithImpl<$Res>
    implements $RoutingProblemCopyWith<$Res> {
  _$RoutingProblemCopyWithImpl(this._self, this._then);

  final RoutingProblem _self;
  final $Res Function(RoutingProblem) _then;

/// Create a copy of RoutingProblem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,}) {
  return _then(RoutingProblem(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RoutingProblem].
extension RoutingProblemPatterns on RoutingProblem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoutingProblem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoutingProblem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoutingProblem value)  $default,){
final _that = this;
switch (_that) {
case _RoutingProblem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoutingProblem value)?  $default,){
final _that = this;
switch (_that) {
case _RoutingProblem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoutingProblem() when $default != null:
return $default(_that.code,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message)  $default,) {final _that = this;
switch (_that) {
case _RoutingProblem():
return $default(_that.code,_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message)?  $default,) {final _that = this;
switch (_that) {
case _RoutingProblem() when $default != null:
return $default(_that.code,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoutingProblem implements RoutingProblem {
  const _RoutingProblem({required this.code, required this.message});
  factory _RoutingProblem.fromJson(Map<String, dynamic> json) => _$RoutingProblemFromJson(json);

@override final  String code;
@override final  String message;

/// Create a copy of RoutingProblem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoutingProblemCopyWith<_RoutingProblem> get copyWith => __$RoutingProblemCopyWithImpl<_RoutingProblem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoutingProblemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoutingProblem&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,message);
}

@override
String toString() {
    return 'RoutingProblem(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class _$RoutingProblemCopyWith<$Res> implements $RoutingProblemCopyWith<$Res> {
  factory _$RoutingProblemCopyWith(_RoutingProblem value, $Res Function(_RoutingProblem) _then) = __$RoutingProblemCopyWithImpl;
@override @useResult
$Res call({
 String code, String message
});




}
/// @nodoc
class __$RoutingProblemCopyWithImpl<$Res>
    implements _$RoutingProblemCopyWith<$Res> {
  __$RoutingProblemCopyWithImpl(this._self, this._then);

  final _RoutingProblem _self;
  final $Res Function(_RoutingProblem) _then;

/// Create a copy of RoutingProblem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,}) {
  return _then(_RoutingProblem(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$JourneysResponse {

 List<Journey> get items; Meta get meta; List<RoutingProblem> get routingErrors;
/// Create a copy of JourneysResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneysResponseCopyWith<JourneysResponse> get copyWith => _$JourneysResponseCopyWithImpl<JourneysResponse>(this as JourneysResponse, _$identity);

  /// Serializes this JourneysResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JourneysResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneysResponse&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.meta, _this.meta) || other.meta == _this.meta)&&const DeepCollectionEquality().equals(other.routingErrors, _this.routingErrors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JourneysResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.meta,const DeepCollectionEquality().hash(_this.routingErrors));
}

@override
String toString() {
  final _this = this as JourneysResponse;
  return 'JourneysResponse(items: ${_this.items}, meta: ${_this.meta}, routingErrors: ${_this.routingErrors})';
}


}

/// @nodoc
abstract mixin class $JourneysResponseCopyWith<$Res>  {
  factory $JourneysResponseCopyWith(JourneysResponse value, $Res Function(JourneysResponse) _then) = _$JourneysResponseCopyWithImpl;
@useResult
$Res call({
 List<Journey> items, Meta meta, List<RoutingProblem> routingErrors
});


$MetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$JourneysResponseCopyWithImpl<$Res>
    implements $JourneysResponseCopyWith<$Res> {
  _$JourneysResponseCopyWithImpl(this._self, this._then);

  final JourneysResponse _self;
  final $Res Function(JourneysResponse) _then;

/// Create a copy of JourneysResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? meta = null,Object? routingErrors = null,}) {
  return _then(JourneysResponse(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Journey>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,routingErrors: null == routingErrors ? _self.routingErrors : routingErrors // ignore: cast_nullable_to_non_nullable
as List<RoutingProblem>,
  ));
}
/// Create a copy of JourneysResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [JourneysResponse].
extension JourneysResponsePatterns on JourneysResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneysResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneysResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneysResponse value)  $default,){
final _that = this;
switch (_that) {
case _JourneysResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneysResponse value)?  $default,){
final _that = this;
switch (_that) {
case _JourneysResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Journey> items,  Meta meta,  List<RoutingProblem> routingErrors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JourneysResponse() when $default != null:
return $default(_that.items,_that.meta,_that.routingErrors);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Journey> items,  Meta meta,  List<RoutingProblem> routingErrors)  $default,) {final _that = this;
switch (_that) {
case _JourneysResponse():
return $default(_that.items,_that.meta,_that.routingErrors);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Journey> items,  Meta meta,  List<RoutingProblem> routingErrors)?  $default,) {final _that = this;
switch (_that) {
case _JourneysResponse() when $default != null:
return $default(_that.items,_that.meta,_that.routingErrors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JourneysResponse implements JourneysResponse {
  const _JourneysResponse({required  List<Journey> items, required this.meta,  List<RoutingProblem> routingErrors = const <RoutingProblem>[]}): _items = items,_routingErrors = routingErrors;
  factory _JourneysResponse.fromJson(Map<String, dynamic> json) => _$JourneysResponseFromJson(json);

 final  List<Journey> _items;
@override List<Journey> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Meta meta;
 final  List<RoutingProblem> _routingErrors;
@override@JsonKey() List<RoutingProblem> get routingErrors {
  if (_routingErrors is EqualUnmodifiableListView) return _routingErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routingErrors);
}


/// Create a copy of JourneysResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneysResponseCopyWith<_JourneysResponse> get copyWith => __$JourneysResponseCopyWithImpl<_JourneysResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneysResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneysResponse&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.meta, meta) || other.meta == meta)&&const DeepCollectionEquality().equals(other.routingErrors, _routingErrors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta,const DeepCollectionEquality().hash(_routingErrors));
}

@override
String toString() {
    return 'JourneysResponse(items: $items, meta: $meta, routingErrors: $routingErrors)';
}


}

/// @nodoc
abstract mixin class _$JourneysResponseCopyWith<$Res> implements $JourneysResponseCopyWith<$Res> {
  factory _$JourneysResponseCopyWith(_JourneysResponse value, $Res Function(_JourneysResponse) _then) = __$JourneysResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Journey> items, Meta meta, List<RoutingProblem> routingErrors
});


@override $MetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$JourneysResponseCopyWithImpl<$Res>
    implements _$JourneysResponseCopyWith<$Res> {
  __$JourneysResponseCopyWithImpl(this._self, this._then);

  final _JourneysResponse _self;
  final $Res Function(_JourneysResponse) _then;

/// Create a copy of JourneysResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,Object? routingErrors = null,}) {
  return _then(_JourneysResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Journey>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as Meta,routingErrors: null == routingErrors ? _self._routingErrors : routingErrors // ignore: cast_nullable_to_non_nullable
as List<RoutingProblem>,
  ));
}

/// Create a copy of JourneysResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaCopyWith<$Res> get meta {
  
  return $MetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
