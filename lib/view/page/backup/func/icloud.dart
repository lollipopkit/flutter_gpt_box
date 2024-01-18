part of '../view.dart';

Widget _buildIcloud(BuildContext context) {
  return CardX(
    child: ListTile(
      leading: const Icon(Icons.cloud),
      title: const Text('iCloud'),
      trailing: StoreSwitch(
        prop: Stores.setting.icloudSync,
        callback: (val) async {
          if (val) {
            _icloudLoading.value = true;
            await ICloud.sync();
            _icloudLoading.value = false;
          }
        },
      ),
    ),
  );
}
