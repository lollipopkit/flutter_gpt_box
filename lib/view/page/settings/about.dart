part of 'setting.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, Never? args});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      children: [
        UIs.height13,
        const Text(
          'GPT Box v${Build.build}',
          textAlign: TextAlign.center,
        ),
        UIs.height13,
        _buildUniLinks(),
        _buildLicense(context),
        _buildInfo(),
      ],
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
