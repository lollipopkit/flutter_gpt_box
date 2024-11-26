abstract final class AppLink {
  /// lpkt.cn
  static const scheme = 'lpkt.cn';
  static const host = 'gptbox';

  /// lpkt.cn://gptbox
  static const prefix = '$scheme://$host';

  static const newChatPath = '/new';
  static const openChatPath = '/open';
  static const searchPath = '/search';
  static const shareChatPath = '/share';
  static const goPath = '/go';
  static const setPath = '/set';
  static const profilePath = '/profile';
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
