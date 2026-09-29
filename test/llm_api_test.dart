/// Live API tests. They need credentials, either as environment variables or
/// in `.env` / `test/.env` (see `.env.example`); environment variables win.
/// Without them the whole group is skipped.
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:openai_dart/openai_dart.dart';

void main() {
  final env = _Env.load();
  final baseUrl = env['LLM_BASE_URL'];
  final apiKey = env['LLM_API_KEY'];
  final model = env['LLM_MODEL'] ?? 'gpt-3.5-turbo';
  final missing = baseUrl == null || apiKey == null || apiKey == 'sk-xxx';

  group(
    'LLM API',
    skip: missing ? 'LLM_BASE_URL / LLM_API_KEY not configured' : false,
    () {
      late OpenAIClient client;

      setUpAll(() {
        client = OpenAIClient(apiKey: apiKey, baseUrl: baseUrl);
      });

      CreateChatCompletionRequest request(
        List<ChatCompletionMessage> messages, {
        int maxTokens = 256,
      }) {
        return CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId(model),
          messages: messages,
          maxTokens: maxTokens,
        );
      }

      ChatCompletionMessage user(String text) => ChatCompletionMessage.user(
        content: ChatCompletionUserMessageContent.string(text),
      );

      test('simple chat completion', () async {
        final response = await client.createChatCompletion(
          request: request([user('Hello!')]),
        );
        expect(response.choices, isNotEmpty);
        expect(_assistantText(response.choices.first.message), isNotEmpty);
      });

      test('system + user message', () async {
        final response = await client.createChatCompletion(
          request: request([
            const ChatCompletionMessage.system(
              content: 'You are a helpful assistant. Keep responses short.',
            ),
            user('Say "test ok".'),
          ], maxTokens: 512),
        );
        expect(response.choices, isNotEmpty);
        expect(_assistantText(response.choices.first.message), isNotEmpty);
      });

      test('stream chat completion', () async {
        final chunks = await client
            .createChatCompletionStream(
              request: request([user('Count from 1 to 3, one per line.')]),
            )
            .toList();
        expect(chunks, isNotEmpty);
      });

      test('request with custom headers', () async {
        final customClient = OpenAIClient(
          apiKey: apiKey,
          baseUrl: baseUrl,
          headers: {'X-Custom-Header': 'test'},
        );
        final response = await customClient.createChatCompletion(
          request: request([user('Hi')], maxTokens: 10),
        );
        expect(response.choices, isNotEmpty);
      });

      test('error handling - invalid key', () async {
        final badClient = OpenAIClient(apiKey: 'invalid-key', baseUrl: baseUrl);
        await expectLater(
          badClient.createChatCompletion(
            request: request([user('Hi')], maxTokens: 10),
          ),
          throwsA(isA<OpenAIClientException>()),
        );
      });

      test('usage tokens in response', () async {
        final response = await client.createChatCompletion(
          request: request([user('Hello')], maxTokens: 20),
        );
        expect(response.usage, isNotNull);
        expect(response.usage!.promptTokens, greaterThan(0));
        expect(response.usage!.completionTokens, greaterThan(0));
      });
    },
  );
}

/// Reads `test/.env` or `.env` (first found), then overlays the process
/// environment. Returns an empty map when neither provides anything.
abstract final class _Env {
  static const _keys = ['LLM_BASE_URL', 'LLM_API_KEY', 'LLM_MODEL'];

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

String _assistantText(ChatCompletionMessage msg) {
  if (msg is ChatCompletionAssistantMessage) return msg.content ?? '';
  return '';
}
