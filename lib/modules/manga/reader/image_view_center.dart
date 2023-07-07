import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

class ImageViewCenter extends ConsumerWidget {
  final String lang;
  final int length;
  final String url;
  final int index;
  final String titleManga;
  final String source;
  final String chapter;
  final Directory path;
  final bool isLocale;
  final Uint8List? archiveImage;
  final Widget? Function(ExtendedImageState state) loadStateChanged;
  final Function(ExtendedImageGestureState state) onDoubleTap;
  final GestureConfig Function(ExtendedImageState state)
      initGestureConfigHandler;
  const ImageViewCenter({
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
    required this.lang,
    this.archiveImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isLocale
        ? archiveImage != null
            ? ExtendedImage.memory(
                archiveImage!,
                clearMemoryCacheWhenDispose: true,
                enableMemoryCache: false,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: initGestureConfigHandler,
                onDoubleTap: onDoubleTap,
                loadStateChanged: loadStateChanged,
              )
            : ExtendedImage.file(
                File("${path.path}" "${padIndex(index + 1)}.jpg"),
                clearMemoryCacheWhenDispose: true,
                enableMemoryCache: false,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: initGestureConfigHandler,
                onDoubleTap: onDoubleTap,
                loadStateChanged: loadStateChanged,
              )
        : ExtendedImage.network(
            url.trim().trimLeft().trimRight(),
            headers: ref.watch(headersProvider(source: source, lang: lang)),
            enableMemoryCache: true,
            mode: ExtendedImageMode.gesture,
            cacheMaxAge: const Duration(days: 7),
            initGestureConfigHandler: initGestureConfigHandler,
            onDoubleTap: onDoubleTap,
            handleLoadingProgress: true,
            loadStateChanged: loadStateChanged,
          );
  }
}
