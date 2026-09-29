// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get attention => 'Dikkat';

  @override
  String get auto => 'Otomatik';

  @override
  String get autoCheckUpdate => 'Güncellemeleri otomatik kontrol et';

  @override
  String get autoScrollBottom => 'Otomatik aşağı kaydır';

  @override
  String get backupTip =>
      'Lütfen yedekleme dosyanızın özel ve güvenli olduğundan emin olun!';

  @override
  String get calcTokenLen => 'Token uzunluğunu hesapla';

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
  String get emptyTrash => 'Geri dönüşüm kutusunu boşalt';

  @override
  String get emptyTrashTip =>
      '==0, bir sonraki başlangıçta sil. <0 otomatik olarak silme.';

  @override
  String get fontSize => 'Yazı tipi boyutu';

  @override
  String get fontSizeSettingTip => 'Sadece kod bloklarına uygulanır';

  @override
  String get genChatTitle => 'Sohbet başlığı oluştur';

  @override
  String get history => 'Geçmiş';

  @override
  String historyToolHelp(Object keywords) {
    return '$keywords anahtar kelimelerini içeren sohbetler bağlam olarak yüklensin mi?';
  }

  @override
  String get historyToolTip => 'Geçmiş sohbetleri bağlam olarak yükle';

  @override
  String get httpToolTip => 'HTTP isteği gerçekleştir, örneğin: içerik ara';

  @override
  String get image => 'Resim';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Bilinmeyen bağlantı: $uri';
  }

  @override
  String get joinBeta => 'Beta testine katıl';

  @override
  String get languageName => 'Türkçe';

  @override
  String get license => 'Lisans';

  @override
  String get licenseMenuItem => 'Açık kaynak lisansları';

  @override
  String get list => 'Liste';

  @override
  String get manual => 'Manuel';

  @override
  String get memory => 'Hafıza';

  @override
  String memoryAdded(Object str) {
    return 'Hafıza eklendi: $str';
  }

  @override
  String memoryTip(Object txt) {
    return '[$txt] hatırlansın mı?';
  }

  @override
  String get message => 'Mesaj';

  @override
  String get model => 'Model';

  @override
  String get more => 'Daha fazla';

  @override
  String get myOtherApps => 'Diğer uygulamalarım';

  @override
  String get newChat => 'Yeni sohbet';

  @override
  String get onMsgCome => 'Yeni mesajlar olduğunda';

  @override
  String get onSwitchChat => 'Konuşmalar arasında geçiş yaparken';

  @override
  String get passwd => 'Şifre';

  @override
  String get privacy => 'Gizlilik';

  @override
  String get privacyTip => 'Bu uygulama herhangi bir bilgi toplamaz.';

  @override
  String get rename => 'Yeniden adlandır';

  @override
  String get replay => 'Tekrar oynat';

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
  String get switcher => 'Değiştirici';

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
  String get tool => 'Araç';

  @override
  String toolConfirmFmt(Object tool) {
    return '$tool aracını kullanmayı kabul ediyor musunuz?';
  }

  @override
  String toolHttpReqHelp(Object host) {
    return 'Ağdan veri alınacak, bu sefer $host ile iletişim kurulacak';
  }

  @override
  String get toolHttpReqName => 'HTTP isteği';

  @override
  String get untitled => 'Başlıksız';

  @override
  String get usage => 'Kullanım';

  @override
  String get user => 'Kullanıcı';

  @override
  String get deny => 'Reddet';

  @override
  String get allow => 'İzin ver';

  @override
  String get allowAlways => 'Her zaman izin ver';

  @override
  String get trash => 'Çöp kutusu';

  @override
  String get startChatTip => 'Aşağıdan bir model seçip bir şey yazın.';

  @override
  String get camera => 'Kamera';

  @override
  String get send => 'Gönder';

  @override
  String get noProviderKey =>
      'Henüz hiçbir sağlayıcının anahtarı yok. Sohbete başlamak için bir tane ekleyin.';

  @override
  String get providers => 'Sağlayıcılar';

  @override
  String get regenerate => 'Yeniden oluştur';

  @override
  String get compacted => 'Önceki mesajlar özetlendi';

  @override
  String get favorite => 'Favoriler';

  @override
  String get defaultModel => 'Varsayılan model';

  @override
  String get titleModel => 'Başlık modeli';

  @override
  String get systemPrompt => 'Sistem istemi';

  @override
  String get compaction => 'Uzun sohbetleri sıkıştır';

  @override
  String get compactionTip =>
      'Bir sohbet modelin bağlamına artık sığmadığında, önceki mesajlar model için özetlenir. Siz hepsini görmeye devam edersiniz.';

  @override
  String get customProvider => 'Özel sağlayıcı';

  @override
  String get refreshModels => 'Modelleri yenile';

  @override
  String get modelsListedTip =>
      'İsteğe bağlı: uç noktanın /models listesi alınır. Listede olmayan kimlikleri ekleyin.';

  @override
  String get modelsRequired =>
      'Bu API modellerini listeleyemez: en az bir model kimliği girin.';

  @override
  String modelsCountFmt(int n) {
    return '$n model';
  }

  @override
  String get sameAsChat => 'Sohbetle aynı';

  @override
  String get keyInKeychain =>
      'Sistem anahtar zincirinde saklanır, yedeklere asla girmez.';

  @override
  String get extraVars => 'Ek değişkenler';

  @override
  String get extraVarsTip =>
      'Satır başına bir KEY=VALUE; anahtardan fazlasını isteyen sağlayıcılar için (Azure kaynağı, Cloudflare hesabı).';
}
