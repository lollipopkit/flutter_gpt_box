import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/string.dart';
import 'package:flutter_chatgpt/core/ext/widget.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/route/page.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/input.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _inputCtrl = TextEditingController();
  final _histories = <ChatHistory>[];
  final _rebuildNode = RebuildNode();
  Stream<OpenAIStreamChatCompletionModel>? _chatStream;

  bool get _isWaiting => _chatStream != null;

  @override
  void initState() {
    super.initState();
    final history = Stores.history.fetch('');
    if (history != null) {
      _histories.addAll(history);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: CustomAppBar(
        title: const Text('GPT'),
        actions: [
          IconButton(
            onPressed: () => Routes.debug.go(context),
            icon: const Icon(Icons.developer_board),
          )
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildInput(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      itemCount: _histories.length,
      itemBuilder: (_, index) {
        final last = index == _histories.length - 1;
        return _buildChatHistory(_histories[index], last);
      },
    );
  }

  Widget _buildChatHistory(ChatHistory chat, bool last) {
    return Container(
      padding: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(chat.role.name.upperFirst, style: UIs.text13Grey),
          _buildMd(last && _chatStream != null, chat),
        ],
      ),
    );
  }

  Widget _buildMd(bool cond, ChatHistory chat) {
    return cond
        ? ListenableBuilder(
            listenable: _rebuildNode,
            builder: (_, __) {
              return MarkdownBody(data: chat.toMarkdown);
            })
        : MarkdownBody(data: chat.toMarkdown);
  }

  Widget _buildInput() {
    return SafeArea(
      child: Input(
        controller: _inputCtrl,
        hint: 'Type something...',
        onSubmitted: (p0) {
          if (p0.isEmpty || _isWaiting) return;
          _histories.add(ChatHistory(
            content: [ChatContent(type: ChatContentType.text, raw: p0)],
            role: ChatRole.user,
          ));
          _inputCtrl.clear();
          _chatStream = OpenAI.instance.chat.createStream(
            model: 'gpt-3.5-turbo',
            messages: [
              _histories.last.toOpenAI,
            ],
          );
          _histories.add(ChatHistory.emptyAssist);
          setState(() {});
          _chatStream?.listen(
            (event) {
              _histories.last.content.first.raw += event.choices.first.delta.content?.first.text ?? '';
              _rebuildNode.rebuild();
            },
            onError: (e) {
              debugPrint(e);
            },
            onDone: () {
              _chatStream = null;
              Stores.history.put('', _histories);
            },
          );
        },
      ).padding(const EdgeInsets.all(7)),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text('Flutter ChatGPT'),
          ),
          ListTile(
            title: const Text('Setting'),
            onTap: () {
              Routes.setting.go(context);
            },
          ),
        ],
      ),
    );
  }
}
