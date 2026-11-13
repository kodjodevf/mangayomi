import 'dart:convert';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/browse/discover/discover_screen.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';
import 'package:shiori/shiori.dart';

class Hidden extends HideItemsState {
  Hidden(this.value);
  final List<String> value;
  @override
  List<String> build() => value;
}

class Adult extends ShowNSFWState {
  @override
  bool build() => false;
}

class Tv extends AnimeOnlyTvMode {
  Tv(this.value);
  final bool value;
  @override
  bool build() => value;
}

void main() {
  for (final (label, hidden, animeOnly, expected) in [
    (
      'all types',
      <String>[],
      false,
      [ItemType.manga, ItemType.anime, ItemType.novel],
    ),
    (
      'anime hidden',
      ['/AnimeLibrary'],
      false,
      [ItemType.manga, ItemType.novel],
    ),
    ('anime only TV', <String>[], true, [ItemType.anime]),
    ('anime only TV and anime hidden', ['/AnimeLibrary'], true, <ItemType>[]),
  ]) {
    testWidgets('route respects $label without accessing a database', (
      tester,
    ) async {
      final queries = <String>[];
      await http.runWithClient(
        () async {
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                hideItemsStateProvider.overrideWith(() => Hidden(hidden)),
                showNSFWStateProvider.overrideWith(Adult.new),
                animeOnlyTvModeProvider.overrideWith(() => Tv(animeOnly)),
              ],
              child: MaterialApp(
                theme: buildShioriTheme(
                  brightness: Brightness.dark,
                  colors: FlexColor.schemesList[2].dark,
                  tintSurfaces: false,
                  blendLevel: 10,
                  density: ShioriDensity.phone,
                ),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: const DiscoverRoute(initialType: ItemType.anime),
              ),
            ),
          );
          await tester.pumpAndSettle();
        },
        () => MockClient((request) async {
          queries.add(jsonDecode(request.body)['query']);
          return http.Response('{"data":{"Page":{"media":[]}}}', 200);
        }),
      );
      final screen = tester.widget<DiscoverScreen>(find.byType(DiscoverScreen));
      expect(screen.availableTypes, expected);
      expect(screen.includeAdult, isFalse);
      expect(find.text('Comics'), findsNothing);
      expect(queries.length, expected.isEmpty ? 0 : 2);
      if (queries.isNotEmpty) {
        expect(
          queries.every(
            (query) => query.contains(
              expected.contains(ItemType.anime) ? 'type: ANIME' : 'type: MANGA',
            ),
          ),
          isTrue,
        );
      }
      expect(tester.takeException(), isNull);
    });
  }
}
