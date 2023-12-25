library route;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/analysis.dart';
import 'package:flutter_chatgpt/view/page/debug.dart';
import 'package:flutter_chatgpt/view/page/setting.dart';

part 'base.dart';

// class PopTime {
//   static const none = PopTime._(0);
//   static const before = PopTime._(1 << 1);
//   static const after = PopTime._(1);
//   static const all = PopTime._(1 << 2 - 1);

//   final int val;

//   const PopTime._(this.val);

//   operator |(PopTime other) => PopTime._(val | other.val);

//   bool should(PopTime time) => time.val & PopTime.before.val != 0;
// }


/// NEVER use [Navigator.pushNamed], it's [arguments] is not type safe.
/// USE [Routes] instead.
sealed class Routes {
  static const setting = AppRoute(
    page: SettingPage.new,
    path: '/setting',
  );

  static const debug = AppRoute(
    page: DebugPage.new,
    path: '/debug',
  );
}
