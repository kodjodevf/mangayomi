import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

class ImageViewCenter extends ConsumerWidget {
  final UChapDataPreload datas;
  final bool cropBorders;
  final Function(UChapDataPreload datas) onLongPressData;
  final Widget? Function(ExtendedImageState state) loadStateChanged;
  final Function(ExtendedImageGestureState state)? onDoubleTap;
  final GestureConfig Function(ExtendedImageState state)?
      initGestureConfigHandler;
  const ImageViewCenter({
    super.key,
    required this.datas,
    required this.cropBorders,
    required this.onLongPressData,
    required this.loadStateChanged,
    this.onDoubleTap,
    this.initGestureConfigHandler,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cropImageExist = cropBorders && datas.cropImage != null;

    return _imageView(cropImageExist ? true : datas.isLocale!,
        cropImageExist ? datas.cropImage : datas.archiveImage, ref);
  }

  Widget _imageView(bool isLocale, Uint8List? archiveImage, WidgetRef ref) {
    final scaleType = ref.watch(scaleTypeStateProvider);
    final image = isLocale
        ? archiveImage != null
            ? ExtendedMemoryImageProvider(archiveImage)
            : ExtendedFileImageProvider(
                File('${datas.path!.path}${padIndex(datas.index! + 1)}.jpg'))
        : ExtendedNetworkImageProvider(datas.url!.trim().trimLeft().trimRight(),
            cache: true,
            cacheMaxAge: const Duration(days: 7),
            headers: ref.watch(headersProvider(
                source: datas.chapter!.manga.value!.source!,
                lang: datas.chapter!.manga.value!.lang!)));

    return GestureDetector(
      onLongPress: () => onLongPressData.call(datas),
      child: ColorFilterWidget(
        child: ExtendedImage(
            image: image as ImageProvider<Object>,
            fit: getBoxFit(scaleType),
            filterQuality: FilterQuality.medium,
            enableMemoryCache: true,
            mode: ExtendedImageMode.gesture,
            handleLoadingProgress: true,
            loadStateChanged: loadStateChanged,
            initGestureConfigHandler: initGestureConfigHandler,
            onDoubleTap: onDoubleTap),
      ),
    );
  }
}
