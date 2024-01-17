import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_chatgpt/core/ext/string.dart';

/// Platforms.
enum Pfs {
  android,
  ios,
  linux,
  macos,
  windows,
  web,
  fuchsia,
  unknown;

  static final type = () {
    if (kIsWeb) {
      return Pfs.web;
    }
    if (Platform.isAndroid) {
      return Pfs.android;
    }
    if (Platform.isIOS) {
      return Pfs.ios;
    }
    if (Platform.isLinux) {
      return Pfs.linux;
    }
    if (Platform.isMacOS) {
      return Pfs.macos;
    }
    if (Platform.isWindows) {
      return Pfs.windows;
    }
    if (Platform.isFuchsia) {
      return Pfs.fuchsia;
    }
    return Pfs.unknown;
  }();

  @override
  String toString() => switch (this) {
        Pfs.macos => 'macOS',
        Pfs.ios => 'iOS',
        final val => val.name.upperFirst,
      };

  /// Whether has platform specific settings.
  static final hasSpecSetting = switch (type) {
    Pfs.android || Pfs.ios => true,
    _ => false,
  };

  /// Whether need to check update file.
  static final needCheckFile = switch (type) {
    Pfs.android || Pfs.windows || Pfs.linux => true,
    _ => false,
  };
}

final isAndroid = Pfs.type == Pfs.android;
final isIOS = Pfs.type == Pfs.ios;
final isLinux = Pfs.type == Pfs.linux;
final isMacOS = Pfs.type == Pfs.macos;
final isWindows = Pfs.type == Pfs.windows;
final isWeb = Pfs.type == Pfs.web;
final isMobile = Pfs.type == Pfs.ios || Pfs.type == Pfs.android;
final isDesktop =
    Pfs.type == Pfs.linux || Pfs.type == Pfs.macos || Pfs.type == Pfs.windows;
