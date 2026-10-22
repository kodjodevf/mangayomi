import 'package:flutter/material.dart';
import 'package:mangayomi/modules/reader_common/reader_chapter_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/reader_common/providers/chapter_display.dart';
import 'package:mangayomi/router/push_router.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_interactive_region.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/download_repository.dart';

/// Between two chapters: the one just read, the next one (or the end of the
/// series), and what to do about it.
///
/// It said to continue but gave nothing to press, and at the end of a
/// series no way back to it; it named chapters by their raw titles, and
/// said nothing of chapters missing between the two. The next chapter has
/// a button now and the end a way back to the series, both reachable
/// through the page's tap zones; chapters are named as in the series'
/// list; and a gap in the numbering is flagged on the next chapter.
class ChapterTransitionPage extends ConsumerWidget {
  final Chapter currentChapter;
  final Chapter? nextChapter;
  final String mangaName;
  final ReaderMode readerMode;

  const ChapterTransitionPage({
    super.key,
    required this.currentChapter,
    required this.nextChapter,
    required this.mangaName,
    required this.readerMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuilt when the series switches between titles and numbers; the
    // names below read the choice.
    ref.watch(chapterNumberDisplayProvider);
    return Container(
      color: context.shiori.color.ink0,
      child: readerMode.isVertical
          ? _buildVerticalScaffold(context)
          : _buildHorizontalScaffold(context),
    );
  }

  // ── Vertical: FittedBox path (width is always capped to 480) ──────────────

  Widget _buildVerticalScaffold(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth.clamp(100.0, 480.0),
                maxHeight: constraints.maxHeight.clamp(100.0, double.infinity),
              ),
              child: Padding(
                padding: const EdgeInsets.all(ShioriSpace.s24),
                child: _buildVerticalLayout(context),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Horizontal: MediaQuery path (Row/Expanded always get a real width) ────

  Widget _buildHorizontalScaffold(BuildContext context) {
    // Use the actual screen width so Expanded children always have a
    // finite constraint.  FittedBox is deliberately NOT used here because
    // it would pass infinite width down to the Row.
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        width: screenWidth,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(ShioriSpace.s24),
            child: _buildHorizontalLayout(context),
          ),
        ),
      ),
    );
  }

  // ── Vertical layout (top → arrow → bottom) ────────────────────────────────

  Widget _buildVerticalLayout(BuildContext context) {
    final l10n = context.l10n;
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Symbols.auto_stories_rounded,
            size: 48,
            color: context.shiori.color.accentInk,
          ),
          const SizedBox(height: ShioriSpace.s24),
          Text(
            l10n.end_of_chapter,
            style: context.shiori.text.screenTitle.copyWith(
              color: context.shiori.color.fg,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ShioriSpace.s16),
          _buildChapterCard(
            context,
            label: l10n.chapter_completed,
            name: _name(context, currentChapter),
            isPrimary: false,
          ),
          const SizedBox(height: ShioriSpace.s16),
          Icon(
            fill: 1,
            nextChapter != null
                ? Symbols.keyboard_arrow_down_rounded
                : Symbols.check_circle_rounded,
            size: 32,
            color: nextChapter != null
                ? context.shiori.color.accentInk
                : context.shiori.color.fgMuted,
          ),
          const SizedBox(height: ShioriSpace.s16),
          if (nextChapter != null) ...[
            _buildChapterCard(
              context,
              label: l10n.next_chapter,
              name: _name(context, nextChapter!),
              isPrimary: true,
            ),
            const SizedBox(height: ShioriSpace.s24),
            _action(context),
            const SizedBox(height: ShioriSpace.s12),
            Text(
              l10n.continue_to_next_chapter,
              style: context.shiori.caption,
              textAlign: TextAlign.center,
            ),
          ] else ...[
            _buildEndOfMangaCard(context),
            const SizedBox(height: ShioriSpace.s24),
            _action(context),
            const SizedBox(height: ShioriSpace.s12),
            Text(
              l10n.return_to_the_list_of_chapters,
              style: context.shiori.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  // ── Horizontal layout (left → arrow → right) ──────────────────────────────

  Widget _buildHorizontalLayout(BuildContext context) {
    final l10n = context.l10n;

    // For LTR: [current] → [next]
    // For RTL: [next] ← [current]
    final Widget currentCard = _buildChapterCard(
      context,
      label: l10n.chapter_completed,
      name: _name(context, currentChapter),
      isPrimary: false,
    );

    final Widget arrowIcon = Icon(
      fill: 1,
      nextChapter != null
          ? (readerMode.isRTL
                ? Symbols.keyboard_arrow_left_rounded
                : Symbols.keyboard_arrow_right_rounded)
          : Symbols.check_circle_rounded,
      size: 36,
      color: nextChapter != null
          ? context.shiori.color.accentInk
          : context.shiori.color.fgMuted,
    );

    final Widget nextCard = nextChapter != null
        ? _buildChapterCard(
            context,
            label: l10n.next_chapter,
            name: _name(context, nextChapter!),
            isPrimary: true,
          )
        : _buildEndOfMangaCard(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Symbols.auto_stories_rounded,
          size: 40,
          color: context.shiori.color.accentInk,
        ),
        const SizedBox(height: ShioriSpace.s16),
        Text(
          l10n.end_of_chapter,
          style: context.shiori.text.screenTitle.copyWith(
            color: context.shiori.color.fg,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: ShioriSpace.s24),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: readerMode.isRTL
                    ? [
                        Expanded(child: nextCard),
                        const SizedBox(width: ShioriSpace.s12),
                        Center(child: arrowIcon),
                        const SizedBox(width: ShioriSpace.s12),
                        Expanded(child: currentCard),
                      ]
                    : [
                        Expanded(child: currentCard),
                        const SizedBox(width: ShioriSpace.s12),
                        Center(child: arrowIcon),
                        const SizedBox(width: ShioriSpace.s12),
                        Expanded(child: nextCard),
                      ],
              ),
            ),
          ),
        ),
        const SizedBox(height: ShioriSpace.s24),
        _action(context),
        const SizedBox(height: ShioriSpace.s12),
        Text(
          nextChapter != null
              ? l10n.continue_to_next_chapter
              : l10n.return_to_the_list_of_chapters,
          style: context.shiori.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Shared card widgets ────────────────────────────────────────────────────

  /// How many chapters the numbering skips between the one read and the
  /// next, or 0 when it does not or a number cannot be read.
  int _gap() {
    final next = nextChapter;
    if (next == null) return 0;
    final recognition = ChapterRecognition();
    final (_, a) = recognition.rawSeasonAndNumber(
      mangaName,
      currentChapter.name ?? '',
    );
    final (_, b) = recognition.rawSeasonAndNumber(mangaName, next.name ?? '');
    if (a == null || b == null || a < 0 || b < 0) return 0;
    final missing = b.floor() - a.floor() - 1;
    return missing > 0 ? missing : 0;
  }

  /// Opens the next chapter, as reaching the end of this page would.
  void _openNext(BuildContext context) {
    ReaderChapterNavigation.markNavigatingToChapter();
    pushReplacementMangaReaderView(context: context, chapter: nextChapter!);
  }

  /// What to do from here: read the next chapter, or go back to the series.
  /// Its own region, so the page's tap zones leave the button its taps.
  Widget _action(BuildContext context) {
    final l10n = context.l10n;
    return ReaderInteractiveRegion(
      child: Center(
        child: nextChapter != null
            ? ShioriButton(
                icon: Symbols.skip_next_rounded,
                label: l10n.next_chapter,
                onPressed: () => _openNext(context),
              )
            : ShioriButton.secondary(
                icon: Symbols.arrow_back_rounded,
                label: l10n.back_to_series,
                onPressed: () => Navigator.maybePop(context),
              ),
      ),
    );
  }

  /// A chapter's name, or "Chapter" in the reader's language when the
  /// source gave none (the fallback was English and showed the database id).
  String _name(BuildContext context, Chapter chapter) {
    final manga = chapter.manga.value ?? currentChapter.manga.value;
    if ((chapter.name?.isNotEmpty ?? false) && manga != null) {
      return chapterDisplayName(
        chapter,
        manga,
        context.l10n,
        byNumber: ProviderScope.containerOf(
          context,
          listen: false,
        ).read(chapterNumberDisplayProvider).contains(manga.id),
      );
    }
    if (chapter.name?.isNotEmpty ?? false) return chapter.name!;
    final word = context.l10n.chapter;
    return word.isEmpty ? word : word[0].toUpperCase() + word.substring(1);
  }

  Widget _buildChapterCard(
    BuildContext context, {
    required String label,
    required String name,
    required bool isPrimary,
  }) {
    final tokens = context.shiori;
    final c = tokens.color;
    // Whether the next chapter can be read without a connection: the one
    // thing to know before turning the page on a train.
    final next = isPrimary ? nextChapter : null;
    final offline = next == null || next.archivePath != null
        ? null
        : downloadRepository.getByChapterId(next.id)?.isDownload == true;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s16,
        vertical: ShioriSpace.s12,
      ),
      decoration: BoxDecoration(
        color: isPrimary
            ? c.accent.withValues(alpha: Alphas.accentTint)
            : c.ink1,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        border: Border.all(
          color: isPrimary
              ? c.accent.withValues(alpha: Alphas.hairline * 2)
              : c.hairline,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: ShioriSpace.s4,
        children: [
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: tokens.text.overline.copyWith(
              color: isPrimary ? c.accentInk : c.fgMuted,
            ),
            maxLines: 2,
          ),
          Text(
            name,
            style: tokens.text.section.copyWith(color: c.fg),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (isPrimary && _gap() > 0) ...[
            const SizedBox(height: ShioriSpace.s4),
            ShioriStatusChip(
              kind: ShioriStatusKind.error,
              icon: Symbols.warning_rounded,
              label: context.l10n.missing_chapters(_gap()),
            ),
          ],
          if (offline != null) ...[
            const SizedBox(height: ShioriSpace.s4),
            ShioriStatusChip(
              kind: offline
                  ? ShioriStatusKind.downloaded
                  : ShioriStatusKind.offline,
              icon: offline
                  ? Symbols.download_done_rounded
                  : Symbols.cloud_off_rounded,
              label: offline
                  ? context.l10n.downloaded
                  : context.l10n.not_downloaded,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEndOfMangaCard(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    final c = tokens.color;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s16,
        vertical: ShioriSpace.s12,
      ),
      decoration: BoxDecoration(
        color: c.ink2,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        border: Border.all(color: c.hairline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: ShioriSpace.s4,
        children: [
          RotatedBox(
            quarterTurns: readerMode.isVertical
                ? 1 // turn 90° clockwise, so Icon is pointing down
                : readerMode.isRTL
                ? 2 // turn 180°, so Icon is pointing left
                : 0, // no rotation, Icon points to the right.
            child: Icon(
              Symbols.last_page_rounded,
              color: c.fgMuted,
              size: tokens.scaled(24),
            ),
          ),
          Text(
            l10n.no_next_chapter,
            style: tokens.text.section.copyWith(color: c.fg),
            textAlign: TextAlign.center,
          ),
          Text(
            l10n.you_have_finished_reading,
            style: tokens.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
