import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/util/api_balance.dart';

void main() {
  group('ApiBalanceProvider', () {
    group('fromEndpoint', () {
      test('returns null for OpenAI official endpoint', () {
        expect(ApiBalanceProvider.fromEndpoint('https://api.openai.com'), isNull);
      });

      test('returns deepseek for DeepSeek API', () {
        expect(
          ApiBalanceProvider.fromEndpoint('https://api.deepseek.com'),
          ApiBalanceProvider.deepseek,
        );
        expect(
          ApiBalanceProvider.fromEndpoint('https://api.deepseek.com/v1'),
          ApiBalanceProvider.deepseek,
        );
      });

      test('returns chatanywhere for ChatAnywhere endpoint', () {
        expect(
          ApiBalanceProvider.fromEndpoint('https://api.chatanywhere.org'),
          ApiBalanceProvider.chatanywhere,
        );
        expect(
          ApiBalanceProvider.fromEndpoint('https://api.chatanywhere.tech'),
          ApiBalanceProvider.chatanywhere,
        );
      });

      test('returns openrouter for OpenRouter endpoint', () {
        expect(
          ApiBalanceProvider.fromEndpoint('https://openrouter.ai'),
          ApiBalanceProvider.openrouter,
        );
        expect(
          ApiBalanceProvider.fromEndpoint('https://openrouter.ai/api/v1'),
          ApiBalanceProvider.openrouter,
        );
      });

      test('returns siliconflow for SiliconFlow endpoint', () {
        expect(
          ApiBalanceProvider.fromEndpoint('https://api.siliconflow.cn'),
          ApiBalanceProvider.siliconflow,
        );
        expect(
          ApiBalanceProvider.fromEndpoint('https://api.siliconflow.cn/v1'),
          ApiBalanceProvider.siliconflow,
        );
      });

      test('returns null for unknown third-party endpoints', () {
        // Per the code comment: "TODO: Change it to oneapi after correctly impl"
        expect(ApiBalanceProvider.fromEndpoint('https://custom-api.example.com'), isNull);
        expect(ApiBalanceProvider.fromEndpoint('https://my-server.com/v1'), isNull);
      });
    });
  });

  group('ApiBalanceState', () {
    test('constructor sets properties correctly', () {
      const state = ApiBalanceState(loading: true);
      expect(state.loading, true);
      expect(state.state, isNull);
    });

    test('supports state with balance string', () {
      const state = ApiBalanceState(loading: false, state: '9.26 CNY | 0.00 USD');
      expect(state.loading, false);
      expect(state.state, '9.26 CNY | 0.00 USD');
    });

    test('default state has null state', () {
      const state = ApiBalanceState(loading: false);
      expect(state.state, isNull);
    });
  });
}