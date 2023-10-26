import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/crop_borders_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

class ImageViewCenter extends ConsumerWidget {
  final UChapDataPreload datas;
  final bool cropBorders;
  final Widget? Function(ExtendedImageState state) loadStateChanged;
  const ImageViewCenter(
      {super.key,
      required this.datas,
      required this.cropBorders,
      required this.loadStateChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image =
        ref.watch(cropBordersProvider(datas: datas, cropBorder: cropBorders));
    final defaultWidget = _imageView(datas.isLocale!, datas.archiveImage, ref);
    return image.when(
      data: (data) {
        // if (data == null && !datas.isLocale!) {
        //   ref.invalidate(cropBordersProvider(datas: datas, cropBorder: true));
        // }
        return _imageView(data != null ? true : datas.isLocale!,
            data ?? datas.archiveImage, ref);
      },
      error: (_, __) => defaultWidget,
      loading: () => defaultWidget,
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
                loadStateChanged: loadStateChanged,
              )
            : ExtendedImage.file(
                File("${datas.path!.path}" "${padIndex(datas.index! + 1)}.jpg"),
                fit: getBoxFit(scaleType),
                clearMemoryCacheWhenDispose: true,
                enableMemoryCache: false,
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
            handleLoadingProgress: true,
            loadStateChanged: loadStateChanged,
          );
  }
}
