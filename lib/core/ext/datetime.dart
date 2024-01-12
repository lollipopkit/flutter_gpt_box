import 'package:flutter_chatgpt/data/res/l10n.dart';

extension DatetimeX on DateTime {
  /// eg: 1 min ago, 2 days ago
  String get toAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    final days = diff.inDays;
    if (days >= 7) {
      return l10n.weeksAgo(days ~/ 7);
    }
    if (days > 0) {
      return l10n.daysAgo(days);
    }

    final hours = diff.inHours;
    if (hours >= 23) {
      return l10n.daysAgo(1);
    }
    if (hours > 0) {
      return l10n.hoursAgo(hours);
    }

    final minutes = diff.inMinutes;
    if (minutes >= 53) {
      return l10n.hoursAgo(1);
    }
    if (minutes > 0) {
      return l10n.minutesAgo(minutes);
    }

    return l10n.justNow;
  }

  int get toUnix => millisecondsSinceEpoch;
}
