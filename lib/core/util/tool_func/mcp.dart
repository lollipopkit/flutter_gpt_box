part of 'tool.dart';

class McpTools {
  static final _client = Client(
    Implementation(name: BuildData.name, version: '1.0.${BuildData.build}'),
  );
  static Set<ChatCompletionTool> tools = {};

  static Future<Transport?> initTransport(String url) async {
    final uri = Uri.parse(url);
    final transport = StreamableHttpClientTransport(uri);
    transport.onerror = Loggers.app.warning;
    try {
      await _client.connect(transport);
      return transport;
    } catch (e, s) {
      Loggers.app.warning('Connect to MCP failed', e, s);
    }
    return null;
  }

  static Future<void> addTools() async {
    try {
      final list = await _client.listTools();
      tools = list.tools
          .map(
            (e) => ChatCompletionTool(
              type: ChatCompletionToolType.function,
              function: FunctionObject(
                name: e.name,
                description: e.description,
                parameters: e.inputSchema.properties,
              ),
            ),
          )
          .toSet();
    } catch (e, s) {
      Loggers.app.warning('Load MCP tools failed', e, s);
    }
  }

  static Future<_Ret?> handle(_CallResp call, OnToolLog onToolLog) async {
    final args = await _parseMap(call.function.arguments);
    try {
      final res = await _client.callTool(
        CallToolRequestParams(name: call.function.name, arguments: args),
      );
      onToolLog(res.toString());
      return [ChatContent.text(res.toString())];
    } catch (e, s) {
      Loggers.app.warning('MCP tool error', e, s);
      return null;
    }
  }
}
