import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:shiori/shiori.dart';

/// Progress view during the match discovery phase of mass migration.
class MassMigrationMatchingPhase extends StatelessWidget {
  const MassMigrationMatchingPhase({
    super.key,
    required this.sourceGroup,
    required this.destinationSource,
    required this.currentIndex,
    required this.resolvedItems,
    required this.isWaitingForNextItem,
  });

  final MassMigrationSourceGroup sourceGroup;
  final Source destinationSource;
  final int currentIndex;
  final List<MassMigrationResolvedItem> resolvedItems;
  final bool isWaitingForNextItem;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = sourceGroup.items.length;
    final currentItem = sourceGroup.items[currentIndex];

    return Padding(
      padding: const EdgeInsets.all(ShioriSpace.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MassMigrationSourceIcon(source: destinationSource),
              const SizedBox(width: ShioriSpace.s12),
              Expanded(
                child: Text(
                  l10n.mass_migration_finding_matches(
                    destinationSource.name ?? '',
                    languageName(context, destinationSource.lang ?? ''),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ShioriSpace.s16),
          ShioriProgressBar(value: (currentIndex + 1) / total),
          const SizedBox(height: ShioriSpace.s8),
          Text(
            l10n.mass_migration_processing_item(currentIndex + 1, total),
            style: context.shiori.caption,
          ),
          const SizedBox(height: ShioriSpace.s16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(ShioriSpace.s16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MassMigrationCover(
                    libraryItem: currentItem,
                    source: sourceGroup.source,
                  ),
                  const SizedBox(width: ShioriSpace.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentItem.name ?? l10n.mass_migration_unknown_title,
                          style: context.shiori.text.section.copyWith(
                            color: context.shiori.color.fg,
                          ),
                        ),
                        const SizedBox(height: ShioriSpace.s8),
                        Text(
                          [
                            sourceGroup.sourceName,
                            l10n.mass_migration_chapter_count(
                              currentItem.chapters.length,
                            ),
                          ].join(' · '),
                          style: context.shiori.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isWaitingForNextItem) ...[
            const SizedBox(height: ShioriSpace.s12),
            Text(
              l10n.mass_migration_waiting_next_item,
              style: context.shiori.caption,
            ),
          ],
          if (resolvedItems.isNotEmpty) ...[
            const SizedBox(height: ShioriSpace.s16),
            Text(
              l10n.mass_migration_matched_so_far(
                resolvedItems.where((item) => item.hasMatch).length,
              ),
              style: context.shiori.caption,
            ),
            Text(
              l10n.mass_migration_no_match_count(
                resolvedItems.where((item) => !item.hasMatch).length,
              ),
              style: context.shiori.caption,
            ),
          ],
        ],
      ),
    );
  }
}
