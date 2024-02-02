import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/widget.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as md;

final _textStyle = GoogleFonts.robotoMono();

class CodeElementBuilder extends MarkdownElementBuilder {
  final void Function(String)? onCopy;
  final bool isForCapture;

  CodeElementBuilder({this.onCopy, this.isForCapture = false});

  static bool isDark = false;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    // Can't be null
    String language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }

    final textContent = element.textContent.trim();
    if (language.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(37, 158, 158, 158),
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: ValueListenableBuilder(
          valueListenable: Stores.setting.fontSize.listenable(),
          builder: (_, val, __) => Text(
            textContent,
            style: _textStyle.copyWith(fontSize: val),
          ),
        ),
      );
    }

    if (language == 'latex') {
      /// The following control sequence is unsupported:
      /// - \documentclass
      /// - \title
      /// - \author
      /// - \begin
      /// - more...
      /// If [textContent] contains any of the above, it will be rendered as
      /// plain text.
      final isUnsupported = textContent.contains(r'\documentclass') ||
          textContent.contains(r'\title') ||
          textContent.contains(r'\author') ||
          textContent.contains(r'\begin');
      if (!isUnsupported) {
        final String? displayMode = element.attributes['displayMode'];
        return Math.tex(
          textContent,
          mathStyle: displayMode == 'true' ? MathStyle.display : MathStyle.text,
        );
      }
    }

    if (isForCapture) {
      return HighlightViewSync(
        textContent,
        language: language,
        theme: _theme,
        textStyle: _textStyle,
        tabSize: 4,
        softWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
      );
    }

    final isMultiLine = textContent.contains('\n');
    return ValueListenableBuilder(
      valueListenable: Stores.setting.fontSize.listenable(),
      builder: (_, fontSize, __) => isMultiLine
          ? HighlightViewSync(
              textContent,
              key: ValueKey(textContent),
              language: language,
              theme: _theme,
              textStyle: _textStyle.copyWith(fontSize: fontSize),
              tabSize: 4,
              softWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
            )
          : HighlightViewSync(
              textContent,
              key: ValueKey(textContent),
              language: language,
              theme: _theme,
              textStyle: _textStyle.copyWith(fontSize: fontSize),
              tabSize: 4,
              softWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            ),
    ).tap(onLongTap: () => onCopy?.call(textContent));
  }

  Map<String, TextStyle> get _theme {
    return isDark ? _darkTheme : _lightTheme;
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
