import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/modules/browse/widgets/source_code_error_banner.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/manga/home/providers/state_provider.dart';
import 'package:mangayomi/modules/manga/home/widget/filter_widget.dart';
import 'package:mangayomi/modules/widgets/listview_widget.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_filter_list.dart';
import 'package:mangayomi/services/get_latest_updates.dart';
import 'package:mangayomi/services/get_popular.dart';
import 'package:mangayomi/services/get_source_baseurl.dart';
import 'package:mangayomi/modules/manga/home/providers/saved_searches_provider.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/services/supports_latest.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/home/widget/mangas_card_selector.dart';
import 'package:mangayomi/modules/widgets/cover_grid_skeleton.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:mangayomi/modules/manga/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:marquee/marquee.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/modules/widgets/tv_menu.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MangaHomeScreen extends ConsumerStatefulWidget {
  final Source source;
  final bool isSearch;
  final bool isLatest;
  final String query;
  const MangaHomeScreen({
    required this.source,
    this.query = "",
    this.isSearch = false,
    this.isLatest = false,
    super.key,
  });

  @override
  ConsumerState<MangaHomeScreen> createState() => _MangaHomeScreenState();
}

class TypeMangaSelector {
  final IconData icon;
  final String title;
  TypeMangaSelector(this.icon, this.title);
}

class _MangaHomeScreenState extends ConsumerState<MangaHomeScreen> {
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  int _fullDataLength = 50;
  int _page = 1;
  bool _hasNextPage = true;
  late int _selectedIndex = widget.isLatest
      ? 1
      : widget.isSearch
      ? 2
      : 0;
  late Source source = widget.source;
  late bool isLocal = source.name == "local" && source.lang == "";
  late List<dynamic> filters = isLocal ? [] : getFilterList(source: source);
  final List<MManga> _mangaList = [];
  late StreamSubscription<List<Manga>> _mangaStreamSub;
  Map<String, Manga> _libraryIndex = {};
  List<TypeMangaSelector> _types(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return [
      TypeMangaSelector(Symbols.local_fire_department_rounded, l10n.popular),
      TypeMangaSelector(Symbols.new_releases_rounded, l10n.latest),
      TypeMangaSelector(Symbols.filter_list_rounded, l10n.filter),
    ];
  }

  Future<MPages?> _loadMore() async {
    MPages? mangaRes;
    if (_isLoading) {
      if (source.isFullData!) {
        await Future.delayed(const Duration(milliseconds: 500));
        _fullDataLength = _fullDataLength + 50;
      } else {
        if (_selectedIndex == 0 && !_isSearch && _query.isEmpty) {
          mangaRes = await ref.read(
            getPopularProvider(source: source, page: _page + 1).future,
          );
        } else if (_selectedIndex == 1 && !_isSearch && _query.isEmpty) {
          mangaRes = await ref.read(
            getLatestUpdatesProvider(source: source, page: _page + 1).future,
          );
        } else if (_selectedIndex == 2 && (_isSearch && _query.isNotEmpty) ||
            _isFiltering) {
          mangaRes = await ref.read(
            searchProvider(
              source: source,
              query: _query,
              page: _page + 1,
              filterList: filters,
            ).future,
          );
        }
      }
      if (mangaRes!.list.isNotEmpty) {
        if (mounted) {
          setState(() {
            _page = _page + 1;
            _hasNextPage = mangaRes!.hasNextPage;
          });
        }
      }
    }

    return mangaRes;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _mangaStreamSub = mangaRepository
        .watchBySourceAndLang(source.name, source.lang)
        .listen((mangas) {
          if (mounted) {
            setState(() {
              _libraryIndex = {};
              for (final m in mangas.where(
                (e) => e.sourceId == null || e.sourceId == source.id,
              )) {
                if (m.name == null) continue;
                final existing = _libraryIndex[m.name!];
                // Prefer the record with the lower id (first inserted = real entry).
                // Guards against pre-existing duplicate records in the DB.
                if (existing == null || m.id! < existing.id!) {
                  _libraryIndex[m.name!] = m;
                }
              }
            });
          }
        });
  }

