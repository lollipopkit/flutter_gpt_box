import 'package:flutter/material.dart';

const _shape = Border();

class ExpandTile extends ExpansionTile {
  const ExpandTile({
    super.key,
    super.leading,
    required super.title,
    super.children,
    super.subtitle,
    super.initiallyExpanded,
    super.tilePadding,
    super.childrenPadding,
    super.trailing,
    super.controller,
    Alignment? align = Alignment.centerLeft,
  }) : super(shape: _shape, collapsedShape: _shape, expandedAlignment: align);
}
