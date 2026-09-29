import 'dart:convert';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_markdown_plus_latex/flutter_markdown_plus_latex.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/widget/code.dart';

/// Markdown as every message draws it.
class ChatMarkdown extends StatelessWidget {
  const ChatMarkdown(this.data, {super.key, this.forCapture = false});

  final String data;

  /// Drawn for a screenshot: nothing interactive.
  final bool forCapture;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      builders: {
        'code': CodeElementBuilder(onCopy: forCapture ? null : Pfs.copy, isForCapture: forCapture),
        'latex': LatexElementBuilder(),
      },
      styleSheet: MarkdownStyleSheet.fromTheme(context.theme).copyWith(a: TextStyle(color: UIs.primaryColor)),
      extensionSet: MarkdownUtils.extensionSet,
      onTapLink: MarkdownUtils.onLinkTap,
      selectable: isDesktop && !forCapture,
    );
  }
}

/// One entry of the branch, as the chat view draws it.
class MessageView extends StatelessWidget {
  const MessageView({super.key, required this.chat, required this.entry, this.forCapture = false});

  final OpenChat? chat;
  final LlmEntry entry;
  final bool forCapture;

  @override
  Widget build(BuildContext context) {
    switch (entry.type) {
      case 'message':
        final m = entry.message!;
        return switch (m.role) {
          'user' => _UserMessage(chat: chat, entry: entry, forCapture: forCapture),
          'assistant' => _AssistantMessage(message: m, forCapture: forCapture),
          'toolResult' => _ToolResult(message: m),
          _ => UIs.placeholder,
        };
      case 'compaction' || 'branch_summary':
        return _Summary(entry: entry);
      default:
        return UIs.placeholder;
    }
  }
}

/// A reply still being written.
class StreamingView extends StatelessWidget {
  const StreamingView({super.key, required this.reply});

  final StreamingReply reply;

  @override
  Widget build(BuildContext context) {
    return _Bubble(
      assistant: true,
      children: [
        if (reply.thinking.isNotEmpty) _Thinking(text: reply.thinking, open: reply.text.isEmpty),
        for (final t in reply.tools) _ToolChip(name: t, running: true),
        if (reply.text.isNotEmpty)
          ChatMarkdown(reply.text)
        else if (reply.thinking.isEmpty && reply.tools.isEmpty)
          const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2)),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.assistant, required this.children, this.actions});

  final bool assistant;
  final List<Widget> children;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: assistant ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: children.joinWith(UIs.height7),
    );
    final content = assistant
        ? body
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: body,
          );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      child: Column(
        crossAxisAlignment: assistant ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Align(
            alignment: assistant ? Alignment.centerLeft : Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: assistant ? double.infinity : 620),
              child: content,
            ),
          ),
          ?actions,
        ],
      ),
    );
  }
}

class _UserMessage extends StatelessWidget {
  const _UserMessage({required this.chat, required this.entry, required this.forCapture});

  final OpenChat? chat;
  final LlmEntry entry;
  final bool forCapture;

  @override
  Widget build(BuildContext context) {
    final m = entry.message!;
    final images = _imagesOf(m);
    final chat = this.chat;
    final versions = chat?.versionsOf(entry) ?? [entry];
    final idx = versions.indexWhere((e) => e.id == entry.id);
    Widget? actions;
    if (!forCapture && chat != null) {
      actions = chat.running.listenVal((running) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (versions.length > 1) ...[
              _iconBtn(Icons.chevron_left, idx > 0 && !running
                  ? () => Chats.switchTo(chat.id, versions[idx - 1])
                  : null),
              Text('${idx + 1}/${versions.length}', style: UIs.text12Grey),
              _iconBtn(Icons.chevron_right, idx < versions.length - 1 && !running
                  ? () => Chats.switchTo(chat.id, versions[idx + 1])
                  : null),
            ],
            _iconBtn(Icons.copy, () {
              Pfs.copy(m.text);
              Toast.show(l10n.copied);
            }, tip: libL10n.copy),
            if (!running) ...[
              _iconBtn(Icons.edit, () => _edit(context, chat), tip: libL10n.edit),
              _iconBtn(Icons.refresh, () => Chats.regenerate(chat.id, entry), tip: l10n.regenerate),
            ],
          ],
        );
      });
    }
    return _Bubble(
      assistant: false,
      actions: actions,
      children: [
        if (images.isNotEmpty)
          Wrap(
            spacing: 7,
            runSpacing: 7,
            alignment: WrapAlignment.end,
            children: [for (final i in images) _ImageThumb(data: i.$1, mime: i.$2)],
          ),
        if (m.text.isNotEmpty) forCapture ? Text(m.text) : SelectableText(m.text),
      ],
    );
  }

  Future<void> _edit(BuildContext context, OpenChat chat) async {
    final ctrl = TextEditingController(text: entry.message!.text);
    final text = await context.showRoundDialog<String>(
      title: libL10n.edit,
      child: SizedBox(
        width: 500,
        child: Input(controller: ctrl, maxLines: 10, minLines: 3, autoFocus: true),
      ),
      actions: [Btn.ok(onTap: () => context.pop(ctrl.text))],
    );
    ctrl.dispose();
    if (text == null || text.trim().isEmpty) return;
    await Chats.edit(chat.id, entry, text);
  }
}

