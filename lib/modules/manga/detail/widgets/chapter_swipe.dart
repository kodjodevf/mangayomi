import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/download/providers/download_gate.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/haptics.dart';
import 'package:shiori/shiori.dart';

/// The swipe actions on a chapter row, wherever the row is: a series'
/// chapter list or Updates. Each direction does what Settings › Reader ›
/// Chapter swipe actions says (bookmark, read, download) and snaps back.
class ChapterSwipe extends ConsumerWidget {
  const ChapterSwipe({
    super.key,
    required this.chapter,
    required this.child,
    this.enabled = true,
  });

  final Chapter chapter;
  final Widget child;

  /// Off while selecting, where a swipe would fight the selection.
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final start = ref.watch(chapterSwipeStartActionStateProvider);
    final end = ref.watch(chapterSwipeEndActionStateProvider);
    const off = ChapterSwipeAction.disabled;
    final direction = !enabled || (start == off && end == off)
        ? DismissDirection.none
        : start == off
        ? DismissDirection.endToStart
        : end == off
        ? DismissDirection.startToEnd
        : DismissDirection.horizontal;
    return Dismissible(
      key: ValueKey('chapter_swipe_${chapter.id}'),
      direction: direction,
      confirmDismiss: (direction) async {
        final action = direction == DismissDirection.startToEnd ? start : end;
        selectionHaptic();
        await performChapterSwipeAction(action, chapter, ref);
        return false; // Don't dismiss, snap back
      },
      background: _background(context, start, Alignment.centerLeft),
      secondaryBackground: _background(context, end, Alignment.centerRight),
      child: child,
    );
  }

  Widget _background(
    BuildContext context,
    ChapterSwipeAction action,
    Alignment alignment,
  ) {
    final c = context.shiori.color;
    final (ShioriStatus, IconData)? look = switch (action) {
      ChapterSwipeAction.toggleBookmark => (
        c.unread,
        chapter.isBookmarked!
            ? Symbols.bookmark_remove_rounded
            : Symbols.bookmark_add_rounded,
      ),
      ChapterSwipeAction.toggleRead => (
        chapter.isRead! ? c.read : c.completed,
        chapter.isRead!
            ? Symbols.remove_done_rounded
            : Symbols.done_all_rounded,
      ),
      ChapterSwipeAction.download =>
        _isDownloaded(chapter)
            ? (c.error, Symbols.delete_rounded)
            : (c.downloaded, Symbols.download_rounded),
      ChapterSwipeAction.disabled => null,
    };
    if (look == null) return const SizedBox.shrink();
    final (tone, icon) = look;
    return Container(
      color: tone.background,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s24),
      child: Icon(icon, fill: 1, color: tone.foreground),
    );
  }
}

bool _isDownloaded(Chapter chapter) {
  final download = downloadRepository.getByChapterId(chapter.id);
  return download != null && download.isDownload == true;
}

/// Does what a swipe on [chapter] is set to do.
Future<void> performChapterSwipeAction(
  ChapterSwipeAction action,
  Chapter chapter,
  WidgetRef ref,
) async {
  switch (action) {
    case ChapterSwipeAction.toggleBookmark:
      chapter.isBookmarked = !chapter.isBookmarked!;
      await chapterRepository.save(chapter);
    case ChapterSwipeAction.toggleRead:
      chapter.isRead = !chapter.isRead!;
      if (!chapter.isRead!) chapter.lastPageRead = "1";
      await chapterRepository.save(chapter);
    case ChapterSwipeAction.download:
      if (_isDownloaded(chapter)) {
        await chapter.deleteDownloadedFiles();
      } else if (!isDownloadScheduled(chapter.id)) {
        await downloadRepository.enqueue(chapter);
        if (ref.context.mounted) {
          ref.invalidate(downloadChapterProvider(chapter: chapter));
          ref.read(downloadChapterProvider(chapter: chapter));
        }
      }
    case ChapterSwipeAction.disabled:
      break;
  }
}
