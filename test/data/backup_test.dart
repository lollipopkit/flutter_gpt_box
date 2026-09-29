import 'package:fl_lib/fl_lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/llm/store.dart';
import 'package:gpt_box/data/model/backup.dart';
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

  Backup backupWith(Map<String, ({String text, int mtime})> sessions) => Backup(
    date: 1,
    chats: const {},
    llm: const {},
    tools: const {},
    settings: const {},
    sessions: sessions,
  );

  test('round-trips through JSON', () async {
    await files.append('/sessions/-/1_a.jsonl', 'h\n');
    final b = await Backup.fromStores();
    final back = Backup.fromJson(b.toJson().cast<String, Object?>());
    expect(back.sessions['/sessions/-/1_a.jsonl']!.text, 'h\n');
  });

  test('refuses another format version', () {
    expect(() => Backup.fromJson({'version': 2}), throwsFormatException);
  });

  test('a missing session is added, an extended one fast-forwarded', () async {
    await files.write('/s/old.jsonl', 'a\n');
    await backupWith({
      '/s/new.jsonl': (text: 'n\n', mtime: 1),
      '/s/old.jsonl': (text: 'a\nb\n', mtime: 1),
    }).merge();
    expect(await files.read('/s/new.jsonl'), 'n\n');
    expect(await files.read('/s/old.jsonl'), 'a\nb\n');
  });

  test('a backup behind the local log changes nothing', () async {
    await files.write('/s/a.jsonl', 'a\nb\n');
    await backupWith({'/s/a.jsonl': (text: 'a\n', mtime: 9999999999999)}).merge(force: true);
    expect(await files.read('/s/a.jsonl'), 'a\nb\n');
  });

  test('diverged logs keep the newer one, or the backup when forced', () async {
    await files.write('/s/a.jsonl', 'a\nlocal\n');
    await backupWith({'/s/a.jsonl': (text: 'a\nremote\n', mtime: 0)}).merge();
    expect(await files.read('/s/a.jsonl'), 'a\nlocal\n');
    await backupWith({'/s/a.jsonl': (text: 'a\nremote\n', mtime: 0)}).merge(force: true);
    expect(await files.read('/s/a.jsonl'), 'a\nremote\n');
  });
}
