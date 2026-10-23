import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/reader/tall_image_slices.dart';

void main() {
  test('an image not tall enough stays whole', () {
    expect(tallImageSlices(800, 2400), isEmpty);
    expect(tallImageSlices(0, 2400), isEmpty);
  });

  test('a strip is cut in slices about two widths high', () {
    final slices = tallImageSlices(800, 10000);
    expect(slices, hasLength(7));
    for (final slice in slices) {
      expect(slice.width, 800);
      expect(slice.height, lessThanOrEqualTo(1600));
    }
  });

  test('the slices cover the image without gaps', () {
    final slices = tallImageSlices(720, 9999);
    expect(slices.first.top, 0);
    expect(slices.last.bottom, 9999);
    for (var i = 1; i < slices.length; i++) {
      expect(slices[i].top, slices[i - 1].bottom);
    }
  });
}
