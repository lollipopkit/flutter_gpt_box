extension ObjX<T> on T {
  List<T> get asList => [this];

  T? nullOrSelf(bool cond) => cond ? this : null;
}
