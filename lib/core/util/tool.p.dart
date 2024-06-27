part of 'tool.dart';

typedef _Ret = List<ChatContent>;
typedef _CallResp = OpenAIResponseToolCall;
typedef _Map = Map<String, dynamic>;

Future<Map<String, dynamic>> _parseMap(dynamic value) async {
  Future<_Map> tryDecodeJson(dynamic value) {
    return compute((_) {
      try {
        return json.decode(value);
      } catch (e) {
        return {};
      }
    }, null);
  }

  if (value is String) {
    final json = await tryDecodeJson(value);
    if (json.isNotEmpty) return json;
  }
  if (value is Map<String, dynamic>) return value;
  return {};
}
