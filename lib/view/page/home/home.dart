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
import 'package:gpt_box/view/page/home/approval.dart';
import 'package:gpt_box/view/page/home/chat_list.dart';
import 'package:gpt_box/view/page/home/chat_view.dart';
import 'package:gpt_box/view/page/home/composer.dart';
import 'package:gpt_box/view/page/home/share.dart';
import 'package:gpt_box/view/page/settings/providers.dart';
import 'package:gpt_box/view/page/settings/setting.dart';

part 'desktop.dart';
part 'url_scheme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  final _scaffold = GlobalKey<ScaffoldState>();
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;

  @override
  void dispose() {
    _linkSub?.cancel();
    Chats.approver = null;
    super.dispose();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    Chats.approver = (call) => askToolApproval(this.context, call);
    Chats.current.value ??= Stores.chat.all().firstOrNull?.id;
    unawaited(Chats.purgeTrash());
    _initLinks();
    if (Stores.setting.autoCheckUpdate.get()) {
      unawaited(AppUpdateIface.doUpdate(
        githubReleasesUrl: Urls.githubReleasesApi,
        context: context,
        build: BuildData.build,
      ));
    }
    if (Llm.configured.value.isEmpty && context.mounted) {
      // Nothing can be sent without a key; say so up front.
      Toast.show(l10n.noProviderKey, action: ToastAction(label: l10n.providers, onTap: _openProviders));
    }
  }

  void _openProviders() => ProvidersPage.route.go(context);

  void _initLinks() {
    DeepLinks.register(_handleLink);
    _linkSub = _appLinks.uriLinkStream.listen(
      (uri) => DeepLinks.process(uri, mounted ? context : null),
      onError: (Object e) => Loggers.app.warning(l10n.invalidLinkFmt(e)),
    );
  }

  bool get _split => MediaQuery.sizeOf(context).width >= AdaptivePanes.kSplitWidth;

  void _newChat() {
    Chats.current.value = null;
    if (!_split) _scaffold.currentState?.closeDrawer();
  }

  void _openSettings() => SettingsPage.route.go(context);

  void _search() {
    if (!_split) _scaffold.currentState?.openDrawer();
    ChatList.searchRequest.notify();
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
    final scaffold = Scaffold(
      key: _scaffold,
      appBar: _appBar(),
      drawer: _split ? null : Drawer(child: SafeArea(child: ChatList(onPicked: () => Navigator.of(context).pop()))),
      body: _body(),
    );
    final shortcuts = CallbackShortcuts(bindings: _desktopShortcuts(this), child: Focus(autofocus: true, child: scaffold));
    return ExitConfirm(
      onPop: (_) => ExitConfirm.exitApp(),
      // The target platform, not the host: the menu bar is the platform's.
      child: defaultTargetPlatform == TargetPlatform.macOS
          ? PlatformMenuBar(menus: _macosMenus(this), child: shortcuts)
          : shortcuts,
    );
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      title: ListenableBuilder(
        listenable: Listenable.merge([Chats.current, Stores.chat.changes]),
        builder: (_, _) {
          final id = Chats.current.value;
          final title = id == null ? l10n.newChat : Stores.chat.fetch(id)?.title ?? l10n.untitled;
          return Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: UIs.text15);
        },
      ),
      actions: [
        Chats.current.listenVal((id) {
          if (id == null) return UIs.placeholder;
          return IconButton(tooltip: l10n.share, icon: const Icon(Icons.share), onPressed: () => shareChat(context, id));
        }),
        IconButton(tooltip: l10n.newChat, icon: const Icon(Icons.add_comment_outlined), onPressed: _newChat),
        IconButton(tooltip: libL10n.setting, icon: const Icon(Icons.settings_outlined), onPressed: _openSettings),
      ],
    );
  }

  Widget _body() {
    final sets = Stores.setting;
    return sets.paneListWidth.listenable().listenVal(
      (width) => sets.paneListCollapsed.listenable().listenVal(
        (collapsed) => AdaptivePanes.surface(
          listWidth: width,
          onListWidthChanged: sets.paneListWidth.set,
          collapsed: collapsed,
          onCollapsedChanged: sets.paneListCollapsed.set,
          listBuilder: (_, _) => const ChatList(),
          // Narrow: the list is in the drawer, the chat has the width.
          surfaceBuilder: (_, _) => const ChatView(),
        ),
      ),
    );
  }
}
