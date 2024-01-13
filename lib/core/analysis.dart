import 'dart:async';

import 'package:countly_flutter/countly_flutter.dart';
import 'package:flutter_chatgpt/core/build_mode.dart';
import 'package:flutter_chatgpt/core/util/platform/base.dart';

class Analysis {
  static const _url = 'https://countly.xuty.cc';
  static const _key = '6344c39659b1dcca4f1fc8692399bfc1021f69fd';

  static bool enabled = false;

  static Future<void> init() async {
    if (!BuildMode.isRelease) {
      return;
    }
    if (isAndroid || isIOS) {
      enabled = true;
      final config = CountlyConfig(_url, _key)
          .setLoggingEnabled(false)
          .enableCrashReporting();
      await Countly.initWithConfig(config);
      await Countly.giveAllConsent();
    }
  }

  static void recordView(String view) {
    if (enabled) {
      Countly.instance.views.startView(view);
    }
  }

  static void recordException(Object exception, [bool fatal = false]) {
    if (enabled) {
      Countly.logException(exception.toString(), !fatal, null);
    }
  }
}
