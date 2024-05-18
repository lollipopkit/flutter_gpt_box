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
      prompt: fields[0] == null ? '' : fields[0] as String,
      url: fields[1] == null ? 'https://api.openai.com' : fields[1] as String,
      key: fields[2] == null ? '' : fields[2] as String,
      model: fields[3] == null ? 'gpt-4o' : fields[3] as String,
      historyLen: fields[7] == null ? 7 : fields[7] as int,
      id: fields[8] == null ? 'defaultId' : fields[8] as String,
      name: fields[9] == null ? '' : fields[9] as String,
      imgModel: fields[10] == null ? 'dall-e-3' : fields[10] as String,
      speechModel: fields[11] == null ? 'tts-1' : fields[11] as String,
      transcribeModel: fields[12] == null ? 'whisper-1' : fields[12] as String,
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
      ..writeByte(10)
      ..write(obj.imgModel)
      ..writeByte(11)
      ..write(obj.speechModel)
      ..writeByte(12)
      ..write(obj.transcribeModel);
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
