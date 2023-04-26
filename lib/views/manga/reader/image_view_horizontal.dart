import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

class ImageViewHorizontal extends StatelessWidget {
  final int length;
  final String url;
  final int index;
  final String titleManga;
  final String source;
  final String chapter;
  final Directory path;
  final bool isLocale;
  final Widget? Function(ExtendedImageState state) loadStateChanged;
  final Function(ExtendedImageGestureState state) onDoubleTap;
  final GestureConfig Function(ExtendedImageState state)
      initGestureConfigHandler;
  const ImageViewHorizontal({
    super.key,
    required this.url,
    required this.chapter,
    required this.index,
    required this.path,
    required this.titleManga,
    required this.source,
    required this.length,
    required this.loadStateChanged,
    required this.onDoubleTap,
    required this.initGestureConfigHandler,
    required this.isLocale,
  });

  @override
  Widget build(BuildContext context) {
    return isLocale
        ? ExtendedImage.file(
            File("${path.path}" "${padIndex(index + 1)}.jpg"),
            clearMemoryCacheWhenDispose: true,
            enableMemoryCache: false,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: initGestureConfigHandler,
            onDoubleTap: onDoubleTap,
            loadStateChanged: loadStateChanged,
          )
        : ExtendedImage(
            image: FastCachedImageProvider(url, headers: headers(source)),
            clearMemoryCacheWhenDispose: true,
            enableMemoryCache: false,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: initGestureConfigHandler,
            onDoubleTap: onDoubleTap,
            handleLoadingProgress: true,
            loadStateChanged: loadStateChanged,
          );
  }
}
