part of '../tool.dart';

/// A page's readable part as Markdown: headings, paragraphs, lists, links,
/// code and tables; scripts, styles, forms and page chrome dropped.
///
/// A model reads this at a fraction of the page's tokens. Top-level, for
/// [compute]: `(html, base url)`.
String htmlToMarkdown((String, String) args) {
  final (html, base) = args;
  final doc = html_parser.parse(html);
  final baseUri = Uri.tryParse(base);
  final title = doc.querySelector('title')?.text.trim();
  final root = doc.querySelector('main') ?? doc.querySelector('article') ?? doc.body ?? doc.documentElement;
  if (root == null) return '';
  root
      .querySelectorAll(
        'script, style, noscript, template, svg, canvas, iframe, form, button, select, input, textarea, '
        'nav, footer, aside, [hidden], [aria-hidden="true"]',
      )
      .forEach((e) => e.remove());
  final out = _MdWriter(baseUri)..block(root);
  final body = out.text;
  if (title == null || title.isEmpty || body.startsWith('# ')) return body;
  return '# $title\n\n$body';
}

final class _MdWriter {
  _MdWriter(this.base);

  final Uri? base;
  final _b = StringBuffer();

  String get text => _b.toString().replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();

  static const _blocks = {
    'p', 'div', 'section', 'article', 'main', 'header', 'figure', 'figcaption', 'blockquote', 'dl', 'dt', 'dd',
    'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'ul', 'ol', 'li', 'pre', 'table', 'tr', 'hr', 'br', 'body', 'html',
  };

  void block(dom.Node node, {String indent = ''}) {
    for (final n in node.nodes) {
      if (n is dom.Text) {
        _inlineText(n.text);
        continue;
      }
      if (n is! dom.Element) continue;
      final tag = n.localName;
      switch (tag) {
        case 'h1' || 'h2' || 'h3' || 'h4' || 'h5' || 'h6':
          _para('${'#' * int.parse(tag!.substring(1))} ${_inline(n)}');
        case 'p' || 'figcaption' || 'dt' || 'dd':
          _para(_inline(n));
        case 'blockquote':
          final inner = (_MdWriter(base)..block(n)).text;
          _para(inner.split('\n').map((l) => '> $l').join('\n'));
        case 'pre':
          final lang = n.querySelector('code')?.className.replaceFirst(RegExp(r'^.*language-'), '').split(' ').first;
          _para('```${lang ?? ''}\n${n.text.trimRight()}\n```');
        case 'ul' || 'ol':
          var i = 0;
          final lines = <String>[];
          for (final li in n.children.where((c) => c.localName == 'li')) {
            i++;
            final marker = tag == 'ol' ? '$i.' : '-';
            final inner = (_MdWriter(base)..block(li, indent: '$indent  ')).text;
            final parts = inner.split('\n');
            lines.add('$indent$marker ${parts.first}');
            lines.addAll(parts.skip(1).where((l) => l.trim().isNotEmpty).map((l) => '$indent  $l'));
          }
          _para(lines.join('\n'));
        case 'table':
          _para(_table(n));
        case 'hr':
          _para('---');
        case 'br':
          _b.write('\n');
        default:
          if (_blocks.contains(tag) || n.children.any((c) => _blocks.contains(c.localName))) {
            _b.write('\n');
            block(n, indent: indent);
            _b.write('\n');
          } else {
            _b.write(_inlineOne(n));
          }
      }
    }
  }

  void _para(String s) {
    if (s.trim().isEmpty) return;
    _b
      ..write('\n\n')
      ..write(s)
      ..write('\n\n');
  }

  void _inlineText(String s) {
    final t = s.replaceAll(RegExp(r'\s+'), ' ');
    if (t.trim().isEmpty && (_b.isEmpty || _b.toString().endsWith('\n'))) return;
    _b.write(t);
  }

  /// [node]'s children, inline.
  String _inline(dom.Node node) {
    final sb = StringBuffer();
    for (final n in node.nodes) {
      if (n is dom.Text) {
        sb.write(n.text.replaceAll(RegExp(r'\s+'), ' '));
      } else if (n is dom.Element) {
        sb.write(_inlineOne(n));
      }
    }
    return sb.toString().replaceAll(RegExp(r' {2,}'), ' ').trim();
  }

  /// [n] itself, inline.
  String _inlineOne(dom.Element n) {
    final inner = _inline(n);
    return switch (n.localName) {
      'a' => switch (_url(n.attributes['href'])) {
        final href? when inner.isNotEmpty => '[$inner]($href)',
        _ => inner,
      },
      'strong' || 'b' => inner.isEmpty ? '' : '**$inner**',
      'em' || 'i' => inner.isEmpty ? '' : '*$inner*',
      'code' => inner.isEmpty ? '' : '`${n.text}`',
      'br' => '\n',
      'img' => switch (n.attributes['alt']?.trim()) {
        final alt? when alt.isNotEmpty => '[image: $alt]',
        _ => '',
      },
      _ => inner,
    };
  }

  String? _url(String? href) {
    if (href == null || href.isEmpty || href.startsWith('#') || href.startsWith('javascript:')) return null;
    final u = Uri.tryParse(href);
    if (u == null) return null;
    return (base?.resolveUri(u) ?? u).toString();
  }

  String _table(dom.Element t) {
    final rows = [
      for (final tr in t.querySelectorAll('tr'))
        [for (final c in tr.children.where((c) => c.localName == 'td' || c.localName == 'th')) _inline(c).replaceAll('|', r'\|')],
    ].where((r) => r.isNotEmpty).toList();
    if (rows.isEmpty) return '';
    final width = rows.map((r) => r.length).reduce((a, b) => a > b ? a : b);
    String line(List<String> r) => '| ${[...r, for (var i = r.length; i < width; i++) ''].join(' | ')} |';
    return [line(rows.first), '|${List.filled(width, ' --- ').join('|')}|', ...rows.skip(1).map(line)].join('\n');
  }
}
