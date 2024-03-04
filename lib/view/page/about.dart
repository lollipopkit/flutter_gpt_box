import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/data/res/github_id.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/card.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
            _buildUniLinks(),
            _buildLicense(context),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildUniLinks() {
    return CardX(child: ListTile(
      leading: const Icon(Icons.link),
      title: Text('URL Scheme ${l10n.usage}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => launchUrlString(
          'https://github.com/lollipopkit/flutter_gpt_box/blob/main/doc/uni_link.md'),
    ));
  }

  Widget _buildInfo() {
    return CardX(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: MarkdownBody(
          data: '''
### 👋🏻 ${l10n.myOtherApps}
- [Server Box](https://github.com/lollipopkit/flutter_server_box): View status & control your server


### 🥳 ${l10n.contributor} & ${l10n.participant}
${GithubId.markdownStr}


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
        title: Text(l10n.licenseMenuItem),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => showLicensePage(context: context),
      ),
    );
  }
}
