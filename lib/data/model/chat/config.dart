import 'dart:convert';

import 'package:gpt_box/core/util/url.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shortid/shortid.dart';

part 'config.g.dart';

@HiveType(typeId: 6)
@JsonSerializable()
final class ChatConfig {
  @HiveField(0, defaultValue: '')
  final String prompt;
  @HiveField(1, defaultValue: defaultUrl)
  final String url;
  @HiveField(2, defaultValue: '')
  final String key;
  @HiveField(3, defaultValue: '')
  final String model;
  @HiveField(7, defaultValue: defaultHistoryLen)
  final int historyLen;
  @HiveField(8, defaultValue: defaultId)
  @JsonKey(defaultValue: defaultId)
  final String id;
  @HiveField(9, defaultValue: '')
  final String name;
  @HiveField(14)
  final String? genTitlePrompt;

  const ChatConfig({
    required this.prompt,
    required this.url,
    required this.key,
    required this.model,
    required this.historyLen,
    required this.id,
    required this.name,
    this.genTitlePrompt,
  });

  ChatConfig.noid({
    required this.prompt,
    required this.url,
    required this.key,
    required this.model,
    required this.historyLen,
    required this.name,
    this.genTitlePrompt,
  }) : id = shortid.generate();

  static final apiUrlReg = RegExp(r'^https?://[0-9A-Za-z\.]+(:\d+)?$');
  static const defaultId = 'defaultId';
  static const defaultUrl = 'https://api.openai.com/v1';
  static const defaultHistoryLen = 7;
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

  ChatConfig copyWith({
    String? id,
    String? prompt,
    String? url,
    String? key,
    String? model,
    int? historyLen,
    String? name,
    String? imgModel,
    String? speechModel,
    String? transcribeModel,
    String? genTitlePrompt,
  }) =>
      ChatConfig(
        id: id ?? this.id,
        prompt: prompt ?? this.prompt,
        url: url ?? this.url,
        key: key ?? this.key,
        model: model ?? this.model,
        historyLen: historyLen ?? this.historyLen,
        name: name ?? this.name,
      );

  factory ChatConfig.fromJson(Map<String, dynamic> json) =>
      _$ChatConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ChatConfigToJson(this);

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
    return ChatConfig.noid(
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
