abstract final class AppLink {
  static const scheme = 'lollipopkit.com';
  static const host = 'gptbox';

  /// lollipopkit.com://gptbox
  static const prefix = '$scheme://$host';

  /// `?msg=...&send=true`
  static const newChatPath = '/new';

  /// `?chatId=...` or `?title=...`
  static const openChatPath = '/open';

  /// `?keyword=...`
  static const searchPath = '/search';

  /// `?chatId=...`
  static const shareChatPath = '/share';

  /// `?page=settings|providers|tools|backup|about`
  static const goPath = '/go';

  /// `?name=...&api=...&baseUrl=...` — asks before adding it; never a key.
  static const providerPath = '/provider';
}

enum UrlType {
  file,
  http,
  base64,
  ;

  static UrlType from(String url) {
    if (url.startsWith('http')) {
      return UrlType.http;
    }
    if (url.startsWith('data:')) {
      return UrlType.base64;
    }
    return UrlType.file;
  }

  bool get isFile => this == UrlType.file;
  bool get isHttp => this == UrlType.http;
  bool get isBase64 => this == UrlType.base64;
}
