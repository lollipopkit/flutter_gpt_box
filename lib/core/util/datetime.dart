

import 'package:hive_flutter/adapters.dart';

class DateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  final typeId = 4;

  @override
  DateTime read(BinaryReader reader) {
    var microseconds = reader.readInt();
    return DateTime.fromMicrosecondsSinceEpoch(microseconds);
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.writeInt(obj.microsecondsSinceEpoch);
  }
}
