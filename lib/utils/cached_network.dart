import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';

/// Default upper bound on the encoded byte size of a thumbnail-sized cover
/// after `ExtendedResizeImage` resamples. 200 KB roughly maps to a 400x600
/// JPEG / WebP — sharp enough at typical grid / list display sizes on
/// high-DPR screens, while keeping the *decoded* RAM footprint small (the
/// resampled image goes into Flutter's `imageCache` decoded, where every
/// saved KB matters).
const int _coverMaxBytes = 200 << 10;

/// Returns an `ImageProvider` for a manga / anime cover URL that decodes at
/// thumbnail resolution rather than the source resolution.
///
/// Source covers are commonly 720x1080 or larger (~3 MB decoded RGBA per
/// cover). When used directly in a library grid or list, every visible
/// thumbnail fills `imageCache` with a 3 MB blob even though it renders at
/// ~150x220 logical pixels. Wrapping the provider in `ExtendedResizeImage`
/// instructs the decoder to resample to a much smaller bitmap before it
/// hits the cache, so the same in-memory budget holds far more thumbnails
/// and scrolling stops thrashing.
///
/// Use this for thumbnail call sites (library grid / list, browse search
/// cards, tracker results, calendar, etc.). Do *not* use it for large hero
/// covers (manga detail page) or for reader pages, which need full
/// resolution.
ImageProvider coverProvider(
  String url, {
  Map<String, String>? headers,
  int maxBytes = _coverMaxBytes,
  bool cache = true,
  Duration? cacheMaxAge,
}) {
  return ExtendedResizeImage(
    CustomExtendedNetworkImageProvider(
      url,
      headers: headers,
      cache: cache,
      cacheMaxAge: cacheMaxAge,
    ),
    maxBytes: maxBytes,
  );
}

Widget cachedNetworkImage({
  Map<String, String>? headers,
  required String imageUrl,
  required double? width,
  required double? height,
  required BoxFit? fit,
  AlignmentGeometry? alignment,
  bool useCustomNetworkImage = true,
  Widget errorWidget = const Icon(Icons.error, size: 50),
}) {
  return ExtendedImage(
    image: useCustomNetworkImage
        ? CustomExtendedNetworkImageProvider(imageUrl, headers: headers)
        : ExtendedNetworkImageProvider(imageUrl, headers: headers),
    width: width,
    height: height,
    fit: fit,
    filterQuality: FilterQuality.medium,
    mode: ExtendedImageMode.none,
    handleLoadingProgress: true,
    loadStateChanged: (state) {
      if (state.extendedImageLoadState == LoadState.failed) {
        return errorWidget;
      }
      return null;
    },
  );
}

Widget cachedCompressedNetworkImage({
  Map<String, String>? headers,
  required String imageUrl,
  required double? width,
  required double? height,
  required BoxFit? fit,
  AlignmentGeometry? alignment,
  bool useCustomNetworkImage = true,
  Widget errorWidget = const Icon(Icons.error, size: 50),
  int maxBytes = 5 << 10,
}) {
  return ExtendedImage(
    image: ExtendedResizeImage(
      useCustomNetworkImage
          ? CustomExtendedNetworkImageProvider(imageUrl, headers: headers)
          : ExtendedNetworkImageProvider(imageUrl, headers: headers),
      maxBytes: maxBytes,
    ),
    width: width,
    height: height,
    fit: fit,
    filterQuality: FilterQuality.medium,
    mode: ExtendedImageMode.none,
    handleLoadingProgress: true,
    clearMemoryCacheWhenDispose: true,
    loadStateChanged: (state) {
      if (state.extendedImageLoadState == LoadState.failed) {
        return errorWidget;
      }
      return null;
    },
  );
}
