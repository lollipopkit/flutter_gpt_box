// ignore_for_file: avoid_print

import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/app.dart';
import 'package:gpt_box/core/util/datetime.dart';
import 'package:gpt_box/core/util/sync.dart';
import 'package:gpt_box/core/util/url.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/data/model/chat/history/hive_adapter.dart';
import 'package:gpt_box/data/model/chat/type.dart';
import 'package:gpt_box/data/res/build_data.dart';
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
  ProxyHttpOverrides.useSystemProxy();

  await Paths.init(BuildData.name);
  await _initDb();

  _setupLogger();
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
  Hive.registerAdapter(ChatSettingsAdapter()); // 8
  Hive.registerAdapter(ChatCompletionMessageToolCallAdapter()); // 9
  Hive.registerAdapter(ChatCompletionMessageFunctionCallAdapter()); // 10

  await PrefStore.shared.init();
  await Stores.init();
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
  DeepLinks.appId = AppLink.host;
  UserApi.init();

  final sets = Stores.setting;
  final windowStateProp = sets.windowState;
  final windowState = windowStateProp.fetch();
  await SystemUIs.initDesktopWindow(
    hideTitleBar: sets.hideTitleBar.get(),
    size: windowState?.size,
    position: windowState?.position,
    listener: WindowStateListener(windowStateProp),
  );

  Cfg.applyClient();
  Cfg.updateModels();

  BakSync.instance.init();
  BakSync.instance.sync();

  if (Stores.setting.joinBeta.get()) AppUpdate.chan = AppUpdateChan.beta;

  Stores.trash.autoDelete();
}
