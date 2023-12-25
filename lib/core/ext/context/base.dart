import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef RiverpodCtx = ({BuildContext context, WidgetRef ref});

mixin RiverpodCtxMixin on ConsumerWidget {
  late final RiverpodCtx ctx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ctx = (context: context, ref: ref);
    return super.build(context, ref);
  }
}

extension ContextX on BuildContext {
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  void popUntil(RoutePredicate predicate) {
    Navigator.of(this).popUntil(predicate);
  }

  bool get canPop => Navigator.of(this).canPop();

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
