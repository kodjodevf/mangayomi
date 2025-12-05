import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';

/// Page indicator widget showing current page / total pages.
///
/// Displayed at the bottom center when the UI is hidden and
/// "show page numbers" setting is enabled.
class PageIndicator extends ConsumerWidget {
  /// The current chapter being read.
  final Chapter chapter;

  /// Whether the UI overlay is currently visible.
  final bool isUiVisible;

  /// Total number of pages.
  final int totalPages;

  /// Function to format the current index for display.
  final String Function(int index) formatCurrentIndex;

  const PageIndicator({
    super.key,
    required this.chapter,
    required this.isUiVisible,
    required this.totalPages,
    required this.formatCurrentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider(chapter));
    final showPagesNumber = ref.watch(showPagesNumberStateProvider);

    // Don't show when UI is visible or setting is disabled
    if (isUiVisible || !showPagesNumber) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        '${formatCurrentIndex(currentIndex)} / $totalPages',
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
    );
  }
}
