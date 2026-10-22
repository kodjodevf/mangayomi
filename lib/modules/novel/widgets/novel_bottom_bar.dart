import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/router/push_router.dart';
import 'package:mangayomi/modules/reader_common/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/reader_common/widgets/reader_app_bar.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/modules/novel/utils/novel_paginator.dart';
import 'package:mangayomi/modules/novel/utils/reading_time.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// How far above the bottom edge the novel reader panel's top sits, plus a
/// margin: where the speech bar rests while the panel is shown.
double novelBottomBarHeightAbove(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final bottomInset = max(
    mediaQuery.viewPadding.bottom,
    mediaQuery.systemGestureInsets.bottom,
  );
  // The slider row (38 and its padding), the rule, the actions.
  return bottomInset +
      ShioriSpace.s8 +
      38 +
      ShioriSpace.s8 +
      1 +
      context.shiori.density.rowHeight +
      ShioriSpace.s8;
}

/// Shows the font size slider + preset chips bottom sheet for the novel reader.
void showNovelFontSizeBottomSheet(
  BuildContext context, {
  required ValueChanged<int> onFontSizeChanged,
}) {
  showShioriSheet<void>(
    context,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final currentFontSize = ref.watch(novelFontSizeStateProvider);
        void setSize(int size) {
          ref.read(novelFontSizeStateProvider.notifier).set(size);
          onFontSizeChanged(size);
        }

        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShioriSliderRow(
                icon: Symbols.format_size_rounded,
                title: context.l10n.font_size,
                value: currentFontSize.toDouble().clamp(8, 40),
                min: 8,
                max: 40,
                divisions: 32,
                valueLabel: (v) => '${v.round()} px',
                stepTooltips: (context.l10n.decrease, context.l10n.increase),
                defaultValue: 14,
                onReset: () => setSize(14),
                resetTooltip: context.l10n.reset,
                onChanged: (v) => setSize(v.round()),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  ShioriSpace.s16,
                  0,
                  ShioriSpace.s16,
                  ShioriSpace.s16,
                ),
                child: Wrap(
                  spacing: ShioriSpace.s8,
                  runSpacing: ShioriSpace.s8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final size in [12, 14, 16, 18, 20, 24, 28])
                      ChoiceChip(
                        label: Text('$size'),
                        selected: currentFontSize == size,
                        onSelected: (_) => setSize(size),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// Bottom floating control bar for the novel reader.
class NovelBottomBar extends ConsumerWidget {
  final Chapter chapter;
  final NovelReaderController readerController;
  final bool isVisible;
  final Color Function(BuildContext) backgroundColor;
  final Stream<double> rebuildStream;
  final ReaderMode readerMode;
  final PageMode effectivePageMode;
  final NovelPaginationResult? Function() cachedPagination;
  final int Function() currentSpreadIndex;
  final PageController spreadController;
  final ScrollController scrollController;
  final double Function() offset;
  final double Function() maxOffset;
  final double? Function() chapterMinutes;
  final bool ttsSupported;
  final bool showTts;
  final ValueChanged<int> onFontSizeChanged;
  final void Function(ReaderMode mode, PageMode pageMode) onLayoutModeCycled;
  final VoidCallback onToggleTts;
  final VoidCallback onOpenSettings;

  const NovelBottomBar({
    super.key,
    required this.chapter,
    required this.readerController,
    required this.isVisible,
    required this.backgroundColor,
    required this.rebuildStream,
    required this.readerMode,
    required this.effectivePageMode,
    required this.cachedPagination,
    required this.currentSpreadIndex,
    required this.spreadController,
    required this.scrollController,
    required this.offset,
    required this.maxOffset,
    required this.chapterMinutes,
    required this.ttsSupported,
    required this.showTts,
    required this.onFontSizeChanged,
    required this.onLayoutModeCycled,
    required this.onToggleTts,
    required this.onOpenSettings,
  });

  Widget _chapterButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
  }) {
    final c = context.shiori.color;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      iconSize: context.shiori.scaled(22),
      style: IconButton.styleFrom(
        foregroundColor: c.fg,
        disabledForegroundColor: c.fg.withValues(alpha: Alphas.disabled),
        fixedSize: const Size.square(40),
        minimumSize: const Size.square(40),
      ),
      icon: Icon(icon, fill: 1),
    );
  }

  TextStyle _pageLabelStyle(BuildContext context, {bool muted = false}) =>
      context.shiori.text.meta.copyWith(
        color: muted ? context.shiori.color.fgMuted : context.shiori.color.fg,
        fontWeight: FontWeight.w700,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPrevChapter = readerController.hasPreviousChapter;
    final hasNextChapter = readerController.hasNextChapter;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = max(
      mediaQuery.viewPadding.bottom,
      mediaQuery.systemGestureInsets.bottom,
    );
    final duration = ShioriMotion.of(context, ShioriMotion.enter);
    final curve = isVisible ? ShioriMotion.enterCurve : ShioriMotion.exitCurve;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ReaderChromeGate(
        shown: isVisible,
        child: AnimatedSlide(
          offset: isVisible ? Offset.zero : const Offset(0, 1),
          duration: duration,
          curve: curve,
          child: AnimatedOpacity(
            opacity: isVisible ? 1 : 0,
            duration: duration,
            curve: curve,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                ShioriSpace.s8,
                0,
                ShioriSpace.s8,
                bottomInset + ShioriSpace.s8,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Material(
                    color: backgroundColor(context),
                    borderRadius: BorderRadius.circular(ShioriShape.sheet),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ShioriSpace.s4,
                            vertical: ShioriSpace.s4,
                          ),
                          child: Row(
                            children: [
                              _chapterButton(
                                context,
                                icon: Symbols.skip_previous_rounded,
                                tooltip: context.l10n.previous_chapter,
                                onPressed: hasPrevChapter
                                    ? () {
                                        pushReplacementMangaReaderView(
                                          context: context,
                                          chapter: readerController
                                              .getPrevChapter(),
                                        );
                                      }
                                    : null,
                              ),
                              const SizedBox(width: ShioriSpace.s8),
                              Expanded(
                                child: SizedBox(
                                  height: 38,
                                  child: StreamBuilder<double>(
                                    stream: rebuildStream,
                                    builder: (context, asyncSnapshot) {
                                      return Consumer(
                                        builder: (context, ref, child) {
                                          if (!readerMode.isContinuous) {
                                            final pagination =
                                                cachedPagination();
                                            final isDouble =
                                                effectivePageMode ==
                                                PageMode.doublePage;
                                            final totalItems = isDouble
                                                ? (pagination?.spreadCount ?? 1)
                                                : (pagination?.pageCount ?? 1);
                                            final currentIndex =
                                                currentSpreadIndex()
                                                    .clamp(
                                                      0,
                                                      max(0, totalItems - 1),
                                                    )
                                                    .toInt();
                                            final currentLabel = isDouble
                                                ? (pagination
                                                          ?.spreadLabelForSpread(
                                                            currentIndex,
                                                          ) ??
                                                      '${currentIndex + 1}')
                                                : '${currentIndex + 1}';
                                            final totalLabel =
                                                '${pagination?.pageCount ?? totalItems}';
                                            final sliderValue = totalItems > 1
                                                ? (currentIndex /
                                                          (totalItems - 1))
                                                      .clamp(0.0, 1.0)
                                                : 0.0;

                                            return Row(
                                              children: [
                                                const SizedBox(
                                                  width: ShioriSpace.s12,
                                                ),
                                                Text(
                                                  currentLabel,
                                                  style: _pageLabelStyle(
                                                    context,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SliderTheme(
                                                    data: SliderTheme.of(context).copyWith(
                                                      trackHeight: 2.5,
                                                      thumbShape:
                                                          const RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                6.0,
                                                          ),
                                                      overlayShape:
                                                          const RoundSliderOverlayShape(
                                                            overlayRadius: 12.0,
                                                          ),
                                                    ),
                                                    child: Slider(
                                                      onChanged: (value) {
                                                        if (totalItems > 1 &&
                                                            spreadController
                                                                .hasClients) {
                                                          final targetIndex =
                                                              (value *
                                                                      (totalItems -
                                                                          1))
                                                                  .round();
                                                          spreadController
                                                              .jumpToPage(
                                                                targetIndex,
                                                              );
                                                        }
                                                      },
                                                      value: sliderValue,
                                                      min: 0,
                                                      max: 1,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  totalLabel,
                                                  style: _pageLabelStyle(
                                                    context,
                                                    muted: true,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: ShioriSpace.s12,
                                                ),
                                              ],
                                            );
                                          }

                                          final curMax = maxOffset();
                                          final scrollPercentage = curMax > 0
                                              ? ((offset() / curMax) * 100)
                                                    .clamp(0, 100)
                                                    .toInt()
                                              : 0;
                                          final chapMins = chapterMinutes();
                                          return Row(
                                            children: [
                                              const SizedBox(
                                                width: ShioriSpace.s12,
                                              ),
                                              Text(
                                                '$scrollPercentage%',
                                                style: _pageLabelStyle(context),
                                              ),
                                              Expanded(
                                                child: SliderTheme(
                                                  data: SliderTheme.of(context).copyWith(
                                                    trackHeight: 2.5,
                                                    thumbShape:
                                                        const RoundSliderThumbShape(
                                                          enabledThumbRadius:
                                                              6.0,
                                                        ),
                                                    overlayShape:
                                                        const RoundSliderOverlayShape(
                                                          overlayRadius: 12.0,
                                                        ),
                                                  ),
                                                  child: Slider(
                                                    onChanged: (value) {
                                                      if (scrollController
                                                          .hasClients) {
                                                        scrollController.jumpTo(
                                                          scrollController
                                                                  .position
                                                                  .maxScrollExtent *
                                                              value,
                                                        );
                                                      }
                                                    },
                                                    value:
                                                        (scrollPercentage / 100)
                                                            .clamp(0.0, 1.0),
                                                    min: 0,
                                                    max: 1,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                chapMins == null
                                                    ? '100%'
                                                    : context.l10n.minutes_left(
                                                        minutesLeft(
                                                          chapMins,
                                                          scrollPercentage /
                                                              100,
                                                        ),
                                                      ),
                                                style: _pageLabelStyle(
                                                  context,
                                                  muted: true,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: ShioriSpace.s12,
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: ShioriSpace.s8),
                              _chapterButton(
                                context,
                                icon: Symbols.skip_next_rounded,
                                tooltip: context.l10n.next_chapter,
                                onPressed: hasNextChapter
                                    ? () {
                                        pushReplacementMangaReaderView(
                                          context: context,
                                          chapter: readerController
                                              .getNextChapter(),
                                        );
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Container(
                          height: context.shiori.density.rowHeight,
                          padding: const EdgeInsets.symmetric(
                            horizontal: ShioriSpace.s12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: context.shiori.density.minTarget,
                                  minHeight: context.shiori.density.minTarget,
                                ),
                                onPressed: () => showChapterListPanel(
                                  context,
                                  title: context.l10n.chapters,
                                  chapter: chapter,
                                ),
                                icon: const Icon(
                                  Symbols.format_list_numbered_rounded,
                                  size: 22,
                                ),
                                tooltip: context.l10n.chapters,
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: context.shiori.density.minTarget,
                                  minHeight: context.shiori.density.minTarget,
                                ),
                                onPressed: () => showNovelFontSizeBottomSheet(
                                  context,
                                  onFontSizeChanged: onFontSizeChanged,
                                ),
                                icon: const Icon(
                                  Symbols.format_size_rounded,
                                  size: 22,
                                ),
                                tooltip: context.l10n.font_size,
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: context.shiori.density.minTarget,
                                  minHeight: context.shiori.density.minTarget,
                                ),
                                onPressed: () {
                                  if (readerMode.isContinuous) {
                                    readerController.setReaderMode(
                                      ReaderMode.ltr,
                                    );
                                    readerController.setPageMode(
                                      PageMode.onePage,
                                    );
                                    ref
                                        .read(
                                          doublePageAutoStateProvider.notifier,
                                        )
                                        .set(false);
                                    onLayoutModeCycled(
                                      ReaderMode.ltr,
                                      PageMode.onePage,
                                    );
                                  } else if (effectivePageMode ==
                                      PageMode.onePage) {
                                    readerController.setPageMode(
                                      PageMode.doublePage,
                                    );
                                    ref
                                        .read(
                                          doublePageAutoStateProvider.notifier,
                                        )
                                        .set(false);
                                    onLayoutModeCycled(
                                      readerMode,
                                      PageMode.doublePage,
                                    );
                                  } else {
                                    readerController.setReaderMode(
                                      ReaderMode.verticalContinuous,
                                    );
                                    onLayoutModeCycled(
                                      ReaderMode.verticalContinuous,
                                      effectivePageMode,
                                    );
                                  }
                                },
                                icon: Icon(
                                  readerMode.isContinuous
                                      ? Symbols.swap_vert_rounded
                                      : (effectivePageMode ==
                                                PageMode.doublePage
                                            ? Symbols.auto_stories_rounded
                                            : Symbols.article_rounded),
                                  size: 22,
                                  color: !readerMode.isContinuous
                                      ? context.shiori.color.accentInk
                                      : null,
                                ),
                                tooltip: readerMode.isContinuous
                                    ? context
                                          .l10n
                                          .reading_mode_vertical_continuous
                                    : (effectivePageMode == PageMode.doublePage
                                          ? context.l10n.double_page
                                          : context.l10n.single_page),
                              ),
                              if (ttsSupported)
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(
                                    minWidth: context.shiori.density.minTarget,
                                    minHeight: context.shiori.density.minTarget,
                                  ),
                                  onPressed: onToggleTts,
                                  icon: Icon(
                                    Symbols.record_voice_over_rounded,
                                    fill: showTts ? 1 : 0,
                                    size: 22,
                                    color: showTts
                                        ? context.shiori.color.accentInk
                                        : null,
                                  ),
                                  tooltip: context.l10n.tts,
                                ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: context.shiori.density.minTarget,
                                  minHeight: context.shiori.density.minTarget,
                                ),
                                onPressed: onOpenSettings,
                                icon: const Icon(Symbols.tune_rounded),
                                tooltip: context.l10n.settings,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
