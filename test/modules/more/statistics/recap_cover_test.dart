import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_cover.dart';

Manga _series({
  String? imageUrl,
  String? source,
  String? lang,
  String name = 'Spare Me, Great Lord!',
}) => Manga(
  source: source,
  author: '',
  artist: '',
  genre: const [],
  imageUrl: imageUrl,
  lang: lang,
  link: '/spare-me',
  name: name,
  status: Status.ongoing,
  description: '',
  sourceId: null,
  itemType: ItemType.manga,
);

Future<void> _pump(
  WidgetTester tester,
  Manga? manga, {
  bool showTitle = true,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [recapMangaProvider.overrideWith((ref, id) async => manga)],
      child: MaterialApp(
        home: Center(
          child: SizedBox(
            width: 90,
            height: 135,
            child: RecapCover(
              mangaId: 1,
              placeholder: Colors.black,
              showTitle: showTitle,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('a series with no cover shows its title', (tester) async {
    await _pump(tester, _series());

    expect(find.text('Spare Me, Great Lord!'), findsOneWidget);
  });

  testWidgets('a cover that fails to load shows the title', (tester) async {
    await tester.runAsync(() async {
      await _pump(tester, _series(imageUrl: 'https://cover.invalid/x.jpg'));
      for (var i = 0; i < 50; i++) {
        if (find.text('Spare Me, Great Lord!').evaluate().isNotEmpty) break;
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await tester.pump();
      }
    });

    expect(find.text('Spare Me, Great Lord!'), findsOneWidget);
  });

  testWidgets('without showTitle a missing cover stays a plain box', (
    tester,
  ) async {
    await _pump(tester, _series(), showTitle: false);

    expect(find.text('Spare Me, Great Lord!'), findsNothing);
  });

  testWidgets('a series whose source is gone still builds', (tester) async {
    // Orphaned entries (uninstalled source, legacy rows) have no source or
    // lang; source headers must be skipped rather than force-unwrapped.
    await _pump(tester, _series(imageUrl: 'https://cover.invalid/x.jpg'));

    expect(tester.takeException(), isNull);
  });

  testWidgets('a word too long for the tile shrinks instead of breaking', (
    tester,
  ) async {
    await _pump(tester, _series(name: 'Survival Story of a Sword King'));

    final text = tester.widget<Text>(
      find.text('Survival Story of a Sword King'),
    );
    final word = TextPainter(
      text: TextSpan(text: 'Survival', style: text.style),
      textDirection: TextDirection.ltr,
    )..layout();
    // 90 wide less the padding on both sides.
    expect(word.width, lessThanOrEqualTo(90 - 2 * 8));
  });
}
