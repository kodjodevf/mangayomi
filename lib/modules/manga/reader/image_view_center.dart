import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mangayomi/modules/manga/reader/providers/auto_crop_image_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

class ImageViewCenter extends ConsumerWidget {
  final UChapDataPreload datas;
  final Widget? Function(ExtendedImageState state) loadStateChanged;
  final Function(ExtendedImageGestureState state) onDoubleTap;
  final GestureConfig Function(ExtendedImageState state)
      initGestureConfigHandler;
  const ImageViewCenter({
    super.key,
    required this.datas,
    required this.loadStateChanged,
    required this.onDoubleTap,
    required this.initGestureConfigHandler,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final cropBorder = ref.watch(cropBordersStateProvider);
    return _imageView(datas.isLocale!, datas.archiveImage, ref);
    // StreamBuilder<Uint8List?>(
    //     stream: ref
    //         .watch(autoCropImageBorderProvider(
    //                 datas: datas, cropBorder: cropBorder)
    //             .future)
    //         .asStream(),
    //     builder: (context, snapshot) {
    //       final hasData = snapshot.hasData && snapshot.data != null;
    //       if (hasData) {
    //         return _imageView(hasData, snapshot.data, ref);
    //       }
    //       return _imageView(datas.isLocale!, datas.archiveImage, ref);
    //     });
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
                File("${datas.path!.path}" "${padIndex(datas.index! + 1)}.jpg"),
                fit: getBoxFit(scaleType),
                clearMemoryCacheWhenDispose: true,
                enableMemoryCache: false,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: initGestureConfigHandler,
                onDoubleTap: onDoubleTap,
                loadStateChanged: loadStateChanged,
              )
        : ExtendedImage.network(
            datas.url!.trim().trimLeft().trimRight(),
            fit: getBoxFit(scaleType),
            headers: ref.watch(headersProvider(
                source: datas.chapter!.manga.value!.source!,
                lang: datas.chapter!.manga.value!.lang!)),
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
