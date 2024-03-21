import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:markdown/markdown.dart' as md;

abstract final class MarkdownUtils {
  static void onLinkTap(String? text, String? href, String title) {
    if (href == null) return;
    launchUrlString(href);
  }

  static final extensionSet = md.ExtensionSet(
    [
      LatexBlockSyntax(),
      ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
    ],
    [
      LatexInlineSyntax(),
      md.EmojiSyntax(),
      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
    ],
  );

  static final extensionSetWithoutCode = md.ExtensionSet(
    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
    [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
  );
}
