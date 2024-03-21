extension IterableX<T> on Iterable<T?> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (element != null && test(element)) {
        return element;
      }
    }
    return null;
  }

  T? lastWhereOrNull(bool Function(T) test) {
    T? result;
    for (var element in this) {
      if (element != null && test(element)) {
        result = element;
      }
    }
    return result;
  }

  Iterable<T> whereNotNull() sync* {
    for (var element in this) {
      if (element != null) {
        yield element;
      }
    }
  }

  Iterable<E> mapNotNull<E>(E Function(T) f) sync* {
    for (var element in this) {
      if (element != null) {
        yield f(element);
      }
    }
  }
}