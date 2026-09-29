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
    return '$n modelos';
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
}
