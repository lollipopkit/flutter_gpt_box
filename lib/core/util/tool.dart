import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:dio/dio.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/model/chat/history.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:html/parser.dart' as html_parser;

part 'tool.p.dart';

abstract final class OpenAIFuncCalls {
  static const _tools = [
    _HttpReq(),
    //_RunJS(),
  ];

  static final tools = _tools.map((e) => e.into).toList();

  static Future<_Ret?> handle(
    _CallResp resp,
    ToolConfirm askConfirm,
    OnToolLog onToolLog,
  ) async {
    final tool = tools.firstWhere((t) => t.type == resp.type);
    switch (tool.type) {
      case 'function':
        final fn = tool.function;
        final args = await _parseMap(resp.function.arguments);
        final func = _tools.firstWhereOrNull((e) => e.name == fn.name);
        if (func == null) throw 'Unknown function ${fn.name}';
        if (!await askConfirm(func, func.help(resp, args))) return null;
        return await func.run(resp, args, onToolLog);
      default:
        throw 'Unknown tool type ${tool.type}';
    }
  }
}

abstract final class ToolFunc {
  final String name;
  final String? description;
  final _Map parametersSchema;

  const ToolFunc({
    required this.name,
    this.description,
    required this.parametersSchema,
  });

  /// For users to understand what this function does.
  /// Used in permission request dialog.
  String help(_CallResp call, _Map args) {
    return '''

${json.encode(call)}

${json.encode(args)}
''';
  }

  Future<_Ret> run(_CallResp call, _Map args, OnToolLog log) async =>
      throw 'Not implemented';

  OpenAIToolModel get into => OpenAIToolModel(
        type: 'function',
        function: OpenAIFunctionModel(
          name: name,
          description: description,
          parametersSchema: parametersSchema,
        ),
      );
}

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
