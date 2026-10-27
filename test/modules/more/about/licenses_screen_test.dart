import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/about/licenses_screen.dart';
import 'package:shiori/shiori.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(
      ['licenses_screen_test_package'],
      'Permission is hereby granted, free of charge',
    );
  });

  testWidgets('lists the registered packages and shows their licence', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LicensesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ShioriSettingRow), findsWidgets);
    final row = find.text('licenses_screen_test_package');
    expect(row, findsOneWidget);

    await tester.tap(row);
    await tester.pumpAndSettle();

    expect(find.textContaining('Permission is hereby granted'), findsOneWidget);
  });
}
