import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/util/api_balance.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/openai.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:shortid/shortid.dart';

final class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, Never? args});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

final class _ProfilePageState extends State<ProfilePage> {
  final _cfgRN = RNode();

  @override
  void initState() {
    super.initState();
    ApiBalance.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.profile),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      children: [
        _buildBalance(),
        _buildTitle(l10n.chat),
        _buildChat(),
        _buildTitle(l10n.more),
        _buildMore(),
        const SizedBox(height: 37),
      ],
    );
  }

  Widget _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 23, bottom: 17),
      child: Center(
        child: Text(
          text,
          style: UIs.textGrey,
        ),
      ),
    );
  }

  Widget _buildBalance() {
    return ValBuilder(
      listenable: ApiBalance.balance,
      builder: (val) {
        return ListTile(
          leading: const Icon(Icons.account_balance_wallet),
          title: Text(l10n.balance),
          trailing: Text(
            val,
            style: UIs.text13Grey,
          ),
        ).cardx;
      },
    );
  }

  Widget _buildChat() {
    return ListenBuilder(
      listenable: _cfgRN,
      builder: () {
        final cfg = OpenAICfg.current;
        final children = [
          _buildSwitchCfg(cfg),
          _buildOpenAIKey(cfg.key),
          _buildOpenAIUrl(cfg.url),
          _buildOpenAIModels(cfg),
        ];
        return Column(children: children.map((e) => e.cardx).toList());
      },
    );
  }

  Widget _buildMore() {
    return ListenBuilder(
      listenable: _cfgRN,
      builder: () {
        final cfg = OpenAICfg.current;
        final children = [
          _buildPrompt(cfg.prompt),
          _buildHistoryLength(cfg.historyLen),
          //_buildFollowChatModel(),
        ];
        return Column(children: children.map((e) => e.cardx).toList());
      },
    );
  }

  Widget _buildSwitchCfg(ChatConfig cfg) {
    final vals = Stores.config.box
        .toJson<ChatConfig>(includeInternal: false)
        .values
        .toList();
    final children = <Widget>[];
    for (int idx = 0; idx < vals.length; idx++) {
      final value = vals[idx];
      final delBtn = IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          if (value.id == ChatConfig.defaultId) return;
          context.showRoundDialog(
            title: l10n.attention,
            child: Text(l10n.delFmt(value.name, l10n.profile)),
            actions: Btns.oks(
              onTap: () {
                Stores.config.delete(value.id);
                _cfgRN.notify();
                context.pop();
                if (cfg.id == value.id) {
                  OpenAICfg.switchToDefault(context);
                  _cfgRN.notify();
                }
              },
              red: true,
            ),
          );
        },
      );
      children.add(ListTile(
        leading: Checkbox(
          value: cfg.id == value.id,
          onChanged: (val) {
            if (val != true) return;
            OpenAICfg.setTo(value);
            _cfgRN.notify();
          },
        ),
        title: Text(value.name.isEmpty ? l10n.defaulT : value.name),
        onTap: () {
          if (cfg.id == value.id) return;
          OpenAICfg.setTo(value);
          _cfgRN.notify();
        },
        trailing: value.id != ChatConfig.defaultId ? delBtn : null,
      ));
    }
    children.add(ListTile(
      onTap: () async {
        final ctrl = TextEditingController();
        final name = await context.showRoundDialog(
          title: l10n.add,
          child: Input(
            controller: ctrl,
            hint: l10n.name,
            icon: Icons.text_fields,
          ),
          actions: Btns.oks(
            onTap: () => context.pop(ctrl.text),
          ),
        );
        if (name == null) return;
        final cfg = ChatConfig.defaultOne.copyWith(
          id: shortid.generate(),
          name: name,
        )..save();
        OpenAICfg.setTo(cfg);
        _cfgRN.notify();
      },
      title: Text(l10n.add),
      trailing: const Icon(Icons.add),
    ));
    return ExpandTile(
      leading: const Icon(Icons.switch_account),
      title: Text(l10n.profile),
      subtitle: Text(
        '${l10n.current}: ${switch ((cfg.id, cfg.name)) {
          (ChatConfig.defaultId, _) => l10n.defaulT,
          (_, final String name) => name,
        }}',
        style: UIs.text13Grey,
      ),
      children: children,
    );
  }

  Widget _buildOpenAIKey(String val) {
    return ListTile(
      leading: const Icon(Icons.vpn_key),
      title: Text(l10n.secretKey),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 60),
        child: Text(
          val.isEmpty ? l10n.empty : val,
          style: UIs.textGrey,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () async {
        final ctrl = TextEditingController(text: val);
        final result = await context.showRoundDialog<String>(
          title: l10n.edit,
          child: Input(
            controller: ctrl,
            hint: 'sk-xxx',
            maxLines: 3,
          ),
          actions: Btns.oks(
            onTap: () => context.pop(ctrl.text),
          ),
        );
        if (result == null) return;
        OpenAICfg.setTo(OpenAICfg.current.copyWith(key: result));
        OpenAICfg.updateModels(force: true);
        _cfgRN.notify();
      },
    );
  }

  Widget _buildOpenAIUrl(String val) {
    return ListTile(
      leading: const Icon(Icons.link),
      title: Text(l10n.apiUrl),
      trailing: const Icon(Icons.keyboard_arrow_right),
      subtitle: Text(
        val.isEmpty ? l10n.empty : val,
        style: UIs.text13Grey,
      ),
      onTap: () async {
        final ctrl = TextEditingController(text: val);
        final result = await context.showRoundDialog<String>(
          title: l10n.edit,
          child: Input(
            controller: ctrl,
            hint: 'https://api.openai.com',
            maxLines: 3,
          ),
          actions: Btns.oks(
            onTap: () => context.pop(ctrl.text),
          ),
        );
        if (result == null) return;
        if (result.contains('/v1') || !ChatConfig.apiUrlReg.hasMatch(result)) {
          final sure = await context.showRoundDialog(
            title: l10n.attention,
            child: Text(l10n.apiUrlTip),
            actions: Btns.oks(
              onTap: () => context.pop(true),
              red: true,
            ),
          );
          if (sure != true) return;
        }
        OpenAICfg.setTo(OpenAICfg.current.copyWith(url: result));
        OpenAICfg.updateModels(force: true);
        _cfgRN.notify();
      },
    );
  }

  Widget _buildOpenAIModels(ChatConfig cfg) {
    return ValBuilder(
      listenable: OpenAICfg.models,
      builder: (models) {
        return ExpandTile(
          leading: const Icon(Icons.model_training),
          title: Text(l10n.model),
          children: [
            _buildOpenAIChatModel(),
            _buildOpenAIImgModel(),
            _buildOpenAISpeechModel(),
            // _buildOpenAITranscribeModel(),
          ],
        );
      },
    );
  }

  Future<String?> _showPickModelDialog(String title, String val) async {
    if (OpenAICfg.current.key.isEmpty) {
      context.showRoundDialog(
        title: l10n.attention,
        child: Text(l10n.needOpenAIKey),
        actions: Btns.oks(onTap: context.pop),
      );
      return null;
    }

    return context.showPickSingleDialog(
      items: OpenAICfg.models.value,
      initial: val,
      title: title,
      actions: [
        TextButton(
          onPressed: () async {
            context.pop();
            await context.showLoadingDialog(
                fn: () => OpenAICfg.updateModels(force: true));
            _showPickModelDialog(title, val);
          },
          child: Text(l10n.refresh),
        ),
        TextButton(
          onPressed: () {
            void onSave(String s) {
              context.pop();
              OpenAICfg.setTo(OpenAICfg.current.copyWith(model: s));
              _cfgRN.notify();
            }

            context.pop();
            final ctrl = TextEditingController();
            context.showRoundDialog(
              title: l10n.custom,
              child: Input(
                controller: ctrl,
                hint: kChatModel,
                onSubmitted: (s) => onSave(s),
              ),
              actions: Btns.oks(onTap: () => onSave(ctrl.text)),
            );
          },
          child: Text(l10n.custom),
        ),
      ],
    );
  }

  Widget _buildOpenAIChatModel() {
    final cfg = OpenAICfg.current;
    final val = cfg.model;
    return ListTile(
      leading: const Icon(Icons.chat),
      title: Text(l10n.chat),
      trailing: const Icon(Icons.keyboard_arrow_right),
      subtitle: Text(val, style: UIs.text13Grey),
      onTap: () async {
        final model = await _showPickModelDialog(l10n.model, val);
        if (model != null) {
          OpenAICfg.setTo(OpenAICfg.current.copyWith(model: model));
          _cfgRN.notify();
        }
      },
    );
  }

  Widget _buildOpenAIImgModel() {
    final cfg = OpenAICfg.current;
    final val = cfg.imgModel;
    return ListTile(
      leading: const Icon(Icons.photo),
      title: Text(l10n.image),
      trailing: const Icon(Icons.keyboard_arrow_right),
      subtitle: Text(val, style: UIs.text13Grey),
      onTap: () async {
        final model = await _showPickModelDialog(l10n.model, val);
        if (model != null) {
          OpenAICfg.setTo(OpenAICfg.current.copyWith(imgModel: model));
          _cfgRN.notify();
        }
      },
    );
  }

  Widget _buildOpenAISpeechModel() {
    final cfg = OpenAICfg.current;
    final val = cfg.speechModel;
    return ListTile(
      leading: const Icon(Icons.speaker),
      title: Text(l10n.tts),
      trailing: const Icon(Icons.keyboard_arrow_right),
      subtitle: Text(val, style: UIs.text13Grey),
      onTap: () async {
        final model = await _showPickModelDialog(l10n.model, val);
        if (model != null) {
          OpenAICfg.setTo(OpenAICfg.current.copyWith(speechModel: model));
          _cfgRN.notify();
        }
      },
    );
  }

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
  //         OpenAICfg.setTo(OpenAICfg.current.copyWith(transcribeModel: model));
  //         _cfgRN.notify();
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
          val.isEmpty ? l10n.empty : val,
          style: UIs.textGrey,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () async {
        final ctrl = TextEditingController(text: val);
        final result = await context.showRoundDialog<String>(
          title: l10n.edit,
          child: Input(
            controller: ctrl,
            maxLines: 3,
          ),
          actions: Btns.oks(onTap: () => context.pop(ctrl.text)),
        );
        if (result == null) return;
        OpenAICfg.setTo(OpenAICfg.current.copyWith(prompt: result));
        _cfgRN.notify();
      },
    );
  }

  Widget _buildHistoryLength(int val) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(l10n.chatHistoryLength),
      trailing: Text(
        val.toString(),
        style: UIs.text13Grey,
      ),
      subtitle: Text(l10n.chatHistoryTip, style: UIs.textGrey),
      onTap: () async {
        final ctrl = TextEditingController(text: val.toString());
        final result = await context.showRoundDialog<String>(
          title: l10n.edit,
          child: Input(
            controller: ctrl,
            hint: '7',
            type: TextInputType.number,
          ),
          actions: Btns.oks(
            onTap: () => context.pop(ctrl.text),
          ),
        );
        if (result == null) return;
        final newVal = int.tryParse(result);
        if (newVal == null) {
          context.showSnackBar('Invalid number: $result');
          return;
        }
        OpenAICfg.setTo(OpenAICfg.current.copyWith(historyLen: newVal));
        _cfgRN.notify();
      },
    );
  }

  // Widget _buildFollowChatModel() {
  //   return ListTile(
  //     leading: const Icon(OctIcons.arrow_switch, size: 21),
  //     title: Text(l10n.followChatModel),
  //     trailing: StoreSwitch(prop: Stores.config.followModel),
  //   );
  // }
}
