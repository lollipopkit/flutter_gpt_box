// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatConfig _$ChatConfigFromJson(Map<String, dynamic> json) {
  return _ChatConfig.fromJson(json);
}

/// @nodoc
mixin _$ChatConfig {
  @HiveField(0, defaultValue: '')
  String get prompt => throw _privateConstructorUsedError;
  @HiveField(1, defaultValue: ChatConfigX.defaultUrl)
  String get url => throw _privateConstructorUsedError;
  @HiveField(2, defaultValue: '')
  String get key => throw _privateConstructorUsedError;
  @HiveField(3, defaultValue: '')
  String get model => throw _privateConstructorUsedError;
  @HiveField(7, defaultValue: ChatConfigX.defaultHistoryLen)
  int get historyLen => throw _privateConstructorUsedError;
  @HiveField(8, defaultValue: ChatConfigX.defaultId)
  @JsonKey(defaultValue: ChatConfigX.defaultId)
  String get id => throw _privateConstructorUsedError;
  @HiveField(9, defaultValue: '')
  String get name => throw _privateConstructorUsedError;
  @HiveField(14)
  String? get genTitlePrompt => throw _privateConstructorUsedError;
  @HiveField(15)
  String? get genTitleModel => throw _privateConstructorUsedError;
  @HiveField(16)
  String? get imgModel => throw _privateConstructorUsedError;

  /// Serializes this ChatConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatConfigCopyWith<ChatConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatConfigCopyWith<$Res> {
  factory $ChatConfigCopyWith(
          ChatConfig value, $Res Function(ChatConfig) then) =
      _$ChatConfigCopyWithImpl<$Res, ChatConfig>;
  @useResult
  $Res call(
      {@HiveField(0, defaultValue: '') String prompt,
      @HiveField(1, defaultValue: ChatConfigX.defaultUrl) String url,
      @HiveField(2, defaultValue: '') String key,
      @HiveField(3, defaultValue: '') String model,
      @HiveField(7, defaultValue: ChatConfigX.defaultHistoryLen) int historyLen,
      @HiveField(8, defaultValue: ChatConfigX.defaultId)
      @JsonKey(defaultValue: ChatConfigX.defaultId)
      String id,
      @HiveField(9, defaultValue: '') String name,
      @HiveField(14) String? genTitlePrompt,
      @HiveField(15) String? genTitleModel,
      @HiveField(16) String? imgModel});
}

/// @nodoc
class _$ChatConfigCopyWithImpl<$Res, $Val extends ChatConfig>
    implements $ChatConfigCopyWith<$Res> {
  _$ChatConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = null,
    Object? url = null,
    Object? key = null,
    Object? model = null,
    Object? historyLen = null,
    Object? id = null,
    Object? name = null,
    Object? genTitlePrompt = freezed,
    Object? genTitleModel = freezed,
    Object? imgModel = freezed,
  }) {
    return _then(_value.copyWith(
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      historyLen: null == historyLen
          ? _value.historyLen
          : historyLen // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      genTitlePrompt: freezed == genTitlePrompt
          ? _value.genTitlePrompt
          : genTitlePrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      genTitleModel: freezed == genTitleModel
          ? _value.genTitleModel
          : genTitleModel // ignore: cast_nullable_to_non_nullable
              as String?,
      imgModel: freezed == imgModel
          ? _value.imgModel
          : imgModel // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatConfigImplCopyWith<$Res>
    implements $ChatConfigCopyWith<$Res> {
  factory _$$ChatConfigImplCopyWith(
          _$ChatConfigImpl value, $Res Function(_$ChatConfigImpl) then) =
      __$$ChatConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0, defaultValue: '') String prompt,
      @HiveField(1, defaultValue: ChatConfigX.defaultUrl) String url,
      @HiveField(2, defaultValue: '') String key,
      @HiveField(3, defaultValue: '') String model,
      @HiveField(7, defaultValue: ChatConfigX.defaultHistoryLen) int historyLen,
      @HiveField(8, defaultValue: ChatConfigX.defaultId)
      @JsonKey(defaultValue: ChatConfigX.defaultId)
      String id,
      @HiveField(9, defaultValue: '') String name,
      @HiveField(14) String? genTitlePrompt,
      @HiveField(15) String? genTitleModel,
      @HiveField(16) String? imgModel});
}

