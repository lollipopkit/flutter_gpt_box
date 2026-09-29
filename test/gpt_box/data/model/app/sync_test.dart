import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/app/sync.dart';

void main() {
  group('SyncResult', () {
    test('constructor sets all fields', () {
      const result = SyncResult(
        up: ['a', 'b'],
        down: ['c'],
        err: {'d': 'error'},
      );
      expect(result.up, ['a', 'b']);
      expect(result.down, ['c']);
      expect(result.err, {'d': 'error'});
    });

    test('supports empty collections', () {
      const result = SyncResult<String, String>(
        up: [],
        down: [],
        err: {},
      );
      expect(result.up, isEmpty);
      expect(result.down, isEmpty);
      expect(result.err, isEmpty);
    });

    test('toString contains field values', () {
      const result = SyncResult(
        up: ['file1'],
        down: ['file2'],
        err: {'file3': 'timeout'},
      );
      final str = result.toString();
      expect(str, contains('file1'));
      expect(str, contains('file2'));
      expect(str, contains('timeout'));
    });

    test('works with integer sync type', () {
      const result = SyncResult<int, String>(
        up: [1, 2, 3],
        down: [4, 5],
        err: {6: 'network error'},
      );
      expect(result.up.length, 3);
      expect(result.down.length, 2);
      expect(result.err[6], 'network error');
    });
  });
}