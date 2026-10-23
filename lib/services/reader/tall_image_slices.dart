import 'dart:math';
import 'dart:ui';

/// How much taller than wide an image must be before it is split.
const double tallImageMinAspect = 3;

/// The height of a slice, as a multiple of the image's width: about a phone
/// screen.
const double tallImageSliceAspect = 2;

/// The regions a [width] by [height] image is read in when it is split, top
/// to bottom, all of the same height; none when it is not tall enough to be
/// worth it.
///
/// Decoding one slice at a time keeps a long strip from being held in
/// memory whole, which on a phone is what gets the reader killed.
List<Rect> tallImageSlices(double width, double height) {
  if (width <= 0 || height <= width * tallImageMinAspect) return const [];
  final count = (height / (width * tallImageSliceAspect)).ceil();
  final sliceHeight = (height / count).floorToDouble();
  return [
    for (var i = 0; i < count; i++)
      Rect.fromLTRB(
        0,
        i * sliceHeight,
        width,
        // The last slice takes what rounding left over.
        i == count - 1 ? height : min(height, (i + 1) * sliceHeight),
      ),
  ];
}
