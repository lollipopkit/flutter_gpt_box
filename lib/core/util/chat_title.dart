import 'package:gpt_box/data/res/openai.dart';

abstract final class ChatTitleUtil {
  static const _maxLen = 20;

  static const userCotentLocator = 'GPTBOX>>>';

  static final claudeEndReg = RegExp(r'\[\]\(ID:\d+\|UUID:\S+');

//   static const toolPrompt = '''
// Only returns the toolCall part.
// If there is no toolCall section returned, return the message as empty.''';

  static const titlePrompt = '''
Generate a title for the user content behind `$userCotentLocator` with requirements: 
0. you are generating a title, not a content.
1. the language of the generated title should be the same as the user content
2. title length <= 10 characters if Chinese, Japanese, Korean, etc.
3. title lengt <= $_maxLen letters if English, German, French, etc.
4. the title should be meaningful, concise, no additional punctuation and only title itself.
$userCotentLocator''';

  static final _punctionsRm = RegExp('[“”]');

  static String prettify(String title) {
    // If it's wrapped with `《》`
    if (title.startsWith('《')) title = title.substring(1);
    if (title.endsWith('》')) title = title.substring(0, title.length - 1);

    title = title.replaceFirst(userCotentLocator, '');

    title = title.replaceAll(_punctionsRm, '');
    title = title.replaceAll('\n', ' ');

    if (title.length > _maxLen) {
      title = title.substring(0, _maxLen);
    }

    final claudeMatch = claudeEndReg.firstMatch(title);
    if (claudeMatch != null) {
      title = title.substring(0, claudeMatch.start);
    }

    return title;
  }

  /// Get the suitable model for generating title.
  static String? get pickSuitableModel {
    final cfgPromptModel = Cfg.current.genTitleModel;
    if (cfgPromptModel != null && cfgPromptModel.isNotEmpty) {
      return cfgPromptModel;
    }

    // Auto select
    final models = Cfg.models.value;
    if (models == null || models.isEmpty) return null;

    const preferedModels = [
      'deepseek-chat',
      'deepseek-v3',
      'gpt-4o-mini',
      'claude-3.5-sonnet',
      'claude-3-5-sonnet',
      'gemini-2.0-flash',
      'gpt-3.5-turbo',
    ];

    for (final pModel in preferedModels) {
      for (final model in models) {
        // Some third-party reverse api providers names the model with a prefix...
        if (model.contains(pModel)) return model;
      }
    }

    return Cfg.current.model;
  }
}
