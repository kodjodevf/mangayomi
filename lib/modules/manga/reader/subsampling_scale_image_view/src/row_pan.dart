import 'dart:math';
import 'dart:ui';

/// Where the image goes to show the next row of a zoomed page, or the row
/// above: one screen down (or up) from [translation], clamped to the
/// image, and to the start of that row as it is read, the left edge or the
/// right one when [rightToLeft]. Going up, it lands at the end of the row.
/// An image no wider than the screen keeps its place across.
///
/// [translation] is the image's top-left corner on screen, [shown] its size
/// on screen and [view] the screen's.
Offset rowPanTarget({
  required Offset translation,
  required Size shown,
  required Size view,
  required bool down,
  required bool rightToLeft,
}) {
  final dy = down
      ? max(translation.dy - view.height, view.height - shown.height)
      : min(translation.dy + view.height, 0.0);
  var dx = translation.dx;
  if (shown.width > view.width) {
    final toRight = down == rightToLeft;
    dx = toRight ? view.width - shown.width : 0.0;
  }
  return Offset(dx, dy);
}
