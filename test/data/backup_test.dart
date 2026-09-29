import 'package:fl_lib/fl_lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/llm/store.dart';
import 'package:gpt_box/data/model/backup.dart';
import 'package:gpt_box/data/model/chat.dart';
import 'package:gpt_box/data/store/all.dart';

void main() {
  late SqlitePiSessionStore files;

  setUp(() async {
    SqliteDb.openInMemory();
    await Stores.init();
    files = SqlitePiSessionStore.instance;
    // The instance made its table on an earlier database; make it here too.
    SqlitePiSessionStore();
  });
  tearDown(() => SqliteDb.close());

  /// A session file of chat [id], as pi names it.
  String sessionOf(String id) => '/sessions/-/1_$id.jsonl';

  void chat(String id) => Stores.chat.put(ChatMeta(id: id, updatedAt: DateTime(2026)));

  Backup backupWith({
    Map<String, Object?> chats = const {},
    Map<String, Object?> memory = const {},
    Map<String, Object?> settings = const {},
    Map<String, ({String text, int mtime})> sessions = const {},
  }) => Backup(date: 1, chats: chats, llm: const {}, tools: const {}, memory: memory, settings: settings, sessions: sessions);

  /// Store data as a backup carries it: values, and their times.
  Map<String, Object?> data(Map<String, Object?> values, Map<String, int> ts) => {
    ...values,
    Stores.chat.lastUpdateTsKey: ts,
  };

  group('format', () {
    test('round-trips through JSON', () async {
      chat('a');
      await files.append(sessionOf('a'), 'h\n');
      final b = await Backup.fromStores();
      final back = Backup.fromJson(b.toJson().cast<String, Object?>());
      expect(back.sessions[sessionOf('a')]!.text, 'h\n');
    });

    test('refuses an older format, and says so for a newer one', () {
      expect(() => Backup.fromJson({'version': 2}), throwsFormatException);
      expect(() => Backup.fromJson({'version': Backup.formatVersion + 1}), throwsA(isA<BackupTooNew>()));
    });

    test('with a password it is encrypted, and opens only with it', () async {
      chat('a');
      final text = (await Backup.fromStores()).encode(password: 'pw');
      expect(Backup.isEncrypted(text), isTrue);
      expect(text, isNot(contains('"chats"')));
      expect((await Backup.parse(text, password: 'pw')).chats.keys, contains('a'));
      await expectLater(Backup.parse(text), throwsA(isA<BackupPasswordNeeded>()));
      await expectLater(Backup.parse(text, password: 'wrong'), throwsA(anything));
    });

    test('without one it is plain JSON', () async {
      final text = (await Backup.fromStores()).encode();
      expect(Backup.isEncrypted(text), isFalse);
      expect((await Backup.parse(text)).date, greaterThan(0));
    });

    test("this device's own settings stay out of it", () async {
      Stores.setting.paneListWidth.set(300);
      Stores.setting.avatar.set('x');
      final b = await Backup.fromStores();
      expect(b.settings.keys, isNot(contains('paneListWidth')));
      expect(b.settings.keys, contains('avatar'));
      expect((await Backup.fromStores(includeSettings: false)).settings, isEmpty);
    });
  });

  group('stores', () {
    test('a key only the backup has is added', () async {
      await backupWith(chats: data({'a': ChatMeta(id: 'a', updatedAt: DateTime(2026)).toJson()}, {'a': 5})).merge();
      expect(Stores.chat.fetch('a'), isNotNull);
    });

    test('the newer write wins; force takes the backup', () async {
      chat('a');
      final local = Stores.chat.lastUpdateTs!['a']!;
      final old = data({'a': ChatMeta(id: 'a', title: 'old', updatedAt: DateTime(2020)).toJson()}, {'a': local - 1000});
      await backupWith(chats: old).merge();
      expect(Stores.chat.fetch('a')!.title, isNull);
      await backupWith(chats: old).merge(force: true);
      expect(Stores.chat.fetch('a')!.title, 'old');
    });

    test('a deletion there after the last write here deletes here', () async {
      chat('a');
      final local = Stores.chat.lastUpdateTs!['a']!;
      await backupWith(chats: data({}, {'a': local + 1000})).merge();
      expect(Stores.chat.fetch('a'), isNull);
    });

    test('what only this device has is kept, even forced', () async {
      chat('mine');
      await backupWith(chats: data({}, {})).merge(force: true);
      expect(Stores.chat.fetch('mine'), isNotNull);
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
    test('a missing session is added, an extended one fast-forwarded', () async {
      chat('new');
      chat('old');
      await files.write(sessionOf('old'), 'a\n');
      await backupWith(sessions: {
        sessionOf('new'): (text: 'n\n', mtime: 1),
        sessionOf('old'): (text: 'a\nb\n', mtime: 1),
      }).merge();
      expect(await files.read(sessionOf('new')), 'n\n');
      expect(await files.read(sessionOf('old')), 'a\nb\n');
    });

    test('a backup behind the local log changes nothing', () async {
      chat('a');
      await files.write(sessionOf('a'), 'a\nb\n');
      await backupWith(sessions: {sessionOf('a'): (text: 'a\n', mtime: 9999999999999)}).merge(force: true);
      expect(await files.read(sessionOf('a')), 'a\nb\n');
    });

    test('diverged logs keep the newer one, or the backup when forced', () async {
      chat('a');
      await files.write(sessionOf('a'), 'a\nlocal\n');
      await backupWith(sessions: {sessionOf('a'): (text: 'a\nremote\n', mtime: 0)}).merge();
      expect(await files.read(sessionOf('a')), 'a\nlocal\n');
      await backupWith(sessions: {sessionOf('a'): (text: 'a\nremote\n', mtime: 0)}).merge(force: true);
      expect(await files.read(sessionOf('a')), 'a\nremote\n');
    });

    test('a session of no chat here is not taken', () async {
      await backupWith(sessions: {sessionOf('ghost'): (text: 'g\n', mtime: 1)}).merge();
      expect(await files.read(sessionOf('ghost')), isNull);
    });

    test('a chat deleted by the merge takes its session with it', () async {
      chat('a');
      await files.write(sessionOf('a'), 'a\n');
      final local = Stores.chat.lastUpdateTs!['a']!;
      await backupWith(chats: data({}, {'a': local + 1000})).merge();
      expect(await files.read(sessionOf('a')), isNull);
    });
  });

  test('the local stamp moves with an edit', () async {
    final before = Backup.localStamp(includeSettings: false);
    await Future<void>.delayed(const Duration(milliseconds: 2));
    chat('a');
    expect(Backup.localStamp(includeSettings: false), isNot(before));
  });
}
