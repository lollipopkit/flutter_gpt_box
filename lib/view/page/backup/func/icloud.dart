part of '../view.dart';

Widget _buildIcloud(BuildContext context) {
  return CardX(
    child: ListTile(
      leading: const Icon(Icons.cloud),
      title: const Text('iCloud'),
      trailing: ListenableBuilder(
        listenable: _icloudLoading,
        builder: (_, __) {
          if (_icloudLoading.value) {
            return UIs.centerSizedLoadingSmall;
          }
          return StoreSwitch(
            prop: Stores.setting.icloudSync,
            updateLastModTime: false,
            validator: (p0) {
              if (Stores.setting.webdavSync.fetch() && p0) {
                context.showSnackBar(l10n.syncConflict('iCloud', 'WebDAV'));
                return false;
              }
              return true;
            },
            callback: (val) async {
              if (val) {
                _icloudLoading.value = true;
                await ICloud.sync();
                _icloudLoading.value = false;
              }
            },
          );
        },
      ),
    ),
  );
}
