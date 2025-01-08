import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class ImageViewPaged extends ConsumerWidget {
  final UChapDataPreload data;
  final Function(UChapDataPreload data) onLongPressData;
  final Widget? Function(ExtendedImageState state) loadStateChanged;
  final Function(ExtendedImageGestureState state)? onDoubleTap;
  final GestureConfig Function(ExtendedImageState state)?
      initGestureConfigHandler;
  const ImageViewPaged({
    super.key,
    required this.data,
    required this.onLongPressData,
    required this.loadStateChanged,
    this.onDoubleTap,
    this.initGestureConfigHandler,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaleType = ref.watch(scaleTypeStateProvider);
    final image = data.getImageProvider(ref, true);
    return GestureDetector(
      onLongPress: () => onLongPressData.call(data),
      child: ColorFilterWidget(
        child: ExtendedImage(
            image: image,
            fit: getBoxFit(scaleType),
            filterQuality: FilterQuality.medium,
            mode: ExtendedImageMode.gesture,
            handleLoadingProgress: true,
            loadStateChanged: loadStateChanged,
            initGestureConfigHandler: initGestureConfigHandler,
            onDoubleTap: onDoubleTap),
      ),
    );
  }
}
