// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatConfig {

 String get prompt; String get url; String get key; String get model; int get historyLen; String get id; String get name; String? get genTitlePrompt; String? get genTitleModel; String? get imgModel; String? get azureApiVersion; String? get azureDeploymentName;
/// Create a copy of ChatConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatConfigCopyWith<ChatConfig> get copyWith => _$ChatConfigCopyWithImpl<ChatConfig>(this as ChatConfig, _$identity);

  /// Serializes this ChatConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatConfig&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.url, url) || other.url == url)&&(identical(other.key, key) || other.key == key)&&(identical(other.model, model) || other.model == model)&&(identical(other.historyLen, historyLen) || other.historyLen == historyLen)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.genTitlePrompt, genTitlePrompt) || other.genTitlePrompt == genTitlePrompt)&&(identical(other.genTitleModel, genTitleModel) || other.genTitleModel == genTitleModel)&&(identical(other.imgModel, imgModel) || other.imgModel == imgModel)&&(identical(other.azureApiVersion, azureApiVersion) || other.azureApiVersion == azureApiVersion)&&(identical(other.azureDeploymentName, azureDeploymentName) || other.azureDeploymentName == azureDeploymentName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prompt,url,key,model,historyLen,id,name,genTitlePrompt,genTitleModel,imgModel,azureApiVersion,azureDeploymentName);



}

