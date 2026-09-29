// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get attention => 'Atenção';

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Verificar atualizações automaticamente';

  @override
  String get backupTip =>
      'Por favor, certifique-se de que seu arquivo de backup é privado e seguro!';

  @override
  String get chat => 'Chat';

  @override
  String get clickToCheck => 'Clique para verificar';

  @override
  String get codeBlock => 'Bloco de código';

  @override
  String get copied => 'Copiado';

  @override
  String get current => 'Atual';

  @override
  String delFmt(Object id, Object type) {
    return 'Excluir $type ($id)?';
  }

  @override
  String get deleteConfirm => 'Confirmar antes de excluir';

  @override
  String emptyFields(Object fields) {
    return '$fields estão vazios';
  }

  @override
  String get emptyTrashTip =>
      '==0, excluir na próxima inicialização. <0 não excluir automaticamente.';

  @override
  String get genChatTitle => 'Gerar título do chat';

  @override
  String get history => 'Histórico';

  @override
  String historyToolHelp(Object keywords) {
    return 'Carregar chats contendo as palavras-chave $keywords como contexto?';
  }

  @override
  String get historyToolTip => 'Carregar chats históricos como contexto';

  @override
  String get httpToolTip =>
      'Realizar uma solicitação HTTP, por exemplo: pesquisar conteúdo';

  @override
  String get image => 'Imagem';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Link desconhecido: $uri';
  }

  @override
  String get joinBeta => 'Participar do teste beta';

  @override
  String get languageName => 'Português';

  @override
  String get license => 'Licença';

  @override
  String get licenseMenuItem => 'Licenças de código aberto';

  @override
  String get manual => 'Manual';

  @override
  String get memory => 'Memória';

  @override
  String get message => 'Mensagem';

  @override
  String get model => 'Modelo';

  @override
  String get more => 'Mais';

  @override
  String get myOtherApps => 'Meus outros aplicativos';

  @override
  String get newChat => 'Novo chat';

  @override
  String get passwd => 'Senha';

  @override
  String get privacy => 'Privacidade';

  @override
  String get privacyTip => 'Este aplicativo não coleta nenhuma informação.';

  @override
  String get rename => 'Renomear';

  @override
  String get share => 'Compartilhar';

  @override
  String get shareFrom => 'Compartilhado de';

  @override
  String get softWrap => 'Quebra de linha suave';

  @override
  String sureRestoreFmt(Object time) {
    return 'Tem certeza de que deseja restaurar o backup ($time)?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Conflito: não é possível ativar $a e $b ao mesmo tempo';
  }

  @override
  String get text => 'Texto';

  @override
  String get themeColorSeed => 'Semente de cor do tema';

  @override
  String get themeMode => 'Modo de tema';

  @override
  String get tool => 'Ferramenta';

  @override
  String toolHttpReqHelp(Object host) {
    return 'Serão obtidos dados da rede, desta vez entrando em contato com $host';
  }

  @override
  String get toolHttpReqName => 'Solicitação HTTP';

  @override
  String get untitled => 'Sem título';

  @override
  String get usage => 'Uso';

  @override
  String get user => 'Usuário';

  @override
  String get deny => 'Negar';

  @override
  String get allow => 'Permitir';

  @override
  String get allowAlways => 'Sempre permitir';

  @override
  String get trash => 'Lixeira';

  @override
  String get startChatTip => 'Escolha um modelo abaixo e diga algo.';

  @override
  String get camera => 'Câmera';

  @override
  String get send => 'Enviar';

  @override
  String get noProviderKey =>
      'Nenhum provedor tem chave ainda. Adicione uma para começar a conversar.';

  @override
  String get providers => 'Provedores';

  @override
  String get regenerate => 'Gerar novamente';

  @override
  String get compacted => 'As mensagens anteriores foram resumidas';

  @override
  String get favorite => 'Favoritos';

  @override
  String get defaultModel => 'Modelo padrão';

  @override
  String get titleModel => 'Modelo para títulos';

  @override
  String get systemPrompt => 'Prompt do sistema';

  @override
  String get compaction => 'Compactar conversas longas';

  @override
  String get compactionTip =>
      'Quando uma conversa não cabe mais no contexto do modelo, as mensagens anteriores são resumidas para o modelo. Você continua vendo todas.';

  @override
  String get customProvider => 'Provedor personalizado';

  @override
  String get refreshModels => 'Atualizar modelos';

  @override
  String get modelsListedTip =>
      'Opcional: a lista /models do endpoint é obtida. Adicione os IDs que não estiverem nela.';

  @override
  String get modelsRequired =>
      'Esta API não consegue listar seus modelos: informe pelo menos um ID de modelo.';

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
  String get sameAsChat => 'Igual à conversa';

  @override
  String get keyInKeychain =>
      'Guardada no chaveiro do sistema, nunca nos backups.';

  @override
  String get extraVars => 'Variáveis extras';

  @override
  String get extraVarsTip =>
      'Uma KEY=VALUE por linha, para provedores que precisam de mais que uma chave (recurso do Azure, conta do Cloudflare).';

  @override
  String providersCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n provedores',
      one: '1 provedor',
    );
    return '$_temp0';
  }

  @override
  String get today => 'Hoje';

  @override
  String get earlier => 'Anteriores';

  @override
  String get now => 'agora';

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
      other: '$n mensagens',
      one: '1 mensagem',
    );
    return '$_temp0';
  }

  @override
  String get thought => 'Raciocínio';

  @override
  String tokensFmt(String n) {
    return '$n tokens';
  }

  @override
  String allowToolFmt(String tool) {
    return 'Permitir $tool?';
  }

  @override
  String get replyWaits => 'A resposta aguarda sua decisão.';

  @override
  String usableModelsFmt(int n, int m) {
    return '$n disponíveis · $m provedores';
  }

  @override
  String get searchModels => 'Buscar modelos';

  @override
  String get version => 'Versão';

  @override
  String get endpoint => 'Endpoint';

  @override
  String get key => 'Chave';

  @override
  String get toolsAndMcp => 'Ferramentas e MCP';

  @override
  String get useTools => 'Usar ferramentas';

  @override
  String get useToolsTip =>
      'Cada chamada pergunta antes, a menos que esteja permitida abaixo';

  @override
  String get builtIn => 'Integradas';

  @override
  String get allowedWithoutAsking => 'Permitidas sem perguntar';

  @override
  String get mcpServers => 'Servidores MCP';

  @override
  String get addServer => 'Adicionar servidor';

  @override
  String connectedFmt(int n) {
    return 'Conectado · $n ferramentas';
  }

  @override
  String get disconnected => 'Desconectado';

  @override
  String get deleteKey => 'Excluir chave';

  @override
  String moreFmt(int n) {
    return 'mais $n';
  }

  @override
  String get back => 'Voltar';

  @override
  String get allProviders => 'Todos os provedores';

  @override
  String get searchProviders => 'Buscar provedores';

  @override
  String get backToChats => 'Voltar às conversas';

  @override
  String get genChatTitleTip => 'Dá nome à conversa após a primeira resposta';

  @override
  String get scrollOnNewMsg => 'Rolar até o fim a cada nova mensagem';

  @override
  String get scrollAfterSwitch => 'Rolar até o fim ao trocar de conversa';

  @override
  String chatsCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n conversas',
      one: '1 conversa',
    );
    return '$_temp0';
  }

  @override
  String get emptyTrashAfter => 'Esvaziar a lixeira após';

  @override
  String get trashTip => 'As conversas excluídas ficam aqui primeiro';

  @override
  String daysFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String thoughtForFmt(String time) {
    return 'Pensou por $time';
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
  String get attachment => 'Anexo';

  @override
  String get sync => 'Sincronização';

  @override
  String get syncNow => 'Sincronizar agora';

  @override
  String get syncing => 'Sincronizando…';

  @override
  String get neverSynced => 'Ainda não sincronizado';

  @override
  String lastSyncFmt(String time) {
    return 'Última sincronização: $time';
  }

  @override
  String get syncOffTip =>
      'Ative o iCloud ou o WebDAV abaixo para sincronizar automaticamente.';

  @override
  String get backupPassword => 'Senha do backup';

  @override
  String get backupEncrypted => 'Os backups são criptografados com ela';

  @override
  String get backupNotEncrypted =>
      'Não definida: backups em arquivo ficam sem criptografia, e a sincronização exige uma';

  @override
  String get backupEncryptedTip => 'Este backup está criptografado';

  @override
  String get backupPasswordRequired =>
      'Defina uma senha de backup primeiro: backups sincronizados são sempre criptografados';

  @override
  String get passwordWrong => 'Senha incorreta ou backup danificado';

  @override
  String get backupTooNew =>
      'Este backup é de uma versão mais nova do app. Atualize para restaurá-lo.';

  @override
  String get syncAppSettings => 'Sincronizar ajustes do app';

  @override
  String get syncAppSettingsTip =>
      'Tamanho da janela e barra de título ficam por dispositivo';

  @override
  String get webdavManualTip => 'Uma cópia datada ao lado da sincronizada';

  @override
  String get exportFile => 'Exportar para um arquivo';

  @override
  String get importFile => 'Restaurar de um arquivo';

  @override
  String get copyBackup => 'Copiar para a área de transferência';

  @override
  String get pasteBackup => 'Restaurar da área de transferência';

  @override
  String get memoryView => 'Ler memória';

  @override
  String get memorySearch => 'Pesquisar na memória';

  @override
  String get memoryWrite => 'Guardar memória';

  @override
  String get memoryEdit => 'Editar memória';

  @override
  String get memoryDelete => 'Excluir memória';

  @override
  String get memoryMove => 'Mover memória';

  @override
  String get memoryToolTip =>
      'Arquivos que o modelo mantém entre chats; lê e escreve sem perguntar';

  @override
  String charsFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n caracteres',
      one: '1 caractere',
    );
    return '$_temp0';
  }

  @override
  String alreadyExists(String path) {
    return '$path já existe';
  }

  @override
  String get unsavedChanges => 'Salvar as alterações antes de sair?';

  @override
  String get discard => 'Descartar';
}
