// shiori-file: timings set by the finger's speed and the page's size, not
// by the motion scale, as the reader's gestures are physical.
import 'dart:math';

import 'package:flutter/animation.dart';

/// How the reader moves pages and zooms, after Android's own pager and list:
/// a motion picks up at the speed the finger left it and eases into place,
/// rather than lasting a set time whatever it starts from.
abstract final class ReaderMotion {
  /// Android's pager and list curve, `(t - 1)⁵ + 1`: most of the way at
  /// once, a long soft landing.
  static const Curve quinticOut = _QuinticOut();

  /// The longest a page takes to settle.
  static const Duration maxSettle = Duration(milliseconds: 600);

  /// How long a page takes to settle [distance] pixels away, on a page
  /// [extent] pixels long, released at [velocity] pixels a second: as long
  /// as the finger's speed takes, or 100 ms a page plus 100 ms from rest.
  static Duration settle({
    required double distance,
    required double extent,
    double velocity = 0,
  }) {
    distance = distance.abs();
    velocity = velocity.abs();
    if (extent <= 0 || distance == 0) return Duration.zero;
    final int ms;
    if (velocity > 0) {
      // Closer than a page, the influence of the distance falls off.
      final half = extent / 2;
      final ratio = min(1.0, distance / extent);
      final eased = half + half * sin((ratio - 0.5) * 0.3 * pi / 2);
      ms = 4 * (1000 * eased / velocity).round();
    } else {
      ms = ((distance / extent + 1) * 100).round();
    }
    return Duration(milliseconds: min(ms, maxSettle.inMilliseconds));
  }

  /// How long a list takes to scroll [distance] pixels on a viewport
  /// [extent] pixels long: 300 ms from rest plus 300 ms a viewport.
  static Duration scroll({required double distance, required double extent}) {
    if (extent <= 0) return Duration.zero;
    final ms = ((distance.abs() / extent + 1) * 300).round();
    return Duration(milliseconds: min(ms, 2000));
  }

  /// The double-tap zoom, by the speed setting: none, normal and fast.
  static Duration doubleTapZoom(int? speed) => switch (speed) {
    0 => const Duration(milliseconds: 1),
    2 => const Duration(milliseconds: 250),
    _ => const Duration(milliseconds: 500),
  };

  /// The double-tap zoom on a long strip: quicker, the strip staying under
  /// the finger, still none when that is the setting.
  static Duration stripDoubleTapZoom(int? speed) => speed == 0
      ? const Duration(milliseconds: 1)
      : const Duration(milliseconds: 200);

  /// A zoomed page flung: it glides [flingTravel] of the release speed in
  /// [flingDuration], decelerating, so it leaves at the finger's speed.
  static const double flingTravel = 0.2;
  static const Duration flingDuration = Duration(milliseconds: 400);
}

class _QuinticOut extends Curve {
  const _QuinticOut();

  @override
  double transformInternal(double t) {
    final u = t - 1;
    return u * u * u * u * u + 1;
  }
}
