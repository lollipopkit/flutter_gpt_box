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
  String get untitled => 'Sin título';

  @override
  String get usage => 'Uso';

  @override
  String get user => 'Usuario';

  @override
  String get trash => 'Papelera';

  @override
  String get startChatTip => 'Elige un modelo abajo y escribe algo.';

  @override
  String get noProviderKey =>
      'Ningún proveedor tiene clave todavía. Añade una para empezar a chatear.';

  @override
  String get providers => 'Proveedores';

  @override
  String get keyInKeychain =>
      'Guardada en el llavero del sistema, nunca en las copias de seguridad.';

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
  String get version => 'Versión';

  @override
  String get toolsAndMcp => 'Herramientas y MCP';

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
  String get pullNewChat => 'Desliza hacia abajo para un nuevo chat';

  @override
  String get releaseNewChat => 'Suelta para un nuevo chat';

  @override
  String get pullOlderChat =>
      'Desliza hacia arriba y mantén para el chat anterior';

  @override
  String holdOlderChatFmt(String title) {
    return 'Sigue manteniendo: $title';
  }
}
