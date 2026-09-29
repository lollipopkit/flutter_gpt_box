import 'dart:convert';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/app/backup.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/data/store/all.dart';

ChatHistory _history(String id, String text) => ChatHistory(
  id: id,
  name: 'name-$id',
  items: [
    ChatHistoryItem(
      id: 'item-$id',
      role: ChatRole.user,
      content: [ChatContent.text(text)],
      createdAt: DateTime(2024, 1, 15, 10),
    ),
  ],
);

void main() {
  setUp(SqliteDb.openInMemory);
  tearDown(SqliteDb.close);

  group('HistoryStore', () {
    test('put and fetchAll round-trip through JSON', () {
      Stores.history.put(_history('h1', 'hello'));

      final all = Stores.history.fetchAll();
      expect(all.keys, ['h1']);
      final restored = all['h1']!;
      expect(restored.name, 'name-h1');
      expect(restored.items.single.content.single.raw, 'hello');
      expect(restored.items.single.role, ChatRole.user);
    });

    test('delete removes the history', () {
      Stores.history.put(_history('h1', 'hello'));
      Stores.history.delete('h1');
      expect(Stores.history.fetchAll(), isEmpty);
    });

    test('fetchAll skips non-map values', () {
      Stores.history.set('broken', 'not-a-map');
      Stores.history.put(_history('h1', 'hello'));
      expect(Stores.history.fetchAll().keys, ['h1']);
    });
  });

  group('ConfigStore', () {
    test('fetch of defaultId creates the default config', () {
      expect(Stores.config.fetch(ChatConfigX.defaultId), ChatConfigX.defaultOne);
      expect(Stores.config.keys(), contains(ChatConfigX.defaultId));
    });

    test('put and fetch round-trip', () {
      const cfg = ChatConfig(id: 'c1', model: 'gpt-4o', key: 'k', name: 'n');
      Stores.config.put(cfg);
      expect(Stores.config.fetch('c1'), cfg);
    });

    test('fetchAll excludes non-profile keys', () {
      Stores.config.put(const ChatConfig(id: 'c1'));
      Stores.config.profileId.set('c1');
      expect(Stores.config.fetchAll().keys, ['c1']);
    });

    test('default config cannot be deleted', () {
      Stores.config.put(const ChatConfig(id: 'c1'));
      expect(Stores.config.delete(ChatConfigX.defaultId), false);
      expect(Stores.config.delete('c1'), true);
      expect(Stores.config.fetch('c1'), isNull);
    });
  });

  group('Backup', () {
    test('loadFromStore survives a JSON round-trip', () async {
      Stores.history.put(_history('h1', 'hello'));
      Stores.config.put(const ChatConfig(id: 'c1', model: 'gpt-4o'));
      Stores.mcp.set('customKey', 'customValue');
      Stores.trash.addHistory(_history('t1', 'trashed'));

      final raw = json.encode(await Backup.loadFromStore());
      final restored = Backup.fromJsonString(raw);

      expect(restored.version, Backup.validVer);
      expect(restored.history.map((e) => e.id), ['h1']);
      expect(restored.configs.map((e) => e.id), ['c1']);
      expect(restored.tools['customKey'], 'customValue');
      expect(restored.trashes?.values.map((e) => e.id), ['t1']);
    });
  });
}
