// The point of this test: widgets of the old built-in Material library.
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart' as legacy;
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/l10n_delegates.dart';
import 'package:mangayomi/utils/legacy_material.dart';
import 'package:material_ui/material_ui.dart';

/// Packages such as bot_toast, table_calendar and media_kit_video still build
/// on the old Material library, whose theme, strings and Material are not the
/// ones material_ui provides.
void main() {
  testWidgets('a widget of the old Material library works under the app', (
    tester,
  ) async {
    legacy.ThemeData? theme;
    legacy.MaterialLocalizations? strings;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.dark,
          ),
        ),
        localizationsDelegates: appLocalizationsDelegates,
        locale: const Locale('fr'),
        supportedLocales: const [Locale('en'), Locale('fr')],
        builder: (context, child) => LegacyMaterialBridge(child: child!),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              theme = legacy.Theme.of(context);
              strings = legacy.MaterialLocalizations.of(context);
              // Needs a Material of its own library above it.
              return legacy.IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_left),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(theme!.colorScheme.brightness, Brightness.dark);
    expect(strings!.okButtonLabel, 'OK');
    expect(strings!.cancelButtonLabel, 'Annuler');
  });
}
