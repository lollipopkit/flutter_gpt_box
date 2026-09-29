import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/model_picker.dart';
import 'package:gpt_box/view/page/settings/custom_provider.dart';
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

  /// Opens the custom provider a deep link describes, prefilled; nothing is
  /// stored until the user saves it. A link never carries a key.
  static Future<void> addFromLink(BuildContext context, Map<String, String> p) async {
    final name = p['name'], baseUrl = p['baseUrl'];
    final api = LlmApi.fromWire(p['api']) ?? LlmApi.openaiCompletions;
    final models = [
      for (final m in (p['models'] ?? '').split(',')) if (m.trim().isNotEmpty) m.trim(),
    ];
    final uri = baseUrl == null ? null : Uri.tryParse(baseUrl);
    if (name == null || uri == null || !uri.isScheme('https') && !uri.isScheme('http')) {
      Toast.show(l10n.invalidLinkFmt(p.toString()));
      return;
    }
    await CustomProviderPage.route.go(
      context,
      args: LlmCustomProvider(
        id: 'custom_${shortid.generate()}',
        name: name,
        api: api,
        baseUrl: baseUrl!,
        models: models.isEmpty ? null : models,
      ),
    );
  }

  /// Lists the models of [id] again; a failure is shown.
  static Future<void> _refreshOne(String id) async {
    final err = (await Llm.refresh(only: [id]))[id];
    if (err != null) Toast.show('${Llm.provider(id)?.name ?? id}: $err');
  }

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
        bool matches(LlmProviderInfo p) => q.isEmpty || p.name.toLowerCase().contains(q) || p.id.contains(q);
        bool pinned(LlmProviderInfo p) => p.custom || Llm.configured.value.contains(p.id);
        final all = Llm.providers.value;
        // Custom providers and the ones with a key always come first.
        final top = [
          for (final p in all) if (p.custom && matches(p)) p,
          for (final p in all) if (!p.custom && pinned(p) && matches(p)) p,
        ];
        final others = [for (final p in all) if (!pinned(p) && matches(p)) p];
        return SectionList(
          children: [
            CenterGreyTitle(l10n.model),
            _buildDefaults(),
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
              onTap: () => CustomProviderPage.route.go(context),
            ).cardx,
            if (top.isEmpty && q.isEmpty) ListTile(title: Text(l10n.noProviderKey, style: UIs.textGrey)).cardx,
            for (final p in top) _tile(p),
            if (top.isNotEmpty && others.isNotEmpty) const Divider(height: 27),
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
      trailing: p.custom ? const Icon(Icons.chevron_right) : null,
      onTap: () => p.custom ? _editCustom(p) : _editKey(p),
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

  void _editCustom(LlmProviderInfo p) {
    final spec = Stores.llm.customProviders.get()?.firstWhereOrNull((e) => e.id == p.id);
    if (spec != null) CustomProviderPage.route.go(context, args: spec);
  }
}

