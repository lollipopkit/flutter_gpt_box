// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get auto => 'Otomatik';

  @override
  String get autoCheckUpdate => 'Güncellemeleri otomatik kontrol et';

  @override
  String get backupTip =>
      'Lütfen yedekleme dosyanızın özel ve güvenli olduğundan emin olun!';

  @override
  String get chat => 'Sohbet';

  @override
  String get clickToCheck => 'Kontrol etmek için tıklayın';

  @override
  String get codeBlock => 'Kod bloğu';

  @override
  String get copied => 'Kopyalandı';

  @override
  String get current => 'Mevcut';

  @override
  String delFmt(Object id, Object type) {
    return '$type ($id) silinsin mi?';
  }

  @override
  String get deleteConfirm => 'Silmeden önce onayla';

  @override
  String emptyFields(Object fields) {
    return '$fields boş';
  }

  @override
  String get emptyTrashTip =>
      '==0, bir sonraki başlangıçta sil. <0 otomatik olarak silme.';

  @override
  String get genChatTitle => 'Sohbet başlığı oluştur';

  @override
  String get image => 'Resim';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Bilinmeyen bağlantı: $uri';
  }

  @override
  String get languageName => 'Türkçe';

  @override
  String get license => 'Lisans';

  @override
  String get licenseMenuItem => 'Açık kaynak lisansları';

  @override
  String get manual => 'Manuel';

  @override
  String get more => 'Daha fazla';

  @override
  String get myOtherApps => 'Diğer uygulamalarım';

  @override
  String get newChat => 'Yeni sohbet';

  @override
  String get passwd => 'Şifre';

  @override
  String get privacy => 'Gizlilik';

  @override
  String get privacyTip => 'Bu uygulama herhangi bir bilgi toplamaz.';

  @override
  String get rename => 'Yeniden adlandır';

  @override
  String get share => 'Paylaş';

  @override
  String get shareFrom => 'Paylaşan';

  @override
  String get softWrap => 'Yumuşak kaydırma';

  @override
  String sureRestoreFmt(Object time) {
    return 'Yedeklemeyi ($time) geri yüklemek istediğinizden emin misiniz?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Çakışma: $a ve $b aynı anda etkinleştirilemez';
  }

  @override
  String get text => 'Metin';

  @override
  String get themeColorSeed => 'Tema renk tohumu';

  @override
  String get themeMode => 'Tema modu';

  @override
  String get untitled => 'Başlıksız';

  @override
  String get usage => 'Kullanım';

  @override
  String get user => 'Kullanıcı';

  @override
  String get trash => 'Çöp kutusu';

  @override
  String get startChatTip => 'Aşağıdan bir model seçip bir şey yazın.';

  @override
  String get noProviderKey =>
      'Henüz hiçbir sağlayıcının anahtarı yok. Sohbete başlamak için bir tane ekleyin.';

  @override
  String get providers => 'Sağlayıcılar';

  @override
  String get keyInKeychain =>
      'Sistem anahtar zincirinde saklanır, yedeklere asla girmez.';

  @override
  String providersCountFmt(int n) {
    return '$n sağlayıcı';
  }

  @override
  String get today => 'Bugün';

  @override
  String get earlier => 'Daha önce';

  @override
  String get now => 'şimdi';

  @override
  String minutesFmt(int n) {
    return '$n dk';
  }

  @override
  String hoursFmt(int n) {
    return '$n sa';
  }

  @override
  String messagesCountFmt(int n) {
    return '$n mesaj';
  }

  @override
  String get version => 'Sürüm';

  @override
  String get toolsAndMcp => 'Araçlar ve MCP';

  @override
  String get backToChats => 'Sohbetlere dön';

  @override
  String get genChatTitleTip => 'İlk yanıttan sonra sohbete ad verir';

  @override
  String get scrollOnNewMsg => 'Yeni mesajda en alta kaydır';

  @override
  String get scrollAfterSwitch => 'Sohbet değiştirince en alta kaydır';

  @override
  String chatsCountFmt(int n) {
    return '$n sohbet';
  }

  @override
  String get emptyTrashAfter => 'Çöp kutusunu boşaltma süresi';

  @override
  String get trashTip => 'Silinen sohbetler önce burada bekler';

  @override
  String daysFmt(int n) {
    return '$n gün';
  }

  @override
  String get sync => 'Senkronizasyon';

  @override
  String get syncNow => 'Şimdi senkronize et';

  @override
  String get syncing => 'Senkronize ediliyor…';

  @override
  String get neverSynced => 'Henüz senkronize edilmedi';

  @override
  String lastSyncFmt(String time) {
    return 'Son senkronizasyon: $time';
  }

  @override
  String get syncOffTip =>
      'Otomatik senkronizasyon için aşağıda iCloud veya WebDAV\'ı açın.';

  @override
  String get backupPassword => 'Yedek parolası';

  @override
  String get backupEncrypted => 'Yedekler bununla şifrelenir';

  @override
  String get backupNotEncrypted =>
      'Ayarlanmadı: dosya yedekleri şifresizdir ve senkronizasyon için gereklidir';

  @override
  String get backupEncryptedTip => 'Bu yedek şifreli';

  @override
  String get backupPasswordRequired =>
      'Önce bir yedek parolası ayarlayın: senkronize yedekler her zaman şifrelenir';

  @override
  String get passwordWrong => 'Yanlış parola veya yedek bozuk';

  @override
  String get backupTooNew =>
      'Bu yedek uygulamanın daha yeni bir sürümünden. Geri yüklemek için güncelleyin.';

  @override
  String get syncAppSettings => 'Uygulama ayarlarını senkronize et';

  @override
  String get syncAppSettingsTip =>
      'Pencere boyutu ve başlık çubuğu cihaza özel kalır';

  @override
  String get webdavManualTip => 'Senkronize olanın yanında tarihli bir kopya';

  @override
  String get exportFile => 'Dosyaya aktar';

  @override
  String get importFile => 'Dosyadan geri yükle';

  @override
  String get copyBackup => 'Panoya kopyala';

  @override
  String get pasteBackup => 'Panodan geri yükle';
}
