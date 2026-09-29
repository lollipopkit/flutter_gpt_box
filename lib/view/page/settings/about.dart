part of 'setting.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionList(
      children: [
        SettingsGroup(
          title: BuildData.name,
          rows: [
            SettingsRow(icon: Icons.tag, title: l10n.version, trailing: RowValue('v1.0.${BuildData.build}')),
            SettingsRow(
              icon: Icons.link,
              title: 'URL Scheme ${l10n.usage}',
              trailing: const RowChevron(),
              onTap: () => launchUrlString(Urls.unilinkDoc),
            ),
            SettingsRow(
              icon: Icons.description_outlined,
              title: l10n.licenseMenuItem,
              trailing: const RowChevron(),
              // Pushed like any page, so it gets the window's frame too.
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => VirtualWindowFrame(
                    child: LicensePage(applicationName: BuildData.name, applicationVersion: 'v1.0.${BuildData.build}'),
                  ),
                ),
              ),
            ),
          ],
        ),
        SettingsGroup(
          title: l10n.more,
          rows: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
              child: SimpleMarkdown(
                data: '''
${GithubId.markdownStr}

### ${l10n.myOtherApps}
[Server Box](${Urls.serverBoxRepo})

### ${l10n.privacy}
${l10n.privacyTip}

### ${l10n.license}
AGPL-3.0 lollipopkit
''',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
