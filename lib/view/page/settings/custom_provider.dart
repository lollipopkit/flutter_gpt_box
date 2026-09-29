import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/settings/provider.dart';
import 'package:gpt_box/view/page/settings/providers.dart';
import 'package:gpt_box/view/widget/section_list.dart';
import 'package:shortid/shortid.dart';

/// Sets up a custom provider: its endpoint, key and models.
///
/// An OpenAI-compatible endpoint's models are listed while it is being
/// filled in; typed ids are kept beside them. Nothing is stored until saved.
class CustomProviderPage extends StatefulWidget {
  const CustomProviderPage({super.key, this.args, this.onBack});

  /// The provider to edit, or a new one prefilled (a deep link). Null starts
  /// empty.
  final LlmCustomProvider? args;

  /// Back to the list, where this is shown in its place. Pushed, the route
  /// is popped instead.
  final VoidCallback? onBack;

  static const route = AppRoute<void, LlmCustomProvider>(page: CustomProviderPage.new, path: '/providers/custom');

  @override
  State<CustomProviderPage> createState() => _CustomProviderPageState();
}

class _CustomProviderPageState extends State<CustomProviderPage> {
  late final _id = widget.args?.id ?? 'custom_${shortid.generate()}';
  late final _existing = (Stores.llm.customProviders.get() ?? const []).any((e) => e.id == _id);
  late final _name = TextEditingController(text: widget.args?.name);
  late final _url = TextEditingController(text: widget.args?.baseUrl);
  final _key = TextEditingController();
  late final _extra = TextEditingController(text: widget.args?.models?.join(', ') ?? '');
  late var _api = widget.args?.api ?? LlmApi.openaiCompletions;

  /// The stored credential's `env`, kept as it is.
  Map<String, String>? _env;

  /// What the endpoint lists: null before the first answer.
  final _listed = nvn<List<LlmModelInfo>>();
  final _listing = false.vn;
  final _listError = nvn<String>();
  Timer? _debounce;
  var _probe = 0;

  @override
  void initState() {
    super.initState();
    for (final c in [_url, _key]) {
      c.addListener(_listSoon);
    }
    if (_existing) {
      Llm.readCredential(_id).then((c) {
        if (!mounted || c == null) return;
        _env = c.env;
        _key.text = c.key ?? '';
      });
    }
    _list();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _probe++;
    for (final c in [_name, _url, _key, _extra]) {
      c.dispose();
    }
    _listed.dispose();
    _listing.dispose();
    _listError.dispose();
    super.dispose();
  }

  String get _baseUrl => _url.text.trim();

  bool get _urlValid {
    final u = Uri.tryParse(_baseUrl);
    return u != null && u.host.isNotEmpty && (u.isScheme('https') || u.isScheme('http'));
  }

  List<String> get _extraIds => [
    for (final m in _extra.text.split(RegExp(r'[,\n]'))) if (m.trim().isNotEmpty) m.trim(),
  ];

