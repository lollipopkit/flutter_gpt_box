import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/core/util/url.dart';

void main() {
  group('ChatConfig shareUrl and fromUrlParams round-trip', () {
    test('shareUrl contains profile path', () {
      const config = ChatConfig(
        id: 'test-share',
        url: 'https://api.example.com/v1',
        key: 'sk-test-key',
        model: 'gpt-4',
        prompt: 'Be helpful',
        name: 'Test Profile',
      );
      final url = config.shareUrl;
      expect(url, startsWith(AppLink.prefix));
      expect(url, contains(AppLink.profilePath));
    });

    test('shareUrl encodes JSON params', () {
      const config = ChatConfig(
        id: 'test-share',
        url: 'https://api.example.com/v1',
        key: 'sk-test-key',
      );
      final url = config.shareUrl;
      expect(url, contains('params='));
    });

    test('shareUrl round-trips through fromUrlParams', () {
      const config = ChatConfig(
        id: 'restored-id',
        url: 'https://api.restored.com/v1',
        key: 'sk-restored',
        model: 'gpt-4o',
        prompt: 'Be helpful',
        name: 'Restored',
        historyLen: 3,
      );
      final params = Uri.parse(config.shareUrl).queryParameters['params'];
      expect(params, isNotNull);
      final restored = ChatConfigX.fromUrlParams(params!);
      expect(restored, config);
    });

    test('fromUrlParams applies defaults for missing fields', () {
      final config = ChatConfigX.fromUrlParams('{"id":"my-id"}');
      expect(config.id, 'my-id');
      expect(config.url, ChatConfigX.defaultUrl);
      expect(config.key, '');
      expect(config.model, '');
      expect(config.historyLen, ChatConfigX.defaultHistoryLen);
    });

    test('fromUrlParams preserves all optional fields', () {
      final config = ChatConfigX.fromUrlParams(
        '{"id":"full-cfg","url":"https://api.test.com/v1","key":"sk-key","model":"gpt-4","prompt":"Be helpful","name":"My Config","genTitlePrompt":"Generate title","historyLen":10}',
      );
      expect(config.id, 'full-cfg');
      expect(config.url, 'https://api.test.com/v1');
      expect(config.key, 'sk-key');
      expect(config.model, 'gpt-4');
      expect(config.prompt, 'Be helpful');
      expect(config.name, 'My Config');
      expect(config.genTitlePrompt, 'Generate title');
      expect(config.historyLen, 10);
      // Note: genTitleModel is not parsed by fromUrlParams unless present in JSON
    });
  });

  group('AppLink', () {
    test('URL components are consistent', () {
      // All paths should start with /
      expect(AppLink.newChatPath, startsWith('/'));
      expect(AppLink.openChatPath, startsWith('/'));
      expect(AppLink.searchPath, startsWith('/'));
      expect(AppLink.shareChatPath, startsWith('/'));
      expect(AppLink.goPath, startsWith('/'));
      expect(AppLink.setPath, startsWith('/'));
      expect(AppLink.profilePath, startsWith('/'));
    });

    test('scheme and host form valid prefix', () {
      final prefix = AppLink.prefix;
      expect(prefix, '${AppLink.scheme}://${AppLink.host}');
    });
  });
}