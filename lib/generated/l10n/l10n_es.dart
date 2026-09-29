// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get attention => 'Atención';

  @override
  String get auto => 'Automático';

  @override
  String get autoCheckUpdate => 'Comprobar actualizaciones automáticamente';

  @override
  String get autoScrollBottom => 'Desplazamiento automático hacia abajo';

  @override
  String get backupTip =>
      '¡Por favor, asegúrese de que su archivo de respaldo sea privado y seguro!';

  @override
  String get calcTokenLen => 'Calcular longitud de tokens';

  @override
  String get chat => 'Chat';

  @override
  String get clickToCheck => 'Clic para comprobar';

  @override
  String get codeBlock => 'Bloque de código';

  @override
  String get copied => 'Copiado';

  @override
  String get current => 'Actual';

  @override
  String delFmt(Object id, Object type) {
    return '¿Eliminar $type ($id)?';
  }

  @override
  String get deleteConfirm => 'Confirmar antes de eliminar';

  @override
  String emptyFields(Object fields) {
    return '$fields están vacíos';
  }

  @override
  String get emptyTrash => 'Vaciar la papelera de reciclaje';

  @override
  String get emptyTrashTip =>
      '==0, eliminar en el próximo inicio. <0 no eliminar automáticamente.';

  @override
  String get fontSize => 'Tamaño de fuente';

  @override
  String get fontSizeSettingTip => 'Solo se aplica a bloques de código';

  @override
  String get genChatTitle => 'Generar título del chat';

  @override
  String get history => 'Historial';

  @override
  String historyToolHelp(Object keywords) {
    return '¿Cargar chats que contengan las palabras clave $keywords como contexto?';
  }

  @override
  String get historyToolTip => 'Cargar chats históricos como contexto';

  @override
  String get httpToolTip =>
      'Realizar una solicitud HTTP, por ejemplo: buscar contenido';

  @override
  String get image => 'Imagen';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Enlace desconocido: $uri';
  }

  @override
  String get joinBeta => 'Unirse a la prueba Beta';

  @override
  String get languageName => 'Español';

  @override
  String get license => 'Licencia';

  @override
  String get licenseMenuItem => 'Licencias de código abierto';

  @override
  String get list => 'Lista';

  @override
  String get manual => 'Manual';

  @override
  String get memory => 'Memoria';

  @override
  String memoryAdded(Object str) {
    return 'Memoria añadida: $str';
  }

  @override
  String memoryTip(Object txt) {
    return '¿Recordar [$txt]?';
  }

  @override
  String get message => 'Mensaje';

  @override
  String get model => 'Modelo';

  @override
  String get more => 'Más';

  @override
  String get myOtherApps => 'Mis otras aplicaciones';

  @override
  String get newChat => 'Nuevo chat';

  @override
  String get onMsgCome => 'Cuando hay nuevos mensajes';

  @override
  String get onSwitchChat => 'Al cambiar de conversación';

  @override
  String get passwd => 'Contraseña';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacyTip => 'Esta aplicación no recopila ninguna información.';

  @override
  String get rename => 'Renombrar';

  @override
  String get replay => 'Repetir';

  @override
  String get share => 'Compartir';

  @override
  String get shareFrom => 'Compartido desde';

  @override
  String get softWrap => 'Ajuste de línea';

  @override
  String sureRestoreFmt(Object time) {
    return '¿Está seguro de restaurar la copia de seguridad ($time)?';
  }

  @override
  String get switcher => 'Interruptor';

  @override
  String syncConflict(Object a, Object b) {
    return 'Conflicto: no se pueden activar $a y $b al mismo tiempo';
  }

  @override
  String get text => 'Texto';

  @override
  String get themeColorSeed => 'Semilla de color del tema';

  @override
  String get themeMode => 'Modo de tema';

  @override
  String get tool => 'Herramienta';

  @override
  String toolConfirmFmt(Object tool) {
    return '¿Acepta usar la herramienta $tool?';
  }

  @override
  String toolHttpReqHelp(Object host) {
    return 'Se obtendrán datos de la red, esta vez se contactará con $host';
  }

  @override
  String get toolHttpReqName => 'Solicitud HTTP';

  @override
  String get untitled => 'Sin título';

  @override
  String get usage => 'Uso';

  @override
  String get user => 'Usuario';

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
