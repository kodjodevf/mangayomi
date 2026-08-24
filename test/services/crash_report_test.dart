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
        expect(jsonDecode(file().readAsStringSync()), hasLength(10));
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
