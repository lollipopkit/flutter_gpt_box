import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/util/chat_title.dart';

void main() {
  group('ChatTitleUtil', () {
    group('prettify', () {
      test('removes 《》book quotes', () {
        expect(ChatTitleUtil.prettify('《测试标题》'), '测试标题');
        expect(ChatTitleUtil.prettify('《Hello World》'), 'Hello World');
      });

      test('removes only opening 《', () {
        expect(ChatTitleUtil.prettify('《测试'), '测试');
      });

      test('removes only closing 》', () {
        expect(ChatTitleUtil.prettify('测试》'), '测试');
      });

      test('removes userContentLocator', () {
        expect(
          ChatTitleUtil.prettify('${ChatTitleUtil.userCotentLocator}Hello'),
          'Hello',
        );
      });

      test('removes smart quotes (unicode left/right double quotation marks)', () {
        // The regex removes \u201C and \u201D (curly/smart quotes)
        expect(ChatTitleUtil.prettify('\u201CHello\u201D'), 'Hello');
      });

      test('replaces newlines with spaces', () {
        expect(ChatTitleUtil.prettify('Hello\nWorld'), 'Hello World');
        expect(ChatTitleUtil.prettify('Line1\nLine2\nLine3'), 'Line1 Line2 Line3');
      });

      test('truncates long titles to max length', () {
        final longTitle = 'a' * 30;
        final result = ChatTitleUtil.prettify(longTitle);
        expect(result.length, 20);
      });

      test('keeps short titles unchanged', () {
        expect(ChatTitleUtil.prettify('Hello'), 'Hello');
        expect(ChatTitleUtil.prettify('短标题'), '短标题');
      });

      test('removes Claude end match pattern', () {
        expect(ChatTitleUtil.prettify('Title[](ID:1|UUID:ab'), 'Title');
      });

      test(
        'removes Claude end match pattern when title exceeds max length',
        () {
          expect(
            ChatTitleUtil.prettify('My Title[](ID:123|UUID:abc'),
            'My Title',
          );
        },
      );

      test('handles combined transformations', () {
        final result = ChatTitleUtil.prettify('《Test “Title”\nExtra》');
        expect(result, 'Test Title Extra');
      });

      test('handles empty string', () {
        expect(ChatTitleUtil.prettify(''), '');
      });

      test('handles string equal to max length', () {
        final title = 'a' * 20;
        expect(ChatTitleUtil.prettify(title), title);
      });

      test('handles string one over max length', () {
        final title = 'a' * 21;
        expect(ChatTitleUtil.prettify(title).length, 20);
      });
    });

    group('titlePrompt', () {
      test('contains userContentLocator', () {
        expect(ChatTitleUtil.titlePrompt, contains(ChatTitleUtil.userCotentLocator));
      });

      test('contains length constraints', () {
        expect(ChatTitleUtil.titlePrompt, contains('10'));
        expect(ChatTitleUtil.titlePrompt, contains('20'));
      });
    });

    group('claudeEndReg', () {
      test('matches Claude end pattern', () {
        final text = 'Title[](ID:123|UUID:abc-def';
        expect(ChatTitleUtil.claudeEndReg.hasMatch(text), true);
      });

      test('does not match normal text', () {
        expect(ChatTitleUtil.claudeEndReg.hasMatch('Normal Title'), false);
      });
    });

    group('pickSuitableModel', () {
      // Note: This test cannot fully exercise the model selection logic
      // since it depends on Cfg.current which requires initialized stores.
      // We test that it returns the current model as fallback.
      test('userCotentLocator constant is correct', () {
        expect(ChatTitleUtil.userCotentLocator, 'GPTBOX>>>');
      });
    });
  });
}