/// @nodoc
class __$$ChatConfigImplCopyWithImpl<$Res>
    extends _$ChatConfigCopyWithImpl<$Res, _$ChatConfigImpl>
    implements _$$ChatConfigImplCopyWith<$Res> {
  __$$ChatConfigImplCopyWithImpl(
      _$ChatConfigImpl _value, $Res Function(_$ChatConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = null,
    Object? url = null,
    Object? key = null,
    Object? model = null,
    Object? historyLen = null,
    Object? id = null,
    Object? name = null,
    Object? genTitlePrompt = freezed,
    Object? genTitleModel = freezed,
    Object? imgModel = freezed,
  }) {
    return _then(_$ChatConfigImpl(
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      historyLen: null == historyLen
          ? _value.historyLen
          : historyLen // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      genTitlePrompt: freezed == genTitlePrompt
          ? _value.genTitlePrompt
          : genTitlePrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      genTitleModel: freezed == genTitleModel
          ? _value.genTitleModel
          : genTitleModel // ignore: cast_nullable_to_non_nullable
              as String?,
      imgModel: freezed == imgModel
          ? _value.imgModel
          : imgModel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatConfigImpl implements _ChatConfig {
  const _$ChatConfigImpl(
      {@HiveField(0, defaultValue: '') required this.prompt,
      @HiveField(1, defaultValue: ChatConfigX.defaultUrl) required this.url,
      @HiveField(2, defaultValue: '') required this.key,
      @HiveField(3, defaultValue: '') required this.model,
      @HiveField(7, defaultValue: ChatConfigX.defaultHistoryLen)
      required this.historyLen,
      @HiveField(8, defaultValue: ChatConfigX.defaultId)
      @JsonKey(defaultValue: ChatConfigX.defaultId)
      required this.id,
      @HiveField(9, defaultValue: '') required this.name,
      @HiveField(14) this.genTitlePrompt,
      @HiveField(15) this.genTitleModel,
      @HiveField(16) this.imgModel});

  factory _$ChatConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatConfigImplFromJson(json);

  @override
  @HiveField(0, defaultValue: '')
  final String prompt;
  @override
  @HiveField(1, defaultValue: ChatConfigX.defaultUrl)
  final String url;
  @override
  @HiveField(2, defaultValue: '')
  final String key;
  @override
  @HiveField(3, defaultValue: '')
  final String model;
  @override
  @HiveField(7, defaultValue: ChatConfigX.defaultHistoryLen)
  final int historyLen;
  @override
  @HiveField(8, defaultValue: ChatConfigX.defaultId)
  @JsonKey(defaultValue: ChatConfigX.defaultId)
  final String id;
  @override
  @HiveField(9, defaultValue: '')
  final String name;
  @override
  @HiveField(14)
  final String? genTitlePrompt;
  @override
  @HiveField(15)
  final String? genTitleModel;
  @override
  @HiveField(16)
  final String? imgModel;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatConfigImpl &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.historyLen, historyLen) ||
                other.historyLen == historyLen) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.genTitlePrompt, genTitlePrompt) ||
                other.genTitlePrompt == genTitlePrompt) &&
            (identical(other.genTitleModel, genTitleModel) ||
                other.genTitleModel == genTitleModel) &&
            (identical(other.imgModel, imgModel) ||
                other.imgModel == imgModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, prompt, url, key, model,
      historyLen, id, name, genTitlePrompt, genTitleModel, imgModel);

  /// Create a copy of ChatConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatConfigImplCopyWith<_$ChatConfigImpl> get copyWith =>
      __$$ChatConfigImplCopyWithImpl<_$ChatConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatConfigImplToJson(
      this,
    );
  }
}

abstract class _ChatConfig implements ChatConfig {
  const factory _ChatConfig(
      {@HiveField(0, defaultValue: '') required final String prompt,
      @HiveField(1, defaultValue: ChatConfigX.defaultUrl)
      required final String url,
      @HiveField(2, defaultValue: '') required final String key,
      @HiveField(3, defaultValue: '') required final String model,
      @HiveField(7, defaultValue: ChatConfigX.defaultHistoryLen)
      required final int historyLen,
      @HiveField(8, defaultValue: ChatConfigX.defaultId)
      @JsonKey(defaultValue: ChatConfigX.defaultId)
      required final String id,
      @HiveField(9, defaultValue: '') required final String name,
      @HiveField(14) final String? genTitlePrompt,
      @HiveField(15) final String? genTitleModel,
      @HiveField(16) final String? imgModel}) = _$ChatConfigImpl;

  factory _ChatConfig.fromJson(Map<String, dynamic> json) =
      _$ChatConfigImpl.fromJson;

  @override
  @HiveField(0, defaultValue: '')
  String get prompt;
  @override
  @HiveField(1, defaultValue: ChatConfigX.defaultUrl)
  String get url;
  @override
  @HiveField(2, defaultValue: '')
  String get key;
  @override
  @HiveField(3, defaultValue: '')
  String get model;
  @override
  @HiveField(7, defaultValue: ChatConfigX.defaultHistoryLen)
  int get historyLen;
  @override
  @HiveField(8, defaultValue: ChatConfigX.defaultId)
  @JsonKey(defaultValue: ChatConfigX.defaultId)
  String get id;
  @override
  @HiveField(9, defaultValue: '')
  String get name;
  @override
  @HiveField(14)
  String? get genTitlePrompt;
  @override
  @HiveField(15)
  String? get genTitleModel;
  @override
  @HiveField(16)
  String? get imgModel;

  /// Create a copy of ChatConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatConfigImplCopyWith<_$ChatConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
