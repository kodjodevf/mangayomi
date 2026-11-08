import 'dart:io';
import 'dart:ui' as ui;

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/anime/utils/video_filters.dart';
import 'package:mangayomi/modules/anime/widgets/video_filters_section.dart';
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
    directory = Directory.systemTemp.createTempSync('video_filters_section');
    isar = await Isar.open(
      [SettingsSchema, SourceSchema],
      directory: directory.path,
      name: 'video_filters_section_${directory.path.hashCode}',
    );
    isar.writeTxnSync(() => isar.settings.putSync(Settings()));
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  Widget host(Widget child) => ProviderScope(
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
      home: Scaffold(body: child),
    ),
  );

  testWidgets('an adjustment the output cannot show is not offered', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        VideoFiltersSection(
          available: availableVideoFilters(softwareOutput: true),
          onApply: (_, _) {},
        ),
      ),
    );
    expect(find.byType(Slider), findsNWidgets(4));
    expect(find.text('Gamma'), findsNothing);
  });

  testWidgets('every adjustment is offered otherwise', (tester) async {
    await tester.pumpWidget(
      host(
        VideoFiltersSection(
          available: availableVideoFilters(softwareOutput: false),
          onApply: (_, _) {},
        ),
      ),
    );
    expect(find.byType(Slider), findsNWidgets(VideoFilter.values.length));
  });

  testWidgets('the layer adjusts what is beneath it, not what is above', (
    tester,
  ) async {
    isar.writeTxnSync(() {
      isar.settings.putSync(
        isar.settings.getSync(227)!..playerVideoFilters = [50, 0, 0, 0, 0],
      );
    });
    const beneath = Color(0xFF404040);
    const above = Color(0xFF00FF00);
    final boundary = GlobalKey();
    await tester.pumpWidget(
      host(
        RepaintBoundary(
          key: boundary,
          child: const Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: beneath),
              SoftwareVideoFilterLayer(),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: ColoredBox(color: above),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final pixels = await tester.runAsync(() async {
      final render =
          boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await render.toImage();
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      int at(int x, int y) => data!.getUint32((y * image.width + x) * 4);
      return (at(50, 50), at(400, 400));
    });

    expect(pixels!.$1, 0x00FF00FF, reason: 'above the layer: unchanged');
    // 0x40 + 50% of 255 = 0xBF or so, in each channel.
    final red = pixels.$2 >> 24;
    expect(red, closeTo(0xBF, 2), reason: 'beneath the layer: brightened');
  });
}
