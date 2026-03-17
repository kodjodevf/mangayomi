import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
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
    final (colorBlendMode, color) = chapterColorFIlterValues(context, ref);
    final needsScaleOverride =
        scaleType == ScaleType.fitWidth || scaleType == ScaleType.fitHeight;
    final effectiveFit = needsScaleOverride
        ? BoxFit.contain
        : getBoxFit(scaleType);

    GestureConfig Function(ExtendedImageState)? effectiveGestureHandler;
    if (needsScaleOverride) {
      effectiveGestureHandler = (ExtendedImageState state) {
        final base = initGestureConfigHandler?.call(state);
        double initScale = base?.initialScale ?? 1.0;
        InitialAlignment alignment =
            base?.initialAlignment ?? InitialAlignment.center;
        final info = state.extendedImageInfo;
        if (info != null) {
          final imgW = info.image.width.toDouble();
          final imgH = info.image.height.toDouble();
          final viewSize = MediaQuery.of(context).size;
          final viewAspect = viewSize.width / viewSize.height;
          final imgAspect = imgW / imgH;
          if (scaleType == ScaleType.fitWidth && imgAspect < viewAspect) {
            initScale = viewAspect / imgAspect;
            alignment = InitialAlignment.topCenter;
          } else if (scaleType == ScaleType.fitHeight &&
              imgAspect > viewAspect) {
            initScale = imgAspect / viewAspect;
            alignment = InitialAlignment.centerLeft;
          }
        }
        return GestureConfig(
          initialScale: initScale,
          initialAlignment: alignment,
          inertialSpeed: base?.inertialSpeed ?? 200,
          inPageView: base?.inPageView ?? true,
          maxScale: base?.maxScale ?? 8,
          animationMaxScale: base?.animationMaxScale ?? 8,
          cacheGesture: base?.cacheGesture ?? true,
          hitTestBehavior: base?.hitTestBehavior ?? HitTestBehavior.translucent,
        );
      };
    } else {
      effectiveGestureHandler = initGestureConfigHandler;
    }

    return applyReaderColorFilter(
      GestureDetector(
        onLongPress: () => onLongPressData.call(data),
        child: ExtendedImage(
          image: image,
          colorBlendMode: colorBlendMode,
          color: color,
          fit: effectiveFit,
          filterQuality: FilterQuality.medium,
          mode: ExtendedImageMode.gesture,
          handleLoadingProgress: true,
          loadStateChanged: loadStateChanged,
          initGestureConfigHandler: effectiveGestureHandler,
          onDoubleTap: onDoubleTap,
        ),
      ),
      ref,
    );
  }
}
