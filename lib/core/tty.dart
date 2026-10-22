import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_tty/fl_tty.dart';
import 'package:llmbox/data/res/build_data.dart';
import 'package:llmbox/data/store/all.dart';
import 'package:llmbox/data/store/setting.dart';

/// Hands fl_tty what it reads of LLMBox, and finds the Linux userland.
Future<void> initTty() async {
  FlTty.settings = const _Settings();
  // Fixed once shipped: an installed system keeps its `/etc/llmbox`.
  FlTty.brand = 'llmbox';
  FlTty.appName = BuildData.name;
  try {
    await Rootfs.prepare();
  } catch (e, s) {
    Loggers.app.warning('Failed to locate the Linux rootfs', e, s);
  }
  // Which releases are installable moves on the distributions' schedule; what
  // `prepare` adopted works until something newer verifies.
  if (Rootfs.isAvailable) {
    unawaited(
      RootfsManifestSource.refresh().then(
        (_) {},
        onError: (Object e, StackTrace s) => Loggers.app.warning('Rootfs manifest refresh failed', e, s),
      ),
    );
  }
}

final class _Settings implements FlTtySettings {
  const _Settings();

  static SettingStore get _s => Stores.setting;

  @override
  String get profile => _s.linuxProfile.get();
  @override
  set profile(String value) => _s.linuxProfile.set(value);

  @override
  String get distro => _s.linuxDistro.get();

  @override
  Map<String, String> get mirrors => _s.linuxMirrors.get();
  @override
  set mirrors(Map<String, String> value) => _s.linuxMirrors.set(value);

  @override
  String get dns => _s.linuxDns.get();

  @override
  int get manifestSerial => _s.rootfsManifestSerial.get();
  @override
  set manifestSerial(int value) => _s.rootfsManifestSerial.set(value);

  @override
  String get manifestCache => _s.rootfsManifestCache.get();
  @override
  set manifestCache(String value) => _s.rootfsManifestCache.set(value);

  @override
  String get manifestCacheSig => _s.rootfsManifestCacheSig.get();
  @override
  set manifestCacheSig(String value) => _s.rootfsManifestCacheSig.set(value);
}
