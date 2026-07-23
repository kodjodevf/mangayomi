import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/modules/manga/download/download_page_widget.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';

class UpdateChapterListTileWidget extends ConsumerWidget {
  final Chapter chapter;
  final bool sourceExist;
  const UpdateChapterListTileWidget({
    required this.chapter,
    required this.sourceExist,
    super.key,
  });

  /// The cover, title and chapter name: the row's main target.
  Widget _body(BuildContext context, WidgetRef ref, Manga manga) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: manga.customCoverImage != null
                  ? MemoryImage(manga.customCoverImage as Uint8List)
                        as ImageProvider
                  : CustomExtendedNetworkImageProvider(
                      toImgUrl(manga.customCoverFromTracker ?? manga.imageUrl!),
                      headers: ref.watch(
                        headersProvider(
                          source: manga.source!,
                          lang: manga.lang!,
                          sourceId: manga.sourceId,
                        ),
                      ),
                    ),
              fit: BoxFit.cover,
              width: 40,
              height: 45,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  manga.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                Text(
                  chapter.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: chapter.isRead ?? false
                        ? Colors.grey
                        : Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manga = chapter.manga.value!;
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
              child: _body(context, ref, manga),
            ),
          ),
          if (sourceExist)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChapterPageDownload(chapter: chapter),
            ),
        ],
      );
    }
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        focusColor: isTv
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
            : null,
        onTap: () async {
          chapter.pushToReaderView(context, ignoreIsRead: true);
        },
        onLongPress: () {},
        onSecondaryTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
          child: Container(
            height: 45,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Material(
                          child: GestureDetector(
                            onTap: () {
                              context.push(
                                '/manga-reader/detail',
                                extra: manga.id,
                              );
                            },
                            child: Ink.image(
                              fit: BoxFit.cover,
                              width: 40,
                              height: 45,
                              image: manga.customCoverImage != null
                                  ? MemoryImage(
                                          manga.customCoverImage as Uint8List,
                                        )
                                        as ImageProvider
                                  : CustomExtendedNetworkImageProvider(
                                      toImgUrl(
                                        manga.customCoverFromTracker ??
                                            manga.imageUrl!,
                                      ),
                                      headers: ref.watch(
                                        headersProvider(
                                          source: manga.source!,
                                          lang: manga.lang!,
                                          sourceId: manga.sourceId,
                                        ),
                                      ),
                                    ),
                              child: InkWell(child: Container()),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                manga.name!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.color,
                                ),
                              ),
                              Text(
                                chapter.name!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: chapter.isRead ?? false
                                      ? Colors.grey
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodyLarge!.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (sourceExist) ChapterPageDownload(chapter: chapter),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
