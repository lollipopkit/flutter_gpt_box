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
