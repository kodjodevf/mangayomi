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

class MobilePlayerTopControlsLayout extends StatelessWidget {
  const MobilePlayerTopControlsLayout({
    super.key,
    required this.compactPortrait,
    required this.backButton,
    required this.title,
    required this.wideActions,
    required this.portraitActions,
  });

  final bool compactPortrait;
  final Widget backButton;
  final Widget title;
  final Widget wideActions;
  final Widget portraitActions;

  @override
  Widget build(BuildContext context) {
    if (!compactPortrait) {
      return Row(
        key: const ValueKey('mobile-player-top-controls-wide'),
        children: [
          backButton,
          Expanded(child: title),
          wideActions,
        ],
      );
    }

    return Column(
      key: const ValueKey('mobile-player-top-controls-portrait'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          key: const ValueKey('mobile-player-portrait-actions-row'),
          children: [
            backButton,
            Expanded(
              child: LayoutBuilder(
                builder: (context, actionConstraints) => SingleChildScrollView(
                  key: const ValueKey('mobile-player-portrait-actions-scroll'),
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: actionConstraints.maxWidth,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: portraitActions,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: title,
        ),
      ],
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
    required this.compactPortrait,
    required this.lockButton,
    required this.seekButton,
    required this.chapterButton,
    required this.shortcutButtons,
  });

  static const double compactPortraitBreakpoint = 600;

  final bool compactPortrait;
  final Widget lockButton;
  final Widget seekButton;
  final Widget chapterButton;
  final Widget shortcutButtons;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, _) {
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
          child: Row(
            key: const ValueKey('mobile-player-compact-controls-row'),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              lockButton,
              const SizedBox(width: 8),
              seekButton,
              const Spacer(),
              shortcutButtons,
            ],
          ),
        );
      },
    );
  }
}
