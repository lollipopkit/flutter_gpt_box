import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/model_picker.dart';
import 'package:image_picker/image_picker.dart';

/// Where a message is written: text, attachments, the model and the send
/// button. Makes the chat when there is none yet.
class Composer extends StatefulWidget {
  const Composer({super.key, required this.chatId, required this.onChatCreated});

  /// The chat it sends to; null until the first message makes one.
  final String? chatId;
  final void Function(String id) onChatCreated;

  /// Text put in by a deep link.
  static final draft = nvn<String>();

  @override
  State<Composer> createState() => _ComposerState();
}

class _ComposerState extends State<Composer> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  final _files = <String>[].vn;

  @override
  void initState() {
    super.initState();
    Composer.draft.addListener(_takeDraft);
    _takeDraft();
  }

  @override
  void dispose() {
    Composer.draft.removeListener(_takeDraft);
    _ctrl.dispose();
    _focus.dispose();
    _files.dispose();
    super.dispose();
  }

  void _takeDraft() {
    final d = Composer.draft.value;
    if (d == null) return;
    _ctrl.text = d;
    Composer.draft.value = null;
  }

  LlmModelRef? get _model {
    final id = widget.chatId;
    return (id == null ? null : Stores.chat.fetch(id)?.model) ?? Llm.defaultModel;
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    final files = [..._files.value];
    if (text.isEmpty && files.isEmpty) return;
    if (_model == null) {
      await pickModel(context);
      return;
    }
    var id = widget.chatId;
    if (id == null) {
      id = Chats.create();
      widget.onChatCreated(id);
    }
    _ctrl.clear();
    _files.value = [];
    try {
      await Chats.send(id, text, files: files);
    } catch (e, s) {
      Loggers.app.warning('Send', e, s);
      Toast.show('$e');
    }
  }

  Future<void> _pickFiles() async {
    final res = await FilePicker.pickFiles();
    _files.value = [..._files.value, ...res.map((e) => e.path).whereType<String>()];
  }

  Future<void> _pickImage(ImageSource source) async {
    final img = await ImagePicker().pickImage(source: source);
    if (img != null) _files.value = [..._files.value, img.path];
  }

  @override
  Widget build(BuildContext context) {
    final chat = widget.chatId == null ? null : Chats.openOf(widget.chatId!);
    final running = chat?.running ?? false.vn;
    return Material(
      color: context.theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(17),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(9, 7, 9, 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _files.listenVal((files) {
              if (files.isEmpty) return UIs.placeholder;
              return Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 5,
                  children: [
                    for (final f in files)
                      InputChip(
                        label: Text(f.split(RegExp(r'[/\\]')).last, style: UIs.text12),
                        onDeleted: () => _files.value = [..._files.value]..remove(f),
                      ),
                  ],
                ),
              );
            }),
            CallbackShortcuts(
              bindings: {
                // Enter sends on a keyboard; Shift+Enter is a new line.
                if (isDesktop) const SingleActivator(LogicalKeyboardKey.enter): _send,
              },
              child: TextField(
                controller: _ctrl,
                focusNode: _focus,
                minLines: 1,
                maxLines: 8,
                textInputAction: isDesktop ? TextInputAction.newline : TextInputAction.send,
                onSubmitted: isDesktop ? null : (_) => _send(),
                decoration: InputDecoration(
                  hintText: l10n.message,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
                ),
              ),
            ),
            Row(
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.attach_file, size: 19),
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'file', child: Text(libL10n.file)),
                    if (isMobile) ...[
                      PopupMenuItem(value: 'gallery', child: Text(l10n.image)),
                      PopupMenuItem(value: 'camera', child: Text(l10n.camera)),
                    ],
                  ],
                  onSelected: (v) => switch (v) {
                    'gallery' => _pickImage(ImageSource.gallery),
                    'camera' => _pickImage(ImageSource.camera),
                    _ => _pickFiles(),
                  },
                ),
                _ModelChip(chatId: widget.chatId, model: _model, onChanged: () => setState(() {})),
                _ThinkingChip(model: _model),
                if (widget.chatId != null) _ToolsToggle(chatId: widget.chatId!),
                const Spacer(),
                running.listenVal((r) {
                  return r
                      ? IconButton.filledTonal(
                          icon: const Icon(Icons.stop),
                          tooltip: libL10n.stop,
                          onPressed: () => Chats.abort(widget.chatId!),
                        )
                      : IconButton.filled(
                          icon: const Icon(Icons.arrow_upward),
                          tooltip: l10n.send,
                          onPressed: _send,
                        );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelChip extends StatelessWidget {
  const _ModelChip({required this.chatId, required this.model, required this.onChanged});

  final String? chatId;
  final LlmModelRef? model;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Llm.providers.listenVal((_) {
      final name = Llm.info(model)?.name ?? model?.id ?? l10n.model;
      return TextButton.icon(
        icon: const Icon(Icons.auto_awesome, size: 17),
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 180),
          child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        onPressed: () async {
          final picked = await pickModel(context, current: model);
          if (picked == null) return;
          final id = chatId;
          if (id == null) {
            Stores.llm.defaultModel.set(picked);
          } else {
            await Chats.setModel(id, picked);
          }
          onChanged();
        },
      );
    });
  }
}

class _ThinkingChip extends StatefulWidget {
  const _ThinkingChip({required this.model});

  final LlmModelRef? model;

  @override
  State<_ThinkingChip> createState() => _ThinkingChipState();
}

class _ThinkingChipState extends State<_ThinkingChip> {
  @override
  Widget build(BuildContext context) {
    if (Llm.info(widget.model)?.reasoning != true) return UIs.placeholder;
    final cur = Stores.llm.thinkingLevel.get();
    return PopupMenuButton<ThinkingLevel>(
      tooltip: libL10n.thinking,
      initialValue: ThinkingLevel.values.firstWhereOrNull((e) => e.name == cur),
      itemBuilder: (_) => [
        for (final l in ThinkingLevel.values) PopupMenuItem(value: l, child: Text(l.name)),
      ],
      onSelected: (l) async {
        await Chats.setThinkingLevel(l);
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [const Icon(Icons.psychology_outlined, size: 17), UIs.width7, Text(cur, style: UIs.text13)],
        ),
      ),
    );
  }
}

class _ToolsToggle extends StatefulWidget {
  const _ToolsToggle({required this.chatId});

  final String chatId;

  @override
  State<_ToolsToggle> createState() => _ToolsToggleState();
}

class _ToolsToggleState extends State<_ToolsToggle> {
  @override
  Widget build(BuildContext context) {
    if (!Stores.mcp.enabled.get()) return UIs.placeholder;
    final on = Stores.chat.fetch(widget.chatId)?.useTools ?? true;
    return IconButton(
      tooltip: l10n.tool,
      isSelected: on,
      icon: const Icon(Icons.build_outlined, size: 19),
      selectedIcon: const Icon(Icons.build, size: 19),
      onPressed: () async {
        await Chats.setUseTools(widget.chatId, !on);
        setState(() {});
      },
    );
  }
}
