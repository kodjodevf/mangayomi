import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/volume_keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.kodjodevf.mangayomi.volume_keys');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  test('takes the buttons, passes each press, and gives them back', () async {
    VolumeKeys.debugSupported = true;
    addTearDown(() => VolumeKeys.debugSupported = null);
    final calls = <String>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

    final presses = <bool>[];
    await VolumeKeys.enable(presses.add);
    await messenger.handlePlatformMessage(
      channel.name,
      channel.codec.encodeMethodCall(const MethodCall('press', 'up')),
      (_) {},
    );
    await VolumeKeys.disable();
    expect(calls, ['enable', 'disable']);
    expect(presses, [true]);
  });

  test('off a phone, nothing is asked of the platform', () async {
    VolumeKeys.debugSupported = false;
    addTearDown(() => VolumeKeys.debugSupported = null);
    var asked = false;
    messenger.setMockMethodCallHandler(channel, (call) async {
      asked = true;
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    await VolumeKeys.enable((_) {});
    await VolumeKeys.disable();
    expect(asked, isFalse);
  });
}
