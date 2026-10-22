import 'package:flutter/material.dart';
import 'package:mangayomi/modules/reader_common/reader_chapter_navigation.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/reader_common/providers/chapter_display.dart';
import 'package:mangayomi/router/push_router.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
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
    tooltip: title,
    onPressed: () async {
      onChanged?.call(false);
      await showChapterListPanel(context, title: title, chapter: chapter);
      onChanged?.call(true);
    },
    icon: Icon(Symbols.format_list_numbered_rounded, color: iconColor),
  );
}

/// The chapters or episodes of [chapter]'s series, opened over the reader or
/// the player without hiding it: a panel from the side when the screen is
/// wider than tall (a video in landscape keeps playing beside it), a sheet
/// from the bottom otherwise.
Future<void> showChapterListPanel(
  BuildContext context, {
  required String title,
  required Chapter chapter,
}) {
  final size = MediaQuery.sizeOf(context);
  if (size.width <= size.height) {
    return showShioriSheet<void>(
      context,
      title: title,
      maxHeightFactor: 0.8,
      builder: (_) => ChapterListWidget(chapter: chapter),
    );
  }
  final width = (size.width * 0.45).clamp(320.0, 460.0);
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: ShioriScrim.onImage,
    transitionDuration: ShioriMotion.of(context, ShioriMotion.enter),
    pageBuilder: (context, _, _) => Align(
      alignment: AlignmentDirectional.centerEnd,
      child: SizedBox(
        width: width,
        height: double.infinity,
        child: Material(
          color: context.shiori.color.ink1,
          borderRadius: const BorderRadiusDirectional.horizontal(
            start: Radius.circular(ShioriShape.sheet),
          ),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            left: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    ShioriSpace.s16,
                    ShioriSpace.s8,
                    ShioriSpace.s4,
                    ShioriSpace.s4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            title,
                            style: context.shiori.text.section.copyWith(
                              color: context.shiori.color.fg,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: MaterialLocalizations.of(context)
                            .closeButtonTooltip,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Symbols.close_rounded),
                      ),
                    ],
                  ),
                ),
                Expanded(child: ChapterListWidget(chapter: chapter)),
              ],
            ),
          ),
        ),
      ),
    ),
    transitionBuilder: (context, animation, _, child) => SlideTransition(
      position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
        CurvedAnimation(parent: animation, curve: ShioriMotion.enterCurve),
      ),
      child: child,
    ),
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
  final _listController = ListController();
  late final chapterList = widget.chapter.manga.value!
      .getSortedFilteredChapters();
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
    _listController.dispose();
    controller.dispose();
    super.dispose();
  }

  /// Opens on the current chapter, a third of the way down: the list
  /// controller lands on the item itself, where dividing the scroll extent
  /// by the count landed wherever the rows' heights disagreed.
  Future<void> _jumpTo() async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || currentChapIndex < 0) return;
    _listController.jumpToItem(
      index: currentChapIndex,
      scrollController: controller,
      alignment: 0.3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      interactive: true,
      thickness: 8,
      radius: const Radius.circular(ShioriShape.card),
      controller: controller,
      child: CustomScrollView(
        controller: controller,
        // A short list takes its own height rather than the sheet's whole;
        // a long one stays lazy, and fills it.
        shrinkWrap: chapterList.length <= 20,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(ShioriSpace.s12),
            sliver: SuperSliverList.builder(
              listController: _listController,
              itemCount: chapterList.length,
              itemBuilder: (context, index) {
                final chapter = chapterList[index];
                final currentChap =
                    currentChapIndex >= 0 &&
                    chapter == chapterList[currentChapIndex];
                return Padding(
                  padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
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
    final tokens = context.shiori;
    final c = tokens.color;
    final isRead = chapter.isRead!;
    final meta = tokens.caption;
    return AnimatedContainer(
      duration: ShioriMotion.of(context, ShioriMotion.standard),
      decoration: BoxDecoration(
        color: widget.currentChap
            ? c.accent.withValues(alpha: Alphas.accentTint)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        border: widget.currentChap
            ? Border.all(color: c.accent, width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(ShioriShape.card),
          onTap: () async {
            if (!widget.currentChap) {
              Navigator.pop(context);
              ReaderChapterNavigation.markNavigatingToChapter();
              pushReplacementMangaReaderView(
                context: context,
                chapter: chapter,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ShioriSpace.s16,
              vertical: ShioriSpace.s12,
            ),
            child: Row(
              children: [
                // Chapter indicator
                Container(
                  width: 4,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isRead ? c.hairline : c.accent,
                    borderRadius: BorderRadius.circular(ShioriShape.badge),
                  ),
                ),
                const SizedBox(width: ShioriSpace.s12),
                // Chapter content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Named as in the series' own list: by its title, or
                      // by its number when the series is set to.
                      Consumer(
                        builder: (context, ref, _) {
                          final manga = chapter.manga.value!;
                          return Text(
                            chapterDisplayName(
                              chapter,
                              manga,
                              context.l10n,
                              byNumber: ref.watch(
                                chapterNumberDisplayProvider.select(
                                  (ids) => ids.contains(manga.id),
                                ),
                              ),
                            ),
                            style: tokens.text.row.copyWith(
                              fontWeight: widget.currentChap
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isRead ? c.fgMuted : c.fg,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          );
                        },
                      ),
                      const SizedBox(height: ShioriSpace.s4),
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
                                            Symbols.access_time_rounded,
                                            fill: 1,
                                            size: 12,
                                            color: c.fgMuted,
                                          ),
                                          const SizedBox(width: ShioriSpace.s4),
                                          Text(dateText, style: meta),
                                        ],
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                          // Bounded by the row: a long scanlator name is
                          // cut, where its Flexible needs a width to cut at.
                          if (chapter.scanlator != null &&
                              chapter.scanlator!.isNotEmpty)
                            Flexible(
                              child: Row(
                                children: [
                                  if (!(chapter.manga.value!.isLocalArchive ??
                                          false) &&
                                      (chapter.dateUpload != null &&
                                          chapter.dateUpload!.isNotEmpty))
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: ShioriSpace.s8,
                                      ),
                                      child: Text('·', style: meta),
                                    ),
                                  Icon(
                                    Symbols.group_rounded,
                                    fill: 1,
                                    size: 12,
                                    color: c.fgMuted,
                                  ),
                                  const SizedBox(width: ShioriSpace.s4),
                                  Flexible(
                                    child: Text(
                                      chapter.scanlator!,
                                      style: meta,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (!chapter.isRead! &&
                          chapter.lastPageRead!.isNotEmpty &&
                          chapter.lastPageRead != "1")
                        Padding(
                          padding: const EdgeInsets.only(top: ShioriSpace.s4),
                          child: Row(
                            children: [
                              Icon(
                                Symbols.bookmark_rounded,
                                fill: 1,
                                size: 12,
                                color: c.accentInk,
                              ),
                              const SizedBox(width: ShioriSpace.s4),
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
                                style: meta.copyWith(color: c.accentInk),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: ShioriSpace.s12),
                // Bookmark button
                IconButton(
                  tooltip: isBookmarked
                      ? context.l10n.remove_bookmark
                      : context.l10n.bookmark,
                  onPressed: () {
                    setState(() => isBookmarked = !isBookmarked);
                    chapterRepository.save(
                      chapter..isBookmarked = isBookmarked,
                    );
                  },
                  icon: Icon(
                    Symbols.bookmark_rounded,
                    fill: isBookmarked ? 1 : 0,
                    color: isBookmarked ? c.accentInk : c.fgMuted,
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
