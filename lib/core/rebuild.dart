import 'package:flutter/material.dart';

class RebuildNode implements Listenable {
  final List<VoidCallback> _listeners = [];

  RebuildNode();

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Rebuild all listeners.
  /// - [delay] if true, rebuild will be delayed.
  Future<void> rebuild({bool delay = false}) async {
    if (delay) await Future.delayed(const Duration(milliseconds: 277));
    for (final listener in _listeners) {
      listener();
    }
  }

  /// Add this node's listeners to another node.
  void chain(RebuildNode node) {
    node.addListener(rebuild);
  }

  static final app = RebuildNode();
}
