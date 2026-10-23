import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/secure_screen.dart';

void main() {
  test('secure only when the setting says so', () {
    for (final incognito in [false, true]) {
      expect(
        isScreenSecure(SecureScreenMode.never, incognito: incognito),
        isFalse,
      );
      expect(
        isScreenSecure(SecureScreenMode.always, incognito: incognito),
        isTrue,
      );
    }
    expect(isScreenSecure(SecureScreenMode.incognito, incognito: true), isTrue);
    expect(
      isScreenSecure(SecureScreenMode.incognito, incognito: false),
      isFalse,
    );
  });
}
