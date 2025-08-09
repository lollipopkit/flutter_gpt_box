part of 'tool.dart';

/// MCP Tools util class.
abstract class McpTools {
  static final _clients = <String, Client>{};
  static final _transports = <String, Transport>{};
  static final _toolsByServer = <String, Set<ChatCompletionTool>>{};
  static final _serverNames = <Transport, String>{};
  static final _connectionStates = <String, bool>{};
  static final _retryTimers = <String, Timer>{};
  static const int _maxRetries = 3;
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
      final client = Client(
        Implementation(name: BuildData.name, version: '1.0.${BuildData.build}'),
      );
      
      // Set up transport error handlers
      transport.onerror = (error) {
        Loggers.app.warning('Transport error for $serverName: $error');
        _connectionStates[serverName] = false;
        _scheduleReconnect(serverName, transport);
      };
      
      transport.onclose = () {
        Loggers.app.info('Transport closed for $serverName');
        _connectionStates[serverName] = false;
      };
      
      await client.connect(transport);
      
      _clients[serverName] = client;
      _transports[serverName] = transport;
      _serverNames[transport] = serverName;
      _connectionStates[serverName] = true;
      
      // Cancel any pending retry
      _retryTimers[serverName]?.cancel();
      _retryTimers.remove(serverName);
      
      await _refreshToolsForServer(serverName);
      Loggers.app.info('Successfully connected to MCP server "$serverName" with ${(_toolsByServer[serverName] ?? {}).length} tools');
      return transport;
    } catch (e, s) {
      _connectionStates[serverName] = false;
      
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
      _toolsByServer[serverName] = {};
      return;
    }
    
    try {
      final list = await client.listTools();
      final tools = list.tools
          .map(
            (e) => ChatCompletionTool(
              type: ChatCompletionToolType.function,
              function: FunctionObject(
                name: '$serverName::${e.name}',
                description: '[$serverName] ${e.description}',
                parameters: e.inputSchema.properties,
              ),
            ),
          )
          .toSet();
      _toolsByServer[serverName] = tools;
      Loggers.app.info('Loaded ${tools.length} tools from server "$serverName"');
    } catch (e, s) {
      Loggers.app.warning('Load tools from server "$serverName" failed', e, s);
      _toolsByServer[serverName] = {};
    }
  }
  
  /// Refresh tools for a specific server by name (public method).
  static Future<void> refreshToolsForServer(String serverName) async {
    await _refreshToolsForServer(serverName);
  }

  /// Get all tools from all connected servers.
  static Set<ChatCompletionTool> get tools {
    // Add internal tools
    _toolsByServer[InternalMcpServer.serverName] = _getInternalTools();
    _connectionStates[InternalMcpServer.serverName] = true;
    
    // Only include tools from connected servers
    return _toolsByServer.entries
        .where((entry) => isServerConnected(entry.key))
        .expand((entry) => entry.value)
        .toSet();
  }
  
  /// Get internal tools as ChatCompletionTool objects
  static Set<ChatCompletionTool> _getInternalTools() {
    final disabledMcp = Stores.mcp.disabledTools.get();
    final tools = <ChatCompletionTool>{};
    
    for (final tool in OpenAIFuncCalls.internalTools) {
      final toolName = '${InternalMcpServer.serverName}::${tool.name}';
      if (!disabledMcp.contains(toolName) && !disabledMcp.contains(tool.name)) {
        tools.add(ChatCompletionTool(
          type: ChatCompletionToolType.function,
          function: FunctionObject(
            name: toolName,
            description: '[${InternalMcpServer.serverName}] ${tool.description}',
            parameters: tool.parametersSchema,
          ),
        ));
      }
    }
    
    return tools;
  }
  
  /// Get count of available tools per server.
  static Map<String, int> get toolCounts {
    return Map.fromEntries(
      _toolsByServer.entries
          .where((entry) => isServerConnected(entry.key))
          .map((entry) => MapEntry(entry.key, entry.value.length))
    );
  }

  /// Get tools from a specific server.
  static Set<ChatCompletionTool> getToolsFromServer(String serverName) {
    return _toolsByServer[serverName] ?? {};
  }

  /// Get all connected server names.
  static Set<String> get serverNames => _clients.keys.toSet();

  static Future<_Ret?> handle(_CallResp call, OnToolLog onToolLog) async {
    final fullName = call.function.name;
    final parts = fullName.split('::');
    
    if (parts.length != 2) {
      final error = 'Invalid tool name format: $fullName (expected "server::tool")';
      Loggers.app.warning(error);
      onToolLog(error);
      return null;
    }
    
    final serverName = parts[0];
    final toolName = parts[1];
    
    // Handle internal MCP server tools directly
    if (serverName == InternalMcpServer.serverName) {
      final args = await _parseMap(call.function.arguments);
      return await InternalMcpServer.handleToolCall(toolName, args, onToolLog);
    }
    
    final client = _clients[serverName];
    
    if (client == null) {
      final error = 'Server not found: $serverName';
      Loggers.app.warning(error);
      onToolLog(error);
      return null;
    }
    
    if (!isServerConnected(serverName)) {
      final error = 'Server $serverName is not connected';
      Loggers.app.warning(error);
      onToolLog(error);
      return null;
    }
    
    final args = await _parseMap(call.function.arguments);
    try {
      onToolLog('Calling [$serverName] $toolName...');
      final res = await client.callTool(
        CallToolRequestParams(name: toolName, arguments: args),
      );
      
      String resultText = '';
      if (res.content.isNotEmpty) {
        resultText = res.content.map((content) {
          if (content is TextContent) {
            return content.text;
          } else if (content is ImageContent) {
            return '[Image: ${content.data}]';
          } else if (content is AudioContent) {
            return '[Audio: ${content.data}]';
          } else if (content is EmbeddedResource) {
            return '[Resource: ${content.resource.uri}]';
          }
          return content.toString();
        }).join('\n');
      }
      
      if (res.isError == true) {
        final error = 'Tool execution failed: $resultText';
        onToolLog('[$serverName] Error: $resultText');
        return [ChatContent.text(error)];
      }
      
      onToolLog('[$serverName] Success: $resultText');
      return [ChatContent.text(resultText)];
    } catch (e, s) {
      final error = 'MCP tool error for $fullName: $e';
      Loggers.app.warning(error, e, s);
      onToolLog('[$serverName] Error: $e');
      return null;
    }
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
        final toolCount = (_toolsByServer[serverName] ?? {}).length;
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
