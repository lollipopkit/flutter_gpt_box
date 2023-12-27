// ignore_for_file: deprecated_member_use_from_same_package

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_chatgpt/data/res/uuid.dart';
import 'package:hive_flutter/adapters.dart';

part 'history.g.dart';

@HiveType(typeId: 0)
final class ChatHistoryItem {
  @HiveField(0)
  final ChatRole role;
  @HiveField(1)
  final List<ChatContent> content;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  final String id;

  const ChatHistoryItem({
    required this.role,
    required this.content,
    required this.createdAt,
    required this.id,
  });

  ChatHistoryItem.noid({
    required this.role,
    required this.content,
    required this.createdAt,
  }) : id = uuid.v4();

  OpenAIChatCompletionChoiceMessageModel get toOpenAI {
    return OpenAIChatCompletionChoiceMessageModel(
      role: role.toOpenAI,
      content: content.map((e) {
        switch (e.type) {
          case ChatContentType.text:
            return OpenAIChatCompletionChoiceMessageContentItemModel.text(
                e.raw);
          case ChatContentType.image:
            return OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
                e.raw);
          default:
            throw UnimplementedError();
        }
      }).toList(),
    );
  }

  String get toMarkdown {
    return content.map((e) {
      switch (e.type) {
        case ChatContentType.text:
          return e.raw;
        case ChatContentType.image:
          return '![](${e.raw})';
        default:
          throw UnimplementedError();
      }
    }).join('\n');
  }

  static ChatHistoryItem get emptyAssist => ChatHistoryItem.noid(
        content: [
          ChatContent(
            type: ChatContentType.text,
            raw: '',
          )
        ],
        role: ChatRole.assist,
        createdAt: DateTime.now(),
      );
}

@HiveType(typeId: 1)
enum ChatContentType {
  @HiveField(0)
  text,
  @HiveField(1)
  image,
  @HiveField(2)
  video,
  @HiveField(3)
  audio,
  @HiveField(4)
  file,
}

@HiveType(typeId: 2)
final class ChatContent {
  @HiveField(0)
  final ChatContentType type;
  @HiveField(1)
  String raw;

  ChatContent({required this.type, required this.raw});
}

@HiveType(typeId: 3)
enum ChatRole {
  @HiveField(0)
  user,
  @HiveField(1)
  assist,
  @HiveField(2)
  system,
  ;

  OpenAIChatMessageRole get toOpenAI {
    switch (this) {
      case ChatRole.user:
        return OpenAIChatMessageRole.user;
      case ChatRole.assist:
        return OpenAIChatMessageRole.assistant;
      case ChatRole.system:
        return OpenAIChatMessageRole.system;
      default:
        throw UnimplementedError();
    }
  }
}

@HiveType(typeId: 5)
final class ChatHistory {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<ChatHistoryItem> items;
  @HiveField(2)
  final String name;

  const ChatHistory({
    required this.name,
    required this.items,
    required this.id,
  });

  ChatHistory.noid({
    required this.name,
    required this.items,
  }) : id = uuid.v4();

  static ChatHistory get empty => ChatHistory.noid(
        name: 'Empty',
        items: [],
      );

  ChatHistory copyWith({
    String? name,
    List<ChatHistoryItem>? items,
  }) {
    return ChatHistory(
      name: name ?? this.name,
      items: items ?? this.items,
      id: id,
    );
  }
}
