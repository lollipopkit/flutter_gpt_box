import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/ext/context/snackbar.dart';
import 'package:flutter_chatgpt/core/ext/widget.dart';
import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/util/platform/file.dart';
import 'package:flutter_chatgpt/core/util/ui.dart';
import 'package:flutter_chatgpt/data/model/app/backup.dart';
import 'package:flutter_chatgpt/data/model/chat/gpt_next.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
import 'package:flutter_chatgpt/data/model/chat/openai.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/data/res/url.dart';
import 'package:flutter_chatgpt/view/page/home/home.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/card.dart';
import 'package:flutter_chatgpt/view/widget/expand_tile.dart';
import 'package:flutter_chatgpt/view/widget/markdown.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../core/util/platform/base.dart';
import '../../../core/util/sync/icloud.dart';
import '../../../core/util/sync/webdav.dart';
import '../../../data/res/path.dart';
import '../../../data/store/all.dart';
import '../../widget/input.dart';
import '../../widget/switch.dart';

part 'impl/file.dart';
part 'impl/webdav.dart';
part 'impl/icloud.dart';
part 'impl/gpt_next.dart';
part 'impl/openai.dart';

final _webdavLoading = ValueNotifier(false);

typedef BackupPageRet = ({bool isRestoreSuc});

final class BackupPage extends StatelessWidget {
  const BackupPage({super.key, Never? args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.backup),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(17),
      children: [
        _buildTip(),
        //_buildTitle(l10n.settings),
        _buildSettings(context),
        _buildTitle('App'),
        if (isMacOS || isIOS) _buildIcloud(context),
        if (!isWeb) _buildWebdav(context),
        _buildFile(context),
        _buildTitle(l10n.thirdParty),
        _buildGPTNext(context),
        _buildOpenAI(context),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: UIs.textGrey,
        ),
      ),
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

  Widget _buildSettings(BuildContext context) {
    return CardX(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(MingCute.refresh_3_line),
            title: Text(l10n.onlySyncOnLaunch),
            trailing: StoreSwitch(prop: Stores.setting.onlySyncOnLaunch),
          ),
        ],
      ),
    );
  }
}
