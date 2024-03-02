import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';

class StoreSwitch extends StatelessWidget {
  final StorePropertyBase<bool> prop;

  /// If return false, the switch will not change.
  final FutureOr<bool> Function(bool)? validator;

  final bool updateLastModTime;

  final _loading = ValueNotifier(false);

  StoreSwitch({
    super.key,
    required this.prop,
    this.validator,
    this.updateLastModTime = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: prop.listenable(),
      builder: (context, value, widget) {
        return ValueListenableBuilder(
          valueListenable: _loading,
          builder: (_, loading, __) {
            if (loading) return UIs.centerSizedLoadingSmall;
            return Switch(
              value: value,
              onChanged: (value) async {
                if (loading) return;
                if (value == prop.fetch()) return;
                _loading.value = true;
                if (await validator?.call(value) == false) {
                  _loading.value = false;
                  return;
                }
                _loading.value = false;
                prop.put(value, updateModTime: updateLastModTime);
              },
            );
          },
        );
      },
    );
  }
}
