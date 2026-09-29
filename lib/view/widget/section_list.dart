import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';

/// Sections of a page in one scrollable list, each under its own heading.
///
/// Replaces fl_lib's removed `MultiList`: its columns were sections, and each
/// scrolled on its own. Capped in width so a wide desktop window does not
/// stretch a row of settings across the whole screen.
final class SectionList extends StatelessWidget {
  const SectionList({super.key, required this.children, this.maxWidth = 720});

  /// Each section, heading included.
  final List<Widget> children;

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ListView(
          padding: UIs.roundRectCardPadding,
          children: children,
        ),
      ),
    );
  }
}
