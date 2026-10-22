import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Summary phase view shown when mass migration completes.
class MassMigrationSummaryPhase extends StatelessWidget {
  const MassMigrationSummaryPhase({
    super.key,
    required this.sourceGroup,
    required this.destinationSource,
    required this.resolvedItems,
    required this.migratedCount,
    required this.skippedCount,
    required this.failedItems,
    required this.onExit,
  });

  final MassMigrationSourceGroup sourceGroup;
  final Source destinationSource;
  final List<MassMigrationResolvedItem> resolvedItems;
  final int migratedCount;
  final int skippedCount;
  final List<String> failedItems;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = sourceGroup.items.length;
    final matchedCount = resolvedItems.where((item) => item.hasMatch).length;
    final tone = failedItems.isEmpty
        ? context.shiori.color.completed
        : context.shiori.color.offline;
    final successTone = tone.foreground;

    return Container(
      decoration: BoxDecoration(color: context.shiori.color.ink0),
      child: ListView(
        padding: const EdgeInsets.all(ShioriSpace.s16),
        children: [
          Container(
            padding: const EdgeInsets.all(ShioriSpace.s24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ShioriShape.card),
              color: context.shiori.color.ink1,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: tone.background,
                    borderRadius: BorderRadius.circular(ShioriShape.card),
                  ),
                  child: Icon(
                    failedItems.isEmpty
                        ? Symbols.task_alt_rounded
                        : Symbols.done_all_rounded,
                    color: successTone,
                    size: 30,
                  ),
                ),
                const SizedBox(width: ShioriSpace.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.mass_migration_complete,
                        style: context.shiori.text.seriesTitle.copyWith(
                          color: context.shiori.color.fg,
                        ),
                      ),
                      const SizedBox(height: ShioriSpace.s8),
                      Text(
                        failedItems.isEmpty
                            ? l10n.mass_migration_complete_success_message
                            : l10n.mass_migration_complete_partial_message,
                        style: context.shiori.text.body.copyWith(
                          color: context.shiori.color.fg,
                        ),
                      ),
                      const SizedBox(height: ShioriSpace.s12),
                      Text(
                        l10n.mass_migration_route_summary(
                          sourceGroup.sourceName,
                          destinationSource.name ?? '',
                        ),
                        style: context.shiori.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: ShioriSpace.s16),
          Wrap(
            spacing: ShioriSpace.s12,
            runSpacing: ShioriSpace.s12,
            children: [
              SummaryStatCard(
                label: l10n.mass_migration_processed,
                value: '$total',
              ),
              SummaryStatCard(
                label: l10n.mass_migration_matched,
                value: '$matchedCount',
              ),
              SummaryStatCard(
                label: l10n.mass_migration_migrated,
                value: '$migratedCount',
              ),
              SummaryStatCard(
                label: l10n.mass_migration_skipped,
                value: '$skippedCount',
              ),
              SummaryStatCard(
                label: l10n.mass_migration_failed,
                value: '${failedItems.length}',
              ),
            ],
          ),
          if (failedItems.isNotEmpty) ...[
            const SizedBox(height: ShioriSpace.s24),
            Container(
              padding: const EdgeInsets.all(ShioriSpace.s16),
              decoration: BoxDecoration(
                color: context.shiori.color.ink1,
                borderRadius: BorderRadius.circular(ShioriShape.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mass_migration_failed_items,
                    style: context.shiori.text.section.copyWith(
                      color: context.shiori.color.fg,
                    ),
                  ),
                  const SizedBox(height: ShioriSpace.s12),
                  for (final item in failedItems)
                    Padding(
                      padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
                      child: Row(
                        children: [
                          Icon(
                            Symbols.error_outline_rounded,
                            fill: 1,
                            size: 18,
                            color: context.shiori.color.offline.foreground,
                          ),
                          const SizedBox(width: ShioriSpace.s8),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: ShioriSpace.s24),
          ShioriButton(
            onPressed: onExit,
            icon: Symbols.exit_to_app_rounded,
            label: l10n.mass_migration_exit,
          ),
        ],
      ),
    );
  }
}

/// One figure of the summary: the number large and tabular, its label under it.
class SummaryStatCard extends StatelessWidget {
  const SummaryStatCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return Container(
      width: 156,
      padding: const EdgeInsets.all(ShioriSpace.s16),
      decoration: BoxDecoration(
        color: tokens.color.ink1,
        borderRadius: BorderRadius.circular(ShioriShape.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: ShioriSpace.s4,
        children: [
          Text(
            value,
            style: tokens.text.seriesTitle.copyWith(
              color: tokens.color.fg,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(label, style: tokens.caption),
        ],
      ),
    );
  }
}
