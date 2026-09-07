/// Chooses the native video texture size for the visible Linux viewport.
///
/// media_kit otherwise renders at the source video's full resolution, which is
/// unnecessarily expensive when a high-resolution stream is displayed in a
/// smaller window. Even dimensions avoid extra chroma-alignment work for
/// common YUV formats.
({int width, int height})? linuxVideoOutputSize({
  required double logicalWidth,
  required double logicalHeight,
  required double devicePixelRatio,
}) {
  if (!logicalWidth.isFinite ||
      !logicalHeight.isFinite ||
      !devicePixelRatio.isFinite ||
      logicalWidth <= 0 ||
      logicalHeight <= 0 ||
      devicePixelRatio <= 0) {
    return null;
  }

  int evenPhysicalPixels(double logicalPixels) {
    final pixels = (logicalPixels * devicePixelRatio).ceil();
    return pixels.isEven ? pixels : pixels + 1;
  }

  return (
    width: evenPhysicalPixels(logicalWidth),
    height: evenPhysicalPixels(logicalHeight),
  );
}
