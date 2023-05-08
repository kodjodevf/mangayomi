import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/views/manga/reader/providers/push_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/views/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/views/manga/download/download_page_widget.dart';

class ChapterListTileWidget extends ConsumerWidget {
  final Chapter chapter;
  final List<Chapter> chapterList;
  const ChapterListTileWidget({
    required this.chapterList,
    required this.chapter,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);

    return Container(
      color: chapterList.contains(chapter)
          ? primaryColor(context).withOpacity(0.4)
          : null,
      child: ListTile(
        textColor: chapter.isRead!
            ? isLight(context)
                ? Colors.black.withOpacity(0.4)
                : Colors.white.withOpacity(0.3)
            : null,
        selectedColor:
            chapter.isRead! ? Colors.white.withOpacity(0.3) : Colors.white,
        onLongPress: () {
          if (!isLongPressed) {
            ref.read(chaptersListStateProvider.notifier).update(chapter);

            ref
                .read(isLongPressedStateProvider.notifier)
                .update(!isLongPressed);
          } else {
            ref.read(chaptersListStateProvider.notifier).update(chapter);
          }
        },
        onTap: () async {
          if (isLongPressed) {
            ref.read(chaptersListStateProvider.notifier).update(chapter);
          } else {
            pushMangaReaderView(context: context, chapter: chapter);
          }
        },
        title: Row(
          children: [
            chapter.isBookmarked!
                ? Icon(
                    Icons.bookmark,
                    size: 16,
                    color: primaryColor(context),
                  )
                : Container(),
            Flexible(
              child: Text(
                chapter.name!,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              dateFormat(chapter.dateUpload!, ref: ref),
              style: const TextStyle(fontSize: 11),
            ),
            if(!chapter.isRead!)
            if (chapter.lastPageRead!.isNotEmpty && chapter.lastPageRead != "1")
              Row(
                children: [
                  const Text(' • '),
                  Text(
                    "Page ${chapter.lastPageRead}",
                    style: TextStyle(
                        fontSize: 11,
                        color: isLight(context)
                            ? Colors.black.withOpacity(0.4)
                            : Colors.white.withOpacity(0.3)),
                  ),
                ],
              ),
            if (chapter.scanlator!.isNotEmpty)
              Row(
                children: [
                  const Text(' • '),
                  Text(
                    chapter.scanlator!,
                    style: TextStyle(
                        fontSize: 11,
                        color: chapter.isRead!
                            ? isLight(context)
                                ? Colors.black.withOpacity(0.4)
                                : Colors.white.withOpacity(0.3)
                            : null),
                  ),
                ],
              )
          ],
        ),
        trailing: ChapterPageDownload(chapter: chapter),
      ),
    );
  }
}
