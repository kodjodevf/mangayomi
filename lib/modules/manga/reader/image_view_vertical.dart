import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';

class ImageViewVertical extends ConsumerWidget {
  final bool isLocale;
  final String url;
  final int index;
  final String source;
  final Directory path;
  final String lang;
  final Uint8List? archiveImage;
  final Function(bool) failedToLoadImage;

  const ImageViewVertical(
      {super.key,
      required this.url,
      required this.index,
      required this.path,
      required this.source,
      required this.isLocale,
      required this.lang,
      this.archiveImage,
      required this.failedToLoadImage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaleType = ref.watch(scaleTypeStateProvider);
    final l10n = l10nLocalizations(context)!;
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (index == 0)
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
          isLocale
              ? archiveImage != null
                  ? ExtendedImage.memory(archiveImage!,
                      fit: getBoxFit(scaleType),
                      enableMemoryCache: false,
                      enableLoadState: true, loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return Container(
                          color: Colors.black,
                          height: mediaHeight(context, 0.6),
                        );
                      }
                      return null;
                    })
                  : ExtendedImage.file(
                      fit: getBoxFit(scaleType),
                      enableMemoryCache: false,
                      File('${path.path}${padIndex(index + 1)}.jpg'),
                      enableLoadState: true, loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return Container(
                          color: Colors.black,
                          height: mediaHeight(context, 0.6),
                        );
                      }
                      return null;
                    })
              : ExtendedImage.network(url.trim().trimLeft().trimRight(),
                  headers:
                      ref.watch(headersProvider(source: source, lang: lang)),
                  handleLoadingProgress: true,
                  cacheMaxAge: const Duration(days: 7),
                  fit: getBoxFit(scaleType),
                  enableMemoryCache: true,
                  enableLoadState: true, loadStateChanged: (state) {
                  if (state.extendedImageLoadState == LoadState.completed) {
                    failedToLoadImage(false);
                  }
                  if (state.extendedImageLoadState == LoadState.loading) {
                    final ImageChunkEvent? loadingProgress =
                        state.loadingProgress;
                    final double progress =
                        loadingProgress?.expectedTotalBytes != null
                            ? loadingProgress!.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : 0;
                    return Container(
                      color: Colors.black,
                      height: mediaHeight(context, 0.8),
                      child: CircularProgressIndicatorAnimateRotate(
                          progress: progress),
                    );
                  }
                  if (state.extendedImageLoadState == LoadState.failed) {
                    failedToLoadImage(true);
                    return Container(
                        color: Colors.black,
                        height: mediaHeight(context, 0.8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l10n.image_loading_error,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7))),
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
                                        color: primaryColor(context),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      child: Text(
                                        l10n.retry,
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ));
                  }
                  return null;
                }),
        ],
      ),
    );
  }
}
