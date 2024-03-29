import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/view/widget/choice.dart';

extension DialogX on BuildContext {
  Future<T?> showRoundDialog<T>({
    Widget? child,
    List<Widget>? actions,
    String? title,
    bool barrierDismiss = true,
    void Function(BuildContext)? onContext,
  }) async {
    return await showDialog<T>(
      context: this,
      barrierDismissible: barrierDismiss,
      builder: (_) {
        onContext?.call(_);
        return AlertDialog(
          title: title == null ? null : Text(title),
          content: child,
          actions: actions,
          actionsPadding: const EdgeInsets.all(17),
        );
      },
    );
  }

  Future<T> showLoadingDialog<T>({
    required Future<T> Function() fn,
    bool barrierDismiss = false,
  }) async {
    BuildContext? ctx;
    showRoundDialog(
      child: UIs.centerSizedLoading,
      barrierDismiss: barrierDismiss,
      onContext: (c) => ctx = c,
    );

    try {
      return await fn();
    } catch (e) {
      rethrow;
    } finally {
      /// Wait for context to be unmounted
      await Future.delayed(const Duration(milliseconds: 100));
      if (ctx?.mounted == true) {
        ctx?.pop();
      }
    }
  }

  Future<List<T>?> showPickDialog<T>({
    required List<T?> items,
    String Function(T)? name,
    bool multi = true,
    List<T>? initial,
    bool clearable = false,
    List<Widget>? actions,
  }) async {
    var vals = initial ?? <T>[];
    final sure = await showRoundDialog<bool>(
      title: l10n.choose,
      child: SingleChildScrollView(
        child: Choice<T>(
          onChanged: (value) => vals = value,
          multiple: multi,
          clearable: clearable,
          value: vals,
          builder: (state, _) {
            return Wrap(
              children: List<Widget>.generate(
                items.length,
                (index) {
                  final item = items[index];
                  if (item == null) return UIs.placeholder;
                  return ChoiceChipX<T>(
                    label: name?.call(item) ?? item.toString(),
                    state: state,
                    value: item,
                  );
                },
              ),
            );
          },
        ),
      ),
      actions: [
        if (actions != null) ...actions,
        TextButton(
          onPressed: () => pop(true),
          child: Text(l10n.ok),
        ),
      ],
    );
    if (sure == true && vals.isNotEmpty) {
      return vals;
    }
    return null;
  }

  Future<T?> showPickSingleDialog<T>({
    required List<T?> items,
    String Function(T)? name,
    T? initial,
    bool clearable = false,
    List<Widget>? actions,
  }) async {
    final vals = await showPickDialog<T>(
      items: items,
      name: name,
      multi: false,
      initial: initial == null ? null : [initial],
      actions: actions,
    );
    if (vals != null && vals.isNotEmpty) {
      return vals.first;
    }
    return null;
  }
}
