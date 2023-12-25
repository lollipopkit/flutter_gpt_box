// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Store {
  late final Box box;

  final String boxName;

  Store(this.boxName);

  Future<void> init() async => box = await Hive.openBox(boxName);

  _StoreProperty<T> property<T>(String key, T defaultValue) {
    return _StoreProperty<T>(box, key, defaultValue);
  }

  _StoreListProperty<T> listProperty<T>(String key, List<T> defaultValue) {
    return _StoreListProperty<T>(box, key, defaultValue);
  }
}

abstract class StorePropertyBase<T> {
  ValueListenable<T> listenable();
  T fetch();
  Future<void> put(T value);
  Future<void> delete();
}

class _StoreProperty<T> implements StorePropertyBase<T> {
  const _StoreProperty(this._box, this._key, this.defaultValue);

  final Box _box;
  final String _key;
  final T defaultValue;

  @override
  ValueListenable<T> listenable() {
    return PropertyListenable<T>(_box, _key, defaultValue);
  }

  @override
  T fetch() {
    final stored = _box.get(_key);
    if (stored == null || stored is! T) {
      return defaultValue;
    }
    return stored;
  }

  @override
  Future<void> put(T value) {
    return _box.put(_key, value);
  }

  @override
  Future<void> delete() {
    return _box.delete(_key);
  }
}

class _StoreListProperty<T> implements StorePropertyBase<List<T>> {
  const _StoreListProperty(this._box, this._key, this.defaultValue);

  final Box _box;
  final String _key;
  final List<T> defaultValue;

  @override
  ValueListenable<List<T>> listenable() {
    return PropertyListenable<List<T>>(_box, _key, defaultValue);
  }

  @override
  List<T> fetch() {
    final val = _box.get(_key, defaultValue: defaultValue)!;

    if (val is! List) {
      throw Exception('StoreListProperty("$_key") is: ${val.runtimeType}');
    }

    return List<T>.from(val);
  }

  @override
  Future<void> put(List<T> value) {
    return _box.put(_key, value);
  }

  @override
  Future<void> delete() {
    return _box.delete(_key);
  }
}

class PropertyListenable<T> extends ValueListenable<T> {
  PropertyListenable(this.box, this.key, this.defaultValue);

  final Box box;
  final String key;
  final T? defaultValue;

  final List<VoidCallback> _listeners = [];
  StreamSubscription? _subscription;

  @override
  void addListener(VoidCallback listener) {
    _subscription ??= box.watch().listen((event) {
      if (key == event.key) {
        for (var listener in _listeners) {
          listener();
        }
      }
    });

    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  @override
  T get value => box.get(key, defaultValue: defaultValue);
}
