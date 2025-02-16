import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get apiUrlV1Tip => 'https://api.openai.com/v1 gibi (sondaki /v1 gerekli). Bu URL\'yi kullanmaya devam edilsin mi?';

  @override
  String get assistant => 'Asistan';

  @override
  String get attention => 'Dikkat';

  @override
  String get audio => 'Ses';

  @override
  String get auto => 'Otomatik';

  @override
  String get autoCheckUpdate => 'Güncellemeleri otomatik kontrol et';

  @override
  String get autoRmDupChat => 'Yinelenen sohbetleri otomatik sil';

  @override
  String get autoScrollBottom => 'Otomatik aşağı kaydır';

  @override
  String get backupTip => 'Lütfen yedekleme dosyanızın özel ve güvenli olduğundan emin olun!';

  @override
  String get balance => 'Bakiye';

  @override
  String get calcTokenLen => 'Token uzunluğunu hesapla';

  @override
  String get changeModelTip => 'Farklı anahtarlar farklı model listelerine erişebilir. Mekanizmayı anlamıyorsanız ve hatalar oluşuyorsa, modeli yeniden ayarlamanız önerilir.';

  @override
  String get chat => 'Sohbet';

  @override
  String get chatHistoryLength => 'Sohbet geçmişi uzunluğu';

  @override
  String get chatHistoryTip => 'Sohbet bağlamı olarak kullanılır';

  @override
  String get clickSwitch => 'Değiştirmek için tıklayın';

  @override
  String get clickToCheck => 'Kontrol etmek için tıklayın';

  @override
  String get clipboard => 'Pano';

  @override
  String get codeBlock => 'Kod bloğu';

  @override
  String get colorSeedTip => 'Bu bir renk tohumu, renk değil';

  @override
  String get compress => 'Sıkıştır';

  @override
  String get compressImgTip => 'Sohbet ve paylaşım için';

  @override
  String get contributor => 'Katkıda bulunan';

  @override
  String get copied => 'Kopyalandı';

  @override
  String get current => 'Mevcut';

  @override
  String get custom => 'Özel';

  @override
  String get day => 'gün';

  @override
  String get defaulT => 'Varsayılan';

  @override
  String delFmt(Object id, Object type) {
    return '$type ($id) silinsin mi?';
  }

  @override
  String get delete => 'Sil';

  @override
  String get deleteConfirm => 'Silmeden önce onayla';

  @override
  String get editor => 'Düzenleyici';

  @override
  String emptyFields(Object fields) {
    return '$fields boş';
  }

  @override
  String get emptyTrash => 'Geri dönüşüm kutusunu boşalt';

  @override
  String get emptyTrashTip => '==0, bir sonraki başlangıçta sil. <0 otomatik olarak silme.';

  @override
  String fileNotFound(Object file) {
    return 'Dosya ($file) bulunamadı';
  }

  @override
  String fileTooLarge(Object size) {
    return 'Dosya çok büyük: $size';
  }

  @override
  String get followChatModel => 'Sohbet modelini takip et';

  @override
  String get fontSize => 'Yazı tipi boyutu';

  @override
  String get fontSizeSettingTip => 'Sadece kod bloklarına uygulanır';

  @override
  String get freeCopy => 'Serbest kopyalama';

  @override
  String get genChatTitle => 'Sohbet başlığı oluştur';

  @override
  String get genTitle => 'Başlık oluştur';

  @override
  String get headTailMode => 'Baş-Kuyruk modu';

  @override
  String get headTailModeTip => 'Sadece `prompt + ilk kullanıcı mesajı + mevcut giriş` bağlam olarak gönderilir.\n\nBu özellikle konuşmaları çevirmek için kullanışlıdır (token tasarrufu sağlar).';

  @override
  String get help => 'Yardım';

  @override
  String get history => 'Geçmiş';

  @override
  String historyToolHelp(Object keywords) {
    return '$keywords anahtar kelimelerini içeren sohbetler bağlam olarak yüklensin mi?';
  }

  @override
  String get historyToolTip => 'Geçmiş sohbetleri bağlam olarak yükle';

  @override
  String get hour => 'saat';

  @override
  String get httpToolTip => 'HTTP isteği gerçekleştir, örneğin: içerik ara';

  @override
  String get ignoreContextConstraint => 'Bağlam kısıtlamasını yok say';

  @override
  String get ignoreTip => 'İpucunu yok say';

  @override
  String get image => 'Resim';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 İpuçları\n- Sohbet arayüzünde aşırı kaydırma (overscroll) sohbet geçmişleri arasında hızlı geçiş yapmanızı sağlar\n- Sohbet metnine uzun basarak Markdown kaynağını serbestçe seçip kopyalayabilirsiniz\n- URL şeması kullanımı [burada]($unilink) bulunabilir\n\n### 🔍 Yardım\n- GPT Box\'ta hatalar varsa, [Github Issue]($issue) kullanın\n- Telegram `@lpktg`';
  }

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
  String get migrationV1UrlTip => 'Yapılandırmanın sonuna otomatik olarak \"/v1\" eklensin mi?';

  @override
  String get minute => 'dakika';

  @override
  String get model => 'Model';

  @override
  String get modelRegExpTip => 'Model adı eşleşirse, araçlar kullanılacak';

  @override
  String get more => 'Daha fazla';

  @override
  String get multiModel => 'Çok modlu';

  @override
  String get myOtherApps => 'Diğer uygulamalarım';

  @override
  String get needOpenAIKey => 'Lütfen önce OpenAI anahtarını girin';

  @override
  String get needRestart => 'Uygulamak için yeniden başlatma gerekli';

  @override
  String get newChat => 'Yeni sohbet';

  @override
  String get noDuplication => 'Yineleme yok';

  @override
  String notSupported(Object val) {
    return '$val desteklenmiyor';
  }

  @override
  String get onMsgCome => 'Yeni mesajlar olduğunda';

  @override
  String get onSwitchChat => 'Konuşmalar arasında geçiş yaparken';

  @override
  String get onlyRestoreHistory => 'Sadece sohbet geçmişini geri yükle (API URL\'sini ve gizli anahtarı geri yükleme)';

  @override
  String get onlySyncOnLaunch => 'Sadece başlatırken senkronize et';

  @override
  String get other => 'Diğer';

  @override
  String get participant => 'Katılımcı';

  @override
  String get passwd => 'Şifre';

  @override
  String get privacy => 'Gizlilik';

  @override
  String get privacyTip => 'Bu uygulama herhangi bir bilgi toplamaz.';

  @override
  String get profile => 'Profil';

  @override
  String get promptsSettingsItem => 'Komutlar';

  @override
  String get quickShareTip => 'Mevcut yapılandırmayı hızlıca içe aktarmak için bu bağlantıyı başka bir cihazda açın.';

  @override
  String get raw => 'Ham';

  @override
  String get refresh => 'Yenile';

  @override
  String get regExp => 'Düzenli ifade';

  @override
  String get remember30s => '30 saniye hatırla';

  @override
  String get rename => 'Yeniden adlandır';

  @override
  String get replay => 'Tekrar oynat';

  @override
  String get replayTip => 'Tekrar oynatılan mesajlar ve sonraki tüm mesajlar temizlenecek.';

  @override
  String get res => 'Kaynak';

  @override
  String restoreOpenaiTip(Object url) {
    return 'Belgelendirme [burada]($url) bulunabilir';
  }

  @override
  String get rmDuplication => 'Yinelemeyi kaldır';

  @override
  String rmDuplicationFmt(Object count) {
    return '[$count] yinelenen öğeyi silmek istediğinizden emin misiniz?';
  }

  @override
  String get route => 'Rota';

  @override
  String get save => 'Kaydet';

  @override
  String get saveErrChat => 'Hatalı sohbeti kaydet';

  @override
  String get saveErrChatTip => 'Her mesajı aldıktan/gönderdikten sonra kaydet, hata olsa bile';

  @override
  String get scrollSwitchChat => 'Sohbeti değiştirmek için kaydır';

  @override
  String get search => 'Ara';

  @override
  String get secretKey => 'Gizli anahtar';

  @override
  String get share => 'Paylaş';

  @override
  String get shareFrom => 'Paylaşan';

  @override
  String get skipSameTitle => 'Yerel sohbetlerle aynı başlığa sahip sohbetleri atla';

  @override
  String get softWrap => 'Yumuşak kaydırma';

  @override
  String get stt => 'Konuşmadan metne';

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
  String get system => 'Sistem';

  @override
  String get text => 'Metin';

  @override
  String get themeColorSeed => 'Tema renk tohumu';

  @override
  String get themeMode => 'Tema modu';

  @override
  String get thirdParty => 'Üçüncü taraf';

  @override
  String get tool => 'Araç';

  @override
  String toolConfirmFmt(Object tool) {
    return '$tool aracını kullanmayı kabul ediyor musunuz?';
  }

  @override
  String get toolFinishTip => 'Araç çağrısı tamamlandı';

  @override
  String toolHttpReqHelp(Object host) {
    return 'Ağdan veri alınacak, bu sefer $host ile iletişim kurulacak';
  }

  @override
  String get toolHttpReqName => 'HTTP isteği';

  @override
  String get tts => 'Metinden konuşmaya';

  @override
  String get unsupported => 'Desteklenmiyor';

  @override
  String get untitled => 'Başlıksız';

  @override
  String get update => 'Güncelle';

  @override
  String get usage => 'Kullanım';

  @override
  String get user => 'Kullanıcı';

  @override
  String weeksAgo(Object weeks) {
    return '$weeks hafta önce';
  }

  @override
  String get wrap => 'Sarmala';
}
