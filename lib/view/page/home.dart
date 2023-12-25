import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/route/page.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Home Page'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Flutter ChatGPT'),
          ),
          ListTile(
            title: const Text('Setting'),
            onTap: () {
              Routes.setting.go(context);
            },
          ),
          ListTile(
            title: const Text('chat'),
            onTap: () {
              Routes.chat.go(context);
            },
          ),
        ],
      ),
    );
  }
}
