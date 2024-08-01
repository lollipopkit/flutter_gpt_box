part of '../tool.dart';

final class TfHttpReq extends ToolFunc {
  static const instance = TfHttpReq._();

  const TfHttpReq._()
      : super(
          name: 'httpReq',
          description: '''
Send an HTTP request. It can be used for searching, downloading, etc.

If user wants to search, use `bing.com` as the search engine and set `forSearch` to true.

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
