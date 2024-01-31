import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';

abstract final class Btns {
  /// - [onTap] If return false, the dialog will not be closed.
  static TextButton ok<T>({
    bool red = false,
    Function? onTap,
  }) {
    return TextButton(
      onPressed: () => onTap?.call(),
      child: Text(l10n.ok, style: red ? UIs.textRed : null),
    );
  }

  static TextButton cancel<T>({
    T? pop,
    Function? onPressed,
  }) {
    return TextButton(
      onPressed: () => onPressed?.call(),
      child: Text(l10n.cancel),
    );
  }

  static List<TextButton> oks<T>({
    bool red = false,
    Function? onTap,
  }) {
    return [ok(red: red, onTap: onTap)];
  }
}
