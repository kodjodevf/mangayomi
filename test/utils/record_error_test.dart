import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/utils/error_toast.dart';

void main() {
  group('recordError', () {
    setUp(CrashReports.resetForTest);
    tearDown(CrashReports.resetForTest);

    test('keeps a handled error in CrashReports under its source', () {
      recordError(
        Exception('safety backup failed'),
        stack: StackTrace.current,
        source: 'safety_backup',
      );

      expect(CrashReports.latest?.source, 'safety_backup');
      expect(CrashReports.latest?.error, contains('safety backup failed'));
      expect(CrashReports.latest?.stack, isNotNull);
    });

    test('works without a stack trace', () {
      recordError(StateError('no stack'), source: 'restore_decode');

      expect(CrashReports.latest?.source, 'restore_decode');
      expect(CrashReports.latest?.stack, isNull);
    });

    test('prints the error unredacted in a debug build', () {
      final printed = <String?>[];
      final previous = debugPrint;
      debugPrint = (message, {wrapWidth}) => printed.add(message);
      addTearDown(() => debugPrint = previous);

      recordError(
        Exception('401 for https://api.example.com/me?token=abc123'),
        source: 'tracker',
      );

      expect(printed.single, contains('token=abc123'));
      expect(CrashReports.latest?.error, isNot(contains('abc123')));
    });
  });
}
