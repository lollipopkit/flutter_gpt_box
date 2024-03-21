import 'package:flutter_chatgpt/core/ext/iterable.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';

abstract final class OpenAIConvertor {
  static ChatHistory toChatHistory(Map session) {
    final title = session['title'] as String;
    final mapping = session['mapping'] as Map<String, dynamic>;
    final items = <ChatHistoryItem>[];

    var item = mapping.values
        .firstWhereOrNull((e) => e is Map && e['parent'] == null) as Map?;
    var children = item?['children'] as List?;

    var times = 0;
    while (children != null && children.isNotEmpty && times++ < 100) {
      final nextId = children.firstOrNull;
      if (nextId == null || nextId is! String) break;

      item = mapping[nextId];
      children = item?['children'] as List?;

      final msg = item?['message'] as Map?;
      final roleStr = msg?['author']?['role'] as String?;
      final role = ChatRole.fromString(roleStr);
      if (role == null) continue;

      final content = msg?['content']?['parts'] as List?;
      if (content == null || content.isEmpty) continue;

      final contentStr = content.join('\n');
      if (contentStr.isEmpty) continue;

      final createdTime = msg?['create_time'] as int;
      final time = DateTime.fromMillisecondsSinceEpoch(createdTime * 1000);

      items.add(ChatHistoryItem.single(
        role: role,
        raw: contentStr,
        createdAt: time,
      ));
    }

    return ChatHistory.noid(items: items, name: title);
  }
}
