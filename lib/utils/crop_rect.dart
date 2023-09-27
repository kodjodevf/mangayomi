import 'dart:ui';

Image cropRect({
  required Image image,
  required int x,
  required int y,
  required int width,
  required int height,
}) {
  final recorder = PictureRecorder();
  Canvas(recorder).drawImageRect(
    image,
    Rect.fromLTRB(
      x.toDouble(),
      y.toDouble(),
      x.toDouble() + width.toDouble(),
      y.toDouble() + height.toDouble(),
    ),
    Rect.fromLTRB(0, 0, width.toDouble(), height.toDouble()),
    Paint(),
  );

  final croppedImage = recorder.endRecording().toImageSync(width, height);
  return croppedImage;
}
