// The home page on the real runtime: it lays out, and a message typed and sent
// comes back streamed into the chat view.
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_lib/generated/l10n/lib_l10n.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/core/llm/store.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/generated/l10n/l10n.dart';
import 'package:gpt_box/view/page/home/home.dart';
import 'package:gpt_box/view/page/settings/setting.dart';

import '../core/chats_test.dart' show mockServer, nativeLib;

Widget _app() => MaterialApp(
  localizationsDelegates: const [LibLocalizations.delegate, ...AppLocalizations.localizationsDelegates],
  supportedLocales: AppLocalizations.supportedLocales,
  home: Builder(
    builder: (context) {
      context.setLibL10n();
      l10n = AppLocalizations.of(context)!;
      return ToastHost(child: ResponsivePoints.builder(context, const HomePage()));
    },
  ),
);

void main() {
  setUpAll(() async {
    // No platform side in a test: app_links' stream would throw on listen.
    TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger.setMockStreamHandler(
      const EventChannel('com.llfbandit.app_links/events'),
      MockStreamHandler.inline(onListen: (_, _) {}),
    );
    // The binding answers every HTTP request with a 400; the runtime needs
    // to reach the mock server for real.
    HttpOverrides.global = null;
    final (server, _) = await mockServer();
    SqliteDb.openInMemory();
    await Stores.init();
    SqlitePiSessionStore();
    Stores.setting.autoCheckUpdate.set(false);
    Stores.setting.genTitle.set(false);
    Stores.llm.customProviders.set([
      LlmCustomProvider(
        id: 'mock',
        name: 'Mock',
        api: LlmApi.openaiCompletions,
        baseUrl: 'http://127.0.0.1:${server.port}/v1',
        models: const ['echo'],
      ),
    ]);
    await Llm.init(
      credentials: MemoryCredentials({'mock': LlmCredential.apiKey('k')}),
      externalLibrary: nativeLib(),
    );
  });

  testWidgets('every settings tab lays out', (tester) async {
    tester.view.physicalSize = const Size(1000, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app());
    await tester.pump();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    for (final tab in SettingsTab.values) {
      await tester.tap(find.text(tab.i18n));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: tab.name);
    }
    // The providers tab lists pi-ai's catalog, the configured one first.
    await tester.tap(find.text(SettingsTab.providers.i18n));
    await tester.pumpAndSettle();
    expect(find.text('Mock'), findsWidgets);
  });

  for (final size in const [Size(400, 800), Size(1200, 800)]) {
    testWidgets('sends and shows the reply at ${size.width.toInt()} wide', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      Chats.current.value = null;

      await tester.pumpWidget(_app());
      await tester.pump();
      expect(find.byType(TextField), findsWidgets);
      expect(find.text('echo'), findsOneWidget, reason: 'the default model is on the chip');

      final input = find.byWidgetPredicate((w) => w is TextField && w.decoration?.hintText != null && w.minLines == 1);
      await tester.enterText(input, 'hello widget');
      await tester.tap(find.byIcon(Icons.arrow_upward));

      // The runtime runs on real time.
      final reply = find.textContaining('Echo:', findRichText: true);
      for (var i = 0; i < 50 && reply.evaluate().isEmpty; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pump();
      }
      expect(reply, findsWidgets);
      expect(find.byWidgetPredicate((w) => w is SelectableText && w.data == 'hello widget'), findsOneWidget);
      await tester.runAsync(Chats.closeAll);
    });
  }
}
