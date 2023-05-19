import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              ? ExtendedImage.file(
                  fit: BoxFit.contain,
                  clearMemoryCacheWhenDispose: true,
                  enableMemoryCache: false,
                  File('${path.path}${padIndex(index + 1)}.jpg'))
              : ExtendedImage.network(url,
                  headers: ref.watch(headersProvider(source: source)),
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
          if (index + 1 == length)
            SizedBox(
              height: mediaHeight(context, 0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$chapter finished',
                    style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(
                    FontAwesomeIcons.circleCheck,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
