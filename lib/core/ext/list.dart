import 'package:flutter/widgets.dart';

extension ListX<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) {
        return e;
      }
    }
    return null;
  }
}

extension ListWidget on Iterable<Widget> {
  List<Widget> joinWith(Widget separator) {
    final list = toList();
    final result = <Widget>[];
    for (var i = 0; i < length; i++) {
      if (i > 0) {
        result.add(separator);
      }
      result.add(list[i]);
    }
    return result;
  }
}
