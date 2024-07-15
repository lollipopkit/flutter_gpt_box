import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:dio/dio.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:html/parser.dart' as html_parser;

part 'type.dart';
part 'func/iface.dart';
part 'func/http.dart';
part 'func/js.dart';

abstract final class OpenAIFuncCalls {
  static const internalTools = [
    _HttpReq(),
    //_RunJS(),
  ];

  static List<OpenAIToolModel> get tools {
    final tools = <OpenAIToolModel>[];
    final enabledTools = Stores.tool.enabledTools.fetch();
    for (final tool in internalTools) {
      if (enabledTools.contains(tool.name)) {
        tools.add(tool.into);
      }
    }
    return tools;
  }

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
        final func = internalTools.firstWhereOrNull((e) => e.name == fn.name);
        if (func == null) throw 'Unknown function ${fn.name}';
        if (!await askConfirm(func, func.help(resp, args))) return null;
        return await func.run(resp, args, onToolLog);
      default:
        throw 'Unknown tool type ${tool.type}';
    }
  }
}
