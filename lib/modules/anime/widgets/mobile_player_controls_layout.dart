import 'package:flutter/material.dart';

bool usesCompactPortraitPlayerControls({
  required Orientation orientation,
  required double width,
}) =>
    orientation == Orientation.portrait &&
    width < MobilePlayerBottomControlsLayout.compactPortraitBreakpoint;

class MobilePlayerTopSafeArea extends StatelessWidget {
  const MobilePlayerTopSafeArea({
    super.key,
    required this.isDesktop,
    required this.child,
  });

  final bool isDesktop;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('mobile-player-top-safe-area'),
      padding: EdgeInsets.only(
        top: isDesktop ? 0 : MediaQuery.viewPaddingOf(context).top,
      ),
      child: child,
    );
  }
}

class MobilePlayerUnlockControl extends StatelessWidget {
  const MobilePlayerUnlockControl({
    super.key,
    required this.tooltip,
    required this.onPressed,
  });

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton.filledTonal(
          key: const ValueKey('mobile-player-unlock-button'),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black.withValues(alpha: 0.55),
            foregroundColor: Colors.white,
          ),
          tooltip: tooltip,
          onPressed: onPressed,
          icon: const Icon(Icons.lock_outline, size: 24),
        ),
      ),
    );
  }
}

class MobilePlayerBottomControlsLayout extends StatelessWidget {
  const MobilePlayerBottomControlsLayout({
    super.key,
    required this.lockButton,
    required this.seekButton,
    required this.chapterButton,
    required this.shortcutButtons,
  });

  static const double compactPortraitBreakpoint = 600;

  final Widget lockButton;
  final Widget seekButton;
  final Widget chapterButton;
  final Widget shortcutButtons;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compactPortrait = usesCompactPortraitPlayerControls(
          orientation: MediaQuery.orientationOf(context),
          width: constraints.maxWidth,
        );

        if (!compactPortrait) {
          return Padding(
            key: const ValueKey('mobile-player-bottom-controls-wide'),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              key: const ValueKey('mobile-player-bottom-controls-wide-row'),
              children: [
                lockButton,
                seekButton,
                chapterButton,
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: shortcutButtons,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          key: const ValueKey('mobile-player-bottom-controls-compact'),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                key: const ValueKey('mobile-player-primary-controls'),
                children: [
                  lockButton,
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [seekButton, chapterButton],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SingleChildScrollView(
                key: const ValueKey('mobile-player-shortcuts-scroll'),
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth - 24,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: shortcutButtons,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
