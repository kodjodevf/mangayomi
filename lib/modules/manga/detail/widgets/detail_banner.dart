import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/headers.dart';

/// The collapsing header banner behind the detail page's app bar: the
/// manga's cover, scrimmed to fade into the scaffold background, hidden
/// once the page has scrolled past it. A separate widget (rather than an
/// inline Consumer) so scrolling only rebuilds this, not the rest of the
/// page.
class DetailBanner extends ConsumerWidget {
  final Manga manga;
  final NotifierProvider<Notifier<double>, double> offsetProvider;

  const DetailBanner({
    super.key,
    required this.manga,
    required this.offsetProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      top: 0,
      child: ref.watch(offsetProvider.select((val) => val == 0.0))
          ? Stack(
              children: [
                manga.customCoverImage != null
                    ? Image.memory(
                        manga.customCoverImage as Uint8List,
                        width: context.width(1),
                        height: 300,
                        fit: BoxFit.cover,
                      )
                    // The banner renders at 300 px behind an overlay;
                    // decode it resized instead of at full cover
                    // resolution.
                    : cachedCompressedNetworkImage(
                        headers: manga.isLocalArchive!
                            ? null
                            : ref.watch(
                                headersProvider(
                                  source: manga.source!,
                                  lang: manga.lang!,
                                  sourceId: manga.sourceId,
                                ),
                              ),
                        imageUrl: toImgUrl(
                          manga.customCoverFromTracker ?? manga.imageUrl ?? "",
                        ),
                        width: context.width(1),
                        height: 300,
                        fit: BoxFit.cover,
                        maxBytes: 512 << 10,
                      ),
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: context.width(1),
                          height: AppBar().preferredSize.height,
                          color: context.isTablet
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Theme.of(
                                  context,
                                ).scaffoldBackgroundColor.withValues(alpha: 0.9),
                        ),
                        Container(
                          width: context.width(1),
                          height: 465,
                          color: context.isTablet
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Theme.of(
                                  context,
                                ).scaffoldBackgroundColor.withValues(alpha: 0.9),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: context.width(1),
                        height: 100,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Container(),
    );
  }
}
