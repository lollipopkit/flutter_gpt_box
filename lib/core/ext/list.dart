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