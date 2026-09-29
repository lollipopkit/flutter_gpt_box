part of '../tool.dart';

/// Fetches a URL for the model: a page as Markdown, text as it is, an image
/// as an image, paged so a long one does not fill the context.
final class TfHttpReq extends ToolFunc {
  static const instance = TfHttpReq._();

  // The name predates what the tool became; kept, as permissions and old
  // chats refer to it.
  const TfHttpReq._()
    : super(
        name: 'httpReq',
        parametersSchema: const {
          'type': 'object',
          'properties': {
            'url': {'type': 'string', 'description': 'http(s) URL'},
            'method': {'type': 'string', 'description': 'HTTP method. Default GET.'},
            'headers': {
              'type': 'object',
              'additionalProperties': {'type': 'string'},
              'description': 'Request headers',
            },
            'body': {'type': 'string', 'description': 'Request body; JSON as a string.'},
            'raw': {'type': 'boolean', 'description': 'Return HTML as it is instead of as Markdown. Default false.'},
            'start_index': {
              'type': 'integer',
              'description': 'Return the text from this character on, to read past a truncated response. Default 0.',
            },
            'max_length': {
              'type': 'integer',
              'description': 'At most this many characters. Default $_defaultLength, at most $_maxLength.',
            },
          },
          'required': ['url'],
        },
      );

  static const _defaultLength = 20000;
  static const _maxLength = 100000;

  /// Bytes read at most; the rest of a response is not downloaded.
  static const _maxBytes = 5 * 1024 * 1024;

  /// Image types models take.
  static const _imageTypes = {'image/png', 'image/jpeg', 'image/gif', 'image/webp'};

  /// Its own client: nothing of the app's own requests (headers, base
  /// options) goes to the sites the model visits.
  static final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (_) => true,
      responseType: ResponseType.stream,
      maxRedirects: 5,
      headers: {'user-agent': 'Mozilla/5.0 (compatible; ${BuildData.name}/1.0)'},
    ),
  );

  @override
  String get description => '''
Fetch a URL. HTML pages come back as Markdown (links kept), text and JSON as they are, images as images.
Use it to read pages and call public APIs (prefer a JSON API when one exists). The response starts with the status, type and final URL.
A long response is cut at max_length; read on with start_index.''';

  @override
  String get l10nName => l10n.toolHttpReqName;

  @override
  String? get l10nTip => l10n.httpToolTip;

  @override
  String summary(_Map args) => '${(args['method'] as String? ?? 'GET').toUpperCase()} ${args['url'] ?? ''}';

  @override
  Future<LlmToolResult> run(_Map args, ToolCtx ctx) async {
    final url = Uri.tryParse(args['url'] as String? ?? '');
    if (url == null || !(url.isScheme('http') || url.isScheme('https')) || url.host.isEmpty) {
      throw ArgumentError('An http(s) URL is required');
    }
    final method = (args['method'] as String? ?? 'GET').toUpperCase();
    final raw = args['raw'] == true;
    final start = (args['start_index'] as num? ?? 0).toInt().clamp(0, 1 << 30);
    final max = (args['max_length'] as num? ?? _defaultLength).toInt().clamp(1, _maxLength);

    final ct = CancelToken();
    unawaited(ctx.cancel.whenCancelled.then((_) => ct.cancel()));
    _log('$method $url');
    final resp = await _dio.requestUri<ResponseBody>(
      url,
      data: args['body'] as String?,
      options: Options(
        method: method,
        headers: {for (final MapEntry(:key, :value) in ((args['headers'] as Map?) ?? const {}).entries) '$key': '$value'},
      ),
      cancelToken: ct,
    );

    final bytes = BytesBuilder(copy: false);
    var cut = false;
    await for (final chunk in resp.data!.stream) {
      bytes.add(chunk);
      if (bytes.length > _maxBytes) {
        cut = true;
        break;
      }
    }
    final data = bytes.takeBytes();
    final type = resp.headers.value('content-type') ?? '';
    final mime = type.split(';').first.trim().toLowerCase();
    final head = 'HTTP ${resp.statusCode} ${resp.statusMessage ?? ''}'.trim();
    final info = '$head · ${mime.isEmpty ? 'unknown type' : mime} · ${resp.realUri}';
    final details = {'status': resp.statusCode};

    if (_imageTypes.contains(mime) && !cut) {
      return LlmToolResult(
        content: [LlmContent.text('$info · ${data.length} bytes'), LlmContent.image(base64.encode(data), mime)],
        details: details,
      );
    }
    if (!_isText(mime, data)) {
      return LlmToolResult.text('$info\n\nBinary content, ${data.length}${cut ? '+' : ''} bytes: not shown.', details: details);
    }

    var text = _decode(data, type);
    if (!raw && (mime == 'text/html' || mime == 'application/xhtml+xml')) {
      text = await compute(htmlToMarkdown, (text, resp.realUri.toString()));
    }
    final end = (start + max).clamp(0, text.length);
    final page = start >= text.length ? '' : text.substring(start, end);
    final notes = [
      if (start > 0) 'Showing characters $start–$end of ${text.length}.',
      if (end < text.length) 'Truncated: ${text.length - end} more characters; call again with start_index $end.',
      if (cut) 'The response was larger than ${_maxBytes ~/ 1024 ~/ 1024} MB; only the start was downloaded.',
    ];
    return LlmToolResult.text(
      [info, if (page.isNotEmpty) page else '(empty)', ...notes].join('\n\n'),
      details: details,
    );
  }

  static bool _isText(String mime, List<int> data) {
    if (mime.startsWith('text/')) return true;
    if (RegExp(r'json|xml|javascript|yaml|csv|x-www-form-urlencoded|graphql').hasMatch(mime)) return true;
    if (mime.startsWith('image/') || mime.startsWith('audio/') || mime.startsWith('video/')) return false;
    // Untyped or generic: text if the start has no NUL byte.
    return !data.take(1024).contains(0);
  }

  static String _decode(List<int> data, String contentType) {
    final charset = RegExp(r'charset=([\w-]+)', caseSensitive: false).firstMatch(contentType)?.group(1)?.toLowerCase();
    return switch (charset) {
      'iso-8859-1' || 'latin1' || 'us-ascii' || 'ascii' => latin1.decode(data, allowInvalid: true),
      _ => utf8.decode(data, allowMalformed: true),
    };
  }
}
