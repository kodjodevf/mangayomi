import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/src/min_subsampling_image_view.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart';

class ImageViewVertical extends ConsumerWidget {
  final UChapDataPreload data;
  final Function(UChapDataPreload data) onLongPressData;
  final bool isHorizontal;
  final ValueNotifier<bool> isVisible;
  final Function(bool) failedToLoadImage;
  final Widget? Function(SubsamplingImageState)? loadStateChanged;
  final int rotation;
  final Function(double width, double height)? onImageLoaded;

  const ImageViewVertical({
    super.key,
    required this.data,
    required this.onLongPressData,
    required this.failedToLoadImage,
    required this.isHorizontal,
    required this.isVisible,
    this.loadStateChanged,
    this.rotation = 0,
    this.onImageLoaded,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (colorBlendMode, color) = chapterColorFIlterValues(context, ref);
    final cropBorders = ref.watch(cropBordersStateProvider);

    final imageWidget = MinSubsamplingImage(
      data: data,
      fit: getBoxFit(ref.watch(scaleTypeStateProvider)),
      color: color,
      colorBlendMode: colorBlendMode,
      cropBorders: cropBorders,
      isHorizontal: isHorizontal,
      failedToLoadImage: failedToLoadImage,
      isVisible: isVisible,
      loadStateChanged: loadStateChanged,
      rotation: rotation,
      onImageLoaded: onImageLoaded,
    );

    return applyReaderColorFilter(
      GestureDetector(
        onLongPress: () => onLongPressData.call(data),
        child: isHorizontal
            ? imageWidget
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (data.index == 0)
                    SizedBox(height: MediaQuery.of(context).padding.top),
                  imageWidget,
                ],
              ),
      ),
      ref,
    );
  }
}
