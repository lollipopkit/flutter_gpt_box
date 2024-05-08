import 'package:gpt_box/data/store/all.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortid/shortid.dart';

part 'config.g.dart';

const _kUrl = 'https://api.openai.com';
const _kModel = 'gpt-4-turbo-preview';
const _kHistoryLen = 7;
const _kImgModel = 'dall-e-3';
const _kSpeechModel = 'tts-1';
const _kTranscribeModel = 'whisper-1';
const _kVisionModel = 'gpt-4-vision-preview';

@HiveType(typeId: 6)
final class ChatConfig {
  @HiveField(0, defaultValue: '')
  final String prompt;
  @HiveField(1, defaultValue: _kUrl)
  final String url;
  @HiveField(2, defaultValue: '')
  final String key;
  @HiveField(3, defaultValue: _kModel)
  final String model;
  @HiveField(7, defaultValue: _kHistoryLen)
  final int historyLen;
  @HiveField(8, defaultValue: defaultId)
  final String id;
  @HiveField(9, defaultValue: '')
  final String name;
  @HiveField(10, defaultValue: _kImgModel)
  final String imgModel;
  @HiveField(11, defaultValue: _kSpeechModel)
  final String speechModel;
  @HiveField(12, defaultValue: _kTranscribeModel)
  final String transcribeModel;
  @HiveField(13, defaultValue: _kVisionModel)
  final String visionModel;

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
    required this.visionModel,
  });

  static final apiUrlReg = RegExp(r'^https?://[0-9A-Za-z\.]+(:\d+)?$');
  static const defaultId = 'defaultId';
  static const defaultOne = ChatConfig(
    id: defaultId,
    prompt: '',
    url: _kUrl,
    key: '',
    model: _kModel,
    historyLen: _kHistoryLen,
    name: '',
    imgModel: _kImgModel,
    speechModel: _kSpeechModel,
    transcribeModel: _kTranscribeModel,
    visionModel: _kVisionModel,
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
    String? visionModel,
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
        visionModel: visionModel ?? this.visionModel,
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
      'visionModel': visionModel,
    };
  }

  static ChatConfig fromJson(Map<String, dynamic> json) {
    return ChatConfig(
      id: json['id'] as String? ?? shortid.generate(),
      prompt: json['prompt'] as String,
      url: json['url'] as String,
      key: json['key'] as String,
      model: json['model'] as String,
      historyLen: json['historyLen'] as int,
      name: json['name'] as String? ?? 'Untitled',
      imgModel: json['imgModel'] as String? ?? _kImgModel,
      speechModel: json['speechModel'] as String? ?? _kSpeechModel,
      transcribeModel: json['transcribeModel'] as String? ?? _kTranscribeModel,
      visionModel: json['visionModel'] as String? ?? _kVisionModel,
    );
  }
}
