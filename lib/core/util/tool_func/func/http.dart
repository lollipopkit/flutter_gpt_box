part of '../tool.dart';

final class _HttpReq extends ToolFunc {
  const _HttpReq()
      : super(
          name: 'httpReq',
          description: '''
Send an HTTP request. It can be used for searching, downloading, etc.

If for searching: use Bing.

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
  String help(_CallResp call, _Map args) {
    return l10n.toolHttpReqHelp(args['url'] as String? ?? '<?>');
  }

  @override
  Future<_Ret> run(_CallResp call, _Map args, OnToolLog log) async {
    final method = args['method'] ?? 'GET';
    final url = args['url'] as String;
    final headers = args['headers'];
    final body = args['body'];
    final forSearch = args['forSearch'] as bool? ?? false;
    final truncateSize = args['truncateSize'] as int?;
    int? followRedirects;
    try {
      followRedirects = args['followRedirects'] as int?;
    } catch (e, s) {
      Loggers.app.warning('Failed to parse followRedirects', e, s);
    }

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

    final contentType = resp.headers['content-type']?.firstOrNull;

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
      respBody = await compute(_filterHtml, respBody);
    }

    if (truncateSize != null && respBody.length > truncateSize) {
      respBody = respBody.substring(0, truncateSize);
    }

    await Future.delayed(Durations.medium1);
    log('Http $method -> ${l10n.success}');
    await Future.delayed(Durations.medium1);

    return ChatContent.text(respBody).asList;
  }
}
