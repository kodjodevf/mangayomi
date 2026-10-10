import 'package:flutter/material.dart';

const double mobilePlayerPortraitControlIconSize = 24;
const double mobilePlayerBottomControlsBottomPadding = 30;

ButtonStyle mobilePlayerEpisodeNavigationButtonStyle() => IconButton.styleFrom(
  backgroundColor: Colors.transparent,
  disabledBackgroundColor: Colors.transparent,
  foregroundColor: Colors.white,
  disabledForegroundColor: Colors.white.withValues(alpha: 0.35),
);

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

    return Row(
      key: const ValueKey('mobile-player-top-controls-portrait'),
      mainAxisSize: MainAxisSize.min,
      children: [
        backButton,
        Expanded(child: title),
        portraitActions,
      ],
    );
  }
}

class MobilePlayerPortraitActionTheme extends StatelessWidget {
  const MobilePlayerPortraitActionTheme({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IconButtonTheme(
      data: IconButtonThemeData(
        style: IconButton.styleFrom(
          iconSize: mobilePlayerPortraitControlIconSize,
          minimumSize: const Size.square(48),
          maximumSize: const Size.square(48),
          padding: EdgeInsets.zero,
        ),
      ),
      child: child,
    );
  }
}

class MobilePlayerControlsOverlayLayout extends StatelessWidget {
  const MobilePlayerControlsOverlayLayout({
    super.key,
    required this.compactPortrait,
    required this.safeInsets,
    required this.topControls,
    required this.primaryControls,
    required this.bottomControls,
  });

  final bool compactPortrait;
  final EdgeInsets safeInsets;
  final Widget topControls;
  final Widget primaryControls;
  final Widget bottomControls;

  @override
  Widget build(BuildContext context) {
    if (compactPortrait) {
      return Stack(
        key: const ValueKey('mobile-player-controls-overlay-portrait'),
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: safeInsets.left,
            right: safeInsets.right,
            child: topControls,
          ),
          Positioned.fill(child: primaryControls),
          Positioned(
            left: safeInsets.left,
            right: safeInsets.right,
            bottom: safeInsets.bottom,
            child: bottomControls,
          ),
        ],
      );
    }

    return Column(
      key: const ValueKey('mobile-player-controls-overlay-wide'),
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: safeInsets.left,
            right: safeInsets.right,
          ),
          child: topControls,
        ),
        Expanded(child: primaryControls),
        Padding(
          padding: EdgeInsets.only(
            left: safeInsets.left,
            right: safeInsets.right,
            bottom: safeInsets.bottom,
          ),
          child: bottomControls,
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

class MobilePlayerCompactSeekControl extends StatelessWidget {
  const MobilePlayerCompactSeekControl({
    super.key,
    required this.tooltip,
    required this.onPressed,
    this.onLongPress,
    this.seconds,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final GestureLongPressCallback? onLongPress;
  final int? seconds;

  @override
  Widget build(BuildContext context) {
    final secondsLabel = seconds?.toString();
    final icon = secondsLabel == null
        ? const Icon(
            Icons.fast_forward_rounded,
            size: mobilePlayerPortraitControlIconSize,
            color: Colors.white,
          )
        : SizedBox.square(
            dimension: mobilePlayerPortraitControlIconSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.rotate_right_outlined,
                  size: mobilePlayerPortraitControlIconSize,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    secondsLabel,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: secondsLabel.length > 2 ? 6 : 7.5,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          );

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        onTap: onPressed,
        onLongPress: onLongPress,
        child: ExcludeSemantics(
          child: Material(
            type: MaterialType.transparency,
            child: InkResponse(
              onTap: onPressed,
              onLongPress: onLongPress,
              radius: 24,
              containedInkWell: true,
              highlightShape: BoxShape.circle,
              child: SizedBox.square(dimension: 48, child: Center(child: icon)),
            ),
          ),
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
              const Spacer(),
              seekButton,
              const SizedBox(width: 8),
              shortcutButtons,
            ],
          ),
        );
      },
    );
  }
}
