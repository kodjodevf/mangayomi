import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_swipe.dart';
import 'package:mangayomi/modules/manga/download/download_page_widget.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/deferred_cover_image.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';
import 'package:shiori/shiori.dart';

class UpdateChapterListTileWidget extends ConsumerWidget {
  final Chapter chapter;
  final Manga manga;
  final bool sourceExist;
  const UpdateChapterListTileWidget({
    required this.chapter,
    required this.manga,
    required this.sourceExist,
    super.key,
  });

  ImageProvider _cover(WidgetRef ref) => manga.customCoverImage != null
      ? MemoryImage(manga.customCoverImage as Uint8List)
      : coverProvider(
          toImgUrl(manga.customCoverFromTracker ?? manga.imageUrl ?? ''),
          headers: ref.watch(
            headersProvider(
              source: manga.source!,
              lang: manga.lang!,
              sourceId: manga.sourceId,
            ),
          ),
        );

  /// The cover, the title and the chapter. [openDetail] lets the cover open
  /// the series on its own, which only a pointer can reach.
  ShioriListRow _row(
    BuildContext context,
    WidgetRef ref, {
    VoidCallback? onTap,
    bool openDetail = false,
    Widget? trailing,
  }) {
    final height = context.shiori.density.rowHeight - ShioriSpace.s8;
    return ShioriListRow(
      leading: ShioriThumbnail(
        height: height,
        semanticLabel: openDetail ? manga.name : null,
        onTap: openDetail
            ? () => context.push('/manga-reader/detail', extra: manga.id)
            : null,
        child: DeferredCoverImage(
          width: height * coverAspect,
          height: height,
          builder: (context) => Image(
            image: _cover(ref),
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        ),
      ),
      title: manga.name!,
      subtitle: chapter.name,
      dimmed: chapter.isRead ?? false,
      onTap: onTap,
      trailing: trailing,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Two focusable targets on TV, matching the Browse source rows: the entry
    // itself, and its download control. The cover's tap-to-detail is folded
    // into the entry, since a third stop for it would only slow the remote
    // down, and the detail is a press away from the reader anyway.
    if (isTv) {
      return TvListRow(
        children: [
          Expanded(
            child: TvRowButton(
              onTap: () =>
                  chapter.pushToReaderView(context, ignoreIsRead: true),
              child: _row(context, ref),
            ),
          ),
          if (sourceExist)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: ShioriSpace.s8),
              child: ChapterPageDownload(chapter: chapter),
            ),
        ],
      );
    }
    // The same swipes as in a series' chapter list: mark read, bookmark,
    // download, as Settings › Reader says.
    return ChapterSwipe(
      chapter: chapter,
      child: _row(
        context,
        ref,
        openDetail: true,
        onTap: () => chapter.pushToReaderView(context, ignoreIsRead: true),
        trailing: sourceExist ? ChapterPageDownload(chapter: chapter) : null,
      ),
    );
  }
}
