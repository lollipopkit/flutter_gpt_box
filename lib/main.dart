// ignore_for_file: avoid_print

import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/app.dart';
import 'package:gpt_box/core/util/datetime.dart';
import 'package:gpt_box/core/util/sync.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/data/model/chat/type.dart';
import 'package:gpt_box/data/res/openai.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  _runInZone(() async {
    await _initApp();
    runApp(const MyApp());
  });
}

void _runInZone(void Function() body) {
  final zoneSpec = ZoneSpecification(
    print: (_, parent, zone, line) => parent.print(zone, line),
  );

  runZonedGuarded(
    body,
    (e, s) => print('[ZONE] $e\n$s'),
    zoneSpecification: zoneSpec,
  );
}

Future<void> _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  _initBuild();
  await Paths.init();
  await _initDb();

  _setupLogger();
  _initAppComponents();
}

void _initBuild() {
  Build.mockVer = 314;
  Build.mockName = 'GPTBox';
  Build.mockId = 'gptbox';
}

Future<void> _initDb() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ChatHistoryItemAdapter()); // 0
  Hive.registerAdapter(ChatContentTypeAdapter()); // 1
  Hive.registerAdapter(ChatContentAdapter()); // 2
  Hive.registerAdapter(ChatRoleAdapter()); // 3
  Hive.registerAdapter(DateTimeAdapter()); // 4
  Hive.registerAdapter(ChatHistoryAdapter()); // 5
  Hive.registerAdapter(ChatConfigAdapter()); // 6
  Hive.registerAdapter(ChatTypeAdapter()); // 7
  Hive.registerAdapter(ChatSettingsAdapter()); // 8

  await PrefStore.init();
  await Stores.init();

  await Migrations.call(Migrations.initDbFns);
}

void _setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    DebugProvider.addLog(record);
    print(record);
    if (record.error != null) print(record.error);
    if (record.stackTrace != null) print(record.stackTrace);
  });
}

Future<void> _initAppComponents() async {
  Apis.init();
  DeepLinks.appId = AppLink.host;

  final sets = Stores.setting;
  final size = sets.windowSize;
  SystemUIs.initDesktopWindow(
    hideTitleBar: sets.hideTitleBar.fetch(),
    size: size.fetch().toSize(),
    listener: WindowSizeListener(size),
  );

  OpenAICfg.apply();
  OpenAICfg.updateModels();

  sync.sync();

  if (Stores.setting.joinBeta.fetch()) AppUpdate.chan = AppUpdateChan.beta;
}
