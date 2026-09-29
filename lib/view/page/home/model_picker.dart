import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/settings/providers.dart';
import 'package:gpt_box/view/page/settings/setting.dart';
import 'package:gpt_box/view/widget/section_list.dart';

/// Picks a model among those whose provider has a key, favorites first, then
/// by provider. A dialog on a wide window, a sheet on a phone. Offers the
/// provider settings when there is nothing to pick.
Future<LlmModelRef?> pickModel(BuildContext context, {LlmModelRef? current}) async {
  if (Llm.usableModels.isEmpty) {
    final go = await context.showRoundDialog<bool>(
      title: l10n.model,
      child: Text(l10n.noProviderKey),
      actions: [Btn.ok(onTap: () => context.pop(true))],
    );
    if (go == true && context.mounted) SettingsNav.open(context, SettingsTab.providers);
    return null;
  }
  if (MediaQuery.sizeOf(context).width >= AdaptivePanes.kSplitWidth) {
    return showDialog<LlmModelRef>(
      context: context,
      builder: (ctx) => Dialog(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: CardX.borderRadius),
        child: SizedBox(width: 500, height: 580, child: _ModelSheet(current: current)),
      ),
    );
  }
  return showModalBottomSheet<LlmModelRef>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(17))),
    builder: (ctx) => SizedBox(
      height: MediaQuery.sizeOf(ctx).height * 0.78,
      child: _ModelSheet(current: current, compact: true),
    ),
  );
}

class _ModelSheet extends StatefulWidget {
  const _ModelSheet({required this.current, this.compact = false});

  final LlmModelRef? current;

  /// On a phone: a grip on top.
  final bool compact;

  @override
  State<_ModelSheet> createState() => _ModelSheetState();
}

class _ModelSheetState extends State<_ModelSheet> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.theme.colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerHigh,
      child: ListenableBuilder(
        listenable: Listenable.merge([Llm.providers, Llm.configured, Stores.llm.favoriteModels.listenable()]),
        builder: (context, _) {
          final models = Llm.usableModels;
          final favs = Stores.llm.favoriteModels.get().toSet();
          final q = _query.text.trim().toLowerCase();
          final shown = [
            for (final m in models)
              if (q.isEmpty || m.id.toLowerCase().contains(q) || m.name.toLowerCase().contains(q)) m,
          ];
          final byProvider = <String, List<LlmModelInfo>>{};
          for (final m in shown) {
            if (favs.contains(m.ref.toString())) continue;
            (byProvider[m.provider] ??= []).add(m);
          }
          final favorites = [for (final m in shown) if (favs.contains(m.ref.toString())) m];
          final providers = models.map((m) => m.provider).toSet().length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.compact)
                Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 4,
                      decoration: BoxDecoration(color: scheme.outline, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 13, 13, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            child: Text(l10n.model, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            l10n.usableModelsFmt(models.length, providers),
                            style: UIs.text12Grey.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 9),
                    Input(
                      controller: _query,
                      hint: l10n.searchModels,
                      icon: Icons.search,
                      autoFocus: isDesktop,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(7, 0, 7, 13),
                  children: [
                    if (favorites.isNotEmpty) ..._group(l10n.favorite, favorites, favs),
                    for (final MapEntry(key: pid, value: list) in byProvider.entries)
                      ..._group(Llm.provider(pid)?.name ?? pid, list, favs),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _group(String title, List<LlmModelInfo> models, Set<String> favs) => [
    GroupTitle(title, padding: const EdgeInsets.fromLTRB(10, 13, 10, 5)),
    for (final m in models) _row(m),
  ];

  Widget _row(LlmModelInfo m) {
    final scheme = context.theme.colorScheme;
    final sel = m.ref == widget.current;
    return Material(
      color: sel ? scheme.secondaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: () => Navigator.of(context).pop(m.ref),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11, 4, 3, 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: sel ? FontWeight.w500 : FontWeight.w400,
                        color: sel ? scheme.onSecondaryContainer : null,
                      ),
                    ),
                    Text(
                      modelSubtitle(m),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: UIs.text12Grey.copyWith(height: 16 / 12),
                    ),
                  ],
                ),
              ),
              if (sel) Icon(Icons.check, size: 20, color: scheme.onSecondaryContainer),
              FavoriteStar(model: m.ref),
            ],
          ),
        ),
      ),
    );
  }
}
