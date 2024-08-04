part of 'app.dart';

typedef _Builder = Widget Function(BuildContext ctx, double padTop);

final class _IntroPage extends StatelessWidget {
  final List<_Builder> pages;

  const _IntroPage(this.pages);

  static const _builders = {
    237: _buildAppSettings,
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        final padTop = cons.maxHeight * .12;
        final pages_ = pages.map((e) => e(context, padTop)).toList();
        return IntroPage(
          args: IntroPageArgs(
            pages: pages_,
            onDone: (ctx) {
              Stores.setting.introVer.put(Build.build);
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
          ),
        );
      },
    );
  }

  static Widget _buildAppSettings(BuildContext ctx, double padTop) {
    return ListView(
      padding: _introListPad,
      children: [
        SizedBox(height: padTop),
        _buildTitle(icon: Iconsax.magic_star_bold, big: true),
        SizedBox(height: padTop),
        _buildTitle(text: 'App'),
        ListTile(
          leading: const Icon(IonIcons.language),
          title: Text(libL10n.language),
          onTap: () async {
            final selected = await ctx.showPickSingleDialog(
              title: libL10n.language,
              items: AppLocalizations.supportedLocales,
              name: (p0) => p0.code,
              initial: _setting.locale.fetch().toLocale,
            );
            if (selected != null) {
              _setting.locale.put(selected.code);
              RNodes.app.notify();
            }
          },
          trailing: Text(
            l10n.languageName,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ).cardx,
        ListTile(
          leading: const Icon(Icons.update),
          title: Text(l10n.autoCheckUpdate),
          trailing: StoreSwitch(prop: _setting.autoCheckUpdate),
        ).cardx,
        _buildTitle(text: l10n.chat),
        ListTile(
          leading: const Icon(Iconsax.subtitle_bold),
          title: Text(l10n.genChatTitle),
          trailing: StoreSwitch(prop: _setting.genTitle),
        ).cardx,
        ListTile(
          leading: const Icon(LineAwesome.compress_solid),
          title: Text(l10n.compress),
          subtitle: Text(l10n.compressImgTip, style: UIs.textGrey),
          trailing: StoreSwitch(prop: _setting.compressImg),
        ).cardx,
        ListTile(
          leading: const Icon(Icons.swap_vert),
          title: Text(l10n.scrollSwitchChat),
          trailing: StoreSwitch(prop: _setting.scrollSwitchChat),
        ).cardx,
      ],
    );
  }

  static Widget _buildTitle({IconData? icon, String? text, bool big = false}) {
    assert(icon != null || text != null);

    Widget child;
    if (icon != null) {
      child = Icon(icon, size: big ? 41 : null);
    } else if (text != null) {
      child = Text(
        text,
        style: big
            ? const TextStyle(fontSize: 41, fontWeight: FontWeight.w500)
            : UIs.textGrey,
      );
    } else {
      child = const SizedBox();
    }
    if (!big) {
      child = Padding(
          padding: const EdgeInsets.symmetric(vertical: 13), child: child);
    }
    return Center(child: child);
  }

  static final _setting = Stores.setting;
  static const _introListPad = EdgeInsets.symmetric(horizontal: 17);

  static List<_Builder> get builders {
    final storedVer = _setting.introVer.fetch();
    return _builders.entries
        .where((e) => e.key > storedVer)
        .map((e) => e.value)
        .toList();
  }
}
