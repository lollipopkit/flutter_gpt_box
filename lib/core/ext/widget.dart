import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/util/func.dart';
import 'package:flutter_chatgpt/view/widget/card.dart';

extension WidgetX on Widget {
  Widget tap({
    VoidCallback? onTap,
    bool disable = false,
    VoidCallback? onLongTap,
    VoidCallback? onDoubleTap,
    bool clip = true,
  }) {
    if (disable) return this;

    final child = InkWell(
      onTap: onTap == null ? null : () => Funcs.throttle(onTap),
      onLongPress: onLongTap,
      onDoubleTap: onDoubleTap,
      child: this,
    );
    if (!clip) return child;

    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }

  Widget get card => CardX(child: this);
}
