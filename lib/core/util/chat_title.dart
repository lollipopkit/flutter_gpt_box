abstract final class ChatTitleUtil {
  static const _maxLen = 20;

  static const titlePrompt = '''
Generate a title for the user content behind `GPTBOX>>>` with requirements: 
0. the language of the generated title should be the same as the user content
1. <= 10 characters if Chinese, Japanese, Korean, etc.
2. <= $_maxLen letters if English, German, French, etc.
3. the title should be meaningful, concise, no additional punctuation and only title itself
GPTBOX>>>''';

  static final _punctionsRm = RegExp('[“”]');

  static String prettify(String title) {
    // If it's wrapped with `《》`
    if (title.startsWith('《')) title = title.substring(1);
    if (title.endsWith('》')) title = title.substring(0, title.length - 1);

    title = title.replaceAll(_punctionsRm, '');

    if (title.length > _maxLen) {
      title = title.substring(0, _maxLen);
    }

    return title;
  }
}
