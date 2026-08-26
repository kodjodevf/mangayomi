import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/crash_native.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:path/path.dart' as p;

/// A native crash is written by a signal handler in the run that died, and
/// read back by the run after it. These cover the reading half.
void main() {
  late Directory directory;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('native_crash');
    CrashReports.resetForTest();
  });

  tearDown(() {
    CrashReports.resetForTest();
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  File crashFile() => File(p.join(directory.path, 'native_crash.txt'));

  test('a crash the handler left becomes a report', () async {
    crashFile().writeAsStringSync('signal 11 SIGSEGV\n/animePlayer\n');

    await CrashReports.init(directory);
    await NativeCrashHandler.init(directory);

    expect(CrashReports.reports, hasLength(1));
    final report = CrashReports.latest!;
    expect(report.source, 'native');
    expect(report.error, contains('SIGSEGV'));
    expect(report.screen, '/animePlayer');
    // There is no Dart stack for a native crash, and claiming otherwise would
    // send whoever reads it looking for one.
    expect(report.stack, isNull);
    expect(report.error, contains('no Dart stack'));
  });

  test('it is cleared once read, or every launch reports it again', () async {
    crashFile().writeAsStringSync('signal 6 SIGABRT\n');

    await CrashReports.init(directory);
    await NativeCrashHandler.init(directory);
    expect(crashFile().existsSync(), false);

    // The report itself is kept, that is the point of it. What must not
    // happen is the same crash being recorded again on every launch.
    expect(CrashReports.reports, hasLength(1));

    CrashReports.resetForTest();
    await CrashReports.init(directory);
    await NativeCrashHandler.init(directory);
    expect(
      CrashReports.reports.where((r) => r.source == 'native'),
      hasLength(1),
    );
  });

  test('a crash with no screen recorded still reports', () async {
    crashFile().writeAsStringSync('signal 11 SIGSEGV\n');

    await CrashReports.init(directory);
    await NativeCrashHandler.init(directory);

    expect(CrashReports.latest!.screen, isNull);
    expect(CrashReports.latest!.error, contains('SIGSEGV'));
  });

  test('an empty file is not a crash', () async {
    crashFile().writeAsStringSync('   \n');

    await CrashReports.init(directory);
    await NativeCrashHandler.init(directory);

    expect(CrashReports.reports, isEmpty);
  });

  test('no file at all is the normal case and reports nothing', () async {
    await CrashReports.init(directory);
    await NativeCrashHandler.init(directory);

    expect(CrashReports.reports, isEmpty);
  });

  test('a crash during startup still says so', () async {
    // The route observer has not fired yet at that point, so without a default
    // the report would carry no screen at all.
    crashFile().writeAsStringSync('signal 11 SIGSEGV\nstartup\n');

    await CrashReports.init(directory);
    await NativeCrashHandler.init(directory);

    expect(CrashReports.latest!.screen, 'startup');
  });

  test('a missing directory is survivable', () async {
    await CrashReports.init(directory);
    await NativeCrashHandler.init(null);

    expect(CrashReports.reports, isEmpty);
  });
}
