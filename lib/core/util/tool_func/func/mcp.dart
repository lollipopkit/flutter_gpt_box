part of '../tool.dart';

class McpTools {
  static final _client = McpClient();
  static List<ChatCompletionTool> _tools = [];
  static bool _inited = false;

  static Future<void> init() async {
    if (_inited) return;
    try {
      final list = await _client.listTools();
      _tools = list
          .map((e) => ChatCompletionTool(
                type: ChatCompletionToolType.function,
                function: FunctionObject(
                  name: e.name,
                  description: e.description,
                  parameters: e.parameters,
                ),
              ))
          .toList();
    } catch (e, s) {
      Loggers.app.warning('Load MCP tools failed', e, s);
    }
    _inited = true;
  }

  static Future<List<ChatCompletionTool>> getTools() async {
    await init();
    return _tools;
  }

  static Future<_Ret?> handle(_CallResp call, OnToolLog onToolLog) async {
    await init();
    final args = await _parseMap(call.function.arguments);
    try {
      final res = await _client.invokeTool(call.function.name, args);
      onToolLog(res.toString());
      return [ChatContent.text(res.toString())];
    } catch (e, s) {
      Loggers.app.warning('MCP tool error', e, s);
      return null;
    }
  }
}

