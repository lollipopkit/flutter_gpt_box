import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/widgets.dart';
import 'package:gpt_box/data/res/build_data.dart';
import 'package:gpt_box/data/res/url.dart';

/// Checks for a newer build: GitHub's releases, and on iOS the App Store's
/// (an iOS update is the store's to give). No other platform asks the store:
/// macOS ships as a DMG from GitHub.
Future<void> checkAppUpdate(BuildContext context) => AppUpdateIface.doUpdate(
  context: context,
  githubReleasesUrl: Urls.githubReleasesApi,
  storeUrl: isIOS ? Urls.appStore : null,
  build: BuildData.build,
);
