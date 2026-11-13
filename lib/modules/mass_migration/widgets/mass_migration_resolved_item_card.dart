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
            // The two titles side by side, each under its cover: beside both
            // covers, a long title was left a column a few letters wide.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Side(
                    cover: MassMigrationCover(
                      libraryItem: item.sourceItem,
                      source: sourceGroup.source,
                    ),
                    title:
                        item.sourceItem.name ??
                        l10n.mass_migration_unknown_title,
                    sourceName: sourceGroup.sourceName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 44,
                    left: ShioriSpace.s8,
                    right: ShioriSpace.s8,
                  ),
                  child: Icon(
                    Symbols.arrow_forward_rounded,
                    fill: 1,
                    color: context.shiori.color.fgMuted,
                  ),
                ),
                Expanded(
                  child: _Side(
                    cover: MassMigrationCover(
                      remoteItem: item.selectedCandidate,
                      source: destinationSource,
                    ),
                    title: item.hasMatch
                        ? (item.selectedCandidate?.name ??
                              l10n.mass_migration_unknown_match)
                        : l10n.mass_migration_no_destination_match,
                    muted: !item.hasMatch,
                    sourceName: destinationSource.name,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ShioriSpace.s12),
            Text(
              [
                l10n.mass_migration_source_chapter_count(
                  item.sourceItem.chapters.length,
                ),
                l10n.mass_migration_destination_chapter_count(
                  destinationChapterNames.length,
                ),
                if ((item.searchResult.usedQuery ?? '').isNotEmpty)
                  l10n.mass_migration_query(item.searchResult.usedQuery!),
              ].join(' · '),
              style: context.shiori.caption,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
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
            // The choice gets a line of its own: sharing one with a spacer and
            // the other button squeezed it down to a blank pill.
            if (item.canMigrate)
              ShioriSegmentedControl<bool>(
                segments: [
                  ShioriSegment(value: false, label: l10n.mass_migration_skip),
                  ShioriSegment(value: true, label: l10n.migrate),
                ],
                selected: item.shouldMigrate,
                onSelected: onShouldMigrateChanged,
              ),
            if (item.searchResult.candidates.length > 1)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: ShioriButton.quiet(
                  onPressed: isLoadingCandidate ? null : onPickAnotherCandidate,
                  label: isLoadingCandidate
                      ? l10n.mass_migration_loading
                      : l10n.mass_migration_choose_another_result,
                ),
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

/// One side of the migration: a cover, its title and the source it is on.
class _Side extends StatelessWidget {
  const _Side({
    required this.cover,
    required this.title,
    required this.sourceName,
    this.muted = false,
  });

  final Widget cover;
  final String title;
  final String? sourceName;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cover,
        const SizedBox(height: ShioriSpace.s8),
        Text(
          title,
          style: context.shiori.text.row.copyWith(
            color: muted
                ? context.shiori.color.fgMuted
                : context.shiori.color.fg,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if ((sourceName ?? '').isNotEmpty)
          Text(
            sourceName!,
            style: context.shiori.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
