/// Make these class private, so that we can only use [Routes] to navigate.

part of 'page.dart';

typedef _PageBuilder<Args> = Widget Function({Key? key, Args? args});

typedef MiddlewareArgs = ({BuildContext context, AppRoute route});

/// If [Middleware] returns false, the navigation will be canceled.
typedef Middleware<T> = bool Function(MiddlewareArgs);

class AppRoute<Ret, Arg> {
  // ignore: library_private_types_in_public_api
  final _PageBuilder<Arg> page;
  final List<Middleware<Arg>>? middlewares;
  final String path;

  const AppRoute({
    required this.page,
    required this.path,
    this.middlewares,
  });

  Future<Ret?>? go(BuildContext context, {Key? key, Arg? args}) {
    /// Add global middlewares here.
    Analysis.recordView(path);

    final ret = middlewares?.any((e) => !e((context: context, route: this)));
    if (ret == true) return null;

    return Navigator.push<Ret>(
      context,
      MaterialPageRoute(builder: (context) => page(key: key, args: args)),
    );
  }
}
