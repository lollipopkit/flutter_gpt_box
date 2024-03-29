import 'package:flutter/material.dart';

extension String2Locale on String {
  Locale? get toLocale {
    // Issue #151
    if (isEmpty) {
      return null;
    }
    final parts = split('_');
    if (parts.length == 1) {
      return Locale(parts[0]);
    }
    return Locale(parts[0], parts[1]);
  }
}
