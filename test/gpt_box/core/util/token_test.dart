import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/util/token.dart';

void main() {
  group('TiktokenUtils', () {
    group('getPrice', () {
      test('returns 0.00006 for gpt-4-32k', () {
        expect(TiktokenUtils.getPrice('gpt-4-32k'), 0.00006);
      });

      test('returns 0.00003 for gpt-4', () {
        expect(TiktokenUtils.getPrice('gpt-4'), 0.00003);
      });

      test('returns 0.00001 for gpt-4 variants', () {
        expect(TiktokenUtils.getPrice('gpt-4-turbo'), 0.00001);
        expect(TiktokenUtils.getPrice('gpt-4-1106-preview'), 0.00001);
        expect(TiktokenUtils.getPrice('gpt-4-vision'), 0.00001);
      });

      test('returns 0.000001 for gpt-3.5 variants', () {
        expect(TiktokenUtils.getPrice('gpt-3.5-turbo'), 0.000001);
        expect(TiktokenUtils.getPrice('gpt-3.5-turbo-16k'), 0.000001);
      });

      test('returns null for unknown models', () {
        expect(TiktokenUtils.getPrice('claude-3'), isNull);
        expect(TiktokenUtils.getPrice('deepseek-chat'), isNull);
        expect(TiktokenUtils.getPrice(''), isNull);
        expect(TiktokenUtils.getPrice('random-model'), isNull);
      });
    });
  });
}