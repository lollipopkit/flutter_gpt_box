import 'package:fl_lib/fl_lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/llm/store.dart';

void main() {
  late SqlitePiSessionStore store;

  setUp(() {
    SqliteDb.openInMemory();
    store = SqlitePiSessionStore();
  });
  tearDown(() => SqliteDb.close());

  test('an append is a new chunk, read back in order', () async {
    expect(await store.read('/s/a.jsonl'), isNull);
    await store.append('/s/a.jsonl', 'one\n');
    await store.append('/s/a.jsonl', 'two\n');
    expect(await store.read('/s/a.jsonl'), 'one\ntwo\n');
    expect(await store.read('/s/a.jsonl', maxLines: 1), 'one\n');
    expect((await store.stat('/s/a.jsonl'))!.size, 8);
  });

  test('write replaces, rename moves, remove deletes', () async {
    await store.append('/s/a.jsonl', 'old\n');
    await store.write('/s/a.jsonl', 'new\n');
    expect(await store.read('/s/a.jsonl'), 'new\n');
    await store.rename('/s/a.jsonl', '/s/b.jsonl');
    expect(await store.read('/s/a.jsonl'), isNull);
    expect(await store.read('/s/b.jsonl'), 'new\n');
    await store.remove('/s', recursive: true);
    expect(await store.list('/'), isEmpty);
  });

  test('list is recursive under a directory, and only under it', () async {
    await store.append('/sessions/x/1.jsonl', 'a');
    await store.append('/sessions/y/2.jsonl', 'b');
    await store.append('/models/p.json', 'c');
    expect((await store.list('/sessions')).map((f) => f.path).toSet(), {'/sessions/x/1.jsonl', '/sessions/y/2.jsonl'});
    expect(await store.list("/sessionsX"), isEmpty);
  });

  test('search finds the files that contain a string', () async {
    await store.append('/s/a.jsonl', 'hello world');
    await store.append('/s/b.jsonl', 'goodbye');
    expect(store.search('world'), ['/s/a.jsonl']);
    expect(store.dump(), {'/s/a.jsonl': 'hello world', '/s/b.jsonl': 'goodbye'});
  });
}
