// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class ChatHistoryItemAdapter extends TypeAdapter<ChatHistoryItem> {
  @override
  final typeId = 0;

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
      toolCalls: (fields[5] as List?)?.cast<ChatCompletionMessageToolCall>(),
      reasoning: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatHistoryItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.role)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.toolCallId)
      ..writeByte(5)
      ..write(obj.toolCalls)
      ..writeByte(6)
      ..write(obj.reasoning);
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

class ChatContentTypeAdapter extends TypeAdapter<ChatContentType> {
  @override
  final typeId = 1;

  @override
  ChatContentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChatContentType.text;
      case 1:
        return ChatContentType.audio;
      case 2:
        return ChatContentType.image;
      case 3:
        return ChatContentType.file;
      default:
        return ChatContentType.text;
    }
  }

  @override
  void write(BinaryWriter writer, ChatContentType obj) {
    switch (obj) {
      case ChatContentType.text:
        writer.writeByte(0);
      case ChatContentType.audio:
        writer.writeByte(1);
      case ChatContentType.image:
        writer.writeByte(2);
      case ChatContentType.file:
        writer.writeByte(3);
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

class ChatContentAdapter extends TypeAdapter<ChatContent> {
  @override
  final typeId = 2;

  @override
  ChatContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatContent(
      type: fields[0] as ChatContentType,
      raw: fields[1] as String,
      id: fields[2] as String,
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

class ChatRoleAdapter extends TypeAdapter<ChatRole> {
  @override
  final typeId = 3;

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
      case ChatRole.assist:
        writer.writeByte(1);
      case ChatRole.system:
        writer.writeByte(2);
      case ChatRole.tool:
        writer.writeByte(3);
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

class ChatHistoryAdapter extends TypeAdapter<ChatHistory> {
  @override
  final typeId = 5;

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

class ChatConfigAdapter extends TypeAdapter<ChatConfig> {
  @override
  final typeId = 6;

  @override
  ChatConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatConfig(
      prompt: fields[0] == null ? '' : fields[0] as String,
      url: fields[1] == null
          ? 'https://api.openai.com/v1'
          : fields[1] as String,
      key: fields[2] == null ? '' : fields[2] as String,
      model: fields[3] == null ? '' : fields[3] as String,
      historyLen: fields[7] == null ? 7 : (fields[7] as num).toInt(),
      id: fields[8] == null ? 'defaultId' : fields[8] as String,
      name: fields[9] == null ? '' : fields[9] as String,
      genTitlePrompt: fields[14] as String?,
      genTitleModel: fields[15] as String?,
      imgModel: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatConfig obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.prompt)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.key)
      ..writeByte(3)
      ..write(obj.model)
      ..writeByte(7)
      ..write(obj.historyLen)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.name)
      ..writeByte(14)
      ..write(obj.genTitlePrompt)
      ..writeByte(15)
      ..write(obj.genTitleModel)
      ..writeByte(16)
      ..write(obj.imgModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatTypeAdapter extends TypeAdapter<ChatType> {
  @override
  final typeId = 7;

  @override
  ChatType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChatType.text;
      case 1:
        return ChatType.img;
      default:
        return ChatType.text;
    }
  }

  @override
  void write(BinaryWriter writer, ChatType obj) {
    switch (obj) {
      case ChatType.text:
        writer.writeByte(0);
      case ChatType.img:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatSettingsAdapter extends TypeAdapter<ChatSettings> {
  @override
  final typeId = 8;

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
