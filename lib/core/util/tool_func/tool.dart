import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart' hide RequestOptions;
import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/foundation.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/data/res/build_data.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/data/store/memory.dart';
import 'package:gpt_box/data/store/tool.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:mcp_dart/mcp_dart.dart';

part 'type.dart';
part 'func/iface.dart';
part 'func/http.dart';
part 'func/html_text.dart';
part 'func/memory.dart';
part 'func/history.dart';
part 'mcp.dart';

/// The tools a chat offers the model: the built-in ones, and every tool of
/// every connected MCP server.
abstract final class Tools {
  static const internalTools = <ToolFunc>[
    ...TfMemory.all,
    ...TfHistory.all,
    TfHttpReq.instance,
  ];

  /// One tool of each group: what the settings list, one switch each.
  static List<ToolFunc> get groups => [
    for (final (i, t) in internalTools.indexed)
      if (internalTools.indexWhere((e) => e.group == t.group) == i) t,
  ];

  /// What the model gets, when tools are on at all.
  static List<LlmTool> get enabled {
    if (!Stores.mcp.enabled.get()) return const [];
    return [
      for (final t in internalTools)
        if (isOn(t)) t.llmTool,
      ...McpTools.llmTools,
    ];
  }

  /// Whether [t]'s switch is on.
  static bool isOn(ToolFunc t) => t.defaultEnabled
      ? !Stores.mcp.disabledTools.get().contains(t.group)
      : Stores.mcp.enabledTools.get().contains(t.group);

  /// Turns [t]'s switch, and every tool's under it, [on] or off.
  static void setOn(ToolFunc t, bool on) {
    final prop = t.defaultEnabled ? Stores.mcp.disabledTools : Stores.mcp.enabledTools;
    final add = t.defaultEnabled ? !on : on;
    final rest = prop.get().where((e) => e != t.group);
    prop.set([...rest, if (add) t.group]);
  }

  /// Whether the memory tools are switched on; the memory is in the system
  /// prompt only then.
  static bool get memoryOn => isOn(TfMemory.all.first);

  static ToolFunc? internal(String name) => internalTools.firstWhereOrNull((e) => e.name == name);

  /// Runs [run] and keeps how long it took in the result's `details`, which
  /// the session stores with it for the UI (`ms`).
  static Future<LlmToolResult> timed(Future<LlmToolResult> Function() run) async {
    final sw = Stopwatch()..start();
    final r = await run();
    return LlmToolResult(
      content: r.content,
      details: {...?(r.details as Map?)?.cast<String, Object?>(), 'ms': sw.elapsedMilliseconds},
      terminate: r.terminate,
    );
  }

  /// A tool's name as the user reads it: the built-in one's own, an MCP
  /// tool's as `server__tool` has it.
  static String labelOf(String name) => internal(name)?.l10nName ?? McpTools.toolLabel(name) ?? name;

  /// A call's arguments on one line.
  static String summaryOf(String name, Map<String, Object?> args) =>
      internal(name)?.summary(args) ?? jsonEncode(args);
}
