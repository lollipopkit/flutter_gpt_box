import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/ext/context/snackbar.dart';
import 'package:flutter_chatgpt/core/ext/string.dart';
import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/util/platform/base.dart';
import 'package:flutter_chatgpt/data/model/app/update.dart';
import 'package:flutter_chatgpt/data/res/build.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/path.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:url_launcher/url_launcher_string.dart';

abstract final class AppUpdateIface {
  static final newestBuild = ValueNotifier<int?>(null);

  static Future<bool> _isFileAvailable(String url) async {
    try {
      final resp = await Dio().head(url);
      return resp.statusCode == 200;
    } catch (e) {
      Loggers.app.warning('HEAD update file failed', e);
      return false;
    }
  }

  static Future<void> doUpdate(BuildContext context,
      {bool force = false}) async {
    if (isWeb) return;

    await _rmDownloadApks();

    final update = await AppUpdate.fromUrl();

    final newest = update.build.last.current;
    if (newest == null) {
      Loggers.app.warning('Update not available on ${OS.type}');
      return;
    }

    newestBuild.value = newest;

    if (!force && newest <= Build.build) {
      Loggers.app.info('Update ignored: ${Build.build} >= $newest');
      return;
    }
    Loggers.app.info('Update available: $newest');

    final url = update.url.current!;

    if (url.isFileUrl && !await _isFileAvailable(url)) {
      Loggers.app.warning('Update file not available');
      return;
    }

    final min = update.build.min.current;

    final tip = 'v1.0.$newest\n${update.changelog.current}';

    if (min != null && min > Build.build) {
      context.showRoundDialog(
        child: Text(tip),
        actions: [
          TextButton(
            onPressed: () => _doUpdate(update, context),
            child: Text(l10n.ok),
          )
        ],
      );
      return;
    }

    context.showSnackBarWithAction(
      content: tip,
      action: l10n.update,
      onTap: () => _doUpdate(update, context),
    );
  }

  static Future<void> _doUpdate(AppUpdate update, BuildContext context) async {
    final url = update.url.current;
    if (url == null) {
      Loggers.app.warning('Update url not is null');
      return;
    }

    if (isAndroid) {
      final fileName = url.split('/').last;
      await RUpgrade.upgrade(url, fileName: fileName);
    } else if (isIOS) {
      await RUpgrade.upgradeFromAppStore('1586449703');
    } else {
      await launchUrlString(url);
    }
  }

  /// rmdir Download
  static Future<void> _rmDownloadApks() async {
    if (!isAndroid) return;
    final dlDir = Directory(await Paths.dl);
    if (await dlDir.exists()) {
      await dlDir.delete(recursive: true);
    }
  }
}
