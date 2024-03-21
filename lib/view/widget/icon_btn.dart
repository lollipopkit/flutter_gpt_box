import 'package:flutter/material.dart';

final class IconBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final void Function() onTap;
  final String? tooltip;

  const IconBtn({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 17,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final child = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: size, color: color),
      ),
    );
    if (tooltip == null) return child;
    return Tooltip(
      message: tooltip!,
      child: child,
    );
  }
}
