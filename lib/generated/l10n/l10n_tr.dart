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
