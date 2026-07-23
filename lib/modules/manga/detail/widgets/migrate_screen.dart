import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/mass_migration/services/mass_migration_service.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';

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
  // Set once the first source row with results has taken the TV autofocus, so
  // no other row steals it afterwards.
  bool _autofocusClaimed = false;
  bool _claimAutofocus() {
    if (_autofocusClaimed) return false;
    _autofocusClaimed = true;
    return true;
  }

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
                // Yield a frame so the empty state is rendered before re-querying
                await WidgetsBinding.instance.endOfFrame;
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
              padding: tvPageInsets,
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
                    isFirst: index == 0,
                    claimAutofocus: isTv ? _claimAutofocus : null,
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
  // Whether this is the first source row (gets first shot at claiming the TV
  // autofocus so the highlight lands at the top when it has results).
  final bool isFirst;
  // Returns true for exactly the first caller that has results, so on TV the
  // first non-empty source claims the initial focus even when an earlier source
  // returned nothing. Null off-TV.
  final bool Function()? claimAutofocus;
  const MigrationSourceSearchScreen({
    super.key,
    required this.query,
    required this.manga,
    required this.source,
    this.trackSearch,
    this.isFirst = false,
    this.claimAutofocus,
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
  bool _autofocusFirst = false;
  MPages? pages;
  Future<void> _init() async {
    try {
      _errorMessage = "";
      pages = await ref.read(
        searchProvider(
          source: widget.source,
          page: 1,
          query: widget.query,
          filterList: const [],
        ).future,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Claim the TV autofocus if this source has results. The first row
        // claims immediately; later rows wait a beat so the first still wins
        // when it also has results, but a lower row grabs focus if the first
        // came back empty.
        final claim = widget.claimAutofocus;
        if (claim != null && (pages?.list.isNotEmpty ?? false)) {
          if (!widget.isFirst) {
            await Future.delayed(const Duration(milliseconds: 150));
          }
          if (mounted && claim()) {
            setState(() => _autofocusFirst = true);
          }
        }
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
                                autofocus: _autofocusFirst && index == 0,
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
  final bool autofocus;

  const MigrationMangaGlobalImageCard({
    super.key,
    required this.oldManga,
    required this.manga,
    required this.source,
    this.trackSearch,
    this.autofocus = false,
  });

  @override
  ConsumerState<MigrationMangaGlobalImageCard> createState() =>
      _MigrationMangaGlobalImageCardState();
}

class _MigrationMangaGlobalImageCardState
    extends ConsumerState<MigrationMangaGlobalImageCard>
    with AutomaticKeepAliveClientMixin<MigrationMangaGlobalImageCard> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = l10nLocalizations(context)!;
    final getMangaDetail = widget.manga;
    // A bare GestureDetector never takes focus, so on a remote these covers were
    // unreachable. Match the global-search / library covers: focusable, accent
    // ring plus a lift, opens on OK.
    return Focus(
      autofocus: widget.autofocus,
      onFocusChange: (f) {
        setState(() => _focused = f);
        if (f && context.mounted && Scrollable.maybeOf(context) != null) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.5,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && tvIsSelectKey(event.logicalKey)) {
          _showMigrateDialog(context, l10n);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      // Padding outside the scale so the focused cover grows into it.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..scaleByDouble(
              _focused ? 1.06 : 1.0,
              _focused ? 1.06 : 1.0,
              _focused ? 1.06 : 1.0,
              1,
            ),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _focused ? context.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: GestureDetector(
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
                return Stack(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Column(
                        children: [
                          Builder(
                            builder: (context) {
                              if (hasData &&
                                  snapshot.data!.first.customCoverImage !=
                                      null) {
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
                            textColor: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.color,
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
                );
              },
            ),
          ),
        ),
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
                                      widgetRef: ref,
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
    await migrateLibraryItem(
      ref: ref,
      oldManga: widget.oldManga,
      selectedManga: widget.manga,
      preview: preview,
      destinationSource: widget.source,
    );
  }
}

class SuperPrecalculationPolicy extends ExtentPrecalculationPolicy {
  @override
  bool shouldPrecalculateExtents(ExtentPrecalculationContext context) {
    return context.numberOfItems < 100;
  }
}
