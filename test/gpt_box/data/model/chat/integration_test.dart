import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:openai_dart/openai_dart.dart';

/// Mirrors how models are persisted: encoded to a JSON string and decoded back.
Map<String, dynamic> _jsonRoundTrip(Object obj) =>
    jsonDecode(jsonEncode(obj)) as Map<String, dynamic>;

void main() {
  group('ChatHistory serialization integration', () {
    test('full ChatHistory round-trip serialization', () {
      final history = ChatHistory(
        id: 'test-chat-id',
        items: [
          ChatHistoryItem(
            id: 'msg-1',
            role: ChatRole.system,
            content: [ChatContent.text('You are a helpful assistant.')],
            createdAt: DateTime(2024, 1, 15, 10, 0),
          ),
          ChatHistoryItem(
            id: 'msg-2',
            role: ChatRole.user,
            content: [ChatContent.text('What is Dart?')],
            createdAt: DateTime(2024, 1, 15, 10, 1),
          ),
          ChatHistoryItem(
            id: 'msg-3',
            role: ChatRole.assist,
            content: [ChatContent.text('Dart is a programming language.')],
            createdAt: DateTime(2024, 1, 15, 10, 2),
          ),
        ],
        name: 'Dart Chat',
        settings: const ChatSettings(useTools: false),
      );

      // Serialize
      final json = _jsonRoundTrip(history);

      // Verify structure
      expect(json['id'], 'test-chat-id');
      expect(json['name'], 'Dart Chat');
      expect(json['items'], isA<List>());
      expect((json['items'] as List).length, 3);

      // Deserialize
      final restored = ChatHistory.fromJson(json);
      expect(restored.id, history.id);
      expect(restored.name, history.name);
      expect(restored.items.length, 3);
      expect(restored.items[0].role, ChatRole.system);
      expect(restored.items[1].role, ChatRole.user);
      expect(restored.items[2].role, ChatRole.assist);
      expect(restored.items[0].content.first.raw, 'You are a helpful assistant.');
      expect(restored.items[1].content.first.raw, 'What is Dart?');
      expect(restored.items[2].content.first.raw, 'Dart is a programming language.');
      expect(restored.settings?.useTools, false);
    });

    test('ChatHistoryItem with tool calls', () {
      final toolCall = ChatCompletionMessageToolCall(
        id: 'call-abc123',
        type: ChatCompletionMessageToolCallType.function,
        function: ChatCompletionMessageFunctionCall(
          name: 'get_weather',
          arguments: '{"city": "NYC"}',
        ),
      );

      final item = ChatHistoryItem.gen(
        role: ChatRole.assist,
        content: [ChatContent.text('Let me check the weather.')],
        toolCalls: [toolCall],
      );

      final json = _jsonRoundTrip(item);
      final restored = ChatHistoryItem.fromJson(json);

      expect(restored.role, ChatRole.assist);
      expect(restored.toolCalls, isNotNull);
      expect(restored.toolCalls!.length, 1);
      expect(restored.toolCalls!.first.id, 'call-abc123');
      expect(restored.toolCalls!.first.function.name, 'get_weather');
    });

    test('ChatHistoryItem with tool response', () {
      final item = ChatHistoryItem.gen(
        role: ChatRole.tool,
        content: [ChatContent.text('Weather: 72°F, sunny')],
        toolCallId: 'call-abc123',
      );

      final json = _jsonRoundTrip(item);
      final restored = ChatHistoryItem.fromJson(json);

      expect(restored.role, ChatRole.tool);
      expect(restored.toolCallId, 'call-abc123');
      expect(restored.content.first.raw, 'Weather: 72°F, sunny');
    });

    test('ChatHistory with reasoning', () {
      final item = ChatHistoryItem.gen(
        role: ChatRole.assist,
        content: [ChatContent.text('The answer is 4.')],
        reasoning: '2 + 2 = 4',
      );

      final json = _jsonRoundTrip(item);
      expect(json.containsKey('reasoning'), true);
      expect(json['reasoning'], '2 + 2 = 4');

      final restored = ChatHistoryItem.fromJson(json);
      expect(restored.reasoning, '2 + 2 = 4');
    });

    test('ChatHistoryItem with mixed content types', () {
      final item = ChatHistoryItem.gen(
        role: ChatRole.user,
        content: [
          ChatContent.text('Check this image:'),
          ChatContent.image('https://example.com/photo.png'),
          ChatContent.file('/path/to/document.pdf'),
        ],
      );

      final json = _jsonRoundTrip(item);
      final restored = ChatHistoryItem.fromJson(json);

      expect(restored.content.length, 3);
      expect(restored.content[0].type, ChatContentType.text);
      expect(restored.content[1].type, ChatContentType.image);
      expect(restored.content[2].type, ChatContentType.file);
      expect(restored.content[1].raw, 'https://example.com/photo.png');
    });

    test('ChatSettings serialization round-trip', () {
      const settings = ChatSettings(
        headTailMode: true,
        useTools: false,
        ignoreContextConstraint: true,
      );

      final json = _jsonRoundTrip(settings);
      final restored = ChatSettings.fromJson(json);

      expect(restored.headTailMode, true);
      expect(restored.useTools, false);
      expect(restored.ignoreContextConstraint, true);
    });

    test('ChatSettings with short JSON keys', () {
      const settings = ChatSettings(headTailMode: true);
      final json = _jsonRoundTrip(settings);
      // Verify short keys are used for JSON serialization
      expect(json.containsKey('htm'), true);
      expect(json.containsKey('ut'), true);
      expect(json.containsKey('icc'), true);
    });

    test('ChatContent with all content types serialization', () {
      for (final type in ChatContentType.values) {
        final raw = switch (type) {
          ChatContentType.text => 'hello',
          ChatContentType.image => 'https://example.com/img.png',
          ChatContentType.audio => 'https://example.com/audio.mp3',
          ChatContentType.file => '/path/to/file.pdf',
        };
        final content = ChatContent(type: type, raw: raw, id: 'test-id');
        final json = _jsonRoundTrip(content);
        final restored = ChatContent.fromJson(json);
        expect(restored.type, type);
        expect(restored.raw, raw);
        expect(restored.id, 'test-id');
      }
    });

    test('empty ChatHistory', () {
      final history = ChatHistory(id: 'empty', items: []);
      final json = _jsonRoundTrip(history);
      final restored = ChatHistory.fromJson(json);
      expect(restored.id, 'empty');
      expect(restored.items, isEmpty);
      expect(restored.lastTime, isNull);
    });

    test('ChatHistory preserves all nullable fields as null when not set', () {
      final item = ChatHistoryItem.gen(
        role: ChatRole.user,
        content: [ChatContent.text('simple')],
      );
      final json = _jsonRoundTrip(item);
      // toolCallId, toolCalls, and reasoning should be absent when null
      expect(json.containsKey('toolCallId'), false);
      expect(json.containsKey('reasoning'), false);
    });
  });
}
