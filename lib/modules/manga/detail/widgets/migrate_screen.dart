import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/services/search_.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class MigrationScreen extends ConsumerStatefulWidget {
  final Manga manga;
  final TrackSearch? trackSearch;
  const MigrationScreen({required this.manga, this.trackSearch, super.key});

  @override
  ConsumerState<MigrationScreen> createState() => _MigrationScreenScreenState();
}

class _MigrationScreenScreenState extends ConsumerState<MigrationScreen> {
  String _query = "";
  final _textEditingController = TextEditingController();
  late final List<Source> sourceList =
      ref.read(onlyIncludePinnedSourceStateProvider)
      ? isar.sources
            .filter()
            .isPinnedEqualTo(true)
            .and()
            .itemTypeEqualTo(widget.manga.itemType)
            .findAllSync()
      : isar.sources
            .filter()
            .idIsNotNull()
            .and()
            .isAddedEqualTo(true)
            .and()
            .itemTypeEqualTo(widget.manga.itemType)
            .findAllSync();
  @override
  void initState() {
    super.initState();
    final query = widget.manga.name ?? widget.manga.author ?? "";
    _textEditingController.text = query;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final query = _query.isNotEmpty
        ? _query
        : widget.manga.name ?? widget.manga.author ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.trackSearch == null ? l10n.migrate : l10n.track_library_add,
        ),
        leading: Container(),
        actions: [
          SeachFormTextField(
            onChanged: (value) {},
            onPressed: () {
              Navigator.pop(context);
            },
            onFieldSubmitted: (value) async {
              if (!(_query == _textEditingController.text)) {
                setState(() {
                  _query = "";
                });
                await Future.delayed(const Duration(milliseconds: 10));
                setState(() {
                  _query = value;
                });
              }
            },
            onSuffixPressed: () {
              _textEditingController.clear();
              setState(() {
                _query = "";
              });
            },
            controller: _textEditingController,
            autofocus: false,
          ),
        ],
      ),
      body:
          _query.isNotEmpty ||
              (widget.manga.name != null && widget.manga.author != null)
          ? SuperListView.builder(
              itemCount: sourceList.length,
              extentPrecalculationPolicy: SuperPrecalculationPolicy(),
              itemBuilder: (context, index) {
                final source = sourceList[index];
                return SizedBox(
                  height: 260,
                  child: MigrationSourceSearchScreen(
                    key: ValueKey(query),
                    query: query,
                    manga: widget.manga,
                    source: source,
                    trackSearch: widget.trackSearch,
                  ),
                );
              },
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}

class MigrationSourceSearchScreen extends ConsumerStatefulWidget {
  final String query;
  final Manga manga;
  final TrackSearch? trackSearch;

  final Source source;
  const MigrationSourceSearchScreen({
    super.key,
    required this.query,
    required this.manga,
    required this.source,
    this.trackSearch,
  });

  @override
  ConsumerState<MigrationSourceSearchScreen> createState() =>
      _MigrationSourceSearchScreenState();
}

