import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
            image: CachedNetworkImageProvider(url,
                cacheManager: CacheManager(
                    Config(url, stalePeriod: const Duration(days: 7))),
                headers: headers(source)),
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
