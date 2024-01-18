import '../../res/uuid.dart';
import 'history.dart';

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
      final roleEnum = switch (role) {
        'user' => ChatRole.user,
        'assistant' => ChatRole.assist,
        'system' => ChatRole.system,
        final role => throw ArgumentError('role: $role'),
      };
      final contentEnum = ChatContent(
        type: ChatContentType.text,
        raw: content,
      );
      final dateEnum = parseDate(date);
      if (dateEnum == null) {
        continue;
      }
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

  /// 2023/11/6 15:57:22
  static DateTime? parseDate(String date) {
    final parts = date.split(' ');
    final dateParts = parts[0].split('/');
    final timeParts = parts[1].split(':');

    if (dateParts.length != 3 || timeParts.length != 3) {
      return null;
    }

    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final second = int.parse(timeParts[2]);

    return DateTime(year, month, day, hour, minute, second);
  }
}
