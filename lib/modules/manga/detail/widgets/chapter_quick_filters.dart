import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// The chapter filters a reader reaches for, as chips right above the list
/// they filter: Unread, Downloaded, Bookmarked. Each cycles off, only those,
/// all but those; the last chip opens the full sheet (scanlators, sorting).
/// They used to live behind an icon at the top of the page, away from the
/// list.
class ChapterQuickFilters extends ConsumerWidget {
  const ChapterQuickFilters({
    super.key,
    required this.manga,
    required this.onMore,
  });

  final Manga manga;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = manga.id!;
    final local = manga.isLocalArchive ?? false;
    final unread = chapterFilterUnreadStateProvider(mangaId: id);
    final downloaded = chapterFilterDownloadedStateProvider(mangaId: id);
    final bookmarked = chapterFilterBookmarkedStateProvider(mangaId: id);
    // Each filter carries its count, which a row of figures above the
    // header used to repeat: the number sits where it can be acted on.
    final chapters = manga.chapters.toList();
    final downloadedIds =
        ref.watch(downloadedChapterIdsProvider).asData?.value ?? const <int>{};
    final chips = <(String, int, int, VoidCallback)>[
      (
        manga.itemType == ItemType.anime ? l10n.unwatched : l10n.unread,
        chapters.where((c) => !(c.isRead ?? false)).length,
        ref.watch(unread),
        () => ref.read(unread.notifier).update(),
      ),
      if (!local)
        (
          l10n.downloaded,
          chapters.where((c) => downloadedIds.contains(c.id)).length,
          ref.watch(downloaded),
          () => ref.read(downloaded.notifier).update(),
        ),
      (
        l10n.bookmarked,
        chapters.where((c) => c.isBookmarked ?? false).length,
        ref.watch(bookmarked),
        () => ref.read(bookmarked.notifier).update(),
      ),
    ];
    final c = context.shiori.color;
    return SizedBox(
      height: context.shiori.density.minTarget,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
        children: [
          for (final (label, count, state, cycle) in chips)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: ShioriSpace.s8),
              child: FilterChip(
                selected: state != 0,
                showCheckmark: false,
                avatar: state == 0
                    ? null
                    : Icon(
                        state == 1
                            ? Symbols.check_rounded
                            : Symbols.block_rounded,
                        color: state == 1 ? c.accentInk : c.error.foreground,
                      ),
                label: Text.rich(
                  TextSpan(
                    text: label,
                    children: [
                      TextSpan(
                        text: ' · $count',
                        style: TextStyle(
                          color: c.fgMuted,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                tooltip: state == 2 ? '${l10n.excluded}: $label' : label,
                onSelected: (_) => cycle(),
              ),
            ),
          ActionChip(
            avatar: const Icon(Symbols.tune_rounded),
            label: Text(l10n.more_filters),
            onPressed: onMore,
          ),
        ],
      ),
    );
  }
}
