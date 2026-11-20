import 'package:material_ui/material_ui.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/chapter_gaps.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:shiori/shiori.dart';

/// "12 chapters missing" under the series' chapter count, which opens the
/// list of the numbers missing.
///
/// It only gave the count, and the reader was left to find the gaps in the
/// list by eye. Nothing is drawn when no number is missing.
class MissingChaptersLabel extends StatelessWidget {
  const MissingChaptersLabel({super.key, required this.manga});

  final Manga manga;

  @override
  Widget build(BuildContext context) {
    final ranges = manga.missingChapterRanges();
    final count = ranges.numberCount;
    if (count <= 0) return const SizedBox.shrink();
    final l10n = context.l10n;
    final anime = manga.itemType == ItemType.anime;
    final color = context.shiori.color.error.foreground;
    return Semantics(
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(ShioriShape.badge),
        onTap: () => showMissingChapters(context, manga, ranges),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: ShioriSpace.s4,
          children: [
            Flexible(
              child: Text(
                anime
                    ? l10n.missing_episodes(count)
                    : l10n.missing_chapters(count),
                style: context.shiori.text.meta.copyWith(color: color),
              ),
            ),
            Icon(
              Symbols.info_rounded,
              size: context.shiori.scaled(14),
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

/// The numbers missing from [manga], as runs ("3, 7–9, 100"), and why
/// they may be missing.
Future<void> showMissingChapters(
  BuildContext context,
  Manga manga,
  List<ChapterNumberRange> ranges,
) {
  final l10n = context.l10n;
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => ShioriDialog(
      title: manga.itemType == ItemType.anime
          ? l10n.missing_episodes_title
          : l10n.missing_chapters_title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: ShioriSpace.s12,
        children: [
          // A long run of gaps scrolls rather than pushing the dialog off
          // the screen; the numbers can be copied.
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.4,
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                formatChapterNumberRanges(ranges),
                style: dialogContext.shiori.text.section.copyWith(
                  color: dialogContext.shiori.color.fg,
                ),
              ),
            ),
          ),
          Text(
            l10n.missing_chapters_info,
            style: dialogContext.shiori.text.meta.copyWith(
              color: dialogContext.shiori.color.fgMuted,
            ),
          ),
        ],
      ),
      actions: [
        ShioriButton(
          label: l10n.close,
          onPressed: () => Navigator.pop(dialogContext),
        ),
      ],
    ),
  );
}
