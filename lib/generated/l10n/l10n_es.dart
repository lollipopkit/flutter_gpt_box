// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get auto => 'Automático';

  @override
  String get autoCheckUpdate => 'Comprobar actualizaciones automáticamente';

  @override
  String get backupTip =>
      '¡Por favor, asegúrese de que su archivo de respaldo sea privado y seguro!';

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
  String get emptyTrashTip =>
      '==0, eliminar en el próximo inicio. <0 no eliminar automáticamente.';

  @override
  String get genChatTitle => 'Generar título del chat';

  @override
  String get history => 'Historial';

  @override
  String get historyToolTip => 'Buscar y leer tus otros chats, sin preguntar';

  @override
  String get httpToolTip => 'Obtener páginas web y APIs';

  @override
  String get image => 'Imagen';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Enlace desconocido: $uri';
  }

  @override
  String get languageName => 'Español';

  @override
  String get license => 'Licencia';

  @override
  String get licenseMenuItem => 'Licencias de código abierto';

  @override
  String get manual => 'Manual';

  @override
  String get memory => 'Memoria';

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
  String get passwd => 'Contraseña';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacyTip => 'Esta aplicación no recopila ninguna información.';

  @override
  String get rename => 'Renombrar';

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
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n modelos',
      one: '1 modelo',
    );
    return '$_temp0';
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

  @override
  String providersCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n proveedores',
      one: '1 proveedor',
    );
    return '$_temp0';
  }

  @override
  String get today => 'Hoy';

  @override
  String get earlier => 'Anteriores';

  @override
  String get now => 'ahora';

  @override
  String minutesFmt(int n) {
    return '$n min';
  }

  @override
  String hoursFmt(int n) {
    return '$n h';
  }

  @override
  String messagesCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mensajes',
      one: '1 mensaje',
    );
    return '$_temp0';
  }

  @override
  String get thought => 'Razonamiento';

  @override
  String tokensFmt(String n) {
    return '$n tokens';
  }

  @override
  String allowToolFmt(String tool) {
    return '¿Permitir $tool?';
  }

  @override
  String get replyWaits => 'La respuesta espera tu decisión.';

  @override
  String usableModelsFmt(int n, int m) {
    return '$n disponibles · $m proveedores';
  }

  @override
  String get searchModels => 'Buscar modelos';

  @override
  String get version => 'Versión';

  @override
  String get endpoint => 'Endpoint';

  @override
  String get key => 'Clave';

  @override
  String get toolsAndMcp => 'Herramientas y MCP';

  @override
  String get useTools => 'Usar herramientas';

  @override
  String get useToolsTip =>
      'Cada llamada pregunta primero salvo que esté permitida abajo';

  @override
  String get builtIn => 'Integradas';

  @override
  String get allowedWithoutAsking => 'Permitidas sin preguntar';

  @override
  String get mcpServers => 'Servidores MCP';

  @override
  String get addServer => 'Añadir servidor';

  @override
  String connectedFmt(int n) {
    return 'Conectado · $n herramientas';
  }

  @override
  String get disconnected => 'Desconectado';

  @override
  String get deleteKey => 'Eliminar clave';

  @override
  String moreFmt(int n) {
    return '$n más';
  }

  @override
  String get back => 'Atrás';

  @override
  String get allProviders => 'Todos los proveedores';

  @override
  String get searchProviders => 'Buscar proveedores';

  @override
  String get backToChats => 'Volver a los chats';

  @override
  String get genChatTitleTip => 'Pone nombre al chat tras la primera respuesta';

  @override
  String get scrollOnNewMsg => 'Desplazar al final con cada mensaje nuevo';

  @override
  String get scrollAfterSwitch => 'Desplazar al final al cambiar de chat';

  @override
  String chatsCountFmt(int n) {
    return '$n chats';
  }

  @override
  String get emptyTrashAfter => 'Vaciar la papelera tras';

  @override
  String get trashTip => 'Los chats eliminados esperan aquí primero';

  @override
  String daysFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String thoughtForFmt(String time) {
    return 'Pensó $time';
  }

  @override
  String secondsFmt(String n) {
    return '$n s';
  }

  @override
  String minutesSecondsFmt(int m, int s) {
    return '$m min $s s';
  }

  @override
  String get attachment => 'Adjunto';

  @override
  String get sync => 'Sincronización';

  @override
  String get syncNow => 'Sincronizar ahora';

  @override
  String get syncing => 'Sincronizando…';

  @override
  String get neverSynced => 'Aún sin sincronizar';

  @override
  String lastSyncFmt(String time) {
    return 'Última sincronización: $time';
  }

  @override
  String get syncOffTip =>
      'Activa iCloud o WebDAV abajo para sincronizar automáticamente.';

  @override
  String get backupPassword => 'Contraseña de copia de seguridad';

  @override
  String get backupEncrypted => 'Las copias se cifran con ella';

  @override
  String get backupNotEncrypted =>
      'Sin definir: las copias en archivo van sin cifrar y la sincronización necesita una';

  @override
  String get backupEncryptedTip => 'Esta copia está cifrada';

  @override
  String get backupPasswordRequired =>
      'Define primero una contraseña: las copias sincronizadas siempre se cifran';

  @override
  String get passwordWrong => 'Contraseña incorrecta o copia dañada';

  @override
  String get backupTooNew =>
      'Esta copia es de una versión más nueva de la app. Actualiza para restaurarla.';

  @override
  String get syncAppSettings => 'Sincronizar ajustes de la app';

  @override
  String get syncAppSettingsTip =>
      'El tamaño de ventana y la barra de título son de cada dispositivo';

  @override
  String get webdavManualTip => 'Una copia con fecha junto a la sincronizada';

  @override
  String get exportFile => 'Exportar a un archivo';

  @override
  String get importFile => 'Restaurar desde un archivo';

  @override
  String get copyBackup => 'Copiar al portapapeles';

  @override
  String get pasteBackup => 'Restaurar desde el portapapeles';

  @override
  String get memoryView => 'Leer memoria';

  @override
  String get memorySearch => 'Buscar en la memoria';

  @override
  String get memoryWrite => 'Guardar memoria';

  @override
  String get memoryEdit => 'Editar memoria';

  @override
  String get memoryDelete => 'Eliminar memoria';

  @override
  String get memoryMove => 'Mover memoria';

  @override
  String get memoryToolTip =>
      'Archivos que el modelo conserva entre chats; los lee y escribe sin preguntar';

  @override
  String charsFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n caracteres',
      one: '1 carácter',
    );
    return '$_temp0';
  }

  @override
  String alreadyExists(String path) {
    return '$path ya existe';
  }

  @override
  String get unsavedChanges => '¿Guardar los cambios antes de salir?';

  @override
  String get discard => 'Descartar';

  @override
  String get chatSearch => 'Buscar chats';

  @override
  String get chatRead => 'Leer chat';

  @override
  String attachUnsupported(String name) {
    return 'No se puede adjuntar $name: solo imágenes y archivos de texto de hasta 512 KB';
  }

  @override
  String get replyInterrupted => 'La respuesta se interrumpió';

  @override
  String get resumeReply => 'Continuar';
}