  void _listSoon() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), _list);
  }

  /// Asks the endpoint for its models. A later call supersedes an earlier one.
  Future<void> _list() async {
    final probe = ++_probe;
    if (!_api.listsModels || !_urlValid) {
      _listed.value = null;
      _listError.value = null;
      _listing.value = false;
      return;
    }
    _listing.value = true;
    try {
      final key = _key.text.trim();
      final models = await Llm.rt.listModels(
        LlmCustomProvider(id: _id, name: _id, api: _api, baseUrl: _baseUrl),
        credential: key.isEmpty ? null : LlmCredential.apiKey(key),
      );
      if (probe != _probe) return;
      _listed.value = models;
      _listError.value = null;
    } catch (e) {
      if (probe != _probe) return;
      _listed.value = null;
      _listError.value = e is LlmException ? e.message : '$e';
    } finally {
      if (probe == _probe) _listing.value = false;
    }
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty || !_urlValid) {
      Toast.show(libL10n.fail);
      return;
    }
    final extra = _extraIds;
    if (!_api.listsModels && extra.isEmpty) {
      Toast.show(l10n.modelsRequired);
      return;
    }
    final provider = LlmCustomProvider(
      id: _id,
      name: name,
      api: _api,
      baseUrl: _baseUrl,
      headers: widget.args?.headers,
      models: extra.isEmpty ? null : extra,
    );
    final list = [...Stores.llm.customProviders.get() ?? const <LlmCustomProvider>[]];
    final i = list.indexWhere((e) => e.id == _id);
    i < 0 ? list.add(provider) : list[i] = provider;

    final (_, err) = await context.showLoadingDialog(
      fn: () async {
        // An endpoint without a key (a local server) still gets a
        // credential: that is what makes a provider usable.
        await Llm.setCredential(_id, LlmCredential.apiKey(_key.text.trim(), env: _env));
        Stores.llm.customProviders.set(list);
        await Llm.applyCustomProviders();
      },
    );
    if (err != null) return;
    // Listed in the background: the page is done with it.
    unawaited(Llm.refresh(only: [_id]).then((errors) {
      if (errors[_id] case final e?) Toast.show('$name: $e');
    }, onError: (Object e, StackTrace s) => Loggers.app.warning('Refresh models', e, s)));
    if (mounted) _back();
  }

  void _back() => widget.onBack != null ? widget.onBack!() : context.pop();

  Future<void> _delete() async {
    final ok = await context.showRoundDialog<bool>(
      title: libL10n.delete,
      child: Text(libL10n.askContinue('${libL10n.delete} ${_name.text}')),
      actions: Btnx.cancelRedOk,
    );
    if (ok != true || !mounted) return;
    await context.showLoadingDialog(
      fn: () async {
        Stores.llm.customProviders.set([
          for (final e in Stores.llm.customProviders.get() ?? const <LlmCustomProvider>[])
            if (e.id != _id) e,
        ]);
        await Llm.setCredential(_id, null);
        await Llm.applyCustomProviders();
      },
    );
    if (mounted) _back();
  }

  @override
  Widget build(BuildContext context) {
    final body = SectionList(
      header: ListenableBuilder(
        listenable: Listenable.merge([_name, _url, _listed]),
        builder: (_, _) => ProviderHeader(
          title: _name.text.trim().isEmpty ? l10n.customProvider : _name.text.trim(),
          subtitle: [
            if (_baseUrl.isNotEmpty) _baseUrl,
            _api.wire,
            if (_listed.value case final m?) l10n.modelsCountFmt(m.length),
          ].join(' · '),
          onBack: _back,
          onRefresh: _api.listsModels ? _list : null,
        ),
      ),
      children: [
        SettingsGroup(
          title: l10n.endpoint,
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Input(controller: _name, label: libL10n.name, autoFocus: !_existing && _name.text.isEmpty),
              Input(controller: _url, label: libL10n.apiEndpoint, hint: 'https://api.example.com/v1'),
              DropdownButtonFormField<LlmApi>(
                initialValue: _api,
                decoration: InputDecoration(labelText: libL10n.apiProtocol, border: InputBorder.none),
                items: [for (final a in LlmApi.values) DropdownMenuItem(value: a, child: Text(a.wire))],
                onChanged: (v) {
                  if (v == null || v == _api) return;
                  setState(() => _api = v);
                  _list();
                },
              ).paddingSymmetric(horizontal: 13),
            ],
          ),
        ),
        SettingsGroup(
          title: l10n.key,
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Input(controller: _key, label: libL10n.apiKey, obscureText: true),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 0, 13, 6),
                child: Text(l10n.keyInKeychain, style: UIs.text12Grey),
              ),
            ],
          ),
        ),
        ListenableBuilder(
          listenable: Listenable.merge([_listed, _listing, _listError]),
          builder: (context, _) {
            final models = _listed.value ?? const <LlmModelInfo>[];
            final err = _listError.value;
            return SettingsGroup(
              title: '${l10n.model} · ${models.length}',
              rows: [
                if (_listing.value)
                  SettingsRow(
                    leading: const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2)),
                    title: l10n.refreshModels,
                    muted: true,
                  )
                else if (err != null)
                  SettingsRow(icon: Icons.error_outline, title: libL10n.error, error: err, trailing: Btn.text(text: libL10n.retry, onTap: _list)),
                for (final m in models)
                  SettingsRow(
                    title: m.name,
                    subtitle: modelSubtitle(m),
                    trailing: FavoriteStar(model: LlmModelRef(_id, m.id)),
                  ),
              ],
              footer: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Input(controller: _extra, label: l10n.model, hint: 'model-a, model-b', maxLines: 4, minLines: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Text(_api.listsModels ? l10n.modelsListedTip : l10n.modelsRequired, style: UIs.text12Grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_existing)
                        Btn.text(
                          text: libL10n.delete,
                          textStyle: TextStyle(color: context.theme.colorScheme.error),
                          onTap: _delete,
                        ),
                      Btn.text(text: libL10n.save, onTap: _save),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
    if (widget.onBack != null) return body;
    return Scaffold(body: SafeArea(child: body));
  }
}
