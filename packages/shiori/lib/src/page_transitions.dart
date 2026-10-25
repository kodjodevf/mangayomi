import 'package:flutter/material.dart';

/// Material motion's LinearOutSlowIn, for what fades in.
const Curve _linearOutSlowIn = Cubic(0, 0, 0.2, 1);

/// Material motion's FastOutLinearIn, for what fades out.
const Curve _fastOutLinearIn = Cubic(0.4, 0, 1, 1);

/// How a page arrives and leaves: Material's shared axis on X,
/// moves between its screens.
///
/// Going forward, the page underneath slides 30 logical pixels to the left
/// and fades out over the first 35 % of the movement; the new page slides in
/// from 30 to the right and fades in over the rest, so the two cross without
/// ever both being strong. Going back plays the same movement mirrored. Under
/// reduced motion the page is simply there.
class ShioriPageTransitionsBuilder extends PageTransitionsBuilder {
  const ShioriPageTransitionsBuilder();

  @override
  Duration get transitionDuration => ShioriPageTransition.duration;

  @override
  Duration get reverseTransitionDuration => ShioriPageTransition.duration;

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
/// hand.
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

  /// Material's default motion duration.
  static const Duration duration = Duration(milliseconds: 300);

  /// How far a page travels, in logical pixels.
  static const double slideDistance = 30;

  /// The share of the movement the outgoing page takes to fade out; the
  /// incoming page fades in over the rest.
  static const double _outgoingShare = 0.35;

  /// The incoming page's opacity at [t], 0 to 1 over the movement.
  static double incomingOpacity(double t) => _fadeIn.transform(t);

  /// The outgoing page's opacity at [t], 0 to 1 over the movement.
  static double outgoingOpacity(double t) => _fadeOut.transform(t);

  // FastOutSlowIn for the slides, LinearOutSlowIn for the fade in and
  // FastOutLinearIn for the fade out: Material motion's own easings.
  static final _slide = CurveTween(curve: Curves.fastOutSlowIn);
  static final _fadeIn = CurveTween(
    curve: const Interval(_outgoingShare, 1, curve: _linearOutSlowIn),
  );
  static final _fadeOut = Tween<double>(begin: 1, end: 0).chain(
    CurveTween(
      curve: const Interval(0, _outgoingShare, curve: _fastOutLinearIn),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final sign = rtl ? -1.0 : 1.0;
    final enterSlide = animation.drive(_slide);
    final exitSlide = secondaryAnimation.drive(_slide);
    return AnimatedBuilder(
      animation: Listenable.merge([enterSlide, exitSlide]),
      // The incoming page from the right; the page under a new one to the
      // left. Popping runs both animations backwards, mirroring the move.
      builder: (context, child) => Transform.translate(
        offset: Offset(
          sign * slideDistance * ((1 - enterSlide.value) - exitSlide.value),
          0,
        ),
        child: child,
      ),
      child: FadeTransition(
        opacity: secondaryAnimation.drive(_fadeOut),
        child: FadeTransition(opacity: animation.drive(_fadeIn), child: child),
      ),
    );
  }
}

/// Switching between top-level destinations: the tab being opened fades in
/// over the tab being left, which stays fully drawn until it is covered.
///
/// A fade through (the old tab out, then the new one in) leaves a moment with
/// neither on screen, which read as a dark flash between two dark pages.
abstract final class ShioriFadeThrough {
  static const Duration duration = Duration(milliseconds: 180);

  /// The opacity of the tab being opened at [t], 0 to 1 over the switch.
  static double incoming(double t) => _linearOutSlowIn.transform(t);
}

/// Children kept mounted as an [IndexedStack] keeps them, switched with
/// [ShioriFadeThrough]: the child being opened fades in over the child being
/// left. Every child sits in the same wrapper whether shown or
/// not, so switching never remounts one or loses its scroll; a hidden child
/// is offstage, with its tickers off.
///
/// With [lazy], a child is built the first time it is shown rather than up
/// front, and kept from then on.
///
/// [slideDirection] turns a switch into the pages' shared axis movement
/// instead: given the child being left and the one being opened, it says
/// which way the opened one comes from, 1 from the end side, -1 from the
/// start side, 0 to fade as usual. For siblings laid out in a row, such as
/// the members of a segmented control.
class ShioriFadeThroughStack extends StatefulWidget {
  const ShioriFadeThroughStack({
    super.key,
    required this.index,
    required this.children,
    this.lazy = false,
    this.slideDirection,
  });

  final int index;
  final List<Widget> children;
  final bool lazy;
  final int Function(int from, int to)? slideDirection;

  @override
  State<ShioriFadeThroughStack> createState() => _ShioriFadeThroughStackState();
}

class _ShioriFadeThroughStackState extends State<ShioriFadeThroughStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(
        vsync: this,
        duration: ShioriFadeThrough.duration,
        value: 1,
      )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _previous = null);
        }
      });

  /// The child being left while the switch runs.
  int? _previous;

  /// Which way the switch running slides, or 0 for a fade.
  int _direction = 0;

  /// The children shown at least once, for [ShioriFadeThroughStack.lazy].
  late final Set<int> _visited = {widget.index};

  @override
  void didUpdateWidget(ShioriFadeThroughStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _visited.add(widget.index);
    if (oldWidget.index != widget.index) {
      if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
        _previous = null;
        _controller.value = 1;
      } else {
        _previous = oldWidget.index;
        _direction =
            widget.slideDirection?.call(oldWidget.index, widget.index).sign ??
            0;
        _controller.duration = _direction == 0
            ? ShioriFadeThrough.duration
            : ShioriPageTransition.duration;
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final slide = _direction != 0 && _previous != null;
        final rtl = Directionality.of(context) == TextDirection.rtl;
        final distance =
            ShioriPageTransition.slideDistance * _direction * (rtl ? -1 : 1);
        final moved = Curves.fastOutSlowIn.transform(t);
        // The child being opened is painted last, so it covers the one being
        // left; keys keep every child's state through the reordering.
        final order = [
          for (var i = 0; i < widget.children.length; i++)
            if (i != widget.index && i != _previous) i,
          ?_previous,
          widget.index,
        ];
        return Stack(
          fit: StackFit.expand,
          children: [
            for (final i in order)
              KeyedSubtree(
                key: ValueKey(i),
                child: Offstage(
                  offstage: i != widget.index && i != _previous,
                  child: TickerMode(
                    enabled: i == widget.index,
                    child: _slid(
                      slide: slide,
                      offset: i == widget.index
                          ? distance * (1 - moved)
                          : i == _previous
                          ? -distance * moved
                          : 0,
                      child: Opacity(
                        opacity: !slide
                            ? (i == widget.index
                                  ? ShioriFadeThrough.incoming(t)
                                  : 1)
                            : i == widget.index
                            ? ShioriPageTransition.incomingOpacity(t)
                            : i == _previous
                            ? ShioriPageTransition.outgoingOpacity(t)
                            : 1,
                        child: IgnorePointer(
                          ignoring: i != widget.index,
                          child: widget.lazy && !_visited.contains(i)
                              ? const SizedBox.shrink()
                              : widget.children[i],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// [child] moved sideways by [offset] while a slide runs. The same wrapper
  /// whether it slides or not, so a switch never rebuilds the child's tree.
  Widget _slid({
    required bool slide,
    required double offset,
    required Widget child,
  }) =>
      Transform.translate(offset: Offset(slide ? offset : 0, 0), child: child);
}
