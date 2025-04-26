import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_box/core/util/url.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortid/shortid.dart';

part 'config.g.dart';
part 'config.freezed.dart';

@HiveType(typeId: 6)
@freezed
class ChatConfig with _$ChatConfig {
  const factory ChatConfig({
    @HiveField(0, defaultValue: '') required String prompt,
    @HiveField(1, defaultValue: ChatConfigX.defaultUrl) required String url,
    @HiveField(2, defaultValue: '') required String key,
    @HiveField(3, defaultValue: '') required String model,
    @HiveField(7, defaultValue: ChatConfigX.defaultHistoryLen)
    required int historyLen,
    @HiveField(8, defaultValue: ChatConfigX.defaultId)
    @JsonKey(defaultValue: ChatConfigX.defaultId)
    required String id,
    @HiveField(9, defaultValue: '') required String name,
    @HiveField(14) String? genTitlePrompt,
    @HiveField(15) String? genTitleModel,
    @HiveField(16) String? imgModel,
  }) = _ChatConfig;

  factory ChatConfig.fromJson(Map<String, dynamic> json) =>
      _$ChatConfigFromJson(json);

  @override
  String toString() => 'ChatConfig($id, $url, $model)';
}

extension ChatConfigX on ChatConfig {
  static final apiUrlReg = RegExp(r'^https?://[0-9A-Za-z\.]+(:\d+)?$');
  static const defaultId = 'defaultId';
  static const defaultUrl = 'https://api.openai.com/v1';
  static const defaultHistoryLen = 7;
  static const defaultImgModel = 'dall-e-3';
  static const defaultOne = ChatConfig(
    id: defaultId,
    prompt: '',
    url: defaultUrl,
    key: '',
    model: '',
    historyLen: defaultHistoryLen,
    name: '',
  );

  String get displayName => switch (id) {
        // Corresponding as `id == defaultId && name.isEmpty`
        defaultId when name.isEmpty => l10n.defaulT,
        _ => name,
      };

  void save() => Stores.config.put(this);

  bool shouldUpdateRelated(ChatConfig old) {
    if (id != old.id) return true;
    if (key != old.key) return true;
    if (url != old.url) return true;
    return false;
  }

  bool get isDefault => id == defaultId;

  /// Get share url.
  ///
  /// eg.: lpkt.cn://gptbox/profile?params=...
  String get shareUrl {
    final jsonStr = json.encode(toJson());
    final urlEncoded = Uri.encodeComponent(jsonStr);
    return '${AppLink.prefix}${AppLink.profilePath}?params=$urlEncoded';
  }

  /// Parse url params to [ChatConfig].
  static ChatConfig fromUrlParams(String params) {
    final params_ = json.decode(params) as Map<String, dynamic>;
    return ChatConfig(
      id: params_['id'] ?? shortid.generate(),
      url: params_['url'] ?? defaultUrl,
      key: params_['key'] ?? '',
      model: params_['model'] ?? '',
      prompt: params_['prompt'] ?? '',
      name: params_['name'] ?? '',
      genTitlePrompt: params_['genTitlePrompt'],
      historyLen: params_['historyLen'] ?? defaultHistoryLen,
    );
  }
}
