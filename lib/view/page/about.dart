import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/card.dart';
import 'package:flutter_chatgpt/view/widget/expand_tile.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, Never? args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.about),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          children: [
            _buildMyOtherApps(),
            _buildOther(),
            _buildLicense(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMyOtherApps() {
    return CardX(
      child: ExpandTile(
        initiallyExpanded: true,
        title: Text(l10n.myOtherApps),
        leading: const Icon(Icons.apps),
        children: [
          ListTile(
            title: const Text('Server Box'),
            subtitle: const Text('View status & control your server'),
            onTap: () => launchUrlString('https://gptbox.com'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildOther() {
    return CardX(
      child: ExpandTile(
        initiallyExpanded: true,
        leading: const Icon(Icons.more, size: 19),
        title: Text(l10n.other),
        children: [
          Padding(
            padding: const EdgeInsets.all(11),
            child: MarkdownBody(
              data: '''
### 🥳 ${l10n.contributor}
～

### 🙌🏻 ${l10n.participant}
～

### 🗂️ ${l10n.privacy}
${l10n.privacyTip}

### 📝 ${l10n.license}
GPL v3 lollipopkit
''',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLicense(BuildContext context) {
    return CardX(
      child: ListTile(
        leading: const Icon(Icons.description),
        title: Text('${l10n.license} of libs'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => showLicensePage(context: context),
      ),
    );
  }
}
