import 'package:gpt_box/data/model/chat/config.dart';
import 'package:shortid/shortid.dart';

import 'history/history.dart';

abstract final class GPTNextConvertor {
  static ChatHistory toChatHistory(Map session) {
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
      final role = message['role'] as String;
      final content = message['content'] as String;
      final date = message['date'] as String;
      final roleEnum = ChatRole.fromString(role);
      if (roleEnum == null) {
        continue;
      }
      final contentEnum = ChatContent.text(content);
      final dateEnum = parseDate(date);
      if (dateEnum == null) {
        continue;
      }
      items.add(ChatHistoryItem(
        role: roleEnum,
        content: [contentEnum],
        createdAt: dateEnum,
        id: shortid.generate(),
      ));
    }

    return ChatHistory(
      id: shortid.generate(),
      name: topic,
      items: items,
    );
  }

  /// 2023/11/6 15:57:22
  static DateTime? parseDate(String date) {
    final parts = date.trim().split(' ');
    if (parts.length != 2) return null;
    final dateParts = parts[0].split('/').map(int.tryParse).toList();
    final timeParts = parts[1].split(':').map(int.tryParse).toList();
    if (dateParts.length != 3 || timeParts.length != 3) return null;
    if (dateParts.contains(null) || timeParts.contains(null)) return null;

    return DateTime(
      dateParts[0]!,
      dateParts[1]!,
      dateParts[2]!,
      timeParts[0]!,
      timeParts[1]!,
      timeParts[2]!,
    );
  }

  static ChatConfig parseConfig(Map map, ChatConfig cfg) {
    try {
      final {
        'app-config': {
          'modelConfig': {
            'model': String model,
            'historyMessageCount': int historyMessageCount,
          }
        },
      } = map;
      cfg = cfg.copyWith(
        model: model,
        historyLen: historyMessageCount,
      );
    } catch (e) {
      // ignore
    }

    try {
      final {
        'access-control': {
          'openaiUrl': String url,
          'openaiApiKey': String key,
        },
      } = map;
      cfg = cfg.copyWith(url: url, key: key);
    } catch (e) {
      // ignore
    }

    return cfg;
  }
}
