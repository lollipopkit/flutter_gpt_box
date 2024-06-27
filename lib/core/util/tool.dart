import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:dio/dio.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:gpt_box/data/model/chat/history.dart';

part 'tool.p.dart';

abstract final class OpenAIFuncCalls {
  static const _tools = [
    _HttpReq(),
    //_RunJS(),
  ];

  static final tools = _tools.map((e) => e.into).toList();

  static Future<_Ret> handle(_CallResp resp) async {
    final tool = tools.firstWhere((t) => t.type == resp.type);
    switch (tool.type) {
      case 'function':
        final fn = tool.function;
        final args = await _parseMap(resp.function.arguments);
        final res = await _tools
            .firstWhereOrNull((e) => e.name == fn.name)
            ?.run(resp, args);
        if (res != null) return res;
        throw 'Unknown function ${fn.name}';
      default:
        throw 'Unknown tool type ${tool.type}';
    }
  }
}

abstract final class _ToolFunc {
  final String name;
  final String? description;
  final _Map parametersSchema;

  const _ToolFunc({
    required this.name,
    this.description,
    required this.parametersSchema,
  });

  Future<_Ret> run(_CallResp call, _Map args) async => throw 'Not implemented';

  OpenAIToolModel get into => OpenAIToolModel(
        type: 'function',
        function: OpenAIFunctionModel(
          name: name,
          description: description,
          parametersSchema: parametersSchema,
        ),
      );
}

final class _HttpReq extends _ToolFunc {
  const _HttpReq()
      : super(
          name: 'httpReq',
          description: '''
Send an HTTP request, returns the resp which in JSON format like:
{
  "statusCode": 200,
  "headers": {},
  "body": "..."
}
Both request/response body is String. If json, encode it into String.
If blob, encode it into base64 String.''',
          parametersSchema: const {
            'type': 'object',
            'properties': {
              'method': {
                'type': 'string',
                'description': 'The HTTP method, default is GET',
              },
              'url': {
                'type': 'string',
                'description': 'The URL to send the request',
              },
              'queryParameters': {
                'type': 'object',
                'description': 'The query parameters',
              },
              'headers': {
                'type': 'object',
                'description': 'The headers',
              },
              'body': {
                'type': 'string',
                'description': 'The request body',
              },
              'followRedirects': {
                'type': 'integer',
                'description': 'The max redirects to follow',
              },
            },
            'required': ['url'],
          },
        );

  @override
  Future<_Ret> run(_CallResp call, _Map args) async {
    final method = args['method'] ?? 'GET';
    final url = args['url'] as String;
    final queryParameters = await _parseMap(args['queryParameters']);
    final headers = args['headers'];
    final body = args['body'];
    int? followRedirects;
    try {
      followRedirects = args['followRedirects'] as int?;
    } catch (e, s) {
      Loggers.app.warning('Failed to parse followRedirects', e, s);
    }
    final resp = await myDio.request(
      url,
      queryParameters: queryParameters,
      options: Options(
        method: method,
        headers: headers,
        maxRedirects: followRedirects,
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

    final respBody = switch ((contentType, resp.data)) {
      (_, final String raw) => raw,
      (final typ, final List<int> raw) when mimesString.contains(typ) =>
        await compute(utf8.decode, raw),
      (final String typ, final List<int> raw)
          when mimesBin.any((e) => typ.startsWith(e)) =>
        await compute(base64.encode, raw),
      (_, final List<int> raw) => await compute(utf8.decode, raw),
      _ => tryConvertStr(resp.data),
    };

    final ret = {
      'statusCode': resp.statusCode,
      'headers': resp.headers.map,
      'body': respBody,
    };
    final retStr = json.encode(ret);

    return ChatContent.text(retStr).asList;
  }
}

// final class _RunJS extends _ToolFunc {
//   const _RunJS()
//       : super(
//           name: 'runJS',
//           description: 'Run JavaScript code',
//           parametersSchema: const {'code': 'The JavaScript code to run'},
//         );

//   @override
//   Future<_Msg> run(_CallResp call, _Map args) async {
//     final code = args['code'];
//     return _Msg(
//       role: _Role.tool,
//       content: [ChatContent.text('running $code').toOpenAI],
//       name: name,
//       toolCalls: [call],
//     );
//   }
// }
