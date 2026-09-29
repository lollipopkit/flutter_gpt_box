import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/core/util/url.dart';
import 'package:gpt_box/data/model/chat.dart';
import 'package:gpt_box/data/res/build_data.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/url.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/chat_list.dart';
import 'package:gpt_box/view/page/home/chat_view.dart';
import 'package:gpt_box/view/page/home/composer.dart';
import 'package:gpt_box/view/page/home/share.dart';
import 'package:gpt_box/view/page/settings/providers.dart';
import 'package:gpt_box/view/page/settings/setting.dart';

part 'desktop.dart';
part 'url_scheme.dart';

/// One sidebar and the content beside it on a wide window: the chats, or in
/// the settings their categories. A phone has the chat, with the chats in a
/// drawer and the settings pushed.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static _HomePageState? _state;

  /// The desktop shortcuts, for a key pressed on any page: the settings are
  /// routes of their own, above the home page. Put above the navigator.
  static Widget shortcuts({required Widget child}) => Focus(
    canRequestFocus: false,
    skipTraversal: true,
    onKeyEvent: (_, e) {
      final s = _state;
      if (s == null || !s.mounted || e is! KeyDownEvent) return KeyEventResult.ignored;
      for (final MapEntry(key: a, value: run) in _desktopShortcuts(s).entries) {
        if (a.accepts(e, HardwareKeyboard.instance)) {
          run();
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    },
    child: child,
  );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  final _scaffold = GlobalKey<ScaffoldState>();
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    HomePage._state = this;
  }

  @override
  void dispose() {
    if (HomePage._state == this) HomePage._state = null;
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    Chats.current.value ??= Stores.chat.all().firstOrNull?.id;
    unawaited(Chats.purgeTrash());
    _initLinks();
    if (Stores.setting.autoCheckUpdate.get()) {
      unawaited(
        AppUpdateIface.doUpdate(
          githubReleasesUrl: Urls.githubReleasesApi,
          context: context,
          build: BuildData.build,
        ),
      );
    }
    if (Llm.configured.value.isEmpty && context.mounted) {
      // Nothing can be sent without a key; say so up front.
      Toast.show(
        l10n.noProviderKey,
        action: ToastAction(
          label: l10n.providers,
          onTap: () => _openSettings(SettingsTab.providers),
        ),
      );
    }
  }

  void _initLinks() {
    DeepLinks.register(_handleLink);
    _linkSub = _appLinks.uriLinkStream.listen(
      (uri) => DeepLinks.process(uri, mounted ? context : null),
      onError: (Object e) => Loggers.app.warning(l10n.invalidLinkFmt(e)),
    );
  }

  void _newChat() {
    Chats.current.value = null;
    SettingsNav.close();
    _scaffold.currentState?.closeDrawer();
  }

  void _openSettings([SettingsTab tab = SettingsTab.app]) {
    _scaffold.currentState?.closeDrawer();
    if (SettingsNav.inline) {
      SettingsNav.open(context, tab);
    } else if (tab == SettingsTab.app) {
      SettingsPage.route.go(context);
    } else {
      SettingsTabPage.route.go(context, args: tab);
    }
  }

  void _search() {
    SettingsNav.close();
    if (!SettingsNav.inline) _scaffold.currentState?.openDrawer();
    ChatSidebar.requestSearch();
  }

  void _step(int delta) {
    final chats = Stores.chat.all();
    if (chats.isEmpty) return;
    final i = chats.indexWhere((c) => c.id == Chats.current.value);
    final next = (i < 0 ? 0 : i + delta).clamp(0, chats.length - 1);
    Chats.current.value = chats[next].id;
  }

  @override
  Widget build(BuildContext context) {
    final body = LayoutBuilder(
      builder: (context, cons) {
        final wide = cons.maxWidth >= AdaptivePanes.kSplitWidth;
        SettingsNav.inline = wide;
        return wide ? _wide() : _narrow();
      },
    );
    final scaffold = Scaffold(
      key: _scaffold,
      drawer: Drawer(
        child: SafeArea(
          child: ChatSidebar(
            onNewChat: _newChat,
            onOpenSettings: _openSettings,
            onPicked: () => _scaffold.currentState?.closeDrawer(),
          ),
        ),
      ),
      drawerEnableOpenDragGesture: !isDesktop,
      body: body,
    );
    final shortcuts = Focus(autofocus: true, child: scaffold);
    return ExitConfirm(
      onPop: (_) => ExitConfirm.exitApp(),
      // The target platform, not the host: the menu bar is the platform's.
      child: defaultTargetPlatform == TargetPlatform.macOS
          ? PlatformMenuBar(menus: _macosMenus(this), child: shortcuts)
          : shortcuts,
    );
  }

  Widget _wide() {
    final sets = Stores.setting;
    // The seam drags; the sidebar does not fold, so there is no grip on it.
    return sets.paneListWidth.listenable().listenVal(
      (width) => AdaptivePanes.surface(
        listWidth: width,
        onListWidthChanged: sets.paneListWidth.set,
        listBuilder: (_, _) => ChatSidebar(onNewChat: _newChat, onOpenSettings: _openSettings),
        surfaceBuilder: (_, _) => const ChatPane(),
      ),
    );
  }

  Widget _narrow() {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          SizedBox(
            height: 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                children: [
                  Btn.icon(
                    icon: const Icon(Icons.menu, size: 22),
                    text: l10n.chat,
                    onTap: () => _scaffold.currentState?.openDrawer(),
                  ),
                  const Expanded(child: ChatTitle(center: true)),
                  Btn.icon(
                    icon: const Icon(Icons.settings_outlined, size: 22),
                    text: libL10n.setting,
                    onTap: _openSettings,
                  ),
                ].joinWith(const SizedBox(width: 3)),
              ),
            ),
          ),
          const Expanded(child: ChatPane(compact: true)),
        ],
      ),
    );
  }
}
