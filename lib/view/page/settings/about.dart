part of 'setting.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, Never? args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        children: [
          _buildUniLinks(),
          _buildLicense(context),
          _buildInfo(),
        ],
      ),
      bottomSheet: const Padding(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 13),
        child: Text(
          'GPT Box v${BuildData.build}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildUniLinks() {
    return CardX(
      child: ListTile(
        leading: const Icon(Icons.link),
        title: Text('URL Scheme ${l10n.usage}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => launchUrlString(Urls.unilinkDoc),
      ),
    );
  }

  Widget _buildInfo() {
    return CardX(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: SimpleMarkdown(
          data: '''
${GithubId.markdownStr}


### 💡 ${l10n.myOtherApps}
[Server Box](${Urls.serverBoxRepo}): View status & control your server


### 🗂️ ${l10n.privacy}
${l10n.privacyTip}


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
