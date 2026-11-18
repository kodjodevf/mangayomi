import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/continue_shelf.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/manga/detail/widgets/read_action.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_interactive_region.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/reader_common/reader_chapter_navigation.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/router/push_router.dart';
import 'package:shiori/shiori.dart';

/// A series in the library to read after the one just finished, and what
/// ranks it.
class ReadNextEntry {
  const ReadNextEntry({
    required this.manga,
    required this.unread,
    required this.read,
    required this.downloadedUnread,
    required this.sharedGenres,
    required this.lastReadAt,
  });

  final Manga manga;

  /// Chapters left to read.
  final int unread;

  /// Chapters read: how long the series has been followed.
  final int read;

  /// Whether a chapter left to read is downloaded, so it opens at once,
  /// even offline.
  final bool downloadedUnread;

  /// The genres it has in common with the finished series, as [manga]
  /// spells them.
  final List<String> sharedGenres;

  /// When it was last read, in milliseconds; 0 when never.
  final int lastReadAt;
}

String _genreKey(String genre) => genre.trim().toLowerCase();

/// The genres of [manga] found in [genres] (lowercased keys).
List<String> sharedGenresOf(Manga manga, Set<String> genres) => [
  for (final g in manga.genre ?? const <String>[])
    if (g.trim().isNotEmpty && genres.contains(_genreKey(g))) g.trim(),
];

/// [candidates] ordered as the series most likely read next, and only those
/// with chapters left: a downloaded chapter to read first, then the most
/// genres in common, then the most chapters read, then the latest read.
List<ReadNextEntry> rankReadNext(
  Iterable<ReadNextEntry> candidates, {
  int limit = 8,
}) {
  final out = candidates.where((e) => e.unread > 0).toList()
    ..sort((a, b) {
      if (a.downloadedUnread != b.downloadedUnread) {
        return a.downloadedUnread ? -1 : 1;
      }
      final byGenres = b.sharedGenres.length.compareTo(a.sharedGenres.length);
      if (byGenres != 0) return byGenres;
      final byRead = b.read.compareTo(a.read);
      if (byRead != 0) return byRead;
      return b.lastReadAt.compareTo(a.lastReadAt);
    });
  return out.take(limit).toList();
}

/// What to read after the series [mangaId], from the rest of the library of
/// its kind: see [rankReadNext].
final readNextProvider = FutureProvider.autoDispose
    .family<List<ReadNextEntry>, int>((ref, mangaId) async {
      final current = await mangaRepository.findByIdAsync(mangaId);
      if (current == null) return const [];
      final library = mangaRepository.getFavoritesByItemType(current.itemType);
      final lastReadAt = <int, int>{};
      for (final h in historyRepository.getAll()) {
        final id = h.mangaId;
        final at = int.tryParse(h.date ?? '');
        if (id == null || at == null) continue;
        if (at > (lastReadAt[id] ?? 0)) lastReadAt[id] = at;
      }
      final genres = {
        for (final g in current.genre ?? const <String>[])
          if (g.trim().isNotEmpty) _genreKey(g),
      };
      final downloaded = await downloadRepository.getDownloadedChapterIds();
      final candidates = <ReadNextEntry>[];
      for (final m in library) {
        if (m.id == null || m.id == current.id) continue;
        final unreadIds = await chapterRepository.getUnreadIdsByMangaId(m.id!);
        if (unreadIds.isEmpty) continue;
        final total = await chapterRepository.countByMangaIdAsync(m.id);
        candidates.add(
          ReadNextEntry(
            manga: m,
            unread: unreadIds.length,
            read: total - unreadIds.length,
            downloadedUnread: unreadIds.any(downloaded.contains),
            sharedGenres: sharedGenresOf(m, genres),
            lastReadAt: lastReadAt[m.id] ?? 0,
          ),
        );
      }
      return rankReadNext(candidates);
    });

/// "Read next" on the page after a series' last chapter: other series in
/// the library with chapters left, the most alike first, each a tap from
/// its reader. Renders nothing when there is none.
class ReadNextShelf extends ConsumerWidget {
  const ReadNextShelf({super.key, required this.mangaId});

  final int mangaId;

  static const double _coverWidth = 96;

  /// Where to pick [manga] up: the chapter last opened if it isn't read
  /// yet, else the first unread one in reading order.
  static Chapter? _chapterToOpen(Manga manga, {required bool incognito}) {
    final resume = resumeChapterFor(manga, incognito: incognito);
    if (resume != null && !(resume.isRead ?? false)) return resume;
    return firstUnreadChapterFor(manga);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(readNextProvider(mangaId)).value;
    if (entries == null || entries.isEmpty) return const SizedBox.shrink();
    return ReaderInteractiveRegion(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShioriSectionHeader(title: context.l10n.read_next, overline: true),
          SizedBox(
            height: coverTileHeight(context, _coverWidth),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
              itemCount: entries.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: ShioriSpace.s12),
              itemBuilder: (context, i) {
                final e = entries[i];
                return SizedBox(
                  width: _coverWidth,
                  child: ShioriCoverTile(
                    subtitle: e.sharedGenres.take(2).join(' · '),
                    cover: ShioriCover(
                      image: resolveCoverImage(e.manga, ref),
                      title: e.manga.name ?? '',
                      unread: e.unread,
                      downloaded: e.downloadedUnread,
                      onTap: () {
                        final chapter = _chapterToOpen(
                          e.manga,
                          incognito: ref.read(incognitoModeStateProvider),
                        );
                        if (chapter == null) return;
                        if (!chapter.manga.isLoaded) chapter.manga.loadSync();
                        ReaderChapterNavigation.markNavigatingToChapter();
                        pushReplacementMangaReaderView(
                          context: context,
                          chapter: chapter,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          // Clear of the page number and the home indicator.
          SizedBox(
            height: MediaQuery.paddingOf(context).bottom + ShioriSpace.s48,
          ),
        ],
      ),
    );
  }
}
