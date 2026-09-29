// The chat core against the real runtime: fl_pi_llm on QuickJS, pi's
// sessions in the encrypted store, a mock OpenAI-compatible server.
import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/core/llm/store.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/data/store/memory.dart';

/// Streams `Echo: <last user text>` one word at a time.
Future<(HttpServer, List<Map<String, Object?>>)> mockServer() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  final seen = <Map<String, Object?>>[];
  server.listen((req) async {
    if (req.method == 'GET') {
      req.response
        ..headers.contentType = ContentType.json
        ..write(jsonEncode({
          'data': [
            {'id': 'echo'},
          ],
        }));
      await req.response.close();
      return;
    }
    final body = jsonDecode(await utf8.decodeStream(req)) as Map<String, Object?>;
    seen.add(body);
    final msgs = (body['messages'] as List).cast<Map>();
    final last = msgs.lastWhere((m) => m['role'] == 'user');
    final content = last['content'];
    final text = content is String
        ? content
        : (content as List).whereType<Map>().where((p) => p['type'] == 'text').map((p) => p['text']).join();
    final res = req.response
      ..headers.contentType = ContentType('text', 'event-stream')
      ..bufferOutput = false;
    void send(Map<String, Object?> delta, [String? finish]) => res.write('data: ${jsonEncode({
      'id': 'c',
      'object': 'chat.completion.chunk',
      'created': 1,
      'model': body['model'],
      'choices': [{'index': 0, 'delta': delta, 'finish_reason': finish}],
    })}\n\n');
    if (msgs.last['role'] == 'tool') {
      send({'content': 'Done.'}, 'stop');
      res.write('data: [DONE]\n\n');
      await res.close();
      return;
    }
    // `remember X`: saves X with the memory tool.
    if (text.startsWith('remember ')) {
      send({
        'tool_calls': [
          {
            'index': 0,
            'id': 'call_1',
            'type': 'function',
            'function': {
              'name': 'memory_write',
              'arguments': jsonEncode({'path': '/memories/user.md', 'content': text.substring(9)}),
            },
          },
        ],
      }, 'tool_calls');
      res.write('data: [DONE]\n\n');
      await res.close();
      return;
    }
    for (final w in ['Echo: ', ...text.split(' ').map((w) => '$w ')]) {
      send({'content': w});
      await res.flush();
    }
    send({}, 'stop');
    res.write('data: [DONE]\n\n');
    await res.close();
  });
  return (server, seen);
}

ExternalLibrary nativeLib() => ExternalLibrary.open(switch (Platform.operatingSystem) {
  'macos' => 'build/native_assets/macos/libfl_pi_llm.dylib',
  'windows' => 'build/native_assets/windows/fl_pi_llm.dll',
  _ => 'build/native_assets/linux/libfl_pi_llm.so',
});

