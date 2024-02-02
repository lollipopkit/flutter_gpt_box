// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/app.dart';
import 'package:flutter_chatgpt/core/analysis.dart';
import 'package:flutter_chatgpt/core/build_mode.dart';
import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/util/datetime.dart';
import 'package:flutter_chatgpt/core/util/platform/base.dart';
import 'package:flutter_chatgpt/core/util/sync/base.dart';
import 'package:flutter_chatgpt/data/model/chat/config.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
import 'package:flutter_chatgpt/data/provider/debug.dart';
import 'package:flutter_chatgpt/data/res/openai.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:uni_links_desktop/uni_links_desktop.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  _runInZone(() async {
    await _initApp();
    runApp(const MyApp());
  });
}

void _runInZone(void Function() body) {
  final zoneSpec = ZoneSpecification(
    print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      parent.print(zone, line);
    },
  );

  runZonedGuarded(
    body,
    (obj, trace) {
      Analysis.recordException(trace);
      Loggers.root.warning(obj, null, trace);
    },
    zoneSpecification: zoneSpec,
  );
}

Future<void> _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupLogger();
  await _initDesktopWindow();

  // Base of all data.
  await _initDb();
  await _loadStores();

  Analysis.init();

  OpenAI.showLogs = !BuildMode.isRelease;
  OpenAI.showResponsesLogs = !BuildMode.isRelease;
  OpenAICfg.apply();

  SyncService.sync(force: true);

  if (isWindows) {
    registerProtocol('lk-gptbox');
  }
}

Future<void> _initDb() async {
  await Hive.initFlutter();

  /// It's used by [ChatHistoryAdapter]
  Hive.registerAdapter(DateTimeAdapter());
  Hive.registerAdapter(ChatContentAdapter());
  Hive.registerAdapter(ChatContentTypeAdapter());
  Hive.registerAdapter(ChatRoleAdapter());
  Hive.registerAdapter(ChatHistoryItemAdapter());
  Hive.registerAdapter(ChatConfigAdapter());

  /// MUST put it back of all chat related adapters.
  Hive.registerAdapter(ChatHistoryAdapter());
}

void _setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    DebugNotifier.addLog(record);
    print(record);
    if (record.error != null) print(record.error);
    if (record.stackTrace != null) print(record.stackTrace);
  });
}

Future<void> _initDesktopWindow() async {
  if (!isDesktop) return;

  await windowManager.ensureInitialized();
  await CustomAppBar.updateTitlebarHeight();

  const windowOptions = WindowOptions(
    size: Size(960, 720),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

Future<void> _loadStores() async {
  await Stores.history.init();
  await Stores.setting.init();
}
