part of 'tool.dart';

/// MCP Tools util class.
abstract class McpTools {
  static final _clients = <String, McpClient>{};
  static final _transports = <String, Transport>{};
  static final _toolsByServer = <String, List<Tool>>{};
  static final _serverNames = <Transport, String>{};
  static final _connectionStates = <String, bool>{};
  static final _errors = <String, String>{};
  static final _retryTimers = <String, Timer>{};
  static const int _maxRetries = 3;

  /// Notified when the set of tools changes: a server connected, dropped or
  /// relisted its tools.
  static final changes = RNode();

  /// Connects every stored server. Run at launch; each connects on its own.
  static Future<void> connectStored() async {
    await Future.wait([
      for (final url in Stores.mcp.mcpServers.get())
        if (!_clients.containsKey(nameFor(url))) addTs(newHttpTs(url: url), nameFor(url)),
    ]);
  }

  /// The name a server's tools are prefixed with: from its URL, so it stays
  /// the same across launches and when another server is removed.
  static String nameFor(String url) {
    // FNV-1a: `String.hashCode` is not stable across runs.
    var h = 0x811c9dc5;
    for (final c in url.codeUnits) {
      h = ((h ^ c) * 0x01000193) & 0xffffffff;
    }
    return 'mcp${h.toRadixString(16).padLeft(8, '0')}';
  }
  static const Duration _retryDelay = Duration(seconds: 5);

  /// Init a stdio [Transport] with lifecycle management.
  ///
  /// - [path]: The path to the MCP server executable.
  /// - [args]: Optional arguments to pass to the MCP server.
  /// - [environment]: Optional environment variables for the process.
  static Transport newStdioTs({
    required String path,
    List<String> args = const [],
    Map<String, String>? environment,
  }) {
    final serverParams = StdioServerParameters(
      command: path,
      args: args,
      environment: environment,
      stderrMode: ProcessStartMode.normal,
    );
    final transport = StdioClientTransport(serverParams);
    
    // Add cleanup handler for process termination
    transport.onclose = () {
      Loggers.app.info('Stdio transport closed for: $path');
    };
    
    return transport;
  }

  /// Init a Streamable HTTP [Transport] with enhanced error handling.
  ///
  /// - [url]: The URL of the MCP server.
  /// - [requestInit]: Optional HTTP request configuration (headers, etc.).
  /// - [sessionId]: Optional session ID for the connection.
  static Transport newHttpTs({
    required String url, 
    Map<String, dynamic>? requestInit,
    String? sessionId,
  }) {
    final uri = Uri.parse(url);
    final opts = StreamableHttpClientTransportOptions(
      requestInit: requestInit,
      sessionId: sessionId,
    );
    final transport = StreamableHttpClientTransport(uri, opts: opts);
    
    transport.onerror = (error) {
      Loggers.app.warning('HTTP transport error for $url: $error');
    };
    
    transport.onclose = () {
      Loggers.app.info('HTTP transport closed for: $url');
    };
    
    return transport;
  }

  /// Add a transport with unique server name and retry mechanism.
  static Future<Transport?> addTs(Transport transport, String serverName, {int retryCount = 0}) async {
    try {
      final client = McpClient(
        Implementation(name: BuildData.name, version: '1.0.${BuildData.build}'),
      );
      
      // Set up transport error handlers
      transport.onerror = (error) {
        Loggers.app.warning('Transport error for $serverName: $error');
        _connectionStates[serverName] = false;
        _errors[serverName] = '$error';
        changes.notify();
        _scheduleReconnect(serverName, transport);
      };
      
      transport.onclose = () {
        Loggers.app.info('Transport closed for $serverName');
        _connectionStates[serverName] = false;
        changes.notify();
      };
      
      await client.connect(transport);
      
      _clients[serverName] = client;
      _transports[serverName] = transport;
      _serverNames[transport] = serverName;
      _connectionStates[serverName] = true;
      _errors.remove(serverName);
      
      // Cancel any pending retry
      _retryTimers[serverName]?.cancel();
      _retryTimers.remove(serverName);
      
      await _refreshToolsForServer(serverName);
      Loggers.app.info('Successfully connected to MCP server "$serverName" with ${(_toolsByServer[serverName] ?? const []).length} tools');
      return transport;
    } catch (e, s) {
      _connectionStates[serverName] = false;
      _errors[serverName] = '$e';
      changes.notify();
      
      if (retryCount < _maxRetries) {
        Loggers.app.warning(
          'Connect to MCP server "$serverName" failed (attempt ${retryCount + 1}/$_maxRetries)',
          e, s
        );
        _scheduleRetry(serverName, transport, retryCount + 1);
      } else {
        Loggers.app.warning(
          'Connect to MCP server "$serverName" failed after $_maxRetries attempts', e, s
        );
      }
    }
    return null;
  }

  /// Refresh tools for all connected servers.
  static Future<void> refreshAllTools() async {
    for (final serverName in _clients.keys) {
      await _refreshToolsForServer(serverName);
    }
  }

  /// Refresh tools for a specific server.
  static Future<void> _refreshToolsForServer(String serverName) async {
    final client = _clients[serverName];
    if (client == null || !isServerConnected(serverName)) {
      _toolsByServer[serverName] = [];
      return;
    }

    try {
      final list = await client.listTools();
      _toolsByServer[serverName] = list.tools;
      changes.notify();
      Loggers.app.info('Loaded ${list.tools.length} tools from server "$serverName"');
    } catch (e, s) {
      Loggers.app.warning('Load tools from server "$serverName" failed', e, s);
      _toolsByServer[serverName] = [];
    }
  }

