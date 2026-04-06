import 'package:flutter/material.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_destination_screen.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/language.dart';

class MassMigrationPreviewScreen extends StatelessWidget {
  const MassMigrationPreviewScreen({required this.sourceGroup, super.key});

  final MassMigrationSourceGroup sourceGroup;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mass_migration_preview_items)),
      body: Column(
        children: [
          ListTile(
            leading: MassMigrationSourceIcon(source: sourceGroup.source),
            title: Text(sourceGroup.sourceName),
            subtitle: Text(
              [
                if ((sourceGroup.lang ?? '').isNotEmpty)
                  completeLanguageName(sourceGroup.lang!),
                l10n.mass_migration_items_ready_for_review(sourceGroup.count),
              ].join(' • '),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: sourceGroup.items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final manga = sourceGroup.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${index + 1}'),
                              const SizedBox(width: 12),
                              MassMigrationCover(
                                libraryItem: manga,
                                source: sourceGroup.source,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      manga.name ??
                                          l10n.mass_migration_unknown_title,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      [
                                        if ((manga.author ?? '')
                                            .trim()
                                            .isNotEmpty)
                                          manga.author!,
                                        if ((manga.artist ?? '')
                                            .trim()
                                            .isNotEmpty)
                                          manga.artist!,
                                        l10n.mass_migration_chapter_count(
                                          manga.chapters.length,
                                        ),
                                      ].join(' • '),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          MassMigrationChapterSection(
                            title: l10n.mass_migration_source_chapters,
                            chapters: manga.chapters
                                .map(
                                  (chapter) =>
                                      chapter.name ??
                                      l10n.mass_migration_unknown_chapter,
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    createRoute(
                      page: MassMigrationDestinationScreen(
                        sourceGroup: sourceGroup,
                      ),
                    ),
                  );
                },
                child: Text(l10n.mass_migration_select_destination_source),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
