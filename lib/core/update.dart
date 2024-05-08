import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/ext/context/base.dart';
import 'package:gpt_box/core/ext/context/dialog.dart';
import 'package:gpt_box/core/ext/context/snackbar.dart';
import 'package:gpt_box/core/ext/string.dart';
import 'package:gpt_box/core/logger.dart';
import 'package:gpt_box/core/util/platform/base.dart';
import 'package:gpt_box/data/model/app/update.dart';
import 'package:gpt_box/data/res/build.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/path.dart';
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

  static Future<void> doUpdate(
    BuildContext context, {
    bool force = false,
  }) async {
    if (isWeb) return;
    await _rmDownloadApks();

    final update = await AppUpdate.fromUrl();

    final newest = update.build.last.current;
    if (newest == null) {
      Loggers.app.warning('Update not available on ${Pfs.type}');
      return;
    }

    newestBuild.value = newest;

    if (!force && newest <= Build.build) {
      Loggers.app.info('Update ignored: ${Build.build} >= $newest');
      return;
    }
    Loggers.app.info('Update available: $newest');

    final url = update.url.current!;

    if (Pfs.needCheckFile && url.isFileUrl && !await _isFileAvailable(url)) {
      Loggers.app.warning('Update file not available');
      return;
    }

    final min = update.build.min.current;

    final tip = 'v1.0.$newest\n${update.changelog.current}';

    if (min != null && min > Build.build) {
      context.showRoundDialog(
        title: 'v1.0.$newest',
        child: Text(update.changelog.current ?? l10n.empty),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              _doUpdate(update, context);
            },
            child: Text(l10n.update),
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

    switch (Pfs.type) {
      case Pfs.android:
        final fileName = url.split('/').last;
        await RUpgrade.upgrade(url, fileName: fileName);
        break;
      case Pfs.ios || Pfs.macos:
        await RUpgrade.upgradeFromAppStore('6476033062');
        break;
      case Pfs.windows || Pfs.linux:
        await launchUrlString(url);
        break;
      case Pfs.web:
        context.showRoundDialog(
          title: l10n.attention,
          child: const Text('Please notify the administrator to update.'),
        );
        break;
      default:
        Loggers.app.warning('Update not supported on ${Pfs.type}');
        break;
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