  /// Refresh tools for a specific server by name (public method).
  static Future<void> refreshToolsForServer(String serverName) async {
    await _refreshToolsForServer(serverName);
  }

  /// A tool's name as the model sees it: providers take `[a-zA-Z0-9_-]`
  /// only, and two servers may both have a `search`.
  static String toolName(String serverName, String tool) =>
      '${serverName}__$tool'.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

  /// Every tool of every connected server, as the model gets it.
  static List<LlmTool> get llmTools => [
    for (final MapEntry(key: server, value: tools) in _toolsByServer.entries)
      if (isServerConnected(server))
        for (final t in tools)
          LlmTool(
            name: toolName(server, t.name),
            description: '[$server] ${t.description ?? ''}',
            parameters: t.inputSchema.toJson(),
            label: '$server · ${t.name}',
            execute: (call, _) => Tools.timed(() => _call(server, t.name, call.args)),
          ),
  ];

  /// Get count of available tools per server.
  static Map<String, int> get toolCounts {
    return Map.fromEntries(
      _toolsByServer.entries
          .where((entry) => isServerConnected(entry.key))
          .map((entry) => MapEntry(entry.key, entry.value.length)),
    );
  }

  /// Get all connected server names.
  static Set<String> get serverNames => _clients.keys.toSet();

  static Future<LlmToolResult> _call(String serverName, String toolName, _Map args) async {
    final client = _clients[serverName];
    if (client == null) throw StateError('Server not found: $serverName');
    if (!isServerConnected(serverName)) throw StateError('Server $serverName is not connected');

    _log('Calling [$serverName] $toolName...');
    final res = await client.callTool(CallToolRequest(name: toolName, arguments: args));
    final parts = <Map<String, Object?>>[
      for (final c in res.content)
        switch (c) {
          TextContent() => LlmContent.text(c.text),
          ImageContent() => LlmContent.image(c.data, c.mimeType),
          AudioContent() => LlmContent.text('[Audio: ${c.mimeType}]'),
          EmbeddedResource() => LlmContent.text('[Resource: ${c.resource.uri}]'),
          _ => LlmContent.text(c.toString()),
        },
    ];
    if (res.isError == true) {
      throw StateError(parts.map((p) => p['text'] ?? '').join('\n'));
    }
    return LlmToolResult(content: parts);
  }

  /// Schedule a retry connection attempt.
  static void _scheduleRetry(String serverName, Transport transport, int retryCount) {
    _retryTimers[serverName]?.cancel();
    _retryTimers[serverName] = Timer(_retryDelay, () {
      Loggers.app.info('Retrying connection to $serverName (attempt $retryCount/$_maxRetries)');
      addTs(transport, serverName, retryCount: retryCount);
    });
  }
  
  /// Schedule reconnection for existing transport.
  static void _scheduleReconnect(String serverName, Transport transport) {
    _retryTimers[serverName]?.cancel();
    _retryTimers[serverName] = Timer(_retryDelay, () {
      Loggers.app.info('Attempting to reconnect to $serverName');
      addTs(transport, serverName);
    });
  }

  /// Remove a server and clean up resources.
  static Future<void> removeServer(String serverName) async {
    // Cancel any pending retry
    _retryTimers[serverName]?.cancel();
    _retryTimers.remove(serverName);
    _errors.remove(serverName);
    
    final transport = _transports[serverName];
    if (transport != null) {
      try {
        await transport.close();
      } catch (e, s) {
        Loggers.app.warning('Error closing transport for $serverName', e, s);
      }
      _serverNames.remove(transport);
    }
    
    _clients.remove(serverName);
    _transports.remove(serverName);
    _toolsByServer.remove(serverName);
    _connectionStates.remove(serverName);
    changes.notify();
  }

  /// Close all connections and clean up.
  static Future<void> dispose() async {
    // Cancel all retry timers first
    for (final timer in _retryTimers.values) {
      timer.cancel();
    }
    _retryTimers.clear();
    
    for (final serverName in _clients.keys.toList()) {
      await removeServer(serverName);
    }
  }

  /// Check if a server is connected.
  static bool isServerConnected(String serverName) {
    return _connectionStates[serverName] ?? false;
  }

  /// Why [serverName] last failed to connect, if it did.
  static String? errorOf(String serverName) => _errors[serverName];

  /// Get connection status for all servers.
  static Map<String, bool> get connectionStates => Map.unmodifiable(_connectionStates);

  /// Manually retry connection to a server.
  static Future<Transport?> retryConnection(String serverName) async {
    final transport = _transports[serverName];
    if (transport != null) {
      return addTs(transport, serverName);
    }
    return null;
  }

  /// Get server capabilities.
  static ServerCapabilities? getServerCapabilities(String serverName) {
    return _clients[serverName]?.getServerCapabilities();
  }
  
  /// Get server information.
  static Implementation? getServerInfo(String serverName) {
    return _clients[serverName]?.getServerVersion();
  }
  
  /// Get server instructions.
  static String? getServerInstructions(String serverName) {
    return _clients[serverName]?.getInstructions();
  }
  
  /// Get detailed status for all servers.
  static Map<String, Map<String, dynamic>> getServerStatuses() {
    return Map.fromEntries(
      serverNames.map((serverName) {
        final isConnected = isServerConnected(serverName);
        final toolCount = (_toolsByServer[serverName] ?? const []).length;
        final serverInfo = getServerInfo(serverName);
        final capabilities = getServerCapabilities(serverName);
        
        return MapEntry(serverName, {
          'connected': isConnected,
          'toolCount': toolCount,
          'serverInfo': serverInfo?.toJson(),
          'capabilities': capabilities?.toJson(),
          'instructions': getServerInstructions(serverName),
        });
      })
    );
  }
}
