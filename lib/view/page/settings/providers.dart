import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/model_picker.dart';
import 'package:gpt_box/view/widget/section_list.dart';
import 'package:shortid/shortid.dart';

/// Providers, their keys, and which models to use by default.
///
/// The catalog is pi-ai's. A key goes into the system keychain; a provider
/// without one is listed but offers no models.
class ProvidersPage extends StatefulWidget {
  const ProvidersPage({super.key, this.embedded = false});

  /// Shown as a settings tab rather than a page of its own.
  final bool embedded;

  static const route = AppRouteNoArg(page: ProvidersPage.new, path: '/providers');

  /// Adds the custom provider a deep link describes, after asking. A link
  /// never carries a key.
  static Future<void> addFromLink(BuildContext context, Map<String, String> p) async {
    final name = p['name'], baseUrl = p['baseUrl'];
    final api = LlmApi.fromWire(p['api']) ?? LlmApi.openaiCompletions;
    final models = _splitIds(p['models'] ?? '');
    final uri = baseUrl == null ? null : Uri.tryParse(baseUrl);
    if (name == null ||
        uri == null ||
        !uri.isScheme('https') && !uri.isScheme('http') ||
        !api.listsModels && models.isEmpty) {
      Toast.show(l10n.invalidLinkFmt(p.toString()));
      return;
    }
    final ok = await context.showRoundDialog<bool>(
      title: l10n.customProvider,
      child: Text(l10n.providerLinkFmt(name, baseUrl!)),
      actions: Btnx.cancelOk,
    );
    if (ok != true) return;
    final id = 'custom_${shortid.generate()}';
    await _saveCustom([
      ...Stores.llm.customProviders.get() ?? const [],
      LlmCustomProvider(id: id, name: name, api: api, baseUrl: baseUrl, models: models.isEmpty ? null : models),
    ], id);
    if (context.mounted) await route.go(context);
  }

  /// Stores [list] and lists the models of [changed] again.
  static Future<void> _saveCustom(List<LlmCustomProvider> list, String? changed) async {
    Stores.llm.customProviders.set(list);
    await Llm.applyCustomProviders();
    if (changed != null) await _refreshOne(changed);
  }

  /// Lists the models of [id] again; a failure is shown.
  static Future<void> _refreshOne(String id) async {
    final err = (await Llm.refresh(only: [id]))[id];
    if (err != null) Toast.show('${Llm.provider(id)?.name ?? id}: $err');
  }

  static List<String> _splitIds(String s) => [
    for (final m in s.split(RegExp(r'[,\n]'))) if (m.trim().isNotEmpty) m.trim(),
  ];

