import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/foundation.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/data/res/build_data.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:mcp_dart/mcp_dart.dart';

part 'type.dart';
part 'func/iface.dart';
part 'func/http.dart';
part 'func/memory.dart';
part 'func/history.dart';
part 'mcp.dart';

/// The tools a chat offers the model: the built-in ones, and every tool of
/// every connected MCP server.
abstract final class Tools {
  static const internalTools = <ToolFunc>[
    TfMemory.instance,
    TfHistory.instance,
    TfHttpReq.instance,
  ];

  /// What the model gets, when tools are on at all.
  static List<LlmTool> get enabled {
    if (!Stores.mcp.enabled.get()) return const [];
    final disabled = Stores.mcp.disabledTools.get().toSet();
    return [
      for (final t in internalTools)
        if (!disabled.contains(t.name)) t.llmTool,
      ...McpTools.llmTools,
    ];
  }

  static ToolFunc? internal(String name) => internalTools.firstWhereOrNull((e) => e.name == name);

  /// What the approval dialog says about [call].
  static String helpFor(LlmToolCall call) {
    final f = internal(call.name);
    if (f != null) return f.help(call.args);
    return '```json\n${const JsonEncoder.withIndent('  ').convert(call.args)}\n```';
  }
}
