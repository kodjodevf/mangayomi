import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/settings.dart';

void main() {
  test('floating navigation is opt-in and survives settings JSON', () {
    final defaults = Settings();
    expect(defaults.useFloatingNavigationBar, isFalse);
    expect(defaults.toJson()['useFloatingNavigationBar'], isFalse);

    final restored = Settings.fromJson({
      ...defaults.toJson(),
      'useFloatingNavigationBar': true,
    });
    expect(restored.useFloatingNavigationBar, isTrue);
  });

  test('an older settings backup without the preference keeps it disabled', () {
    final json = Settings().toJson()..remove('useFloatingNavigationBar');
    expect(Settings.fromJson(json).useFloatingNavigationBar, isFalse);
  });
}
