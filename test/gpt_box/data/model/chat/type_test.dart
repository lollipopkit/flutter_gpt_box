import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/chat/type.dart';

void main() {
  group('ChatType', () {
    test('has correct enum values', () {
      expect(ChatType.values.length, 2);
      expect(ChatType.values, contains(ChatType.text));
      expect(ChatType.values, contains(ChatType.img));
    });

    test('fromString returns correct type for valid strings', () {
      expect(ChatType.fromString('text'), ChatType.text);
      expect(ChatType.fromString('img'), ChatType.img);
    });

    test('fromString returns null for invalid strings', () {
      expect(ChatType.fromString('unknown'), isNull);
      expect(ChatType.fromString(''), isNull);
      expect(ChatType.fromString(null), isNull);
    });

    test('fromIdx returns correct type for valid indices', () {
      expect(ChatType.fromIdx(0), ChatType.text);
      expect(ChatType.fromIdx(1), ChatType.img);
    });

    test('fromIdx returns null for invalid indices', () {
      expect(ChatType.fromIdx(-1), isNull);
      expect(ChatType.fromIdx(2), isNull);
      expect(ChatType.fromIdx(100), isNull);
      expect(ChatType.fromIdx(null), isNull);
    });

  });
}