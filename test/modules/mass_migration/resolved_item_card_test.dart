import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/l10n_delegates.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_resolved_item_card.dart';
import 'package:shiori/shiori.dart';

const _longTitle =
    'The Reincarnated Swordmaster Who Became the Strongest Villainess in '
    'Another World';

/// #1137: on a phone, both covers and the arrow left the titles a column a
/// few letters wide, and the Skip / Migrate choice, sharing its line with
/// another button, was squeezed into a blank pill.
void main() {
  for (final width in [320.0, 360.0]) {
    testWidgets('a long title still reads on a ${width.toInt()} dp phone', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final old = Manga(
        source: 'Old',
        author: '',
        artist: '',
        genre: const [],
        imageUrl: null,
        lang: 'en',
        link: '/old',
        name: _longTitle,
        status: Status.ongoing,
        description: '',
        sourceId: null,
      );
      final match = MManga(name: '$_longTitle (Official)', link: '/new');
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: appLocalizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(ShioriSpace.s16),
                child: MassMigrationResolvedItemCard(
                  item: MassMigrationResolvedItem(
                    sourceItem: old,
                    searchResult: MassMigrationSearchResult(
                      queries: const ['Swordmaster'],
                      candidates: [
                        match,
                        MManga(name: 'Other', link: '/o'),
                      ],
                      selected: match,
                      usedQuery: 'Swordmaster',
                    ),
                    selectedCandidate: match,
                    destinationPreview: MManga(chapters: []),
                    shouldMigrate: true,
                  ),
                  index: 0,
                  sourceGroup: MassMigrationSourceGroup(
                    sourceName: 'Old',
                    itemType: ItemType.manga,
                    items: [old],
                  ),
                  destinationSource: Source(name: '', lang: ''),
                  isLoadingCandidate: false,
                  onShouldMigrateChanged: (_) {},
                  onPickAnotherCandidate: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      // Each title gets about half the card, not what two covers leave.
      expect(tester.getSize(find.text(_longTitle)).width, greaterThan(100));
      // The choice spans the card, wide enough for its two labels.
      final choice = find.byType(ShioriSegmentedControl<bool>);
      expect(tester.getSize(choice).width, greaterThan(width - 80));
      final l10n = AppLocalizations.of(tester.element(choice))!;
      expect(find.text(l10n.migrate), findsOneWidget);
      expect(
        tester.getSize(find.text(l10n.migrate)).width,
        lessThan(tester.getSize(choice).width / 2),
      );
    });
  }
}
