import 'package:flutter/widgets.dart';

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
