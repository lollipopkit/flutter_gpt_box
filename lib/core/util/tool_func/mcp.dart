part of 'tool.dart';

/// One MCP server the user added, by URL.
final class _McpServer {
  _McpServer(this.url);

  final String url;
  McpClient? client;
  Transport? transport;
  List<Tool> tools = const [];
  bool connected = false;
  String? error;
  Timer? retry;
  int attempts = 0;

  /// What the server calls itself; its host until it has said.
  String get label => client?.getServerVersion()?.name ?? Uri.tryParse(url)?.host ?? url;
}

/// The MCP servers (Streamable HTTP) and their tools.
abstract final class McpTools {
  static final _servers = <String, _McpServer>{};

  static const _maxAttempts = 3;
  static const _retryDelay = Duration(seconds: 5);
  static const _callTimeout = Duration(minutes: 5);

  /// Providers take tool names of at most this many characters.
  static const _maxNameLength = 64;

  static const _maxInstructions = 2000;

  /// Notified when a server connects, drops or relists its tools.
  static final changes = RNode();

  /// Connects every stored server. Run at launch; each connects on its own.
  static Future<void> connectStored() =>
      Future.wait([for (final url in Stores.mcp.mcpServers.get()) connect(url)]);

  /// The id a server's tools are prefixed with: from its URL, so it stays the
  /// same across launches and when another server is removed.
  static String nameFor(String url) => 'mcp${_fnv(url)}';

  /// FNV-1a: `String.hashCode` is not stable across runs.
  static String _fnv(String s) {
    var h = 0x811c9dc5;
    for (final c in s.codeUnits) {
      h = ((h ^ c) * 0x01000193) & 0xffffffff;
    }
    return h.toRadixString(16).padLeft(8, '0');
  }

  /// Connects [url], or reconnects it. Failures are kept for [errorOf] and
  /// retried a few times.
  static Future<void> connect(String url) async {
    final id = nameFor(url);
    final s = _servers[id] ??= _McpServer(url);
    s.retry?.cancel();
    await _close(s);
    // A fresh transport each time: a closed one cannot be started again.
    final transport = StreamableHttpClientTransport(Uri.parse(url));
    final client = McpClient(Implementation(name: BuildData.name, version: '1.0.${BuildData.build}'));
    s
      ..transport = transport
      ..client = client;
    // The client's, not the transport's: the client takes those over.
    client
      ..onerror = ((e) => _dropped(s, transport, '$e'))
      ..onclose = (() => _dropped(s, transport, null));
    try {
      await client.connect(transport);
      if (!identical(s.transport, transport)) return;
      client.setNotificationHandler<JsonRpcToolListChangedNotification>(
        Method.notificationsToolsListChanged,
        (_) => _listTools(s),
        (params, meta) => JsonRpcToolListChangedNotification(meta: meta),
      );
      s
        ..connected = true
        ..error = null
        ..attempts = 0;
      await _listTools(s);
      Loggers.app.info('MCP ${s.label}: ${s.tools.length} tools');
    } catch (e, s_) {
      if (!identical(s.transport, transport)) return;
      Loggers.app.warning('MCP connect $url', e, s_);
      s
        ..connected = false
        ..error = '$e';
      _retryLater(s);
    }
    changes.notify();
  }

  /// [transport] errored or closed. Only the current one counts: an old one
  /// closing after a reconnect says nothing about the server.
  static void _dropped(_McpServer s, Transport transport, String? error) {
    if (!identical(s.transport, transport) || !s.connected) return;
    Loggers.app.warning('MCP ${s.label} dropped: ${error ?? 'closed'}');
    s
      ..connected = false
      ..error = error;
    changes.notify();
    _retryLater(s);
  }

  static void _retryLater(_McpServer s) {
    if (s.attempts >= _maxAttempts || !_servers.containsKey(nameFor(s.url))) return;
    s.attempts++;
    s.retry?.cancel();
    s.retry = Timer(_retryDelay * s.attempts, () => unawaited(connect(s.url)));
  }

  static Future<void> _listTools(_McpServer s) async {
    final client = s.client;
    if (client == null) return;
    try {
      final tools = <Tool>[];
      String? cursor;
      do {
        final r = await client.listTools(params: cursor == null ? null : ListToolsRequest(cursor: cursor));
        tools.addAll(r.tools);
        cursor = r.nextCursor;
      } while (cursor != null);
      s.tools = tools;
    } catch (e, st) {
      Loggers.app.warning('MCP ${s.label}: list tools', e, st);
      s.tools = const [];
    }
    changes.notify();
  }

