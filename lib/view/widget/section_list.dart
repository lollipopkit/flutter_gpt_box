import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';

/// A settings page: named groups in one column, 20 apart.
///
/// One column of 640 at most, centred: the settings sit beside a sidebar that
/// already names the page, so a second column would only make the eye jump.
final class SectionList extends StatelessWidget {
  const SectionList({super.key, required this.children, this.header, this.maxWidth = 640});

  /// Each group — usually a [SettingsGroup].
  final List<Widget> children;

  /// Above the groups, 17 over the first: a page's own title row.
  final Widget? header;

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 26),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header case final header?) ...[header, const SizedBox(height: 17)],
                ...children.joinWith(const SizedBox(height: 20), false),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The heading over a group: its name in small capitals, then a hairline to
/// the end of the row.
final class GroupTitle extends StatelessWidget {
  const GroupTitle(this.title, {super.key, this.padding = const EdgeInsets.fromLTRB(4, 0, 4, 2)});

  final String title;
  final EdgeInsets padding;

  static const style = TextStyle(fontSize: 11, height: 1.25, fontWeight: FontWeight.w700, letterSpacing: 0.9);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      // The name at its own width, up to 60 %, and the rule the rest: as two
      // flex children they would split the row in half.
      child: LayoutBuilder(
        builder: (context, cons) => Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: cons.maxWidth * 0.6),
              child: Text(
                title.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style.copyWith(color: UIs.textGrey.color),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(child: Container(height: Hairline.thickness, color: Hairline.color(context))),
          ],
        ),
      ),
    );
  }
}

/// One named group of settings: its [GroupTitle], and its rows in one card,
/// separated by hairlines.
final class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, this.title, this.rows = const [], this.header, this.footer});

  final String? title;
  final List<Widget> rows;

  /// Between the title and the card: a search field, a form.
  final Widget? header;

  /// Under the card: the group's actions.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final line = Container(height: Hairline.thickness, color: Hairline.color(context));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title case final title?) GroupTitle(title),
        ?header,
        if (rows.isNotEmpty)
          CardX(
            margin: EdgeInsets.zero,
            child: Column(mainAxisSize: MainAxisSize.min, children: rows.joinWith(line, false)),
          ),
        ?footer,
      ].joinWith(UIs.height7),
    );
  }
}

/// A row of a [SettingsGroup]: an icon, a title and what it says, and what it
/// ends in — a value, a switch, a chevron.
final class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.icon,
    this.leading,
    this.iconColor,
    this.subtitle,
    this.error,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.muted = false,
    this.mono = false,
  });

  final String title;
  final IconData? icon;

  /// Instead of [icon]: a state dot.
  final Widget? leading;
  final Color? iconColor;
  final String? subtitle;

  /// Why the thing the row is about does not work, under [subtitle].
  final String? error;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;

  /// A row that is less than the others: "10 more".
  final bool muted;

  /// The title is machine text: a URL, an id.
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final scheme = context.theme.colorScheme;
    final lead = leading ?? (icon == null ? null : Icon(icon, size: 24, color: iconColor ?? (muted ? UIs.textGrey.color : scheme.onSurfaceVariant)));
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        child: Row(
          children: [
            if (lead != null) SizedBox(width: 24, child: Center(child: lead)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 20 / 14,
                      fontFamily: mono ? Mono.family : null,
                      fontFamilyFallback: mono ? Mono.fallback : null,
                      color: muted ? UIs.textGrey.color : null,
                    ),
                  ),
                  if (subtitle case final s? when s.isNotEmpty)
                    Text(s, maxLines: 1, overflow: TextOverflow.ellipsis, style: _small(UIs.textGrey.color)),
                  if (error case final e? when e.isNotEmpty) Text(e, style: _small(scheme.error)),
                ].joinWith(const SizedBox(height: 1)),
              ),
            ),
            ?trailing,
          ].joinWith(UIs.width13),
        ),
      ),
    );
    return Material(
      color: selected ? scheme.secondaryContainer : Colors.transparent,
      child: InkWell(onTap: onTap, onLongPress: onLongPress, child: row),
    );
  }

  static TextStyle _small(Color? color) => TextStyle(fontSize: 12, height: 16 / 12, color: color);
}

/// What a row is set to, at its end.
final class RowValue extends StatelessWidget {
  const RowValue(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end, style: UIs.text13Grey);
}

/// A row that opens something.
final class RowChevron extends StatelessWidget {
  const RowChevron({super.key});

  @override
  Widget build(BuildContext context) => Icon(Icons.chevron_right_rounded, size: 20, color: UIs.textGrey.color);
}

/// A state dot where a row's icon goes.
final class RowDot extends StatelessWidget {
  const RowDot(this.color, {super.key});

  final Color color;

  @override
  Widget build(BuildContext context) =>
      Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

/// The state colours, fixed under any seed.
abstract final class StateColors {
  static const running = Color(0xFF22C55E);
  static const failed = Color(0xFFEF4444);
}

/// Machine text — code, URLs, a tool's arguments — in the platform's
/// monospace: SF Mono / Menlo on Apple, Consolas on Windows, whatever the
/// system calls `monospace` elsewhere. `'monospace'` alone resolves on
/// Android and Linux only.
abstract final class Mono {
  static const family = 'SF Mono';
  static const fallback = ['Menlo', 'Monaco', 'Consolas', 'Cascadia Mono', 'Roboto Mono', 'DejaVu Sans Mono', 'monospace'];

  static TextStyle style({double fontSize = 12, double? height, Color? color}) => TextStyle(
    fontFamily: family,
    fontFamilyFallback: fallback,
    fontSize: fontSize,
    height: height,
    color: color,
  );
}
