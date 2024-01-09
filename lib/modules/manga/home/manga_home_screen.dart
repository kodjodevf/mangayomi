import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/home/widget/filter_widget.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_filter_list.dart';
import 'package:mangayomi/services/get_latest_updates.dart';
import 'package:mangayomi/services/get_popular.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/services/supports_latest.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/home/widget/mangas_card_selector.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';

class MangaHomeScreen extends ConsumerStatefulWidget {
  final Source source;
  final bool isSearch;
  final bool isLatest;
  final String query;
  const MangaHomeScreen(
      {required this.source,
      this.query = "",
      this.isSearch = false,
      this.isLatest = false,
      super.key});

  @override
  ConsumerState<MangaHomeScreen> createState() => _MangaHomeScreenState();
}

class TypeMangaSelector {
  final IconData icon;
  final String title;
  TypeMangaSelector(
    this.icon,
    this.title,
  );
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
  List<dynamic> filters = [];
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
    MPages? mangaResList;

    if (_isLoading) {
      if (widget.source.isFullData!) {
        await Future.delayed(const Duration(milliseconds: 500));
        _fullDataLength = _fullDataLength + 50;
      } else {
        if (_selectedIndex == 0 && !_isSearch && _query.isEmpty) {
          mangaResList = await ref.watch(getPopularProvider(
            source: widget.source,
            page: _page + 1,
          ).future);
        } else if (_selectedIndex == 1 && !_isSearch && _query.isEmpty) {
          mangaResList = await ref.watch(getLatestUpdatesProvider(
            source: widget.source,
            page: _page + 1,
          ).future);
        } else if (_selectedIndex == 2 && (_isSearch && _query.isNotEmpty) ||
            _isFiltering) {
          mangaResList = await ref.watch(searchProvider(
                  source: widget.source,
                  query: _query,
                  page: _page + 1,
                  filterList: filters)
              .future);
        }
      }
      if (mounted) {
        setState(() {
          _page = _page + 1;
          _hasNextPage = mangaResList!.hasNextPage;
        });
      }
    }
    return mangaResList;
  }

  late final _textEditingController = TextEditingController(text: widget.query);
  late String _query = widget.query;
  late bool _isSearch = widget.isSearch;
  AsyncValue<MPages?>? _getManga;
  int _length = 0;
  bool _isFiltering = false;
  @override
  Widget build(BuildContext context) {
    final supportsLatest =
        ref.watch(supportsLatestProvider(source: widget.source));
    final filterList = getFilterList(source: widget.source);
    if (_selectedIndex == 2 && (_isSearch && _query.isNotEmpty) ||
        _isFiltering) {
      _getManga = ref.watch(searchProvider(
          source: widget.source, query: _query, page: 1, filterList: filters));
    } else if (_selectedIndex == 1 && !_isSearch && _query.isEmpty) {
      _getManga =
          ref.watch(getLatestUpdatesProvider(source: widget.source, page: 1));
    } else if (_selectedIndex == 0 && !_isSearch && _query.isEmpty) {
      _getManga = ref.watch(getPopularProvider(source: widget.source, page: 1));
    }
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
        appBar: AppBar(
          title: _isSearch ? null : Text('${widget.source.name}'),
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
                    icon:
                        Icon(Icons.search, color: Theme.of(context).hintColor)),
            IconButton(
              onPressed: () {
                Map<String, String> data = {
                  'url': widget.source.baseUrl!,
                  'sourceId': widget.source.id.toString(),
                  'title': ''
                };
                context.push("/mangawebview", extra: data);
              },
              icon: Icon(
                Icons.public,
                size: 22,
                color: context.secondaryColor,
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height * 0.8),
            child: Column(
              children: [
                SizedBox(
                  width: context.mediaWidth(1),
                  height: 45,
                  child: ListView.builder(
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
                          _mangaList.clear();
                          if (filters.isEmpty) {
                            filters = filterList;
                          }
                          if (index == 2) {
                            final result = await showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  StatefulBuilder(builder: (context, setState) {
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
                                                    source: widget.source);
                                              });
                                            },
                                            child: Text(l10n.reset),
                                          ),
                                          const Spacer(),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    context.primaryColor),
                                            onPressed: () {
                                              Navigator.pop(context, 'filter');
                                            },
                                            child: Text(
                                              l10n.filter,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor),
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
                              }),
                            );
                            if (result == 'filter') {
                              if (mounted) {
                                setState(() {
                                  _selectedIndex = 2;
                                  _isFiltering = true;
                                  _page = 1;
                                });
                              }

                              _getManga = ref.refresh(searchProvider(
                                  source: widget.source,
                                  query: _query,
                                  page: 1,
                                  filterList: filters));
                            }
                          } else if (index != 2) {
                            setState(() {
                              _selectedIndex = index;
                              _isFiltering = false;
                              _isSearch = false;
                              _page = 1;
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
                  width: context.mediaWidth(1),
                )
              ],
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: _getManga!.when(
            data: (data) {
              if (_mangaList.isEmpty && data!.list.isNotEmpty) {
                _mangaList.addAll(data.list);
              }
              if (_getManga!.isLoading) {
                return const ProgressCenter();
              }
              Widget buildProgressIndicator() {
                return !(data!.list.isNotEmpty && (_hasNextPage))
                    ? Container()
                    : _isLoading
                        ? const Center(
                            child: SizedBox(
                              height: 100,
                              width: 200,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : context.isTablet
                            ? Padding(
                                padding: const EdgeInsets.all(4),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(l10n.load_more),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Icon(
                                            Icons.arrow_forward_outlined),
                                      ],
                                    )),
                              )
                            : Container();
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

              _length = widget.source.isFullData!
                  ? _fullDataLength
                  : _mangaList.length;
              _length =
                  (_mangaList.length < _length ? _mangaList.length : _length);
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Flexible(
                        child: GridViewWidget(
                      controller: _scrollController,
                      itemCount: _length + 1,
                      itemBuilder: (context, index) {
                        if (index == _length) {
                          return buildProgressIndicator();
                        }
                        return MangaHomeImageCard(
                          isManga: widget.source.isManga ?? true,
                          manga: _mangaList[index],
                          source: widget.source,
                        );
                      },
                    )),
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
                                  ref.invalidate(searchProvider(
                                      source: widget.source,
                                      query: _query,
                                      page: 1,
                                      filterList: filters));
                                } else if (_selectedIndex == 1 &&
                                    !_isSearch &&
                                    _query.isEmpty) {
                                  ref.invalidate(getLatestUpdatesProvider(
                                      source: widget.source, page: 1));
                                } else if (_selectedIndex == 0 &&
                                    !_isSearch &&
                                    _query.isEmpty) {
                                  ref.invalidate(getPopularProvider(
                                    source: widget.source,
                                    page: 1,
                                  ));
                                }
                              },
                              icon: const Icon(Icons.refresh)),
                          Text(l10n.refresh)
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Map<String, String> data = {
                                'url': widget.source.baseUrl!,
                                'sourceId': widget.source.id.toString(),
                                'title': ''
                              };
                              context.push("/mangawebview", extra: data);
                            },
                            icon: Icon(
                              Icons.public,
                              size: 22,
                              color: context.secondaryColor,
                            ),
                          ),
                          const Text("Webview")
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ));
  }
}

class MangaHomeImageCard extends ConsumerStatefulWidget {
  final MManga manga;
  final bool isManga;
  final Source source;
  const MangaHomeImageCard({
    super.key,
    required this.manga,
    required this.source,
    required this.isManga,
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
      isManga: widget.isManga,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
