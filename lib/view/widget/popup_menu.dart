import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';

class PopupMenu<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> items;
  final void Function(T) onSelected;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final T? initialValue;
  final String? tooltip;

  const PopupMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.child = UIs.popMenuChild,
    this.padding = const EdgeInsets.all(7),
    this.initialValue,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      itemBuilder: (_) => items,
      onSelected: onSelected,
      initialValue: initialValue,
      padding: padding,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tooltip: tooltip,
      child: child,
    );
  }
}
