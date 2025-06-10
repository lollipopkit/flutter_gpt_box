// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatHistory _$ChatHistoryFromJson(Map<String, dynamic> json) => ChatHistory(
  items: (json['items'] as List<dynamic>)
      .map((e) => ChatHistoryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  id: json['id'] as String,
  name: json['name'] as String?,
  settings: json['settings'] == null
      ? null
      : ChatSettings.fromJson(json['settings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatHistoryToJson(ChatHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      if (instance.name case final value?) 'name': value,
      if (instance.settings case final value?) 'settings': value,
    };

ChatHistoryItem _$ChatHistoryItemFromJson(Map<String, dynamic> json) =>
    ChatHistoryItem(
      role: $enumDecode(_$ChatRoleEnumMap, json['role']),
      content: (json['content'] as List<dynamic>)
          .map((e) => ChatContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      id: json['id'] as String,
      toolCallId: json['toolCallId'] as String?,
      toolCalls: (json['toolCalls'] as List<dynamic>?)
          ?.map(
            (e) => ChatCompletionMessageToolCall.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      reasoning: json['reasoning'] as String?,
    );

Map<String, dynamic> _$ChatHistoryItemToJson(ChatHistoryItem instance) =>
    <String, dynamic>{
      'role': _$ChatRoleEnumMap[instance.role]!,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'id': instance.id,
      if (instance.toolCallId case final value?) 'toolCallId': value,
      if (instance.toolCalls case final value?) 'toolCalls': value,
      if (instance.reasoning case final value?) 'reasoning': value,
    };

const _$ChatRoleEnumMap = {
  ChatRole.user: 'user',
  ChatRole.assist: 'assist',
  ChatRole.system: 'system',
  ChatRole.tool: 'tool',
};

ChatContent _$ChatContentFromJson(Map<String, dynamic> json) => ChatContent(
  type: $enumDecode(_$ChatContentTypeEnumMap, json['type']),
  raw: json['raw'] as String,
  id: json['id'] as String,
);

Map<String, dynamic> _$ChatContentToJson(ChatContent instance) =>
    <String, dynamic>{
      'type': _$ChatContentTypeEnumMap[instance.type]!,
      'raw': instance.raw,
      'id': instance.id,
    };

const _$ChatContentTypeEnumMap = {
  ChatContentType.text: 'text',
  ChatContentType.audio: 'audio',
  ChatContentType.image: 'image',
  ChatContentType.file: 'file',
};

ChatSettings _$ChatSettingsFromJson(Map<String, dynamic> json) => ChatSettings(
  headTailMode: json['htm'] as bool?,
  useTools: json['ut'] as bool?,
  ignoreContextConstraint: json['icc'] as bool?,
);

Map<String, dynamic> _$ChatSettingsToJson(ChatSettings instance) =>
    <String, dynamic>{
      'htm': instance.headTailMode,
      'ut': instance.useTools,
      'icc': instance.ignoreContextConstraint,
    };
