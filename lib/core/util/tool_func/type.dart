part of 'tool.dart';

typedef _Map = Map<String, dynamic>;

/// A line of progress from a running tool.
typedef OnToolLog = void Function(String log);

void _log(String line) => Loggers.app.fine('[tool] $line');
