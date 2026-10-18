import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/services/download_manager/next_downloads.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';

/// The detail page app bar's download shortcut: pick "next N" / "unread" /
/// "all" and queue those chapters, without opening the full filter/sort
/// sheet.
class DownloadQuickMenu extends StatelessWidget {
  final ItemType itemType;
  final Manga manga;
  final Future<void> Function(BuildContext context, List<Chapter> chapters)
  onDownload;

  const DownloadQuickMenu({
    super.key,
    required this.itemType,
    required this.manga,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final anime = itemType == ItemType.anime;
    Future<void> download(int value) async {
      final chapters = manga.getFilteredChapters();
      final chaptersToDownload = value <= 3
          ? selectNextDownloads(
              chapters,
              count: [1, 5, 10, 25][value],
              downloads: downloadRepository.getAll(),
            )
          : chapters
                .where((chapter) => value == 5 || chapter.isRead != true)
                .toList();
      await onDownload(context, chaptersToDownload);
    }

    return ShioriMenuButton(
      icon: Symbols.download_rounded,
      tooltip: l10n.download,
      items: [
        for (final (i, label) in [
          anime ? l10n.next_episode : l10n.next_chapter,
          anime ? l10n.next_5_episodes : l10n.next_5_chapters,
          anime ? l10n.next_10_episodes : l10n.next_10_chapters,
          anime ? l10n.next_25_episodes : l10n.next_25_chapters,
        ].indexed)
          ShioriMenuItem(label: label, onSelected: () => download(i)),
        null,
        ShioriMenuItem(
          label: anime ? l10n.unwatched : l10n.unread,
          onSelected: () => download(4),
        ),
        ShioriMenuItem(
          label: anime ? l10n.all_episodes : l10n.all_chapters,
          onSelected: () => download(5),
        ),
      ],
    );
  }
}
