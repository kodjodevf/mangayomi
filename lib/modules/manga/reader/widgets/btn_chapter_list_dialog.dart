import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

Widget btnToShowChapterListDialog(
    BuildContext context, String title, Chapter chapter,
    {void Function(bool)? onChanged}) {
  return IconButton(
      onPressed: () async {
        onChanged?.call(false);
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(title),
                content: SizedBox(
                    width: context.width(0.8),
                    child: ChapterListWidget(chapter: chapter)),
              );
            });
        onChanged?.call(true);
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
    return Scrollbar(
        interactive: true,
        thickness: 12,
        radius: const Radius.circular(10),
        controller: controller,
        child: CustomScrollView(
          controller: controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              sliver: SuperSliverList.builder(
                  itemCount: chapterList.length,
                  itemBuilder: (context, index) {
                    final chapter = chapterList[index];
                    final currentChap =
                        chapter == chapterList[currentChapIndex];
                    return ChapterListTile(
                        chapter: chapter, currentChap: currentChap);
                  }),
            ),
          ],
        ));
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
      color: widget.currentChap
          ? context.primaryColor.withValues(alpha: 0.3)
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
        onTap: () async {
          if (!widget.currentChap) {
            Navigator.pop(context);
            pushReplacementMangaReaderView(context: context, chapter: chapter);
          }
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
                if (chapter.scanlator != null && chapter.scanlator!.isNotEmpty)
                  Row(
                    children: [
                      const Text(' • '),
                      Text(chapter.scanlator!,
                          style: TextStyle(
                              fontSize: 11,
                              color: chapter.isRead!
                                  ? context.isLight
                                      ? Colors.black.withValues(alpha: 0.4)
                                      : Colors.white.withValues(alpha: 0.3)
                                  : null)),
                    ],
                  )
          ],
        ),
        trailing: Consumer(
          builder: (context, ref, child) => IconButton(
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
              isar.writeTxnSync(() => {
                    isar.chapters.putSync(chapter..isBookmarked = isBookmarked),
                    ref
                        .read(synchingProvider(syncId: 1).notifier)
                        .addChangedPart(ActionType.updateChapter, chapter.id,
                            chapter.toJson(), false),
                  });
            },
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                color: context.primaryColor),
          ),
        ),
      ),
    );
  }
}
