// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatConfig _$ChatConfigFromJson(Map<String, dynamic> json) => _ChatConfig(
  prompt: json['prompt'] as String? ?? '',
  url: json['url'] as String? ?? ChatConfigX.defaultUrl,
  key: json['key'] as String? ?? '',
  model: json['model'] as String? ?? '',
  historyLen:
      (json['historyLen'] as num?)?.toInt() ?? ChatConfigX.defaultHistoryLen,
  id: json['id'] as String? ?? ChatConfigX.defaultId,
  name: json['name'] as String? ?? '',
  genTitlePrompt: json['genTitlePrompt'] as String?,
  genTitleModel: json['genTitleModel'] as String?,
  imgModel: json['imgModel'] as String?,
);

Map<String, dynamic> _$ChatConfigToJson(_ChatConfig instance) =>
    <String, dynamic>{
      'prompt': instance.prompt,
      'url': instance.url,
      'key': instance.key,
      'model': instance.model,
      'historyLen': instance.historyLen,
      'id': instance.id,
      'name': instance.name,
      'genTitlePrompt': instance.genTitlePrompt,
      'genTitleModel': instance.genTitleModel,
      'imgModel': instance.imgModel,
    };
