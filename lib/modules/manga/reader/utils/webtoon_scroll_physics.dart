import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_motion.dart';

/// How the long strip moves once the finger lets go.
///
/// Android keeps its own fling. On iOS and macOS a flick glides on with
/// UIKit's deceleration, as every other list there does, instead of
/// stopping within half a second. Either way the strip stops dead at its
/// ends rather than bouncing, so reaching the end of a chapter stays a
/// single, clear stop.
class WebtoonScrollPhysics extends ClampingScrollPhysics {
  const WebtoonScrollPhysics({super.parent});

  /// `UIScrollView.decelerationRate.normal`, 0.998 a millisecond, over a
  /// second: what [BouncingScrollPhysics] glides with.
  static const double iosDrag = 0.135;

  @override
  WebtoonScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      WebtoonScrollPhysics(parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final simulation = super.createBallisticSimulation(position, velocity);
    if (simulation is! ClampingScrollSimulation || !_glidesLikeIos) {
      return simulation;
    }
    return _StopAtEdges(
      FrictionSimulation(
        iosDrag,
        position.pixels,
        velocity,
        tolerance: toleranceFor(position),
      ),
      position.minScrollExtent,
      position.maxScrollExtent,
    );
  }

  bool get _glidesLikeIos => switch (defaultTargetPlatform) {
    TargetPlatform.iOS || TargetPlatform.macOS => true,
    _ => false,
  };
}

/// A glide that ends where it meets either end of the strip.
class _StopAtEdges extends Simulation {
  _StopAtEdges(this._glide, this._min, this._max)
    : super(tolerance: _glide.tolerance);

  final Simulation _glide;
  final double _min;
  final double _max;

  @override
  double x(double time) => _glide.x(time).clamp(_min, _max);

  /// Whether the glide has run into an end. Leaving one, as a flick from
  /// the very top does, isn't.
  bool _atEdge(double time) {
    final x = _glide.x(time);
    final v = _glide.dx(time);
    return (x <= _min && v <= 0) || (x >= _max && v >= 0);
  }

  @override
  double dx(double time) => _atEdge(time) ? 0 : _glide.dx(time);

  @override
  bool isDone(double time) => _atEdge(time) || _glide.isDone(time);
}

/// The speed a zoomed page hands to the strip as the finger lifts, as a
/// scroll velocity, or 0 when the page's own pan absorbs the fling.
///
/// [offset] is the page's pan along the strip, [maxOffset] how far it can
/// pan either way, and [velocity] the finger's speed along the strip
/// (screen pixels a second). A drag scrolls the strip once the page reaches
/// its edge; likewise a fling that would carry the page past its edge glides
/// the strip on, rather than stopping there.
double stripFlingVelocity({
  required double offset,
  required double maxOffset,
  required double velocity,
}) {
  final target = offset + velocity * ReaderMotion.flingTravel;
  if (target.abs() <= maxOffset) return 0;
  // The strip's offset moves against the finger, as in the drag.
  return -velocity;
}

/// Sets the strip behind [controller] gliding at [velocity] (scroll pixels
/// a second), with its own physics, as if the finger had flung it.
void glideStrip(ScrollController controller, double velocity) {
  if (!controller.hasClients) return;
  final position = controller.position;
  if (position is ScrollPositionWithSingleContext) {
    position.goBallistic(velocity);
  }
}
