import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Card displaying a matched mass migration item during review.
class MassMigrationResolvedItemCard extends StatelessWidget {
  const MassMigrationResolvedItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.sourceGroup,
    required this.destinationSource,
    required this.isLoadingCandidate,
    required this.onShouldMigrateChanged,
    required this.onPickAnotherCandidate,
  });

  final MassMigrationResolvedItem item;
  final int index;
  final MassMigrationSourceGroup sourceGroup;
  final Source destinationSource;
  final bool isLoadingCandidate;
  final ValueChanged<bool> onShouldMigrateChanged;
  final VoidCallback onPickAnotherCandidate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final destinationChapterNames =
        item.destinationPreview?.chapters
            ?.map(
              (chapter) => chapter.name ?? l10n.mass_migration_unknown_chapter,
            )
            .toList() ??
        const <String>[];
    final sourceChapterNames = item.sourceItem.chapters
        .map((chapter) => chapter.name ?? l10n.mass_migration_unknown_chapter)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ShioriSpace.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MassMigrationCover(
                  libraryItem: item.sourceItem,
                  source: sourceGroup.source,
                ),
                const SizedBox(width: ShioriSpace.s12),
                const Icon(Symbols.arrow_forward_rounded, fill: 1),
                const SizedBox(width: ShioriSpace.s12),
                MassMigrationCover(
                  remoteItem: item.selectedCandidate,
                  source: destinationSource,
                ),
                const SizedBox(width: ShioriSpace.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.sourceItem.name ??
                            l10n.mass_migration_unknown_title,
                        style: context.shiori.text.section.copyWith(
                          color: context.shiori.color.fg,
                        ),
                      ),
                      const SizedBox(height: ShioriSpace.s8),
                      Text(
                        item.hasMatch
                            ? (item.selectedCandidate?.name ??
                                  l10n.mass_migration_unknown_match)
                            : l10n.mass_migration_no_destination_match,
                        style: context.shiori.text.row.copyWith(
                          color: item.hasMatch
                              ? context.shiori.color.fg
                              : context.shiori.color.fgMuted,
                        ),
                      ),
                      const SizedBox(height: ShioriSpace.s8),
                      Text(
                        [
                          l10n.mass_migration_source_chapter_count(
                            item.sourceItem.chapters.length,
                          ),
                          l10n.mass_migration_destination_chapter_count(
                            destinationChapterNames.length,
                          ),
                          if ((item.searchResult.usedQuery ?? '').isNotEmpty)
                            l10n.mass_migration_query(
                              item.searchResult.usedQuery!,
                            ),
                        ].join(' · '),
                        style: context.shiori.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if ((item.errorMessage ?? '').isNotEmpty) ...[
              const SizedBox(height: ShioriSpace.s8),
              Text(
                item.errorMessage!,
                style: context.shiori.text.meta.copyWith(
                  color: context.shiori.color.error.foreground,
                ),
              ),
            ],
            const SizedBox(height: ShioriSpace.s12),
            Row(
              children: [
                if (item.canMigrate)
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 260),
                      child: ShioriSegmentedControl<bool>(
                        segments: [
                          ShioriSegment(
                            value: false,
                            label: l10n.mass_migration_skip,
                          ),
                          ShioriSegment(value: true, label: l10n.migrate),
                        ],
                        selected: item.shouldMigrate,
                        onSelected: onShouldMigrateChanged,
                      ),
                    ),
                  ),
                const Spacer(),
                if (item.searchResult.candidates.length > 1)
                  ShioriButton.quiet(
                    onPressed: isLoadingCandidate
                        ? null
                        : onPickAnotherCandidate,
                    label: isLoadingCandidate
                        ? l10n.mass_migration_loading
                        : l10n.mass_migration_choose_another_result,
                  ),
              ],
            ),
            const SizedBox(height: ShioriSpace.s8),
            MassMigrationChapterSection(
              title: l10n.mass_migration_source_chapters,
              chapters: sourceChapterNames,
            ),
            MassMigrationChapterSection(
              title: l10n.mass_migration_destination_chapters,
              chapters: destinationChapterNames,
            ),
          ],
        ),
      ),
    );
  }
}
