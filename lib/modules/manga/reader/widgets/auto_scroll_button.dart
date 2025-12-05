import 'package:flutter/material.dart';

/// Auto-scroll play/pause button for continuous reading modes.
///
/// Shows a play/pause button at the bottom-right corner when auto-scroll is enabled.
/// Only visible in vertical/horizontal continuous modes.
class ReaderAutoScrollButton extends StatelessWidget {
  /// Whether the current mode supports auto-scroll (continuous modes).
  final bool isContinuousMode;

  /// Whether the UI is currently visible (hide button when UI is hidden).
  final bool isUiVisible;

  /// ValueNotifier for auto-scroll page setting (user preference).
  final ValueNotifier<bool> autoScrollPage;

  /// ValueNotifier for auto-scroll running state.
  final ValueNotifier<bool> autoScroll;

  /// Callback when play/pause is toggled.
  final VoidCallback onToggle;

  const ReaderAutoScrollButton({
    super.key,
    required this.isContinuousMode,
    required this.isUiVisible,
    required this.autoScrollPage,
    required this.autoScroll,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (!isContinuousMode) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      right: 0,
      child: isUiVisible
          ? const SizedBox.shrink()
          : ValueListenableBuilder(
              valueListenable: autoScrollPage,
              builder: (context, isEnabled, child) => isEnabled
                  ? ValueListenableBuilder(
                      valueListenable: autoScroll,
                      builder: (context, isPlaying, child) => IconButton(
                        onPressed: onToggle,
                        icon: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
    );
  }
}
