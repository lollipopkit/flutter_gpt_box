import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get apiUrlV1Tip => 'Similar a https://api.openai.com/v1 (requiriendo el /v1 final). ¿Continuar usando esta URL?';

  @override
  String get assistant => 'Asistente';

  @override
  String get attention => 'Atención';

  @override
  String get audio => 'Audio';

  @override
  String get auto => 'Automático';

  @override
  String get autoCheckUpdate => 'Comprobar actualizaciones automáticamente';

  @override
  String get autoRmDupChat => 'Eliminar chats duplicados automáticamente';

  @override
  String get autoScrollBottom => 'Desplazamiento automático hacia abajo';

  @override
  String get backupTip => '¡Por favor, asegúrese de que su archivo de respaldo sea privado y seguro!';

  @override
  String get balance => 'Saldo';

  @override
  String get calcTokenLen => 'Calcular longitud de tokens';

  @override
  String get changeModelTip => 'Diferentes claves pueden acceder a diferentes listas de modelos. Si no entiendes el mecanismo y ocurren errores, se recomienda reconfigurar el modelo.';

  @override
  String get chat => 'Chat';

  @override
  String get chatHistoryLength => 'Longitud del historial de chat';

  @override
  String get chatHistoryTip => 'Se usa como contexto del chat';

  @override
  String get clickSwitch => 'Clic para cambiar';

  @override
  String get clickToCheck => 'Clic para comprobar';

  @override
  String get clipboard => 'Portapapeles';

  @override
  String get codeBlock => 'Bloque de código';

  @override
  String get colorSeedTip => 'Esto es una semilla de color, no un color';

  @override
  String get compress => 'Comprimir';

  @override
  String get compressImgTip => 'Para chat y compartir';

  @override
  String get contributor => 'Colaborador';

  @override
  String get copied => 'Copiado';

  @override
  String get current => 'Actual';

  @override
  String get custom => 'Personalizado';

  @override
  String get day => 'día';

  @override
  String get defaulT => 'Predeterminado';

  @override
  String delFmt(Object id, Object type) {
    return '¿Eliminar $type ($id)?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteConfirm => 'Confirmar antes de eliminar';

  @override
  String get editor => 'Editor';

  @override
  String emptyFields(Object fields) {
    return '$fields están vacíos';
  }

  @override
  String fileNotFound(Object file) {
    return 'Archivo ($file) no encontrado';
  }

  @override
  String fileTooLarge(Object size) {
    return 'Archivo demasiado grande: $size';
  }

  @override
  String get followChatModel => 'Seguir modelo de chat';

  @override
  String get fontSize => 'Tamaño de fuente';

  @override
  String get fontSizeSettingTip => 'Solo se aplica a bloques de código';

  @override
  String get freeCopy => 'Copia libre';

  @override
  String get genChatTitle => 'Generar título del chat';

  @override
  String get genTitle => 'Generar título';

  @override
  String get headTailMode => 'Modo cabeza-cola';

  @override
  String get headTailModeTip => 'Solo envía `prompt + primer mensaje del usuario + entrada actual` como contexto.\n\nEsto es especialmente útil para traducir conversaciones (ahorra tokens).';

  @override
  String get help => 'Ayuda';

  @override
  String get history => 'Historial';

  @override
  String historyToolHelp(Object keywords) {
    return '¿Cargar chats que contengan las palabras clave $keywords como contexto?';
  }

  @override
  String get historyToolTip => 'Cargar chats históricos como contexto';

  @override
  String get hour => 'hora';

  @override
  String get httpToolTip => 'Realizar una solicitud HTTP, por ejemplo: buscar contenido';

  @override
  String get ignoreContextConstraint => 'Ignorar restricción de contexto';

  @override
  String get ignoreTip => 'Ignorar aviso';

  @override
  String get image => 'Imagen';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 Consejos\n- El desplazamiento excesivo (overscroll) en la interfaz de chat permite cambiar rápidamente entre historiales de chat\n- Mantén presionado el texto del chat para seleccionar y copiar libremente el código fuente Markdown\n- El uso del esquema URL se puede encontrar [aquí]($unilink)\n\n### 🔍 Ayuda\n- Si GPT Box tiene errores, usa [Github Issue]($issue)\n- Telegram `@lpktg`';
  }

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
  String get migrationV1UrlTip => '¿Se debe agregar automáticamente \"/v1\" al final de la configuración?';

  @override
  String get minute => 'minuto';

  @override
  String get model => 'Modelo';

  @override
  String get modelRegExpTip => 'Si el nombre del modelo coincide, se usarán las herramientas';

  @override
  String get more => 'Más';

  @override
  String get multiModel => 'Multimodal';

  @override
  String get myOtherApps => 'Mis otras aplicaciones';

  @override
  String get needOpenAIKey => 'Por favor, introduzca primero la clave de OpenAI';

  @override
  String get needRestart => 'Se necesita reiniciar para aplicar';

  @override
  String get newChat => 'Nuevo chat';

  @override
  String get noDuplication => 'Sin duplicados';

  @override
  String notSupported(Object val) {
    return '$val no es compatible';
  }

  @override
  String get onMsgCome => 'Cuando hay nuevos mensajes';

  @override
  String get onSwitchChat => 'Al cambiar de conversación';

  @override
  String get onlyRestoreHistory => 'Solo restaurar historial de chat (no restaurar URL de API ni clave secreta)';

  @override
  String get onlySyncOnLaunch => 'Sincronizar solo al iniciar';

  @override
  String get other => 'Otro';

  @override
  String get participant => 'Participante';

  @override
  String get passwd => 'Contraseña';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacyTip => 'Esta aplicación no recopila ninguna información.';

  @override
  String get profile => 'Perfil';

  @override
  String get promptsSettingsItem => 'Indicaciones';

  @override
  String get raw => 'Crudo';

  @override
  String get refresh => 'Actualizar';

  @override
  String get regExp => 'Expresión regular';

  @override
  String get remember30s => 'Recordar 30 segundos';

  @override
  String get rename => 'Renombrar';

  @override
  String get replay => 'Repetir';

  @override
  String get replayTip => 'Los mensajes reproducidos y todos los mensajes posteriores se borrarán.';

  @override
  String get res => 'Recurso';

  @override
  String restoreOpenaiTip(Object url) {
    return 'La documentación se puede encontrar [aquí]($url)';
  }

  @override
  String get rmDuplication => 'Eliminar duplicados';

  @override
  String rmDuplicationFmt(Object count) {
    return '¿Está seguro de que desea eliminar [$count] elementos duplicados?';
  }

  @override
  String get route => 'Ruta';

  @override
  String get save => 'Guardar';

  @override
  String get saveErrChat => 'Guardar chat con error';

  @override
  String get saveErrChatTip => 'Guardar después de recibir/enviar cada mensaje, incluso si hay errores';

  @override
  String get scrollSwitchChat => 'Desplazar para cambiar de chat';

  @override
  String get search => 'Buscar';

  @override
  String get secretKey => 'Clave secreta';

  @override
  String get share => 'Compartir';

  @override
  String get shareFrom => 'Compartido desde';

  @override
  String get skipSameTitle => 'Omitir chats con el mismo título que los chats locales';

  @override
  String get softWrap => 'Ajuste de línea';

  @override
  String get stt => 'Voz a texto';

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
  String get system => 'Sistema';

  @override
  String get text => 'Texto';

  @override
  String get themeColorSeed => 'Semilla de color del tema';

  @override
  String get themeMode => 'Modo de tema';

  @override
  String get thirdParty => 'Terceros';

  @override
  String get tool => 'Herramienta';

  @override
  String toolConfirmFmt(Object tool) {
    return '¿Acepta usar la herramienta $tool?';
  }

  @override
  String get toolFinishTip => 'Llamada a la herramienta completada';

  @override
  String toolHttpReqHelp(Object host) {
    return 'Se obtendrán datos de la red, esta vez se contactará con $host';
  }

  @override
  String get toolHttpReqName => 'Solicitud HTTP';

  @override
  String get tts => 'Texto a voz';

  @override
  String get unsupported => 'No compatible';

  @override
  String get untitled => 'Sin título';

  @override
  String get update => 'Actualizar';

  @override
  String get usage => 'Uso';

  @override
  String get user => 'Usuario';

  @override
  String weeksAgo(Object weeks) {
    return 'Hace $weeks semanas';
  }

  @override
  String get wrap => 'Envolver';
}
