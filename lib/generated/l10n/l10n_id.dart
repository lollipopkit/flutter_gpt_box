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
  String get deny => 'Tolak';

  @override
  String get allow => 'Izinkan';

  @override
  String get allowAlways => 'Selalu izinkan';

  @override
  String get trash => 'Sampah';

  @override
  String get startChatTip => 'Pilih model di bawah lalu tulis sesuatu.';

  @override
  String get camera => 'Kamera';

  @override
  String get send => 'Kirim';

  @override
  String get noProviderKey =>
      'Belum ada penyedia yang memiliki kunci. Tambahkan satu untuk mulai mengobrol.';

  @override
  String get providers => 'Penyedia';

  @override
  String get regenerate => 'Buat ulang';

  @override
  String get compacted => 'Pesan sebelumnya telah diringkas';

  @override
  String get favorite => 'Favorit';

  @override
  String get defaultModel => 'Model bawaan';

  @override
  String get titleModel => 'Model untuk judul';

  @override
  String get systemPrompt => 'Prompt sistem';

  @override
  String get compaction => 'Padatkan obrolan panjang';

  @override
  String get compactionTip =>
      'Saat obrolan tidak lagi muat dalam konteks model, pesan sebelumnya diringkas untuk model. Anda tetap melihat semuanya.';

  @override
  String get customProvider => 'Penyedia kustom';

  @override
  String get refreshModels => 'Muat ulang model';

  @override
  String get modelsListedTip =>
      'Opsional: daftar /models dari endpoint akan diambil. Tambahkan ID yang tidak tercantum.';

  @override
  String get modelsRequired =>
      'API ini tidak dapat mencantumkan modelnya: masukkan setidaknya satu ID model.';

  @override
  String modelsCountFmt(int n) {
    return '$n model';
  }

  @override
  String get sameAsChat => 'Sama seperti obrolan';

  @override
  String get keyInKeychain =>
      'Disimpan di keychain sistem, tidak pernah di cadangan.';

  @override
  String get extraVars => 'Variabel tambahan';

  @override
  String get extraVarsTip =>
      'Satu KEY=VALUE per baris, untuk penyedia yang butuh lebih dari kunci (resource Azure, akun Cloudflare).';
}
