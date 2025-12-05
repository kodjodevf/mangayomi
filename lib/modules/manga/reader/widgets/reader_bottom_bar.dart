import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/custom_value_indicator_shape.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';

/// The bottom bar for the manga reader.
///
/// This is a complete drop-in replacement for the _bottomBar() method in reader_view.dart.
/// It handles all the complex interactions including:
/// - Page slider with real-time updates via Consumer
/// - Chapter navigation
/// - Reader mode selection
/// - Crop borders toggle
/// - Double page mode toggle
/// - Settings access
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

  /// Provider family for watching current page index
  /// Type: CurrentIndexFamily (from reader_controller_provider.g.dart)
  final CurrentIndexFamily currentIndexProvider;

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
    required this.currentIndexProvider,
    required this.currentPageMode,
    required this.isReverseHorizontal,
    required this.totalPages,
    required this.currentIndexLabel,
    required this.backgroundColor,
  });

  bool get _isDoublePageMode => currentPageMode == PageMode.doublePage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readerMode = ref.watch(currentReaderModeProvider);
    final isHorizontalContinuous =
        readerMode == ReaderMode.horizontalContinuous;

    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
        curve: Curves.ease,
        duration: const Duration(milliseconds: 300),
        width: context.width(1),
        height: isVisible ? 130 : 0,
        child: Column(
          children: [
            // Page slider section
            Flexible(
              child: _buildPageSlider(context, ref, isHorizontalContinuous),
            ),

            // Quick actions section
            Flexible(
              child: _buildQuickActions(
                context,
                ref,
                readerMode,
                isHorizontalContinuous,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageSlider(
    BuildContext context,
    WidgetRef ref,
    bool isHorizontalContinuous,
  ) {
    return Transform.scale(
      scaleX: !isReverseHorizontal ? 1 : -1,
      child: Row(
        children: [
          // Previous chapter button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 23,
              backgroundColor: backgroundColor(context),
              child: IconButton(
                onPressed: hasPreviousChapter ? onPreviousChapter : null,
                icon: Transform.scale(
                  scaleX: 1,
                  child: Icon(
                    Icons.skip_previous_rounded,
                    color: hasPreviousChapter
                        ? Theme.of(context).textTheme.bodyLarge!.color
                        : Theme.of(
                            context,
                          ).textTheme.bodyLarge!.color!.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),

          // Slider container
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: backgroundColor(context),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Current page label
                    Transform.scale(
                      scaleX: !isReverseHorizontal ? 1 : -1,
                      child: SizedBox(
                        width: 55,
                        child: Center(
                          child: Consumer(
                            builder: (context, ref, child) {
                              final currentIndex = ref.watch(
                                currentIndexProvider(chapter),
                              );
                              return Text(
                                currentIndexLabel(currentIndex),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Slider
                    if (isVisible)
                      Flexible(
                        flex: 14,
                        child: _buildSlider(
                          context,
                          ref,
                          isHorizontalContinuous,
                        ),
                      ),

                    // Total pages label
                    Transform.scale(
                      scaleX: !isReverseHorizontal ? 1 : -1,
                      child: SizedBox(
                        width: 55,
                        child: Center(
                          child: Text(
                            "$totalPages",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Next chapter button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 23,
              backgroundColor: backgroundColor(context),
              child: IconButton(
                onPressed: hasNextChapter ? onNextChapter : null,
                icon: Transform.scale(
                  scaleX: 1,
                  child: Icon(
                    Icons.skip_next_rounded,
                    color: hasNextChapter
                        ? Theme.of(context).textTheme.bodyLarge!.color
                        : Theme.of(
                            context,
                          ).textTheme.bodyLarge!.color!.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
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
        final currentIndex = ref.watch(currentIndexProvider(chapter));

        final maxValue = (_isDoublePageMode && !isHorizontalContinuous)
            ? ((totalPages / 2).ceil() + 1).toDouble()
            : (totalPages - 1).toDouble();

        final divisions = totalPages == 1
            ? null
            : _isDoublePageMode
            ? (totalPages / 2).ceil() + 1
            : totalPages - 1;

        final currentValue = min(
          currentIndex.toDouble(),
          (_isDoublePageMode && !isHorizontalContinuous)
              ? ((totalPages / 2).ceil() + 1).toDouble()
              : totalPages.toDouble(),
        );

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
  }

  Widget _buildQuickActions(
    BuildContext context,
    WidgetRef ref,
    ReaderMode? readerMode,
    bool isHorizontalContinuous,
  ) {
    return Container(
      height: 65,
      color: backgroundColor(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Reader mode button
          PopupMenuButton<ReaderMode>(
            popUpAnimationStyle: popupAnimationStyle,
            color: Colors.black,
            onSelected: (value) {
              onReaderModeChanged(value, ref);
            },
            itemBuilder: (context) => [
              for (var mode in ReaderMode.values)
                PopupMenuItem(
                  value: mode,
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: readerMode == mode
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        getReaderModeName(mode, context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            child: const Icon(Icons.app_settings_alt_outlined),
          ),

          // Crop borders button
          Consumer(
            builder: (context, ref, child) {
              final cropBorders = ref.watch(cropBordersStateProvider);
              return IconButton(
                onPressed: () {
                  ref.read(cropBordersStateProvider.notifier).set(!cropBorders);
                },
                icon: Stack(
                  children: [
                    const Icon(Icons.crop_rounded),
                    if (!cropBorders)
                      Positioned(
                        right: 8,
                        child: Transform.scale(
                          scaleX: 2.5,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('\\', style: TextStyle(fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          // Double page mode button
          IconButton(
            onPressed: !isHorizontalContinuous ? onPageModeToggle : null,
            icon: Icon(
              _isDoublePageMode
                  ? CupertinoIcons.book_solid
                  : CupertinoIcons.book,
            ),
          ),

          // Settings button
          IconButton(
            onPressed: onSettingsPressed,
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
    );
  }
}

/// Widget to display the current page number when UI is hidden.
class PageNumberOverlay extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final bool isVisible;
  final bool showPageNumbers;
  final PageMode pageMode;

  const PageNumberOverlay({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.isVisible,
    required this.showPageNumbers,
    required this.pageMode,
  });

  @override
  Widget build(BuildContext context) {
    if (isVisible || !showPageNumbers) {
      return const SizedBox.shrink();
    }

    final label = pageMode == PageMode.doublePage && currentIndex > 0
        ? _getDoublePageLabel()
        : '${currentIndex + 1}';

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          '$label / $totalPages',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            shadows: [
              Shadow(offset: Offset(-1, -1), blurRadius: 1),
              Shadow(offset: Offset(1, -1), blurRadius: 1),
              Shadow(offset: Offset(1, 1), blurRadius: 1),
              Shadow(offset: Offset(-1, 1), blurRadius: 1),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _getDoublePageLabel() {
    final index1 = currentIndex * 2;
    final index2 = index1 + 1;

    if (index1 >= totalPages) {
      return '$totalPages';
    }

    return index2 >= totalPages ? '$totalPages' : '$index1-$index2';
  }
}
