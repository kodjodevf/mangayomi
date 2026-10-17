import 'package:flutter/material.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/services/download_manager/next_downloads.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';

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
    final l10n = l10nLocalizations(context)!;
    return PopupMenuButton(
      popUpAnimationStyle: popupAnimationStyle,
      icon: const Icon(Icons.download_outlined),
      tooltip: l10n.download,
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: Text(
              itemType != ItemType.anime
                  ? context.l10n.next_chapter
                  : context.l10n.next_episode,
            ),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Text(
              itemType != ItemType.anime
                  ? context.l10n.next_5_chapters
                  : context.l10n.next_5_episodes,
            ),
          ),
          PopupMenuItem<int>(
            value: 2,
            child: Text(
              itemType != ItemType.anime
                  ? context.l10n.next_10_chapters
                  : context.l10n.next_10_episodes,
            ),
          ),
          PopupMenuItem<int>(
            value: 3,
            child: Text(
              itemType != ItemType.anime
                  ? context.l10n.next_25_chapters
                  : context.l10n.next_25_episodes,
            ),
          ),
          PopupMenuItem<int>(
            value: 4,
            child: Text(
              itemType != ItemType.anime
                  ? context.l10n.unread
                  : context.l10n.unwatched,
            ),
          ),
          PopupMenuItem<int>(
            value: 5,
            child: Text(
              itemType != ItemType.anime
                  ? context.l10n.all_chapters
                  : context.l10n.all_episodes,
            ),
          ),
        ];
      },
      onSelected: (value) async {
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
      },
    );
  }
}
