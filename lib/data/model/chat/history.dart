import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_chatgpt/data/model/chat/config.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/uuid.dart';
import 'package:hive_flutter/adapters.dart';

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

  /// session example:
  /// ```json
  /// {
  ///    "id": "lwr6ZBr5KMhQrprwijlQD",
  ///    "topic": "执行脚本路径问题",
  ///    "memoryPrompt": "",
  ///    "messages": [
  ///        {
  ///            "id": "e2XeOfnUYaheo0trvRF_U",
  ///            "date": "2023/11/6 15:57:22",
  ///            "role": "user",
  ///            "content": "使用golang的exec，执行与golang程序处于不同目录的脚本，显示找不到文件，怎么解决"
  ///        },
  ///        {
  ///            "id": "tgk0u_hORmQO6-vsBtXic",
  ///            "date": "2023/11/6 15:57:22",
  ///            "role": "assistant",
  ///            "content": "在Go语言中，使用`os/exec`包执行脚本或程序时，需要提供完整的文件路径。如果你的脚本或程序位于与Go程序不同的目录下，你需要使用脚本或程序的绝对路径。\n\n下面是一个例子：\n\n```go\npackage main\n\nimport (\n\t\"log\"\n\t\"os/exec\"\n)\n\nfunc main() {\n\tcmd := exec.Command(\"/完整路径/到你的脚本\", \"可能的\", \"参数\")\n\terr := cmd.Run()\n\tif err != nil {\n\t\tlog.Fatal(err)\n\t}\n}\n```\n\n在上述代码中，替换`\"/完整路径/到你的脚本\"`为你的脚本或程序的完整路径。例如，如果你的脚本在`/home/user/scripts/myscript.sh`，你应该使用该路径。\n\n如果你不确定脚本或程序的完整路径，你可以在终端中使用`pwd`命令（在脚本或程序的目录中）来获取当前目录的路径，然后将它与脚本或程序的文件名拼接起来。\n\n如果你的脚本或程序在Go程序的子目录中，你也可以使用相对路径。例如，如果你的Go程序在`/home/user/mygoapp`，你的脚本在`/home/user/mygoapp/scripts/myscript.sh`，你可以使用`scripts/myscript.sh`作为路径。\n\n注意，你的脚本或程序需要有执行权限。你可以使用`chmod +x /完整路径/到你的脚本`来添加执行权限。",
  ///            "streaming": false,
  ///            "model": "gpt-4-0613"
  ///        }
  ///    ],
  ///    "stat": {
  ///        "tokenCount": 0,
  ///        "wordCount": 0,
  ///        "charCount": 631
  ///    },
  ///    "lastUpdate": 1699257480906,
  ///    "lastSummarizeIndex": 0,
  ///    "mask": {
  ///        "id": "Ohw0r23BAAO1GaXcRUJEo",
  ///        "avatar": "gpt-bot",
  ///        "name": "新的聊天",
  ///        "context": [],
  ///        "syncGlobalConfig": true,
  ///        "modelConfig": {
  ///            "model": "gpt-4-0613",
  ///            "temperature": 0.5,
  ///            "top_p": 1,
  ///            "max_tokens": 2000,
  ///            "presence_penalty": 0,
  ///            "frequency_penalty": 0,
  ///            "sendMemory": true,
  ///            "historyMessageCount": 4,
  ///            "compressMessageLengthThreshold": 1000,
  ///            "enableInjectSystemPrompts": true,
  ///            "template": "{{input}}"
  ///        },
  ///        "lang": "cn",
  ///        "builtin": false,
  ///        "createdAt": 1699257396822
  ///    }
  /// }
  static ChatHistory fromGPTNext(Map<String, dynamic> session) {
    final items = <ChatHistoryItem>[];
    final {
      'messages': List messages,
      'topic': String topic,
      // There is no need to restore prompt for old chat,
      // because prompt is only used for new chat
      //'memoryPrompt': String prompt,

      // Temporarily ignore these configs
      // 'mask': {
      //   'modelConfig': {
      //     'model': String model,
      //     'temperature': double temperature,
      //     'historyMessageCount': int historyMessageCount,
      //   }
      // },
    } = session;

    for (final message in messages) {
      final {
        'role': String role,
        'content': String content,
        'date': String date,
      } = message;
      final roleEnum = switch (role) {
        'user' => ChatRole.user,
        'assistant' => ChatRole.assist,
        'system' => ChatRole.system,
        final role => throw UnimplementedError('role: $role'),
      };
      final contentEnum = ChatContent(
        type: ChatContentType.text,
        raw: content,
      );
      final dateEnum = DateTime.parse(date);
      items.add(ChatHistoryItem(
        id: uuid.v4(),
        role: roleEnum,
        content: [contentEnum],
        createdAt: dateEnum,
      ));
    }

    return ChatHistory(
      id: uuid.v4(),
      name: topic,
      items: items,
    );
  }
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

  String get name => switch (this) {
        user => l10n.user,
        assist => l10n.assistant,
        system => l10n.system,
      };
}
