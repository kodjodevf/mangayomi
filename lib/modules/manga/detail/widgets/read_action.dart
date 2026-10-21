import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:shiori/shiori.dart';

/// The chapter the reader last opened in [manga], or null when there is
/// none, or while incognito (whose reading is not remembered).
Chapter? resumeChapterFor(Manga manga, {required bool incognito}) {
  if (incognito || manga.id == null) return null;
  final history = historyRepository.findByMangaId(manga.id!);
  if (history == null) return null;
  if (!history.chapter.isLoaded) history.chapter.loadSync();
  return history.chapter.value;
}

/// The chapter to open when there is no history: the first unread one in
/// reading order (by number, under the series' filters), else the first.
Chapter? firstUnreadChapterFor(Manga manga) {
  final ordered = manga.getChapterListForReading();
  if (ordered.isEmpty) return null;
  return ordered.firstWhere(
    (c) => !(c.isRead ?? false),
    orElse: () => ordered.first,
  );
}

/// The page's one main action, under the header: resume where the reader
/// stopped, or start the series. It replaces a floating button that covered
/// the chapter list it was about.
class ReadActionButton extends ConsumerWidget {
  const ReadActionButton({super.key, required this.manga});

  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(isLongPressedStateProvider)) return const SizedBox.shrink();
    final chapters = manga.chapters.toList();
    if (chapters.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    final resume = resumeChapterFor(
      manga,
      incognito: ref.watch(incognitoModeStateProvider),
    );
    final start = manga.itemType == ItemType.anime ? l10n.watch : l10n.read;
    // With no history (chapters marked by hand, or brought in by a tracker
    // or a backup), the first unread chapter in reading order; it used to
    // open the list's first chapter, the newest on most sources.
    final next = resume == null ? firstUnreadChapterFor(manga) : null;
    final anyRead = chapters.any((c) => c.isRead ?? false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s16,
        ShioriSpace.s8,
        ShioriSpace.s16,
        ShioriSpace.s4,
      ),
      child: ShioriButton(
        expand: true,
        icon: Symbols.play_arrow_rounded,
        label: resume != null
            ? '${l10n.resume} · ${resume.name}'
            : next != null && anyRead && !(next.isRead ?? false)
            ? '${l10n.continue_reading} · ${next.name}'
            : start,
        onPressed: () =>
            (resume ?? next ?? chapters.first).pushToReaderView(context),
      ),
    );
  }
}