class _MigrationSourceSearchScreenState
    extends ConsumerState<MigrationSourceSearchScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  String _errorMessage = "";
  bool _isLoading = true;
  MPages? pages;
  _init() async {
    try {
      _errorMessage = "";
      pages = await ref.read(
        searchProvider(
          source: widget.source,
          page: 1,
          query: widget.query,
          filterList: [],
        ).future,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return Scaffold(
      body: SizedBox(
        height: 260,
        child: Column(
          children: [
            ListTile(
              dense: true,
              title: Text(widget.source.name!),
              subtitle: Text(
                completeLanguageName(widget.source.lang!),
                style: const TextStyle(fontSize: 10),
              ),
            ),
            Flexible(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Builder(
                      builder: (context) {
                        if (_errorMessage.isNotEmpty) {
                          return Center(child: Text(_errorMessage));
                        }
                        if (pages!.list.isNotEmpty) {
                          return SuperListView.builder(
                            extentPrecalculationPolicy:
                                SuperPrecalculationPolicy(),
                            scrollDirection: Axis.horizontal,
                            itemCount: pages!.list.length,
                            itemBuilder: (context, index) {
                              return MigrationMangaGlobalImageCard(
                                oldManga: widget.manga,
                                manga: pages!.list[index],
                                source: widget.source,
                                trackSearch: widget.trackSearch,
                              );
                            },
                          );
                        }
                        return Center(child: Text(l10n.no_result));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class MigrationMangaGlobalImageCard extends ConsumerStatefulWidget {
  final Manga oldManga;
  final MManga manga;
  final Source source;
  final TrackSearch? trackSearch;

  const MigrationMangaGlobalImageCard({
    super.key,
    required this.oldManga,
    required this.manga,
    required this.source,
    this.trackSearch,
  });

  @override
  ConsumerState<MigrationMangaGlobalImageCard> createState() =>
      _MigrationMangaGlobalImageCardState();
}

class _MigrationMangaGlobalImageCardState
    extends ConsumerState<MigrationMangaGlobalImageCard>
    with AutomaticKeepAliveClientMixin<MigrationMangaGlobalImageCard> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = l10nLocalizations(context)!;
    final getMangaDetail = widget.manga;
    return GestureDetector(
      onTap: () => _showMigrateDialog(context, l10n),
      child: StreamBuilder(
        stream: isar.mangas
            .filter()
            .langEqualTo(widget.source.lang)
            .nameEqualTo(getMangaDetail.name)
            .sourceEqualTo(widget.source.name)
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          final hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Stack(
              children: [
                SizedBox(
                  width: 110,
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          if (hasData &&
                              snapshot.data!.first.customCoverImage != null) {
                            return Image.memory(
                              snapshot.data!.first.customCoverImage
                                  as Uint8List,
                            );
                          }
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: cachedNetworkImage(
                              headers: ref.watch(
                                headersProvider(
                                  source: widget.source.name!,
                                  lang: widget.source.lang!,
                                  sourceId: widget.source.id,
                                ),
                              ),
                              imageUrl: toImgUrl(
                                hasData
                                    ? snapshot
                                              .data!
                                              .first
                                              .customCoverFromTracker ??
                                          snapshot.data!.first.imageUrl ??
                                          ""
                                    : getMangaDetail.imageUrl ?? "",
                              ),
                              width: 110,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                      BottomTextWidget(
                        fontSize: 12.0,
                        text: widget.manga.name!,
                        isLoading: true,
                        textColor: Theme.of(context).textTheme.bodyLarge!.color,
                        isComfortableGrid: true,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 110,
                  height: 150,
                  color: hasData && snapshot.data!.first.favorite!
                      ? Colors.black.withValues(alpha: 0.7)
                      : null,
                ),
                if (hasData && snapshot.data!.first.favorite!)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.collections_bookmark,
                        color: context.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _showMigrateDialog(BuildContext context, dynamic l10n) {
    ref
        .watch(
          getDetailProvider(
            url: widget.manga.link!,
            source: widget.source,
          ).future,
        )
        .then((preview) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text(
                    widget.trackSearch == null
                        ? l10n.migrate_confirm
                        : l10n.track_library_add_confirm,
                  ),
                  content: preview.chapters != null
                      ? SizedBox(
                          height: ctx.height(0.5),
                          width: ctx.width(1),
                          child: CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.all(0),
                                sliver: SuperSliverList.builder(
                                  itemCount: preview.chapters!.length,
                                  itemBuilder: (context, index) {
                                    final chapter = preview.chapters![index];
                                    return ListTile(
                                      title: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              preview.chapters![index].name!,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                            chapter.dateUpload == null ||
                                                    chapter.dateUpload!.isEmpty
                                                ? ""
                                                : dateFormat(
                                                    chapter.dateUpload!,
                                                    ref: ref,
                                                    context: context,
                                                  ),
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                          if (chapter.scanlator?.isNotEmpty ??
                                              false)
                                            Row(
                                              children: [
                                                const Text(' • '),
                                                Text(
                                                  chapter.scanlator!,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(l10n.n_chapters(0)),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          child: Text(l10n.cancel),
                        ),
                        const SizedBox(width: 15),
                        Consumer(
                          builder: (context, ref, child) => TextButton(
                            onPressed: () async {
                              if (widget.trackSearch == null) {
                                await _migrateManga(preview);
                                if (ctx.mounted) {
                                  Navigator.pop(ctx);
                                  Navigator.pop(ctx);
                                }
                              } else {
                                await _addTrackManga(context);
                              }
                            },
                            child: Text(l10n.ok),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
        });
  }

  Future<void> _addTrackManga(BuildContext context) async {
    List<int> categoryIds = [];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final l10n = l10nLocalizations(context)!;
            return AlertDialog(
              title: Text(l10n.set_categories),
              content: SizedBox(
                width: context.width(0.8),
                child: StreamBuilder(
                  stream: isar.categorys
                      .filter()
                      .idIsNotNull()
                      .and()
                      .forItemTypeEqualTo(widget.oldManga.itemType)
                      .watch(fireImmediately: true),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final entries = snapshot.data!;
                      return SuperListView.builder(
                        shrinkWrap: true,
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          return ListTileChapterFilter(
                            label: entries[index].name!,
                            onTap: () {
                              setState(() {
                                if (categoryIds.contains(entries[index].id)) {
                                  categoryIds.remove(entries[index].id);
                                } else {
                                  categoryIds.add(entries[index].id!);
                                }
                              });
                            },
                            type: categoryIds.contains(entries[index].id)
                                ? 1
                                : 0,
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.push(
                          "/categories",
                          extra: (
                            true,
                            widget.oldManga.itemType == ItemType.manga
                                ? 0
                                : widget.oldManga.itemType == ItemType.anime
                                ? 1
                                : 2,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(l10n.edit),
                    ),
                    Row(
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
                            final model = widget.manga;
                            final manga = Manga(
                              name: model.name,
                              artist: model.artist,
                              author: model.author,
                              description: model.description,
                              imageUrl: model.imageUrl,
                              link: model.link,
                              genre: model.genre,
                              status: model.status ?? Status.unknown,
                              source: widget.source.name,
                              lang: widget.source.lang,
                              itemType: widget.oldManga.itemType,
                              favorite: true,
                              categories: categoryIds,
                              dateAdded: DateTime.now().millisecondsSinceEpoch,
                              updatedAt: DateTime.now().millisecondsSinceEpoch,
                              sourceId: widget.source.id,
                            );
                            int mangaId = -1;
                            isar.writeTxnSync(() {
                              mangaId = isar.mangas.putSync(manga);
                            });
                            if (mangaId != -1) {
                              await ref
                                  .read(
                                    trackStateProvider(
                                      track: null,
                                      itemType: widget.oldManga.itemType,
                                    ).notifier,
                                  )
                                  .setTrackSearch(
                                    widget.trackSearch!,
                                    mangaId,
                                    widget.trackSearch!.syncId!,
                                  );
                            }
                            if (context.mounted) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(l10n.ok),
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
  }

  Future<void> _migrateManga(MManga preview) async {
    String? historyChapter;
    String? historyDate;
    List<Chapter> chaptersProgress = [];
    isar.writeTxnSync(() {
      final histories = isar.historys
          .filter()
          .mangaIdEqualTo(widget.oldManga.id)
          .sortByDate()
          .findAllSync();
      historyChapter = _extractChapterNumber(
        histories.lastOrNull?.chapter.value?.name ?? "",
      );
      historyDate = histories.lastOrNull?.date;
      for (var history in histories) {
        isar.historys.deleteSync(history.id!);
        ref
            .read(synchingProvider(syncId: 1).notifier)
            .addChangedPart(ActionType.removeHistory, history.id, "{}", false);
      }
      for (var chapter in widget.oldManga.chapters) {
        chaptersProgress.add(chapter);
        isar.updates
            .filter()
            .mangaIdEqualTo(chapter.mangaId)
            .chapterNameEqualTo(chapter.name)
            .deleteAllSync();
        isar.chapters.deleteSync(chapter.id!);
        ref
            .read(synchingProvider(syncId: 1).notifier)
            .addChangedPart(ActionType.removeChapter, chapter.id, "{}", false);
      }
      widget.oldManga.name = widget.manga.name;
      widget.oldManga.link = widget.manga.link;
      widget.oldManga.imageUrl = widget.manga.imageUrl;
      widget.oldManga.lang = widget.source.lang;
      widget.oldManga.source = widget.source.name;
      widget.oldManga.artist = preview.artist;
      widget.oldManga.author = preview.author;
      widget.oldManga.status = preview.status ?? widget.oldManga.status;
      widget.oldManga.description = preview.description;
      widget.oldManga.genre = preview.genre;
      widget.oldManga.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.mangas.putSync(widget.oldManga);
    });
    await ref.read(
      updateMangaDetailProvider(
        mangaId: widget.oldManga.id,
        isInit: false,
      ).future,
    );
    isar.writeTxnSync(() {
      for (var oldChapter in chaptersProgress) {
        final chapter = isar.chapters
            .filter()
            .mangaIdEqualTo(widget.oldManga.id)
            .nameContains(
              _extractChapterNumber(oldChapter.name ?? "") ?? ".....",
              caseSensitive: false,
            )
            .findFirstSync();
        if (chapter != null) {
          chapter.isBookmarked = oldChapter.isBookmarked;
          chapter.lastPageRead = oldChapter.lastPageRead;
          chapter.isRead = oldChapter.isRead;
          isar.chapters.putSync(chapter);
        }
      }
      final chapter = isar.chapters
          .filter()
          .mangaIdEqualTo(widget.oldManga.id)
          .nameContains(historyChapter ?? ".....", caseSensitive: false)
          .findFirstSync();
      if (chapter != null) {
        isar.historys.putSync(
          History(
            mangaId: widget.oldManga.id,
            date:
                historyDate ?? DateTime.now().millisecondsSinceEpoch.toString(),
            itemType: widget.oldManga.itemType,
            chapterId: chapter.id,
          )..chapter.value = chapter,
        );
      }
    });
    ref.invalidate(getMangaDetailStreamProvider(mangaId: widget.oldManga.id!));
  }

  String? _extractChapterNumber(String chapterName) {
    return RegExp(
          r'\s*(\d+\.\d+)\s*',
          multiLine: true,
        ).firstMatch(chapterName)?.group(0) ??
        RegExp(
          r'\s*(\d+)\s*',
          multiLine: true,
        ).firstMatch(chapterName)?.group(0);
  }
}

class SuperPrecalculationPolicy extends ExtentPrecalculationPolicy {
  @override
  bool shouldPrecalculateExtents(ExtentPrecalculationContext context) {
    return context.numberOfItems < 100;
  }
}
