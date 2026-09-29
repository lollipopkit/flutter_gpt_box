import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:gpt_box/view/widget/section_list.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:markdown/markdown.dart' as md;

final _textStyle = Mono.style(fontSize: 12.5, height: 1.6);

class CodeElementBuilder extends MarkdownElementBuilder {
  /// On copy callback.
  final void Function(String)? onCopy;

  /// Whether the view is for capture.
  final bool isForCapture;

  CodeElementBuilder({this.onCopy, this.isForCapture = false});

  /// Code inside a sentence: mono on a tinted ground.
  static TextStyle inlineStyle(BuildContext context) =>
      Mono.style(fontSize: 12.5).copyWith(backgroundColor: context.theme.colorScheme.surfaceContainerHigh);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final cls = element.attributes['class'];
    final language = cls != null && cls.startsWith('language-') ? cls.substring(9) : '';
    final textContent = element.textContent.trimRight();
    // Inline code is the style sheet's; a block has a language or lines.
    if (language.isEmpty && !textContent.contains('\n')) return null;
    return _CodeBlock(code: textContent, language: language, onCopy: isForCapture ? null : onCopy, theme: _theme);
  }

  Map<String, TextStyle> get _theme {
    return RNodes.dark.value ? _darkTheme : _lightTheme;
  }
}

/// A fenced block: its language and a copy button over the code.
class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code, required this.language, required this.onCopy, required this.theme});

  final String code;
  final String language;
  final void Function(String)? onCopy;
  final Map<String, TextStyle> theme;

  @override
  Widget build(BuildContext context) {
    final view = HighlightView(
      code,
      language: language.isEmpty ? 'plaintext' : language,
      theme: theme,
      textStyle: _textStyle,
      tabSize: 4,
      padding: EdgeInsets.zero,
    );
    final body = Stores.setting.softWrap.listenable().listenVal((wrap) {
      if (wrap) return view;
      return SingleChildScrollView(scrollDirection: Axis.horizontal, child: view);
    });
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 2, 2, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(language, style: Mono.style(fontSize: 11, color: UIs.textGrey.color)),
                ),
                if (onCopy case final copy?)
                  Btn.icon(icon: const Icon(Icons.content_copy, size: 17), text: libL10n.copy, onTap: () => copy(code))
                else
                  const SizedBox(height: 31),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.fromLTRB(13, 0, 13, 13), child: body),
        ],
      ),
    );
  }
}

const _darkTheme = {
  'comment': TextStyle(color: Color(0xffd4d0ab)),
  'quote': TextStyle(color: Color(0xffd4d0ab)),
  'variable': TextStyle(color: Color(0xffffa07a)),
  'template-variable': TextStyle(color: Color(0xffffa07a)),
  'tag': TextStyle(color: Color(0xffffa07a)),
  'name': TextStyle(color: Color(0xffffa07a)),
  'selector-id': TextStyle(color: Color(0xffffa07a)),
  'selector-class': TextStyle(color: Color(0xffffa07a)),
  'regexp': TextStyle(color: Color(0xffffa07a)),
  'deletion': TextStyle(color: Color(0xffffa07a)),
  'number': TextStyle(color: Color(0xfff5ab35)),
  'built_in': TextStyle(color: Color(0xfff5ab35)),
  'builtin-name': TextStyle(color: Color(0xfff5ab35)),
  'literal': TextStyle(color: Color(0xfff5ab35)),
  'type': TextStyle(color: Color(0xfff5ab35)),
  'params': TextStyle(color: Color(0xfff5ab35)),
  'meta': TextStyle(color: Color(0xfff5ab35)),
  'link': TextStyle(color: Color(0xfff5ab35)),
  'attribute': TextStyle(color: Color(0xffffd700)),
  'string': TextStyle(color: Color(0xffabe338)),
  'symbol': TextStyle(color: Color(0xffabe338)),
  'bullet': TextStyle(color: Color(0xffabe338)),
  'addition': TextStyle(color: Color(0xffabe338)),
  'title': TextStyle(color: Color(0xff00e0e0)),
  'section': TextStyle(color: Color(0xff00e0e0)),
  'keyword': TextStyle(color: Color(0xffdcc6e0)),
  'selector-tag': TextStyle(color: Color(0xffdcc6e0)),
  'root': TextStyle(
    backgroundColor: Colors.transparent,
    color: Color.fromARGB(255, 184, 184, 181),
  ),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'strong': TextStyle(fontWeight: FontWeight.bold),
};

const _lightTheme = {
  'comment': TextStyle(color: Color(0xff696969)),
  'quote': TextStyle(color: Color(0xff696969)),
  'variable': TextStyle(color: Color(0xffd91e18)),
  'template-variable': TextStyle(color: Color(0xffd91e18)),
  'tag': TextStyle(color: Color(0xffd91e18)),
  'name': TextStyle(color: Color(0xffd91e18)),
  'selector-id': TextStyle(color: Color(0xffd91e18)),
  'selector-class': TextStyle(color: Color(0xffd91e18)),
  'regexp': TextStyle(color: Color(0xffd91e18)),
  'deletion': TextStyle(color: Color(0xffd91e18)),
  'number': TextStyle(color: Color(0xffaa5d00)),
  'built_in': TextStyle(color: Color(0xffaa5d00)),
  'builtin-name': TextStyle(color: Color(0xffaa5d00)),
  'literal': TextStyle(color: Color(0xffaa5d00)),
  'type': TextStyle(color: Color(0xffaa5d00)),
  'params': TextStyle(color: Color(0xffaa5d00)),
  'meta': TextStyle(color: Color(0xffaa5d00)),
  'link': TextStyle(color: Color(0xffaa5d00)),
  'attribute': TextStyle(color: Color(0xffaa5d00)),
  'string': TextStyle(color: Color(0xff008000)),
  'symbol': TextStyle(color: Color(0xff008000)),
  'bullet': TextStyle(color: Color(0xff008000)),
  'addition': TextStyle(color: Color(0xff008000)),
  'title': TextStyle(color: Color(0xff007faa)),
  'section': TextStyle(color: Color(0xff007faa)),
  'keyword': TextStyle(color: Color(0xff7928a1)),
  'selector-tag': TextStyle(color: Color(0xff7928a1)),
  'root': TextStyle(
    backgroundColor: Colors.transparent,
    color: Color(0xff545454),
  ),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'strong': TextStyle(fontWeight: FontWeight.bold),
};
