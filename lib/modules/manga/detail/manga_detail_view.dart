import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_quick_filters.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/detail/providers/chapter_display.dart';
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
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/riverpod.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/modules/manga/detail/widgets/read_action.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';

class MangaDetailView extends ConsumerStatefulWidget {
  final Widget? titleDescription;
  final List<Color>? backButtonColors;
  final Widget? action;
  final Manga? manga;
  final bool sourceExist;
  final Function(bool) checkForUpdate;
  final ItemType itemType;

  const MangaDetailView({
    super.key,
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
    _listController.dispose();
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

  /// Lets "Current chapter" scroll a list of a thousand chapters to the one
  /// being read, without laying out everything in between.
  final _listController = ListController();

  /// Scrolls to [chapter] in [chapters], or does nothing when it is not in
  /// the list as filtered now.
  void _jumpTo(List<Chapter> chapters, Chapter chapter) {
    final index = chapters.indexWhere((c) => c.id == chapter.id);
    if (index < 0) return;
    _listController.animateToItem(
      // The header is the list's first item.
      index: index + 1,
      scrollController: _scrollController,
      alignment: 0.3,
      duration: (_) => ShioriMotion.of(context, ShioriMotion.enter),
      curve: (_) => ShioriMotion.enterCurve,
    );
  }

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
      child: chapters.when(
        data: (_) {
          List<Chapter> chapters = widget.manga!.getSortedFilteredChapters();
          ref.read(chaptersListttStateProvider.notifier).set(chapters);
          _notifyUnrecognizedChapterNumbers();
          return _buildWidget(chapters: chapters);
        },
        error: (Object error, StackTrace stackTrace) {
          return ErrorState(detail: error.toString());
        },
        loading: () {
          return _buildWidget(chapters: widget.manga!.chapters.toList());
        },
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
    final current = resumeChapterFor(
      widget.manga!,
      incognito: ref.watch(incognitoModeStateProvider),
    );
    final onJumpToCurrent =
        current != null && chapters.any((c) => c.id == current.id)
        ? () => _jumpTo(chapters, current)
        : null;
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
                        onJumpToCurrent: onJumpToCurrent,
                      ),
                    ),
                  ),
                Expanded(
                  child: Scrollbar(
                    interactive: true,
                    thickness: 12,
                    radius: const Radius.circular(ShioriShape.card),
                    controller: _scrollController,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 0, bottom: 60),
                          sliver: SuperSliverList.builder(
                            listController: _listController,
                            itemCount: chapters.length + 1,
                            itemBuilder: (context, index) {
                              final l10n = l10nLocalizations(context)!;
                              int finalIndex = index - 1;
                              if (index == 0) {
                                return context.isTablet
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(
                                              ShioriSpace.s8,
                                            ),
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
                                                  color:
                                                      context.shiori.color.ink0,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal:
                                                              ShioriSpace.s8,
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
                                                          style: context
                                                              .shiori
                                                              .text
                                                              .section
                                                              .copyWith(
                                                                color: context
                                                                    .shiori
                                                                    .color
                                                                    .fg,
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
                                                              style: context
                                                                  .shiori
                                                                  .text
                                                                  .meta
                                                                  .copyWith(
                                                                    color: context
                                                                        .shiori
                                                                        .color
                                                                        .error
                                                                        .foreground,
                                                                  ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                if (onJumpToCurrent != null)
                                                  ShioriButton.quiet(
                                                    icon: Symbols
                                                        .my_location_rounded,
                                                    label: l10n.current_chapter,
                                                    onPressed: onJumpToCurrent,
                                                  ),
                                                if (isLocalArchive)
                                                  ShioriButton.secondary(
                                                    icon: Symbols.add_rounded,
                                                    label:
                                                        widget
                                                                .manga!
                                                                .itemType !=
                                                            ItemType.anime
                                                        ? l10n.add_chapters
                                                        : l10n.add_episodes,
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
                                          ChapterQuickFilters(
                                            manga: widget.manga!,
                                            onMore: _showDraggableMenu,
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
                                        onJumpToCurrent: onJumpToCurrent,
                                        chapterFilters: ChapterQuickFilters(
                                          manga: widget.manga!,
                                          onMore: _showDraggableMenu,
                                        ),
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
                    tooltip: checkFirstBookmarked
                        ? l10n.remove_bookmark
                        : l10n.bookmark,
                    icon: Icon(
                      checkFirstBookmarked
                          ? Symbols.bookmark_remove_rounded
                          : Symbols.bookmark_add_rounded,
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
                    tooltip: checkReadBookmarked
                        ? l10n.mark_as_unread
                        : l10n.mark_as_read,
                    icon: Icon(
                      checkReadBookmarked
                          ? Symbols.remove_done_rounded
                          : Symbols.done_all_rounded,
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
                      tooltip: l10n.mark_below_as_read,
                      icon: const Icon(Symbols.done_rounded),
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
                      tooltip: l10n.download,
                      icon: const Icon(Symbols.download_rounded),
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
                      tooltip: l10n.delete,
                      icon: const Icon(Symbols.delete_rounded),
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
                            return ShioriDialog(
                              title: l10n.delete_chapters,
                              content: isLocalArchive && isLastChapters
                                  ? Text(
                                      warningMessage,
                                      style: TextStyle(
                                        color: context
                                            .shiori
                                            .color
                                            .error
                                            .foreground,
                                      ),
                                    )
                                  : null,
                              actions: [
                                ShioriButton.quiet(
                                  label: l10n.cancel,
                                  onPressed: () => Navigator.pop(context),
                                ),
                                ShioriButton(
                                  label: l10n.delete,
                                  destructive: true,
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
                                          isLongPressedStateProvider.notifier,
                                        )
                                        .update(false);
                                    ref
                                        .read(
                                          chaptersListStateProvider.notifier,
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
                  ShioriSettingRow(
                    icon: Symbols.group_rounded,
                    title: l10n.filter_scanlator_groups,
                    subtitle: scanlators.$2.isEmpty
                        ? null
                        : '${scanlators.$1.length - scanlators.$2.length} / ${scanlators.$1.length}',
                    onTap: () async {
                      // Ticked is shown; what is stored is what is left out.
                      final shown = await showShioriMultiChoice<String>(
                        context,
                        title: l10n.filter_scanlator_groups,
                        confirmLabel: l10n.filter,
                        selected: {
                          for (final g in scanlators.$1)
                            if (!scanlators.$2.contains(g)) g,
                        },
                        options: [
                          for (final g in scanlators.$1) ShioriChoice(g, g),
                        ],
                      );
                      if (shown == null) return;
                      ref
                          .read(
                            scanlatorsFilterStateProvider(widget.manga!)
                                .notifier,
                          )
                          .set([
                            for (final g in scanlators.$1)
                              if (!shown.contains(g)) g,
                          ]);
                    },
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
        // How each chapter is named in the list: as the source titles it,
        // or by its number.
        Consumer(
          builder: (context, ref, _) {
            final byNumber = ref.watch(
              chapterNumberDisplayProvider.select(
                (ids) => ids.contains(widget.manga!.id),
              ),
            );
            void set(bool value) => ref
                .read(chapterNumberDisplayProvider.notifier)
                .set(widget.manga!.id!, byNumber: value);
            return Column(
              children: [
                _DisplayChoiceRow(
                  label: l10n.source_title,
                  selected: !byNumber,
                  onTap: () => set(false),
                ),
                _DisplayChoiceRow(
                  label: widget.itemType != ItemType.anime
                      ? l10n.chapter_number
                      : l10n.episode_number,
                  selected: byNumber,
                  onTap: () => set(true),
                ),
              ],
            );
          },
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

/// One choice of the Display tab, laid out as the Filter tab's rows: the
/// same inset, height and icon size, with a radio mark for the checkbox.
/// Material's radio tiles sat further in than the rows beside them.
class _DisplayChoiceRow extends StatelessWidget {
  const _DisplayChoiceRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    return MergeSemantics(
      child: Semantics(
        checked: selected,
        inMutuallyExclusiveGroup: true,
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            dense: true,
            minTileHeight: tokens.density.minTarget,
            leading: Icon(
              selected
                  ? Symbols.radio_button_checked_rounded
                  : Symbols.radio_button_unchecked_rounded,
              color: selected ? c.accentInk : c.fgMuted,
              size: tokens.scaled(24),
            ),
            title: Text(label, style: tokens.text.row.copyWith(color: c.fg)),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
