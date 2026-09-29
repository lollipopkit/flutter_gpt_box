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
  String get autoScrollBottom => 'Rolar automaticamente para baixo';

  @override
  String get backupTip =>
      'Por favor, certifique-se de que seu arquivo de backup é privado e seguro!';

  @override
  String get calcTokenLen => 'Calcular comprimento dos tokens';

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
  String get emptyTrash => 'Esvaziar a lixeira';

  @override
  String get emptyTrashTip =>
      '==0, excluir na próxima inicialização. <0 não excluir automaticamente.';

  @override
  String get fontSize => 'Tamanho da fonte';

  @override
  String get fontSizeSettingTip => 'Aplica-se apenas a blocos de código';

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
  String get list => 'Lista';

  @override
  String get manual => 'Manual';

  @override
  String get memory => 'Memória';

  @override
  String memoryAdded(Object str) {
    return 'Memória adicionada: $str';
  }

  @override
  String memoryTip(Object txt) {
    return 'Lembrar [$txt]?';
  }

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
  String get onMsgCome => 'Quando houver novas mensagens';

  @override
  String get onSwitchChat => 'Ao alternar conversas';

  @override
  String get passwd => 'Senha';

  @override
  String get privacy => 'Privacidade';

  @override
  String get privacyTip => 'Este aplicativo não coleta nenhuma informação.';

  @override
  String get rename => 'Renomear';

  @override
  String get replay => 'Repetir';

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
  String get switcher => 'Alternador';

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
  String toolConfirmFmt(Object tool) {
    return 'Você concorda em usar a ferramenta $tool?';
  }

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
