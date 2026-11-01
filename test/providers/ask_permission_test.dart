import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const _channel = MethodChannel('flutter.baseflow.com/permissions/methods');

/// Answers the permission plugin: [status] for a check, [onRequest] for a
/// request.
void _answer({
  required int status,
  required Object? Function() onRequest,
}) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_channel, (call) async {
        return switch (call.method) {
          'checkPermissionStatus' => status,
          'requestPermissions' => onRequest(),
          _ => null,
        };
      });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final permission = Permission.manageExternalStorage;
  const denied = 0, granted = 1;

  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null),
  );

  test('already granted: not asked again', () async {
    var asked = false;
    _answer(status: granted, onRequest: () => asked = true);
    expect(await askPermission(permission), isTrue);
    expect(asked, isFalse);
  });

  test('asked and granted', () async {
    _answer(status: denied, onRequest: () => {permission.value: granted});
    expect(await askPermission(permission), isTrue);
  });

  test('a device without the screen that grants it answers no rather than '
      'crashing (#1069)', () async {
    _answer(
      status: denied,
      onRequest: () => throw PlatformException(
        code: 'error',
        message:
            'No Activity found to handle Intent { '
            'act=android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION }',
      ),
    );
    expect(await askPermission(permission), isFalse);
  });
}
