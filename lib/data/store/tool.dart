import 'package:fl_lib/fl_lib.dart';

final class ToolStore extends PersistentStore {
  ToolStore() : super('tool');

  late final permittedTools = property('permittedTools', <String>[]);
}