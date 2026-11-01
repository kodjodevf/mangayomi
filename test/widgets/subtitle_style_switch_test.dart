import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/anime/widgets/player_settings_sections.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_setting_widget.dart';
import 'package:shiori/shiori.dart';

void main() {
  late Directory directory;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
  });

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('subtitle_style_switch');
    isar = await Isar.open(
      [SettingsSchema, SourceSchema],
      directory: directory.path,
      name: 'subtitle_style_switch_${directory.path.hashCode}',
    );
    isar.writeTxnSync(() => isar.settings.putSync(Settings()));
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  Future<void> pump(WidgetTester tester, {required bool useLibass}) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildShioriTheme(
            brightness: Brightness.dark,
            colors: FlexColor.schemesList[2].dark,
            tintSurfaces: false,
            blendLevel: 10,
            density: ShioriDensity.phone,
          ),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: AppearanceSectionWidget(
                useLibass: useLibass,
                hasSubtitleTrack: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool styleLocked(WidgetTester tester) => tester
      .widget<IgnorePointer>(
        find
            .ancestor(
              of: find.byType(SubtitleAppearanceWidget),
              matching: find.byType(IgnorePointer),
            )
            .first,
      )
      .ignoring;

  testWidgets('the style can only be changed while it is in use', (
    tester,
  ) async {
    await pump(tester, useLibass: true);
    expect(find.text('Use my subtitle style'), findsOneWidget);
    expect(styleLocked(tester), isTrue);

    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    expect(styleLocked(tester), isFalse);

    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    expect(styleLocked(tester), isTrue);

    // Lets the settings write queued by the switch finish.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
  });

  testWidgets('without libass there is no switch and the style stays open', (
    tester,
  ) async {
    await pump(tester, useLibass: false);
    expect(find.text('Use my subtitle style'), findsNothing);
    expect(styleLocked(tester), isFalse);
  });
}
