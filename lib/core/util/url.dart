abstract final class AppLink {
  static const scheme = 'lollipopkit.com';
  static const host = 'gptbox';

  /// lollipopkit.com://gptbox
  static const prefix = '$scheme://$host';

  /// `?msg=...&send=true`
  static const newChatPath = '/new';

  /// `?chatId=...` or `?title=...`
  static const openChatPath = '/open';

  /// Opens the chat search.
  static const searchPath = '/search';

  /// `?chatId=...`
  static const shareChatPath = '/share';

  /// `?page=settings|providers|tools|backup|about`
  static const goPath = '/go';

  /// `?name=...&api=...&baseUrl=...` — asks before adding it; never a key.
  static const providerPath = '/provider';
}
