import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/gpt_next.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';

void main() {
  group('GPTNextConvertor', () {
    group('parseDate', () {
      test('parses valid date string', () {
        final result = GPTNextConvertor.parseDate('2023/11/6 15:57:22');
        expect(result, isNotNull);
        expect(result!.year, 2023);
        expect(result.month, 11);
        expect(result.day, 6);
        expect(result.hour, 15);
        expect(result.minute, 57);
        expect(result.second, 22);
      });

      test('parses date with different values', () {
        final result = GPTNextConvertor.parseDate('2024/1/15 0:0:0');
        expect(result, isNotNull);
        expect(result!.year, 2024);
        expect(result.month, 1);
        expect(result.day, 15);
        expect(result.hour, 0);
        expect(result.minute, 0);
        expect(result.second, 0);
      });

      test('returns null for invalid date format', () {
        expect(GPTNextConvertor.parseDate('invalid'), isNull);
        expect(GPTNextConvertor.parseDate(''), isNull);
        expect(GPTNextConvertor.parseDate('2023-11-06'), isNull);
      });

      test('returns null for incomplete date', () {
        expect(GPTNextConvertor.parseDate('2023/11'), isNull);
        expect(GPTNextConvertor.parseDate('15:57:22'), isNull);
      });
    });

    test('toChatHistory converts valid session', () {
      final session = <String, dynamic>{
        'messages': [
          {
            'role': 'user',
            'content': 'Hello!',
            'date': '2024/1/15 10:30:45',
          },
          {
            'role': 'assistant',
            'content': 'Hi there!',
            'date': '2024/1/15 10:31:00',
          },
        ],
        'topic': 'Test Chat',
      };

      final result = GPTNextConvertor.toChatHistory(session);
      expect(result.name, 'Test Chat');
      expect(result.items.length, 2);

      expect(result.items[0].role, ChatRole.user);
      expect(result.items[0].content.first.raw, 'Hello!');
      expect(result.items[0].createdAt.year, 2024);

      expect(result.items[1].role, ChatRole.assist);
      expect(result.items[1].content.first.raw, 'Hi there!');
    });

    test('toChatHistory skips messages with invalid role', () {
      final session = <String, dynamic>{
        'messages': [
          {
            'role': 'user',
            'content': 'Hello!',
            'date': '2024/1/15 10:30:45',
          },
          {
            'role': 'invalid_role',
            'content': 'Unknown',
            'date': '2024/1/15 10:31:00',
          },
          {
            'role': 'system',
            'content': 'System msg',
            'date': '2024/1/15 10:32:00',
          },
        ],
        'topic': 'Mixed Chat',
      };

      final result = GPTNextConvertor.toChatHistory(session);
      // Invalid role is skipped, valid roles kept
      expect(result.items.length, 2);
      expect(result.items[0].role, ChatRole.user);
      expect(result.items[1].role, ChatRole.system);
    });

    test('toChatHistory skips messages with invalid date', () {
      final session = <String, dynamic>{
        'messages': [
          {
            'role': 'user',
            'content': 'Valid',
            'date': '2024/1/15 10:30:45',
          },
          {
            'role': 'assistant',
            'content': 'Invalid date',
            'date': 'invalid-date',
          },
        ],
        'topic': 'Date Test',
      };

      final result = GPTNextConvertor.toChatHistory(session);
      expect(result.items.length, 1);
      expect(result.items[0].content.first.raw, 'Valid');
    });

    test('toChatHistory handles empty messages', () {
      final session = <String, dynamic>{
        'messages': [],
        'topic': 'Empty Chat',
      };

      final result = GPTNextConvertor.toChatHistory(session);
      expect(result.name, 'Empty Chat');
      expect(result.items, isEmpty);
    });

    test('toChatHistory handles system role', () {
      final session = <String, dynamic>{
        'messages': [
          {
            'role': 'system',
            'content': 'You are a helpful assistant.',
            'date': '2024/1/15 10:30:45',
          },
        ],
        'topic': 'System Chat',
      };

      final result = GPTNextConvertor.toChatHistory(session);
      expect(result.items.length, 1);
      expect(result.items[0].role, ChatRole.system);
    });

    group('parseConfig', () {
      test('parses model config', () {
        final map = <String, dynamic>{
          'app-config': {
            'modelConfig': {
              'model': 'gpt-4',
              'historyMessageCount': 10,
            },
          },
        };
        final result = GPTNextConvertor.parseConfig(map, const ChatConfig());
        expect(result.model, 'gpt-4');
        expect(result.historyLen, 10);
      });

      test('parses access-control config', () {
        final map = <String, dynamic>{
          'access-control': {
            'openaiUrl': 'https://api.custom.com/v1',
            'openaiApiKey': 'sk-custom-key',
          },
        };
        final result = GPTNextConvertor.parseConfig(map, const ChatConfig());
        expect(result.url, 'https://api.custom.com/v1');
        expect(result.key, 'sk-custom-key');
      });

      test('preserves original config for missing fields', () {
        const original = ChatConfig(
          model: 'gpt-3.5-turbo',
          historyLen: 5,
        );
        final result = GPTNextConvertor.parseConfig({}, original);
        expect(result.model, 'gpt-3.5-turbo');
        expect(result.historyLen, 5);
      });

      test('handles both model and access-control', () {
        final map = <String, dynamic>{
          'app-config': {
            'modelConfig': {
              'model': 'gpt-4',
              'historyMessageCount': 20,
            },
          },
          'access-control': {
            'openaiUrl': 'https://api.example.com',
            'openaiApiKey': 'sk-test',
          },
        };
        final result = GPTNextConvertor.parseConfig(map, const ChatConfig());
        expect(result.model, 'gpt-4');
        expect(result.historyLen, 20);
        expect(result.url, 'https://api.example.com');
        expect(result.key, 'sk-test');
      });
    });
  });
}