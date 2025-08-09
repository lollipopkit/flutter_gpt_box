import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Element;
// import 'package:flutter_js/extensions/fetch.dart';
// import 'package:flutter_js/flutter_js.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/data/res/build_data.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:mcp_dart/mcp_dart.dart';

part 'type.dart';
part 'func/iface.dart';
part 'func/http.dart';
// part 'func/js.dart';
part 'func/memory.dart';
part 'func/history.dart';
part 'mcp.dart';
part 'internal_mcp_server.dart';

abstract final class OpenAIFuncCalls {
  static const internalTools = [
    TfMemory.instance,
    TfHistory.instance,
    // TfJs.instance,
    TfHttpReq.instance,
  ];

  static Future<Set<ChatCompletionTool>> get tools async {
    if (!Stores.mcp.enabled.get()) return {};
    
    try {
      // All tools are now handled through MCP protocol
      return McpTools.tools;
    } catch (e, s) {
      Loggers.app.warning('Load MCP tools failed', e, s);
      return {};
    }
  }

  static Future<_Ret?> handle(
    _CallResp resp,
    ToolConfirm askConfirm,
    OnToolLog onToolLog,
  ) async {
    switch (resp.type) {
      case ChatCompletionMessageToolCallType.function:
        final targetName = resp.function.name;
        final parts = targetName.split('::');
        
        // For internal tools, we still need to ask for confirmation
        if (parts.length == 2 && parts[0] == InternalMcpServer.serverName) {
          final toolName = parts[1];
          final func = internalTools.firstWhereOrNull((e) => e.name == toolName);
          if (func != null) {
            final args = await _parseMap(resp.function.arguments);
            if (!await askConfirm(func, func.help(resp, args))) return null;
          }
        }
        
        // All tools are now handled through MCP protocol
        return await McpTools.handle(resp, onToolLog);
    }
  }
}
