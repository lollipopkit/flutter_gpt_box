import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get apiUrlV1Tip => 'Semelhante a https://api.openai.com/v1 (requerendo o /v1 final). Continuar usando esta URL?';

  @override
  String get assistant => 'Assistente';

  @override
  String get attention => 'Atenção';

  @override
  String get audio => 'Áudio';

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Verificar atualizações automaticamente';

  @override
  String get autoRmDupChat => 'Remover chats duplicados automaticamente';

  @override
  String get autoScrollBottom => 'Rolar automaticamente para baixo';

  @override
  String get backupTip => 'Por favor, certifique-se de que seu arquivo de backup é privado e seguro!';

  @override
  String get balance => 'Saldo';

  @override
  String get calcTokenLen => 'Calcular comprimento dos tokens';

  @override
  String get changeModelTip => 'Diferentes chaves podem acessar diferentes listas de modelos. Se você não entende o mecanismo e ocorrem erros, é recomendável reconfigurar o modelo.';

  @override
  String get chat => 'Chat';

  @override
  String get chatHistoryLength => 'Comprimento do histórico de chat';

  @override
  String get chatHistoryTip => 'Usado como contexto do chat';

  @override
  String get clickSwitch => 'Clique para alternar';

  @override
  String get clickToCheck => 'Clique para verificar';

  @override
  String get clipboard => 'Área de transferência';

  @override
  String get codeBlock => 'Bloco de código';

  @override
  String get colorSeedTip => 'Isto é uma semente de cor, não uma cor';

  @override
  String get compress => 'Comprimir';

  @override
  String get compressImgTip => 'Para chat e compartilhamento';

  @override
  String get contributor => 'Contribuidor';

  @override
  String get copied => 'Copiado';

  @override
  String get current => 'Atual';

  @override
  String get custom => 'Personalizado';

  @override
  String get day => 'dia';

  @override
  String get defaulT => 'Padrão';

  @override
  String delFmt(Object id, Object type) {
    return 'Excluir $type ($id)?';
  }

  @override
  String get delete => 'Excluir';

  @override
  String get deleteConfirm => 'Confirmar antes de excluir';

  @override
  String get editor => 'Editor';

  @override
  String emptyFields(Object fields) {
    return '$fields estão vazios';
  }

  @override
  String get emptyTrash => 'Esvaziar a lixeira';

  @override
  String get emptyTrashTip => '==0, excluir na próxima inicialização. <0 não excluir automaticamente.';

  @override
  String fileNotFound(Object file) {
    return 'Arquivo ($file) não encontrado';
  }

  @override
  String fileTooLarge(Object size) {
    return 'Arquivo muito grande: $size';
  }

  @override
  String get followChatModel => 'Seguir modelo de chat';

  @override
  String get fontSize => 'Tamanho da fonte';

  @override
  String get fontSizeSettingTip => 'Aplica-se apenas a blocos de código';

  @override
  String get freeCopy => 'Cópia livre';

  @override
  String get genChatTitle => 'Gerar título do chat';

  @override
  String get genTitle => 'Gerar título';

  @override
  String get headTailMode => 'Modo cabeça-cauda';

  @override
  String get headTailModeTip => 'Envia apenas `prompt + primeira mensagem do usuário + entrada atual` como contexto.\n\nIsso é especialmente útil para traduzir conversas (economiza tokens).';

  @override
  String get help => 'Ajuda';

  @override
  String get history => 'Histórico';

  @override
  String historyToolHelp(Object keywords) {
    return 'Carregar chats contendo as palavras-chave $keywords como contexto?';
  }

  @override
  String get historyToolTip => 'Carregar chats históricos como contexto';

  @override
  String get hour => 'hora';

  @override
  String get httpToolTip => 'Realizar uma solicitação HTTP, por exemplo: pesquisar conteúdo';

  @override
  String get ignoreContextConstraint => 'Ignorar restrição de contexto';

  @override
  String get ignoreTip => 'Ignorar dica';

  @override
  String get image => 'Imagem';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 Dicas\n- A rolagem excessiva (overscroll) na interface do chat permite alternar rapidamente entre históricos de chat\n- Pressione longamente o texto do chat para selecionar e copiar livremente a fonte Markdown\n- O uso do esquema de URL pode ser encontrado [aqui]($unilink)\n\n### 🔍 Ajuda\n- Se o GPT Box tiver bugs, use [Github Issue]($issue)\n- Telegram `@lpktg`';
  }

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
  String get migrationV1UrlTip => 'Deve-se adicionar automaticamente \"/v1\" ao final da configuração?';

  @override
  String get minute => 'minuto';

  @override
  String get model => 'Modelo';

  @override
  String get modelRegExpTip => 'Se o nome do modelo corresponder, as ferramentas serão usadas';

  @override
  String get more => 'Mais';

  @override
  String get multiModel => 'Multimodal';

  @override
  String get myOtherApps => 'Meus outros aplicativos';

  @override
  String get needOpenAIKey => 'Por favor, insira primeiro a chave OpenAI';

  @override
  String get needRestart => 'Reinicialização necessária para aplicar';

  @override
  String get newChat => 'Novo chat';

  @override
  String get noDuplication => 'Sem duplicação';

  @override
  String notSupported(Object val) {
    return '$val não é suportado';
  }

  @override
  String get onMsgCome => 'Quando houver novas mensagens';

  @override
  String get onSwitchChat => 'Ao alternar conversas';

  @override
  String get onlyRestoreHistory => 'Restaurar apenas o histórico de chat (não restaurar URL da API e chave secreta)';

  @override
  String get onlySyncOnLaunch => 'Sincronizar apenas na inicialização';

  @override
  String get other => 'Outro';

  @override
  String get participant => 'Participante';

  @override
  String get passwd => 'Senha';

  @override
  String get privacy => 'Privacidade';

  @override
  String get privacyTip => 'Este aplicativo não coleta nenhuma informação.';

  @override
  String get profile => 'Perfil';

  @override
  String get promptsSettingsItem => 'Prompts';

  @override
  String get quickShareTip => 'Abra este link em outro dispositivo para importar rapidamente a configuração atual.';

  @override
  String get raw => 'Bruto';

  @override
  String get refresh => 'Atualizar';

  @override
  String get regExp => 'Expressão regular';

  @override
  String get remember30s => 'Lembrar por 30 segundos';

  @override
  String get rename => 'Renomear';

  @override
  String get replay => 'Repetir';

  @override
  String get replayTip => 'As mensagens reproduzidas e todas as mensagens subsequentes serão apagadas.';

  @override
  String get res => 'Recurso';

  @override
  String restoreOpenaiTip(Object url) {
    return 'A documentação pode ser encontrada [aqui]($url)';
  }

  @override
  String get rmDuplication => 'Remover duplicação';

  @override
  String rmDuplicationFmt(Object count) {
    return 'Tem certeza de que deseja remover [$count] itens duplicados?';
  }

  @override
  String get route => 'Rota';

  @override
  String get save => 'Salvar';

  @override
  String get saveErrChat => 'Salvar chat com erro';

  @override
  String get saveErrChatTip => 'Salvar após receber/enviar cada mensagem, mesmo se houver erros';

  @override
  String get scrollSwitchChat => 'Rolar para alternar chat';

  @override
  String get search => 'Pesquisar';

  @override
  String get secretKey => 'Chave secreta';

  @override
  String get share => 'Compartilhar';

  @override
  String get shareFrom => 'Compartilhado de';

  @override
  String get skipSameTitle => 'Pular chats com o mesmo título que os chats locais';

  @override
  String get softWrap => 'Quebra de linha suave';

  @override
  String get stt => 'Fala para texto';

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
  String get system => 'Sistema';

  @override
  String get text => 'Texto';

  @override
  String get themeColorSeed => 'Semente de cor do tema';

  @override
  String get themeMode => 'Modo de tema';

  @override
  String get thirdParty => 'Terceiro';

  @override
  String get tool => 'Ferramenta';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Você concorda em usar a ferramenta $tool?';
  }

  @override
  String get toolFinishTip => 'Chamada de ferramenta concluída';

  @override
  String toolHttpReqHelp(Object host) {
    return 'Serão obtidos dados da rede, desta vez entrando em contato com $host';
  }

  @override
  String get toolHttpReqName => 'Solicitação HTTP';

  @override
  String get tts => 'Texto para fala';

  @override
  String get unsupported => 'Não suportado';

  @override
  String get untitled => 'Sem título';

  @override
  String get update => 'Atualizar';

  @override
  String get usage => 'Uso';

  @override
  String get user => 'Usuário';

  @override
  String weeksAgo(Object weeks) {
    return '$weeks semanas atrás';
  }

  @override
  String get wrap => 'Quebrar';
}
