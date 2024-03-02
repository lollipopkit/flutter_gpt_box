part of 'page.dart';

/// Define it as a named record, makes it easier for refactor.
typedef MiddlewareArg<Ret, Arg> = ({
  BuildContext context,
  AppRoute<Ret, Arg> route
});

class AppRoute<Ret, Arg> {
  final Widget Function({Key? key, Arg? args}) page;

  /// If [middlewares] returns false, the navigation will be canceled.
  final List<bool Function(MiddlewareArg<Ret, Arg>)>? middlewares;
  final String path;

  const AppRoute({
    required this.page,
    required this.path,
    this.middlewares,
  });

  Future<Ret?> go(BuildContext context, {Key? key, Arg? args}) {
    /// Add global middlewares here.
    Analysis.recordView(path);

    final ret = middlewares?.any((e) => !e((context: context, route: this)));
    if (ret == true) return Future.value(null);

    return Navigator.push<Ret>(
      context,
      MaterialPageRoute(builder: (context) => page(key: key, args: args)),
    );
  }
}

// class PopTime {
//   static const none = PopTime._(0);
//   static const before = PopTime._(1 << 1);
//   static const after = PopTime._(1);
//   static const all = PopTime._(1 << 2 - 1);

//   final int val;

//   const PopTime._(this.val);

//   operator |(PopTime other) => PopTime._(val | other.val);

//   bool should(PopTime time) => time.val & PopTime.before.val != 0;
// }
