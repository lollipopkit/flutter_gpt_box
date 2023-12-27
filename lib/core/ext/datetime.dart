extension DatetimeX on DateTime {
  /// eg: 1 min ago, 2 days ago
  String get toHuman {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inDays > 0) {
      return '${diff.inDays} days ago';
    }

    if (diff.inHours > 0) {
      return '${diff.inHours} hours ago';
    }

    if (diff.inMinutes > 0) {
      return '${diff.inMinutes} mins ago';
    }

    // if (diff.inSeconds > 0) {
    //   return '${diff.inSeconds} secs ago';
    // }

    return 'just now';
  }

  int get toUnix => millisecondsSinceEpoch;
}