  @override
  State<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends State<ProvidersPage> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = ListenableBuilder(
      listenable: Listenable.merge([Llm.providers, Llm.configured, Llm.modelErrors]),
      builder: (context, _) {
        final q = _query.text.trim().toLowerCase();
        final all = Llm.providers.value;
        final configured = [for (final p in all) if (Llm.configured.value.contains(p.id)) p];
        final others = [
          for (final p in all)
            if (!Llm.configured.value.contains(p.id) && (q.isEmpty || p.name.toLowerCase().contains(q) || p.id.contains(q)))
              p,
        ];
        return SectionList(
          children: [
            CenterGreyTitle(l10n.model),
            _buildDefaults(),
            CenterGreyTitle(libL10n.configured),
            if (configured.isEmpty) ListTile(title: Text(l10n.noProviderKey, style: UIs.textGrey)).cardx,
            for (final p in configured) _tile(p),
            CenterGreyTitle(l10n.providers),
            Input(
              controller: _query,
              hint: libL10n.search,
              icon: Icons.search,
              onChanged: (_) => setState(() {}),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(l10n.customProvider),
              onTap: () => _editCustom(null),
            ).cardx,
            for (final p in others) _tile(p),
          ],
        );
      },
    );
    if (widget.embedded) return body;
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.providers),
        actions: [
          IconButton(
            tooltip: l10n.refreshModels,
            icon: const Icon(Icons.refresh),
            onPressed: () => context.showLoadingDialog(fn: () => Llm.refresh(force: true)),
          ),
        ],
      ),
      body: body,
    );
  }

  Widget _buildDefaults() {
    String nameOf(LlmModelRef? r) => r == null ? libL10n.empty : Llm.info(r)?.name ?? r.toString();
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.auto_awesome),
          title: Text(l10n.defaultModel),
          subtitle: Text(nameOf(Llm.defaultModel), style: UIs.textGrey),
          onTap: () async {
            final m = await pickModel(context, current: Llm.defaultModel);
            if (m != null) setState(() => Stores.llm.defaultModel.set(m));
          },
        ),
        ListTile(
          leading: const Icon(Icons.title),
          title: Text(l10n.titleModel),
          subtitle: Text(
            Stores.llm.titleModel.get() == null ? l10n.sameAsChat : nameOf(Stores.llm.titleModel.get()),
            style: UIs.textGrey,
          ),
          onTap: () async {
            final m = await pickModel(context, current: Stores.llm.titleModel.get());
            if (m != null) setState(() => Stores.llm.titleModel.set(m));
          },
          onLongPress: () => setState(() => Stores.llm.titleModel.remove()),
        ),
        ListTile(
          leading: const Icon(Icons.notes),
          title: Text(l10n.systemPrompt),
          subtitle: Text(
            Stores.llm.systemPrompt.get().isEmpty ? libL10n.empty : Stores.llm.systemPrompt.get(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: UIs.textGrey,
          ),
          onTap: _editSystemPrompt,
        ),
        ListTile(
          leading: const Icon(Icons.compress),
          title: TipText(l10n.compaction, l10n.compactionTip),
          trailing: StoreSwitch(prop: Stores.llm.compaction, callback: (_) => Chats.reconfigure()),
        ),
      ],
    ).cardx;
  }

  Future<void> _editSystemPrompt() async {
    final ctrl = TextEditingController(text: Stores.llm.systemPrompt.get());
    final v = await context.showRoundDialog<String>(
      title: l10n.systemPrompt,
      child: SizedBox(width: 520, child: Input(controller: ctrl, maxLines: 12, minLines: 4, autoFocus: true)),
      actions: [Btn.ok(onTap: () => context.pop(ctrl.text))],
    );
    ctrl.dispose();
    if (v == null) return;
    Stores.llm.systemPrompt.set(v);
    await Chats.reconfigure();
    setState(() {});
  }

  Widget _tile(LlmProviderInfo p) {
    final has = Llm.configured.value.contains(p.id);
    final err = Llm.modelErrors.value[p.id];
    return ListTile(
      leading: Icon(has ? Icons.key : Icons.key_off_outlined, color: has ? UIs.primaryColor : null),
      title: Text(p.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            [if (p.custom) p.baseUrl ?? '' else p.id, l10n.modelsCountFmt(p.models.length)].join(' · '),
            style: UIs.text12Grey,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (err != null)
            Text(
              err,
              style: TextStyle(fontSize: 12, color: context.theme.colorScheme.error),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      trailing: p.custom
          ? IconButton(icon: const Icon(Icons.edit, size: 19), onPressed: () => _editCustom(p))
          : null,
      onTap: () => _editKey(p),
    ).cardx;
  }

  Future<void> _editKey(LlmProviderInfo p) async {
    final current = await Llm.readCredential(p.id);
    if (!mounted) return;
    final key = TextEditingController(text: current?.key);
    final env = TextEditingController(
      text: current?.env?.entries.map((e) => '${e.key}=${e.value}').join('\n') ?? '',
    );
    final ret = await context.showRoundDialog<String>(
      title: p.name,
      child: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Input(controller: key, label: libL10n.apiKey, obscureText: true, autoFocus: true),
            Text(l10n.keyInKeychain, style: UIs.text12Grey).paddingSymmetric(horizontal: 7),
            UIs.height13,
            Input(controller: env, label: l10n.extraVars, hint: l10n.extraVarsTip, maxLines: 4, minLines: 1),
          ],
        ),
      ),
      actions: [
        if (current != null) Btn.text(text: libL10n.delete, onTap: () => context.pop('delete')),
        Btn.ok(onTap: () => context.pop('save')),
      ],
    );
    final keyText = key.text.trim();
    final envText = env.text;
    key.dispose();
    env.dispose();
    switch (ret) {
      case 'delete':
        await Llm.setCredential(p.id, null);
      case 'save' when keyText.isNotEmpty:
        final vars = <String, String>{
          for (final line in envText.split('\n'))
            if (line.contains('=')) line.substring(0, line.indexOf('=')).trim(): line.substring(line.indexOf('=') + 1).trim(),
        };
        await Llm.setCredential(p.id, LlmCredential.apiKey(keyText, env: vars.isEmpty ? null : vars));
        // A provider that lists its models remotely does it with the key.
        await ProvidersPage._refreshOne(p.id);
    }
  }

  Future<void> _editCustom(LlmProviderInfo? info) async {
    final list = [...Stores.llm.customProviders.get() ?? const <LlmCustomProvider>[]];
    final old = info == null ? null : list.firstWhereOrNull((e) => e.id == info.id);
    final name = TextEditingController(text: old?.name);
    final url = TextEditingController(text: old?.baseUrl);
    final models = TextEditingController(text: old?.models?.join(', ') ?? '');
    var api = old?.api ?? LlmApi.openaiCompletions;
    final ret = await context.showRoundDialog<String>(
      title: l10n.customProvider,
      child: StatefulBuilder(
        builder: (context, setState) => SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Input(controller: name, label: libL10n.name, autoFocus: true),
              Input(controller: url, label: libL10n.apiEndpoint, hint: 'https://api.example.com/v1'),
              DropdownButtonFormField<LlmApi>(
                initialValue: api,
                decoration: InputDecoration(labelText: libL10n.apiProtocol),
                items: [for (final a in LlmApi.values) DropdownMenuItem(value: a, child: Text(a.wire))],
                onChanged: (v) => setState(() => api = v ?? api),
              ).paddingSymmetric(horizontal: 7),
              UIs.height13,
              Input(controller: models, label: l10n.model, hint: 'model-a, model-b'),
              Text(
                api.listsModels ? l10n.modelsListedTip : l10n.modelsRequired,
                style: UIs.text12Grey,
              ).paddingSymmetric(horizontal: 7),
            ],
          ),
        ),
      ),
      actions: [
        if (old != null) Btn.text(text: libL10n.delete, onTap: () => context.pop('delete')),
        Btn.ok(
          onTap: () {
            if (!api.listsModels && ProvidersPage._splitIds(models.text).isEmpty) {
              Toast.show(l10n.modelsRequired);
              return;
            }
            context.pop('save');
          },
        ),
      ],
    );
    final n = name.text.trim(), u = url.text.trim();
    final ms = ProvidersPage._splitIds(models.text);
    name.dispose();
    url.dispose();
    models.dispose();
    String? changed;
    if (ret == 'delete' && old != null) {
      list.removeWhere((e) => e.id == old.id);
      await Llm.setCredential(old.id, null);
    } else if (ret == 'save' && n.isNotEmpty && Uri.tryParse(u)?.hasScheme == true) {
      final next = LlmCustomProvider(
        id: old?.id ?? 'custom_${shortid.generate()}',
        name: n,
        api: api,
        baseUrl: u,
        models: ms.isEmpty ? null : ms,
      );
      changed = next.id;
      final i = list.indexWhere((e) => e.id == next.id);
      i < 0 ? list.add(next) : list[i] = next;
    } else {
      return;
    }
    if (!mounted) return;
    await context.showLoadingDialog(fn: () => ProvidersPage._saveCustom(list, changed));
  }
}

