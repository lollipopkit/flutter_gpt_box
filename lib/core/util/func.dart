import 'dart:async';

abstract final class Funcs {
  static const int _defaultDurationTime = 377;
  static const String _defaultThrottleId = 'default';
  static final Map<String, int> startTimeMap = <String, int>{};

  static Future<void> throttle(
    FutureOr Function() func, {
    String id = _defaultThrottleId,
    int duration = _defaultDurationTime,
    FutureOr Function()? onIgnore,
  }) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - (startTimeMap[id] ?? 0) > duration) {
      startTimeMap[id] = DateTime.now().millisecondsSinceEpoch;
      await func();
    } else {
      onIgnore?.call();
    }
  }
}
