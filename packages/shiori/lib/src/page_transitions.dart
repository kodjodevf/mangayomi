import 'package:flutter/material.dart';

import 'tokens.dart';

/// How a page arrives and leaves: on a short shared axis, with a fade.
///
/// The new page slides in from a little to the right while it fades in over
/// the one under it, which drifts a little to the left. The page underneath
/// stays opaque: fading both out and in showed the bare ground between them,
/// a flash on a light theme. Short distances and Shiori's
/// curves keep it quick and calm: it says where the page came from without
/// zooming the whole screen at the reader, as Material's default did.
///
/// Going back plays the same movement in reverse. Under reduced motion the
/// page is simply there.
class ShioriPageTransitionsBuilder extends PageTransitionsBuilder {
  const ShioriPageTransitionsBuilder();

  /// How far, as a fraction of the width, a page travels.
  static const double _shift = 0.08;

  @override
  Duration get transitionDuration => ShioriMotion.enter;

  @override
  Duration get reverseTransitionDuration => ShioriMotion.standard;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;
    return ShioriPageTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

/// The movement [ShioriPageTransitionsBuilder] draws, for routes built by
/// hand (a dialog page, an onboarding step).
class ShioriPageTransition extends StatelessWidget {
  const ShioriPageTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  static final _enterSlide = Tween<Offset>(
    begin: const Offset(ShioriPageTransitionsBuilder._shift, 0),
    end: Offset.zero,
  ).chain(CurveTween(curve: ShioriMotion.enterCurve));

  // The page fades in over the first part of its slide, so it is solid
  // before it settles.
  static final _enterFade = CurveTween(
    curve: const Interval(0, 0.6, curve: ShioriMotion.standardCurve),
  );

  static final _exitSlide = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-ShioriPageTransitionsBuilder._shift, 0),
  ).chain(CurveTween(curve: ShioriMotion.standardCurve));

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: secondaryAnimation.drive(_exitSlide),
      child: SlideTransition(
        position: animation.drive(_enterSlide),
        child: FadeTransition(
          opacity: animation.drive(_enterFade),
          child: child,
        ),
      ),
    );
  }
}
