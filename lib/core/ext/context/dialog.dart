import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/ext/context/base.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/ui.dart';
import 'package:gpt_box/view/widget/choice.dart';

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

  /// [noConfirm] Return value immediately without confirmation,
  /// only valid if [multi] is false
  Future<List<T>?> showPickDialog<T>({
    required List<T> items,
    String Function(T)? name,
    bool multi = true,
    List<T>? initial,
    bool clearable = true,
    List<Widget>? actions,
    bool noConfirm = true,
    String? title,
  }) async {
    assert(!noConfirm || !multi);
    var vals = initial ?? <T>[];
    final actions_ = [
      if (actions != null) ...actions,
      if (!noConfirm)
        TextButton(
          onPressed: () => pop(true),
          child: Text(l10n.ok),
        ),
    ];
    final sure = await showRoundDialog<bool>(
      title: title ?? l10n.choose,
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
                  return ChoiceChipX<T>(
                    label: name?.call(item) ?? item.toString(),
                    state: state,
                    value: item,
                    onSelected: noConfirm
                        ? (_) {
                            vals = [item];
                            pop(true);
                          }
                        : null,
                  );
                },
              ),
            );
          },
        ),
      ),
      actions: actions_.isEmpty ? null : actions_,
    );
    if (sure == true && vals.isNotEmpty) {
      return vals;
    }
    return null;
  }

  Future<T?> showPickSingleDialog<T>({
    required List<T> items,
    String Function(T)? name,
    T? initial,
    List<Widget>? actions,

    /// Return value immediately without confirmation
    bool noConfirm = true,
    String? title,
  }) async {
    final vals = await showPickDialog<T>(
      title: title,
      items: items,
      name: name,
      multi: false,
      initial: initial == null ? null : [initial],
      actions: actions,
    );
    if (vals != null && vals.isNotEmpty) {
      assert(vals.length == 1);
      return vals.first;
    }
    return null;
  }
}
