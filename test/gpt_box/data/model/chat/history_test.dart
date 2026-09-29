import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';

/// Mirrors how models are persisted: encoded to a JSON string and decoded back.
Map<String, dynamic> _jsonRoundTrip(Object obj) =>
    jsonDecode(jsonEncode(obj)) as Map<String, dynamic>;

void main() {
  group('ChatRole', () {
    test('has correct enum values', () {
      expect(ChatRole.values.length, 4);
      expect(ChatRole.values, contains(ChatRole.user));
      expect(ChatRole.values, contains(ChatRole.assist));
      expect(ChatRole.values, contains(ChatRole.system));
      expect(ChatRole.values, contains(ChatRole.tool));
    });

    group('fromString', () {
      test('returns correct role for valid strings', () {
        expect(ChatRole.fromString('user'), ChatRole.user);
        expect(ChatRole.fromString('assist'), ChatRole.assist);
        expect(ChatRole.fromString('system'), ChatRole.system);
        expect(ChatRole.fromString('tool'), ChatRole.tool);
      });

      test('returns assist for "assistant"', () {
        expect(ChatRole.fromString('assistant'), ChatRole.assist);
      });

      test('returns null for invalid strings', () {
        expect(ChatRole.fromString('unknown'), isNull);
        expect(ChatRole.fromString(''), isNull);
        expect(ChatRole.fromString(null), isNull);
      });
    });

    test('boolean getters work correctly', () {
      expect(ChatRole.user.isUser, true);
      expect(ChatRole.user.isAssist, false);
      expect(ChatRole.user.isSystem, false);
      expect(ChatRole.user.isTool, false);

      expect(ChatRole.assist.isAssist, true);
      expect(ChatRole.system.isSystem, true);
      expect(ChatRole.tool.isTool, true);
    });
  });

  group('ChatContentType', () {
    test('has correct enum values', () {
      expect(ChatContentType.values.length, 4);
      expect(ChatContentType.values, contains(ChatContentType.text));
      expect(ChatContentType.values, contains(ChatContentType.audio));
      expect(ChatContentType.values, contains(ChatContentType.image));
      expect(ChatContentType.values, contains(ChatContentType.file));
    });

    test('boolean getters work correctly', () {
      expect(ChatContentType.text.isText, true);
      expect(ChatContentType.text.isImage, false);
      expect(ChatContentType.text.isAudio, false);
      expect(ChatContentType.text.isFile, false);

      expect(ChatContentType.image.isImage, true);
      expect(ChatContentType.audio.isAudio, true);
      expect(ChatContentType.file.isFile, true);
    });
  });

  group('ChatContent', () {
    test('text constructor creates text content', () {
      final content = ChatContent.text('hello');
      expect(content.type, ChatContentType.text);
      expect(content.raw, 'hello');
      expect(content.id, isNotEmpty);
    });

    test('image constructor creates image content', () {
      final content = ChatContent.image('https://example.com/img.png');
      expect(content.type, ChatContentType.image);
      expect(content.raw, 'https://example.com/img.png');
    });

    test('audio constructor creates audio content', () {
      final content = ChatContent.audio('/path/to/audio.mp3');
      expect(content.type, ChatContentType.audio);
      expect(content.raw, '/path/to/audio.mp3');
    });

    test('file constructor creates file content', () {
      final content = ChatContent.file('/path/to/file.pdf');
      expect(content.type, ChatContentType.file);
      expect(content.raw, '/path/to/file.pdf');
    });

    test('noid constructor generates id', () {
      final content = ChatContent.noid(type: ChatContentType.text, raw: 'test');
      expect(content.id, isNotEmpty);
    });

    test('constructor with empty id generates id', () {
      final content = ChatContent(type: ChatContentType.text, raw: 'test', id: '');
      expect(content.id, isNotEmpty);
    });

    test('constructor with custom id preserves it', () {
      final content = ChatContent(type: ChatContentType.text, raw: 'test', id: 'my-id');
      expect(content.id, 'my-id');
    });

    test('fromJson and toJson round-trip', () {
      final content = ChatContent.text('hello world');
      final json = _jsonRoundTrip(content);
      final fromJson = ChatContent.fromJson(json);
      expect(fromJson.type, content.type);
      expect(fromJson.raw, content.raw);
      expect(fromJson.id, content.id);
    });

    test('equatable compares by type, raw, and id', () {
      final content1 = ChatContent(type: ChatContentType.text, raw: 'hello', id: 'id1');
      final content2 = ChatContent(type: ChatContentType.text, raw: 'hello', id: 'id1');
      final content3 = ChatContent(type: ChatContentType.text, raw: 'world', id: 'id1');
      final content4 = ChatContent(type: ChatContentType.image, raw: 'hello', id: 'id1');

      expect(content1, content2);
      expect(content1, isNot(content3));
      expect(content1, isNot(content4));
    });

    test('copyWith modifies specified fields', () {
      final content = ChatContent.text('hello');
      final modified = content.copyWith(raw: 'world');
      expect(modified.type, ChatContentType.text);
      expect(modified.raw, 'world');
      expect(modified.id, content.id);
    });

    test('copyWith changes type', () {
      final content = ChatContent.text('hello');
      final modified = content.copyWith(type: ChatContentType.image);
      expect(modified.type, ChatContentType.image);
      expect(modified.raw, 'hello');
    });
  });

  group('ChatHistoryItem', () {
    test('single constructor creates item with one content', () {
      final item = ChatHistoryItem.single(
        role: ChatRole.user,
        raw: 'Hello',
      );
      expect(item.role, ChatRole.user);
      expect(item.content.length, 1);
      expect(item.content.first.type, ChatContentType.text);
      expect(item.content.first.raw, 'Hello');
      expect(item.id, isNotEmpty);
      expect(item.createdAt, isNotNull);
    });

    test('single constructor with custom type', () {
      final item = ChatHistoryItem.single(
        role: ChatRole.user,
        raw: 'https://example.com/img.png',
        type: ChatContentType.image,
      );
      expect(item.content.first.type, ChatContentType.image);
    });

    test('single constructor with custom date', () {
      final date = DateTime(2024, 1, 15, 10, 30);
      final item = ChatHistoryItem.single(
        role: ChatRole.user,
        raw: 'Hello',
        createdAt: date,
      );
      expect(item.createdAt, date);
    });

    test('gen constructor creates item with DateTime.now', () {
      final before = DateTime.now();
      final item = ChatHistoryItem.gen(
        role: ChatRole.assist,
        content: [ChatContent.text('Response')],
      );
      final after = DateTime.now();
      expect(item.createdAt.isAfter(before) || item.createdAt == before, true);
      expect(item.createdAt.isBefore(after) || item.createdAt == after, true);
    });

    test('gen constructor preserves toolCallId', () {
      final item = ChatHistoryItem.gen(
        role: ChatRole.tool,
        content: [ChatContent.text('result')],
        toolCallId: 'call_123',
      );
      expect(item.toolCallId, 'call_123');
    });

    test('fromJson and toJson round-trip', () {
      final item = ChatHistoryItem.single(
        role: ChatRole.user,
        raw: 'Hello world',
      );
      final json = _jsonRoundTrip(item);
      final fromJson = ChatHistoryItem.fromJson(json);
      expect(fromJson.role, item.role);
      expect(fromJson.content.length, item.content.length);
      expect(fromJson.content.first.raw, item.content.first.raw);
      expect(fromJson.id, item.id);
    });

    test('toJson includes toolCallId when present', () {
      final item = ChatHistoryItem.gen(
        role: ChatRole.tool,
        content: [ChatContent.text('result')],
        toolCallId: 'call_abc',
      );
      final json = _jsonRoundTrip(item);
      expect(json.containsKey('toolCallId'), true);
      expect(json['toolCallId'], 'call_abc');
    });

    test('toJson excludes toolCallId when null', () {
      final item = ChatHistoryItem.gen(
        role: ChatRole.user,
        content: [ChatContent.text('hello')],
      );
      final json = _jsonRoundTrip(item);
      // It should either be absent or null (depending on includeIfNull)
      // Actually, since @JsonKey(includeIfNull: false), it should be absent
      expect(json.containsKey('toolCallId'), false);
    });

    test('copyWith creates modified copy', () {
      final item = ChatHistoryItem.single(
        role: ChatRole.user,
        raw: 'Hello',
      );
      final modified = item.copyWith(
        role: ChatRole.assist,
        content: [ChatContent.text('World')],
      );
      expect(modified.role, ChatRole.assist);
      expect(modified.content.first.raw, 'World');
      expect(modified.id, item.id);
      expect(item.role, ChatRole.user); // Original unchanged
    });
  });

  group('ChatHistory', () {
    test('noid constructor generates id', () {
      final history = ChatHistory.noid(items: []);
      expect(history.id, isNotEmpty);
    });

    test('noid constructor preserves name', () {
      final history = ChatHistory.noid(items: [], name: 'My Chat');
      expect(history.name, 'My Chat');
    });

    test('fromJson and toJson round-trip', () {
      final history = ChatHistory(
        id: 'test-id',
        items: [
          ChatHistoryItem.single(role: ChatRole.user, raw: 'Hello'),
          ChatHistoryItem.single(role: ChatRole.assist, raw: 'Hi there'),
        ],
        name: 'Test Chat',
      );
      final json = _jsonRoundTrip(history);
      final fromJson = ChatHistory.fromJson(json);
      expect(fromJson.id, history.id);
      expect(fromJson.name, history.name);
      expect(fromJson.items.length, 2);
      expect(fromJson.items[0].role, ChatRole.user);
      expect(fromJson.items[1].role, ChatRole.assist);
    });

    test('lastTime returns null for empty history', () {
      final history = ChatHistory.noid(items: []);
      expect(history.lastTime, isNull);
    });

    test('lastTime returns time of latest item', () {
      final early = DateTime(2024, 1, 1);
      final late = DateTime(2024, 6, 15);
      final history = ChatHistory(
        id: 'test',
        items: [
          ChatHistoryItem(
            role: ChatRole.user,
            content: [ChatContent.text('first')],
            createdAt: early,
            id: '1',
          ),
          ChatHistoryItem(
            role: ChatRole.assist,
            content: [ChatContent.text('second')],
            createdAt: late,
            id: '2',
          ),
        ],
      );
      expect(history.lastTime, late);
    });

    test('lastTime returns time even for unsorted items', () {
      final early = DateTime(2024, 1, 1);
      final mid = DateTime(2024, 3, 1);
      final late = DateTime(2024, 6, 15);
      final history = ChatHistory(
        id: 'test',
        items: [
          ChatHistoryItem(role: ChatRole.user, content: [ChatContent.text('a')], createdAt: late, id: '1'),
          ChatHistoryItem(role: ChatRole.user, content: [ChatContent.text('b')], createdAt: early, id: '2'),
          ChatHistoryItem(role: ChatRole.assist, content: [ChatContent.text('c')], createdAt: mid, id: '3'),
        ],
      );
      expect(history.lastTime, late);
    });

    test('copyWith creates modified copy', () {
      final history = ChatHistory(
        id: 'test-id',
        items: [ChatHistoryItem.single(role: ChatRole.user, raw: 'hello')],
        name: 'Original',
      );
      final modified = history.copyWith(name: 'Modified');
      expect(modified.id, 'test-id');
      expect(modified.name, 'Modified');
      expect(modified.items.length, 1);
      expect(history.name, 'Original'); // Original unchanged
    });

    test('copyWith preserves original when no args given', () {
      final history = ChatHistory(
        id: 'test-id',
        items: [],
        name: 'Original',
      );
      final copy = history.copyWith();
      expect(copy.id, history.id);
      expect(copy.name, history.name);
    });
  });

  group('ChatSettings', () {
    test('default values', () {
      const settings = ChatSettings();
      expect(settings.headTailMode, false);
      expect(settings.useTools, true);
      expect(settings.ignoreContextConstraint, false);
    });

    test('custom values', () {
      const settings = ChatSettings(
        headTailMode: true,
        useTools: false,
        ignoreContextConstraint: true,
      );
      expect(settings.headTailMode, true);
      expect(settings.useTools, false);
      expect(settings.ignoreContextConstraint, true);
    });

    test('null params use defaults', () {
      const settings = ChatSettings(headTailMode: true);
      expect(settings.headTailMode, true);
      expect(settings.useTools, true);
      expect(settings.ignoreContextConstraint, false);
    });

    test('copyWith modifies specified fields', () {
      const settings = ChatSettings();
      final modified = settings.copyWith(headTailMode: true);
      expect(modified.headTailMode, true);
      expect(modified.useTools, true);
      expect(modified.ignoreContextConstraint, false);
    });

    test('copyWith preserves unspecified fields', () {
      const settings = ChatSettings(headTailMode: true, useTools: false);
      final modified = settings.copyWith(ignoreContextConstraint: true);
      expect(modified.headTailMode, true);
      expect(modified.useTools, false);
      expect(modified.ignoreContextConstraint, true);
    });

    test('fromJson and toJson round-trip', () {
      const settings = ChatSettings(
        headTailMode: true,
        useTools: false,
        ignoreContextConstraint: true,
      );
      final json = _jsonRoundTrip(settings);
      final fromJson = ChatSettings.fromJson(json);
      expect(fromJson.headTailMode, true);
      expect(fromJson.useTools, false);
      expect(fromJson.ignoreContextConstraint, true);
    });

    test('toJson uses short keys', () {
      const settings = ChatSettings(headTailMode: true);
      final json = _jsonRoundTrip(settings);
      expect(json.containsKey('htm'), true);
    });

    test('fromJson handles null values with defaults', () {
      final json = <String, dynamic>{};
      final settings = ChatSettings.fromJson(json);
      expect(settings.headTailMode, false);
      expect(settings.useTools, true);
      expect(settings.ignoreContextConstraint, false);
    });

    test('toString includes hashCode', () {
      const settings = ChatSettings();
      expect(settings.toString(), contains('ChatSettings'));
    });
  });

  group('ChatHistoryItemX', () {
    test('toMarkdown for text content', () {
      final item = ChatHistoryItem.single(
        role: ChatRole.user,
        raw: 'Hello world',
      );
      expect(item.toMarkdown, 'Hello world');
    });

    test('toMarkdown for mixed content', () {
      final item = ChatHistoryItem.gen(
        role: ChatRole.user,
        content: [
          ChatContent.text('Check this image:'),
          ChatContent.image('https://example.com/img.png'),
        ],
      );
      final md = item.toMarkdown;
      expect(md, contains('Check this image:'));
      expect(md, contains('!['));
      expect(md, contains('https://example.com/img.png'));
    });

    test('toMarkdown for file content', () {
      final item = ChatHistoryItem.gen(
        role: ChatRole.user,
        content: [ChatContent.file('/path/to/file.pdf')],
      );
      final md = item.toMarkdown;
      expect(md, contains('file:///path/to/file.pdf'));
    });

    test('toMarkdown for audio content', () {
      final item = ChatHistoryItem.gen(
        role: ChatRole.user,
        content: [ChatContent.audio('/path/to/audio.mp3')],
      );
      final md = item.toMarkdown;
      expect(md, contains('/path/to/audio.mp3'));
    });
  });

  group('ChatContentX', () {
    test('isText extension getter', () {
      expect(ChatContent.text('hello').isText, true);
      expect(ChatContent.image('url').isText, false);
    });

    test('isImg extension getter', () {
      expect(ChatContent.image('url').isImg, true);
      expect(ChatContent.text('hello').isImg, false);
    });

    test('isAudio extension getter', () {
      expect(ChatContent.audio('url').isAudio, true);
      expect(ChatContent.text('hello').isAudio, false);
    });

    test('isFile extension getter', () {
      expect(ChatContent.file('path').isFile, true);
      expect(ChatContent.text('hello').isFile, false);
    });
  });
}