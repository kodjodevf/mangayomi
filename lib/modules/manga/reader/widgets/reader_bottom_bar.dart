import 'package:flutter/foundation.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/reader_common/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/manga/reader/widgets/custom_value_indicator_shape.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_mode_glyph.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_mode_picker.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/reader_common/widgets/reader_app_bar.dart';

/// The manga reader's bottom panel: one floating card, within reach of a
/// thumb, with the page slider between the previous and next chapters, and
/// under it what is changed while reading (the chapter list, the reading
/// mode, cropping, double pages, every setting).
///
/// It was a pill for the slider over a full-width band of buttons, two
/// shapes for one control, and it grew from nothing when shown. It slides
/// up from the bottom edge and back down, and keeps a reading width on a
/// wide screen.
class ReaderBottomBar extends ConsumerWidget {
  /// The chapter being read
  final Chapter chapter;

  /// Whether the bar is visible
  final bool isVisible;

  /// Whether there is a previous chapter
  final bool hasPreviousChapter;

  /// Whether there is a next chapter
  final bool hasNextChapter;

  /// Callback when previous chapter button is pressed
  final VoidCallback? onPreviousChapter;

  /// Callback when next chapter button is pressed
  final VoidCallback? onNextChapter;

  /// Callback when slider value changes (for updating provider)
  final void Function(int value, WidgetRef ref) onSliderChanged;

  /// Callback when slider drag ends (for navigation)
  final void Function(int value) onSliderChangeEnd;

  /// Callback when reader mode is changed
  final void Function(ReaderMode mode, WidgetRef ref) onReaderModeChanged;

  /// Callback when page mode toggle button is pressed
  final VoidCallback? onPageModeToggle;

  /// Callback when settings button is pressed
  final VoidCallback onSettingsPressed;

  /// Provider for watching current reader mode
  /// Accepts any ProviderListenable that returns ReaderMode?
  /// (StateProvider, NotifierProvider, etc.)
  final ProviderListenable<ReaderMode?> currentReaderModeProvider;

  /// Session-local current page index for the visible reader state.
  final ValueListenable<int> currentPageListenable;

  /// Current page mode (nullable for safety)
  final PageMode? currentPageMode;

  /// Whether RTL reading direction is active
  final bool isReverseHorizontal;

  /// Total number of pages in current chapter
  final int totalPages;

  /// Function to get current page index label
  final String Function(int currentIndex) currentIndexLabel;

  /// Background color getter
  final Color Function(BuildContext) backgroundColor;

  /// Whether auto-scroll is on, for the button's state; with
  /// [onAutoScrollPressed], the button shows in the vertical continuous
  /// modes, the ones auto-scroll runs in.
  final ValueListenable<bool>? autoScrollEnabled;

  /// Opens auto-scroll's switch and speed.
  final VoidCallback? onAutoScrollPressed;

  const ReaderBottomBar({
    super.key,
    required this.chapter,
    required this.isVisible,
    required this.hasPreviousChapter,
    required this.hasNextChapter,
    this.onPreviousChapter,
    this.onNextChapter,
    required this.onSliderChanged,
    required this.onSliderChangeEnd,
    required this.onReaderModeChanged,
    this.onPageModeToggle,
    required this.onSettingsPressed,
    required this.currentReaderModeProvider,
    required this.currentPageListenable,
    required this.currentPageMode,
    required this.isReverseHorizontal,
    required this.totalPages,
    required this.currentIndexLabel,
    required this.backgroundColor,
    this.autoScrollEnabled,
    this.onAutoScrollPressed,
  });

  bool get _isDoublePageMode => currentPageMode == PageMode.doublePage;

