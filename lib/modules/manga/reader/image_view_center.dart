import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

class ImageViewCenter extends ConsumerWidget {
  final UChapDataPreload data;
  final bool cropBorders;
  final Function(UChapDataPreload data) onLongPressData;
  final Widget? Function(ExtendedImageState state) loadStateChanged;
  final Function(ExtendedImageGestureState state)? onDoubleTap;
  final GestureConfig Function(ExtendedImageState state)?
      initGestureConfigHandler;
  const ImageViewCenter({
    super.key,
    required this.data,
    required this.cropBorders,
    required this.onLongPressData,
    required this.loadStateChanged,
    this.onDoubleTap,
    this.initGestureConfigHandler,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cropImageExist = cropBorders && data.cropImage != null;

    return _imageView(cropImageExist ? true : data.isLocale!,
        cropImageExist ? data.cropImage : data.archiveImage, ref);
  }

  Widget _imageView(bool isLocale, Uint8List? archiveImage, WidgetRef ref) {
    final scaleType = ref.watch(scaleTypeStateProvider);
    final image = isLocale
        ? archiveImage != null
            ? ExtendedMemoryImageProvider(archiveImage)
            : ExtendedFileImageProvider(
                File('${data.directory!.path}${padIndex(data.index! + 1)}.jpg'))
        : CustomExtendedNetworkImageProvider(
            data.url!.trim().trimLeft().trimRight(),
            cache: true,
            cacheMaxAge: const Duration(days: 7),
            headers: ref.watch(headersProvider(
                source: data.chapter!.manga.value!.source!,
                lang: data.chapter!.manga.value!.lang!)));

    return GestureDetector(
      onLongPress: () => onLongPressData.call(data),
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
