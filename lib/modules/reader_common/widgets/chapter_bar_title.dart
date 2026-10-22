import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/reader_common/providers/chapter_display.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// The series and the chapter or episode being opened, for the bar of a
/// reader's or the player's loading and failure states, as their own top
/// bars say it. Named as the series' list names it ([chapterDisplayName]).
class ChapterBarTitle extends ConsumerWidget {
  const ChapterBarTitle({
    super.key,
    required this.chapter,
    this.onImage = false,
  });

  final Chapter? chapter;

  /// Drawn on the black of a video rather than on the app's ground.
  final bool onImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.shiori;
    final chapter = this.chapter;
    final manga = chapter?.manga.value;
    if (chapter == null || manga == null) return const SizedBox.shrink();
    final byNumber = ref.watch(
      chapterNumberDisplayProvider.select((ids) => ids.contains(manga.id)),
    );
    final titleColor = onImage ? Colors.white : tokens.color.fg;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          manga.name ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: tokens.text.row.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          chapterDisplayName(chapter, manga, context.l10n, byNumber: byNumber),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: onImage
              ? tokens.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                )
              : tokens.caption,
        ),
      ],
    );
  }
}
