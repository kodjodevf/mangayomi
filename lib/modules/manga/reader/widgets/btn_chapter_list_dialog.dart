import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/widgets/draggable_scroll_bar.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

Widget btnToShowChapterListDialog(BuildContext context, String title, Chapter chapter) {
  return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(title),
                content: SizedBox(
                    width: context.mediaWidth(0.8),
                    child: ChapterListWidget(chapter: chapter)),
              );
            });
      },
      icon: const Icon(Icons.format_list_numbered_outlined));
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
  late final currentChapIndex = chapterList.indexWhere((element) =>
      element.name == widget.chapter.name &&
      element.dateUpload == widget.chapter.dateUpload &&
      element.scanlator == widget.chapter.scanlator &&
      element.url == widget.chapter.url);
  @override
  void initState() {
    _jumpTo();
    super.initState();
  }

  Future<void> _jumpTo() async {
    await Future.delayed(const Duration(milliseconds: 5));
    controller.jumpTo(controller.position.maxScrollExtent /
        chapterList.length *
        currentChapIndex);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollbarWidget(
        controller: controller,
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 2),
            controller: controller,
            itemCount: chapterList.length,
            itemBuilder: (context, index) {
              final chapter = chapterList[index];
              final currentChap = chapter == chapterList[currentChapIndex];
              return ChapterListTile(
                  chapter: chapter, currentChap: currentChap);
            }));
  }
}

class ChapterListTile extends StatefulWidget {
  final Chapter chapter;
  final bool currentChap;
  const ChapterListTile(
      {super.key, required this.chapter, required this.currentChap});

  @override
  State<ChapterListTile> createState() => _ChapterListTileState();
}

class _ChapterListTileState extends State<ChapterListTile> {
  late final chapter = widget.chapter;
  late bool isBookmarked = chapter.isBookmarked!;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.currentChap ? context.primaryColor.withOpacity(0.3) : null,
      child: ListTile(
        textColor: chapter.isRead!
            ? context.isLight
                ? Colors.black.withOpacity(0.4)
                : Colors.white.withOpacity(0.3)
            : null,
        selectedColor:
            chapter.isRead! ? Colors.white.withOpacity(0.3) : Colors.white,
        onTap: () async {
          Navigator.pop(context);
          pushReplacementMangaReaderView(context: context, chapter: chapter);
        },
        title: Text(
          chapter.name!,
          style: const TextStyle(fontSize: 13),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            if (!(chapter.manga.value!.isLocalArchive ?? false))
              Consumer(
                  builder: (context, ref, child) => Text(
                      chapter.dateUpload == null || chapter.dateUpload!.isEmpty
                          ? ""
                          : dateFormat(chapter.dateUpload!,
                              ref: ref, context: context),
                      style: const TextStyle(fontSize: 11))),
            if (!chapter.isRead!)
              if (chapter.lastPageRead!.isNotEmpty &&
                  chapter.lastPageRead != "1")
                if (chapter.scanlator!.isNotEmpty)
                  Row(
                    children: [
                      const Text(' • '),
                      Text(chapter.scanlator!,
                          style: TextStyle(
                              fontSize: 11,
                              color: chapter.isRead!
                                  ? context.isLight
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.white.withOpacity(0.3)
                                  : null)),
                    ],
                  )
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              isBookmarked = !isBookmarked;
            });
            isar.writeTxnSync(() =>
                isar.chapters.putSync(chapter..isBookmarked = isBookmarked));
          },
          icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: context.primaryColor),
        ),
      ),
    );
  }
}
