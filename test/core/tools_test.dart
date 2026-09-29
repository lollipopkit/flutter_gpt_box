import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';
import 'package:gpt_box/data/store/all.dart';

void main() {
  group('html to markdown', () {
    test('keeps the readable part, drops the chrome', () {
      const html = '''
<html><head><title>T</title><style>x{}</style></head><body>
<nav><a href="/">Home</a></nav>
<main>
  <h1>Hello</h1>
  <p>Some <b>bold</b> and a <a href="/docs?a=1">link</a>.</p>
  <script>alert(1)</script>
  <ul><li>one</li><li>two <code>x</code></li></ul>
  <pre><code class="language-dart">void main() {}</code></pre>
  <table><tr><th>a</th><th>b</th></tr><tr><td>1</td><td>2</td></tr></table>
</main>
<footer>© x</footer>
</body></html>''';
      final md = htmlToMarkdown((html, 'https://example.com/page'));
      expect(md, startsWith('# Hello'));
      expect(md, contains('Some **bold** and a [link](https://example.com/docs?a=1).'));
      expect(md, contains('- one\n- two `x`'));
      expect(md, contains('```dart\nvoid main() {}\n```'));
      expect(md, contains('| a | b |\n| --- | --- |\n| 1 | 2 |'));
      for (final gone in ['alert', 'Home', '©', 'x{}']) {
        expect(md, isNot(contains(gone)), reason: gone);
      }
    });

    test('adds the title when the page has no heading', () {
      expect(htmlToMarkdown(('<title>T</title><p>x</p>', 'https://a.b')), '# T\n\nx');
    });
  });

  group('fetch', () {
    late HttpServer server;
    late String base;

    setUpAll(() async {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      base = 'http://127.0.0.1:${server.port}';
      server.listen((req) async {
        final r = req.response;
        switch (req.uri.path) {
          case '/page':
            r.headers.contentType = ContentType.html;
            r.write('<title>P</title><p>${'word ' * 100}</p>');
          case '/json':
            r.headers.contentType = ContentType.json;
            r.write(jsonEncode({'ok': true}));
          case '/img':
            r.headers.contentType = ContentType('image', 'png');
            r.add([0x89, 0x50, 0x4e, 0x47]);
          case '/bin':
            r.headers.contentType = ContentType.binary;
            r.add([0, 1, 2]);
          default:
            r.statusCode = 404;
        }
        await r.close();
      });
    });
    tearDownAll(() => server.close(force: true));

    Future<LlmToolResult> fetch(Map<String, Object?> args) =>
        TfHttpReq.instance.run(args, ToolCtx('c', LlmCancelToken()));
    String textOf(LlmToolResult r) => r.content.map((e) => e['text'] ?? '').join('\n');

    test('a page as Markdown, paged', () async {
      final r = await fetch({'url': '$base/page', 'max_length': 50});
      final t = textOf(r);
      expect(t, startsWith('HTTP 200 OK · text/html · $base/page'));
      expect(t, contains('# P\n\nword word'));
      expect(t, contains('call again with start_index 50'));
      final next = textOf(await fetch({'url': '$base/page', 'start_index': 50, 'max_length': 10}));
      expect(next, contains('Showing characters 50–60'));
    });

    test('raw HTML when asked, JSON as it is, the status kept', () async {
      expect(textOf(await fetch({'url': '$base/page', 'raw': true})), contains('<title>P</title>'));
      expect(textOf(await fetch({'url': '$base/json'})), contains('{"ok":true}'));
      final missing = await fetch({'url': '$base/nope'});
      expect((missing.details as Map)['status'], 404);
    });

    test('an image as an image; other binaries not at all', () async {
      final img = await fetch({'url': '$base/img'});
      expect(img.content.last['type'], 'image');
      expect(textOf(await fetch({'url': '$base/bin'})), contains('Binary content, 3 bytes'));
    });

    test('only http(s)', () async {
      for (final u in ['file:///etc/passwd', 'ftp://x', 'nope']) {
        await expectLater(fetch({'url': u}), throwsArgumentError, reason: u);
      }
    });
  });

  group('switches', () {
    setUp(() async {
      SqliteDb.openInMemory();
      await Stores.init();
      Stores.mcp.enabled.set(true);
    });
    tearDown(() => SqliteDb.close());

    List<String> names() => [for (final t in Tools.enabled) t.name];

    test('chat history is off until turned on; one switch per group', () {
      expect(names(), isNot(contains('chat_search')));
      Tools.setOn(TfChatSearch.instance, true);
      expect(names(), containsAll(['chat_search', 'chat_read']));
      Tools.setOn(TfHttpReq.instance, false);
      expect(names(), isNot(contains('httpReq')));
      expect(Tools.groups.map((t) => t.group), ['memory', 'history', 'httpReq']);
    });
  });

  test('MCP tool names fit providers', () {
    final long = McpTools.toolName('mcp12345678', 'a' * 80);
    expect(long.length, 64);
    expect(McpTools.toolName('mcp12345678', 'a' * 80), long);
    expect(McpTools.toolName('mcp12345678', 'x.y'), 'mcp12345678__x_y');
  });
}
