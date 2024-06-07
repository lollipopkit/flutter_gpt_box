// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/app.dart';
import 'package:gpt_box/core/util/datetime.dart';
import 'package:gpt_box/core/util/sync/base.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/history.dart';
import 'package:gpt_box/data/model/chat/type.dart';
import 'package:gpt_box/data/provider/all.dart';
import 'package:gpt_box/data/res/build.dart';
import 'package:gpt_box/data/res/misc.dart';
import 'package:gpt_box/data/res/openai.dart';
import 'package:gpt_box/data/store/all.dart';
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
  await Paths.init(Build.name, bakName: Miscs.bakFileName);

  await _initDb();
  _initAppComponents();
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

  await Stores.history.init();
  await Stores.setting.init();
  await Stores.config.init();
}

void _setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    Pros.debug.addLog(record);
    print(record);
    if (record.error != null) print(record.error);
    if (record.stackTrace != null) print(record.stackTrace);
  });
}

Future<void> _initAppComponents() async {
  SystemUIs.initDesktopWindow(Stores.setting.hideTitleBar.fetch());

  if (Stores.setting.countly.fetch()) {
    Analysis.init(
      'https://countly.lolli.tech',
      '54f29be34c4ef369ddf4249f353cece142ef78d9',
    );
  }

  OpenAI.showLogs = !BuildMode.isRelease;
  OpenAI.showResponsesLogs = !BuildMode.isRelease;
  OpenAICfg.apply();
  OpenAICfg.updateModels();

  SyncService.sync(force: true);

  if (Stores.setting.joinBeta.fetch()) AppUpdate.chan = AppUpdateChan.beta;
}
