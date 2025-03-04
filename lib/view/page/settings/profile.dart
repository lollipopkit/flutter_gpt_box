part of 'setting.dart';

final class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

final class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    ApiBalance.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiList(
      children: [
        [CenterGreyTitle(l10n.chat), _buildChat()],
        [CenterGreyTitle(l10n.more), _buildMore()],
      ],
    );
  }

  static const refreshIcon = IconButton(
    onPressed: ApiBalance.refresh,
    icon: Icon(Icons.refresh),
  );

  Widget _buildBalance() {
    return ApiBalance.balance.listenVal(
      (val) {
        return ListTile(
          leading: const Icon(Icons.account_balance_wallet),
          title: Text(l10n.balance),
          subtitle: Text(val.state ?? l10n.unsupported, style: UIs.text13Grey),
          trailing: val.loading ? SizedLoading.small : refreshIcon,
        );
      },
    );
  }

  Widget _buildChat() {
    return Cfg.vn.listenVal(
      (cfg) {
        final children = [
          _buildSwitchCfg(cfg),
          _buildBalance(),
          _buildOpenAIKey(cfg.key),
          _buildOpenAIUrl(cfg.url),
          _buildOpenAIModels(cfg),
        ];
        return Column(children: children.map((e) => e.cardx).toList());
      },
    );
  }

  Widget _buildMore() {
    return Cfg.vn.listenVal(
      (cfg) {
        final children = [
          _buildQuickShare(),
          _buildPrompt(cfg.prompt),
          _buildHistoryLength(cfg.historyLen),
          _buildGenTitlePrompt(cfg.genTitlePrompt),
          //_buildFollowChatModel(),
        ];
        return Column(children: children.map((e) => e.cardx).toList());
      },
    );
  }

  Widget _buildSwitchCfg(ChatConfig cfg) {
    return ListTile(
      leading: const Icon(Icons.switch_account),
      title: Text(l10n.profile),
      subtitle: Text(cfg.displayName, style: UIs.textGrey),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Delete
          if (cfg.id != ChatConfig.defaultId)
            Btn.icon(
              icon: const Icon(Icons.delete, size: 19),
              onTap: () {
                if (cfg.id == ChatConfig.defaultId) return;
                context.showRoundDialog(
                  title: l10n.attention,
                  child: Text(l10n.delFmt(cfg.name, l10n.profile)),
                  actions: Btn.ok(
                    onTap: () {
                      Stores.config.delete(cfg.id);
                      context.pop();
                      if (cfg.id == cfg.id) {
                        Cfg.switchToDefault(context);
                      }
                    },
                    red: true,
                  ).toList,
                );
              },
            ),
          // Rename
          Btn.icon(
            icon: const Icon(Icons.edit, size: 19),
            onTap: () {
              final ctrl = TextEditingController(text: cfg.name);
              context.showRoundDialog(
                title: libL10n.edit,
                child: Input(
                  controller: ctrl,
                  label: libL10n.name,
                  autoFocus: true,
                ),
                actions: Btn.ok(
                  onTap: () {
                    final name = ctrl.text;
                    if (name.isEmpty) return;
                    final newCfg = cfg.copyWith(name: name);
                    newCfg.save();
                    Cfg.setTo(cfg: newCfg);
                    context.pop();
                  },
                ).toList,
              );
            },
          ),
          // Switch
          Btn.icon(
            icon: const Icon(OctIcons.arrow_switch, size: 19),
            onTap: () async {
              final map = await Stores.config
                  .getAllMapTyped<ChatConfig>(includeInternalKeys: false);
              final vals = map.values.toList();
              final newCfg = await context.showPickSingleDialog(
                items: vals,
                initial: cfg,
                title: l10n.profile,
                display: (p0) => p0.displayName,
              );

              if (newCfg == null) return;
              Cfg.setTo(cfg: newCfg);
            },
          ),
          Btn.icon(
            icon: const Icon(Icons.add, size: 19),
            onTap: () async {
              final ctrl = TextEditingController();
              final ok = await context.showRoundDialog(
                title: libL10n.add,
                child: Input(
                  controller: ctrl,
                  label: libL10n.name,
                  autoFocus: true,
                ),
                actions: Btnx.oks,
              );
              if (ok != true) return;
              final clipboardData = await Pfs.paste();
              var (key, url) = ('', ChatConfig.defaultUrl);
              if (clipboardData != null) {
                if (clipboardData.startsWith('https://')) {
                  url = clipboardData;
                } else if (clipboardData.startsWith('sk-')) {
                  key = clipboardData;
                }
              }
              final newCfg = Cfg.current.copyWith(
                id: shortid.generate(),
                name: ctrl.text,
                key: key,
                url: url,
              );
              newCfg.save();
              Cfg.setTo(cfg: newCfg);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOpenAIKey(String val) {
    return ListTile(
      leading: const Icon(Icons.vpn_key),
      title: Text(l10n.secretKey),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 60),
        child: Text(
          val.isEmpty ? libL10n.empty : val,
          style: UIs.textGrey,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () async {
        final ctrl = TextEditingController(text: val);
        final result = await context.showRoundDialog<String>(
          title: libL10n.edit,
          child: Input(
            controller: ctrl,
            hint: 'sk-xxx',
            maxLines: 3,
            autoFocus: true,
          ),
          actions: Btn.ok(onTap: () => context.pop(ctrl.text)).toList,
        );
        if (result == null) return;
        Cfg.setTo(cfg: Cfg.current.copyWith(key: result));
      },
    );
  }

  Widget _buildOpenAIUrl(String val) {
    return ListTile(
      leading: const Icon(Icons.link),
      title: const Text('URL'),
      trailing: Text(
        val.isEmpty ? libL10n.empty : val.replaceFirst(RegExp('https?://'), ''),
        style: UIs.text13Grey,
      ),
      onTap: () async {
        final ctrl = TextEditingController(text: val);
        final result = await context.showRoundDialog<String>(
          title: libL10n.edit,
          child: Input(
            controller: ctrl,
            hint: ChatConfig.defaultUrl,
            maxLines: 3,
            autoFocus: true,
          ),
          actions: Btn.ok(onTap: () => context.pop(ctrl.text)).toList,
        );
        if (result == null) return;

        final isApiUrl = ChatConfig.apiUrlReg.hasMatch(result);
        final endsWithV1 = result.endsWith('/v1');
        final isGithubModels = result == Urls.githubModels;
        final showDialog = !isApiUrl || (!endsWithV1 && !isGithubModels);
        if (showDialog) {
          final sure = await context.showRoundDialog(
            title: l10n.attention,
            child: Text(l10n.apiUrlV1Tip),
            actions: Btnx.okReds,
          );
          if (sure != true) return;
        }

        Cfg.setTo(cfg: Cfg.current.copyWith(url: result));
      },
    );
  }

  Widget _buildOpenAIModels(ChatConfig cfg) {
    return ValBuilder(
      listenable: Cfg.models,
      builder: (models) {
        return _buildOpenAIChatModel();
        // return ExpandTile(
        //   leading: const Icon(Icons.model_training),
        //   title: Text(l10n.model),
        //   children: [
        //     _buildOpenAIChatModel(),
        //     _buildOpenAIImgModel(),
        //     _buildOpenAISpeechModel(),
        //     // _buildOpenAITranscribeModel(),
        //   ],
        // );
      },
    );
  }

  Widget _buildOpenAIChatModel() {
    final cfg = Cfg.current;
    final val = cfg.model;
    return ListTile(
      leading: const Icon(Icons.chat),
      title: Text(l10n.model),
      trailing: Text(val, style: UIs.text13Grey),
      onTap: () {
        Cfg.showPickModelDialog(context);
      },
    );
  }

  // Widget _buildOpenAIImgModel() {
  //   final cfg = OpenAICfg.current;
  //   final val = cfg.imgModel;
  //   return ListTile(
  //     leading: const Icon(Icons.photo),
  //     title: Text(l10n.image),
  //     trailing: const Icon(Icons.keyboard_arrow_right),
  //     subtitle: Text(val, style: UIs.text13Grey),
  //     onTap: () async {
  //       final model = await _showPickModelDialog(l10n.model, val);
  //       if (model != null) {
  //         Cfg.setTo(Cfg.current.copyWith(imgModel: model));
  //       }
  //     },
  //   );
  // }

  // Widget _buildOpenAISpeechModel() {
  //   final cfg = OpenAICfg.current;
  //   final val = cfg.speechModel;
  //   return ListTile(
  //     leading: const Icon(Icons.speaker),
  //     title: Text(l10n.tts),
  //     trailing: const Icon(Icons.keyboard_arrow_right),
  //     subtitle: Text(val, style: UIs.text13Grey),
  //     onTap: () async {
  //       final model = await _showPickModelDialog(l10n.model, val);
  //       if (model != null) {
  //         Cfg.setTo(Cfg.current.copyWith(speechModel: model));
  //       }
  //     },
  //   );
  // }

  // Widget _buildOpenAITranscribeModel() {
  //   final cfg = OpenAICfg.current;
  //   final val = cfg.transcribeModel;
  //   return ListTile(
  //     leading: const Icon(Icons.transcribe),
  //     title: Text(l10n.stt),
  //     trailing: const Icon(Icons.keyboard_arrow_right),
  //     subtitle: Text(val, style: UIs.text13Grey),
  //     onTap: () async {
  // final model = await _showPickModelDialog(l10n.model, val);
  //       if (model != null) {
  //         Cfg.setTo(Cfg.current.copyWith(transcribeModel: model));
  //         Cfg.vn.notify();
  //       }
  //     },
  //   );
  // }

  Widget _buildPrompt(String val) {
    return ListTile(
      leading: const Icon(Icons.abc),
      title: Text(l10n.promptsSettingsItem),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 60),
        child: Text(
          val.isEmpty ? libL10n.empty : val,
          style: UIs.textGrey,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () async {
        final ctrl = TextEditingController(text: val);
        final result = await context.showRoundDialog<String>(
          title: libL10n.edit,
          child: Input(
            controller: ctrl,
            maxLines: 11,
            autoFocus: true,
          ),
          actions: Btn.ok(onTap: () => context.pop(ctrl.text)).toList,
        );
        if (result == null) return;
        Cfg.setTo(cfg: Cfg.current.copyWith(prompt: result));
      },
    );
  }

  Widget _buildGenTitlePrompt(String? val) {
    return ListTile(
      leading: const Icon(Icons.title),
      title: Text('${l10n.promptsSettingsItem}(${l10n.genTitle})'),
      trailing: Text(val ?? libL10n.empty, style: UIs.textGrey),
      onTap: () async {
        final ctrl = TextEditingController(text: val);
        final result = await context.showRoundDialog<String>(
          title: libL10n.edit,
          child: Input(
            controller: ctrl,
            maxLines: 11,
            autoFocus: true,
          ),
          actions: Btn.ok(onTap: () => context.pop(ctrl.text)).toList,
        );
        if (result == null) return;
        Cfg.setTo(cfg: Cfg.current.copyWith(genTitlePrompt: result));
      },
    );
  }

  Widget _buildHistoryLength(int val) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: TipText(l10n.chatHistoryLength, l10n.chatHistoryTip),
      trailing: Text(val.toString(), style: UIs.text13Grey),
      onTap: () async {
        final ctrl = TextEditingController(text: val.toString());
        final result = await context.showRoundDialog<String>(
          title: libL10n.edit,
          child: Input(
            controller: ctrl,
            hint: '7',
            autoFocus: true,
            type: TextInputType.number,
          ),
          actions: Btn.ok(onTap: () => context.pop(ctrl.text)).toList,
        );
        if (result == null) return;
        final newVal = int.tryParse(result);
        if (newVal == null) {
          context.showSnackBar('Invalid number: $result');
          return;
        }
        Cfg.setTo(cfg: Cfg.current.copyWith(historyLen: newVal));
      },
    );
  }

  Widget _buildQuickShare() {
    return ListTile(
      leading: const Icon(Icons.share),
      title: TipText(libL10n.share, l10n.quickShareTip),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () {
        final url = Cfg.current.shareUrl;
        if (url.isEmpty) return;
        Share.share(url);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  // Widget _buildFollowChatModel() {
  //   return ListTile(
  //     leading: const Icon(OctIcons.arrow_switch, size: 21),
  //     title: Text(l10n.followChatModel),
  //     trailing: StoreSwitch(prop: Stores.config.followModel),
  //   );
  // }
}
