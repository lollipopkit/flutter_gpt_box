import 'package:url_launcher/url_launcher_string.dart';

abstract final class MarkdownUtils {
  static void onLinkTap(String? text, String? href, String title) {
    if (href == null) return;
    launchUrlString(href);
  }
}
