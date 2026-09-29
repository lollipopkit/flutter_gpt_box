import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/app.dart';
import 'package:gpt_box/core/util/sync.dart';
import 'package:gpt_box/data/res/build_data.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  await _runInZone(() async {
    await _initApp();
    runApp(const MyApp());
  });
}

Future<void> _runInZone(Future<void> Function() body) async {
  final zoneSpec = ZoneSpecification(
    print: (_, parent, zone, line) => parent.print(zone, line),
  );

  await runZonedGuarded(body, (e, s) {
    // The zone takes uncaught async errors before `PlatformDispatcher.onError`,
    // so this is the only place they are seen.
    if (Diag.enabled) {
      Diag.error(e, s, 'Zone error');
    } else {
      Loggers.app.severe('Zone error', e, s);
    }
    CrashLog.markUnhandled(e, s);
  }, zoneSpecification: zoneSpec);
}

Future<void> _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Before anything that can fail, so a failure during startup is recorded.
  _setupDebug();

  await Paths.init(
    BuildData.name,
    bakName: bakFileName,
    dirs: const {},
    fileInUserDocuments: false,
  );
  await CrashLog.attach(Paths.doc.joinPath('logs'));

  await _initData();
  await _initWindow();
  await _initAppComponents();
}

Future<void> _initData() async {
  await PrefStore.shared.init(); // Call this before accessing any store
  await SecureStoreProps.migrateLegacyPrefs();
  await Webdav.initShared();
  await Stores.init();
}

void _setupDebug() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(DebugProvider.addLog);
  CrashLog.handleErrors();
  // Local only: nothing is sent anywhere.
  Diag.install(LocalDiagnosticsSink());
  AppLifecycleListener(
    onPause: () => unawaited(Diag.flush()),
    onDetach: () => unawaited(Diag.flush()),
  );
}

Future<void> _initWindow() async {
  if (!isDesktop) return;
  final sets = Stores.setting;
  final windowStateProp = sets.windowState;
  final windowState = windowStateProp.get();
  // The app draws its own title bar: the design has no system one.
  WindowFrameConfig.setShowCaption(true);
  await SystemUIs.initDesktopWindow(
    hideTitleBar: true,
    size: windowState?.size ?? const Size(1100, 760),
    position: windowState?.position,
    listener: WindowStateListener(windowStateProp),
  );
}

Future<void> _initAppComponents() async {
  await Llm.init();
  // Open chats follow the tool settings and the MCP servers.
  Stores.mcp.watch().listen((_) => Chats.reconfigureSoon());
  McpTools.changes.addListener(Chats.reconfigureSoon);
  if (Stores.mcp.enabled.get()) unawaited(McpTools.connectStored());

  BakSync.instance.init();
  // Only when sync is on, and never without a password: see BakSync.
  BakSync.instance.syncSoon();
}
