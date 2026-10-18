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

/// Switching between top-level destinations: Material's fade through, as
/// Mihon switches its tabs. The tab being left fades out over the first 35 %
/// of [duration], then the tab being opened fades in, with no scale.
abstract final class ShioriFadeThrough {
  static const Duration duration = Duration(milliseconds: 200);

  static const _share = ShioriPageTransition._outgoingShare;

  /// The opacity of the tab being opened at [t], 0 to 1 over the switch.
  static double incoming(double t) =>
      _linearOutSlowIn.transform(((t - _share) / (1 - _share)).clamp(0.0, 1.0));

  /// The opacity of the tab being left at [t].
  static double outgoing(double t) =>
      1 - _fastOutLinearIn.transform((t / _share).clamp(0.0, 1.0));
}

/// Children kept mounted as an [IndexedStack] keeps them, switched with
/// [ShioriFadeThrough]: the child being left fades out, then the child being
/// opened fades in. Every child sits in the same wrapper whether shown or
/// not, so switching never remounts one or loses its scroll; a hidden child
/// is offstage, with its tickers off.
///
/// With [lazy], a child is built the first time it is shown rather than up
/// front, and kept from then on.
class ShioriFadeThroughStack extends StatefulWidget {
  const ShioriFadeThroughStack({
    super.key,
    required this.index,
    required this.children,
    this.lazy = false,
  });

  final int index;
  final List<Widget> children;
  final bool lazy;

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
        return Stack(
          fit: StackFit.expand,
          children: [
            for (final (i, child) in widget.children.indexed)
              Offstage(
                offstage: i != widget.index && i != _previous,
                child: TickerMode(
                  enabled: i == widget.index,
                  child: Opacity(
                    opacity: i == widget.index
                        ? ShioriFadeThrough.incoming(t)
                        : i == _previous
                        ? ShioriFadeThrough.outgoing(t)
                        : 1,
                    child: IgnorePointer(
                      ignoring: i != widget.index,
                      child: widget.lazy && !_visited.contains(i)
                          ? const SizedBox.shrink()
                          : child,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
