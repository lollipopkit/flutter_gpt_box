import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';

/// A button's menu, Material's: it drops from the button and grows the way a
/// menu does. The rows are fl_lib's [ContextMenuAction]s, so the same list
/// serves a right click (`showContextMenu`) and a button.
class MenuBtn extends StatelessWidget {
  const MenuBtn({super.key, required this.actions, required this.builder});

  final List<ContextMenuAction> actions;

  /// The button; call the argument to open or close the menu.
  final Widget Function(VoidCallback toggle) builder;

  @override
  Widget build(BuildContext context) {
    final error = context.theme.colorScheme.error;
    return MenuAnchor(
      menuChildren: [
        for (final a in actions)
          MenuItemButton(
            leadingIcon: a.icon == null ? null : Icon(a.icon, size: 18, color: a.destructive ? error : null),
            onPressed: a.onTap,
            child: Text(a.text, style: a.destructive ? TextStyle(color: error) : null),
          ),
      ],
      builder: (_, ctrl, _) => builder(() => ctrl.isOpen ? ctrl.close() : ctrl.open()),
    );
  }
}
