import 'dart:io';
import 'dart:async';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/download_manager/download_isolate_pool.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/ts_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/download_manager/m3u8/m3u8_downloader.dart';

void main() {
  test('temporary paths stay short and distinguish stream variants', () {
    final url = 'https://example.com/${List.filled(300, 'episode').join()}';
    expect(m3u8TempDirectoryName(url).length, lessThan(32));
    expect(m3u8TempDirectoryName(url), m3u8TempDirectoryName(url));
    expect(
      m3u8TempDirectoryName('$url/other'),
      isNot(m3u8TempDirectoryName(url)),
    );
  });

  test('merge uses playlist order and ignores leftover files', () async {
    final dir = await Directory.systemTemp.createTemp('hls_test');
    addTearDown(() => dir.delete(recursive: true));
    await File('${dir.path}/TS_2.ts').writeAsBytes([2]);
    await File('${dir.path}/TS_1.ts').writeAsBytes([1]);
    await File('${dir.path}/TS_3.ts').writeAsBytes([99]);
    final output = '${dir.path}/video.mp4';
    await mergeM3u8Segments(output, dir.path, 2);
    expect(await File(output).readAsBytes(), [1, 2]);
  });

  test('failed merge preserves output and removes partial output', () async {
    final dir = await Directory.systemTemp.createTemp('hls_test');
    addTearDown(() => dir.delete(recursive: true));
    await File('${dir.path}/TS_1.ts').writeAsBytes([1]);
    final output = '${dir.path}/video.mp4';
    await File(output).writeAsBytes([42]);
    await expectLater(mergeM3u8Segments(output, dir.path, 2), throwsStateError);
    expect(await File(output).readAsBytes(), [42]);
    expect(await File('$output.part').exists(), isFalse);
  });

  test(
    'segment retries HTTP errors and interrupted bodies before publishing',
    () async {
      final dir = await Directory.systemTemp.createTemp('hls_test');
      final port = ReceivePort();
      addTearDown(port.close);
      addTearDown(() => dir.delete(recursive: true));
      var attempts = 0;
      final client = MockClient.streaming((request, _) async {
        attempts++;
        if (attempts == 1) return http.StreamedResponse(Stream.value([0]), 503);
        if (attempts == 2) {
          return http.StreamedResponse(() async* {
            yield [9];
            throw http.ClientException('connection interrupted');
          }(), 200);
        }
        return http.StreamedResponse(
          Stream.value([1, 2, 3]),
          200,
          contentLength: 3,
        );
      });
      addTearDown(client.close);
      await processM3u8Download(
        M3u8DownloadParams(
          segments: [TsInfo('TS_1', 'https://example.com/1.ts')],
          tempDir: dir.path,
          key: null,
          iv: null,
          mediaSequence: null,
          headers: null,
          concurrentDownloads: 2,
          itemType: ItemType.anime,
        ),
        port.sendPort,
        client,
      );
      expect(attempts, 3);
      expect(await File('${dir.path}/TS_1.ts').readAsBytes(), [1, 2, 3]);
      expect(await File('${dir.path}/TS_1.ts.part').exists(), isFalse);
    },
  );

  test('free slots continue while another segment is stalled', () async {
    final dir = await Directory.systemTemp.createTemp('hls_test');
    final port = ReceivePort();
    addTearDown(port.close);
    addTearDown(() => dir.delete(recursive: true));
    final releaseFirst = Completer<void>();
    final thirdStarted = Completer<void>();
    final client = MockClient.streaming((request, _) async {
      if (request.url.path == '/1.ts') await releaseFirst.future;
      if (request.url.path == '/3.ts') thirdStarted.complete();
      return http.StreamedResponse(Stream.value([1]), 200);
    });
    addTearDown(client.close);
    final download = processM3u8Download(
      M3u8DownloadParams(
        segments: List.generate(
          3,
          (i) => TsInfo('TS_${i + 1}', 'https://example.com/${i + 1}.ts'),
        ),
        tempDir: dir.path,
        key: null,
        iv: null,
        mediaSequence: null,
        headers: null,
        concurrentDownloads: 2,
        itemType: ItemType.anime,
      ),
      port.sendPort,
      client,
    );
    try {
      await thirdStarted.future.timeout(const Duration(seconds: 5));
    } finally {
      releaseFirst.complete();
      await download;
    }
  });

  test('resolves ordinary playlist references relative to the playlist', () {
    expect(
      resolveM3u8Reference(
        'https://cdn.example/video/master.m3u8',
        'segments/1.ts',
      ),
      'https://cdn.example/video/segments/1.ts',
    );
    expect(
      resolveM3u8Reference(
        'https://cdn.example/video/master.m3u8',
        '/segments/1.ts',
      ),
      'https://cdn.example/segments/1.ts',
    );
  });

  test('roots Mihon video proxy references at the video route', () {
    expect(
      resolveM3u8Reference(
        'http://127.0.0.1:54758/video/master-token',
        'video/variant-token.m3u8',
      ),
      'http://127.0.0.1:54758/video/variant-token.m3u8',
    );
    expect(
      resolveM3u8Reference(
        'http://127.0.0.1:54758/video/master-token.m3u8',
        '/video/segment-token.ts',
      ),
      'http://127.0.0.1:54758/video/segment-token.ts',
    );
  });

  test('selects the highest-bandwidth master playlist variant', () {
    const body = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=800000
low/index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2400000
high/index.m3u8
''';

    expect(
      selectM3u8VariantUrl('https://cdn.example/master.m3u8', body),
      'https://cdn.example/high/index.m3u8',
    );
    expect(
      selectM3u8VariantUrl(
        'https://cdn.example/media.m3u8',
        '#EXTM3U\n#EXTINF:4,\nsegment.ts\n',
      ),
      isNull,
    );
  });
}
