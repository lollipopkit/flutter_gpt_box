import 'package:flutter/material.dart';

extension SnackBarX on BuildContext {
  void showSnackBar(String text, {EdgeInsetsGeometry? margin}) =>
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        margin: margin,
      ));

  void showSnackBarWithAction({
    required String content,
    required String action,
    required GestureTapCallback onTap,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(content),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: action,
        onPressed: onTap,
      ),
    ));
  }
}
