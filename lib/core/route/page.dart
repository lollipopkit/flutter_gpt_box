library route;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/analysis.dart';
import 'package:flutter_chatgpt/view/page/about.dart';
import 'package:flutter_chatgpt/view/page/backup/view.dart';
import 'package:flutter_chatgpt/view/page/debug.dart';
import 'package:flutter_chatgpt/view/page/setting.dart';

part 'base.dart';

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

  static const about = AppRoute(
    page: AboutPage.new,
    path: '/about',
  );

  static const backup = AppRoute<BackupPageRet, Never>(
    page: BackupPage.new,
    path: '/backup',
  );

  // static const editor = AppRoute<String, EditorPageArgs>(
  //   page: EditorPage.new,
  //   path: '/editor',
  // );
}
