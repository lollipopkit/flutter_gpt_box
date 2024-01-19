import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/data/model/chat/config.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/data/res/uuid.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../view/widget/code.dart';
import '../../res/build.dart';

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
  ChatConfig? config;

  ChatHistory({
    required this.items,
    required this.id,
    this.name,
    this.config,
  });

  ChatHistory.noid({
    required this.items,
    this.name,
    this.config,
  }) : id = uuid.v4();

  static ChatHistory get empty => ChatHistory.noid(items: []);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((e) => e.toJson()).toList(),
      'config': config?.toJson(),
    };
  }

  static ChatHistory fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      id: json['id'] as String,
      name: json['name'] as String,
      items: (json['items'] as List)
          .map((e) => ChatHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      config: json['config'] == null
          ? null
          : ChatConfig.fromJson(json['config'] as Map<String, dynamic>),
    );
  }

  (Widget, String) get forShare {
    final mdContent = items
        .map((e) => '##### ${e.role.toSingleChar}${e.toMarkdown}')
        .join('\n\n');
    final widget = ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      children: [
        Text(
          name ?? l10n.untitled,
          style: const TextStyle(fontSize: 21),
        ),
        UIs.height13,
        MarkdownBody(
          data: mdContent,
          shrinkWrap: true,
          builders: {
            'code': CodeElementBuilder(),
          },
        ),
        UIs.height13,
        Text(
          '${l10n.shareFrom} GPT Box v1.0.${Build.build}',
          style: const TextStyle(
            fontSize: 9,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
    return (widget, mdContent);
  }

  static ChatHistory get example => ChatHistory.noid(
        name: l10n.help,
        items: [
          ChatHistoryItem.noid(role: ChatRole.system, content: [
            ChatContent(
              type: ChatContentType.text,
              raw: l10n.initChatHelp,
            )
          ]),
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

  ChatHistoryItem.noid({
    required this.role,
    required this.content,
  })  : id = uuid.v4(),
        createdAt = DateTime.now();

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

  static ChatHistoryItem get emptyAssist => ChatHistoryItem.noid(
        content: [
          ChatContent(
            type: ChatContentType.text,
            raw: '',
          )
        ],
        role: ChatRole.assist,
      );

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
          .map((e) => ChatContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      id: json['id'] as String,
    );
  }

  ChatHistoryItem copyWith({
    ChatRole? role,
    List<ChatContent>? content,
    DateTime? createdAt,
  }) {
    return ChatHistoryItem(
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      id: id,
    );
  }
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
  ;
}

@HiveType(typeId: 2)
final class ChatContent {
  @HiveField(0)
  final ChatContentType type;
  @HiveField(1)
  String raw;

  ChatContent({required this.type, required this.raw});

  OpenAIChatCompletionChoiceMessageContentItemModel get toOpenAI =>
      switch (type) {
        ChatContentType.text =>
          OpenAIChatCompletionChoiceMessageContentItemModel.text(raw),
        ChatContentType.image =>
          OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(raw),
        _ => throw UnimplementedError(),
      };

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'raw': raw,
    };
  }

  static ChatContent fromJson(Map<String, dynamic> json) {
    return ChatContent(
      type: ChatContentType.values[json['type'] as int],
      raw: json['raw'] as String,
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

  String get toSingleChar => switch (this) {
        user => 'Q: ',
        assist => 'A: ',
        system => 'S: ',
      };

  String get name => switch (this) {
        user => l10n.user,
        assist => l10n.assistant,
        system => l10n.system,
      };
}
