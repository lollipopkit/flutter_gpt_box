import 'package:fl_lib/fl_lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/backup.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';

void main() {
  late MemoryStore mem;

  setUp(() async {
    SqliteDb.openInMemory();
    await Stores.init();
    mem = LlmStores.memory;
  });
  tearDown(() => SqliteDb.close());

  Future<String> run(ToolFunc t, Map<String, Object?> args) async {
    final r = await t.run(args, ToolCtx('test', LlmCancelToken()));
    return r.content.map((e) => e['text'] ?? '').join();
  }

  group('paths', () {
    test('are relative to /memories, however written', () {
      expect(MemoryStore.keyOf('/memories/a/b.md'), 'a/b.md');
      expect(MemoryStore.keyOf('/a.md'), 'a.md');
      expect(MemoryStore.keyOf('a//b.md/'), 'a/b.md');
      expect(MemoryStore.keyOf('/memories'), '');
    });

    test('never leave it, nor reach the store bookkeeping', () {
      for (final p in ['../x', '/memories/../x', 'a/./b', r'a\b', '__lkpt_lastUpdateTs', 'a/_x', 'a\u202Eb']) {
        expect(() => MemoryStore.keyOf(p), throwsA(isA<MemoryPathError>()), reason: p);
      }
    });

    test('a file and a directory cannot share a name', () {
      mem.write('a', 'x');
      expect(() => mem.write('a/b', 'y'), throwsA(isA<MemoryPathError>()));
      mem.write('d/e', 'x');
      expect(() => mem.write('d', 'y'), throwsA(isA<MemoryPathError>()));
    });
  });

  group('tools', () {
    test('write, view with line numbers and a range', () async {
      await run(TfMemoryWrite.instance, {'path': '/memories/u.md', 'content': 'a\nb\nc'});
      expect(await run(TfMemoryView.instance, {'path': '/memories/u.md'}), contains('     2\tb'));
      final part = await run(TfMemoryView.instance, {
        'path': 'u.md',
        'view_range': [2, -1],
      });
      expect(part, isNot(contains('\ta')));
      expect(part, contains('     3\tc'));
      expect(await run(TfMemoryView.instance, {}), contains('/memories/u.md'));
    });

    test('edit replaces one occurrence, or all when asked', () async {
      mem.write('u.md', 'x y x');
      await expectLater(
        run(TfMemoryEdit.instance, {'path': 'u.md', 'old_str': 'x', 'new_str': 'z'}),
        throwsArgumentError,
      );
      await run(TfMemoryEdit.instance, {'path': 'u.md', 'old_str': 'y', 'new_str': 'w'});
      await run(TfMemoryEdit.instance, {'path': 'u.md', 'old_str': 'x', 'new_str': 'z', 'replace_all': true});
      expect(mem.read('u.md'), 'z w z');
    });

    test('search finds lines and paths', () async {
      mem.write('a.md', 'likes Tea\nno');
      mem.write('tea/b.md', 'x');
      final out = await run(TfMemorySearch.instance, {'query': 'tea'});
      expect(out, contains('/memories/a.md:1: likes Tea'));
      expect(out, contains('/memories/tea/b.md: (path)'));
      expect(await run(TfMemorySearch.instance, {'query': 'tea', 'case_sensitive': true}), contains('(path)'));
    });

    test('move and delete files and directories', () async {
      mem.write('d/a.md', '1');
      mem.write('d/b.md', '2');
      await run(TfMemoryMove.instance, {'from': 'd', 'to': 'e'});
      expect(mem.files().keys, ['e/a.md', 'e/b.md']);
      await expectLater(run(TfMemoryDelete.instance, {'path': '/memories'}), throwsA(isA<MemoryPathError>()));
      await run(TfMemoryDelete.instance, {'path': 'e'});
      expect(mem.files(), isEmpty);
    });

    test('run without asking', () {
      expect(TfMemory.all.every((t) => t.trusted), isTrue);
      expect(TfHttpReq.instance.trusted, isFalse);
    });
  });

  test('the prompt lists the files and holds the index', () {
    expect(TfMemory.prompt(tools: false), isNull);
    mem.write(MemoryStore.index, '- [User](user.md) — who');
    mem.write('user.md', 'x');
    final p = TfMemory.prompt(tools: true)!;
    expect(p, contains('persistent memory'));
    expect(p, contains('- /memories/user.md'));
    expect(p, contains('<memory_index>\n- [User](user.md) — who\n</memory_index>'));
  });

  test('backups carry files and their deletion', () async {
    mem.write('a.md', 'x');
    final bak = await Backup.fromStores();
    mem.write('b.md', 'y');
    await Future<void>.delayed(const Duration(milliseconds: 2));
    mem.delete('a.md');
    // The deletion here is newer than the backup's file: it stays deleted.
    await bak.merge();
    expect(mem.read('a.md'), isNull);
    expect(mem.read('b.md'), 'y');
  });
}
