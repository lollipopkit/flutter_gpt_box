import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/util/sync.dart';
import 'package:gpt_box/data/model/app/backup.dart';
import 'package:gpt_box/data/model/chat/gpt_next.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/data/model/chat/openai.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/url.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/home.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gpt_box/view/page/settings/setting.dart';
import 'package:icons_plus/icons_plus.dart';

part 'impl/file.dart';
part 'impl/webdav.dart';
part 'impl/icloud.dart';
part 'impl/gpt_next.dart';
part 'impl/openai.dart';
part 'impl/shared.dart';

final _webdavLoading = ValueNotifier(false);

final class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(17),
      children: [
        _buildTip(),
        //_buildTitle(l10n.settings),
        const CenterGreyTitle('App'),
        if (isMacOS || isIOS) _buildIcloud(context),
        if (!isWeb) _buildWebdav(context),
        _buildFile(context),
        CenterGreyTitle(l10n.thirdParty),
        _buildGPTNext(context),
        _buildOpenAI(context),
      ],
    );
  }

  Widget _buildTip() {
    return CardX(
      child: ListTile(
        leading: const Icon(Icons.warning),
        title: Text(l10n.attention),
        subtitle: Text(l10n.backupTip, style: UIs.textGrey),
      ),
    );
  }
}
