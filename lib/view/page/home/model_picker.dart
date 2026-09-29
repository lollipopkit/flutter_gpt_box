import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/settings/providers.dart';

/// Picks a model among those whose provider has a key, grouped by provider,
/// favorites first. Offers the provider settings when there is none.
Future<LlmModelRef?> pickModel(BuildContext context, {LlmModelRef? current}) async {
  final models = Llm.usableModels;
  if (models.isEmpty) {
    final go = await context.showRoundDialog<bool>(
      title: l10n.model,
      child: Text(l10n.noProviderKey),
      actions: [Btn.ok(onTap: () => context.pop(true))],
    );
    if (go == true && context.mounted) await ProvidersPage.route.go(context);
    return null;
  }
  return showModalBottomSheet<LlmModelRef>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _ModelSheet(models: models, current: current),
  );
}

class _ModelSheet extends StatefulWidget {
  const _ModelSheet({required this.models, required this.current});

  final List<LlmModelInfo> models;
  final LlmModelRef? current;

  @override
  State<_ModelSheet> createState() => _ModelSheetState();
}

class _ModelSheetState extends State<_ModelSheet> {
  final _query = TextEditingController();
  late final _fav = Stores.llm.favoriteModels.get().toSet();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.text.trim().toLowerCase();
    final shown = [
      for (final m in widget.models)
        if (q.isEmpty || m.id.toLowerCase().contains(q) || m.name.toLowerCase().contains(q)) m,
    ];
    final favorites = [for (final m in shown) if (_fav.contains(m.ref.toString())) m];
    final byProvider = <String, List<LlmModelInfo>>{};
    for (final m in shown) {
      if (_fav.contains(m.ref.toString())) continue;
      (byProvider[m.provider] ??= []).add(m);
    }
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (_, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 13, 13, 7),
            child: Input(
              controller: _query,
              hint: libL10n.search,
              icon: Icons.search,
              autoFocus: isDesktop,
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView(
              controller: scroll,
              children: [
                if (favorites.isNotEmpty) ...[
                  _header(context, l10n.favorite),
                  for (final m in favorites) _tile(m),
                ],
                for (final MapEntry(key: pid, value: list) in byProvider.entries) ...[
                  _header(context, Llm.provider(pid)?.name ?? pid),
                  for (final m in list) _tile(m),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(17, 13, 17, 5),
    child: Text(text, style: UIs.textGrey),
  );

  Widget _tile(LlmModelInfo m) {
    final key = m.ref.toString();
    final fav = _fav.contains(key);
    final ctx = m.contextWindow >= 1000 ? '${(m.contextWindow / 1000).round()}K' : '${m.contextWindow}';
    return ListTile(
      selected: m.ref == widget.current,
      title: Text(m.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [m.id, ctx, if (m.reasoning) libL10n.thinking, if (m.imageInput) l10n.image].join(' · '),
        style: UIs.text12Grey,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(fav ? Icons.star : Icons.star_border, size: 19),
        onPressed: () {
          setState(() => fav ? _fav.remove(key) : _fav.add(key));
          Stores.llm.favoriteModels.set([..._fav]);
        },
      ),
      onTap: () => Navigator.of(context).pop(m.ref),
    );
  }
}
