import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

/// How far to scroll the surrounding PageView for a pan the image could not
/// absorb, as a change to its scroll offset.
///
/// [excess] is the finger movement left over once the image hit its edge, in
/// screen coordinates. A PageView's offset grows towards its next page, which
/// on screen is to the right of the finger for a normal horizontal PageView
/// but to the left of it for a reversed (right-to-left) one, and likewise up
/// or down for a vertical one. So dragging the content follows the finger
/// only once the sign is taken from [axisDirection].
double pageScrollDeltaForPan(AxisDirection axisDirection, Offset excess) =>
    switch (axisDirection) {
      AxisDirection.right => -excess.dx,
      AxisDirection.left => excess.dx,
      AxisDirection.down => -excess.dy,
      AxisDirection.up => excess.dy,
    };

/// The page a PageView dragged by the image should settle on when the finger
/// lifts at fractional [page], moving at [velocity] (screen pixels/second).
///
/// Like PageView's own physics, a fling turns the page in its direction even
/// when it was dragged less than halfway; a slow release goes to the nearest
/// page.
int settlePage(double page, AxisDirection axisDirection, Offset velocity) {
  final scrollVelocity = pageScrollDeltaForPan(axisDirection, velocity);
  if (scrollVelocity.abs() < kMinFlingVelocity) return page.round();
  return scrollVelocity > 0 ? page.ceil() : page.floor();
}
