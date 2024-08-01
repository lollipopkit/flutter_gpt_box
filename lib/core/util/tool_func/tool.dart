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
part 'func/memory.dart';
part 'func/history.dart';

abstract final class OpenAIFuncCalls {
  static const internalTools = [
    TfHttpReq.instance,
    TfMemory.instance,
    TfHistory.instance,
    //_RunJS(),
  ];

  static List<OpenAIToolModel> get tools {
    final tools = <OpenAIToolModel>[];
    if (!Stores.tool.enabled.fetch()) return tools;
    final disabledTools = Stores.tool.disabledTools.fetch();
    for (final tool in internalTools) {
      if (!disabledTools.contains(tool.name)) {
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
    switch (resp.type) {
      case 'function':
        final targetName = resp.function.name;
        final func =
            internalTools.firstWhereOrNull((e) => e.name == targetName);
        if (func == null) throw 'Unknown function $targetName';
        final args = await _parseMap(resp.function.arguments);
        if (!await askConfirm(func, func.help(resp, args))) return null;
        return await func.run(resp, args, onToolLog);
      default:
        throw 'Unknown tool type ${resp.type}';
    }
  }
}
