import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

const double mobilePlayerPortraitControlIconSize = 24;
const double mobilePlayerBottomControlsBottomPadding = 30;

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
      minimum: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s16,
        vertical: ShioriSpace.s24,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        // Everything else is hidden while locked: the one pill says what it
        // does, so a tap that found the screen unresponsive finds the way out.
        child: KeyedSubtree(
          key: const ValueKey('mobile-player-unlock-button'),
          child: ShioriOverlayPill(
            icon: Symbols.lock_rounded,
            label: tooltip,
            onTap: onPressed,
          ),
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
            Symbols.fast_forward_rounded,
            fill: 1,
            size: mobilePlayerPortraitControlIconSize,
            color: Colors.white,
          )
        : SizedBox.square(
            dimension: mobilePlayerPortraitControlIconSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Symbols.rotate_right_rounded,
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
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s8),
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
          padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s12),
          child: Row(
            key: const ValueKey('mobile-player-compact-controls-row'),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              lockButton,
              const Spacer(),
              seekButton,
              const SizedBox(width: ShioriSpace.s8),
              shortcutButtons,
            ],
          ),
        );
      },
    );
  }
}
