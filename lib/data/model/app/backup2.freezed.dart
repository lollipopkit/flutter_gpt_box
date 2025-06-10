// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupV2 {

 int get version; int get date; Map<String, Object?> get cfgs; Map<String, Object?> get tools; Map<String, Object?> get histories; Map<String, Object?> get trashes;
/// Create a copy of BackupV2
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupV2CopyWith<BackupV2> get copyWith => _$BackupV2CopyWithImpl<BackupV2>(this as BackupV2, _$identity);

  /// Serializes this BackupV2 to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupV2&&(identical(other.version, version) || other.version == version)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.cfgs, cfgs)&&const DeepCollectionEquality().equals(other.tools, tools)&&const DeepCollectionEquality().equals(other.histories, histories)&&const DeepCollectionEquality().equals(other.trashes, trashes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,date,const DeepCollectionEquality().hash(cfgs),const DeepCollectionEquality().hash(tools),const DeepCollectionEquality().hash(histories),const DeepCollectionEquality().hash(trashes));

@override
String toString() {
  return 'BackupV2(version: $version, date: $date, cfgs: $cfgs, tools: $tools, histories: $histories, trashes: $trashes)';
}


}

/// @nodoc
abstract mixin class $BackupV2CopyWith<$Res>  {
  factory $BackupV2CopyWith(BackupV2 value, $Res Function(BackupV2) _then) = _$BackupV2CopyWithImpl;
@useResult
$Res call({
 int version, int date, Map<String, Object?> cfgs, Map<String, Object?> tools, Map<String, Object?> histories, Map<String, Object?> trashes
});




}
/// @nodoc
class _$BackupV2CopyWithImpl<$Res>
    implements $BackupV2CopyWith<$Res> {
  _$BackupV2CopyWithImpl(this._self, this._then);

  final BackupV2 _self;
  final $Res Function(BackupV2) _then;

/// Create a copy of BackupV2
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? date = null,Object? cfgs = null,Object? tools = null,Object? histories = null,Object? trashes = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as int,cfgs: null == cfgs ? _self.cfgs : cfgs // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,tools: null == tools ? _self.tools : tools // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,histories: null == histories ? _self.histories : histories // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,trashes: null == trashes ? _self.trashes : trashes // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BackupV2 extends BackupV2 {
  const _BackupV2({required this.version, required this.date, required final  Map<String, Object?> cfgs, required final  Map<String, Object?> tools, required final  Map<String, Object?> histories, required final  Map<String, Object?> trashes}): _cfgs = cfgs,_tools = tools,_histories = histories,_trashes = trashes,super._();
  factory _BackupV2.fromJson(Map<String, dynamic> json) => _$BackupV2FromJson(json);

@override final  int version;
@override final  int date;
 final  Map<String, Object?> _cfgs;
@override Map<String, Object?> get cfgs {
  if (_cfgs is EqualUnmodifiableMapView) return _cfgs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_cfgs);
}

 final  Map<String, Object?> _tools;
@override Map<String, Object?> get tools {
  if (_tools is EqualUnmodifiableMapView) return _tools;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_tools);
}

 final  Map<String, Object?> _histories;
@override Map<String, Object?> get histories {
  if (_histories is EqualUnmodifiableMapView) return _histories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_histories);
}

 final  Map<String, Object?> _trashes;
@override Map<String, Object?> get trashes {
  if (_trashes is EqualUnmodifiableMapView) return _trashes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_trashes);
}


/// Create a copy of BackupV2
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupV2CopyWith<_BackupV2> get copyWith => __$BackupV2CopyWithImpl<_BackupV2>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupV2ToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupV2&&(identical(other.version, version) || other.version == version)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._cfgs, _cfgs)&&const DeepCollectionEquality().equals(other._tools, _tools)&&const DeepCollectionEquality().equals(other._histories, _histories)&&const DeepCollectionEquality().equals(other._trashes, _trashes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,date,const DeepCollectionEquality().hash(_cfgs),const DeepCollectionEquality().hash(_tools),const DeepCollectionEquality().hash(_histories),const DeepCollectionEquality().hash(_trashes));

@override
String toString() {
  return 'BackupV2(version: $version, date: $date, cfgs: $cfgs, tools: $tools, histories: $histories, trashes: $trashes)';
}


}

/// @nodoc
abstract mixin class _$BackupV2CopyWith<$Res> implements $BackupV2CopyWith<$Res> {
  factory _$BackupV2CopyWith(_BackupV2 value, $Res Function(_BackupV2) _then) = __$BackupV2CopyWithImpl;
@override @useResult
$Res call({
 int version, int date, Map<String, Object?> cfgs, Map<String, Object?> tools, Map<String, Object?> histories, Map<String, Object?> trashes
});




}
/// @nodoc
class __$BackupV2CopyWithImpl<$Res>
    implements _$BackupV2CopyWith<$Res> {
  __$BackupV2CopyWithImpl(this._self, this._then);

  final _BackupV2 _self;
  final $Res Function(_BackupV2) _then;

/// Create a copy of BackupV2
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? date = null,Object? cfgs = null,Object? tools = null,Object? histories = null,Object? trashes = null,}) {
  return _then(_BackupV2(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as int,cfgs: null == cfgs ? _self._cfgs : cfgs // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,tools: null == tools ? _self._tools : tools // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,histories: null == histories ? _self._histories : histories // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,trashes: null == trashes ? _self._trashes : trashes // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
