extension DatetimeX on DateTime {
  /// eg: 1 min ago, 2 days ago
  String get toAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    final days = diff.inDays;
    if (days >= 7) {
      return '${days ~/ 7} weeks ago';
    }
    if (days > 0) {
      return '$days days ago';
    }

    final hours = diff.inHours;
    if (hours >= 23) {
      return '1 day ago';
    }
    if (hours > 0) {
      return '$hours hours ago';
    }

    final minutes = diff.inMinutes;
    if (minutes >= 53) {
      return '1 hour ago';
    }
    if (minutes > 0) {
      return '$minutes mins ago';
    }

    return 'just now';
  }

  int get toUnix => millisecondsSinceEpoch;
}
