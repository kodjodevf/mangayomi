import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

class ImageViewVertical extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
              : ExtendedImage(
                  image: FastCachedImageProvider(url, headers: headers(source)),
                  handleLoadingProgress: true,
                  fit: BoxFit.contain,
                  clearMemoryCacheWhenDispose: true,
                  enableMemoryCache: false,
                  loadStateChanged: (ExtendedImageState state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      final ImageChunkEvent? loadingProgress =
                          state.loadingProgress;
                      final double progress =
                          loadingProgress?.expectedTotalBytes != null
                              ? loadingProgress!.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : 0;
                      return TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.elasticIn,
                        tween: Tween<double>(
                          begin: 0,
                          end: progress,
                        ),
                        builder: (context, value, _) => Container(
                          color: Colors.black,
                          height: mediaHeight(context, 0.8),
                          child: Center(
                            child: progress == 0
                                ? const CircularProgressIndicator()
                                : CircularProgressIndicator(
                                    value: progress,
                                  ),
                          ),
                        ),
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
