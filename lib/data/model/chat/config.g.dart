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
      url:
          fields[1] == null ? 'https://api.openai.com/v1' : fields[1] as String,
      key: fields[2] == null ? '' : fields[2] as String,
      model: fields[3] == null ? '' : fields[3] as String,
      historyLen: fields[7] == null ? 7 : fields[7] as int,
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatConfigImpl _$$ChatConfigImplFromJson(Map<String, dynamic> json) =>
    _$ChatConfigImpl(
      prompt: json['prompt'] as String,
      url: json['url'] as String,
      key: json['key'] as String,
      model: json['model'] as String,
      historyLen: (json['historyLen'] as num).toInt(),
      id: json['id'] as String? ?? 'defaultId',
      name: json['name'] as String,
      genTitlePrompt: json['genTitlePrompt'] as String?,
      genTitleModel: json['genTitleModel'] as String?,
      imgModel: json['imgModel'] as String?,
    );

Map<String, dynamic> _$$ChatConfigImplToJson(_$ChatConfigImpl instance) =>
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
