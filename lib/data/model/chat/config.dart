import 'package:flutter_chatgpt/data/res/uuid.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'config.g.dart';

@HiveType(typeId: 6)
final class ChatConfig {
  @HiveField(0, defaultValue: '')
  final String prompt;
  @HiveField(1, defaultValue: 'https://api.openai.com')
  final String url;
  @HiveField(2, defaultValue: '')
  final String key;
  @HiveField(3, defaultValue: 'gpt-4-turbo-preview')
  final String model;
  @HiveField(7, defaultValue: 7)
  final int historyLen;
  @HiveField(8, defaultValue: defaultId)
  final String id;
  @HiveField(9, defaultValue: '')
  final String name;
  @HiveField(10, defaultValue: 'dall-e-3')
  final String imgModel;
  @HiveField(11, defaultValue: 'tts-1')
  final String speechModel;
  @HiveField(12, defaultValue: 'whisper-1')
  final String transcribeModel;

  const ChatConfig({
    required this.prompt,
    required this.url,
    required this.key,
    required this.model,
    required this.historyLen,
    required this.id,
    required this.name,
    required this.imgModel,
    required this.speechModel,
    required this.transcribeModel,
  });

  static final apiUrlReg = RegExp(r'^https?://[0-9A-Za-z\.]+(:\d+)?$');
  static const defaultId = 'defaultId';
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
    transcribeModel: 'whisper-1',
  );

  void save() => Stores.config.put(this);

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
  }) =>
      ChatConfig(
        id: id ?? this.id,
        prompt: prompt ?? this.prompt,
        url: url ?? this.url,
        key: key ?? this.key,
        model: model ?? this.model,
        historyLen: historyLen ?? this.historyLen,
        name: name ?? this.name,
        imgModel: imgModel ?? this.imgModel,
        speechModel: speechModel ?? this.speechModel,
        transcribeModel: transcribeModel ?? this.transcribeModel,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'url': url,
      'key': key,
      'model': model,
      'historyLen': historyLen,
      'name': name,
      'imgModel': imgModel,
      'speechModel': speechModel,
      'transcribeModel': transcribeModel,
    };
  }

  static ChatConfig fromJson(Map<String, dynamic> json) {
    return ChatConfig(
      id: json['id'] as String? ?? uuid.v4(),
      prompt: json['prompt'] as String,
      url: json['url'] as String,
      key: json['key'] as String,
      model: json['model'] as String,
      historyLen: json['historyLen'] as int,
      name: json['name'] as String? ?? 'Untitled',
      imgModel: json['imgModel'] as String? ?? 'dall-e-3',
      speechModel: json['speechModel'] as String? ?? 'tts-1',
      transcribeModel: json['transcribeModel'] as String? ?? 'whisper-1',
    );
  }
}
