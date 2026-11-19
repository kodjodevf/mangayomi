import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/utils/window_geometry.dart';

/// The window as the `window_manager` plugin reports it, and what was asked
/// of it.
class _FakeWindow {
  Rect bounds = const Rect.fromLTWH(40, 60, 1000, 700);
  bool fullScreen = false;
  bool maximized = false;
  bool minimized = false;
  final calls = <MethodCall>[];

  Future<Object?> handle(MethodCall call) async {
    calls.add(call);
    switch (call.method) {
      case 'isFullScreen':
        return fullScreen;
      case 'isMaximized':
        return maximized;
      case 'isMinimized':
        return minimized;
      case 'getBounds':
        return {
          'x': bounds.left,
          'y': bounds.top,
          'width': bounds.width,
          'height': bounds.height,
        };
      case 'setBounds':
      case 'maximize':
        return true;
    }
    throw MissingPluginException(call.method);
  }

  List<String> get changes => [
    for (final call in calls)
      if (call.method == 'setBounds' || call.method == 'maximize')
        call.method == 'setBounds'
            ? 'setBounds ${(call.arguments as Map)..remove('devicePixelRatio')}'
            : 'maximize',
  ];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('window_manager');
  late Directory directory;
  late File file;
  late _FakeWindow window;

  setUp(() {
    CrashReports.resetForTest();
    directory = Directory.systemTemp.createTempSync('window_geometry_test');
    file = File('${directory.path}/window_geometry.json');
    WindowGeometryStore.file = () async => file;
    WindowGeometryStore.screens = () => const [Size(1920, 1080)];
    window = _FakeWindow();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, window.handle);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    directory.deleteSync(recursive: true);
    CrashReports.resetForTest();
  });

  Map<String, Object?> saved() =>
      jsonDecode(file.readAsStringSync()) as Map<String, Object?>;

  group('WindowGeometry', () {
    test('reads what it writes', () {
      const geometry = WindowGeometry(
        size: Size(1000, 700),
        position: Offset(40, 60),
        isMaximized: true,
      );
      expect(WindowGeometry.fromJson(geometry.toJson()), geometry);
    });

    test('has no use for a missing or tiny size', () {
      expect(WindowGeometry.fromJson(null), isNull);
      expect(WindowGeometry.fromJson({'width': 800}), isNull);
      expect(WindowGeometry.fromJson({'width': 50, 'height': 700}), isNull);
      expect(WindowGeometry.fromJson({'width': '800', 'height': 700}), isNull);
    });

    test('keeps a size without a position', () {
      final geometry = WindowGeometry.fromJson({'width': 800, 'height': 600});
      expect(geometry?.size, const Size(800, 600));
      expect(geometry?.position, isNull);
    });

    test('tells a fullscreen size from a window one', () {
      const screens = [Size(1920, 1080), Size(1280, 1024)];
      bool covers(double w, double h) =>
          WindowGeometry(size: Size(w, h)).coversAScreen(screens);

      expect(covers(1920, 1080), isTrue);
      expect(covers(1280, 1024), isTrue);
      expect(covers(964, 1048), isFalse);
      expect(covers(1920, 1000), isFalse);
      expect(
        const WindowGeometry(size: Size(1920, 1080)).coversAScreen(const []),
        isFalse,
      );
    });
  });

  group('WindowGeometryStore.save', () {
    test('keeps the window size and place', () async {
      await WindowGeometryStore.save();

      expect(saved(), {
        'width': 1000.0,
        'height': 700.0,
        'x': 40.0,
        'y': 60.0,
        'isMaximized': false,
      });
      expect(File('${file.path}.tmp').existsSync(), isFalse);
    });

    test('leaves what was saved when the window is fullscreen', () async {
      await WindowGeometryStore.save();
      window
        ..fullScreen = true
        ..bounds = const Rect.fromLTWH(0, 0, 1920, 1080);

      await WindowGeometryStore.save();

      expect(saved()['width'], 1000.0);
      expect(saved()['x'], 40.0);
    });

    test('saves nothing for a minimized window', () async {
      window.minimized = true;
      await WindowGeometryStore.save();
      expect(file.existsSync(), isFalse);
    });

    test('keeps the size from before a window is maximized', () async {
      await WindowGeometryStore.save();
      window
        ..maximized = true
        ..bounds = const Rect.fromLTWH(0, 32, 1920, 1048);

      await WindowGeometryStore.save();

      expect(saved(), {
        'width': 1000.0,
        'height': 700.0,
        'x': 40.0,
        'y': 60.0,
        'isMaximized': true,
      });
    });

    test('waits for the window to settle', () async {
      WindowGeometryStore.scheduleSave();
      WindowGeometryStore.scheduleSave();
      expect(file.existsSync(), isFalse);

      await Future<void>.delayed(
        WindowGeometryStore.settleDelay + const Duration(milliseconds: 100),
      );

      expect(saved()['width'], 1000.0);
      expect(
        window.calls.where((call) => call.method == 'getBounds'),
        hasLength(1),
      );
    });

    test('records a failure instead of losing it', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            throw PlatformException(code: 'gone');
          });

      await WindowGeometryStore.save();

      expect(CrashReports.latest?.source, 'window_geometry');
    });
  });

  group('WindowGeometryStore.restore', () {
    test('gives the window its saved size and place', () async {
      file.writeAsStringSync(
        jsonEncode({'width': 1000, 'height': 700, 'x': 40, 'y': 60}),
      );

      await WindowGeometryStore.restore();

      expect(window.changes, [
        'setBounds {width: 1000.0, height: 700.0, animate: false}',
        'setBounds {x: 40.0, y: 60.0, animate: false}',
      ]);
    });

    test('ignores a fullscreen size an older version saved', () async {
      file.writeAsStringSync(
        jsonEncode({'width': 1920, 'height': 1080, 'x': 0, 'y': 0}),
      );

      await WindowGeometryStore.restore();

      expect(window.changes, isEmpty);
    });

    test(
      'maximizes without sizing when only the maximized size is known',
      () async {
        file.writeAsStringSync(
          jsonEncode({
            'width': 1920,
            'height': 1080,
            'x': 0,
            'y': 0,
            'isMaximized': true,
          }),
        );

        await WindowGeometryStore.restore();

        expect(window.changes, ['maximize']);
      },
    );

    test('maximizes after sizing a maximized window', () async {
      file.writeAsStringSync(
        jsonEncode({'width': 1000, 'height': 700, 'isMaximized': true}),
      );

      await WindowGeometryStore.restore();

      expect(window.changes, [
        'setBounds {width: 1000.0, height: 700.0, animate: false}',
        'maximize',
      ]);
    });

    test('does nothing when nothing was saved', () async {
      await WindowGeometryStore.restore();
      expect(window.calls, isEmpty);
    });

    test(
      'opens at the default size from a damaged file, and says so',
      () async {
        file.writeAsStringSync('{"width": 10');

        await WindowGeometryStore.restore();

        expect(window.calls, isEmpty);
        expect(CrashReports.latest?.source, 'window_geometry');
      },
    );
  });
}
