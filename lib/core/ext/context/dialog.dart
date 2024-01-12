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
  }) async {
    return await showDialog<T>(
      context: this,
      barrierDismissible: barrierDismiss,
      builder: (_) {
        return AlertDialog(
          title: title == null ? null : Text(title),
          content: child,
          actions: actions,
          actionsPadding: const EdgeInsets.all(17),
        );
      },
    );
  }

  void showLoadingDialog({bool barrierDismiss = false}) {
    showRoundDialog(
      child: UIs.centerSizedLoading,
      barrierDismiss: barrierDismiss,
    );
  }

  Future<List<T>?> showPickDialog<T>({
    required List<T?> items,
    required String Function(T) name,
    bool multi = true,
    List<T>? initial,
    bool clearable = false,
  }) async {
    var vals = initial ?? <T>[];
    final sure = await showRoundDialog<bool>(
      title: l10n.choose,
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
                  label: name(item),
                  state: state,
                  value: item,
                );
              },
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => pop(true),
          child: const Text('Ok'),
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
    required String Function(T) name,
    T? initial,
    bool clearable = false,
  }) async {
    final vals = await showPickDialog<T>(
      items: items,
      name: name,
      multi: false,
      initial: initial == null ? null : [initial],
    );
    if (vals != null && vals.isNotEmpty) {
      return vals.first;
    }
    return null;
  }
}
