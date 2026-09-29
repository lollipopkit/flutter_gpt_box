import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';
import 'package:openai_dart/openai_dart.dart';

ChatCompletionMessageToolCall _call(String name, String args) {
  return ChatCompletionMessageToolCall(
    id: 'test-id',
    type: ChatCompletionMessageToolCallType.function,
    function: ChatCompletionMessageFunctionCall(name: name, arguments: args),
  );
}

void main() {
  group('OpenAIFuncCalls', () {
    test('internalTools contains memory, history and httpReq', () {
      final names = OpenAIFuncCalls.internalTools.map((e) => e.name);
      expect(names, unorderedEquals(['memory', 'history', 'httpReq']));
    });
  });

  group('TfMemory', () {
    test('name and schema', () {
      expect(TfMemory.instance.name, 'memory');
      final schema = TfMemory.instance.parametersSchema;
      expect(schema['type'], 'object');
      final props = schema['properties'] as Map<String, dynamic>;
      expect(props.containsKey('memory'), true);
    });

    test('description and defaultEnabled', () {
      expect(TfMemory.instance.description, contains('memorise'));
      expect(TfMemory.instance.defaultEnabled, true);
    });

    test('help includes the memory content', () {
      final help = TfMemory.instance.help(
        _call('memory', '{"memory": "test-mem"}'),
        {'memory': 'test-mem'},
      );
      expect(help, contains('test-mem'));
    });
  });

  group('TfHistory', () {
    test('name and schema', () {
      expect(TfHistory.instance.name, 'history');
      final schema = TfHistory.instance.parametersSchema;
      expect(schema['type'], 'object');
      final props = schema['properties'] as Map<String, dynamic>;
      expect(props.keys, containsAll(['keywords', 'onlyTitles', 'count']));
    });

    test('description and defaultEnabled', () {
      expect(TfHistory.instance.description, contains('history'));
      expect(TfHistory.instance.defaultEnabled, false);
    });
  });

  group('TfHttpReq', () {
    test('name and schema', () {
      expect(TfHttpReq.instance.name, 'httpReq');
      final schema = TfHttpReq.instance.parametersSchema;
      expect(schema['type'], 'object');
      final props = schema['properties'] as Map<String, dynamic>;
      expect(props.keys, containsAll(['url', 'method', 'headers', 'body']));
      expect(schema['required'], contains('url'));
    });

    test('description and defaultEnabled', () {
      expect(TfHttpReq.instance.description, contains('HTTP'));
      expect(TfHttpReq.instance.defaultEnabled, true);
    });

    test('help includes the url', () {
      final help = TfHttpReq.instance.help(
        _call('httpReq', '{"url": "https://example.com"}'),
        {'url': 'https://example.com'},
      );
      expect(help, contains('https://example.com'));
    });
  });

  group('ToolFunc.into', () {
    test('converts to ChatCompletionTool', () {
      for (final func in OpenAIFuncCalls.internalTools) {
        final tool = func.into;
        expect(tool.type, ChatCompletionToolType.function);
        expect(tool.function.name, func.name);
        expect(tool.function.description, func.description);
        expect(tool.function.parameters, func.parametersSchema);
      }
    });
  });
}
