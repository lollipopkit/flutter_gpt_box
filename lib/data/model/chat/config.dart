import 'package:flutter_chatgpt/data/res/uuid.dart';
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
  @HiveField(7)
  final String id;
  @HiveField(8)
  final String? name;
  @HiveField(9)
  final String? imgModel;
  @HiveField(10)
  final String? speechModel;
  @HiveField(11)
  final String? translationModel;
  @HiveField(12)
  final String? genTitleModel;

  const ChatConfig({
    required this.prompt,
    required this.url,
    required this.key,
    required this.model,
    this.seed,
    this.temperature,
    required this.historyLen,
    required this.id,
    this.name,
    this.imgModel,
    this.speechModel,
    this.translationModel,
    this.genTitleModel,
  });

  static final apiUrlReg = RegExp(r'^https?://[0-9A-Za-z\.]+(:\d+)?$');
  static const defaultId = '';
  static const defaultOne = ChatConfig(
    id: defaultId,
    prompt: '',
    url: 'https://api.openai.com',
    key: '',
    model: 'gpt-4-turbo-preview',
    historyLen: 7,
    name: '',
    imgModel: 'dall-e-3',
    speechModel: 'tts-1',
    translationModel: 'whisper-1',
    genTitleModel: 'gpt-3.5-turbo-1106',
  );

  void save() => Stores.config.put(this);

  ChatConfig copyWith({
    String? prompt,
    String? url,
    String? key,
    String? model,
    int? seed,
    double? temperature,
    int? historyLen,
    String? name,
    String? imgModel,
    String? speechModel,
    String? translationModel,
    String? genTitleModel,
  }) =>
      ChatConfig(
        id: id,
        prompt: prompt ?? this.prompt,
        url: url ?? this.url,
        key: key ?? this.key,
        model: model ?? this.model,
        seed: seed ?? this.seed,
        temperature: temperature ?? this.temperature,
        historyLen: historyLen ?? this.historyLen,
        name: name ?? this.name,
        imgModel: imgModel ?? this.imgModel,
        speechModel: speechModel ?? this.speechModel,
        translationModel: translationModel ?? this.translationModel,
        genTitleModel: genTitleModel ?? this.genTitleModel,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'url': url,
      'key': key,
      'model': model,
      'seed': seed,
      'temperature': temperature,
      'historyLen': historyLen,
      'name': name,
      'imgModel': imgModel,
      'speechModel': speechModel,
      'translationModel': translationModel,
      'genTitleModel': genTitleModel,
    };
  }

  static ChatConfig fromJson(Map<String, dynamic> json) {
    return ChatConfig(
      id: json['id'] as String? ?? uuid.v4(),
      prompt: json['prompt'] as String,
      url: json['url'] as String,
      key: json['key'] as String,
      model: json['model'] as String,
      seed: json['seed'] as int?,
      temperature: json['temperature'] as double?,
      historyLen: json['historyLen'] as int,
      name: json['name'] as String?,
      imgModel: json['imgModel'] as String?,
      speechModel: json['speechModel'] as String?,
      translationModel: json['translationModel'] as String?,
      genTitleModel: json['genTitleModel'] as String?,
    );
  }
}
