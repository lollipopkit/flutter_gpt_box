import 'dart:convert';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';

/// Asks the user whether [call] may run. The run waits for the answer.
Future<LlmApproval> askToolApproval(BuildContext context, LlmToolCall call) async {
  if (!context.mounted) return const LlmApproval.deny('The app is not showing');
  final args = const JsonEncoder.withIndent('  ').convert(call.args);
  final internal = Tools.internal(call.name);
  final ret = await context.showRoundDialog<String>(
    title: l10n.toolConfirmFmt(internal?.l10nName ?? call.name),
    barrierDismiss: false,
    child: SingleChildScrollView(
      child: internal != null
          ? SimpleMarkdown(data: internal.help(call.args))
          : SelectableText(args, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
    ),
    actions: [
      Btn.text(text: l10n.deny, onTap: () => context.pop('deny')),
      Btn.text(text: l10n.allowAlways, onTap: () => context.pop('always')),
      Btn.text(text: l10n.allow, onTap: () => context.pop('once')),
    ],
  );
  switch (ret) {
    case 'always':
      Stores.mcp.permittedTools.set({...Stores.mcp.permittedTools.get(), call.name}.toList());
      return const LlmApproval.allow();
    case 'once':
      return const LlmApproval.allow();
    default:
      return const LlmApproval.deny('The user denied it');
  }
}
