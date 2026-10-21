import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:shiori/shiori.dart';

/// Page indicator widget showing current page / total pages.
///
/// Displayed at the bottom center when the UI is hidden and
/// "show page numbers" setting is enabled.
class PageIndicator extends ConsumerWidget {
  /// Whether the UI overlay is currently visible.
  final bool isUiVisible;

  /// Session-local current page index for the visible reader state.
  final ValueListenable<int> currentPageListenable;

  /// Total number of pages.
  final int totalPages;

  /// Function to format the current index for display.
  final String Function(int index) formatCurrentIndex;

  const PageIndicator({
    super.key,
    required this.isUiVisible,
    required this.currentPageListenable,
    required this.totalPages,
    required this.formatCurrentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPagesNumber = ref.watch(showPagesNumberStateProvider);

    // Don't show when UI is visible or setting is disabled
    if (isUiVisible || !showPagesNumber) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: ValueListenableBuilder<int>(
        valueListenable: currentPageListenable,
        builder: (context, currentIndex, child) {
          return Padding(
            padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
            child: ShioriOverlayLabel(
              '${formatCurrentIndex(currentIndex)} / $totalPages',
            ),
          );
        },
      ),
    );
  }
}
