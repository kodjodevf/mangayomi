import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/about/providers/download_file_screen.dart';
import 'package:mangayomi/modules/more/about/providers/release_notes.dart';
import 'package:shiori/shiori.dart';

const _apk = UpdateAsset(
  'https://example.org/Mangayomi-v0.7.0-android-arm64-v8a.apk',
  size: 55066029,
);

void main() {
  Future<void> pump(
    WidgetTester tester,
    String notes, {
    String version = '0.7.0',
    List<String>? androidAbis,
    List<UpdateAsset> assets = const [],
    Locale locale = const Locale('en'),
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: DownloadFileScreen(
              currentVersion: '0.6.0',
              androidAbis: androidAbis,
              updateAvailable: UpdateInfo(
                version: version,
                notes: notes,
                pageUrl: 'https://example.org',
                assets: assets,
                publishedAt: DateTime(2026, 10, 12),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  AppLocalizations l10n(WidgetTester tester) =>
      AppLocalizations.of(tester.element(find.byType(DownloadFileScreen)))!;

  testWidgets('names the version installed and the new one', (tester) async {
    await pump(tester, '- Faster library\n\n**Full Changelog**: v0.6...v0.7');

    expect(find.byType(ShioriDialog), findsOneWidget);
    expect(find.text(l10n(tester).update_installed_version), findsOneWidget);
    expect(find.text('v0.6.0'), findsOneWidget);
    expect(find.text(l10n(tester).update_new_version), findsOneWidget);
    expect(find.text('v0.7.0'), findsOneWidget);
    expect(find.textContaining('Oct 12, 2026'), findsOneWidget);
    expect(find.text('Faster library', findRichText: true), findsOneWidget);
    // The link to the full changelog is dropped from the notes.
    expect(find.textContaining('Full Changelog'), findsNothing);
  });

  testWidgets('marks a pre-release', (tester) async {
    await pump(tester, '', version: '1.0.0-beta.1');
    expect(find.text(l10n(tester).update_pre_release), findsOneWidget);
  });

  testWidgets('a final version is not marked as a pre-release', (tester) async {
    await pump(tester, '');
    expect(find.text(l10n(tester).update_pre_release), findsNothing);
  });

  testWidgets('says so when a release has no notes', (tester) async {
    await pump(tester, '');
    expect(find.text(l10n(tester).update_no_notes), findsOneWidget);
  });

  testWidgets('says the browser opens when it cannot install', (tester) async {
    await pump(tester, '');
    expect(find.text(l10n(tester).update_hint_browser), findsOneWidget);
    expect(find.text(l10n(tester).open_in_browser), findsOneWidget);
    expect(find.text(l10n(tester).update_later), findsOneWidget);
  });

  testWidgets('says what an install costs and how it goes', (tester) async {
    await pump(tester, '', androidAbis: ['arm64-v8a'], assets: [_apk]);
    expect(find.text(l10n(tester).update_hint_install), findsOneWidget);
    expect(find.text(l10n(tester).download), findsOneWidget);
    expect(find.textContaining('· 53 MB'), findsOneWidget);
  });

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('opens in $locale', (tester) async {
      await pump(tester, '* fix: a thing', locale: locale);
      expect(find.byType(ShioriDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final (name, size) in [
    ('a phone', const Size(360, 640)),
    ('a phone on its side', const Size(640, 360)),
  ]) {
    testWidgets('fits $name', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pump(tester, List.filled(40, '- A change').join('\n'));
      expect(tester.takeException(), isNull);
    });
  }

  group('picks the APK', () {
    const tvApk = UpdateAsset('https://x/M-android-tv-arm64-v8a.apk');
    const armApk = UpdateAsset('https://x/M-android-armeabi-v7a.apk');
    const ipa = UpdateAsset('https://x/M-ios.ipa');

    test('for the first ABI the device supports', () {
      final apk = pickApk(
        [ipa, tvApk, armApk, _apk],
        ['arm64-v8a', 'armeabi-v7a'],
        tv: false,
      );
      expect(apk, _apk);
    });

    test('for a TV', () {
      expect(pickApk([_apk, tvApk], ['arm64-v8a'], tv: true), tvApk);
    });

    test('there is none in a release without any', () {
      expect(pickApk([ipa], ['arm64-v8a'], tv: false), isNull);
    });
  });

  group('release notes', () {
    test('generated from pull requests are sorted for the reader', () {
      final sections = parseReleaseNotes('''
## What's Changed
* fix(reader): restore double-tap zoom by @a in https://github.com/x/y/pull/1
* feat(ui): add a speed selector by @b in https://github.com/x/y/pull/2
* chore: await dropped writes by @a in https://github.com/x/y/pull/3
* ci: run the tests by @a in https://github.com/x/y/pull/4
* Add a protected proxy by @c in https://github.com/x/y/pull/5
* Bump http by @bot in https://github.com/x/y/pull/6

## New Contributors
* @c made their first contribution in https://github.com/x/y/pull/5

**Full Changelog**: https://github.com/x/y/compare/a...b
''');

      expect(sections.map((section) => section.group), [
        ReleaseNotesGroup.features,
        ReleaseNotesGroup.fixes,
        ReleaseNotesGroup.other,
      ]);
      expect(sections.map((section) => section.notes.single.text), [
        '**UI**: Add a speed selector',
        '**Reader**: Restore double-tap zoom',
        'Add a protected proxy',
      ]);
    });

    test('written by hand keep their headings and order', () {
      final sections = parseReleaseNotes('''
## What's Changed

## Reader
* **Double page** (#1008):
  * Switches by [orientation](https://x.y).
Thanks to all.

## Player
- Faster `start`
''');

      expect(sections.map((section) => section.title), ['Reader', 'Player']);
      expect(sections.first.notes.map((note) => note.text), [
        '**Double page**:',
        'Switches by orientation.',
        'Thanks to all.',
      ]);
      expect(sections.first.notes[1].indent, 1);
      expect(sections.first.notes[2].isBullet, isFalse);
      expect(sections.last.notes.single.text, 'Faster start');
    });

    test('with only commits of no interest are empty', () {
      expect(parseReleaseNotes('* chore: tidy\n* ci: build'), isEmpty);
    });
  });
}
