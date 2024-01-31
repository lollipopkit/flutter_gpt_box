import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/datetime.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:logging/logging.dart';

const _kMaxDebugLogLines = 177;
const _level2Color = {
  'INFO': Colors.blue,
  'WARNING': Colors.yellow,
};

abstract final class DebugNotifier {
  static final node = RebuildNode();
  static final logs = <LogRecord>[];
  static final state = <Widget>[];

  static void addLog(LogRecord record) {
    logs.add(record);
    final color = _level2Color[record.level.name] ?? Colors.blue;
    state.addAll([
      Text.rich(TextSpan(
        children: [
          TextSpan(
            text: '[${DateTime.now().hourMinute}][${record.loggerName}]',
            style: const TextStyle(color: Colors.cyan),
          ),
          TextSpan(
            text: '[${record.level}]',
            style: TextStyle(color: color),
          ),
          TextSpan(
            text: record.error == null
                ? '\n${record.message}'
                : '\n${record.message}: ${record.error}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      )),
      if (record.stackTrace != null)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            '${record.stackTrace}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      UIs.height13,
    ]);

    if (state.length > _kMaxDebugLogLines) {
      state.sublist(state.length - _kMaxDebugLogLines);
    }

    node.rebuild();
  }

  static String get logsStr {
    final sb = StringBuffer();
    for (final log in logs) {
      sb.writeln('[${log.level.name}][${log.loggerName}]: ${log.message}');
      if (log.error != null) {
        sb.writeln(log.error);
      }
      if (log.stackTrace != null) {
        sb.writeln(log.stackTrace);
      }
      sb.writeln();
    }
    return sb.toString();
  }
}
