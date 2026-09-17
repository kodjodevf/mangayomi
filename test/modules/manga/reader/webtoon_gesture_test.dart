import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/image_view_webtoon.dart';

void main() {
  test('WebtoonScaleGestureRecognizer converts accepted to rejected when unzoomed with < 2 pointers', () {
    var canPan = false;
    final recognizer = WebtoonScaleGestureRecognizer(
      canPanCallback: () => canPan,
    );

    // Unzoomed, 0 or 1 pointers -> should reject
    expect(
      recognizer.resolveDisposition(GestureDisposition.accepted),
      GestureDisposition.rejected,
    );

    // Zoomed (canPan = true) -> should accept
    canPan = true;
    expect(
      recognizer.resolveDisposition(GestureDisposition.accepted),
      GestureDisposition.accepted,
    );

    // Already rejected -> remains rejected
    expect(
      recognizer.resolveDisposition(GestureDisposition.rejected),
      GestureDisposition.rejected,
    );
  });
}
