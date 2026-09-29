import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/data/model/chat/openai.dart';

void main() {
  group('OpenAIConvertor', () {
    test('toChatHistory converts simple OpenAI session', () {
      final session = {
        'title': 'Test Chat',
        'mapping': {
          'node1': {
            'parent': null,
            'children': ['node2'],
          },
          'node2': {
            'parent': 'node1',
            'children': [],
            'message': {
              'author': {'role': 'user'},
              'content': {
                'parts': ['Hello, how are you?'],
              },
              'create_time': 1700000000.0,
            },
          },
        },
      };

      final result = OpenAIConvertor.toChatHistory(session);
      expect(result.name, 'Test Chat');
      expect(result.items.length, 1);
      expect(result.items[0].role, ChatRole.user);
      expect(result.items[0].content.first.raw, 'Hello, how are you?');
    });

    test('toChatHistory converts multi-turn conversation', () {
      final session = {
        'title': 'Multi-turn',
        'mapping': {
          'root': {
            'parent': null,
            'children': ['user1'],
          },
          'user1': {
            'parent': 'root',
            'children': ['assistant1'],
            'message': {
              'author': {'role': 'user'},
              'content': {
                'parts': ['What is 2+2?'],
              },
              'create_time': 1700000001.0,
            },
          },
          'assistant1': {
            'parent': 'user1',
            'children': [],
            'message': {
              'author': {'role': 'assistant'},
              'content': {
                'parts': ['2+2 equals 4.'],
              },
              'create_time': 1700000002.0,
            },
          },
        },
      };

      final result = OpenAIConvertor.toChatHistory(session);
      expect(result.items.length, 2);
      expect(result.items[0].role, ChatRole.user);
      expect(result.items[1].role, ChatRole.assist);
      expect(result.items[0].content.first.raw, 'What is 2+2?');
      expect(result.items[1].content.first.raw, '2+2 equals 4.');
    });

    test('toChatHistory handles missing parent gracefully', () {
      final session = {
        'title': 'Orphan Chat',
        'mapping': {
          'orphan_node': {
            'parent': null,
            'children': ['unknown'],
          },
        },
      };

      // Should not crash, but may produce empty or partial results
      final result = OpenAIConvertor.toChatHistory(session);
      expect(result, isNotNull);
      expect(result.name, 'Orphan Chat');
    });

    test('toChatHistory skips empty content', () {
      final session = {
        'title': 'Empty Content',
        'mapping': {
          'root': {
            'parent': null,
            'children': ['msg1'],
          },
          'msg1': {
            'parent': 'root',
            'children': [],
            'message': {
              'author': {'role': 'user'},
              'content': {
                'parts': [''],  // Empty string
              },
              'create_time': 1700000000.0,
            },
          },
        },
      };

      final result = OpenAIConvertor.toChatHistory(session);
      // Empty content should be skipped
      expect(result.items.length, 0);
    });

    test('toChatHistory handles null content', () {
      final session = {
        'title': 'Null Content',
        'mapping': {
          'root': {
            'parent': null,
            'children': ['msg1'],
          },
          'msg1': {
            'parent': 'root',
            'children': [],
            'message': {
              'author': {'role': 'user'},
              'content': null,
              'create_time': 1700000000.0,
            },
          },
        },
      };

      final result = OpenAIConvertor.toChatHistory(session);
      expect(result.items.length, 0);
    });

    test('toChatHistory joins multi-part content', () {
      final session = {
        'title': 'Multi-part',
        'mapping': {
          'root': {
            'parent': null,
            'children': ['msg1'],
          },
          'msg1': {
            'parent': 'root',
            'children': [],
            'message': {
              'author': {'role': 'user'},
              'content': {
                'parts': ['Hello ', 'world', '!'],
              },
              'create_time': 1700000000.0,
            },
          },
        },
      };

      final result = OpenAIConvertor.toChatHistory(session);
      expect(result.items.length, 1);
      expect(result.items[0].content.first.raw, 'Hello \nworld\n!');
    });

    test('toChatHistory converts assistant role correctly', () {
      final session = {
        'title': 'Assistant Test',
        'mapping': {
          'root': {
            'parent': null,
            'children': ['msg1'],
          },
          'msg1': {
            'parent': 'root',
            'children': [],
            'message': {
              'author': {'role': 'assistant'},
              'content': {
                'parts': ['I am an assistant.'],
              },
              'create_time': 1700000000.0,
            },
          },
        },
      };

      final result = OpenAIConvertor.toChatHistory(session);
      // OpenAI uses 'assistant', our model uses 'assist'
      expect(result.items[0].role, ChatRole.assist);
    });

    test('toChatHistory handles deep conversation chain', () {
      final session = {
        'title': 'Deep Chain',
        'mapping': {
          'root': {
            'parent': null,
            'children': ['n1'],
          },
          'n1': {
            'parent': 'root',
            'children': ['n2'],
            'message': {
              'author': {'role': 'user'},
              'content': {'parts': ['Q1']},
              'create_time': 1700000001.0,
            },
          },
          'n2': {
            'parent': 'n1',
            'children': ['n3'],
            'message': {
              'author': {'role': 'assistant'},
              'content': {'parts': ['A1']},
              'create_time': 1700000002.0,
            },
          },
          'n3': {
            'parent': 'n2',
            'children': [],
            'message': {
              'author': {'role': 'user'},
              'content': {'parts': ['Q2']},
              'create_time': 1700000003.0,
            },
          },
        },
      };

      final result = OpenAIConvertor.toChatHistory(session);
      expect(result.items.length, 3);
      expect(result.items[0].role, ChatRole.user);
      expect(result.items[1].role, ChatRole.assist);
      expect(result.items[2].role, ChatRole.user);
    });
  });
}