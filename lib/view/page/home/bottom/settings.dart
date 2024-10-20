part of '../home.dart';

final class _ChatSettings extends StatefulWidget {
  final ChatHistory args;

  const _ChatSettings({Key? key, required this.args});

  static const route = AppRouteArg(
    page: _ChatSettings.new,
    path: '/chat_settings',
  );

  @override
  State<_ChatSettings> createState() => _ChatSettingsState();
}

final class _ChatSettingsState extends State<_ChatSettings> {
  late final settings = (widget.args.settings ?? const ChatSettings()).vn;

  @override
  Widget build(BuildContext context) {
    final items = [
      _buildIgnoreCtxConstraint(),
      _buildUseTools(),
      _buildHeadTailMode(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${libL10n.setting} - ${widget.args.name}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _save();
          context.pop();
        },
        child: const Icon(Icons.save),
      ),
      body: ListView(
        children: items
            .map((e) => e.cardx.paddingSymmetric(vertical: 1, horizontal: 7))
            .toList(),
      ),
    );
  }

  Widget _buildIgnoreCtxConstraint() {
    return ListTile(
      title: Text(l10n.ignoreContextConstraint),
      trailing: settings.listenVal((val) {
        return Switch(
          value: val.ignoreContextConstraint,
          onChanged: (_) {
            settings.value = settings.value.copyWith(
              ignoreContextConstraint: !val.ignoreContextConstraint,
            );
            if (settings.value.headTailMode &&
                settings.value.ignoreContextConstraint) {
              settings.value = settings.value.copyWith(headTailMode: false);
            }
          },
        );
      }),
    );
  }

  Widget _buildUseTools() {
    return ListTile(
      title: Text(l10n.tool),
      trailing: settings.listenVal((val) {
        return Switch(
          value: val.useTools,
          onChanged: (_) {
            settings.value = settings.value.copyWith(useTools: !val.useTools);
          },
        );
      }),
    );
  }

  Widget _buildHeadTailMode() {
    return ListTile(
      title: TipText(l10n.headTailMode, l10n.headTailModeTip),
      trailing: settings.listenVal((val) {
        return Switch(
          value: val.headTailMode,
          onChanged: (_) {
            settings.value =
                settings.value.copyWith(headTailMode: !val.headTailMode);
            if (settings.value.headTailMode &&
                settings.value.ignoreContextConstraint) {
              settings.value =
                  settings.value.copyWith(ignoreContextConstraint: false);
            }
          },
        );
      }),
    );
  }

  void _save() {
    final newOne = widget.args.copyWith(
      settings: settings.value,
    );
    newOne.save();
    _allHistories[_curChatId] = newOne;
  }
}
