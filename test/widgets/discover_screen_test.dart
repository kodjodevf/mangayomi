import 'dart:async';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/browse/discover/discover_screen.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:shiori/shiori.dart';

Future<void> openDiscovery(
  WidgetTester tester,
  DiscoveryFeedLoader loader, {
  List<ItemType> types = const [ItemType.manga, ItemType.anime, ItemType.novel],
  ItemType initialType = ItemType.manga,
  Size size = const Size(390, 844),
  double textScale = 1,
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) =>
            Scaffold(body: DiscoverButton(itemType: initialType)),
      ),
      GoRoute(
        path: '/discover',
        builder: (_, state) => DiscoverScreen(
          initialType: state.extra as ItemType,
          loadFeed: loader,
          availableTypes: types,
        ),
      ),
      GoRoute(
        path: '/globalSearch',
        builder: (_, state) {
          final (title, type) = state.extra as (String, ItemType);
          return Scaffold(body: Text('SEARCH $title ${type.name}'));
        },
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        theme: buildShioriTheme(
          brightness: Brightness.dark,
          colors: FlexColor.schemesList[2].dark,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Discover'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'catalog cards reuse accessible Shiori covers and keyboard activation',
    (tester) async {
      await openDiscovery(
        tester,
        ({required itemType, popular = false, includeAdult = false}) async => [
          DiscoveryMedia(id: 1, romaji: 'Keyboard title'),
        ],
      );
      expect(find.byType(ShioriCoverTile), findsNWidgets(2));
      final cover = tester.widget<ShioriCover>(find.byType(ShioriCover).first);
      expect(cover.title, 'Keyboard title');
      final focus = find
          .descendant(
            of: find.byType(ShioriCover).first,
            matching: find.byType(Focus),
          )
          .first;
      final focusChild = tester.widget<Focus>(focus).child;
      Focus.of(tester.element(find.byWidget(focusChild))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Search installed sources'), findsOneWidget);
    },
  );

  testWidgets('entry from anime starts on anime without manga requests', (
    tester,
  ) async {
    final calls = <ItemType>[];
    await openDiscovery(tester, ({
      required itemType,
      popular = false,
      includeAdult = false,
    }) async {
      calls.add(itemType);
      return [];
    }, initialType: ItemType.anime);
    expect(calls, [ItemType.anime, ItemType.anime]);
  });
  testWidgets('three types remain usable on narrow screens with large text', (
    tester,
  ) async {
    await openDiscovery(
      tester,
      ({required itemType, popular = false, includeAdult = false}) async => [
        DiscoveryMedia(id: 1, romaji: 'A title that needs two lines'),
      ],
      size: const Size(320, 900),
      textScale: 2,
    );
    await tester.tap(find.text('Anime'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('anime opens details and searches video sources, not manga', (
    tester,
  ) async {
    final calls = <ItemType>[];
    await openDiscovery(tester, ({
      required itemType,
      popular = false,
      includeAdult = false,
    }) async {
      calls.add(itemType);
      return [
        DiscoveryMedia(
          id: 1,
          romaji: itemType == ItemType.anime ? 'Anime title' : 'Manga title',
          type: itemType == ItemType.anime ? 'ANIME' : 'MANGA',
          description: 'Anime synopsis.',
        ),
      ];
    }, types: [ItemType.manga, ItemType.anime, ItemType.novel]);
    await tester.tap(find.text('Anime'));
    await tester.pumpAndSettle();
    expect(calls.where((type) => type == ItemType.anime).length, 2);
    await tester.tap(find.byType(ShioriCover).first);
    await tester.pumpAndSettle();
    expect(find.text('Anime synopsis.'), findsOneWidget);
    await tester.tap(find.text('Search installed sources'));
    await tester.pumpAndSettle();
    expect(find.text('SEARCH Anime title anime'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('catalog covers use a bounded public image provider without source settings', () {
    final provider =
        discoveryCover('https://s4.anilist.co/example.jpg') as ResizeImage;
    expect(provider.width, 288);
    expect(provider.height, 432);
    final network = provider.imageProvider as NetworkImage;
    expect(network.url, 'https://s4.anilist.co/example.jpg');
    expect(network.headers!.keys, ['User-Agent']);
  });

  testWidgets(
    'a failed shelf can recover without hiding the successful shelf',
    (tester) async {
      var failing = true;
      await openDiscovery(tester, ({
        required itemType,
        popular = false,
        includeAdult = false,
      }) async {
        if (!popular && failing) throw Exception('offline');
        return [DiscoveryMedia(id: 1, romaji: 'Available title')];
      });
      expect(find.text('Could not load this shelf.'), findsOneWidget);
      expect(find.byType(ShioriCover), findsOneWidget);
      failing = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Could not load this shelf.'), findsNothing);
      expect(find.byType(ShioriCover), findsNWidgets(2));
    },
  );
  testWidgets('late novel response cannot replace the selected manga shelf', (
    tester,
  ) async {
    final pending = Completer<List<DiscoveryMedia>>();
    await openDiscovery(tester, ({
      required itemType,
      popular = false,
      includeAdult = false,
    }) async {
      if (itemType == ItemType.novel) return pending.future;
      return [DiscoveryMedia(id: 1, romaji: 'Manga remains')];
    });
    await tester.tap(find.text('Novel'));
    await tester.pump();
    expect(find.text('Manga remains'), findsNothing);
    expect(find.byType(ShioriLoading), findsNWidgets(2));
    await tester.tap(find.text('Manga'));
    await tester.pumpAndSettle();
    pending.complete([DiscoveryMedia(id: 2, romaji: 'Late novel')]);
    await tester.pumpAndSettle();
    expect(find.text('Late novel'), findsNothing);
    expect(find.byType(ShioriCover), findsNWidgets(2));
  });
  testWidgets('hidden types do not cause any catalog request', (tester) async {
    var requests = 0;
    await openDiscovery(tester, ({
      required itemType,
      popular = false,
      includeAdult = false,
    }) async {
      requests++;
      return [];
    }, types: []);
    expect(requests, 0);
    expect(
      find.text(
        'Enable manga, anime or novels in Settings to discover titles.',
      ),
      findsOneWidget,
    );
  });
  testWidgets('empty catalogs are distinct from failures', (tester) async {
    await openDiscovery(
      tester,
      ({required itemType, popular = false, includeAdult = false}) async => [],
    );
    expect(find.text('No titles in this selection.'), findsNWidgets(2));
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets(
    'switch to novels, inspect synopsis and search installed sources',
    (tester) async {
      final calls = <(ItemType, bool)>[];
      await openDiscovery(tester, ({
        required itemType,
        popular = false,
        includeAdult = false,
      }) async {
        calls.add((itemType, popular));
        return [
          DiscoveryMedia(
            id: popular ? 2 : 1,
            romaji: itemType == ItemType.novel ? 'Novel title' : 'Manga title',
            format: itemType == ItemType.novel ? 'NOVEL' : 'MANGA',
            description: 'A complete synopsis.',
            genres: ['Fantasy'],
          ),
        ];
      });
      expect(find.text('Discover'), findsOneWidget);
      expect(find.text('Trending'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      await tester.tap(find.text('Novel'));
      await tester.pumpAndSettle();
      expect(
        calls,
        containsAll([(ItemType.novel, false), (ItemType.novel, true)]),
      );
      expect(find.text('Manga title'), findsNothing);
      await tester.tap(find.byType(ShioriCover).first);
      await tester.pumpAndSettle();
      expect(find.text('A complete synopsis.'), findsOneWidget);
      await tester.tap(find.text('Search installed sources'));
      await tester.pumpAndSettle();
      expect(find.text('SEARCH Novel title novel'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
