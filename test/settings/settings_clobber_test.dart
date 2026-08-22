import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/utils/settings_write.dart';

/// The appearance settings all live in one Settings row, and each setter reads
/// the whole row, changes its own field and writes the row back. They also call
/// into each other, so what the last write holds is what survives.
void main() {
  late Directory directory;
  late ProviderContainer container;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('settings_clobber');
    isar = await Isar.open(
      [SettingsSchema, SourceSchema],
      directory: directory.path,
      name: 'clobber_${directory.path.hashCode}',
    );
    isar.writeTxnSync(
      () => isar.settings.putSync(
        Settings()
          ..themeIsDark = true
          ..followSystemTheme = false
          ..flexSchemeColorIndex = 3,
      ),
    );
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  Settings stored() => isar.settings.getSync(227)!;

  test('following the system theme survives the write that turns it on', () async {
    // The system is light and the app is dark, so turning this on has to leave
    // the app light. It does in memory; the question is what reached the row.
    final binding = TestWidgetsFlutterBinding.instance;
    binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(binding.platformDispatcher.clearPlatformBrightnessTestValue);

    container.read(followSystemThemeStateProvider.notifier).set(true);

    expect(container.read(themeModeStateProvider), false, reason: 'in memory');
    expect(stored().followSystemTheme, true);
    expect(
      stored().themeIsDark,
      false,
      reason:
          'set() captured the row before setLightTheme wrote to it, so the '
          'stale copy it wrote last puts the app back to dark on next launch',
    );
  });

  group('updateSettings', () {
    test('keeps a change made after the caller last looked at the row', () {
      // What every caller of this used to get wrong: hold the row, let
      // something else write, then write the held copy back over it.
      final stale = isar.settings.getSync(227)!;
      isar.writeTxnSync(
        () => isar.settings.putSync(
          isar.settings.getSync(227)!..themeIsDark = false,
        ),
      );

      updateSettings((settings) => settings.followSystemTheme = true);

      expect(stale.themeIsDark, true, reason: 'the held copy is stale');
      expect(stored().themeIsDark, false, reason: 'the row is not');
      expect(stored().followSystemTheme, true);
    });

    test('stamps updatedAt so a sync sees the change', () {
      final before = stored().updatedAt ?? 0;

      updateSettings((settings) => settings.flexSchemeColorIndex = 9);

      expect(stored().flexSchemeColorIndex, 9);
      expect(stored().updatedAt, greaterThanOrEqualTo(before));
    });
  });

  test(
    'picking a colour scheme does not undo the theme it was picked under',
    () {
      container.read(themeModeStateProvider.notifier).setLightTheme();
      container
          .read(flexSchemeColorStateProvider.notifier)
          .setTheme(ThemeAA.schemes[7].light, 7);

      expect(stored().flexSchemeColorIndex, 7);
      expect(stored().themeIsDark, false);
    },
  );
}
