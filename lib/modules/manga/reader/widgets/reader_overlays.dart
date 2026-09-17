import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/widgets/navigation_overlay.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_gesture_handler.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_interactive_region.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';

/// The reader's interaction layer above the page content: the tap-zone
/// gesture handler, the page-turn flash effect, and (while open) the
/// navigation-layout picker overlay. Purely presentational - all of it reads
/// live settings itself via [ref] and reports taps back through callbacks;
/// the caller still owns the flash/overlay-visibility state.
class ReaderOverlays extends ConsumerWidget {
  final bool isReverseHorizontal;
  final bool hasCurrentPageImageError;
  final bool isContinuousMode;
  final VoidCallback onToggleUI;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;

  final bool isFlashing;
  final Color flashOverlayColor;

  final bool showNavigationOverlay;
  final VoidCallback onCloseNavigationOverlay;

  const ReaderOverlays({
    super.key,
    required this.isReverseHorizontal,
    required this.hasCurrentPageImageError,
    required this.isContinuousMode,
    required this.onToggleUI,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.isFlashing,
    required this.flashOverlayColor,
    required this.showNavigationOverlay,
    required this.onCloseNavigationOverlay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final usePageTapZones = ref.watch(usePageTapZonesStateProvider);
            final navigationLayout = ref.watch(
              readerNavigationLayoutStateProvider,
            );
            final tappingInversion = ref.watch(tappingInversionStateProvider);
            return ReaderInteractiveHitTestBlocker(
              child: ReaderGestureHandler(
                usePageTapZones: usePageTapZones,
                navigationLayout: navigationLayout,
                tappingInversion: tappingInversion,
                isRTL: isReverseHorizontal,
                hasImageError: hasCurrentPageImageError,
                isContinuousMode: isContinuousMode,
                onToggleUI: onToggleUI,
                onPreviousPage: onPreviousPage,
                onNextPage: onNextPage,
              ),
            );
          },
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: isFlashing ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              child: Container(color: flashOverlayColor),
            ),
          ),
        ),
        if (showNavigationOverlay)
          Positioned.fill(
            child: ReaderNavigationOverlay(
              navigationLayout: ref.watch(readerNavigationLayoutStateProvider),
              tappingInversion: ref.watch(tappingInversionStateProvider),
              isRTL: isReverseHorizontal,
              onClose: onCloseNavigationOverlay,
            ),
          ),
      ],
    );
  }
}
