import 'package:flutter/material.dart';

/// [RNode] is RebuildNode.
class RNode implements Listenable {
  final List<VoidCallback> _listeners = [];

  RNode();

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Trigger all listeners.
  /// - [delay] if true, rebuild will be delayed.
  Future<void> build({bool delay = false}) async {
    if (delay) await Future.delayed(const Duration(milliseconds: 277));
    for (final listener in _listeners) {
      listener();
    }
  }

  /// Add this node's listeners to another node.
  void chain(RNode node) {
    node.addListener(build);
  }

  static final app = RNode();
  static final dark = ValueNotifier(false);
}
