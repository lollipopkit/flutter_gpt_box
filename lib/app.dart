import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/locale.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/update.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/page/home/home.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _init(context);
    return ListenableBuilder(
      listenable: RebuildNode.app,
      builder: (_, __) {
        UIs.colorSeed = Color(Stores.setting.themeColorSeed.fetch());
        final themeMode = switch (Stores.setting.themeMode.fetch()) {
          1 => ThemeMode.light,
          2 => ThemeMode.dark,
          _ => ThemeMode.system,
        };
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GPT Box',
          locale: Stores.setting.locale.fetch().toLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: themeMode,
          theme: ThemeData(colorSchemeSeed: UIs.colorSeed),
          darkTheme: _getAmoledTheme(ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: UIs.colorSeed,
          )),
          home: const HomePage(),
        );
      },
    );
  }

  void _init(BuildContext context) async {
    if (Stores.setting.autoCheckUpdate.fetch()) {
      AppUpdateIface.doUpdate(context);
    }
  }
}

ThemeData _getAmoledTheme(ThemeData darkTheme) => darkTheme.copyWith(
      scaffoldBackgroundColor: Colors.black,
      dialogBackgroundColor: Colors.black,
      drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      dialogTheme: const DialogTheme(backgroundColor: Colors.black),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Colors.black),
      listTileTheme: const ListTileThemeData(tileColor: Colors.transparent),
      cardTheme: const CardTheme(color: Colors.black12),
      navigationBarTheme:
          const NavigationBarThemeData(backgroundColor: Colors.black),
      popupMenuTheme: const PopupMenuThemeData(color: Colors.black),
    );
