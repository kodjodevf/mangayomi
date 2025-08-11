import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';

class ImageViewVertical extends ConsumerWidget {
  final UChapDataPreload data;
  final Function(UChapDataPreload data) onLongPressData;
  final bool isHorizontal;

  final Function(bool) failedToLoadImage;

  const ImageViewVertical({
    super.key,
    required this.data,
    required this.onLongPressData,
    required this.failedToLoadImage,
    required this.isHorizontal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (colorBlendMode, color) = chapterColorFIlterValues(context, ref);
    final imageWidget = ExtendedImage(
      colorBlendMode: colorBlendMode,
      color: color,
      image: data.getImageProvider(ref, true),
      filterQuality: FilterQuality.medium,
      handleLoadingProgress: true,
      fit: getBoxFit(ref.watch(scaleTypeStateProvider)),
      enableLoadState: true,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.completed) {
          failedToLoadImage(false);
        }
        if (state.extendedImageLoadState == LoadState.loading) {
          final ImageChunkEvent? loadingProgress = state.loadingProgress;
          final double progress = loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
              : 0;
          return Container(
            color: Colors.black,
            height: context.height(0.8),
            width: isHorizontal ? context.width(0.8) : null,
            child: CircularProgressIndicatorAnimateRotate(progress: progress),
          );
        }
        if (state.extendedImageLoadState == LoadState.failed) {
          failedToLoadImage(true);
          return Container(
            color: Colors.black,
            height: context.height(0.8),
            width: isHorizontal ? context.width(0.8) : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.l10n.image_loading_error,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onLongPress: () {
                      state.reLoadImage();
                      failedToLoadImage(false);
                    },
                    onTap: () {
                      state.reLoadImage();
                      failedToLoadImage(false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Text(context.l10n.retry),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return null;
      },
    );
    return GestureDetector(
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
    );
  }
}
