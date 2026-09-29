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
  String get deny => 'Denegar';

  @override
  String get allow => 'Permitir';

  @override
  String get allowAlways => 'Permitir siempre';

  @override
  String get trash => 'Papelera';

  @override
  String get startChatTip => 'Elige un modelo abajo y escribe algo.';

  @override
  String get camera => 'Cámara';

  @override
  String get send => 'Enviar';

  @override
  String get noProviderKey =>
      'Ningún proveedor tiene clave todavía. Añade una para empezar a chatear.';

  @override
  String get providers => 'Proveedores';

  @override
  String get regenerate => 'Regenerar';

  @override
  String get compacted => 'Los mensajes anteriores se resumieron';

  @override
  String get favorite => 'Favoritos';

  @override
  String get defaultModel => 'Modelo predeterminado';

  @override
  String get titleModel => 'Modelo para títulos';

  @override
  String get systemPrompt => 'Prompt del sistema';

  @override
  String get compaction => 'Compactar chats largos';

  @override
  String get compactionTip =>
      'Cuando un chat ya no cabe en el contexto del modelo, los mensajes anteriores se resumen para el modelo. Tú los sigues viendo todos.';

  @override
  String get customProvider => 'Proveedor personalizado';

  @override
  String get refreshModels => 'Actualizar modelos';

  @override
  String get modelsListedTip =>
      'Opcional: se obtiene la lista /models del endpoint. Añade los ID que no aparezcan.';

  @override
  String get modelsRequired =>
      'Esta API no puede listar sus modelos: introduce al menos un ID de modelo.';

  @override
  String modelsCountFmt(int n) {
    return '$n modelos';
  }

  @override
  String get sameAsChat => 'Igual que el chat';

  @override
  String get keyInKeychain =>
      'Guardada en el llavero del sistema, nunca en las copias de seguridad.';

  @override
  String get extraVars => 'Variables adicionales';

  @override
  String get extraVarsTip =>
      'Una KEY=VALUE por línea, para proveedores que necesitan algo más que una clave (recurso de Azure, cuenta de Cloudflare).';
}
