// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatHistoryAdapter extends TypeAdapter<ChatHistory> {
  @override
  final int typeId = 5;

  @override
  ChatHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatHistory(
      items: (fields[1] as List).cast<ChatHistoryItem>(),
      id: fields[0] as String,
      name: fields[2] as String?,
      settings: fields[6] as ChatSettings?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatHistoryItemAdapter extends TypeAdapter<ChatHistoryItem> {
  @override
  final int typeId = 0;

  @override
  ChatHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatHistoryItem(
      role: fields[0] as ChatRole,
      content: (fields[1] as List).cast<ChatContent>(),
      createdAt: fields[2] as DateTime,
      id: fields[3] as String,
      toolCallId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatHistoryItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.role)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.toolCallId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatContentAdapter extends TypeAdapter<ChatContent> {
  @override
  final int typeId = 2;

  @override
  ChatContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatContent(
      type: fields[0] as ChatContentType,
      raw: fields[1] as String,
      id: fields[2] == null ? '' : fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatContent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.raw)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatSettingsAdapter extends TypeAdapter<ChatSettings> {
  @override
  final int typeId = 8;

  @override
  ChatSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatSettings(
      headTailMode: fields[0] as bool?,
      useTools: fields[1] as bool?,
      ignoreContextConstraint: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatSettings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.headTailMode)
      ..writeByte(1)
      ..write(obj.useTools)
      ..writeByte(2)
      ..write(obj.ignoreContextConstraint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatContentTypeAdapter extends TypeAdapter<ChatContentType> {
  @override
  final int typeId = 1;

  @override
  ChatContentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChatContentType.text;
      case 1:
        return ChatContentType.audio;
      case 2:
        return ChatContentType.image;
      default:
        return ChatContentType.text;
    }
  }

  @override
  void write(BinaryWriter writer, ChatContentType obj) {
    switch (obj) {
      case ChatContentType.text:
        writer.writeByte(0);
        break;
      case ChatContentType.audio:
        writer.writeByte(1);
        break;
      case ChatContentType.image:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatContentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatRoleAdapter extends TypeAdapter<ChatRole> {
  @override
  final int typeId = 3;

  @override
  ChatRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChatRole.user;
      case 1:
        return ChatRole.assist;
      case 2:
        return ChatRole.system;
      case 3:
        return ChatRole.tool;
      default:
        return ChatRole.user;
    }
  }

  @override
  void write(BinaryWriter writer, ChatRole obj) {
    switch (obj) {
      case ChatRole.user:
        writer.writeByte(0);
        break;
      case ChatRole.assist:
        writer.writeByte(1);
        break;
      case ChatRole.system:
        writer.writeByte(2);
        break;
      case ChatRole.tool:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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

Map<String, dynamic> _$ChatHistoryToJson(ChatHistory instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'items': instance.items,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('settings', instance.settings);
  return val;
}

ChatHistoryItem _$ChatHistoryItemFromJson(Map<String, dynamic> json) =>
    ChatHistoryItem(
      role: $enumDecode(_$ChatRoleEnumMap, json['role']),
      content: (json['content'] as List<dynamic>)
          .map((e) => ChatContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      id: json['id'] as String,
      toolCallId: json['toolCallId'] as String?,
    );

Map<String, dynamic> _$ChatHistoryItemToJson(ChatHistoryItem instance) {
  final val = <String, dynamic>{
    'role': _$ChatRoleEnumMap[instance.role]!,
    'content': instance.content,
    'createdAt': instance.createdAt.toIso8601String(),
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('toolCallId', instance.toolCallId);
  return val;
}

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
