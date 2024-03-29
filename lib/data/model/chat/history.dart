import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chatgpt/core/ext/iterable.dart';
import 'package:flutter_chatgpt/data/model/chat/type.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/url.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shortid/shortid.dart';

part 'history.g.dart';

@HiveType(typeId: 5)
final class ChatHistory {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<ChatHistoryItem> items;
  @HiveField(2)
  String? name;
  @HiveField(3)
  ChatApiType? type;

  ChatHistory({
    required this.items,
    required this.id,
    this.name,
    this.type,
  });

  ChatHistory.noid({
    required this.items,
    this.name,
    this.type,
  }) : id = shortid.generate();

  static ChatHistory get empty => ChatHistory.noid(items: []);

  Map<String, dynamic> toJson() {
    final map = {
      'id': id,
      'name': name,
      'items': items.map((e) => e.toJson()).toList(),
    };
    final type = this.type?.index;
    if (type != null) {
      map['type'] = type;
    }
    return map;
  }

  static ChatHistory fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      id: json['id'] as String,
      name: json['name'] as String?,
      items: (json['items'] as List)
          .map((e) => ChatHistoryItem.fromJson(e.cast<String, dynamic>()))
          .toList(),
      type: ChatApiType.fromJson(json['type'] as int? ?? -1),
    );
  }

  static ChatHistory get example => ChatHistory.noid(
        name: l10n.help,
        items: [
          ChatHistoryItem.single(
            role: ChatRole.system,
            type: ChatContentType.text,
            raw: l10n.initChatHelp(Urls.repoIssue, Urls.unilinkDoc),
          ),
        ],
      );
}

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

  ChatHistoryItem.gen({
    required this.role,
    required this.content,
  })  : createdAt = DateTime.now(),
        id = shortid.generate();

  ChatHistoryItem.single({
    required this.role,
    String raw = '',
    ChatContentType type = ChatContentType.text,
    DateTime? createdAt,
  })  : content = [ChatContent.noid(type: type, raw: raw)],
        createdAt = createdAt ?? DateTime.now(),
        id = shortid.generate();

  OpenAIChatCompletionChoiceMessageModel get toOpenAI {
    return OpenAIChatCompletionChoiceMessageModel(
      role: role.toOpenAI,
      content: content.map((e) => e.toOpenAI).toList(),
    );
  }

  String get toMarkdown {
    return content
        .map((e) => switch (e.type) {
              ChatContentType.text => e.raw,
              ChatContentType.image => '![](${e.raw})',
              final type => throw UnimplementedError('type: $type'),
            })
        .join('\n');
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role.index,
      'content': content.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'id': id,
    };
  }

  static ChatHistoryItem fromJson(Map<String, dynamic> json) {
    return ChatHistoryItem(
      role: ChatRole.values[json['role'] as int],
      content: (json['content'] as List)
          .map((e) => ChatContent.fromJson(e.cast<String, dynamic>()))
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      id: json['id'] as String? ?? shortid.generate(),
    );
  }

  ChatHistoryItem copyWith({
    ChatRole? role,
    List<ChatContent>? content,
    DateTime? createdAt,
    @protected String? id,
  }) {
    return ChatHistoryItem(
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }
}

/// Handle [audio] and [image] as url (file:// & https://) or base64
@HiveType(typeId: 1)
enum ChatContentType {
  @HiveField(0)
  text,
  @HiveField(1)
  audio,
  @HiveField(2)
  image,
  ;
}

@HiveType(typeId: 2)
final class ChatContent {
  @HiveField(0)
  final ChatContentType type;
  @HiveField(1)
  String raw;
  @HiveField(2, defaultValue: '')
  final String id;

  ChatContent({required this.type, required this.raw, required String id})
      : id = id.isEmpty ? shortid.generate() : id;
  ChatContent.noid({required this.type, required this.raw})
      : id = shortid.generate();
  ChatContent.text(this.raw)
      : type = ChatContentType.text,
        id = shortid.generate();
  ChatContent.audio(this.raw)
      : type = ChatContentType.audio,
        id = shortid.generate();
  ChatContent.image(this.raw)
      : type = ChatContentType.image,
        id = shortid.generate();

  OpenAIChatCompletionChoiceMessageContentItemModel get toOpenAI =>
      switch (type) {
        ChatContentType.text =>
          OpenAIChatCompletionChoiceMessageContentItemModel.text(raw),
        ChatContentType.image =>
          OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(raw),
        _ => throw UnimplementedError('$type.toOpenAI'),
      };

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'raw': raw,
      'id': id,
    };
  }

  static ChatContent fromJson(Map<String, dynamic> json) {
    return ChatContent(
      type: ChatContentType.values[json['type'] as int],
      raw: json['raw'] as String,
      id: json['id'] as String? ?? shortid.generate(),
    );
  }
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

  String get localized => switch (this) {
        user => l10n.user,
        assist => l10n.assistant,
        system => l10n.system,
      };

  static ChatRole? fromString(String? val) => switch (val) {
        'assistant' => assist,
        _ => values.firstWhereOrNull((p0) => p0.name == val),
      };
}
