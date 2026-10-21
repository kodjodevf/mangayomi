import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_mode_glyph.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_mode_picker.dart';
import 'package:shiori/shiori.dart';

Widget _host(Widget child) => ProviderScope(
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    theme: buildShioriTheme(
      brightness: Brightness.dark,
      colors: FlexColor.schemesList[2].dark,
      tintSurfaces: false,
      blendLevel: 10,
      density: ShioriDensity.phone,
    ),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

void main() {
  testWidgets('one tile per mode; a tap picks it', (tester) async {
    ReaderMode? picked;
    await tester.pumpWidget(
      _host(
        ReaderModePicker(
          mode: ReaderMode.rtl,
          defaultMode: ReaderMode.rtl,
          seriesName: 'Pluto',
          onChanged: (m) => picked = m,
          onSetDefault: () {},
        ),
      ),
    );
    expect(find.text('Reading mode for Pluto'), findsOneWidget);
    expect(find.byType(InkWell), findsNWidgets(ReaderMode.values.length));
    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is ReaderModeGlyph && w.mode == ReaderMode.webtoon,
      ),
    );
    expect(picked, ReaderMode.webtoon);
  });

  testWidgets('says when the series follows the default', (tester) async {
    await tester.pumpWidget(
      _host(
        ReaderModePicker(
          mode: ReaderMode.ltr,
          defaultMode: ReaderMode.ltr,
          seriesName: 'Pluto',
          onChanged: (_) {},
          onSetDefault: () {},
        ),
      ),
    );
    expect(find.text('This is your default reading mode'), findsOneWidget);
    expect(find.text('Set as default'), findsNothing);
  });

  testWidgets('offers the default back, or this mode as the default', (
    tester,
  ) async {
    ReaderMode? picked;
    var setDefault = false;
    await tester.pumpWidget(
      _host(
        ReaderModePicker(
          mode: ReaderMode.webtoon,
          defaultMode: ReaderMode.ltr,
          seriesName: 'Pluto',
          onChanged: (m) => picked = m,
          onSetDefault: () => setDefault = true,
        ),
      ),
    );
    await tester.tap(find.text('Use the default'));
    expect(picked, ReaderMode.ltr);
    await tester.tap(find.text('Set as default'));
    expect(setDefault, isTrue);
  });

  testWidgets('in a sheet, as tall as its tiles', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showShioriSheet<void>(
              context,
              builder: (_) => ReaderModePicker(
                mode: ReaderMode.rtl,
                defaultMode: ReaderMode.rtl,
                seriesName: 'Pluto',
                onChanged: (_) {},
                onSetDefault: () {},
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // It stretched to nine tenths of the screen.
    expect(
      tester.getSize(find.byType(ReaderModePicker)).height,
      lessThan(900 * 0.6),
    );
  });
}
