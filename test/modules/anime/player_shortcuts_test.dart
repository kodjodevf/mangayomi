import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/anime/utils/player_shortcuts.dart';
import 'package:shiori/shiori.dart';

void main() {
  test('the Anime4K keys are listed only with the mpv config on', () {
    bool listsShaders(bool shaders) =>
        playerShortcutKeys(shaders: shaders)
            .any((entry) => entry.$1 == PlayerShortcut.shaders);
    expect(listsShaders(false), isFalse);
    expect(listsShaders(true), isTrue);
  });

  test('each shortcut is listed once, the list of them last', () {
    final shortcuts = [
      for (final (shortcut, _) in playerShortcutKeys(shaders: true)) shortcut,
    ];
    expect(shortcuts.toSet().length, shortcuts.length);
    expect(shortcuts.last, PlayerShortcut.showShortcuts);
    expect(shortcuts.toSet(), PlayerShortcut.values.toSet());
  });

  testWidgets('the list names the seconds each key seeks', (tester) async {
    late BuildContext host;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildShioriTheme(
          brightness: Brightness.dark,
          colors: FlexColor.schemesList[2].dark,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            host = context;
            return const SizedBox.expand();
          },
        ),
      ),
    );
    final l10n = AppLocalizations.of(host)!;

    showPlayerShortcuts(host, skipIntroSeconds: 85);
    await tester.pumpAndSettle();
    expect(find.text(l10n.keyboard_shortcuts), findsOneWidget);
    expect(
      find.text(l10n.shortcut_seek_forward(playerShortSeekSeconds)),
      findsOneWidget,
    );
    expect(
      find.text(l10n.shortcut_seek_back(playerLongSeekSeconds)),
      findsOneWidget,
    );
    expect(find.text(l10n.shortcut_skip_intro(85)), findsOneWidget);
    expect(find.text(l10n.shortcut_shaders), findsNothing);
  });
}
