import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

enum HlsProxyResourceType { playlist, fmp4, transportStream, subtitle, key }

typedef HlsProxyUrlBuilder = String Function(
  Uri upstream,
  HlsProxyResourceType type,
);

/// Rewrites every URI in an HLS playlist so the player only talks to the
/// loopback proxy. This also gives disguised fMP4 segments a media extension,
/// which lets players identify them from their contents instead of rejecting
/// an upstream `.html` suffix before probing the bytes.
String rewriteHlsPlaylist(
  String body,
  Uri playlistUri,
  HlsProxyUrlBuilder buildProxyUrl,
) {
  final isMaster =
      body.contains('#EXT-X-STREAM-INF') || body.contains('#EXT-X-MEDIA:');
  final usesFmp4 = body.contains('#EXT-X-MAP:');
  final uriAttribute = RegExp(r'URI="([^"]+)"');
  final lines = const LineSplitter().convert(body);
  final rewritten = <String>[];

  for (final line in lines) {
    if (line.startsWith('#')) {
      rewritten.add(
        line.replaceAllMapped(uriAttribute, (match) {
          final reference = match.group(1)!;
          final type = switch (line) {
            String value when value.startsWith('#EXT-X-MAP:') =>
              HlsProxyResourceType.fmp4,
            String value
                when value.startsWith('#EXT-X-KEY:') ||
                    value.startsWith('#EXT-X-SESSION-KEY:') =>
              HlsProxyResourceType.key,
            String value
                when value.startsWith('#EXT-X-MEDIA:') ||
                    value.startsWith('#EXT-X-I-FRAME-STREAM-INF:') ||
                    value.startsWith('#EXT-X-RENDITION-REPORT:') =>
              HlsProxyResourceType.playlist,
            String value
                when value.startsWith('#EXT-X-PART:') ||
                    value.startsWith('#EXT-X-PRELOAD-HINT:') =>
              _mediaResourceType(reference, usesFmp4),
            _ => HlsProxyResourceType.playlist,
          };
          return 'URI="${_rewriteReference(reference, type, playlistUri, buildProxyUrl)}"';
        }),
      );
      continue;
    }

    if (line.trim().isEmpty) {
      rewritten.add(line);
      continue;
    }

    final type = isMaster
        ? HlsProxyResourceType.playlist
        : _mediaResourceType(line, usesFmp4);
    rewritten.add(
      _rewriteReference(line.trim(), type, playlistUri, buildProxyUrl),
    );
  }

  return '${rewritten.join('\n')}\n';
}

HlsProxyResourceType _mediaResourceType(String reference, bool usesFmp4) {
  if (usesFmp4) return HlsProxyResourceType.fmp4;

  final path = Uri.tryParse(reference)?.path.toLowerCase() ?? '';
  if (path.endsWith('.m3u8')) return HlsProxyResourceType.playlist;
  if (path.endsWith('.vtt')) return HlsProxyResourceType.subtitle;
  if (path.endsWith('.mp4') || path.endsWith('.m4s') || path.endsWith('.m4a')) {
    return HlsProxyResourceType.fmp4;
  }
  return HlsProxyResourceType.transportStream;
}

String _rewriteReference(
  String reference,
  HlsProxyResourceType type,
  Uri playlistUri,
  HlsProxyUrlBuilder buildProxyUrl,
) {
  try {
    return buildProxyUrl(playlistUri.resolve(reference), type);
  } on FormatException {
    return reference;
  }
}

class HlsProxyService {
  HlsProxyService._();

  static final HlsProxyService instance = HlsProxyService._();

  static const _maxSessions = 32;
  static const _sessionLifetime = Duration(hours: 4);
  static const _maxPlaylistBytes = 4 * 1024 * 1024;

  final _client = http.Client();
  final _random = Random.secure();
  final _sessions = <String, _HlsProxySession>{};
  HttpServer? _server;
  Future<HttpServer>? _startingServer;

  Future<String> createUrl(
    String upstreamUrl,
    Map<String, String> headers,
  ) async {
    final upstream = _validatedUpstream(upstreamUrl);
    final server = await _ensureServer();
    _removeExpiredSessions();

    while (_sessions.length >= _maxSessions) {
      _sessions.remove(_sessions.entries.first.key);
    }

    final token = _createToken();
    _sessions[token] = _HlsProxySession(Map.unmodifiable(headers));
    return _buildUrl(server, token, upstream, HlsProxyResourceType.playlist);
  }

