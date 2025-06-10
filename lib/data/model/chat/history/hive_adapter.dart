import 'package:openai_dart/openai_dart.dart';
import 'package:hive_ce_flutter/adapters.dart';

class ChatCompletionMessageToolCallAdapter
    extends TypeAdapter<ChatCompletionMessageToolCall> {
  @override
  final typeId = 9;

  @override
  ChatCompletionMessageToolCall read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatCompletionMessageToolCall(
      id: fields[0] as String,
      type: ChatCompletionMessageToolCallType.values[fields[1] as int],
      function: fields[2] as ChatCompletionMessageFunctionCall,
    );
  }

  @override
  void write(BinaryWriter writer, ChatCompletionMessageToolCall obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type.index)
      ..writeByte(2)
      ..write(obj.function);
  }
}

class ChatCompletionMessageFunctionCallAdapter
    extends TypeAdapter<ChatCompletionMessageFunctionCall> {
  @override
  final typeId = 10;

  @override
  ChatCompletionMessageFunctionCall read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatCompletionMessageFunctionCall(
      name: fields[0] as String,
      arguments: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatCompletionMessageFunctionCall obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.arguments);
  }
}
