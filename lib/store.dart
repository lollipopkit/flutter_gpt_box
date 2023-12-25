part of 'main.dart';

Future<void> _loadStores() async {
  await Stores.history.init();
  await Stores.setting.init();
}
