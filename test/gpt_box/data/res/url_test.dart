import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/res/url.dart';

void main() {
  group('Urls', () {
    test('myGithub is correct', () {
      expect(Urls.myGithub, 'https://github.com/lollipopkit');
    });

    test('repoBase is correct', () {
      expect(Urls.repoBase, 'https://github.com/lollipopkit/flutter_gpt_box');
    });

    test('repoDiscussion is correct', () {
      expect(Urls.repoDiscussion, '${Urls.repoBase}/discussions');
    });

    test('repoIssue is correct', () {
      expect(Urls.repoIssue, '${Urls.repoBase}/issues');
    });

    test('unilinkDoc is correct', () {
      expect(Urls.unilinkDoc, '${Urls.repoBase}/blob/main/doc/uni_link.md');
    });

    test('openaiRestoreDoc is correct', () {
      expect(Urls.openaiRestoreDoc, '${Urls.repoBase}/blob/main/doc/openai_restore.md');
    });

    test('githubModels is correct', () {
      expect(Urls.githubModels, 'https://models.inference.ai.azure.com');
    });

    test('all URLs use https', () {
      expect(Urls.myGithub, startsWith('https://'));
      expect(Urls.repoBase, startsWith('https://'));
      expect(Urls.repoDiscussion, startsWith('https://'));
      expect(Urls.repoIssue, startsWith('https://'));
      expect(Urls.unilinkDoc, startsWith('https://'));
      expect(Urls.openaiRestoreDoc, startsWith('https://'));
      expect(Urls.serverBoxRepo, startsWith('https://'));
      expect(Urls.githubReleasesApi, startsWith('https://'));
      expect(Urls.githubModels, startsWith('https://'));
    });
  });
}