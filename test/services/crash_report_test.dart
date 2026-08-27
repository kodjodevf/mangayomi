import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/services/crash_report_issue.dart';
import 'package:path/path.dart' as p;

void main() {
  group('redaction', () {
    // The reason a report can be sent at all: it must not carry what the
    // reader was reading, or where on their disk they keep it.
    test('a url keeps its host and loses everything after it', () {
      expect(
        redact('Failed to load https://example.test/manga/one-piece/ch-1.jpg'),
        'Failed to load https://example.test/...',
      );
    });

    test(
      'a home directory becomes a tilde, taking the account name with it',
      () {
        expect(
          redact('FileSystemException: /Users/somebody/Mangayomi/logs.txt'),
          contains('~/Mangayomi/logs.txt'),
        );
        expect(
          redact(r'at C:\Users\somebody\AppData\file.dart'),
          isNot(contains('somebody')),
        );
      },
    );

    test('anything credential-shaped is removed, not just masked in part', () {
      final out = redact(
        '{cookie: cf_clearance=abc123, authorization: Bearer x}',
      );
      expect(out, isNot(contains('abc123')));
      expect(out, isNot(contains('Bearer')));
      expect(out, contains('<removed>'));
    });

    test('an ordinary message is left alone', () {
      expect(
        redact('RangeError: index out of range'),
        'RangeError: index out of range',
      );
    });
  });

  group('likely cause', () {
    test('names the ones worth naming', () {
      expect(
        describeLikelyCause('SocketException: Failed host lookup'),
        contains('network'),
      );
      expect(
        describeLikelyCause(
          'IsarError: Cannot perform this operation from within an active transaction',
        ),
        contains('database write'),
      );
      expect(
        describeLikelyCause('UnimplementedError: Sharing files not supported'),
        contains('not implemented'),
      );
    });

    test('stays quiet rather than guessing at something it does not know', () {
      expect(
        describeLikelyCause('Something entirely novel went wrong'),
        isNull,
      );
    });
  });

  group('the kept reports', () {
    late Directory directory;

    setUp(() async {
      directory = Directory.systemTemp.createTempSync('crash_reports');
      CrashReports.resetForTest();
      await CrashReports.init(directory);
    });

    tearDown(() {
      if (directory.existsSync()) directory.deleteSync(recursive: true);
    });

    File file() => File(p.join(directory.path, 'crash_reports.json'));

    test('a recorded error survives a restart', () async {
      CrashReports.screen = '/mangaDetail';
      CrashReports.record(
        source: 'FlutterError',
        error: StateError('boom'),
        stack: StackTrace.fromString('#0 somewhere'),
      );

      await CrashReports.init(directory); // as if the app started again

      expect(CrashReports.reports, hasLength(1));
      expect(CrashReports.latest!.error, contains('boom'));
      expect(CrashReports.latest!.screen, '/mangaDetail');
    });

    test(
      'the file is capped rather than grown for the life of the install',
      () async {
        for (var i = 0; i < 30; i++) {
          CrashReports.record(source: 'test', error: 'error $i');
        }

        expect(CrashReports.reports, hasLength(10));
        expect(CrashReports.reports.first.error, 'error 20');
        final stored = jsonDecode(file().readAsStringSync()) as Map;
        expect(stored['reports'], hasLength(10));
      },
    );

    test('an error is offered once, then stays quiet', () {
      CrashReports.record(source: 'test', error: 'once');

      expect(CrashReports.hasUnseen, true);
      CrashReports.markSeen();
      expect(CrashReports.hasUnseen, false);

      CrashReports.record(source: 'test', error: 'again');
      expect(CrashReports.hasUnseen, true, reason: 'a new one is new');
    });

    test('a corrupt file loses the history rather than the launch', () async {
      file().writeAsStringSync('not json at all');

      await CrashReports.init(directory);

      expect(CrashReports.reports, isEmpty);
    });

    test('recording before storage is ready is not lost', () async {
      // The handlers are installed before the storage directory is resolved,
      // so a startup error arrives before init has anywhere to put it.
      CrashReports.resetForTest();
      final fresh = Directory.systemTemp.createTempSync('crash_early');
      addTearDown(() => fresh.deleteSync(recursive: true));

      CrashReports.record(source: 'startup', error: 'DB init failed');
      await CrashReports.init(fresh);

      expect(
        CrashReports.reports.map((e) => e.error),
        contains('DB init failed'),
      );
      expect(File(p.join(fresh.path, 'crash_reports.json')).existsSync(), true);
    });
  });

  group('an expected failure', () {
    setUp(CrashReports.resetForTest);
    tearDown(CrashReports.resetForTest);

    test('is recognised from what the app actually reports', () {
      // Captured from #915 and #916, both filed as bugs through the reporter.
      expect(
        isExpectedFailure('Bad state: Failed to load https://manhwaz.com/...'),
        true,
      );
      expect(
        isExpectedFailure(
          'Bad state: Failed to load https://cdn.jsdelivr.net/...',
        ),
        true,
      );
      expect(
        isExpectedFailure("SocketException: Failed host lookup: 'x.test'"),
        true,
      );
    });

    test('the Rust http stack failing is the same network failure', () {
      // #933, a transport error one layer below SocketException.
      expect(
        isExpectedFailure(
          '[RhttpUnknownException] hyper_util::client::legacy::Error',
        ),
        true,
      );
    });

    test('and what a failed download decodes to afterwards', () {
      // #927, whose own recent-errors block shows two failed page loads
      // seconds before it. The bytes that arrived were not an image.
      expect(isExpectedFailure('Exception: Could not decompress image.'), true);
      expect(isExpectedFailure('Exception: Invalid image data'), true);
    });

    test('an app bug is not one of them', () {
      expect(
        isExpectedFailure(
          "Runtime Error: Undefined property or method 'toList'",
        ),
        false,
      );
      expect(
        isExpectedFailure('Null check operator used on a null value'),
        false,
      );
      expect(
        isExpectedFailure('PanicException(Expect rustls-platform-verifier)'),
        false,
      );
    });

    test('is kept, but does not interrupt the reader', () async {
      final directory = Directory.systemTemp.createTempSync('expected');
      addTearDown(() => directory.deleteSync(recursive: true));
      await CrashReports.init(directory);

      CrashReports.record(
        source: 'FlutterError',
        error: 'Bad state: Failed to load https://example.test/...',
      );

      expect(CrashReports.reports, hasLength(1), reason: 'still recorded');
      expect(CrashReports.hasUnseen, false, reason: 'but no banner');
    });

    test('a real bug alongside one still interrupts', () async {
      final directory = Directory.systemTemp.createTempSync('mixed');
      addTearDown(() => directory.deleteSync(recursive: true));
      await CrashReports.init(directory);

      CrashReports.record(
        source: 'FlutterError',
        error: 'Bad state: Failed to load https://example.test/...',
      );
      CrashReports.record(source: 'FlutterError', error: 'Null check operator');

      expect(CrashReports.hasUnseen, true);
    });
  });

  group('an extension failure', () {
    test('is told apart from an app bug', () {
      // #914, filed here because the screen offered a button pointing at this
      // repository.
      expect(
        isExtensionFailure(
          "Runtime Error: Undefined property or method 'toList' on bi<qOb, dynamic>.",
        ),
        true,
      );
      expect(
        isExtensionFailure(
          "Native error during bridged method call 'forEach' on List",
        ),
        true,
      );
    });

    test('a Mihon extension failing is one too', () {
      // #935: the source answered 500 and the extension's deserialisation
      // reported a missing field, named by its JVM package.
      expect(
        isExtensionFailure(
          "Field 'largeImage' is required for type with serial name "
          "'eu.kanade.tachiyomi.extension.en.atsumaru.MangaDto', but it was "
          "missing at path: \$.mangaPage",
        ),
        true,
      );
    });

    test('and an LNReader plugin returning nothing usable', () {
      // #936, in both the old wording and the clearer one that replaced it.
      expect(isExtensionFailure('path is null'), true);
      expect(
        isExtensionFailure(
          'Exception: The source returned a novel with no path, so it cannot '
          'be opened. This is the extension rather than Mangayomi.',
        ),
        true,
      );
    });

    test('an app bug is not one', () {
      expect(
        isExtensionFailure('Null check operator used on a null value'),
        false,
      );
      expect(
        isExtensionFailure('PanicException(Expect rustls-platform-verifier)'),
        false,
      );
      expect(
        isExtensionFailure('Bad state: Failed to load https://a.test/...'),
        false,
      );
    });
  });

  group('reporting the same fault twice', () {
    late Directory directory;

    setUp(() async {
      CrashReports.resetForTest();
      directory = Directory.systemTemp.createTempSync('reported');
      await CrashReports.init(directory);
    });

    tearDown(() {
      CrashReports.resetForTest();
      if (directory.existsSync()) directory.deleteSync(recursive: true);
    });

    test('is refused once it has been sent', () {
      CrashReports.record(source: 'test', error: 'PanicException(boom)');
      final report = CrashReports.latest!;

      expect(CrashReports.wasReported(report), false);
      CrashReports.markReported(report);
      expect(CrashReports.wasReported(report), true);
    });

    test('matches the same fault across runs, ids and all', () {
      // #917 and #918 are one crash filed twice. The numbers in a message
      // change between runs; the fault does not.
      expect(
        fingerprintOf('Failed at offset 4821 in isolate 3'),
        fingerprintOf('Failed at offset 9902 in isolate 7'),
      );
      expect(
        fingerprintOf('Null check operator used on a null value'),
        isNot(fingerprintOf('Bad state: no element')),
      );
    });

    test('survives a restart, or the reader is asked again', () async {
      CrashReports.record(source: 'test', error: 'PanicException(boom)');
      CrashReports.markReported(CrashReports.latest!);

      CrashReports.resetForTest();
      await CrashReports.init(directory);

      expect(CrashReports.wasReported(CrashReports.latest!), true);
    });

    test('a file written by an older build is still read', () async {
      // That build stored a bare list rather than an object.
      File(p.join(directory.path, 'crash_reports.json')).writeAsStringSync(
        '[{"time":"2026-08-25T10:00:00.000","source":"test","error":"old"}]',
      );
      CrashReports.resetForTest();

      await CrashReports.init(directory);

      expect(CrashReports.reports, hasLength(1));
      expect(CrashReports.latest!.error, 'old');
    });
  });

  group('the issue link', () {
    final report = CrashReport(
      time: DateTime.utc(2026, 8, 22, 21, 35),
      source: 'PlatformDispatcher',
      error: "SocketException: Failed host lookup: 'example.test'",
      stack: '#0 somewhere\n#1 elsewhere',
      screen: '/browse',
    );

    test('opens the repository form with the fields already filled', () {
      final url = buildIssueUrl(report, appVersion: '0.8.8', device: 'Pixel 5');

      expect(url.host, 'github.com');
      expect(url.path, '/kodjodevf/mangayomi/issues/new');
      expect(url.queryParameters['template'], 'report_issue.yml');
      expect(url.queryParameters['mangayomi-version'], '0.8.8');
      expect(url.queryParameters['device'], 'Pixel 5');
      expect(url.queryParameters['title'], contains('SocketException'));
    });

    test('says what happened and what the app thinks caused it', () {
      final url = buildIssueUrl(report, appVersion: '0.8.8', device: 'Pixel 5');

      expect(url.queryParameters['reproduce-steps'], contains('/browse'));
      expect(
        url.queryParameters['actual-behavior'],
        contains('Failed host lookup'),
      );
      expect(url.queryParameters['actual-behavior'], contains('Likely cause'));
      expect(url.queryParameters['other-details'], contains('#0 somewhere'));
    });

    test('is a link, so nothing is sent by building it', () {
      final url = buildIssueUrl(report, appVersion: '0.8.8', device: 'Pixel 5');
      expect(url.scheme, 'https');
      // Everything travels as query parameters on a page the reader lands on
      // and can read before submitting.
      expect(url.queryParameters.keys, contains('actual-behavior'));
    });

    test(
      'a long stack is truncated rather than silently dropped by GitHub',
      () {
        final huge = CrashReport(
          time: DateTime.utc(2026),
          source: 'test',
          error: 'boom',
          stack: List.filled(500, '#0 a very long frame indeed').join('\n'),
        );

        final url = buildIssueUrl(huge, appVersion: '1', device: 'x');

        expect(url.queryParameters['other-details']!.length, lessThan(2600));
        expect(url.queryParameters['other-details'], contains('truncated'));
      },
    );
  });
}
