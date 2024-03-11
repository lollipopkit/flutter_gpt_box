import 'package:flutter/foundation.dart';

extension ValueNotifierX<T> on T {
  ValueNotifier<T> get vn => ValueNotifier<T>(this);
}
