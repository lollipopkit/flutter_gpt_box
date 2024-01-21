import 'package:flutter/material.dart';

const _wideThreshold = 0.9;

extension MediaQueryX on MediaQueryData? {
  bool get isWide {
    final width = this?.size.width;
    final height = this?.size.height;
    // Mobile first
    if (width == null || height == null) return false;
    final ratio = width / height;
    return ratio > _wideThreshold;
  }
}
