import 'package:flutter/material.dart';
import 'package:gpt_box/data/res/ui.dart';

class FutureWidget<T> extends StatefulWidget {
  final Future<T> future;
  final Widget loading;
  final Widget Function(Object? error, StackTrace? trace) error;
  final Widget Function(T? data) success;
  final Widget Function(AsyncSnapshot<Object?> snapshot)? active;
  final bool cacheWidget;

  const FutureWidget({
    super.key,
    required this.future,
    this.loading = UIs.placeholder,
    required this.error,
    required this.success,
    this.active,
    this.cacheWidget = true,
  });

  @override
  State<FutureWidget<T>> createState() => _FutureWidgetState<T>();
}

class _FutureWidgetState<T> extends State<FutureWidget<T>> {
  Widget? _cache;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.error(snapshot.error, snapshot.stackTrace);
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            if (widget.cacheWidget && _cache != null) return _cache!;
            return widget.loading;
          case ConnectionState.active:
            if (widget.active != null) {
              return widget.active!(snapshot);
            }
            if (widget.cacheWidget && _cache != null) return _cache!;
            return widget.loading;
          case ConnectionState.done:
            final suc = widget.success(snapshot.data);
            if (widget.cacheWidget) _cache = suc;
            return suc;
        }
      },
    );
  }
}
