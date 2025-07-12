import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
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
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/services/supports_latest.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/home/widget/mangas_card_selector.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:marquee/marquee.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

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
  late List<dynamic> filters = getFilterList(source: source);
  final List<MManga> _mangaList = [];
  List<TypeMangaSelector> _types(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return [
      TypeMangaSelector(Icons.favorite, l10n.popular),
      TypeMangaSelector(Icons.new_releases_outlined, l10n.latest),
      TypeMangaSelector(Icons.filter_list_outlined, l10n.filter),
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
          mangaRes = await ref.watch(
            getPopularProvider(source: source, page: _page + 1).future,
          );
        } else if (_selectedIndex == 1 && !_isSearch && _query.isEmpty) {
          mangaRes = await ref.watch(
            getLatestUpdatesProvider(source: source, page: _page + 1).future,
          );
        } else if (_selectedIndex == 2 && (_isSearch && _query.isNotEmpty) ||
            _isFiltering) {
          mangaRes = await ref.watch(
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
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  late final _textEditingController = TextEditingController(text: widget.query);
  late String _query = widget.query;
  late bool _isSearch = widget.isSearch;
  AsyncValue<MPages?>? _getManga;
  int _length = 0;
  bool _isFiltering = false;
  late final supportsLatest = ref.watch(supportsLatestProvider(source: source));
  late final filterList = getFilterList(source: source);
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
    } else if (_selectedIndex == 1 && !_isSearch && _query.isEmpty) {
      _getManga = ref.watch(getLatestUpdatesProvider(source: source, page: 1));
    } else if (_selectedIndex == 0 && !_isSearch && _query.isEmpty) {
      _getManga = ref.watch(getPopularProvider(source: source, page: 1));
    }
    final l10n = context.l10n;
    final displayType = ref.watch(mangaHomeDisplayTypeStateProvider);
    final displayTypeIcon = switch (displayType) {
      DisplayType.comfortableGrid ||
      DisplayType.compactGrid => Icons.view_module,
      _ => Icons.view_list,
    };
    return Scaffold(
      appBar: AppBar(
        title: _isSearch
            ? null
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${source.name}"),
                  source.notes != null && source.notes!.isNotEmpty
                      ? SizedBox(
                          height: 20,
                          child: Marquee(
                            text: l10n.extension_notes(source.notes!),
                            style: const TextStyle(fontSize: 12),
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
                )
              : IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      _isSearch = true;
                    });
                  },
                  icon: Icon(Icons.search, color: Theme.of(context).hintColor),
                ),
          PopupMenuButton(
            popUpAnimationStyle: popupAnimationStyle,
            icon: Icon(displayTypeIcon),
            itemBuilder: (context) {
              final displayType = ref.watch(mangaHomeDisplayTypeStateProvider);
              final displayTypeNotifier = ref.read(
                mangaHomeDisplayTypeStateProvider.notifier,
              );
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: RadioListTile(
                    title: Text(context.l10n.comfortable_grid),
                    value: DisplayType.comfortableGrid,
                    groupValue: displayType,
                    onChanged: (a) {
                      context.pop();
                      displayTypeNotifier.setMangaHomeDisplayType(a!);
                    },
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: RadioListTile(
                    title: Text(context.l10n.compact_grid),
                    value: DisplayType.compactGrid,
                    groupValue: displayType,
                    onChanged: (a) {
                      context.pop();
                      displayTypeNotifier.setMangaHomeDisplayType(a!);
                    },
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: RadioListTile(
                    title: Text(context.l10n.list),
                    value: DisplayType.list,
                    groupValue: displayType,
                    onChanged: (a) {
                      context.pop();
                      displayTypeNotifier.setMangaHomeDisplayType(a!);
                    },
                  ),
                ),
              ];
            },
            onSelected: (value) {},
          ),
          PopupMenuButton(
            popUpAnimationStyle: popupAnimationStyle,
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(context.l10n.open_in_browser),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(context.l10n.settings),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 0) {
                final baseUrl = ref.watch(
                  sourceBaseUrlProvider(source: source),
                );
                Map<String, dynamic> data = {
                  'url': baseUrl,
                  'sourceId': source.id.toString(),
                  'title': '',
                };
                context.push("/mangawebview", extra: data);
              } else {
                final res = await context.push(
                  '/extension_detail',
                  extra: source,
                );
                if (res != null && mounted) {
                  setState(() {
                    source = res as Source;
                  });
                }
              }
            },
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
                          final result = await showModalBottomSheet(
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                filters = getFilterList(
                                                  source: source,
                                                );
                                              });
                                            },
                                            child: Text(l10n.reset),
                                          ),
                                          const Spacer(),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  context.primaryColor,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context, 'filter');
                                            },
                                            child: Text(
                                              l10n.filter,
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).scaffoldBackgroundColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    Expanded(
                                      child: FilterWidget(
                                        filterList: filters,
                                        onChanged: (values) {
                                          setState(() {
                                            filters = values;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
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
                color: context.primaryColor,
                height: 0.3,
                width: context.width(1),
              ),
            ],
          ),
        ),
      ),
      body: _getManga!.isLoading
          ? const ProgressCenter()
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
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(4),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              if (!_getManga!.isLoading) {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = true;
                                  });
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.load_more,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 2,
                                ),
                                const Icon(Icons.arrow_forward_outlined),
                              ],
                            ),
                          ),
                        );
                }

                if (data!.list.isEmpty) {
                  return Center(child: Text(l10n.no_result));
                }
                _scrollController.addListener(() {
                  if (_scrollController.position.pixels ==
                      _scrollController.position.maxScrollExtent) {
                    if (_mangaList.isNotEmpty &&
                        (_hasNextPage) &&
                        !_isLoading &&
                        !_getManga!.isLoading) {
                      if (mounted) {
                        setState(() {
                          _isLoading = true;
                        });
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
                  }
                });

                _length = source.isFullData!
                    ? _fullDataLength
                    : _mangaList.length;
                _length = (_mangaList.length < _length
                    ? _mangaList.length
                    : _length);
                final isComfortableGrid =
                    displayType == DisplayType.comfortableGrid;
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
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
                                        itemType: source.itemType,
                                        manga: _mangaList[index],
                                        source: source,
                                        isComfortableGrid: isComfortableGrid,
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
              error: (error, stackTrace) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_selectedIndex == 2 &&
                                        (_isSearch && _query.isNotEmpty) ||
                                    _isFiltering) {
                                  ref.invalidate(
                                    searchProvider(
                                      source: source,
                                      query: _query,
                                      page: 1,
                                      filterList: filters,
                                    ),
                                  );
                                } else if (_selectedIndex == 1 &&
                                    !_isSearch &&
                                    _query.isEmpty) {
                                  ref.invalidate(
                                    getLatestUpdatesProvider(
                                      source: source,
                                      page: 1,
                                    ),
                                  );
                                } else if (_selectedIndex == 0 &&
                                    !_isSearch &&
                                    _query.isEmpty) {
                                  ref.invalidate(
                                    getPopularProvider(source: source, page: 1),
                                  );
                                }
                              },
                              icon: const Icon(Icons.refresh),
                            ),
                            Text(l10n.refresh),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                final baseUrl = ref.watch(
                                  sourceBaseUrlProvider(source: source),
                                );
                                Map<String, dynamic> data = {
                                  'url': baseUrl,
                                  'sourceId': source.id.toString(),
                                  'title': '',
                                  "hasCloudFlare":
                                      source.hasCloudflare ?? false,
                                };
                                context.push("/mangawebview", extra: data);
                              },
                              icon: Icon(
                                Icons.public,
                                size: 22,
                                color: context.secondaryColor,
                              ),
                            ),
                            const Text("Webview"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(error.toString(), textAlign: TextAlign.center),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
    );
  }
}

