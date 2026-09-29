import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/util/json.dart';

void main() {
  group('fromJsonList', () {
    test('returns empty list for null input', () {
      final result = fromJsonList(null, (json) => json['value'] as String);
      expect(result, isEmpty);
    });

    test('parses valid list of maps', () {
      final json = [
        {'value': 'a'},
        {'value': 'b'},
        {'value': 'c'},
      ];
      final result =
          fromJsonList(json, (json) => json['value'] as String);
      expect(result, ['a', 'b', 'c']);
    });

    test('skips items that throw during parsing', () {
      final json = [
        {'value': 'a'},
        {'wrong_key': 'b'}, // will throw on 'value' access
        {'value': 'c'},
      ];
      final result =
          fromJsonList(json, (json) => json['value'] as String);
      expect(result, ['a', 'c']);
    });

    test('handles empty list', () {
      final result =
          fromJsonList([], (json) => json['value'] as String);
      expect(result, isEmpty);
    });

    test('handles list with all invalid items', () {
      final json = [
        {'wrong': 'a'},
        {'wrong': 'b'},
      ];
      final result =
          fromJsonList(json, (json) => json['value'] as String);
      expect(result, isEmpty);
    });

    test('handles complex object parsing', () {
      final json = [
        {'name': 'item1', 'count': 1},
        {'name': 'item2', 'count': 2},
      ];
      final result = fromJsonList(
        json,
        (json) => '${json['name']}:${json['count']}',
      );
      expect(result, ['item1:1', 'item2:2']);
    });
  });

  group('fromJsonMap', () {
    test('returns empty map for null input', () {
      final result = fromJsonMap(null, (json) => json['value'] as String);
      expect(result, isEmpty);
    });

    test('parses valid map of maps', () {
      final json = {
        'key1': {'value': 'a'},
        'key2': {'value': 'b'},
      };
      final result =
          fromJsonMap(json, (json) => json['value'] as String);
      expect(result, {'key1': 'a', 'key2': 'b'});
    });

    test('skips entries that throw during parsing', () {
      final json = {
        'key1': {'value': 'a'},
        'key2': {'wrong': 'b'},
        'key3': {'value': 'c'},
      };
      final result =
          fromJsonMap(json, (json) => json['value'] as String);
      expect(result, {'key1': 'a', 'key3': 'c'});
    });

    test('handles empty map', () {
      final result =
          fromJsonMap({}, (json) => json['value'] as String);
      expect(result, isEmpty);
    });

    test('handles map with all invalid entries', () {
      final json = {
        'key1': {'wrong': 'a'},
        'key2': {'wrong': 'b'},
      };
      final result =
          fromJsonMap(json, (json) => json['value'] as String);
      expect(result, isEmpty);
    });
  });
}