import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/download/download_page_widget.dart';

class ChapterListTileWidget extends ConsumerWidget {
  final Chapter chapter;
  final List<Chapter> chapterList;
  final bool sourceExist;
  const ChapterListTileWidget({
    required this.chapterList,
    required this.chapter,
    required this.sourceExist,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    final l10n = l10nLocalizations(context)!;
    return Container(
      color: chapterList.contains(chapter)
          ? context.primaryColor.withValues(alpha: 0.4)
          : null,
      child: ListTile(
        textColor: chapter.isRead!
            ? context.isLight
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.3)
            : null,
        selectedColor: chapter.isRead!
            ? Colors.white.withValues(alpha: 0.3)
            : Colors.white,
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
            chapter.pushToReaderView(context, ignoreIsRead: true);
          }
        },
        title: Row(
          children: [
            chapter.isBookmarked!
                ? Icon(
                    Icons.bookmark,
                    size: 16,
                    color: context.primaryColor,
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
            if ((chapter.manga.value!.isLocalArchive ?? false) == false)
              Text(
                chapter.dateUpload == null || chapter.dateUpload!.isEmpty
                    ? ""
                    : dateFormat(chapter.dateUpload!,
                        ref: ref, context: context),
                style: const TextStyle(fontSize: 11),
              ),
            if (!chapter.isRead!)
              if (chapter.lastPageRead!.isNotEmpty &&
                  chapter.lastPageRead != "1")
                Row(
                  children: [
                    const Text(' • '),
                    Text(
                      chapter.manga.value!.itemType == ItemType.anime
                          ? l10n.episode_progress(Duration(
                                  milliseconds:
                                      int.parse(chapter.lastPageRead!))
                              .toString()
                              .substringBefore("."))
                          : l10n.page(chapter.manga.value!.itemType ==
                                  ItemType.manga
                              ? chapter.lastPageRead!
                              : "${((double.tryParse(chapter.lastPageRead!) ?? 0) * 100).toStringAsFixed(0)} %"),
                      style: TextStyle(
                          fontSize: 11,
                          color: context.isLight
                              ? Colors.black.withValues(alpha: 0.4)
                              : Colors.white.withValues(alpha: 0.3)),
                    ),
                  ],
                ),
            if (chapter.scanlator?.isNotEmpty ?? false)
              Row(
                children: [
                  const Text(' • '),
                  Text(
                    chapter.scanlator!,
                    style: TextStyle(
                        fontSize: 11,
                        color: chapter.isRead!
                            ? context.isLight
                                ? Colors.black.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.3)
                            : null),
                  ),
                ],
              )
          ],
        ),
        trailing: !sourceExist || (chapter.manga.value!.isLocalArchive ?? false)
            ? null
            : ChapterPageDownload(chapter: chapter),
      ),
    );
  }
}
