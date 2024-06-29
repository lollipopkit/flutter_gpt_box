part of 'tool.dart';

typedef _Ret = List<ChatContent>;
typedef _CallResp = OpenAIResponseToolCall;
typedef _Map = Map<String, dynamic>;
typedef ToolConfirm = Future<bool> Function(ToolFunc func, String help);
typedef OnToolLog = void Function(String log);

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

/// Only return the content insides body tag as a <title: url> map.
String _filterHtml(String html) {
  // Remove the first line of <!DOCTYPE html>
  if (html.startsWith('<!')) {
    html = html.substring(html.indexOf('>') + 1);
  }
  final doc = html_parser.parse(html);
  final aInBody = doc.querySelectorAll('body a');
  final map = <String, String>{};
  // Find all <a> tag with href.
  for (final a in aInBody) {
    final href = a.attributes['href'];
    if (href == null) continue;
    // If there is no complete url in href, ignore it.
    // Usually, the uncomplete url is a relative path for the search engine.
    if (!httpReg.hasMatch(href)) continue;
    final title = a.text;
    map[title] = href;
  }
  final sb = StringBuffer();
  for (final entry in map.entries) {
    sb.writeln('${entry.key}\n${entry.value}');
  }
  return sb.toString();
}

final httpReg = RegExp(r'https?://');
