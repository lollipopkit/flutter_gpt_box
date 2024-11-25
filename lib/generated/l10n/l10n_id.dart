import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get apiUrlV1Tip => 'Mirip dengan https://api.openai.com/v1 (memerlukan /v1 di akhir). Lanjutkan menggunakan URL ini?';

  @override
  String get assistant => 'Asisten';

  @override
  String get attention => 'Perhatian';

  @override
  String get audio => 'Audio';

  @override
  String get auto => 'Otomatis';

  @override
  String get autoCheckUpdate => 'Periksa pembaruan secara otomatis';

  @override
  String get autoRmDupChat => 'Hapus obrolan duplikat secara otomatis';

  @override
  String get autoScrollBottom => 'Gulir ke bawah secara otomatis';

  @override
  String get backupTip => 'Pastikan file cadangan Anda bersifat pribadi dan aman!';

  @override
  String get balance => 'Saldo';

  @override
  String get calcTokenLen => 'Hitung panjang Token';

  @override
  String get changeModelTip => 'Kunci yang berbeda mungkin dapat mengakses daftar model yang berbeda. Jika Anda tidak memahami mekanismenya dan terjadi kesalahan, disarankan untuk mengatur ulang model.';

  @override
  String get chat => 'Obrolan';

  @override
  String get chatHistoryLength => 'Panjang riwayat obrolan';

  @override
  String get chatHistoryTip => 'Digunakan sebagai konteks obrolan';

  @override
  String get clickSwitch => 'Klik untuk beralih';

  @override
  String get clickToCheck => 'Klik untuk memeriksa';

  @override
  String get clipboard => 'Papan klip';

  @override
  String get codeBlock => 'Blok kode';

  @override
  String get colorSeedTip => 'Ini adalah seed warna, bukan warna';

  @override
  String get compress => 'Kompres';

  @override
  String get compressImgTip => 'Untuk obrolan dan berbagi';

  @override
  String get contributor => 'Kontributor';

  @override
  String get copied => 'Disalin';

  @override
  String get current => 'Saat ini';

  @override
  String get custom => 'Kustom';

  @override
  String get day => 'hari';

  @override
  String get defaulT => 'Default';

  @override
  String delFmt(Object id, Object type) {
    return 'Hapus $type ($id)?';
  }

  @override
  String get delete => 'Hapus';

  @override
  String get deleteConfirm => 'Konfirmasi sebelum menghapus';

  @override
  String get editor => 'Editor';

  @override
  String emptyFields(Object fields) {
    return '$fields kosong';
  }

  @override
  String fileNotFound(Object file) {
    return 'File ($file) tidak ditemukan';
  }

  @override
  String fileTooLarge(Object size) {
    return 'File terlalu besar: $size';
  }

  @override
  String get followChatModel => 'Ikuti model obrolan';

  @override
  String get fontSize => 'Ukuran font';

  @override
  String get fontSizeSettingTip => 'Hanya berlaku untuk blok kode';

  @override
  String get freeCopy => 'Salin bebas';

  @override
  String get genChatTitle => 'Buat judul obrolan';

  @override
  String get genTitle => 'Menghasilkan judul';

  @override
  String get headTailMode => 'Mode kepala-ekor';

  @override
  String get headTailModeTip => 'Hanya mengirim `prompt + pesan pengguna pertama + input saat ini` sebagai konteks.\n\nIni sangat berguna saat menerjemahkan percakapan (menghemat token).';

  @override
  String get help => 'Bantuan';

  @override
  String get history => 'Riwayat';

  @override
  String historyToolHelp(Object keywords) {
    return 'Muat obrolan yang berisi kata kunci $keywords sebagai konteks?';
  }

  @override
  String get historyToolTip => 'Muat riwayat obrolan sebagai konteks';

  @override
  String get hour => 'jam';

  @override
  String get httpToolTip => 'Lakukan permintaan Http, contoh: cari konten';

  @override
  String get ignoreContextConstraint => 'Abaikan batasan konteks';

  @override
  String get ignoreTip => 'Abaikan petunjuk';

  @override
  String get image => 'Gambar';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 Tips\n- Menggulung berlebihan (overscroll) di antarmuka obrolan memungkinkan Anda untuk beralih cepat antara riwayat obrolan\n- Tekan lama teks obrolan untuk memilih dan menyalin sumber Markdown secara bebas\n- Penggunaan skema URL dapat ditemukan [di sini]($unilink)\n\n### 🔍 Bantuan\n- Jika GPT Box memiliki bug, gunakan [Github Issue]($issue)\n- Telegram `@lpktg`';
  }

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
  String get migrationV1UrlTip => 'Haruskah \"/v1\" ditambahkan secara otomatis di akhir konfigurasi?';

  @override
  String get minute => 'menit';

  @override
  String get model => 'Model';

  @override
  String get modelRegExpTip => 'Jika nama model cocok, Tools akan digunakan';

  @override
  String get more => 'Lainnya';

  @override
  String get multiModel => 'Multi-model';

  @override
  String get myOtherApps => 'Aplikasi lain saya';

  @override
  String get needOpenAIKey => 'Harap masukkan kunci OpenAI terlebih dahulu';

  @override
  String get needRestart => 'Perlu restart untuk menerapkan';

  @override
  String get newChat => 'Obrolan baru';

  @override
  String get noDuplication => 'Tidak ada duplikasi';

  @override
  String notSupported(Object val) {
    return '$val tidak didukung';
  }

  @override
  String get onMsgCome => 'Ketika ada pesan baru';

  @override
  String get onSwitchChat => 'Saat beralih percakapan';

  @override
  String get onlyRestoreHistory => 'Hanya pulihkan riwayat obrolan (tidak memulihkan URL API dan Kunci Rahasia)';

  @override
  String get onlySyncOnLaunch => 'Hanya sinkronkan saat peluncuran';

  @override
  String get other => 'Lainnya';

  @override
  String get participant => 'Peserta';

  @override
  String get passwd => 'Kata sandi';

  @override
  String get privacy => 'Privasi';

  @override
  String get privacyTip => 'Aplikasi ini tidak mengumpulkan informasi apa pun.';

  @override
  String get profile => 'Profil';

  @override
  String get promptsSettingsItem => 'Prompt';

  @override
  String get raw => 'Mentah';

  @override
  String get refresh => 'Segarkan';

  @override
  String get regExp => 'Ekspresi reguler';

  @override
  String get remember30s => 'Ingat selama 30 detik';

  @override
  String get rename => 'Ubah nama';

  @override
  String get replay => 'Putar ulang';

  @override
  String get replayTip => 'Pesan yang diputar ulang dan semua pesan selanjutnya akan dihapus.';

  @override
  String get res => 'Sumber daya';

  @override
  String restoreOpenaiTip(Object url) {
    return 'Dokumentasi dapat ditemukan [di sini]($url)';
  }

  @override
  String get rmDuplication => 'Hapus duplikasi';

  @override
  String rmDuplicationFmt(Object count) {
    return 'Apakah Anda yakin ingin menghapus [$count] item duplikat?';
  }

  @override
  String get route => 'Rute';

  @override
  String get save => 'Simpan';

  @override
  String get saveErrChat => 'Simpan obrolan error';

  @override
  String get saveErrChatTip => 'Simpan setelah menerima/mengirim setiap pesan, bahkan jika ada kesalahan';

  @override
  String get scrollSwitchChat => 'Gulir untuk beralih obrolan';

  @override
  String get search => 'Cari';

  @override
  String get secretKey => 'Kunci rahasia';

  @override
  String get share => 'Bagikan';

  @override
  String get shareFrom => 'Dibagikan dari';

  @override
  String get skipSameTitle => 'Lewati obrolan dengan judul yang sama dengan obrolan lokal';

  @override
  String get softWrap => 'Pembungkus lunak';

  @override
  String get stt => 'Ucapan ke teks';

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
  String get system => 'Sistem';

  @override
  String get text => 'Teks';

  @override
  String get themeColorSeed => 'Seed warna tema';

  @override
  String get themeMode => 'Mode tema';

  @override
  String get thirdParty => 'Pihak ketiga';

  @override
  String get tool => 'Alat';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Apakah Anda setuju untuk menggunakan alat $tool?';
  }

  @override
  String get toolFinishTip => 'Pemanggilan alat selesai';

  @override
  String toolHttpReqHelp(Object host) {
    return 'Akan mengambil data dari jaringan, kali ini akan menghubungi $host';
  }

  @override
  String get toolHttpReqName => 'Permintaan Http';

  @override
  String get tts => 'Teks ke ucapan';

  @override
  String get unsupported => 'Tidak didukung';

  @override
  String get untitled => 'Tanpa judul';

  @override
  String get update => 'Perbarui';

  @override
  String get usage => 'Penggunaan';

  @override
  String get user => 'Pengguna';

  @override
  String weeksAgo(Object weeks) {
    return '$weeks minggu yang lalu';
  }

  @override
  String get wrap => 'Bungkus';
}
