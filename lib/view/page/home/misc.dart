part of 'home.dart';

const _boxShadow = [
  BoxShadow(
    color: Colors.black12,
    blurRadius: 3,
    offset: Offset(0, -0.5),
  ),
];

const _boxShadowDark = [
  BoxShadow(
    color: Colors.white12,
    blurRadius: 3,
    offset: Offset(0, -0.5),
  ),
];

class _CurrentChatSettings extends StatefulWidget {
  final ChatConfig config;

  const _CurrentChatSettings({
    required this.config,
  });

  @override
  State<StatefulWidget> createState() => _CurrentChatSettingsState();
}

class _CurrentChatSettingsState extends State<_CurrentChatSettings> {
  late var url = ValueNotifier(widget.config.url);
  late var key = ValueNotifier(widget.config.key);
  late var model = ValueNotifier(widget.config.model);
  late var prompt = ValueNotifier(widget.config.prompt);
  late var historyCount = ValueNotifier(widget.config.historyLen);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildUrl(),
        _buildKey(),
        _buildModel(),
        _buildPrompt(),
        _buildHistoryCount(),
        //_buildSeed(),
        //_buildTemperature(),
        UIs.height13,
        Row(
          children: [
            const Spacer(),
            _buildSave(),
          ],
        ),
      ],
    );
  }

  Widget _buildUrl() {
    return ValueListenableBuilder(
      valueListenable: url,
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.link),
        title: Text(l10n.apiUrl),
        subtitle:
            Text(val, style: UIs.text13Grey, maxLines: 1, softWrap: false),
        onTap: () async {
          final ctrl = TextEditingController(text: val);
          final result = await context.showRoundDialog<String>(
            title: l10n.edit,
            child: Input(
              controller: ctrl,
              hint: 'https://api.openai.com/v1',
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: Text(l10n.ok),
              ),
            ],
          );
          if (result == null) return;
          url.value = result;
          OpenAI.baseUrl = result;
        },
      ),
    );
  }

  Widget _buildKey() {
    return ValueListenableBuilder(
      valueListenable: key,
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.vpn_key),
        title: Text(l10n.secretKey),
        subtitle: Text(val, style: UIs.text13Grey, maxLines: 1),
        onTap: () async {
          final ctrl = TextEditingController(text: val);
          final result = await context.showRoundDialog<String>(
            title: l10n.edit,
            child: Input(
              controller: ctrl,
              hint: 'sk-xxx',
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: Text(l10n.ok),
              ),
            ],
          );
          if (result == null) return;
          key.value = result;
          OpenAI.apiKey = result;
        },
      ),
    );
  }

  Widget _buildModel() {
    return ValueListenableBuilder(
      valueListenable: model,
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.model_training),
        title: Text(l10n.model),
        subtitle: Text(
          val,
          style: UIs.text13Grey,
        ),
        onTap: () async {
          if (key.value.isEmpty) {
            context.showRoundDialog(title: l10n.needOpenAIKey);
            return;
          }
          context.showLoadingDialog();
          final models = await OpenAI.instance.model.list();
          context.pop();
          final modelStr = await context.showRoundDialog<String>(
            title: l10n.select,
            child: SizedBox(
              height: 300,
              width: 300,
              child: ListView.builder(
                itemCount: models.length,
                itemBuilder: (_, idx) {
                  final item = models[idx];
                  return ListTile(
                    title: Text(item.id),
                    onTap: () => context.pop(item.id),
                  );
                },
              ),
            ),
          );

          if (modelStr != null) {
            model.value = modelStr;
          }
        },
      ),
    );
  }

  Widget _buildPrompt() {
    return ValueListenableBuilder(
      valueListenable: prompt,
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.text_fields),
        title: const Text('Prompt'),
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
              hint: 'You are a efficient expert.',
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: Text(l10n.ok),
              ),
            ],
          );
          if (result == null) return;
          prompt.value = result;
        },
      ),
    );
  }

  Widget _buildHistoryCount() {
    return ValueListenableBuilder(
      valueListenable: historyCount,
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.history),
        title: Text(l10n.chatHistoryLength),
        subtitle: Text(
          val.toString(),
          style: UIs.text13Grey,
        ),
        onTap: () async {
          final ctrl = TextEditingController(text: val.toString());
          final result = await context.showRoundDialog<String>(
            title: l10n.chatHistoryLength,
            child: Input(
              controller: ctrl,
              hint: '7',
              type: TextInputType.number,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: Text(l10n.ok),
              ),
            ],
          );
          if (result == null) return;
          final newVal = int.tryParse(result);
          if (newVal == null) {
            context.showSnackBar('Invalid number: $result');
            return;
          }
          historyCount.value = newVal;
        },
      ),
    );
  }

  Widget _buildSave() {
    return TextButton(
      onPressed: () {
        final config = widget.config.copyWith(
          prompt: prompt.value,
          url: url.value,
          key: key.value,
          model: model.value,
        );
        context.pop(config);
      },
      child: Text(l10n.ok),
    );
  }
}

final class _MoreAction {
  final String title;
  final IconData icon;
  final void Function() onTap;
  final List<int> onPageIdxs;

  _MoreAction({
    required this.title,
    required this.icon,
    required this.onTap,
    this.onPageIdxs = const [],
  });
}
