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
import 'package:gpt_box/view/widget/menu.dart';
import 'package:image_picker/image_picker.dart';

/// Where a message is written: text, attachments, the model, thinking, tools
/// and send. Makes the chat when there is none yet.
class Composer extends StatefulWidget {
  const Composer({super.key, required this.chatId, required this.onChatCreated, this.compact = false});

  /// The chat it sends to; null until the first message makes one.
  final String? chatId;
  final void Function(String id) onChatCreated;

  /// On a phone: the thinking level is an icon.
  final bool compact;

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


  Future<void> _pickFiles() => _picking(() async {
    final res = await FilePicker.pickFiles();
    return [for (final f in res) ?f.path];
  });

  Future<void> _pickImage(ImageSource source) => _picking(() async {
    final img = await ImagePicker().pickImage(source: source);
    return [?img?.path];
  });

  /// A picker's paths, attached; its failure shown rather than lost.
  Future<void> _picking(Future<List<String>> Function() pick) async {
    try {
      final paths = await pick();
      if (paths.isNotEmpty) _files.value = [..._files.value, ...paths];
    } catch (e, s) {
      Loggers.app.warning('Pick attachment', e, s);
      Toast.show('$e');
    }
  }

  /// A file on a computer; on a phone, a file, a photo or the camera.
  Widget _attachBtn() {
    Widget btn(VoidCallback onTap) => Btn.icon(icon: const Icon(Icons.attach_file, size: 19), text: l10n.attachment, onTap: onTap);
    if (!isMobile) return btn(_pickFiles);
    return MenuBtn(
      actions: [
        ContextMenuAction(text: libL10n.file, icon: Icons.insert_drive_file_outlined, onTap: _pickFiles),
        ContextMenuAction(text: l10n.image, icon: Icons.image_outlined, onTap: () => _pickImage(ImageSource.gallery)),
        ContextMenuAction(text: l10n.camera, icon: Icons.photo_camera_outlined, onTap: () => _pickImage(ImageSource.camera)),
      ],
      builder: btn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.theme.colorScheme;
    final chat = widget.chatId == null ? null : Chats.openOf(widget.chatId!);
    final running = chat?.running ?? false.vn;
    return Material(
      color: scheme.surfaceContainerLow,
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
                style: const TextStyle(fontSize: 14, height: 20 / 14),
                textInputAction: isDesktop ? TextInputAction.newline : TextInputAction.send,
                onSubmitted: isDesktop ? null : (_) => _send(),
                decoration: InputDecoration(
                  hintText: l10n.message,
                  hintStyle: UIs.textGrey.copyWith(fontSize: 14, height: 20 / 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
                ),
              ),
            ),
            Row(
              children: [
                _attachBtn(),
                Flexible(
                  child: _ModelChip(chatId: widget.chatId, model: _model, onChanged: () => setState(() {})),
                ),
                _ThinkingChip(model: _model, compact: widget.compact),
                if (widget.chatId != null) _ToolsToggle(chatId: widget.chatId!),
                const Spacer(),
                running.listenVal((r) {
                  return r
                      ? _CircleBtn(
                          icon: Icons.stop_rounded,
                          tooltip: libL10n.stop,
                          color: scheme.secondaryContainer,
                          onColor: scheme.onSecondaryContainer,
                          onTap: () => Chats.abort(widget.chatId!),
                        )
                      : _CircleBtn(
                          icon: Icons.arrow_upward,
                          tooltip: l10n.send,
                          color: scheme.primary,
                          onColor: scheme.onPrimary,
                          onTap: _send,
                        );
                }),
              ].joinWith(const SizedBox(width: 1)),
            ),
          ],
        ),
      ),
    );
  }
}


/// Send, or stop: a 40 circle at the end of the row.
class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.tooltip, required this.color, required this.onColor, required this.onTap});

  final IconData icon;
  final String tooltip;
  final Color color;
  final Color onColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(width: 40, height: 40, child: Icon(icon, size: 22, color: onColor)),
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
    final primary = context.theme.colorScheme.primary;
    return Llm.providers.listenVal((_) {
      final name = Llm.info(model)?.name ?? model?.id ?? l10n.model;
      return Btn.row(
        icon: Icon(Icons.auto_awesome, size: 18, color: primary),
        text: name,
        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: primary, overflow: TextOverflow.ellipsis),
        mainAxisSize: MainAxisSize.min,
        onTap: () async {
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
  const _ThinkingChip({required this.model, required this.compact});

  final LlmModelRef? model;
  final bool compact;

  @override
  State<_ThinkingChip> createState() => _ThinkingChipState();
}

class _ThinkingChipState extends State<_ThinkingChip> {

  static String _label(String level) => level.isEmpty ? level : level[0].toUpperCase() + level.substring(1);

  @override
  Widget build(BuildContext context) {
    if (Llm.info(widget.model)?.reasoning != true) return UIs.placeholder;
    final level = Stores.llm.thinkingLevel.get();
    final cur = _label(level);
    return MenuBtn(
      actions: [
        for (final l in ThinkingLevel.values)
          ContextMenuAction(
            text: _label(l.name),
            icon: l.name == level ? Icons.check : null,
            onTap: () async {
              await Chats.setThinkingLevel(l);
              if (mounted) setState(() {});
            },
          ),
      ],
      builder: (toggle) => widget.compact
          ? Btn.icon(
              icon: const Icon(Icons.psychology_outlined, size: 19),
              text: '${libL10n.thinking}: $cur',
              onTap: toggle,
            )
          : Btn.row(
              icon: const Icon(Icons.psychology_outlined, size: 18),
              text: cur,
              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              mainAxisSize: MainAxisSize.min,
              onTap: toggle,
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
    return Stores.mcp.enabled.listenable().listenVal((enabled) {
      if (!enabled) return UIs.placeholder;
      final on = Stores.chat.fetch(widget.chatId)?.useTools ?? true;
      return Btn.icon(
        icon: Icon(
          on ? Icons.build : Icons.build_outlined,
          size: 19,
          color: on ? context.theme.colorScheme.primary : null,
        ),
        text: l10n.tool,
        onTap: () async {
          await Chats.setUseTools(widget.chatId, !on);
          setState(() {});
        },
      );
    });
  }
}
