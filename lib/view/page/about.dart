import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/card.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, Never? args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.about, style: UIs.text18),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          children: [
            _buildInfo(),
            _buildLicense(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return CardX(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: MarkdownBody(
          data: '''
### 👋🏻 ${l10n.myOtherApps}
- [Server Box](https://github.com/lollipopkit/flutter_server_box) - View status & control your server


### 🥳 ${l10n.contributor} & ${l10n.participant}
～


### 🗂️ ${l10n.privacy}
${l10n.privacyTip}


### 😣 ${l10n.help}
${l10n.helpTip}


### 📝 ${l10n.license}
GPL v3 lollipopkit
''',
        ),
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
