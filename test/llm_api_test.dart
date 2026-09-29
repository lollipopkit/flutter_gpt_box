/// Live API tests, through fl_pi_llm. They need credentials, either as
/// environment variables or in `.env` / `test/.env` (see `.env.example`);
/// environment variables win. Without them the whole group is skipped.
///
/// `LLM_API` picks the protocol (an `LlmApi` wire name), default
/// `openai-completions`.
library;

import 'dart:io';

import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final env = _Env.load();
  final baseUrl = env['LLM_BASE_URL'];
  final apiKey = env['LLM_API_KEY'];
  final model = env['LLM_MODEL'] ?? 'gpt-4o-mini';
  final api = LlmApi.fromWire(env['LLM_API']) ?? LlmApi.openaiCompletions;
  final missing = baseUrl == null || apiKey == null || apiKey == 'sk-xxx';

  group('LLM API', skip: missing ? 'LLM_BASE_URL / LLM_API_KEY not configured' : false, () {
    late FlPiLlm llm;
    const ref = LlmModelRef('live', '');
    final m = LlmModelRef('live', model);

    setUpAll(() async {
      llm = await FlPiLlm.start(
        store: MemorySessionStore(),
        credentials: MemoryCredentials({'live': LlmCredential.apiKey(apiKey!)}),
        externalLibrary: ExternalLibrary.open(switch (Platform.operatingSystem) {
          'macos' => 'build/native_assets/macos/libfl_pi_llm.dylib',
          'windows' => 'build/native_assets/windows/fl_pi_llm.dll',
          _ => 'build/native_assets/linux/libfl_pi_llm.so',
        }),
      );
      await llm.setCustomProviders([
        LlmCustomProvider(id: ref.provider, name: 'Live', api: api, baseUrl: baseUrl!, models: [model]),
      ]);
    });
    tearDownAll(() => llm.dispose());

    test('a completion answers', () async {
      final reply = await llm.complete(
        model: m,
        messages: [
          LlmMessage({'role': 'user', 'content': 'Reply with the single word: pong', 'timestamp': 0}),
        ],
      );
      expect(reply.stopReason, 'stop', reason: '${reply.errorMessage}');
      expect(reply.text.toLowerCase(), contains('pong'));
    });

    test('a session streams and remembers', () async {
      final s = await llm.openSession(id: 'live', model: m);
      final deltas = <String>[];
      s.events.listen((e) {
        if (e.textDelta case final d?) deltas.add(d);
      });
      expect((await s.prompt('My name is Zed. Reply OK.')).completed, isTrue);
      final r = await s.prompt('What is my name? One word.');
      expect(r.completed, isTrue, reason: r.error);
      final entries = await s.entries();
      expect(entries.last.message!.text, contains('Zed'));
      expect(deltas, isNotEmpty);
      await s.close();
    });

    test('a wrong key fails the run with an error', () async {
      final bad = await FlPiLlm.start(
        store: MemorySessionStore(),
        credentials: MemoryCredentials({'live': LlmCredential.apiKey('sk-invalid')}),
      );
      await bad.setCustomProviders([
        LlmCustomProvider(id: 'live', name: 'Live', api: api, baseUrl: baseUrl!, models: [model]),
      ]);
      final reply = await bad.complete(
        model: m,
        messages: [LlmMessage({'role': 'user', 'content': 'hi', 'timestamp': 0})],
      );
      expect(reply.stopReason, 'error');
      await bad.dispose();
    });
  });
}

abstract final class _Env {
  static const _keys = ['LLM_BASE_URL', 'LLM_API_KEY', 'LLM_MODEL', 'LLM_API'];

  static Map<String, String> load() {
    final map = <String, String>{};
    final file = [
      File('test/.env'),
      File('.env'),
    ].where((f) => f.existsSync()).firstOrNull;
    if (file != null) {
      for (final line in file.readAsLinesSync()) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        final eq = trimmed.indexOf('=');
        if (eq == -1) continue;
        final value = trimmed.substring(eq + 1).trim();
        if (value.isNotEmpty) map[trimmed.substring(0, eq).trim()] = value;
      }
    }
    for (final key in _keys) {
      final value = Platform.environment[key];
      if (value != null && value.isNotEmpty) map[key] = value;
    }
    return map;
  }
}

