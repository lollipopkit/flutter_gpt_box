import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  void popUntil(RoutePredicate predicate) {
    Navigator.of(this).popUntil(predicate);
  }

  bool get canPop => Navigator.of(this).canPop();

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Locale get locale => Localizations.localeOf(this);

  String get localeMainName => locale.languageCode;
}
