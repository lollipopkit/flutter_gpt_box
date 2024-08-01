library route;

import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/view/page/about.dart';
import 'package:gpt_box/view/page/backup/view.dart';
import 'package:gpt_box/view/page/image.dart';
import 'package:gpt_box/view/page/profile.dart';
import 'package:gpt_box/view/page/res.dart';
import 'package:gpt_box/view/page/setting.dart';
import 'package:gpt_box/view/page/tool.dart';

sealed class Routes {
  static const setting = AppRouteNoArg<SettingsPageRet>(
    page: SettingPage.new,
    path: '/setting',
  );

  static const about = AppRouteNoArg<void>(
    page: AboutPage.new,
    path: '/about',
  );

  static const backup = AppRouteNoArg<BackupPageRet>(
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

  static const res = AppRouteNoArg<void>(
    page: ResPage.new,
    path: '/res',
  );

  static const tool = AppRouteNoArg<void>(
    page: ToolPage.new,
    path: '/tool',
  );

  static const profile = AppRouteNoArg<void>(
    page: ProfilePage.new,
    path: '/profile',
  );
}
