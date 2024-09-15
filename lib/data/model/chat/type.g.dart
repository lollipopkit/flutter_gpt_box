// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatTypeAdapter extends TypeAdapter<ChatType> {
  @override
  final int typeId = 7;

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
        break;
      case ChatType.img:
        writer.writeByte(1);
        break;
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
