// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get auto => 'Otomatis';

  @override
  String get autoCheckUpdate => 'Periksa pembaruan secara otomatis';

  @override
  String get backupTip =>
      'Pastikan file cadangan Anda bersifat pribadi dan aman!';

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
  String get emptyTrashTip =>
      '==0, hapus saat mulai berikutnya. <0 jangan hapus secara otomatis.';

  @override
  String get genChatTitle => 'Buat judul obrolan';

  @override
  String get image => 'Gambar';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Tautan tidak dikenal: $uri';
  }

  @override
  String get languageName => 'Bahasa Indonesia';

  @override
  String get license => 'Lisensi';

  @override
  String get licenseMenuItem => 'Lisensi sumber terbuka';

  @override
  String get manual => 'Manual';

  @override
  String get more => 'Lainnya';

  @override
  String get myOtherApps => 'Aplikasi lain saya';

  @override
  String get newChat => 'Obrolan baru';

  @override
  String get passwd => 'Kata sandi';

  @override
  String get privacy => 'Privasi';

  @override
  String get privacyTip => 'Aplikasi ini tidak mengumpulkan informasi apa pun.';

  @override
  String get rename => 'Ubah nama';

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
  String get untitled => 'Tanpa judul';

  @override
  String get usage => 'Penggunaan';

  @override
  String get user => 'Pengguna';

  @override
  String get trash => 'Sampah';

  @override
  String get startChatTip => 'Pilih model di bawah lalu tulis sesuatu.';

  @override
  String get noProviderKey =>
      'Belum ada penyedia yang memiliki kunci. Tambahkan satu untuk mulai mengobrol.';

  @override
  String get providers => 'Penyedia';

  @override
  String get keyInKeychain =>
      'Disimpan di keychain sistem, tidak pernah di cadangan.';

  @override
  String providersCountFmt(int n) {
    return '$n penyedia';
  }

  @override
  String get today => 'Hari ini';

  @override
  String get earlier => 'Sebelumnya';

  @override
  String get now => 'baru saja';

  @override
  String minutesFmt(int n) {
    return '$n mnt';
  }

  @override
  String hoursFmt(int n) {
    return '$n jam';
  }

  @override
  String messagesCountFmt(int n) {
    return '$n pesan';
  }

  @override
  String get version => 'Versi';

  @override
  String get toolsAndMcp => 'Alat & MCP';

  @override
  String get backToChats => 'Kembali ke obrolan';

  @override
  String get genChatTitleTip => 'Memberi nama obrolan setelah balasan pertama';

  @override
  String get scrollOnNewMsg => 'Gulir ke bawah saat ada pesan baru';

  @override
  String get scrollAfterSwitch => 'Gulir ke bawah setelah berganti obrolan';

  @override
  String chatsCountFmt(int n) {
    return '$n obrolan';
  }

  @override
  String get emptyTrashAfter => 'Kosongkan sampah setelah';

  @override
  String get trashTip => 'Obrolan yang dihapus menunggu di sini dulu';

  @override
  String daysFmt(int n) {
    return '$n hari';
  }

  @override
  String get sync => 'Sinkronisasi';

  @override
  String get syncNow => 'Sinkronkan sekarang';

  @override
  String get syncing => 'Menyinkronkan…';

  @override
  String get neverSynced => 'Belum disinkronkan';

  @override
  String lastSyncFmt(String time) {
    return 'Terakhir disinkronkan $time';
  }

  @override
  String get syncOffTip =>
      'Aktifkan iCloud atau WebDAV di bawah untuk sinkronisasi otomatis.';

  @override
  String get backupPassword => 'Kata sandi cadangan';

  @override
  String get backupEncrypted => 'Cadangan dienkripsi dengannya';

  @override
  String get backupNotEncrypted =>
      'Belum diatur: cadangan berkas tidak terenkripsi, dan sinkronisasi memerlukannya';

  @override
  String get backupEncryptedTip => 'Cadangan ini terenkripsi';

  @override
  String get backupPasswordRequired =>
      'Atur kata sandi cadangan dulu: cadangan yang disinkronkan selalu dienkripsi';

  @override
  String get passwordWrong => 'Kata sandi salah, atau cadangan rusak';

  @override
  String get backupTooNew =>
      'Cadangan ini dari versi aplikasi yang lebih baru. Perbarui untuk memulihkannya.';

  @override
  String get syncAppSettings => 'Sinkronkan pengaturan aplikasi';

  @override
  String get syncAppSettingsTip =>
      'Ukuran jendela dan bilah judul tetap per perangkat';

  @override
  String get webdavManualTip =>
      'Salinan bertanggal di samping yang disinkronkan';

  @override
  String get exportFile => 'Ekspor ke berkas';

  @override
  String get importFile => 'Pulihkan dari berkas';

  @override
  String get copyBackup => 'Salin ke papan klip';

  @override
  String get pasteBackup => 'Pulihkan dari papan klip';
}
