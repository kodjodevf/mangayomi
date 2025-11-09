import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

Widget btnToShowChapterListDialog(
  BuildContext context,
  String title,
  Chapter chapter, {
  void Function(bool)? onChanged,
  Color? iconColor,
}) {
  return IconButton(
    onPressed: () async {
      onChanged?.call(false);
      await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Container(
              width: context.width(0.85),
              constraints: BoxConstraints(maxHeight: context.height(0.8)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.primaryColor.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: context.primaryColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          color: context.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.primaryColor,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close_rounded,
                            color: context.primaryColor.withValues(alpha: 0.7),
                          ),
                          tooltip: 'Fermer',
                        ),
                      ],
                    ),
                  ),
                  Flexible(child: ChapterListWidget(chapter: chapter)),
                ],
              ),
            ),
          );
        },
      );
      onChanged?.call(true);
    },
    icon: Icon(Icons.format_list_numbered_outlined, color: iconColor),
  );
}

class ChapterListWidget extends StatefulWidget {
  final Chapter chapter;
  const ChapterListWidget({super.key, required this.chapter});

  @override
  State<ChapterListWidget> createState() => _ChapterListWidgetState();
}

class _ChapterListWidgetState extends State<ChapterListWidget> {
  final controller = ScrollController();
  late final chapterList = widget.chapter.manga.value!.getFilteredChapterList();
  late final currentChapIndex = chapterList.indexWhere(
    (element) =>
        element.name == widget.chapter.name &&
        element.dateUpload == widget.chapter.dateUpload &&
        element.scanlator == widget.chapter.scanlator &&
        element.url == widget.chapter.url,
  );
  @override
  void initState() {
    super.initState();
    _jumpTo();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _jumpTo() async {
    await Future.delayed(const Duration(milliseconds: 5));
    controller.jumpTo(
      controller.position.maxScrollExtent /
          chapterList.length *
          currentChapIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      interactive: true,
      thickness: 8,
      radius: const Radius.circular(10),
      controller: controller,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SuperSliverList.builder(
              itemCount: chapterList.length,
              itemBuilder: (context, index) {
                final chapter = chapterList[index];
                final currentChap = chapter == chapterList[currentChapIndex];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ChapterListTile(
                    chapter: chapter,
                    currentChap: currentChap,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChapterListTile extends StatefulWidget {
  final Chapter chapter;
  final bool currentChap;
  const ChapterListTile({
    super.key,
    required this.chapter,
    required this.currentChap,
  });

  @override
  State<ChapterListTile> createState() => _ChapterListTileState();
}

class _ChapterListTileState extends State<ChapterListTile> {
  late final chapter = widget.chapter;
  late bool isBookmarked = chapter.isBookmarked!;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: widget.currentChap
            ? context.primaryColor.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: widget.currentChap
            ? Border.all(
                color: context.primaryColor.withValues(alpha: 0.4),
                width: 1.5,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            if (!widget.currentChap) {
              Navigator.pop(context);
              pushReplacementMangaReaderView(
                context: context,
                chapter: chapter,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Chapter indicator
                Container(
                  width: 4,
                  height: 48,
                  decoration: BoxDecoration(
                    color: chapter.isRead!
                        ? Colors.grey.withValues(alpha: 0.3)
                        : context.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                // Chapter content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.name!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: widget.currentChap
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: chapter.isRead!
                              ? context.isLight
                                    ? Colors.black.withValues(alpha: 0.4)
                                    : Colors.white.withValues(alpha: 0.4)
                              : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (!(chapter.manga.value!.isLocalArchive ?? false))
                            Consumer(
                              builder: (context, ref, child) {
                                final dateText =
                                    chapter.dateUpload == null ||
                                        chapter.dateUpload!.isEmpty
                                    ? ""
                                    : dateFormat(
                                        chapter.dateUpload!,
                                        ref: ref,
                                        context: context,
                                      );
                                return dateText.isNotEmpty
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            size: 12,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            dateText,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                          if (chapter.scanlator != null &&
                              chapter.scanlator!.isNotEmpty)
                            Row(
                              children: [
                                if (!(chapter.manga.value!.isLocalArchive ??
                                        false) &&
                                    (chapter.dateUpload != null &&
                                        chapter.dateUpload!.isNotEmpty))
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Text(
                                      '•',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                Icon(
                                  Icons.group_rounded,
                                  size: 12,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    chapter.scanlator!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (!chapter.isRead! &&
                          chapter.lastPageRead!.isNotEmpty &&
                          chapter.lastPageRead != "1")
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.bookmark_rounded,
                                size: 12,
                                color: context.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                chapter.manga.value!.itemType == ItemType.anime
                                    ? context.l10n.episode_progress(
                                        Duration(
                                          milliseconds: int.parse(
                                            chapter.lastPageRead!,
                                          ),
                                        ).toString().substringBefore("."),
                                      )
                                    : context.l10n.page(
                                        chapter.manga.value!.itemType ==
                                                ItemType.manga
                                            ? chapter.lastPageRead!
                                            : "${((double.tryParse(chapter.lastPageRead!) ?? 0) * 100).toStringAsFixed(0)} %",
                                      ),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: context.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Bookmark button
                Consumer(
                  builder: (context, ref, child) => Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          isBookmarked = !isBookmarked;
                        });
                        isar.writeTxnSync(
                          () => {
                            isar.chapters.putSync(
                              chapter
                                ..isBookmarked = isBookmarked
                                ..updatedAt =
                                    DateTime.now().millisecondsSinceEpoch,
                            ),
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          color: isBookmarked
                              ? context.primaryColor
                              : Colors.grey,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