  static Future<void> _close(_McpServer s) async {
    final t = s.transport;
    s
      ..transport = null
      ..client = null
      ..connected = false
      ..tools = const [];
    if (t == null) return;
    try {
      await t.close();
    } catch (e) {
      Loggers.app.fine('MCP close ${s.url}: $e');
    }
  }

  /// Retries [id] now, from the start.
  static Future<void> retryConnection(String id) async {
    final s = _servers[id];
    if (s == null) return;
    s.attempts = 0;
    await connect(s.url);
  }

  static Future<void> removeServer(String id) async {
    final s = _servers.remove(id);
    if (s == null) return;
    s.retry?.cancel();
    await _close(s);
    changes.notify();
  }

  static bool isServerConnected(String id) => _servers[id]?.connected ?? false;

  /// Why [id] last failed, if it did.
  static String? errorOf(String id) => _servers[id]?.error;

  /// What [id] calls itself.
  static String? labelOf(String id) => _servers[id]?.label;

  static Map<String, int> get toolCounts => {
    for (final MapEntry(:key, :value) in _servers.entries)
      if (value.connected) key: value.tools.length,
  };

  /// A tool's name as the model sees it: providers take `[a-zA-Z0-9_-]`,
  /// at most [_maxNameLength], and two servers may both have a `search`.
  static String toolName(String id, String tool) {
    final n = '${id}__$tool'.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    if (n.length <= _maxNameLength) return n;
    return '${n.substring(0, _maxNameLength - 9)}_${_fnv(tool)}';
  }

  /// `server · tool` for a tool name of [toolName]'s making, as the user
  /// reads it.
  static String? toolLabel(String name) {
    for (final MapEntry(key: id, value: s) in _servers.entries) {
      if (!name.startsWith('${id}__')) continue;
      final t = s.tools.firstWhereOrNull((t) => toolName(id, t.name) == name);
      return '${s.label} · ${t?.title ?? t?.name ?? name.substring(id.length + 2)}';
    }
    return null;
  }

  /// Every tool of every connected server, as the model gets it.
  static List<LlmTool> get llmTools => [
    for (final MapEntry(key: id, value: s) in _servers.entries)
      if (s.connected)
        for (final t in s.tools)
          LlmTool(
            name: toolName(id, t.name),
            description: '[${s.label}] ${t.description ?? t.title ?? ''}'.trim(),
            parameters: t.inputSchema.toJson(),
            label: '${s.label} · ${t.title ?? t.name}',
            execute: (call, cancel) => Tools.timed(() => _call(s, t.name, call.args, cancel)),
          ),
  ];

  /// What connected servers say about using them, for the system prompt.
  static String? get instructions {
    final parts = [
      for (final s in _servers.values)
        if (s.connected && (s.client?.getInstructions()?.trim() ?? '').isNotEmpty)
          '## ${s.label}\n\n${_cap(s.client!.getInstructions()!.trim(), _maxInstructions)}',
    ];
    if (parts.isEmpty) return null;
    return '# MCP servers\n\nInstructions from the MCP servers whose tools you have:\n\n${parts.join('\n\n')}';
  }

  static String _cap(String s, int n) => s.length <= n ? s : '${s.substring(0, n)}…';

  static Future<LlmToolResult> _call(_McpServer s, String tool, _Map args, LlmCancelToken cancel) async {
    final client = s.client;
    if (client == null || !s.connected) throw StateError('${s.label} is not connected');
    _log('MCP ${s.label} · $tool');
    final abort = BasicAbortController();
    unawaited(cancel.whenCancelled.then((_) => abort.abort('Stopped by the user')));
    final res = await client.callTool(
      CallToolRequest(name: tool, arguments: args),
      options: RequestOptions(signal: abort.signal, timeout: _callTimeout),
    );
    final parts = <Map<String, Object?>>[
      for (final c in res.content)
        switch (c) {
          TextContent() => LlmContent.text(c.text),
          ImageContent() => LlmContent.image(c.data, c.mimeType),
          AudioContent() => LlmContent.text('[Audio: ${c.mimeType}, not shown]'),
          EmbeddedResource(resource: final TextResourceContents r) => LlmContent.text('[${r.uri}]\n${r.text}'),
          EmbeddedResource(resource: final r) => LlmContent.text('[Resource: ${r.uri}, binary, not shown]'),
          ResourceLink() => LlmContent.text('[${c.title ?? c.name}](${c.uri})${c.description == null ? '' : ' ${c.description}'}'),
          _ => LlmContent.text(jsonEncode(c.toJson())),
        },
      if (res.content.isEmpty && res.structuredContent != null) LlmContent.text(jsonEncode(res.structuredContent)),
    ];
    if (res.isError) throw StateError(parts.map((p) => p['text'] ?? '').join('\n'));
    return LlmToolResult(content: parts);
  }
}