class _AssistantMessage extends StatelessWidget {
  const _AssistantMessage({required this.message, required this.forCapture});

  final LlmMessage message;
  final bool forCapture;

  @override
  Widget build(BuildContext context) {
    final m = message;
    final err = m.stopReason == 'error' ? m.errorMessage : null;
    final usage = m.usage;
    return _Bubble(
      assistant: true,
      actions: forCapture || m.text.isEmpty
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _iconBtn(Icons.copy, () {
                  Pfs.copy(m.text);
                  Toast.show(l10n.copied);
                }, tip: libL10n.copy),
                if (usage != null && usage['totalTokens'] is int && usage['totalTokens'] != 0)
                  Text('${usage['totalTokens']} tokens', style: UIs.text12Grey),
              ],
            ),
      children: [
        if (m.thinking.isNotEmpty && !forCapture) _Thinking(text: m.thinking, open: false),
        for (final c in m.toolCalls) _ToolChip(name: c['name'] as String? ?? '?', running: false),
        if (m.text.isNotEmpty) ChatMarkdown(m.text, forCapture: forCapture),
        if (m.stopReason == 'aborted') Text(libL10n.stopped, style: UIs.textGrey),
        if (err != null && err.isNotEmpty)
          Text('❌ $err', style: TextStyle(color: context.theme.colorScheme.error)),
      ],
    );
  }
}

class _ToolResult extends StatelessWidget {
  const _ToolResult({required this.message});

  final LlmMessage message;

  @override
  Widget build(BuildContext context) {
    final name = message.json['toolName'] as String? ?? l10n.tool;
    final isError = message.json['isError'] == true;
    final text = message.text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
      child: ExpandTile(
        leading: Icon(isError ? Icons.error_outline : Icons.build_circle_outlined, size: 19),
        title: Text(name, style: UIs.text13Grey),
        children: [
          SelectableText(
            text.length > 20000 ? '${text.substring(0, 20000)}\n…' : text,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.entry});

  final LlmEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      child: ExpandTile(
        leading: const Icon(Icons.compress, size: 19),
        title: Text(l10n.compacted, style: UIs.text13Grey),
        children: [ChatMarkdown(entry.summary ?? '')],
      ),
    );
  }
}

class _Thinking extends StatelessWidget {
  const _Thinking({required this.text, required this.open});

  final String text;
  final bool open;

  @override
  Widget build(BuildContext context) {
    return ExpandTile(
      initiallyExpanded: open,
      leading: const Icon(Icons.psychology_outlined, size: 19),
      title: Text(libL10n.thinking, style: UIs.text13Grey),
      children: [ChatMarkdown(text)],
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({required this.name, required this.running});

  final String name;
  final bool running;

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      avatar: running
          ? const SizedBox(width: 13, height: 13, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.build, size: 15),
      label: Text(name, style: UIs.text12),
    );
  }
}

class _ImageThumb extends StatelessWidget {
  const _ImageThumb({required this.data, required this.mime});

  final String data;
  final String mime;

  @override
  Widget build(BuildContext context) {
    final bytes = base64Decode(data);
    final img = Image.memory(bytes, fit: BoxFit.cover);
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: () => showDialog<void>(
        context: context,
        builder: (ctx) => GestureDetector(
          onTap: () => Navigator.of(ctx).pop(),
          child: InteractiveViewer(child: Image.memory(bytes)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(width: 120, height: 120, child: img),
      ),
    );
  }
}

Widget _iconBtn(IconData icon, VoidCallback? onTap, {String? tip}) => IconButton(
  visualDensity: VisualDensity.compact,
  iconSize: 17,
  tooltip: tip,
  onPressed: onTap,
  icon: Icon(icon),
);

List<(String, String)> _imagesOf(LlmMessage m) {
  final c = m.json['content'];
  if (c is! List) return const [];
  return [
    for (final p in c.whereType<Map>())
      if (p['type'] == 'image') (p['data'] as String, p['mimeType'] as String? ?? 'image/png'),
  ];
}

/// The user's avatar, for the few places that show one.
String get userAvatar => Stores.setting.avatar.get();
