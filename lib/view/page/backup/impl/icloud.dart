part of '../view.dart';

Widget _buildIcloud(BuildContext context) {
  return CardX(
    child: ListTile(
      leading: const Icon(Icons.cloud),
      title: const Text('iCloud'),
      trailing: StoreSwitch(
        prop: Stores.setting.icloudSync,
        validator: (p0) {
          if (Stores.setting.webdavSync.get() && p0) {
            context.showSnackBar(l10n.syncConflict('iCloud', 'WebDAV'));
            return false;
          }
          BakSync.instance.sync(rs: icloud);
          return true;
        },
      ),
    ),
  );
}
