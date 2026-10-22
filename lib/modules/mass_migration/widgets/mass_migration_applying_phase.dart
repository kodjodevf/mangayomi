import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Progress view during the database application phase of mass migration.
class MassMigrationApplyingPhase extends StatelessWidget {
  const MassMigrationApplyingPhase({
    super.key,
    required this.destinationSource,
    required this.sourceGroup,
    required this.selectedItems,
    required this.currentIndex,
    required this.isWaitingForNextItem,
  });

  final Source destinationSource;
  final MassMigrationSourceGroup sourceGroup;
  final List<MassMigrationResolvedItem> selectedItems;
  final int currentIndex;
  final bool isWaitingForNextItem;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = selectedItems.isEmpty ? 1 : selectedItems.length;
    final currentItem = selectedItems.isEmpty
        ? null
        : selectedItems[currentIndex.clamp(0, selectedItems.length - 1)];

    return Padding(
      padding: const EdgeInsets.all(ShioriSpace.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.mass_migration_migrating_selected(
              destinationSource.name ?? '',
            ),
            style: context.shiori.text.section.copyWith(
              color: context.shiori.color.fg,
            ),
          ),
          const SizedBox(height: ShioriSpace.s16),
          ShioriProgressBar(
            value: selectedItems.isEmpty ? 1 : (currentIndex + 1) / total,
          ),
          const SizedBox(height: ShioriSpace.s8),
          Text(
            selectedItems.isEmpty
                ? l10n.mass_migration_no_items_selected
                : l10n.mass_migration_migrating_item(currentIndex + 1, total),
            style: context.shiori.caption,
          ),
          const SizedBox(height: ShioriSpace.s16),
          if (currentItem != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(ShioriSpace.s16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MassMigrationCover(
                      libraryItem: currentItem.sourceItem,
                      source: sourceGroup.source,
                    ),
                    const SizedBox(width: ShioriSpace.s12),
                    const Icon(Symbols.arrow_forward_rounded, fill: 1),
                    const SizedBox(width: ShioriSpace.s12),
                    MassMigrationCover(
                      remoteItem: currentItem.selectedCandidate,
                      source: destinationSource,
                    ),
                    const SizedBox(width: ShioriSpace.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentItem.sourceItem.name ??
                                l10n.mass_migration_unknown_title,
                            style: context.shiori.text.section.copyWith(
                              color: context.shiori.color.fg,
                            ),
                          ),
                          const SizedBox(height: ShioriSpace.s8),
                          Text(
                            currentItem.selectedCandidate?.name ??
                                l10n.mass_migration_unknown_match,
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
              l10n.mass_migration_waiting_next_migration,
              style: context.shiori.caption,
            ),
          ],
        ],
      ),
    );
  }
}
