import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/views/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/views/manga/download/download_page_widget.dart';

class ChapterListTileWidget extends ConsumerWidget {
  final ModelManga modelManga;
  final ModelChapters chapter;
  final int chapterIndex;
  final List<ModelChapters> chapterNameList;
  const ChapterListTileWidget({
    required this.chapterNameList,
    required this.chapter,
    required this.chapterIndex,
    super.key,
    required this.modelManga,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    return Container(
      color: chapterNameList.contains(chapter)
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
            ref.read(chapterIdsListStateProvider.notifier).update(chapter);
            ref.read(chapterModelStateProvider.notifier).update(chapter);
            ref
                .read(isLongPressedStateProvider.notifier)
                .update(!isLongPressed);
          } else {
            ref.read(chapterIdsListStateProvider.notifier).update(chapter);
            ref.read(chapterModelStateProvider.notifier).update(chapter);
          }
        },
        onTap: () async {
          if (isLongPressed) {
            ref.read(chapterIdsListStateProvider.notifier).update(chapter);
            ref.read(chapterModelStateProvider.notifier).update(chapter);
          } else {
            pushMangaReaderView(
                context: context, modelManga: modelManga, index: chapterIndex);
          }
        },
        title: Row(
          children: [
            chapter.isBookmarked!
                ? Icon(
                    Icons.bookmark,
                    size: 15,
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
              chapter.dateUpload!,
              style: const TextStyle(fontSize: 11),
            ),
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
        trailing: ref.watch(ChapterPageDownloadsProvider(
            chapterIndex: chapterIndex,
            modelManga: modelManga,
            chapterId: chapter.id!)),
      ),
    );
  }
}
