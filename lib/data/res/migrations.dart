import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/widgets.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';

abstract final class MigrationFns {
  /// Append '/v1' to the end of the url if the last version is less than 314.
  ///
  /// Passthrough if the url ends with '/v1'.
  ///
  /// It requires [context] to show a dialog to ask for user confirmation.
  static Future<void> appendV1ToUrl(int lastVer, int now,
      {BuildContext? context}) async {
    if (lastVer >= 314) return;

    var userConfirm = false;
    final cfgs = Stores.config.fetchAll();
    for (final key in cfgs.keys) {
      final cfg = cfgs[key];
      if (cfg == null) continue;
      if (!userConfirm) {
        userConfirm =
            await context?.showMigrationDialog(l10n.migrationV1UrlTip) ?? true;
        if (!userConfirm) return;
      }
      if (cfg.url.endsWith('/v1')) continue;
      final newCfg = cfg.copyWith(
        url: cfg.url.endsWith('/') ? '${cfg.url}v1' : '${cfg.url}/v1',
      );
      Stores.config.put(newCfg);
      dprint('Migration: append /v1 to ${cfg.url}');
    }
  }
}
