import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/auto_crop_image_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

class ImageViewCenter extends ConsumerWidget {
  final String lang;
  final String url;
  final int index;
  final String source;
  final Directory path;
  final bool isLocale;
  final Uint8List? archiveImage;
  final WidgetRef parentRef;
  final Widget? Function(ExtendedImageState state) loadStateChanged;
  final Function(ExtendedImageGestureState state) onDoubleTap;
  final GestureConfig Function(ExtendedImageState state)
      initGestureConfigHandler;
  const ImageViewCenter({
    super.key,
    required this.url,
    required this.index,
    required this.path,
    required this.source,
    required this.loadStateChanged,
    required this.onDoubleTap,
    required this.initGestureConfigHandler,
    required this.isLocale,
    required this.lang,
    required this.parentRef,
    this.archiveImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cropBorders = ref.watch(cropBordersStateProvider);
    final cropBorderData = parentRef.watch(autoCropImageBorderProvider(
        autoCrop: cropBorders,
        url: url,
        archiveImages: archiveImage,
        isLocaleList: isLocale,
        path: path,
        index: index));
    return cropBorderData.when(
      data: (data) {
        return data != null
            ? _imageView(true, data, ref)
            : _imageView(isLocale, archiveImage, ref);
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => _imageView(isLocale, archiveImage, ref),
    );
  }

  Widget _imageView(bool isLocale, Uint8List? archiveImage, WidgetRef ref) {
    final scaleType = ref.watch(scaleTypeStateProvider);
    return isLocale
        ? archiveImage != null
            ? ExtendedImage.memory(
                archiveImage,
                fit: getBoxFit(scaleType),
                clearMemoryCacheWhenDispose: true,
                enableMemoryCache: false,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: initGestureConfigHandler,
                onDoubleTap: onDoubleTap,
                loadStateChanged: loadStateChanged,
              )
            : ExtendedImage.file(
                File("${path.path}" "${padIndex(index + 1)}.jpg"),
                fit: getBoxFit(scaleType),
                clearMemoryCacheWhenDispose: true,
                enableMemoryCache: false,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: initGestureConfigHandler,
                onDoubleTap: onDoubleTap,
                loadStateChanged: loadStateChanged,
              )
        : ExtendedImage.network(
            url.trim().trimLeft().trimRight(),
            fit: getBoxFit(scaleType),
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
