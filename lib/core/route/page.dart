library route;

import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/view/page/about.dart';
import 'package:gpt_box/view/page/backup/view.dart';
import 'package:gpt_box/view/page/image.dart';
import 'package:gpt_box/view/page/res.dart';
import 'package:gpt_box/view/page/setting.dart';
import 'package:gpt_box/view/page/tool.dart';

sealed class Routes {
  static const setting = AppRoute<Never, Never>(
    page: SettingPage.new,
    path: '/setting',
  );

  static const debug = AppRoute<Never, DebugPageArgs>(
    page: DebugPage.new,
    path: '/debug',
  );

  static const about = AppRoute<Never, Never>(
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

  static const res = AppRoute<Never, Never>(
    page: ResPage.new,
    path: '/res',
  );

  static const tool = AppRoute<Never, Never>(
    page: ToolPage.new,
    path: '/tool',
  );
}
