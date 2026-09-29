import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/util/url.dart';

void main() {
  group('AppLink', () {
    test('scheme is lpkt.cn', () {
      expect(AppLink.scheme, 'lpkt.cn');
    });

    test('host is gptbox', () {
      expect(AppLink.host, 'gptbox');
    });

    test('prefix combines scheme and host', () {
      expect(AppLink.prefix, 'lpkt.cn://gptbox');
    });

    test('path constants are correct', () {
      expect(AppLink.newChatPath, '/new');
      expect(AppLink.openChatPath, '/open');
      expect(AppLink.searchPath, '/search');
      expect(AppLink.shareChatPath, '/share');
      expect(AppLink.goPath, '/go');
      expect(AppLink.setPath, '/set');
      expect(AppLink.profilePath, '/profile');
    });

    test('prefix + path forms valid URL', () {
      expect(
        '${AppLink.prefix}${AppLink.newChatPath}',
        'lpkt.cn://gptbox/new',
      );
      expect(
        '${AppLink.prefix}${AppLink.profilePath}',
        'lpkt.cn://gptbox/profile',
      );
    });
  });

  group('UrlType', () {
    test('fromString returns http for http URLs', () {
      expect(UrlType.from('http://example.com'), UrlType.http);
      expect(UrlType.from('https://example.com/path'), UrlType.http);
    });

    test('fromString returns base64 for data URLs', () {
      expect(UrlType.from('data:image/png;base64,abc'), UrlType.base64);
      expect(UrlType.from('data:text/plain,hello'), UrlType.base64);
    });

    test('fromString returns file for local paths', () {
      expect(UrlType.from('/path/to/file'), UrlType.file);
      expect(UrlType.from('relative/path'), UrlType.file);
    });

    test('convenience getters work', () {
      expect(UrlType.http.isHttp, true);
      expect(UrlType.http.isFile, false);
      expect(UrlType.http.isBase64, false);

      expect(UrlType.file.isFile, true);
      expect(UrlType.file.isHttp, false);

      expect(UrlType.base64.isBase64, true);
      expect(UrlType.base64.isFile, false);
    });
  });
}