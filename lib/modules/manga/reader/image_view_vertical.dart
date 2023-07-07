import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';

class ImageViewVertical extends ConsumerWidget {
  final int length;
  final bool isLocale;
  final String url;
  final int index;
  final String titleManga;
  final String source;
  final String chapter;
  final Directory path;
  final String lang;
  final Uint8List? archiveImage;

  const ImageViewVertical({
    super.key,
    required this.url,
    required this.chapter,
    required this.index,
    required this.path,
    required this.titleManga,
    required this.source,
    required this.length,
    required this.isLocale,
    required this.lang,
    this.archiveImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      fit: BoxFit.contain, enableMemoryCache: false,
                      loadStateChanged: (ExtendedImageState state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return Container(
                          color: Colors.black,
                          height: mediaHeight(context, 0.8),
                        );
                      }
                      return null;
                    })
                  : ExtendedImage.file(
                      fit: BoxFit.contain,
                      enableMemoryCache: false,
                      File('${path.path}${padIndex(index + 1)}.jpg'),
                      loadStateChanged: (ExtendedImageState state) {
                      if (state.extendedImageLoadState == LoadState.loading) {
                        return Container(
                          color: Colors.black,
                          height: mediaHeight(context, 0.8),
                        );
                      }
                      return null;
                    })
              : ExtendedImage.network(url.trim().trimLeft().trimRight(),
                  headers:
                      ref.watch(headersProvider(source: source, lang: lang)),
                  handleLoadingProgress: true,
                  cacheMaxAge: const Duration(days: 7),
                  fit: BoxFit.contain,
                  enableMemoryCache: true,
                  loadStateChanged: (ExtendedImageState state) {
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
                    return Container(
                        color: Colors.black,
                        height: mediaHeight(context, 0.8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  state.reLoadImage();
                                },
                                child: const Icon(
                                  Icons.replay_outlined,
                                  size: 30,
                                )),
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
