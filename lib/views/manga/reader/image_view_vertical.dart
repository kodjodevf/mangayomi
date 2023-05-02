import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/views/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';

class ImageViewVertical extends StatefulWidget {
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
  State<ImageViewVertical> createState() => _ImageViewVerticalState();
}

class _ImageViewVerticalState extends State<ImageViewVertical>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.index == 0)
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
          widget.isLocale
              ? ExtendedImage.file(
                  fit: BoxFit.contain,
                  clearMemoryCacheWhenDispose: true,
                  enableMemoryCache: false,
                  File('${widget.path.path}${padIndex(widget.index + 1)}.jpg'))
              : ExtendedImage(
                  image: FastCachedImageProvider(widget.url,
                      headers: headers(widget.source)),
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
          if (widget.index + 1 == widget.length)
            SizedBox(
              height: mediaHeight(context, 0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.chapter} finished',
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

  @override
  bool get wantKeepAlive => true;
}