class MangaHomeImageCard extends ConsumerStatefulWidget {
  final MManga manga;
  final ItemType itemType;
  final Source source;
  final bool isComfortableGrid;
  const MangaHomeImageCard({
    super.key,
    required this.manga,
    required this.source,
    required this.itemType,
    required this.isComfortableGrid,
  });

  @override
  ConsumerState<MangaHomeImageCard> createState() => _MangaHomeImageCardState();
}

class _MangaHomeImageCardState extends ConsumerState<MangaHomeImageCard>
    with AutomaticKeepAliveClientMixin<MangaHomeImageCard> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MangaImageCardWidget(
      getMangaDetail: widget.manga,
      source: widget.source,
      itemType: widget.itemType,
      isComfortableGrid: widget.isComfortableGrid,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MangaHomeImageCardListTile extends ConsumerStatefulWidget {
  final MManga manga;
  final ItemType itemType;
  final Source source;
  const MangaHomeImageCardListTile({
    super.key,
    required this.manga,
    required this.source,
    required this.itemType,
  });

  @override
  ConsumerState<MangaHomeImageCardListTile> createState() =>
      _MangaHomeImageCardListTileState();
}

class _MangaHomeImageCardListTileState
    extends ConsumerState<MangaHomeImageCardListTile>
    with AutomaticKeepAliveClientMixin<MangaHomeImageCardListTile> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MangaImageCardListTileWidget(
      getMangaDetail: widget.manga,
      source: widget.source,
      itemType: widget.itemType,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
