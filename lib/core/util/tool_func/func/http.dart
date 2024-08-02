part of '../tool.dart';

final class TfHttpReq extends ToolFunc {
  static const instance = TfHttpReq._();

  const TfHttpReq._()
      : super(
          name: 'httpReq',
          description: '''
Send an HTTP request. It can be used for searching, downloading, etc.


If user want to access some content having an json API, use the API directly.
Such as api.github.com. You can use all the APIs that you(AI model) know.


If users wants to search:
- set `forSearch` to true
- set `url` to search engine's url
- set `headers` to search engine's headers, includes cookies, headers and etc.

Example search engines:
- Google: `https://www.google.com/search?q=`
- Baidu: `https://www.baidu.com/s?wd=`
- Bing: `https://www.bing.com/search?q=`
Default:
- user's language is Chinese: Baidu
- Non-Chinese: Google


Both request/response body is String. If json, encode it into String.
If blob, encode it into base64 String.''',
          parametersSchema: const {
            'type': 'object',
            'properties': {
              'method': {
                'type': 'string',
                'description': 'HTTP method, default GET',
              },
              'url': {
                'type': 'string',
                'description': 'URL',
              },
              'headers': {
                'type': 'object',
                'description': 'Headers map',
              },
              'body': {
                'type': 'string',
                'description': 'Request body',
              },
              'followRedirects': {
                'type': 'integer',
                'description': 'Max redirects to follow',
              },
              'forSearch': {
                'type': 'boolean',
                'description': 'Default false.',
              },
              'truncateSize': {
                'type': 'integer',
                'description':
                    'If user wants to save tokens, set it to the max size of the response body',
              },
            },
            'required': ['url'],
          },
        );

  @override
  String get l10nName => l10n.toolHttpReqName;

  @override
  String? get l10nTip => l10n.httpToolTip;

  @override
  String help(_CallResp call, _Map args) {
    return l10n.toolHttpReqHelp(args['url'] as String? ?? '<?>');
  }

  @override
  Future<_Ret> run(_CallResp call, _Map args, OnToolLog log) async {
    final method = args['method'] as String? ?? 'GET';
    final url = args['url'] as String;
    final headers = (args['headers'] as Map?)?.cast<String, dynamic>();
    final body = args['body'] as String?;
    final forSearch = args['forSearch'] as bool? ?? false;
    final truncateSize = args['truncateSize'] as int?;
    final followRedirects = args['followRedirects'] as int?;

    log('Http $method -> $url');
    final resp = await myDio.request(
      url,
      options: Options(
        method: method,
        headers: headers,
        maxRedirects: followRedirects,
        validateStatus: (_) => true,
      ),
      data: body,
    );

    const mimesBin = [
      'application/octet-stream',
      'image/',
      'video/',
      'audio/',
    ];

    const mimesString = [
      'text/',
      'application/json',
      'application/xml',
      'application/javascript',
      'application/x-www-form-urlencoded',
    ];

    final contentType = resp.headers['content-type']?.join(';');

    String tryConvertStr(raw) {
      try {
        return raw.toString();
      } catch (e) {
        return '';
      }
    }

    log('Http $method -> ${resp.statusCode} ${resp.statusMessage}');
    var respBody = switch ((contentType, resp.data)) {
      (_, final String raw) => raw,
      (final typ, final List<int> raw) when mimesString.contains(typ) =>
        await compute(utf8.decode, raw),
      (final String typ, final List<int> raw)
          when mimesBin.any((e) => typ.startsWith(e)) =>
        await compute(base64.encode, raw),
      (_, final List<int> raw) => await compute(utf8.decode, raw),
      _ => tryConvertStr(resp.data),
    };

    if (forSearch) {
      final urlMap = await compute(_filterHtmlUrls, respBody);
      if (urlMap.isNotEmpty) {
        respBody = '';

        var count = 0;
        for (final entry in urlMap.entries) {
          if (count++ > 5) break;
          final url = entry.value;
          log('Http $method -> $url');
          try {
            final resp = await myDio.request(
              entry.value,
              options: Options(
                method: 'GET',
                maxRedirects: followRedirects,
                validateStatus: (_) => true,
                responseType: ResponseType.plain,
              ),
            );

            final data = resp.data;
            if (data is! String) continue;
            final html = await compute(_filterHtmlBody, data);
            if (html != null) {
              respBody += html;
            }
          } catch (e) {
            log('Http $method -> ${l10n.error}: $e');
          }
        }
      }
    }

    if (truncateSize != null && respBody.length > truncateSize) {
      respBody = respBody.substring(0, truncateSize);
    }

    await Future.delayed(Durations.short3);
    log('Http $method -> ${l10n.success}');
    await Future.delayed(Durations.short3);

    return [ChatContent.text(respBody)];
  }
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
