// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get attention => 'Perhatian';

  @override
  String get auto => 'Otomatis';

  @override
  String get autoCheckUpdate => 'Periksa pembaruan secara otomatis';

  @override
  String get autoScrollBottom => 'Gulir ke bawah secara otomatis';

  @override
  String get backupTip =>
      'Pastikan file cadangan Anda bersifat pribadi dan aman!';

  @override
  String get calcTokenLen => 'Hitung panjang Token';

  @override
  String get chat => 'Obrolan';

  @override
  String get clickToCheck => 'Klik untuk memeriksa';

  @override
  String get codeBlock => 'Blok kode';

  @override
  String get copied => 'Disalin';

  @override
  String get current => 'Saat ini';

  @override
  String delFmt(Object id, Object type) {
    return 'Hapus $type ($id)?';
  }

  @override
  String get deleteConfirm => 'Konfirmasi sebelum menghapus';

  @override
  String emptyFields(Object fields) {
    return '$fields kosong';
  }

  @override
  String get emptyTrash => 'Kosongkan tempat sampah';

  @override
  String get emptyTrashTip =>
      '==0, hapus saat mulai berikutnya. <0 jangan hapus secara otomatis.';

  @override
  String get fontSize => 'Ukuran font';

  @override
  String get fontSizeSettingTip => 'Hanya berlaku untuk blok kode';

  @override
  String get genChatTitle => 'Buat judul obrolan';

  @override
  String get history => 'Riwayat';

  @override
  String historyToolHelp(Object keywords) {
    return 'Muat obrolan yang berisi kata kunci $keywords sebagai konteks?';
  }

  @override
  String get historyToolTip => 'Muat riwayat obrolan sebagai konteks';

  @override
  String get httpToolTip => 'Lakukan permintaan Http, contoh: cari konten';

  @override
  String get image => 'Gambar';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Tautan tidak dikenal: $uri';
  }

  @override
  String get joinBeta => 'Bergabung dengan pengujian Beta';

  @override
  String get languageName => 'Bahasa Indonesia';

  @override
  String get license => 'Lisensi';

  @override
  String get licenseMenuItem => 'Lisensi sumber terbuka';

  @override
  String get list => 'Daftar';

  @override
  String get manual => 'Manual';

  @override
  String get memory => 'Memori';

  @override
  String memoryAdded(Object str) {
    return 'Memori ditambahkan: $str';
  }

  @override
  String memoryTip(Object txt) {
    return 'Ingat [$txt]?';
  }

  @override
  String get message => 'Pesan';

  @override
  String get model => 'Model';

  @override
  String get more => 'Lainnya';

  @override
  String get myOtherApps => 'Aplikasi lain saya';

  @override
  String get newChat => 'Obrolan baru';

  @override
  String get onMsgCome => 'Ketika ada pesan baru';

  @override
  String get onSwitchChat => 'Saat beralih percakapan';

  @override
  String get passwd => 'Kata sandi';

  @override
  String get privacy => 'Privasi';

  @override
  String get privacyTip => 'Aplikasi ini tidak mengumpulkan informasi apa pun.';

  @override
  String get rename => 'Ubah nama';

  @override
  String get replay => 'Putar ulang';

  @override
  String get share => 'Bagikan';

  @override
  String get shareFrom => 'Dibagikan dari';

  @override
  String get softWrap => 'Pembungkus lunak';

  @override
  String sureRestoreFmt(Object time) {
    return 'Apakah Anda yakin ingin memulihkan cadangan ($time)?';
  }

  @override
  String get switcher => 'Pengalih';

  @override
  String syncConflict(Object a, Object b) {
    return 'Konflik: tidak dapat mengaktifkan $a dan $b secara bersamaan';
  }

  @override
  String get text => 'Teks';

  @override
  String get themeColorSeed => 'Seed warna tema';

  @override
  String get themeMode => 'Mode tema';

  @override
  String get tool => 'Alat';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Apakah Anda setuju untuk menggunakan alat $tool?';
  }

  @override
  String toolHttpReqHelp(Object host) {
    return 'Akan mengambil data dari jaringan, kali ini akan menghubungi $host';
  }

  @override
  String get toolHttpReqName => 'Permintaan Http';

  @override
  String get untitled => 'Tanpa judul';

  @override
  String get usage => 'Penggunaan';

  @override
  String get user => 'Pengguna';

  @override
  String get deny => 'Deny';

  @override
  String get allow => 'Allow';

  @override
  String get allowAlways => 'Always allow';

  @override
  String get trash => 'Trash';

  @override
  String get startChatTip => 'Pick a model below and say something.';

  @override
  String get camera => 'Camera';

  @override
  String get send => 'Send';

  @override
  String get noProviderKey =>
      'No provider has a key yet. Add one to start chatting.';

  @override
  String get providers => 'Providers';

  @override
  String get regenerate => 'Regenerate';

  @override
  String get compacted => 'Earlier messages were summarised';

  @override
  String get favorite => 'Favorites';

  @override
  String get defaultModel => 'Default model';

  @override
  String get titleModel => 'Model for titles';

  @override
  String get systemPrompt => 'System prompt';

  @override
  String get compaction => 'Compact long chats';

  @override
  String get compactionTip =>
      'When a chat no longer fits the model\'s context, earlier messages are summarised for the model. You still see all of them.';

  @override
  String get customProvider => 'Custom provider';

  @override
  String get refreshModels => 'Refresh models';

  @override
  String providerLinkFmt(String name, String url) {
    return 'Add the provider \"$name\" at $url? Its key is not in the link; you enter it yourself.';
  }

  @override
  String get modelsListedTip =>
      'Optional: the endpoint\'s /models list is fetched. Add ids it does not list.';

  @override
  String get modelsRequired =>
      'This API cannot list its models: enter at least one model id.';

  @override
  String modelsCountFmt(int n) {
    return '$n models';
  }

  @override
  String get sameAsChat => 'Same as the chat';

  @override
  String get keyInKeychain =>
      'Stored in the system keychain, never in backups.';

  @override
  String get extraVars => 'Extra variables';

  @override
  String get extraVarsTip =>
      'KEY=VALUE per line, for providers that need more than a key (Azure resource, Cloudflare account).';
}