void main() {
  late HttpServer server;
  late List<Map<String, Object?>> seen;

  setUpAll(() async {
    (server, seen) = await mockServer();
    SqliteDb.openInMemory();
    await Stores.init();
    SqlitePiSessionStore();
    Stores.llm.customProviders.set([
      LlmCustomProvider(
        id: 'mock',
        name: 'Mock',
        api: LlmApi.openaiCompletions,
        baseUrl: 'http://127.0.0.1:${server.port}/v1',
        models: const ['echo'],
      ),
    ]);
    Stores.setting.genTitle.set(false);
    await Llm.init(
      credentials: MemoryCredentials({'mock': LlmCredential.apiKey('k')}),
      externalLibrary: nativeLib(),
    );
  });

  tearDownAll(() async {
    await Chats.closeAll();
    await Llm.rt.dispose();
    await server.close(force: true);
  });

  test('the configured custom provider is the default model', () {
    expect(Llm.configured.value, {'mock'});
    expect(Llm.defaultModel, const LlmModelRef('mock', 'echo'));
  });

  test('a chat sends, streams and keeps its conversation', () async {
    final id = Chats.create();
    final chat = await Chats.open(id);
    final seenText = <String>[];
    void onStream() {
      final t = chat.streaming.value?.text;
      if (t != null) seenText.add(t);
    }

    chat.streaming.addListener(onStream);
    await Chats.send(id, 'hello there');
    chat.streaming.removeListener(onStream);

    final roles = chat.entries.value.map((e) => e.message?.role).toList();
    expect(roles, ['user', 'assistant']);
    expect(chat.entries.value.last.message!.text.trim(), 'Echo: hello there');
    expect(seenText.length, greaterThan(1), reason: 'the reply should arrive in pieces');
    expect(chat.running.value, isFalse);
    expect(Stores.chat.fetch(id)!.updatedAt.isAfter(DateTime.now().subtract(const Duration(minutes: 1))), isTrue);

    // Closed and reopened, the conversation is still there.
    await Chats.close(id);
    final again = await Chats.open(id);
    expect(again.entries.value.length, 2);
  });

  test('editing a message makes a version, and switching back restores the old branch', () async {
    final id = Chats.create();
    await Chats.send(id, 'first');
    final chat = await Chats.open(id);
    final original = chat.entries.value.first;

    await Chats.edit(id, original, 'second');
    expect(chat.entries.value.last.message!.text.trim(), 'Echo: second');
    final edited = chat.entries.value.first;
    expect(chat.versionsOf(edited).map((e) => e.message!.text), ['first', 'second']);

    await Chats.switchTo(id, original);
    expect(chat.entries.value.first.id, original.id);
    expect(chat.entries.value.last.message!.text.trim(), 'Echo: first');
  });

  test('images reach the model; text files are inlined', () async {
    final dir = await Directory.systemTemp.createTemp('gptbox');
    addTearDown(() => dir.delete(recursive: true));
    final img = File('${dir.path}/a.png')
      ..writeAsBytesSync(base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
      ));
    final txt = File('${dir.path}/notes.txt')..writeAsStringSync('secret notes');
    final id = Chats.create();
    await Chats.send(id, 'look', files: [img.path, txt.path]);
    final sent = jsonEncode(seen.last);
    expect(sent, contains('image_url'));
    expect(sent, contains('secret notes'));
  });

  test('search finds a chat by what was said in it', () async {
    final id = Chats.create();
    await Chats.send(id, 'a very particular zebra');
    expect(Chats.search('zebra').map((m) => m.id), contains(id));
    expect(Chats.search('no such thing'), isEmpty);
  });

  test('trash, restore, delete for good', () async {
    final id = Chats.create();
    await Chats.send(id, 'bye');
    await Chats.trash(id);
    expect(Stores.chat.all().map((m) => m.id), isNot(contains(id)));
    expect(Stores.chat.all(trashed: true).map((m) => m.id), contains(id));
    Chats.restore(id);
    expect(Stores.chat.all().map((m) => m.id), contains(id));
    await Chats.deleteForever(id);
    expect(Stores.chat.fetch(id), isNull);
    expect((await Llm.rt.sessions()).map((s) => s.id), isNot(contains(id)));
  });

  test('the system prompt carries the memory index, and reaches open chats', () async {
    final id = Chats.create();
    await Chats.open(id);
    Stores.llm.systemPrompt.set('Be brief.');
    Stores.memory.write(MemoryStore.index, '- likes tea');
    await Chats.reconfigure();
    await Chats.send(id, 'hi');
    final sys = jsonEncode(seen.last['messages']);
    expect(sys, contains('Be brief.'));
    expect(sys, contains('likes tea'));
  });

  test('the model saves to memory without asking', () async {
    Stores.mcp.enabled.set(true);
    addTearDown(() => Stores.mcp.enabled.set(false));
    final id = Chats.create();
    await Chats.open(id);
    await Chats.reconfigure();
    await Chats.send(id, 'remember likes green tea');
    expect(Stores.memory.read('user.md'), 'likes green tea');
    expect(Chats.openOf(id)!.approvals.value, isEmpty);
  });

  test('switched off, the memory tools and prompt are gone', () {
    Stores.mcp.enabled.set(true);
    Stores.mcp.disabledTools.set([TfMemory.groupName]);
    addTearDown(() {
      Stores.mcp.enabled.set(false);
      Stores.mcp.disabledTools.set([]);
    });
    expect(Tools.enabled.map((t) => t.name), isNot(contains('memory_view')));
    expect(Chats.systemPromptFor(null), isNot(contains('# Memory')));
  });
}