  Future<HttpServer> _ensureServer() {
    final existing = _server;
    if (existing != null) return Future.value(existing);
    final starting = _startingServer;
    if (starting != null) return starting;

    final future = _bindServer();
    _startingServer = future;
    unawaited(
      future.then<void>(
        (_) {
          if (identical(_startingServer, future)) _startingServer = null;
        },
        onError: (Object _, StackTrace _) {
          if (identical(_startingServer, future)) _startingServer = null;
        },
      ),
    );
    return future;
  }

  Future<HttpServer> _bindServer() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server = server;
    unawaited(
      server.forEach(_handleRequest).catchError((Object _) {
        if (identical(_server, server)) _server = null;
      }),
    );
    return server;
  }

  Future<void> _handleRequest(HttpRequest request) async {
    try {
      if (request.method != 'GET' && request.method != 'HEAD') {
        request.response.statusCode = HttpStatus.methodNotAllowed;
        request.response.headers.set(HttpHeaders.allowHeader, 'GET, HEAD');
        await request.response.close();
        return;
      }

      final segments = request.uri.pathSegments;
      final token = segments.isEmpty ? '' : segments.first;
      final session = _sessions[token];
      if (session == null || session.isExpired) {
        _sessions.remove(token);
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        return;
      }
      session.touch();

      final encodedTarget = request.uri.queryParameters['url'];
      if (encodedTarget == null) throw const FormatException('Missing URL');
      final upstream = _validatedUpstream(
        utf8.decode(base64Url.decode(base64Url.normalize(encodedTarget))),
      );

      final upstreamRequest = http.Request(request.method, upstream);
      _copyRequestHeaders(session.headers, upstreamRequest.headers);
      upstreamRequest.headers[HttpHeaders.acceptEncodingHeader] = 'identity';
      final range = request.headers.value(HttpHeaders.rangeHeader);
      if (range != null) {
        upstreamRequest.headers[HttpHeaders.rangeHeader] = range;
      }

      final upstreamResponse = await _client.send(upstreamRequest);
      request.response.statusCode = upstreamResponse.statusCode;
      _copyHeaders(upstreamResponse.headers, request.response.headers);

      final isPlaylist = segments.length >= 2 && segments[1].endsWith('.m3u8');
      if (request.method == 'HEAD') {
        request.response.headers.contentType = isPlaylist
            ? ContentType('application', 'vnd.apple.mpegurl', charset: 'utf-8')
            : _contentTypeForPath(segments.length >= 2 ? segments[1] : '');
        if (!isPlaylist && upstreamResponse.contentLength != null) {
          request.response.contentLength = upstreamResponse.contentLength!;
        }
        await request.response.close();
        return;
      }

      if (isPlaylist &&
          upstreamResponse.statusCode >= 200 &&
          upstreamResponse.statusCode < 300) {
        final bytes = await _readLimited(
          upstreamResponse.stream,
          _maxPlaylistBytes,
        );
        final body = utf8.decode(bytes, allowMalformed: true);
        final effectiveUri = upstreamResponse.request?.url ?? upstream;
        final rewritten = rewriteHlsPlaylist(
          body,
          effectiveUri,
          (target, type) => _buildUrl(_server!, token, target, type),
        );
        final output = utf8.encode(rewritten);
        request.response.headers
          ..removeAll(HttpHeaders.contentEncodingHeader)
          ..contentType = ContentType(
            'application',
            'vnd.apple.mpegurl',
            charset: 'utf-8',
          )
          ..contentLength = output.length;
        request.response.add(output);
      } else {
        request.response.headers.contentType = _contentTypeForPath(
          segments.length >= 2 ? segments[1] : '',
        );
        if (upstreamResponse.contentLength != null) {
          request.response.contentLength = upstreamResponse.contentLength!;
        }
        await request.response.addStream(upstreamResponse.stream);
      }
      await request.response.close();
    } on FormatException {
      await _sendBadGateway(request.response);
    } on StateError {
      await _sendBadGateway(request.response);
    } on http.ClientException {
      await _sendBadGateway(request.response);
    } on SocketException {
      await _sendBadGateway(request.response);
    }
  }

  String _buildUrl(
    HttpServer server,
    String token,
    Uri upstream,
    HlsProxyResourceType type,
  ) {
    final encoded = base64UrlEncode(utf8.encode(upstream.toString()))
        .replaceAll('=', '');
    return Uri(
      scheme: 'http',
      host: InternetAddress.loopbackIPv4.address,
      port: server.port,
      pathSegments: [token, _fileNameFor(type)],
      queryParameters: {'url': encoded},
    ).toString();
  }

  Uri _validatedUpstream(String value) {
    final uri = Uri.parse(value);
    if (!uri.hasAuthority || (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw const FormatException('Only HTTP(S) URLs can be proxied');
    }
    return uri;
  }

  String _createToken() {
    final bytes = Uint8List.fromList(
      List<int>.generate(32, (_) => _random.nextInt(256)),
    );
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  void _removeExpiredSessions() {
    _sessions.removeWhere((_, session) => session.isExpired);
  }

  static void _copyHeaders(
    Map<String, String> upstream,
    HttpHeaders downstream,
  ) {
    const skipped = {
      HttpHeaders.connectionHeader,
      HttpHeaders.contentEncodingHeader,
      HttpHeaders.contentLengthHeader,
      HttpHeaders.contentTypeHeader,
      'keep-alive',
      HttpHeaders.setCookieHeader,
      HttpHeaders.transferEncodingHeader,
    };
    for (final entry in upstream.entries) {
      if (!skipped.contains(entry.key.toLowerCase())) {
        downstream.set(entry.key, entry.value);
      }
    }
  }

  static void _copyRequestHeaders(
    Map<String, String> source,
    Map<String, String> destination,
  ) {
    const skipped = {
      HttpHeaders.acceptEncodingHeader,
      HttpHeaders.connectionHeader,
      HttpHeaders.contentLengthHeader,
      HttpHeaders.hostHeader,
      'keep-alive',
      HttpHeaders.transferEncodingHeader,
    };
    for (final entry in source.entries) {
      if (!skipped.contains(entry.key.toLowerCase())) {
        destination[entry.key] = entry.value;
      }
    }
  }

  static Future<List<int>> _readLimited(
    Stream<List<int>> stream,
    int maximumBytes,
  ) async {
    final output = BytesBuilder(copy: false);
    await for (final chunk in stream) {
      if (output.length + chunk.length > maximumBytes) {
        throw StateError('HLS playlist is too large');
      }
      output.add(chunk);
    }
    return output.takeBytes();
  }

  static Future<void> _sendBadGateway(HttpResponse response) async {
    try {
      response.statusCode = HttpStatus.badGateway;
      response.headers.contentType = ContentType.text;
      response.write('Unable to load the HLS resource');
    } on StateError {
      // The upstream stream can fail after headers have already been sent.
      // Closing the local response is the only safe recovery at that point.
    }
    await response.close();
  }
}

class _HlsProxySession {
  _HlsProxySession(this.headers) : _lastUsed = DateTime.now();

  final Map<String, String> headers;
  DateTime _lastUsed;

  bool get isExpired =>
      DateTime.now().difference(_lastUsed) > HlsProxyService._sessionLifetime;

  void touch() => _lastUsed = DateTime.now();
}

String _fileNameFor(HlsProxyResourceType type) => switch (type) {
  HlsProxyResourceType.playlist => 'playlist.m3u8',
  HlsProxyResourceType.fmp4 => 'segment.mp4',
  HlsProxyResourceType.transportStream => 'segment.ts',
  HlsProxyResourceType.subtitle => 'subtitle.vtt',
  HlsProxyResourceType.key => 'key.bin',
};

ContentType _contentTypeForPath(String path) {
  if (path.endsWith('.m3u8')) {
    return ContentType('application', 'vnd.apple.mpegurl', charset: 'utf-8');
  }
  if (path.endsWith('.mp4')) return ContentType('video', 'mp4');
  if (path.endsWith('.ts')) return ContentType('video', 'mp2t');
  if (path.endsWith('.vtt')) {
    return ContentType('text', 'vtt', charset: 'utf-8');
  }
  return ContentType.binary;
}
