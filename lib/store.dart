part of 'main.dart';

Future<void> _loadStores() async {
  await Stores.setting.init();
}
