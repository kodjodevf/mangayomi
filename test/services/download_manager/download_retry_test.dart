import 'dart:io';
import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/download_manager/download_isolate_pool.dart';
import 'package:mangayomi/services/download_manager/download_retry.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/download.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/ts_info.dart';

/// A server answering 429 is waited on rather than asked again at once
/// (#1087).
void main() {
  group('a response that asks to slow down', () {
    test('is a 429 or a 503, not another failure', () {
      expect(RateLimitedException.fromResponse(429, null), isNotNull);
      expect(RateLimitedException.fromResponse(503, null), isNotNull);
      expect(RateLimitedException.fromResponse(404, '5'), isNull);
      expect(RateLimitedException.fromResponse(500, null), isNull);
    });

    test('carries the wait it asked for', () {
      final limited = RateLimitedException.fromResponse(429, '7')!;
      expect(limited.retryAfter, const Duration(seconds: 7));
    });
  });

  group('Retry-After', () {
    test('in seconds', () {
      expect(parseRetryAfter('120'), const Duration(seconds: 120));
      expect(parseRetryAfter(' 3 '), const Duration(seconds: 3));
    });

    test('as a date', () {
      final now = DateTime.utc(2026, 10, 31, 12);
      final later = HttpDate.format(now.add(const Duration(seconds: 30)));
      expect(parseRetryAfter(later, now: now), const Duration(seconds: 30));
    });

    test('a date already past waits nothing', () {
      final now = DateTime.utc(2026, 10, 31, 12);
      final earlier = HttpDate.format(now.subtract(const Duration(hours: 1)));
      expect(parseRetryAfter(earlier, now: now), Duration.zero);
    });

    test('absent or unreadable is no wait asked', () {
      expect(parseRetryAfter(null), isNull);
      expect(parseRetryAfter('soon'), isNull);
    });
  });

  group('the wait between attempts', () {
    test('doubles from half a second, up to 16 s', () {
      expect(retryDelay(1), const Duration(milliseconds: 500));
      expect(retryDelay(2), const Duration(seconds: 1));
      expect(retryDelay(3), const Duration(seconds: 2));
      expect(retryDelay(10), const Duration(seconds: 16));
    });

    test('is what the server asked, up to a minute', () {
      expect(
        retryDelay(1, retryAfter: const Duration(seconds: 5)),
        const Duration(seconds: 5),
      );
      expect(
        retryDelay(1, retryAfter: const Duration(hours: 1)),
        maxRetryDelay,
      );
    });
  });

  test('a segment refused with 429 is fetched once the wait is over', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    var requests = 0;
    server.listen((request) async {
      requests++;
      if (requests == 1) {
        request.response
          ..statusCode = 429
          ..headers.set('retry-after', '1');
      } else {
        request.response.add([1, 2, 3, 4]);
      }
      await request.response.close();
    });
    final dir = Directory.systemTemp.createTempSync('m3u8_retry');
    addTearDown(() => dir.deleteSync(recursive: true));
    final port = ReceivePort();
    addTearDown(port.close);
    final client = http.Client();
    addTearDown(client.close);

    final started = DateTime.now();
    await processM3u8Download(
      M3u8DownloadParams(
        segments: [TsInfo('TS_1', 'http://127.0.0.1:${server.port}/s.ts')],
        tempDir: dir.path,
        key: null,
        iv: null,
        mediaSequence: null,
        concurrentDownloads: 1,
        headers: null,
        itemType: ItemType.anime,
      ),
      port.sendPort,
      client,
    );
    final messages = await port.take(2).toList();

    expect(messages.last, isA<DownloadComplete>());
    expect(requests, 2);
    expect(
      DateTime.now().difference(started),
      greaterThanOrEqualTo(const Duration(seconds: 1)),
      reason: 'the wait the server asked for',
    );
    expect(File('${dir.path}/TS_1.ts').readAsBytesSync(), [1, 2, 3, 4]);
  });
}
