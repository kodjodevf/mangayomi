import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_preview_screen.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/mass_migration/widgets/mass_migration_widgets.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MassMigrationSourceSelectionScreen extends StatelessWidget {
  const MassMigrationSourceSelectionScreen({
    required this.itemType,
    this.prioritizedManga,
    super.key,
  });

  /// Which library to group. The screen lists every source in it.
  final ItemType itemType;

  /// Optional: the manga the user came from, whose source floats to the top.
  /// Null when opened library-wide (e.g. from More) rather than from a manga.
  final Manga? prioritizedManga;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sourceGroups = buildMassMigrationSourceGroups(
      itemType: itemType,
      prioritizedManga: prioritizedManga,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mass_migration_title)),
      body: sourceGroups.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(l10n.mass_migration_no_library_items),
              ),
            )
          : ListView.separated(
              padding: tvPageInsets,
              itemCount: sourceGroups.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final sourceGroup = sourceGroups[index];
                void open() => Navigator.push(
                  context,
                  createRoute(
                    page: MassMigrationPreviewScreen(sourceGroup: sourceGroup),
                  ),
                );
                final tile = ListTile(
                  leading: MassMigrationSourceIcon(source: sourceGroup.source),
                  title: Text(sourceGroup.sourceName),
                  subtitle: Text(
                    [
                      if ((sourceGroup.lang ?? '').isNotEmpty)
                        completeLanguageName(sourceGroup.lang!),
                      l10n.mass_migration_item_count(sourceGroup.count),
                    ].join(' • '),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                );
                if (isTv) {
                  return TvListRow(
                    children: [
                      Expanded(
                        child: TvRowButton(
                          autofocus: index == 0,
                          onTap: open,
                          child: tile,
                        ),
                      ),
                    ],
                  );
                }
                return ListTile(
                  leading: tile.leading,
                  title: tile.title,
                  subtitle: tile.subtitle,
                  trailing: tile.trailing,
                  onTap: open,
                );
              },
            ),
    );
  }
}
