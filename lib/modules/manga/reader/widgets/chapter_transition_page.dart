import 'package:flutter/material.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class ChapterTransitionPage extends StatelessWidget {
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

  bool get _isVertical =>
      readerMode == ReaderMode.vertical ||
      readerMode == ReaderMode.verticalContinuous ||
      readerMode == ReaderMode.webtoon;

  bool get _isRTL =>
      readerMode == ReaderMode.rtl ||
      readerMode == ReaderMode.horizontalContinuousRTL;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _isVertical
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
                padding: const EdgeInsets.all(24.0),
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
            padding: const EdgeInsets.all(24.0),
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
            Icons.auto_stories_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.end_of_chapter,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildChapterCard(
            context,
            label: l10n.chapter_completed,
            name: currentChapter.name ?? 'Chapter ${currentChapter.id}',
            isPrimary: false,
          ),
          const SizedBox(height: 16),
          Icon(
            nextChapter != null
                ? Icons.keyboard_arrow_down
                : Icons.check_circle_outline,
            size: 32,
            color: nextChapter != null
                ? Theme.of(context).colorScheme.primary
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          if (nextChapter != null) ...[
            _buildChapterCard(
              context,
              label: l10n.next_chapter,
              name: nextChapter!.name ?? 'Chapter ${nextChapter!.id}',
              isPrimary: true,
            ),
            const SizedBox(height: 20),
            Text(
              l10n.continue_to_next_chapter,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            _buildEndOfMangaCard(context),
            const SizedBox(height: 20),
            Text(
              l10n.return_to_the_list_of_chapters,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
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
    final theme = Theme.of(context);

    // For LTR: [current] → [next]
    // For RTL: [next] ← [current]
    final Widget currentCard = _buildChapterCard(
      context,
      label: l10n.chapter_completed,
      name: currentChapter.name ?? 'Chapter ${currentChapter.id}',
      isPrimary: false,
    );

    final Widget arrowIcon = Icon(
      nextChapter != null
          ? (_isRTL ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right)
          : Icons.check_circle_outline,
      size: 36,
      color: nextChapter != null
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );

    final Widget nextCard = nextChapter != null
        ? _buildChapterCard(
            context,
            label: l10n.next_chapter,
            name: nextChapter!.name ?? 'Chapter ${nextChapter!.id}',
            isPrimary: true,
          )
        : _buildEndOfMangaCard(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.auto_stories_outlined,
          size: 40,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.end_of_chapter,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _isRTL
                    ? [
                        Expanded(child: nextCard),
                        const SizedBox(width: 12),
                        Center(child: arrowIcon),
                        const SizedBox(width: 12),
                        Expanded(child: currentCard),
                      ]
                    : [
                        Expanded(child: currentCard),
                        const SizedBox(width: 12),
                        Center(child: arrowIcon),
                        const SizedBox(width: 12),
                        Expanded(child: nextCard),
                      ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          nextChapter != null
              ? l10n.continue_to_next_chapter
              : l10n.return_to_the_list_of_chapters,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Shared card widgets ────────────────────────────────────────────────────

  Widget _buildChapterCard(
    BuildContext context, {
    required String label,
    required String name,
    required bool isPrimary,
  }) {
    final theme = Theme.of(context);
    final bgColor = isPrimary
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surface;
    final borderColor = isPrimary
        ? theme.colorScheme.primary.withValues(alpha: 0.3)
        : theme.colorScheme.outline.withValues(alpha: 0.2);
    final labelColor = isPrimary
        ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
        : theme.colorScheme.onSurface.withValues(alpha: 0.7);
    final nameColor = isPrimary ? theme.colorScheme.onPrimaryContainer : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(color: labelColor),
            maxLines: 2,
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: nameColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEndOfMangaCard(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RotatedBox(
            quarterTurns: _isVertical
                ? 1 // turn 90° clockwise, so Icon is pointing down
                : _isRTL
                ? 2 // turn 180°, so Icon is pointing left
                : 0, // no rotation, Icon points to the right.
            child: Icon(
              Icons.last_page,
              size: 24,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.no_next_chapter,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.you_have_finished_reading,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
