import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/sync_server.dart';

void main() {
  test('Windows and Linux catch the login on a loopback server', () {
    final callback = syncOAuthCallback(loopback: true);
    expect(callback.redirectUri, 'http://localhost:48765/callback');
    expect(callback.callbackUrlScheme, 'http://localhost:48765');
  });

  test('macOS and mobile come back on the app scheme (#1062)', () {
    final callback = syncOAuthCallback(loopback: false);
    expect(callback.redirectUri, 'mangayomi://oauth-callback');
    // A plain scheme, as flutter_web_auth_2 requires there: no "://".
    expect(callback.callbackUrlScheme, 'mangayomi');
    expect(Uri.parse(callback.redirectUri).scheme, callback.callbackUrlScheme);
  });
}
