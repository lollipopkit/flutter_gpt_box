import 'package:fl_lib/fl_lib.dart';
import 'package:fl_lib/generated/l10n/lib_l10n.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/res/build_data.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/generated/l10n/l10n.dart';
import 'package:gpt_box/view/page/home/home.dart';
import 'package:icons_plus/icons_plus.dart';

part 'intro.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemUIs.setTransparentNavigationBar(context);

    return RNodes.app.listen(() => _buildApp(context));
  }

  Widget _buildApp(BuildContext context) {
    UIs.colorSeed = Color(Stores.setting.themeColorSeed.get());
    final themeMode = switch (Stores.setting.themeMode.get()) {
      1 => ThemeMode.light,
      2 => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final locale = Stores.setting.locale.get();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPT Box',
      locale: locale.toLocale,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        LibLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: LocaleUtil.resolve,
      themeMode: themeMode,
      theme: ThemeData(colorSchemeSeed: UIs.colorSeed).fixWindowsFont,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: UIs.colorSeed,
      ).toAmoled.fixWindowsFont,
      home: VirtualWindowFrame(
        child: Builder(
          builder: (context) {
            final l10n_ = AppLocalizations.of(context);
            if (l10n_ != null) l10n = l10n_;
            context.setLibL10n();
            UIs.primaryColor = Theme.of(context).colorScheme.primary;

            final intros = _IntroPage.builders;
            if (intros.isNotEmpty) {
              return _IntroPage(intros);
            }
            return const HomePage();
          },
        ),
      ),
    );
  }
}
