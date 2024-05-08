library route;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/analysis.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/about.dart';
import 'package:gpt_box/view/page/backup/view.dart';
import 'package:gpt_box/view/page/debug.dart';
import 'package:gpt_box/view/page/image.dart';
import 'package:gpt_box/view/page/res.dart';
import 'package:gpt_box/view/page/setting.dart';

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

  static const image = AppRoute<ImagePageRet, ImagePageArgs>(
    page: ImagePage.new,
    path: '/image',
  );

  static const res = AppRoute(
    page: ResPage.new,
    path: '/res',
  );
}