  @override
  void dispose() {
    _mangaStreamSub.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _textEditingController.dispose();
    _searchFieldFocus.dispose();
    _postSearchFocus.dispose();
    super.dispose();
  }

  /// How far from the end the next page starts loading, so it is there by
  /// the time the reader reaches it. Waiting for the exact end made a fling
  /// stop short of it and left the reader on a "Load more" button.
  static const _prefetchDistance = 600.0;

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _prefetchDistance) {
      if (_mangaList.isNotEmpty &&
          _hasNextPage &&
          !_isLoading &&
          !(_getManga?.isLoading ?? false)) {
        setState(() => _isLoading = true);
        _loadMore().then((value) {
          if (mounted && value != null) {
            setState(() {
              _mangaList.addAll(value.list);
              _isLoading = false;
            });
          }
        });
      }
    }
  }

  Future<void> _promptSaveSearch() async {
    final query = _query.trim();
    if (query.isEmpty) {
      botToast(context.l10n.enter_search_to_save_first);
      return;
    }
    final name = await showShioriPrompt(
      context,
      title: context.l10n.save_search,
      label: context.l10n.name,
      confirmLabel: context.l10n.save,
      initialValue: query,
    );
    if (name == null) return;
    ref.read(savedSearchesProvider.notifier).add(source.id!, name, query);
  }

  void _showSavedSearches() {
    showShioriSheet<void>(
      context,
      title: context.l10n.saved_searches,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          final saved =
              ref.watch(savedSearchesProvider)[source.id] ??
              const <SavedSearch>[];
          if (saved.isEmpty) {
            return ShioriEmptyState(
              icon: Symbols.bookmark_rounded,
              title: context.l10n.no_saved_searches,
              compact: true,
            );
          }
          return ListView(
            shrinkWrap: true,
            children: [
              for (final s in saved)
                ShioriListRow(
                  leading: const Icon(Symbols.bookmark_rounded),
                  title: s.name,
                  subtitle: s.query,
                  onTap: () {
                    Navigator.pop(ctx);
                    _runSavedSearch(s.query);
                  },
                  trailing: IconButton(
                    tooltip: MaterialLocalizations.of(context)
                        .deleteButtonTooltip,
                    icon: const Icon(Symbols.delete_rounded),
                    onPressed: () => ref
                        .read(savedSearchesProvider.notifier)
                        .remove(source.id!, s.name),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Fetches again whatever the screen shows: a search or filter, the
  /// latest, or the popular list.
  void _retry() {
    if (_selectedIndex == 2 && (_isSearch && _query.isNotEmpty) ||
        _isFiltering) {
      ref.invalidate(
        searchProvider(
          source: source,
          query: _query,
          page: 1,
          filterList: filters,
        ),
      );
    } else if (_selectedIndex == 1 && !_isSearch && _query.isEmpty) {
      ref.invalidate(getLatestUpdatesProvider(source: source, page: 1));
    } else if (_selectedIndex == 0 && !_isSearch && _query.isEmpty) {
      ref.invalidate(getPopularProvider(source: source, page: 1));
    }
  }

  void _runSavedSearch(String query) {
    _mangaList.clear();
    _textEditingController.text = query;
    setState(() {
      _isSearch = true;
      _selectedIndex = 2;
      _query = query;
      _page = 1;
    });
  }

  late final _textEditingController = TextEditingController(text: widget.query);
  // TV search focus flow: opening search puts focus on the field; submitting
  // hands focus to the next button in the row, so it never reverts to Popular /
  // Latest (which, on revert, would re-select and close the search field).
  final _searchFieldFocus = FocusNode();
  final _postSearchFocus = FocusNode();
  late String _query = widget.query;
  late bool _isSearch = widget.isSearch;
  AsyncValue<MPages?>? _getManga;
  int _length = 0;
  bool _isFiltering = false;
  late final supportsLatest = isLocal
      ? true
      : ref.watch(supportsLatestProvider(source: source));
  late final filterList = isLocal ? [] : getFilterList(source: source);
  Future<void> _onSourceOverflow(int value) async {
    if (value == 0) {
      final baseUrl = ref.read(sourceBaseUrlProvider(source: source));
      final data = {
        'url': baseUrl,
        'sourceId': source.id.toString(),
        'title': '',
      };
      if (mounted) context.push("/mangawebview", extra: data);
    } else {
      final res = await context.push('/extension_detail', extra: source);
      if (res != null && mounted) setState(() => source = res as Source);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 2 && (_isSearch && _query.isNotEmpty) ||
        _isFiltering) {
      _getManga = ref.watch(
        searchProvider(
          source: source,
          query: _query,
          page: 1,
          filterList: filters,
        ),
      );
    } else if (_selectedIndex == 1 && _query.isEmpty) {
      _getManga = ref.watch(getLatestUpdatesProvider(source: source, page: 1));
    } else if (_selectedIndex == 0 && _query.isEmpty) {
      _getManga = ref.watch(getPopularProvider(source: source, page: 1));
    }
    final l10n = context.l10n;
    final displayType = ref.watch(mangaHomeDisplayTypeStateProvider);
    final displayTypeIcon = switch (displayType) {
      DisplayType.comfortableGrid ||
      DisplayType.compactGrid => Symbols.view_module_rounded,
      _ => Symbols.view_list_rounded,
    };
    return Scaffold(
      appBar: AppBar(
        title: _isSearch
            ? null
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    !isLocal
                        ? "${source.name}"
                        : "${context.l10n.local_source} ${source.itemType.localized(context.l10n)}",
                  ),
                  source.notes != null && source.notes!.isNotEmpty
                      ? SizedBox(
                          height: 20,
                          child: Marquee(
                            text: l10n.extension_notes(source.notes!),
                            style: context.shiori.text.meta,
                            blankSpace: 40.0,
                            velocity: 30.0,
                            pauseAfterRound: const Duration(seconds: 1),
                            startPadding: 10.0,
                          ),
                        )
                      : Container(),
                ],
              ),
        leading: !_isSearch ? null : Container(),
        actions: [
          _isSearch
              ? SeachFormTextField(
                  onFieldSubmitted: (submit) {
                    _mangaList.clear();
                    setState(() {
                      if (submit.isNotEmpty) {
                        _selectedIndex = 2;

                        _query = submit;
                      } else {
                        _selectedIndex = 0;
                      }
                      _page = 1;
                    });
                    // Hand focus to the next button in the row so it never
                    // reverts to Popular / Latest.
                    if (isTv) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) _postSearchFocus.requestFocus();
                      });
                    }
                  },
                  onChanged: (value) {},
                  onSuffixPressed: () {
                    _textEditingController.clear();
                    _mangaList.clear();
                    _query = "";
                    setState(() {});
                  },
                  onPressed: () {
                    setState(() {
                      if (_textEditingController.text.isEmpty) {
                        _isSearch = false;
                        _query = "";
                        _isFiltering = false;
                        _selectedIndex = 0;
                        _page = 1;
                        _textEditingController.clear();
                        _mangaList.clear();
                      } else {
                        Navigator.pop(context);
                      }
                    });
                  },
                  controller: _textEditingController,
                  focusNode: _searchFieldFocus,
                )
              : IconButton(
                  tooltip: MaterialLocalizations.of(context).searchFieldLabel,
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      _isSearch = true;
                    });
                    // Force focus onto the field so it doesn't revert to the
                    // previously focused pill while the search button unmounts.
                    if (isTv) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) _searchFieldFocus.requestFocus();
                      });
                    }
                  },
                  icon: Icon(
                    Symbols.search_rounded,
                    fill: 1,
                    color: context.shiori.color.fgMuted,
                  ),
                ),
          if (isTv)
            IconButton(
              tooltip: context.l10n.change_display_mode,
              focusNode: _postSearchFocus,
              icon: Icon(displayTypeIcon),
              onPressed: () async {
                const order = [
                  DisplayType.comfortableGrid,
                  DisplayType.compactGrid,
                  DisplayType.list,
                ];
                final current = ref.read(mangaHomeDisplayTypeStateProvider);
                final picked = await showTvMenu(
                  context,
                  title: context.l10n.display_mode,
                  options: [
                    TvMenuOption(
                      context.l10n.comfortable_grid,
                      selected: current == DisplayType.comfortableGrid,
                    ),
                    TvMenuOption(
                      context.l10n.compact_grid,
                      selected: current == DisplayType.compactGrid,
                    ),
                    TvMenuOption(
                      context.l10n.list,
                      selected: current == DisplayType.list,
                    ),
                  ],
                );
                if (picked != null) {
                  ref
                      .read(mangaHomeDisplayTypeStateProvider.notifier)
                      .setMangaHomeDisplayType(order[picked]);
                }
              },
            )
          else
            ShioriMenuButton(
              icon: displayTypeIcon,
              tooltip: l10n.display_mode,
              items: [
                for (final (type, label) in [
                  (DisplayType.comfortableGrid, l10n.comfortable_grid),
                  (DisplayType.compactGrid, l10n.compact_grid),
                  (DisplayType.list, l10n.list),
                ])
                  ShioriMenuItem(
                    label: label,
                    checked: displayType == type,
                    onSelected: () => ref
                        .read(mangaHomeDisplayTypeStateProvider.notifier)
                        .setMangaHomeDisplayType(type),
                  ),
                null,
                ShioriMenuItem(
                  label: l10n.save_search,
                  icon: Symbols.bookmark_add_rounded,
                  onSelected: _promptSaveSearch,
                ),
                ShioriMenuItem(
                  label: l10n.saved_searches,
                  icon: Symbols.bookmarks_rounded,
                  onSelected: _showSavedSearches,
                ),
              ],
            ),
          if (!isLocal)
            if (isTv)
              IconButton(
                tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
                icon: const Icon(Symbols.more_vert_rounded, fill: 1),
                onPressed: () async {
                  final picked = await showTvMenu(
                    context,
                    title: source.name ?? '',
                    options: [
                      TvMenuOption(context.l10n.open_in_browser),
                      TvMenuOption(context.l10n.settings),
                    ],
                  );
                  if (picked != null && mounted) _onSourceOverflow(picked);
                },
              )
            else
              ShioriMenuButton(
                tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
                items: [
                  ShioriMenuItem(
                    label: l10n.open_in_browser,
                    icon: Symbols.public_rounded,
                    onSelected: () => _onSourceOverflow(0),
                  ),
                  ShioriMenuItem(
                    label: l10n.settings,
                    icon: Symbols.settings_rounded,
                    onSelected: () => _onSourceOverflow(1),
                  ),
                ],
              ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height * 0.8),
          child: Column(
            children: [
              SizedBox(
                width: context.width(1),
                height: 45,
                child: SuperListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    if (filterList.isEmpty && index == 2) {
                      return const SizedBox.shrink();
                    }
                    if (!supportsLatest && index == 1) {
                      return const SizedBox.shrink();
                    }
                    return MangasCardSelector(
                      icon: _types(context)[index].icon,
                      selected: _selectedIndex == index,
                      text: _types(context)[index].title,
                      onPressed: () async {
                        if (filters.isEmpty) {
                          filters = filterList;
                        }
                        if (index == 2) {
                          final result = await showShioriSheet<String>(
                            context,
                            title: l10n.filter,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) {
                                return FilterSheetBody(
                                  filters: filters,
                                  onChanged: (values) =>
                                      setState(() => filters = values),
                                  onReset: () => setState(
                                    () =>
                                        filters = getFilterList(source: source),
                                  ),
                                  onApply: () =>
                                      Navigator.pop(context, 'filter'),
                                  resetLabel: l10n.reset,
                                  applyLabel: l10n.filter,
                                );
                              },
                            ),
                          );
                          if (result == 'filter') {
                            _mangaList.clear();
                            if (mounted) {
                              setState(() {
                                _selectedIndex = 2;
                                _isFiltering = true;
                                _page = 1;
                                _isLoading = false;
                              });
                            }

                            _getManga = ref.refresh(
                              searchProvider(
                                source: source,
                                query: _query,
                                page: 1,
                                filterList: filters,
                              ),
                            );
                          }
                        } else {
                          _mangaList.clear();
                          setState(() {
                            _selectedIndex = index;
                            _isFiltering = false;
                            _isSearch = false;
                            _query = "";
                            _textEditingController.clear();
                            _page = 1;
                            _isLoading = false;
                          });
                        }
                      },
                    );
                  },
                ),
              ),
              Container(
                color: context.shiori.color.accentInk,
                height: 0.3,
                width: context.width(1),
              ),
            ],
          ),
        ),
      ),
      // In developer mode, what failed in the source's code, on the page.
      body: Column(
        children: [
          SourceCodeErrorBanner(source: source),
          Expanded(
            child: _getManga!.isLoading
                // Fetching a source page is the app's longest routine wait. Lay out
                // the grid the covers will land in rather than a centred spinner;
                // the list mode has no fixed cell shape to stand in for, so it keeps
                // the spinner.
                ? (displayType == DisplayType.list
                      ? const ProgressCenter()
                      : Consumer(
                          builder: (context, ref, child) => CoverGridSkeleton(
                            gridSize: ref.watch(
                              libraryGridSizeStateProvider(
                                itemType: source.itemType,
                              ),
                            ),
                            childAspectRatio:
                                displayType == DisplayType.comfortableGrid
                                ? 0.642
                                : 0.69,
                          ),
                        ))
                : _getManga!.when(
                    data: (data) {
                      if (_hasNextPage) {
                        if (!data!.hasNextPage) {
                          if (mounted) {
                            setState(() {
                              _hasNextPage = false;
                            });
                          }
                        }
                      }
                      if (_mangaList.isEmpty && data!.list.isNotEmpty) {
                        _mangaList.addAll(data.list);
                      }
                      Widget buildProgressIndicator() {
                        return !(data!.list.isNotEmpty &&
                                (data.hasNextPage || _hasNextPage))
                            ? Container()
                            : _isLoading
                            ? const Center(
                                child: SizedBox(
                                  height: 100,
                                  width: 200,
                                  child: Center(child: ShioriLoading.inline()),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(ShioriSpace.s16),
                                child: Center(
                                  child: ShioriButton.secondary(
                                    label: l10n.load_more,
                                    icon: Symbols.expand_more_rounded,
                                    onPressed: () {
                                      if (!_getManga!.isLoading) {
                                        if (mounted) {
                                          setState(() => _isLoading = true);
                                        }
                                        _loadMore().then((value) {
                                          if (mounted && value != null) {
                                            setState(() {
                                              _mangaList.addAll(value.list);
                                              _isLoading = false;
                                            });
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              );
                      }

                      if (data!.list.isEmpty) {
                        return ShioriEmptyState(
                          icon: Symbols.search_off_rounded,
                          title: l10n.no_result,
                          compact: true,
                        );
                      }
                      _length = source.isFullData!
                          ? _fullDataLength
                          : _mangaList.length;
                      _length = (_mangaList.length < _length
                          ? _mangaList.length
                          : _length);
                      final isComfortableGrid =
                          displayType == DisplayType.comfortableGrid;
                      return Padding(
                        padding: const EdgeInsets.only(top: ShioriSpace.s12),
                        child: Column(
                          children: [
                            Flexible(
                              child: displayType == DisplayType.list
                                  ? SuperListViewWidget(
                                      controller: _scrollController,
                                      itemCount: _length + 1,
                                      itemBuilder: (context, index) {
                                        if (index == _length) {
                                          return buildProgressIndicator();
                                        }
                                        return MangaHomeImageCardListTile(
                                          itemType: source.itemType,
                                          manga: _mangaList[index],
                                          source: source,
                                          libraryManga:
                                              _libraryIndex[_mangaList[index]
                                                  .name],
                                        );
                                      },
                                    )
                                  : Consumer(
                                      builder: (context, ref, child) {
                                        final gridSize = ref.watch(
                                          libraryGridSizeStateProvider(
                                            itemType: source.itemType,
                                          ),
                                        );

                                        return GridViewWidget(
                                          gridSize: gridSize,
                                          controller: _scrollController,
                                          itemCount: _length + 1,
                                          childAspectRatio: isComfortableGrid
                                              ? 0.642
                                              : 0.69,
                                          itemBuilder: (context, index) {
                                            if (index == _length) {
                                              return buildProgressIndicator();
                                            }
                                            return MangaHomeImageCard(
                                              autofocus:
                                                  isTv &&
                                                  index == 0 &&
                                                  !_isSearch,
                                              itemType: source.itemType,
                                              manga: _mangaList[index],
                                              source: source,
                                              isComfortableGrid:
                                                  isComfortableGrid,
                                              libraryManga:
                                                  _libraryIndex[_mangaList[index]
                                                      .name],
                                            );
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                    // Retry with the provider this view reads, or open the
                    // source in the browser, the way past a Cloudflare check.
                    error: (error, stackTrace) => ErrorState(
                      // The stack too in developer mode, to see where it broke.
                      detail: ref.watch(developerModeStateProvider)
                          ? '$error\n\n$stackTrace'
                          : error.toString(),
                      onRetry: _retry,
                      secondaryLabel: l10n.webview,
                      secondaryIcon: Symbols.public_rounded,
                      onSecondary: () {
                        final baseUrl = ref.read(
                          sourceBaseUrlProvider(source: source),
                        );
                        context.push(
                          "/mangawebview",
                          extra: {
                            'url': baseUrl,
                            'sourceId': source.id.toString(),
                            'title': '',
                            "hasCloudFlare": source.hasCloudflare ?? false,
                          },
                        );
                      },
                    ),
                    loading: () => const ShioriLoading(),
                  ),
          ),
        ],
      ),
    );
  }
}

class MangaHomeImageCard extends ConsumerStatefulWidget {
  final MManga manga;
  final ItemType itemType;
  final Source source;
  final bool isComfortableGrid;
  final Manga? libraryManga;
  final bool autofocus;
  const MangaHomeImageCard({
    super.key,
    required this.manga,
    required this.source,
    required this.itemType,
    required this.isComfortableGrid,
    this.libraryManga,
    this.autofocus = false,
  });

  @override
  ConsumerState<MangaHomeImageCard> createState() => _MangaHomeImageCardState();
}

class _MangaHomeImageCardState extends ConsumerState<MangaHomeImageCard> {
  @override
  Widget build(BuildContext context) {
    return MangaImageCardWidget(
      getMangaDetail: widget.manga,
      source: widget.source,
      itemType: widget.itemType,
      isComfortableGrid: widget.isComfortableGrid,
      libraryManga: widget.libraryManga,
      autofocus: widget.autofocus,
    );
  }
}

class MangaHomeImageCardListTile extends ConsumerStatefulWidget {
  final MManga manga;
  final ItemType itemType;
  final Source source;
  final Manga? libraryManga;
  const MangaHomeImageCardListTile({
    super.key,
    required this.manga,
    required this.source,
    required this.itemType,
    this.libraryManga,
  });

  @override
  ConsumerState<MangaHomeImageCardListTile> createState() =>
      _MangaHomeImageCardListTileState();
}

class _MangaHomeImageCardListTileState
    extends ConsumerState<MangaHomeImageCardListTile> {
  @override
  Widget build(BuildContext context) {
    return MangaImageCardListTileWidget(
      getMangaDetail: widget.manga,
      source: widget.source,
      itemType: widget.itemType,
      libraryManga: widget.libraryManga,
    );
  }
}
