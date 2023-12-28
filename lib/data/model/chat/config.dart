import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'config.g.dart';

@HiveType(typeId: 6)
final class ChatConfig {
  @HiveField(0)
  final String prompt;
  @HiveField(1)
  final String url;
  @HiveField(2)
  final String key;
  @HiveField(3)
  final String model;
  @HiveField(4)
  final int? seed;
  @HiveField(5)
  final double? temperature;
  @HiveField(6)
  final int historyLen;

  const ChatConfig({
    required this.prompt,
    required this.url,
    required this.key,
    required this.model,
    this.seed,
    this.temperature,
    required this.historyLen,
  });

  static ChatConfig fromStore() => ChatConfig(
        prompt: Stores.setting.prompt.fetch(),
        url: Stores.setting.openaiApiUrl.fetch(),
        key: Stores.setting.openaiApiKey.fetch(),
        model: Stores.setting.openaiModel.fetch(),
        historyLen: Stores.setting.historyLength.fetch(),
      );

  ChatConfig copyWith({
    String? prompt,
    String? url,
    String? key,
    String? model,
    int? seed,
    double? temperature,
    int? historyLen,
  }) =>
      ChatConfig(
        prompt: prompt ?? this.prompt,
        url: url ?? this.url,
        key: key ?? this.key,
        model: model ?? this.model,
        seed: seed ?? this.seed,
        temperature: temperature ?? this.temperature,
        historyLen: historyLen ?? this.historyLen,
      );

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'url': url,
      'key': key,
      'model': model,
      'seed': seed,
      'temperature': temperature,
      'historyLen': historyLen,
    };
  }

  static ChatConfig fromJson(Map<String, dynamic> json) {
    return ChatConfig(
      prompt: json['prompt'] as String,
      url: json['url'] as String,
      key: json['key'] as String,
      model: json['model'] as String,
      seed: json['seed'] as int?,
      temperature: json['temperature'] as double?,
      historyLen: json['historyLen'] as int,
    );
  }
}
