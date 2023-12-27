import 'package:flutter/material.dart';

final class DynColor {
  final Color light;
  final Color dark;

  const DynColor({required this.light, required this.dark});

  Color fromBool(bool isDark) => isDark ? dark : light;

  Color fromBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  Color resolve(BuildContext context) =>
      fromBrightness(Theme.of(context).brightness);
}
