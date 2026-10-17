import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/library_screen.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/detail/chapter_bulk_actions.dart';
import 'package:mangayomi/modules/manga/detail/detail_overflow_actions.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/tv/tv_anime_detail_view.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/detail_app_bar.dart';
import 'package:mangayomi/modules/manga/detail/widgets/detail_banner.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_info_header.dart';
import 'package:mangayomi/modules/manga/detail/widgets/split_chapters_dialog.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/modules/widgets/bottom_select_bar.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/riverpod.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class MangaDetailView extends ConsumerStatefulWidget {
  final Function(bool) isExtended;
  final Widget? titleDescription;
  final List<Color>? backButtonColors;
  final Widget? action;
  final Manga? manga;
  final bool sourceExist;
  final Function(bool) checkForUpdate;
  final ItemType itemType;

  const MangaDetailView({
    super.key,
    required this.isExtended,
    this.titleDescription,
    this.backButtonColors,
    this.action,
    required this.sourceExist,
    required this.manga,
    required this.checkForUpdate,
    required this.itemType,
  });

  @override
  ConsumerState<MangaDetailView> createState() => _MangaDetailViewState();
}

class _MangaDetailViewState extends ConsumerState<MangaDetailView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        ref.read(offetProvider.notifier).state = _scrollController.offset;
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// One-time notice (per screen open) when some chapters have no
  /// detectable number — sort/dedup can't place them reliably.
  void _notifyUnrecognizedChapterNumbers() {
    if (_shownUnrecognizedNotice) return;
    final count = widget.manga!.unrecognizedChapterNumberCount();
    if (count == 0) return;
    _shownUnrecognizedNotice = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = l10nLocalizations(context)!;
      botToast(l10n.unrecognized_chapter_numbers(count), second: 5);
    });
  }

  final offetProvider = StateProvider(() => 0.0);
  bool _shownUnrecognizedNotice = false;
  late final ScrollController _scrollController;
  late final isLocalArchive = widget.manga!.isLocalArchive ?? false;

  /// The detail overflow actions, shared by the popup menu off-TV and the
  /// centred TV menu.
  Future<void> _onDetailOverflow(int value) => handleDetailOverflowAction(
    value: value,
    context: context,
    ref: ref,
    manga: widget.manga!,
    isLocalArchive: isLocalArchive,
    checkForUpdate: widget.checkForUpdate,
  );

  @override
  Widget build(BuildContext context) {
    // On Android TV, anime gets a dedicated d-pad split detail (info left,
    // episodes right). Manga/novel and phones/desktop keep the classic detail.
    if (isTv && widget.itemType == ItemType.anime) {
      return TvAnimeDetailView(manga: widget.manga!);
    }
    // Watch all sort/filter providers so the list rebuilds whenever
    // the user changes settings in _showDraggableMenu().
    ref.watch(scanlatorsFilterStateProvider(widget.manga!));
    ref.watch(sortChapterStateProvider(mangaId: widget.manga!.id!));
    ref.watch(chapterFilterUnreadStateProvider(mangaId: widget.manga!.id!));
    ref.watch(chapterFilterBookmarkedStateProvider(mangaId: widget.manga!.id!));
    ref.watch(chapterFilterDownloadedStateProvider(mangaId: widget.manga!.id!));
    final chapters = ref.watch(
      getChaptersStreamProvider(mangaId: widget.manga!.id!),
    );
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;
        // Reset chapter selection so the top/bottom bars don't bleed into the library screen
        ref.read(isLongPressedStateProvider.notifier).update(false);
        ref.read(chaptersListStateProvider.notifier).clear();
      },
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            widget.isExtended(true);
          }
          if (notification.direction == ScrollDirection.reverse) {
            widget.isExtended(false);
          }
          return true;
        },
        child: chapters.when(
          data: (_) {
            List<Chapter> chapters = widget.manga!.getSortedFilteredChapters();
            ref.read(chaptersListttStateProvider.notifier).set(chapters);
            _notifyUnrecognizedChapterNumbers();
            return _buildWidget(chapters: chapters);
          },
          error: (Object error, StackTrace stackTrace) {
            return ErrorText(error);
          },
          loading: () {
            return _buildWidget(chapters: widget.manga!.chapters.toList());
          },
        ),
      ),
    );
  }

  Future<void> _downloadChaptersWithDestination(
    BuildContext context,
    List<Chapter> chapters,
  ) async {
    final chaptersToDownload = chapters.where((chapter) {
      final entry = downloadRepository.getByChapterId(chapter.id);
      return entry == null || !entry.isDownload!;
    }).toList();
    if (chaptersToDownload.isEmpty) return;

    for (final chapter in chaptersToDownload) {
      await downloadRepository.enqueue(chapter);
    }
    if (!mounted) return;
    ref.invalidate(processDownloadsProvider());
    ref.read(processDownloadsProvider());
  }

  Widget _buildWidget({required List<Chapter> chapters}) {
    final chapterList = ref.watch(chaptersListStateProvider);
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    return Stack(
      children: [
        DetailBanner(manga: widget.manga!, offsetProvider: offetProvider),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: DetailAppBar(
            manga: widget.manga!,
            itemType: widget.itemType,
            isLocalArchive: isLocalArchive,
            chapters: chapters,
            offsetProvider: offetProvider,
            onDownload: _downloadChaptersWithDestination,
            onShowFilterMenu: _showDraggableMenu,
            onOverflowAction: _onDetailOverflow,
          ),
          body: SafeArea(
            child: Row(
              children: [
                if (context.isTablet)
                  SizedBox(
                    width: context.width(0.5),
                    height: context.height(1),
                    child: SingleChildScrollView(
                      child: MangaInfoHeader(
                        manga: widget.manga!,
                        isLocalArchive: isLocalArchive,
                        titleDescription: widget.titleDescription!,
                        action: widget.action!,
                        chapterLength: chapters.length,
                      ),
                    ),
                  ),
                Expanded(
                  child: Scrollbar(
                    interactive: true,
                    thickness: 12,
                    radius: const Radius.circular(10),
                    controller: _scrollController,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 0, bottom: 60),
                          sliver: SuperSliverList.builder(
                            itemCount: chapters.length + 1,
                            itemBuilder: (context, index) {
                              final l10n = l10nLocalizations(context)!;
                              int finalIndex = index - 1;
                              if (index == 0) {
                                return context.isTablet
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: isLocalArchive
                                                  ? MainAxisAlignment
                                                        .spaceBetween
                                                  : MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: chapters.isEmpty
                                                      ? context.height(1)
                                                      : null,
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          widget
                                                                      .manga!
                                                                      .itemType !=
                                                                  ItemType.anime
                                                              ? l10n.n_chapters(
                                                                  chapters
                                                                      .length,
                                                                )
                                                              : l10n.n_episodes(
                                                                  chapters
                                                                      .length,
                                                                ),
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        Builder(
                                                          builder: (context) {
                                                            final missing = widget
                                                                .manga!
                                                                .missingChapterCount();
                                                            if (missing <= 0) {
                                                              return const SizedBox.shrink();
                                                            }
                                                            return Text(
                                                              widget.manga!.itemType !=
                                                                      ItemType
                                                                          .anime
                                                                  ? l10n.missing_chapters(
                                                                      missing,
                                                                    )
                                                                  : l10n.missing_episodes(
                                                                      missing,
                                                                    ),
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .red[400],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                if (isLocalArchive)
                                                  ElevatedButton.icon(
                                                    style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            5,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                      ),
                                                    ),
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: context
                                                          .secondaryColor,
                                                    ),
                                                    label: Text(
                                                      widget.manga!.itemType !=
                                                              ItemType.anime
                                                          ? l10n.add_chapters
                                                          : l10n.add_episodes,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: context
                                                            .secondaryColor,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      final manga =
                                                          widget.manga;
                                                      if (manga!.source ==
                                                          "torrent") {
                                                        addTorrent(
                                                          context,
                                                          manga: manga,
                                                        );
                                                      } else {
                                                        final splitChapters =
                                                            manga.itemType ==
                                                                ItemType.novel
                                                            ? await showSplitChaptersDialog(
                                                                context,
                                                              )
                                                            : true;
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        await ref.watch(
                                                          importArchivesFromFileProvider(
                                                            itemType:
                                                                manga.itemType,
                                                            manga,
                                                            init: false,
                                                            splitChapters:
                                                                splitChapters,
                                                          ).future,
                                                        );
                                                      }
                                                    },
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : MangaInfoHeader(
                                        manga: widget.manga!,
                                        isLocalArchive: isLocalArchive,
                                        titleDescription:
                                            widget.titleDescription!,
                                        action: widget.action!,
                                        chapterLength: chapters.length,
                                      );
                              }
                              return ChapterListTileWidget(
                                chapter: chapters[finalIndex],
                                manga: widget.manga!,
                                chapterList: chapterList,
                                allChapters: chapters,
                                sourceExist: widget.sourceExist,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Builder(
            builder: (context) {
              final chap = ref.watch(chaptersListStateProvider);
              bool getLength1 = chap.length == 1;
              bool checkFirstBookmarked =
                  chap.isNotEmpty && chap.first.isBookmarked! && getLength1;
              bool checkReadBookmarked =
                  chap.isNotEmpty && chap.first.isRead! && getLength1;
              final l10n = l10nLocalizations(context)!;
              final color = Theme.of(context).textTheme.bodyLarge!.color!;
              final downloadedIds =
                  ref.watch(downloadedChapterIdsProvider).asData?.value ??
                  const <int>{};
              final isDownloaded = chap
                  .where((c) => downloadedIds.contains(c.id))
                  .toSet();
              return BottomSelectBar(
                isVisible: isLongPressed,
                actions: [
                  BottomSelectButton(
                    icon: Icon(
                      checkFirstBookmarked
                          ? Icons.bookmark_remove_outlined
                          : Icons.bookmark_add_outlined,
                      color: color,
                    ),
                    onPressed: () {
                      final chapters = ref.watch(chaptersListStateProvider);
                      final List<Chapter> updatedChapters = [];
                      final now = DateTime.now().millisecondsSinceEpoch;
                      for (var chapter in chapters) {
                        chapter.isBookmarked = !chapter.isBookmarked!;
                        chapter.updatedAt = now;
                        chapter.manga.value = widget.manga;
                        updatedChapters.add(chapter);
                      }
                      chapterRepository.putAll(updatedChapters);
                      ref
                          .read(isLongPressedStateProvider.notifier)
                          .update(false);
                      ref.read(chaptersListStateProvider.notifier).clear();
                    },
                  ),
                  BottomSelectButton(
                    icon: Icon(
                      checkReadBookmarked
                          ? Icons.remove_done_sharp
                          : Icons.done_all_sharp,
                      color: color,
                    ),
                    onPressed: () {
                      final chapters = ref.watch(chaptersListStateProvider);
                      final markAsRead = bulkChapterTargetReadState(chapters);
                      final List<Chapter> updatedChapters = [];
                      final now = DateTime.now().millisecondsSinceEpoch;
                      Chapter? highestChapter;
                      int highestNum = -1;
                      final recognition = ChapterRecognition();
                      final mangaTitle = widget.manga!.name ?? '';
                      for (var chapter in chapters) {
                        chapter.isRead = markAsRead;
                        if (!chapter.isRead!) chapter.lastPageRead = "1";
                        chapter.updatedAt = now;
                        chapter.manga.value = widget.manga;
                        updatedChapters.add(chapter);
                        if (chapter.isRead!) {
                          final num = recognition.parseEpisodeNumber(
                            mangaTitle,
                            chapter.name ?? '',
                          );
                          if (num > highestNum) {
                            highestNum = num;
                            highestChapter = chapter;
                          }
                        }
                      }
                      highestChapter?.updateTrackChapterRead(ref);
                      chapterRepository.putAllWithManga(
                        updatedChapters,
                        widget.manga!,
                      );
                      ref
                          .read(isLongPressedStateProvider.notifier)
                          .update(false);
                      ref.read(chaptersListStateProvider.notifier).clear();
                    },
                  ),
                  if (getLength1)
                    BottomSelectButton(
                      icon: Stack(
                        children: [
                          Icon(Icons.done_outlined, color: color),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              Icons.arrow_downward_outlined,
                              size: 11,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        int index = chapters.indexOf(chap.first);
                        final List<Chapter> updatedChapters = [];
                        final now = DateTime.now().millisecondsSinceEpoch;
                        chapters[index + 1].updateTrackChapterRead(ref);
                        for (var i = index + 1; i < chapters.length; i++) {
                          final chapter = chapters[i];
                          if (!chapter.isRead!) {
                            chapter.isRead = true;
                            chapter.lastPageRead = "1";
                            chapter.updatedAt = now;
                            chapter.manga.value = widget.manga;
                            updatedChapters.add(chapter);
                          }
                        }
                        chapterRepository.putAllWithManga(
                          updatedChapters,
                          widget.manga!,
                        );
                        ref
                            .read(isLongPressedStateProvider.notifier)
                            .update(false);
                        ref.read(chaptersListStateProvider.notifier).clear();
                      },
                    ),
                  // If not local archive and not downloaded, show download button
                  if (!isLocalArchive && isDownloaded.isEmpty && !isTv)
                    BottomSelectButton(
                      icon: Icon(Icons.download_outlined, color: color),
                      onPressed: () async {
                        await _downloadChaptersWithDestination(
                          context,
                          ref.read(chaptersListStateProvider),
                        );
                        ref
                            .read(isLongPressedStateProvider.notifier)
                            .update(false);
                        ref.read(chaptersListStateProvider.notifier).clear();
                      },
                    ),
                  // show delete button if local archive or downloaded
                  if (isLocalArchive || isDownloaded.isNotEmpty)
                    BottomSelectButton(
                      icon: Icon(Icons.delete_outline_outlined, color: color),
                      onPressed: () {
                        final selectedChapters = ref.watch(
                          chaptersListStateProvider,
                        );
                        final totalChapters = widget.manga!.chapters.length;
                        final isLastChapters =
                            selectedChapters.length == totalChapters;
                        final isAnime = widget.itemType == ItemType.anime;
                        final entryType = isAnime ? l10n.episode : l10n.chapter;
                        final pluralEntryType = isAnime
                            ? l10n.episodes
                            : l10n.chapters;
                        final mediaType = isAnime ? l10n.anime : l10n.manga;
                        final warningMessage = l10n.last_entry_delete_warning(
                          totalChapters,
                          entryType,
                          pluralEntryType,
                          mediaType,
                        );
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(l10n.delete_chapters),
                              content: isLocalArchive && isLastChapters
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.orange,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            warningMessage,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(l10n.cancel),
                                    ),
                                    const SizedBox(width: 15),
                                    TextButton(
                                      onPressed: () async {
                                        final navigator = Navigator.of(context);
                                        if (isLocalArchive) {
                                          final idsToDelete = selectedChapters
                                              .map((c) => c.id!)
                                              .toList();
                                          await chapterRepository.deleteAll(
                                            idsToDelete,
                                          );
                                        }
                                        for (final chapter in isDownloaded) {
                                          await chapter.deleteDownloadedFiles();
                                        }
                                        if (!mounted) return;
                                        ref
                                            .read(
                                              isLongPressedStateProvider
                                                  .notifier,
                                            )
                                            .update(false);
                                        ref
                                            .read(
                                              chaptersListStateProvider
                                                  .notifier,
                                            )
                                            .clear();
                                        navigator.pop();
                                        if (isLocalArchive && isLastChapters) {
                                          navigator.pop();
                                          Future.delayed(
                                            const Duration(milliseconds: 350),
                                            () {
                                              mangaRepository.delete(
                                                widget.manga!.id!,
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Text(l10n.delete),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDraggableMenu() {
    final scanlators = ref.read(scanlatorsFilterStateProvider(widget.manga!));
    final l10n = l10nLocalizations(context)!;
    customDraggableTabBar(
      tabs: [
        Tab(text: l10n.filter),
        Tab(text: l10n.sort),
        Tab(text: l10n.display),
      ],
      children: [
        Consumer(
          builder: (context, ref, child) {
            return Column(
              children: [
                if (!isLocalArchive)
                  ListTileChapterFilter(
                    label: l10n.downloaded,
                    type: ref.watch(
                      chapterFilterDownloadedStateProvider(
                        mangaId: widget.manga!.id!,
                      ),
                    ),
                    onTap: () {
                      ref
                          .read(
                            chapterFilterDownloadedStateProvider(
                              mangaId: widget.manga!.id!,
                            ).notifier,
                          )
                          .update();
                    },
                  ),
                ListTileChapterFilter(
                  label: widget.itemType != ItemType.anime
                      ? l10n.unread
                      : l10n.unwatched,
                  type: ref.watch(
                    chapterFilterUnreadStateProvider(
                      mangaId: widget.manga!.id!,
                    ),
                  ),
                  onTap: () {
                    ref
                        .read(
                          chapterFilterUnreadStateProvider(
                            mangaId: widget.manga!.id!,
                          ).notifier,
                        )
                        .update();
                  },
                ),
                ListTileChapterFilter(
                  label: l10n.bookmarked,
                  type: ref.watch(
                    chapterFilterBookmarkedStateProvider(
                      mangaId: widget.manga!.id!,
                    ),
                  ),
                  onTap: () {
                    ref
                        .read(
                          chapterFilterBookmarkedStateProvider(
                            mangaId: widget.manga!.id!,
                          ).notifier,
                        )
                        .update();
                  },
                ),
                if (scanlators.$1.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Consumer(
                                    builder: (context, ref, child) {
                                      final scanlators = ref.watch(
                                        scanlatorsFilterStateProvider(
                                          widget.manga!,
                                        ),
                                      );
                                      return AlertDialog(
                                        title: Text(
                                          l10n.filter_scanlator_groups,
                                        ),
                                        content: SizedBox(
                                          width: context.width(0.8),
                                          child: SuperListView.builder(
                                            shrinkWrap: true,
                                            itemCount: scanlators.$1.length,
                                            itemBuilder: (context, index) {
                                              return ListTileChapterFilter(
                                                label: scanlators.$1[index],
                                                type:
                                                    scanlators.$3.contains(
                                                      scanlators.$1[index],
                                                    )
                                                    ? 2
                                                    : 0,
                                                onTap: () {
                                                  ref
                                                      .read(
                                                        scanlatorsFilterStateProvider(
                                                          widget.manga!,
                                                        ).notifier,
                                                      )
                                                      .setFilteredList(
                                                        scanlators.$1[index],
                                                      );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        actions: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            ref
                                                                .read(
                                                                  scanlatorsFilterStateProvider(
                                                                    widget
                                                                        .manga!,
                                                                  ).notifier,
                                                                )
                                                                .set([]);
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Text(
                                                            l10n.reset,
                                                            style: TextStyle(
                                                              color: context
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Text(
                                                          l10n.cancel,
                                                          style: TextStyle(
                                                            color: context
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          ref
                                                              .read(
                                                                scanlatorsFilterStateProvider(
                                                                  widget.manga!,
                                                                ).notifier,
                                                              )
                                                              .set(
                                                                scanlators.$3,
                                                              );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Text(
                                                          l10n.filter,
                                                          style: TextStyle(
                                                            color: context
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Text(l10n.filter_scanlator_groups),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        Consumer(
          builder: (context, ref, chil) {
            final reverse = ref
                .read(
                  sortChapterStateProvider(mangaId: widget.manga!.id!).notifier,
                )
                .isReverse();
            final scanlators = ref.watch(
              scanlatorsFilterStateProvider(widget.manga!),
            );
            final reverseChapter = ref.watch(
              sortChapterStateProvider(mangaId: widget.manga!.id!),
            );
            return Column(
              children: [
                if (scanlators.$1.isNotEmpty)
                  ListTileChapterSort(
                    label: _getSortNameByIndex(0, context),
                    reverse: reverse,
                    onTap: () {
                      ref
                          .read(
                            sortChapterStateProvider(mangaId: widget.manga!.id!)
                                .notifier,
                          )
                          .set(0);
                    },
                    showLeading: reverseChapter.index == 0,
                  ),
                for (var i = 1; i < 4; i++)
                  ListTileChapterSort(
                    label: _getSortNameByIndex(i, context),
                    reverse: reverse,
                    onTap: () {
                      ref
                          .read(
                            sortChapterStateProvider(mangaId: widget.manga!.id!)
                                .notifier,
                          )
                          .set(i);
                    },
                    showLeading: reverseChapter.index == i,
                  ),
              ],
            );
          },
        ),
        RadioGroup(
          groupValue: "e",
          onChanged: (value) {},
          child: Column(
            children: [
              RadioListTile(
                dense: true,
                title: Text(l10n.source_title),
                value: "e",
                selected: true,
              ),
              RadioListTile(
                dense: true,
                title: Text(
                  widget.itemType != ItemType.anime
                      ? l10n.chapter_number
                      : l10n.episode_number,
                ),
                value: "ej",
                selected: false,
              ),
            ],
          ),
        ),
      ],
      context: context,
      vsync: this,
    );
  }

  String _getSortNameByIndex(int index, BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (index == 0) {
      return l10n.by_scanlator;
    } else if (index == 1) {
      return widget.itemType != ItemType.anime
          ? l10n.by_chapter_number
          : l10n.by_episode_number;
    } else if (index == 2) {
      return l10n.by_upload_date;
    }
    return l10n.by_name;
  }
}
