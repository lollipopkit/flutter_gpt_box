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
Map<String, String> _filterHtmlUrls(String html) {
  // Remove the first line of <!DOCTYPE html>
  if (html.startsWith('<!')) {
    html = html.substring(html.indexOf('>') + 1);
  }
  final doc = html_parser.parse(html);
  final aInBody = doc.querySelectorAll('body a');
  final map = <String, String>{};
  // Find all <a> tag with href.
  for (final a in aInBody) {
    var href = a.attributes['href'];
    if (href == null) continue;
    // If there is no complete url in href, ignore it.
    // Usually, the uncomplete url is a relative path for the search engine.
    if (!httpReg.hasMatch(href)) continue;
    final title = a.text;
    // `/url?q=` is the query string for google search result.
    if (href.startsWith('/url?q=')) {
      final uri = Uri.parse(href);
      href = uri.queryParameters['q'] ?? href;
    }
    map[title] = href;
  }
  return map;
}

/// Return all text content insides body tag.
String? _filterHtmlBody(String raw) {
  final doc = html_parser.parse(raw);
  final body = doc.querySelector('body');
  final text = body?.text;
  if (text == null || text.isEmpty) return null;

  final lines = text.split('\n');
  final rmIdxs = <int>[];
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().isEmpty) {
      rmIdxs.add(i);
    }
  }

  for (var i = rmIdxs.length - 1; i >= 0; i--) {
    lines.removeAt(rmIdxs[i]);
  }

  return lines.join('\n');
}

final httpReg = RegExp(r'https?://');
