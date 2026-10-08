import 'dart:convert';
import 'dart:io';

import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/javascript/utils.dart';
import 'package:mangayomi/services/http/hls_proxy.dart';

void main() {
  String proxyUrl(Uri upstream, HlsProxyResourceType type) {
    final suffix = switch (type) {
      HlsProxyResourceType.playlist => 'playlist.m3u8',
      HlsProxyResourceType.fmp4 => 'segment.mp4',
      HlsProxyResourceType.transportStream => 'segment.ts',
      HlsProxyResourceType.subtitle => 'subtitle.vtt',
      HlsProxyResourceType.key => 'key.bin',
    };
    return 'http://127.0.0.1/session/$suffix?url='
        '${base64UrlEncode(utf8.encode(upstream.toString()))}';
  }

  test('rewrites master variants and rendition playlists', () {
    const playlist = '''
#EXTM3U
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",URI="audio/en.m3u8"
#EXT-X-STREAM-INF:BANDWIDTH=2400000,AUDIO="audio"
video/1080/index.m3u8
''';

    final result = rewriteHlsPlaylist(
      playlist,
      Uri.parse('https://cdn.example/path/master.m3u8'),
      proxyUrl,
    );

    expect(result, contains('/playlist.m3u8?url='));
    expect(
      result,
      contains(
        base64UrlEncode(utf8.encode('https://cdn.example/path/audio/en.m3u8')),
      ),
    );
    expect(
      result,
      contains(
        base64UrlEncode(
          utf8.encode('https://cdn.example/path/video/1080/index.m3u8'),
        ),
      ),
    );
  });

  test('gives disguised fMP4 initialization and media chunks mp4 paths', () {
    const playlist = '''
#EXTM3U
#EXT-X-MAP:URI="init_0_0.html"
#EXTINF:4.0,
segment_0_1.html
''';

    final result = rewriteHlsPlaylist(
      playlist,
      Uri.parse('https://cdn.example/media/index.m3u8'),
      proxyUrl,
    );

    expect(RegExp(r'/segment\.mp4\?url=').allMatches(result), hasLength(2));
    expect(result, isNot(contains('.html"')));
  });

  test('rewrites encryption keys and ordinary transport stream segments', () {
    const playlist = '''
#EXTM3U
#EXT-X-KEY:METHOD=AES-128,URI="../keys/episode.key"
#EXTINF:4.0,
segments/1.ts
''';

    final result = rewriteHlsPlaylist(
      playlist,
      Uri.parse('https://cdn.example/media/index.m3u8'),
      proxyUrl,
    );

    expect(result, contains('/key.bin?url='));
    expect(result, contains('/segment.ts?url='));
    expect(
      result,
      contains(
        base64UrlEncode(utf8.encode('https://cdn.example/keys/episode.key')),
      ),
    );
  });

  test('rewrites low-latency HLS parts as fMP4 resources', () {
    const playlist = '''
#EXTM3U
#EXT-X-MAP:URI="init.html"
#EXT-X-PART:DURATION=0.5,URI="part-1.html"
#EXT-X-PRELOAD-HINT:TYPE=PART,URI="part-2.html"
''';

    final result = rewriteHlsPlaylist(
      playlist,
      Uri.parse('https://cdn.example/media/index.m3u8'),
      proxyUrl,
    );

    expect(RegExp(r'/segment\.mp4\?url=').allMatches(result), hasLength(3));
  });

  test('proxies disguised fMP4 bytes with a media type and length', () async {
    final upstream = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => upstream.close(force: true));
    upstream.listen((request) async {
      if (request.uri.path == '/master.m3u8') {
        request.response.write(
          '#EXTM3U\n#EXT-X-STREAM-INF:BANDWIDTH=1000\nmedia.m3u8\n',
        );
      } else if (request.uri.path == '/media.m3u8') {
        request.response.write(
          '#EXTM3U\n#EXT-X-MAP:URI="init.html"\n'
          '#EXTINF:4,\nchunk.html\n',
        );
      } else {
        request.response
          ..headers.contentType = ContentType.html
          ..contentLength = 8
          ..add([0, 0, 0, 16, 109, 111, 111, 102]);
      }
      await request.response.close();
    });

    final client = HttpClient();
    addTearDown(() => client.close(force: true));
    final localMaster = await HlsProxyService.instance.createUrl(
      'http://127.0.0.1:${upstream.port}/master.m3u8',
      const {},
    );
    final master = await _readText(client, localMaster);
    final localMedia = master
        .split('\n')
        .firstWhere((line) => line.startsWith('http://'));
    final media = await _readText(client, localMedia);
    final segmentUrl = RegExp(
      r'http://[^\s"]+/segment\.mp4\?[^\s"]+',
    ).allMatches(media).last.group(0)!;

    final request = await client.getUrl(Uri.parse(segmentUrl));
    final response = await request.close();
    final bytes = await response.fold<int>(
      0,
      (total, chunk) => total + chunk.length,
    );

    expect(response.statusCode, HttpStatus.ok);
    expect(response.headers.contentType?.mimeType, 'video/mp4');
    expect(response.contentLength, 8);
    expect(bytes, 8);
  });

  test('JavaScript extensions can create a loopback HLS URL', () async {
    final runtime = getJavascriptRuntime();
    JsUtils(runtime).init();

    final evaluated = await runtime.evaluateAsync(
      'createHlsProxyUrl("https://cdn.example/master.m3u8", '
      '{"Referer":"https://example.com/"})',
    );
    final result = await runtime.handlePromise(evaluated);

    expect(result.isError, isFalse);
    expect(result.stringResult, startsWith('http://127.0.0.1:'));
    expect(result.stringResult, contains('/playlist.m3u8?url='));
  });
}

Future<String> _readText(HttpClient client, String url) async {
  final request = await client.getUrl(Uri.parse(url));
  final response = await request.close();
  expect(response.statusCode, HttpStatus.ok);
  return utf8.decoder.bind(response).join();
}
