// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatConfigAdapter extends TypeAdapter<ChatConfig> {
  @override
  final int typeId = 6;

  @override
  ChatConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatConfig(
      prompt: fields[0] as String,
      url: fields[1] as String,
      key: fields[2] as String,
      model: fields[3] as String,
      seed: fields[4] as int?,
      temperature: fields[5] as double?,
      historyLen: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ChatConfig obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.prompt)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.key)
      ..writeByte(3)
      ..write(obj.model)
      ..writeByte(4)
      ..write(obj.seed)
      ..writeByte(5)
      ..write(obj.temperature)
      ..writeByte(6)
      ..write(obj.historyLen);
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