/// @nodoc
abstract mixin class $ChatConfigCopyWith<$Res>  {
  factory $ChatConfigCopyWith(ChatConfig value, $Res Function(ChatConfig) _then) = _$ChatConfigCopyWithImpl;
@useResult
$Res call({
 String prompt, String url, String key, String model, int historyLen, String id, String name, String? genTitlePrompt, String? genTitleModel, String? imgModel, String? azureApiVersion, String? azureDeploymentName
});




}
/// @nodoc
class _$ChatConfigCopyWithImpl<$Res>
    implements $ChatConfigCopyWith<$Res> {
  _$ChatConfigCopyWithImpl(this._self, this._then);

  final ChatConfig _self;
  final $Res Function(ChatConfig) _then;

/// Create a copy of ChatConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prompt = null,Object? url = null,Object? key = null,Object? model = null,Object? historyLen = null,Object? id = null,Object? name = null,Object? genTitlePrompt = freezed,Object? genTitleModel = freezed,Object? imgModel = freezed,Object? azureApiVersion = freezed,Object? azureDeploymentName = freezed,}) {
  return _then(_self.copyWith(
prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,historyLen: null == historyLen ? _self.historyLen : historyLen // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,genTitlePrompt: freezed == genTitlePrompt ? _self.genTitlePrompt : genTitlePrompt // ignore: cast_nullable_to_non_nullable
as String?,genTitleModel: freezed == genTitleModel ? _self.genTitleModel : genTitleModel // ignore: cast_nullable_to_non_nullable
as String?,imgModel: freezed == imgModel ? _self.imgModel : imgModel // ignore: cast_nullable_to_non_nullable
as String?,azureApiVersion: freezed == azureApiVersion ? _self.azureApiVersion : azureApiVersion // ignore: cast_nullable_to_non_nullable
as String?,azureDeploymentName: freezed == azureDeploymentName ? _self.azureDeploymentName : azureDeploymentName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatConfig].
extension ChatConfigPatterns on ChatConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatConfig value)  $default,){
final _that = this;
switch (_that) {
case _ChatConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ChatConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String prompt,  String url,  String key,  String model,  int historyLen,  String id,  String name,  String? genTitlePrompt,  String? genTitleModel,  String? imgModel,  String? azureApiVersion,  String? azureDeploymentName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatConfig() when $default != null:
return $default(_that.prompt,_that.url,_that.key,_that.model,_that.historyLen,_that.id,_that.name,_that.genTitlePrompt,_that.genTitleModel,_that.imgModel,_that.azureApiVersion,_that.azureDeploymentName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String prompt,  String url,  String key,  String model,  int historyLen,  String id,  String name,  String? genTitlePrompt,  String? genTitleModel,  String? imgModel,  String? azureApiVersion,  String? azureDeploymentName)  $default,) {final _that = this;
switch (_that) {
case _ChatConfig():
return $default(_that.prompt,_that.url,_that.key,_that.model,_that.historyLen,_that.id,_that.name,_that.genTitlePrompt,_that.genTitleModel,_that.imgModel,_that.azureApiVersion,_that.azureDeploymentName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String prompt,  String url,  String key,  String model,  int historyLen,  String id,  String name,  String? genTitlePrompt,  String? genTitleModel,  String? imgModel,  String? azureApiVersion,  String? azureDeploymentName)?  $default,) {final _that = this;
switch (_that) {
case _ChatConfig() when $default != null:
return $default(_that.prompt,_that.url,_that.key,_that.model,_that.historyLen,_that.id,_that.name,_that.genTitlePrompt,_that.genTitleModel,_that.imgModel,_that.azureApiVersion,_that.azureDeploymentName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatConfig extends ChatConfig {
  const _ChatConfig({this.prompt = '', this.url = ChatConfigX.defaultUrl, this.key = '', this.model = '', this.historyLen = ChatConfigX.defaultHistoryLen, this.id = ChatConfigX.defaultId, this.name = '', this.genTitlePrompt, this.genTitleModel, this.imgModel, this.azureApiVersion, this.azureDeploymentName}): super._();
  factory _ChatConfig.fromJson(Map<String, dynamic> json) => _$ChatConfigFromJson(json);

@override@JsonKey() final  String prompt;
@override@JsonKey() final  String url;
@override@JsonKey() final  String key;
@override@JsonKey() final  String model;
@override@JsonKey() final  int historyLen;
@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override final  String? genTitlePrompt;
@override final  String? genTitleModel;
@override final  String? imgModel;
@override final  String? azureApiVersion;
@override final  String? azureDeploymentName;

/// Create a copy of ChatConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatConfigCopyWith<_ChatConfig> get copyWith => __$ChatConfigCopyWithImpl<_ChatConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatConfig&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.url, url) || other.url == url)&&(identical(other.key, key) || other.key == key)&&(identical(other.model, model) || other.model == model)&&(identical(other.historyLen, historyLen) || other.historyLen == historyLen)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.genTitlePrompt, genTitlePrompt) || other.genTitlePrompt == genTitlePrompt)&&(identical(other.genTitleModel, genTitleModel) || other.genTitleModel == genTitleModel)&&(identical(other.imgModel, imgModel) || other.imgModel == imgModel)&&(identical(other.azureApiVersion, azureApiVersion) || other.azureApiVersion == azureApiVersion)&&(identical(other.azureDeploymentName, azureDeploymentName) || other.azureDeploymentName == azureDeploymentName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,prompt,url,key,model,historyLen,id,name,genTitlePrompt,genTitleModel,imgModel,azureApiVersion,azureDeploymentName);



}

/// @nodoc
abstract mixin class _$ChatConfigCopyWith<$Res> implements $ChatConfigCopyWith<$Res> {
  factory _$ChatConfigCopyWith(_ChatConfig value, $Res Function(_ChatConfig) _then) = __$ChatConfigCopyWithImpl;
@override @useResult
$Res call({
 String prompt, String url, String key, String model, int historyLen, String id, String name, String? genTitlePrompt, String? genTitleModel, String? imgModel, String? azureApiVersion, String? azureDeploymentName
});




}
/// @nodoc
class __$ChatConfigCopyWithImpl<$Res>
    implements _$ChatConfigCopyWith<$Res> {
  __$ChatConfigCopyWithImpl(this._self, this._then);

  final _ChatConfig _self;
  final $Res Function(_ChatConfig) _then;

/// Create a copy of ChatConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prompt = null,Object? url = null,Object? key = null,Object? model = null,Object? historyLen = null,Object? id = null,Object? name = null,Object? genTitlePrompt = freezed,Object? genTitleModel = freezed,Object? imgModel = freezed,Object? azureApiVersion = freezed,Object? azureDeploymentName = freezed,}) {
  return _then(_ChatConfig(
prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,historyLen: null == historyLen ? _self.historyLen : historyLen // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,genTitlePrompt: freezed == genTitlePrompt ? _self.genTitlePrompt : genTitlePrompt // ignore: cast_nullable_to_non_nullable
as String?,genTitleModel: freezed == genTitleModel ? _self.genTitleModel : genTitleModel // ignore: cast_nullable_to_non_nullable
as String?,imgModel: freezed == imgModel ? _self.imgModel : imgModel // ignore: cast_nullable_to_non_nullable
as String?,azureApiVersion: freezed == azureApiVersion ? _self.azureApiVersion : azureApiVersion // ignore: cast_nullable_to_non_nullable
as String?,azureDeploymentName: freezed == azureDeploymentName ? _self.azureDeploymentName : azureDeploymentName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
