import 'package:fl_lib/fl_lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:llmbox/data/model/backup.dart';
import 'package:llmbox/data/store/all.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';

import '../core/chats_test.dart' show initLlm;

void main() {
  setUpAll(() async {
    SqliteDb.openInMemory();
    await Stores.init();
    await initLlm();
    SqliteDb.close();
  });
  tearDownAll(() async {
    await Chats.closeAll();
    await Llm.rt.dispose();
  });
  setUp(() async {
    SqliteDb.openInMemory();
    await Stores.init();
  });
  tearDown(() => SqliteDb.close());

  // The runtime's sessions outlive each test's stores: every test its own chats.
  var n = 0;
  String chat(String name) {
    final id = '$name-${n++}';
    LlmStores.chat.put(ChatMeta(id: id, updatedAt: DateTime(2026)));
    return id;
  }

  /// An exported entry: a message by [role] saying [text].
  Map<String, Object?> said(String uid, String? parent, String text, {String role = 'user'}) => {
    'uid': uid,
    'parent': parent,
    'type': 'message',
    'timestamp': 1,
    'message': {
      'role': role,
      'content': [
        {'type': 'text', 'text': text},
      ],
      'timestamp': 1,
    },
  };

  /// What chat [id]'s session says, every version.
  Future<List<String>> saidIn(String id) async => [
    for (final e in (await Chats.exportChat(id)).entries) ((e['message'] as Map)['content'] as List).first['text'] as String,
  ];

  Future<bool> hasSession(String id) async => (await Llm.rt.sessions()).any((s) => s.id == id);

  Backup backupWith({
    Map<String, Object?> chats = const {},
    Map<String, Object?> memory = const {},
    Map<String, Object?> settings = const {},
    Map<String, ChatExport> sessions = const {},
  }) => Backup(date: 1, chats: chats, llm: const {}, tools: const {}, memory: memory, settings: settings, sessions: sessions);

  /// Store data as a backup carries it: values, and their times.
  Map<String, Object?> data(Map<String, Object?> values, Map<String, int> ts) => {
    ...values,
    LlmStores.chat.lastUpdateTsKey: ts,
  };

  group('format', () {
    test('round-trips through JSON', () async {
      final a = chat('a');
      await Chats.importChat(a, [said('1', null, 'h')]);
      final b = await Backup.fromStores();
      final back = Backup.fromJson(b.toJson().cast<String, Object?>());
      expect(back.sessions[a]!.entries.single['uid'], '1');
      expect(back.sessions[a]!.tip, '1');
    });

    test('refuses an older format, and says so for a newer one', () {
      expect(() => Backup.fromJson({'version': 3}), throwsFormatException);
      expect(() => Backup.fromJson({'version': Backup.formatVersion + 1}), throwsA(isA<BackupTooNew>()));
    });

    test('with a password it is encrypted, and opens only with it', () async {
      final a = chat('a');
      final text = await (await Backup.fromStores()).encode(password: 'pw');
      expect(Backup.isEncrypted(text), isTrue);
      expect(text, isNot(contains('"chats"')));
      expect((await Backup.parse(text, password: 'pw')).chats.keys, contains(a));
      await expectLater(Backup.parse(text), throwsA(isA<BackupPasswordNeeded>()));
      await expectLater(Backup.parse(text, password: 'wrong'), throwsA(anything));
    });

    test('without one it is plain JSON', () async {
      final text = await (await Backup.fromStores()).encode();
      expect(Backup.isEncrypted(text), isFalse);
      expect((await Backup.parse(text)).date, greaterThan(0));
    });

    test("this device's own settings stay out of it", () async {
      Stores.setting.paneListWidth.set(300);
      Stores.setting.genTitle.set(false);
      final b = await Backup.fromStores();
      expect(b.settings.keys, isNot(contains('paneListWidth')));
      expect(b.settings.keys, contains('genTitle'));
      expect((await Backup.fromStores(includeSettings: false)).settings, isEmpty);
    });
  });

  group('stores', () {
    test('a key only the backup has is added', () async {
      await backupWith(chats: data({'a': ChatMeta(id: 'a', updatedAt: DateTime(2026)).toJson()}, {'a': 5})).merge();
      expect(LlmStores.chat.fetch('a'), isNotNull);
    });

    test('the newer write wins; force takes the backup', () async {
      final a = chat('a');
      final local = LlmStores.chat.lastUpdateTs![a]!;
      final old = data({a: ChatMeta(id: a, title: 'old', updatedAt: DateTime(2020)).toJson()}, {a: local - 1000});
      await backupWith(chats: old).merge();
      expect(LlmStores.chat.fetch(a)!.title, isNull);
      await backupWith(chats: old).merge(force: true);
      expect(LlmStores.chat.fetch(a)!.title, 'old');
    });

    test('a deletion there after the last write here deletes here', () async {
      final a = chat('a');
      final local = LlmStores.chat.lastUpdateTs![a]!;
      await backupWith(chats: data({}, {a: local + 1000})).merge();
      expect(LlmStores.chat.fetch(a), isNull);
    });

    test('what only this device has is kept, even forced', () async {
      final mine = chat('mine');
      await backupWith(chats: data({}, {})).merge(force: true);
      expect(LlmStores.chat.fetch(mine), isNotNull);
    });

    test("this device's own settings are never set by a backup", () async {
      Stores.setting.paneListWidth.set(300);
      await backupWith(
        settings: {'paneListWidth': 999.0, Stores.setting.lastUpdateTsKey: {'paneListWidth': 9999999999999}},
      ).merge(force: true);
      expect(Stores.setting.paneListWidth.get(), 300);
    });
  });

  group('sessions', () {
    test('a missing session is added, a continued one gets what it lacks', () async {
      final fresh = chat('new');
      final old = chat('old');
      await Chats.importChat(old, [said('a', null, 'a')]);
      await backupWith(sessions: {
        fresh: (entries: [said('n', null, 'n')], tip: 'n'),
        old: (entries: [said('a', null, 'a'), said('b', 'a', 'b', role: 'assistant')], tip: 'b'),
      }).merge();
      expect(await saidIn(fresh), ['n']);
      expect(await saidIn(old), ['a', 'b']);
    });

    test('diverged sessions keep both, forced or not', () async {
      final a = chat('a');
      await Chats.importChat(a, [said('a', null, 'a'), said('l', 'a', 'local', role: 'assistant')]);
      final remote = (entries: [said('a', null, 'a'), said('r', 'a', 'remote', role: 'assistant')], tip: 'r');
      await backupWith(sessions: {a: remote}).merge();
      expect(await saidIn(a), ['a', 'local', 'remote']);
      await backupWith(sessions: {a: remote}).merge(force: true);
      expect(await saidIn(a), ['a', 'local', 'remote'], reason: 'nothing written twice');
    });

    test('a session of no chat here is not taken', () async {
      await backupWith(sessions: {'ghost': (entries: [said('g', null, 'g')], tip: 'g')}).merge();
      expect(await hasSession('ghost'), isFalse);
    });

    test('a chat deleted by the merge takes its session with it', () async {
      final a = chat('a');
      await Chats.importChat(a, [said('a', null, 'a')]);
      final local = LlmStores.chat.lastUpdateTs![a]!;
      await backupWith(chats: data({}, {a: local + 1000})).merge();
      expect(await hasSession(a), isFalse);
    });
  });

  test('the local stamp moves with an edit, and a chat written to, not a backup', () async {
    final before = await Backup.localStamp(includeSettings: false);
    await Future<void>.delayed(const Duration(milliseconds: 2));
    final a = chat('a');
    final edited = await Backup.localStamp(includeSettings: false);
    expect(edited, isNot(before));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await Chats.importChat(a, [said('a', null, 'a')]);
    final written = await Backup.localStamp(includeSettings: false);
    expect(written, isNot(edited));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await Backup.fromStores();
    expect(await Backup.localStamp(includeSettings: false), written, reason: 'reading the chats for a backup is no change');
  });
}
