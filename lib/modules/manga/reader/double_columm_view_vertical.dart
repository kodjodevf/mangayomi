import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/image_view_paged.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';
import 'package:mangayomi/modules/manga/reader/widgets/transition_view_vertical.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class DoubleColummVerticalView extends StatelessWidget {
  final List<UChapDataPreload?> datas;
  final Function(UChapDataPreload datas) onLongPressData;
  final BackgroundColor backgroundColor;
  final Function(bool) isFailedToLoadImage;
  const DoubleColummVerticalView({
    super.key,
    required this.datas,
    required this.onLongPressData,
    required this.backgroundColor,
    required this.isFailedToLoadImage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    if (datas[0]?.isTransitionPage ?? false) {
      return TransitionViewVertical(data: datas[0]!);
    }
    if (datas.length > 1 && (datas[1]?.isTransitionPage ?? false)) {
      return TransitionViewVertical(data: datas[1]!);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (datas[0]?.index == 0)
          SizedBox(height: MediaQuery.of(context).padding.top),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (datas[0] != null)
              Flexible(
                child: ImageViewPaged(
                  data: datas[0]!,
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      final ImageChunkEvent? loadingProgress =
                          state.loadingProgress;
                      final double progress =
                          loadingProgress?.expectedTotalBytes != null
                          ? loadingProgress!.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : 0;
                      return Container(
                        color: getBackgroundColor(backgroundColor),
                        height: context.height(0.8),
                        child: CircularProgressIndicatorAnimateRotate(
                          progress: progress,
                        ),
                      );
                    }
                    if (state.extendedImageLoadState == LoadState.completed) {
                      isFailedToLoadImage(false);
                      return Image(image: state.imageProvider);
                    }
                    if (state.extendedImageLoadState == LoadState.failed) {
                      isFailedToLoadImage(true);
                      return Container(
                        color: getBackgroundColor(backgroundColor),
                        height: context.height(0.8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.image_loading_error,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onLongPress: () {
                                  state.reLoadImage();
                                  isFailedToLoadImage(false);
                                },
                                onTap: () {
                                  state.reLoadImage();
                                  isFailedToLoadImage(false);
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
                                    child: Text(l10n.retry),
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
                  onLongPressData: (datas) => onLongPressData.call(datas),
                ),
              ),
            // if (datas[1] != null) const SizedBox(width: 10),
            if (datas[1] != null)
              Flexible(
                child: ImageViewPaged(
                  data: datas[1]!,
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      final ImageChunkEvent? loadingProgress =
                          state.loadingProgress;
                      final double progress =
                          loadingProgress?.expectedTotalBytes != null
                          ? loadingProgress!.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : 0;
                      return Container(
                        color: getBackgroundColor(backgroundColor),
                        height: context.height(0.8),
                        child: CircularProgressIndicatorAnimateRotate(
                          progress: progress,
                        ),
                      );
                    }
                    if (state.extendedImageLoadState == LoadState.completed) {
                      isFailedToLoadImage(false);
                      return Image(image: state.imageProvider);
                    }
                    if (state.extendedImageLoadState == LoadState.failed) {
                      isFailedToLoadImage(true);
                      return Container(
                        color: getBackgroundColor(backgroundColor),
                        height: context.height(0.8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.image_loading_error,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onLongPress: () {
                                  state.reLoadImage();
                                  isFailedToLoadImage(false);
                                },
                                onTap: () {
                                  state.reLoadImage();
                                  isFailedToLoadImage(false);
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
                                    child: Text(l10n.retry),
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
                  onLongPressData: (datas) => onLongPressData.call(datas),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