  /// How far above the bottom edge the panel's top sits, plus a margin:
  /// where something shown over the panel (the page preview) starts.
  static double heightAbove(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = max(
      mediaQuery.viewPadding.bottom,
      mediaQuery.systemGestureInsets.bottom,
    );
    final row = context.shiori.density.rowHeight;
    return bottomInset + ShioriSpace.s8 + row * 2 + 1 + ShioriSpace.s8;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readerMode = ref.watch(currentReaderModeProvider);
    if (readerMode == null) return const SizedBox.shrink();
    final isHorizontalContinuous = readerMode.isHorizontalContinuous;
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
                        _buildPageSlider(context, ref, isHorizontalContinuous),
                        const Divider(height: 1),
                        _buildQuickActions(
                          context,
                          ref,
                          readerMode,
                          isHorizontalContinuous,
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

  /// The previous chapter, the page slider between the current page and the
  /// count, and the next chapter. Mirrored when reading right to left, the
  /// figures put back the right way round.
  Widget _buildPageSlider(
    BuildContext context,
    WidgetRef ref,
    bool isHorizontalContinuous,
  ) {
    Widget unmirrored(Widget child) =>
        Transform.scale(scaleX: !isReverseHorizontal ? 1 : -1, child: child);
    return Transform.scale(
      scaleX: !isReverseHorizontal ? 1 : -1,
      child: SizedBox(
        height: context.shiori.density.rowHeight,
        child: Row(
          children: [
            IconButton(
              tooltip: context.l10n.previous_chapter,
              onPressed: hasPreviousChapter ? onPreviousChapter : null,
              icon: const Icon(Symbols.skip_previous_rounded, fill: 1),
            ),
            unmirrored(
              SizedBox(
                width: 44,
                child: Center(
                  child: ValueListenableBuilder<int>(
                    valueListenable: currentPageListenable,
                    builder: (context, currentIndex, child) => Text(
                      currentIndexLabel(currentIndex),
                      style: _pageLabelStyle(context),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: isVisible && totalPages > 0
                  ? _buildSlider(context, ref, isHorizontalContinuous)
                  : const SizedBox.shrink(),
            ),
            unmirrored(
              SizedBox(
                width: 44,
                child: Center(
                  child: Text(
                    "$totalPages",
                    style: _pageLabelStyle(context)
                        .copyWith(color: context.shiori.color.fgMuted),
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: context.l10n.next_chapter,
              onPressed: hasNextChapter ? onNextChapter : null,
              icon: const Icon(Symbols.skip_next_rounded, fill: 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context,
    WidgetRef ref,
    bool isHorizontalContinuous,
  ) {
    return Consumer(
      builder: (context, ref, child) {
        return ValueListenableBuilder<int>(
          valueListenable: currentPageListenable,
          builder: (context, currentIndex, child) {
            final maxValue = (totalPages - 1).toDouble();

            final divisions = totalPages <= 1 ? null : totalPages - 1;

            final currentValue = min(currentIndex.toDouble(), maxValue);

            return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                valueIndicatorShape: CustomValueIndicatorShape(
                  tranform: isReverseHorizontal,
                ),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 5.0),
              ),
              child: Slider(
                onChanged: (value) {
                  onSliderChanged(value.toInt(), ref);
                },
                onChangeEnd: (newValue) {
                  onSliderChangeEnd(newValue.toInt());
                },
                divisions: divisions,
                value: currentValue,
                label: currentIndexLabel(currentIndex),
                min: 0,
                max: maxValue,
              ),
            );
          },
        );
      },
    );
  }

  /// Tabular, so the slider does not shift as the count changes width.
  TextStyle _pageLabelStyle(BuildContext context) => context.shiori.text.meta
      .copyWith(color: context.shiori.color.fg, fontWeight: FontWeight.w700);

  /// The reading mode picker in a sheet; a tile picks and closes it.
  Future<void> _pickReaderMode(BuildContext context) {
    return showShioriSheet<void>(
      context,
      builder: (sheetContext) => Consumer(
        builder: (sheetContext, ref, _) {
          final mode = ref.watch(currentReaderModeProvider);
          if (mode == null) return const SizedBox.shrink();
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(
                top: ShioriSpace.s8,
                bottom: ShioriSpace.s16,
              ),
              child: ReaderModePicker(
                mode: mode,
                defaultMode: ref.watch(defaultReadingModeStateProvider),
                seriesName: chapter.manga.value?.name ?? '',
                onChanged: (value) {
                  onReaderModeChanged(value, ref);
                  Navigator.pop(sheetContext);
                },
                onSetDefault: () => ref
                    .read(defaultReadingModeStateProvider.notifier)
                    .set(mode),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    WidgetRef ref,
    ReaderMode? readerMode,
    bool isHorizontalContinuous,
  ) {
    final l10n = context.l10n;
    final accent = context.shiori.color.accentInk;
    return SizedBox(
      height: context.shiori.density.rowHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // The chapter list, down here within reach rather than in the
          // top bar.
          IconButton(
            tooltip: l10n.chapters,
            onPressed: () => showChapterListPanel(
              context,
              title: l10n.chapters,
              chapter: chapter,
            ),
            icon: const Icon(Symbols.format_list_numbered_rounded),
          ),

          // The reading mode, shown by its direction, opening the same
          // picker as the settings sheet: tiles, the series' own mode and
          // the default.
          IconButton(
            tooltip: readerMode == null
                ? l10n.reading_mode
                : '${l10n.reading_mode} · ${getReaderModeName(readerMode, context)}',
            onPressed: () => _pickReaderMode(context),
            icon: readerMode == null
                ? const Icon(Symbols.chrome_reader_mode_rounded)
                : ReaderModeGlyph(readerMode),
          ),

          // Crop borders button: filled in the accent while it is on.
          Consumer(
            builder: (context, ref, child) {
              final cropBorders = ref.watch(cropBordersStateProvider);
              return IconButton(
                tooltip: l10n.crop_borders,
                isSelected: cropBorders,
                onPressed: () {
                  ref.read(cropBordersStateProvider.notifier).set(!cropBorders);
                },
                icon: const Icon(Symbols.crop_rounded),
                selectedIcon: Icon(
                  Symbols.crop_rounded,
                  fill: 1,
                  color: accent,
                ),
              );
            },
          ),

          // Double page mode button
          IconButton(
            tooltip: l10n.double_page,
            isSelected: _isDoublePageMode,
            onPressed: !isHorizontalContinuous ? onPageModeToggle : null,
            icon: const Icon(Symbols.book_rounded),
            selectedIcon: Icon(
              Symbols.menu_book_rounded,
              fill: 1,
              color: accent,
            ),
          ),

          // Auto-scroll, where it runs: lit while it is on.
          if ((readerMode?.isVerticalContinuous ?? false) &&
              onAutoScrollPressed != null)
            ValueListenableBuilder<bool>(
              valueListenable: autoScrollEnabled ?? ValueNotifier(false),
              builder: (context, enabled, _) => IconButton(
                tooltip: l10n.auto_scroll,
                isSelected: enabled,
                onPressed: onAutoScrollPressed,
                icon: const Icon(Symbols.timer_rounded),
                selectedIcon: Icon(
                  Symbols.timer_rounded,
                  fill: 1,
                  color: accent,
                ),
              ),
            ),

          // Settings button
          IconButton(
            tooltip: l10n.settings,
            onPressed: onSettingsPressed,
            icon: const Icon(Symbols.settings_rounded),
          ),
        ],
      ),
    );
  }
}
