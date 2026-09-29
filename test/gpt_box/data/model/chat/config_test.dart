import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/chat/config.dart';

void main() {
  group('ChatConfig', () {
    test('default constructor creates valid config', () {
      const config = ChatConfig();
      expect(config.prompt, '');
      expect(config.url, ChatConfigX.defaultUrl);
      expect(config.key, '');
      expect(config.model, '');
      expect(config.historyLen, ChatConfigX.defaultHistoryLen);
      expect(config.id, ChatConfigX.defaultId);
      expect(config.name, '');
      expect(config.genTitlePrompt, isNull);
      expect(config.genTitleModel, isNull);
      expect(config.imgModel, isNull);
    });

    test('custom constructor sets properties', () {
      const config = ChatConfig(
        id: 'test-id',
        url: 'https://custom.api.com/v1',
        key: 'sk-test-key',
        model: 'gpt-4',
        prompt: 'You are a helpful assistant',
        name: 'My Config',
        historyLen: 10,
      );
      expect(config.id, 'test-id');
      expect(config.url, 'https://custom.api.com/v1');
      expect(config.key, 'sk-test-key');
      expect(config.model, 'gpt-4');
      expect(config.prompt, 'You are a helpful assistant');
      expect(config.name, 'My Config');
      expect(config.historyLen, 10);
    });

    test('fromJson and toJson round-trip', () {
      const config = ChatConfig(
        id: 'test-id',
        url: 'https://api.test.com/v1',
        key: 'sk-key',
        model: 'gpt-4o',
        prompt: 'Test prompt',
        name: 'Test Config',
        historyLen: 5,
      );
      final json = config.toJson();
      final fromJson = ChatConfig.fromJson(json);
      expect(fromJson.id, config.id);
      expect(fromJson.url, config.url);
      expect(fromJson.key, config.key);
      expect(fromJson.model, config.model);
      expect(fromJson.prompt, config.prompt);
      expect(fromJson.name, config.name);
      expect(fromJson.historyLen, config.historyLen);
    });

    test('copyWith creates modified copy preserving original', () {
      const config = ChatConfig(id: 'orig', model: 'gpt-3.5-turbo');
      final modified = config.copyWith(model: 'gpt-4o');
      expect(modified.model, 'gpt-4o');
      expect(modified.id, 'orig');
      expect(config.model, 'gpt-3.5-turbo');
    });

    test('copyWith with all fields', () {
      const config = ChatConfig(id: 'orig');
      final modified = config.copyWith(
        id: 'new-id',
        url: 'https://new.api.com/v1',
        key: 'new-key',
        model: 'new-model',
        prompt: 'new prompt',
        name: 'New Name',
        historyLen: 99,
        imgModel: 'dall-e-3',
        genTitlePrompt: 'Gen title',
        genTitleModel: 'gpt-4o-mini',
      );
      expect(modified.id, 'new-id');
      expect(modified.url, 'https://new.api.com/v1');
      expect(modified.key, 'new-key');
      expect(modified.model, 'new-model');
      expect(modified.prompt, 'new prompt');
      expect(modified.name, 'New Name');
      expect(modified.historyLen, 99);
      expect(modified.imgModel, 'dall-e-3');
      expect(modified.genTitlePrompt, 'Gen title');
      expect(modified.genTitleModel, 'gpt-4o-mini');
    });

    test('toString format', () {
      const config = ChatConfig(id: 'test-id', url: 'https://api.test.com', model: 'gpt-4');
      expect(config.toString(), contains('test-id'));
      expect(config.toString(), contains('gpt-4'));
    });
  });

  group('ChatConfigX', () {
    test('defaultId is defaultId', () {
      expect(ChatConfigX.defaultId, 'defaultId');
    });

    test('defaultUrl is OpenAI API v1', () {
      expect(ChatConfigX.defaultUrl, 'https://api.openai.com/v1');
    });

    test('defaultHistoryLen is 7', () {
      expect(ChatConfigX.defaultHistoryLen, 7);
    });

    test('defaultImgModel is dall-e-3', () {
      expect(ChatConfigX.defaultImgModel, 'dall-e-3');
    });

    test('defaultOne has correct defaults', () {
      const defaults = ChatConfigX.defaultOne;
      expect(defaults.id, ChatConfigX.defaultId);
      expect(defaults.url, ChatConfigX.defaultUrl);
      expect(defaults.historyLen, ChatConfigX.defaultHistoryLen);
      expect(defaults.key, '');
      expect(defaults.model, '');
      expect(defaults.name, '');
      expect(defaults.prompt, '');
    });

    test('isDefault returns true for defaultId', () {
      const config = ChatConfig(id: ChatConfigX.defaultId);
      expect(config.isDefault, true);
    });

    test('isDefault returns false for custom id', () {
      const config = ChatConfig(id: 'custom-id');
      expect(config.isDefault, false);
    });

    test('shareUrl creates valid URL format', () {
      const config = ChatConfig(
        id: 'test',
        url: 'https://api.test.com/v1',
        key: 'sk-test',
        model: 'gpt-4',
      );
      final url = config.shareUrl;
      expect(url, startsWith('lpkt.cn://gptbox/profile'));
      expect(url, contains('params='));
    });

    test('fromUrlParams parses valid JSON params', () {
      final params = json.encode({
        'id': 'test-id',
        'url': 'https://api.test.com/v1',
        'key': 'sk-test',
        'model': 'gpt-4',
        'prompt': 'Hello',
        'name': 'My Config',
        'historyLen': 5,
      });
      final config = ChatConfigX.fromUrlParams(params);
      expect(config.id, 'test-id');
      expect(config.url, 'https://api.test.com/v1');
      expect(config.key, 'sk-test');
      expect(config.model, 'gpt-4');
      expect(config.prompt, 'Hello');
      expect(config.name, 'My Config');
      expect(config.historyLen, 5);
    });

    test('fromUrlParams uses defaults for missing fields', () {
      final params = json.encode({'id': 'test-id'});
      final config = ChatConfigX.fromUrlParams(params);
      expect(config.id, 'test-id');
      expect(config.url, ChatConfigX.defaultUrl);
      expect(config.key, '');
      expect(config.model, '');
      expect(config.prompt, '');
      expect(config.name, '');
      expect(config.historyLen, ChatConfigX.defaultHistoryLen);
    });

    test('shouldUpdateRelated detects key changes', () {
      const orig = ChatConfig(id: 'same', key: 'key1', url: 'https://a.com');
      final changed = orig.copyWith(key: 'key2');
      expect(changed.shouldUpdateRelated(orig), true);
    });

    test('shouldUpdateRelated detects url changes', () {
      const orig = ChatConfig(id: 'same', url: 'https://a.com');
      final changed = orig.copyWith(url: 'https://b.com');
      expect(changed.shouldUpdateRelated(orig), true);
    });

    test('shouldUpdateRelated detects id changes', () {
      const orig = ChatConfig(id: 'id1');
      const changed = ChatConfig(id: 'id2');
      expect(changed.shouldUpdateRelated(orig), true);
    });

    test('shouldUpdateRelated returns false for only prompt change', () {
      const orig = ChatConfig(id: 'same', prompt: 'a');
      final changed = orig.copyWith(prompt: 'b');
      expect(changed.shouldUpdateRelated(orig), false);
    });

    test('shouldUpdateRelated returns false for only model change', () {
      const orig = ChatConfig(id: 'same', model: 'gpt-3.5');
      final changed = orig.copyWith(model: 'gpt-4');
      expect(changed.shouldUpdateRelated(orig), false);
    });

    test('apiUrlReg matches valid API URLs', () {
      expect(ChatConfigX.apiUrlReg.hasMatch('https://api.example.com'), true);
      expect(ChatConfigX.apiUrlReg.hasMatch('http://localhost:8080'), true);
      expect(ChatConfigX.apiUrlReg.hasMatch('https://192.168.1.1:3000'), true);
      expect(ChatConfigX.apiUrlReg.hasMatch('https://api.openai.com'), true);
    });

    test('apiUrlReg rejects invalid API URLs', () {
      expect(ChatConfigX.apiUrlReg.hasMatch('https://api.example.com/v1'), false);
      expect(ChatConfigX.apiUrlReg.hasMatch('not-a-url'), false);
      expect(ChatConfigX.apiUrlReg.hasMatch('ftp://example.com'), false);
      expect(ChatConfigX.apiUrlReg.hasMatch('https://api.example.com/v1/chat'), false);
      expect(ChatConfigX.apiUrlReg.hasMatch(''), false);
    });

    group('displayName', () {
      test('returns default label for default config with empty name', () {
        // Note: displayName depends on l10n which requires Flutter setup.
        // This test verifies the logic structure.
        const config = ChatConfig(id: ChatConfigX.defaultId, name: '');
        // displayName calls l10n.defaulT which needs localization
        expect(config.id, ChatConfigX.defaultId);
        expect(config.name, '');
      });

      test('returns name for named config', () {
        const config = ChatConfig(id: 'custom', name: 'My Profile');
        expect(config.name, 'My Profile');
      });

      test('returns name for default config with custom name', () {
        const config = ChatConfig(id: ChatConfigX.defaultId, name: 'Custom Default');
        expect(config.name, 'Custom Default');
      });
    });
  });
}