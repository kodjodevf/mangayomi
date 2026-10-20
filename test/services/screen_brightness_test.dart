import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/screen_brightness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.kodjodevf.mangayomi.screen_brightness');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  test('sets the brightness, kept above black, and gives it back', () async {
    ScreenBrightness.debugSupported = true;
    addTearDown(() => ScreenBrightness.debugSupported = null);
    final calls = <(String, Object?)>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add((call.method, call.arguments));
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

    await ScreenBrightness.set(0.4);
    await ScreenBrightness.set(0);
    await ScreenBrightness.reset();
    expect(calls, [('set', 0.4), ('set', 0.01), ('reset', null)]);
  });

  test('reads the brightness now, or nothing on an older build', () async {
    ScreenBrightness.debugSupported = true;
    addTearDown(() => ScreenBrightness.debugSupported = null);
    messenger.setMockMethodCallHandler(channel, (call) async {
      return call.method == 'get' ? 0.7 : null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    expect(await ScreenBrightness.current(), 0.7);

    messenger.setMockMethodCallHandler(channel, null);
    expect(await ScreenBrightness.current(), isNull);
  });

  test('off a phone, nothing is asked of the platform', () async {
    ScreenBrightness.debugSupported = false;
    addTearDown(() => ScreenBrightness.debugSupported = null);
    var asked = false;
    messenger.setMockMethodCallHandler(channel, (call) async {
      asked = true;
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    await ScreenBrightness.set(0.5);
    expect(await ScreenBrightness.current(), isNull);
    expect(asked, isFalse);
  });
}
