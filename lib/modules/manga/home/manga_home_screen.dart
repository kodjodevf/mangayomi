import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_latest_updates_manga.dart';
import 'package:mangayomi/services/get_popular_manga.dart';
import 'package:mangayomi/services/search_manga.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/modules/library/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/home/widget/mangas_card_selector.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';

class MangaHomeScreen extends ConsumerStatefulWidget {
  final Source source;
  const MangaHomeScreen({required this.source, super.key});

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
  int _selectedIndex = 0;
  List<TypeMangaSelector> _types(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return [
      TypeMangaSelector(Icons.favorite, l10n.popular),
      TypeMangaSelector(Icons.new_releases_outlined, l10n.latest),
      TypeMangaSelector(Icons.filter_list_outlined, l10n.filter),
    ];
  }

  Future<List<MangaModel?>> _loadMore() async {
    List<MangaModel?> mangaResList = [];

    if (_isLoading) {
      if (widget.source.isFullData!) {
        await Future.delayed(const Duration(milliseconds: 500));
        _fullDataLength = _fullDataLength + 50;
      } else {
        if (_selectedIndex == 0 && !_isSearch && _query.isEmpty) {
          mangaResList = await ref.watch(getPopularMangaProvider(
            source: widget.source,
            page: _page + 1,
          ).future);
        } else if (_selectedIndex == 1 && !_isSearch && _query.isEmpty) {
          mangaResList = await ref.watch(getLatestUpdatesMangaProvider(
            source: widget.source,
            page: _page + 1,
          ).future);
        } else if (_selectedIndex == 2 && _isSearch && _query.isNotEmpty) {
          mangaResList = await ref.watch(searchMangaProvider(
            source: widget.source,
            query: _query,
            page: _page + 1,
          ).future);
        }
      }
      if (mounted) {
        setState(() {
          _page = _page + 1;
        });
      }
    }
    return mangaResList;
  }

  final _textEditingController = TextEditingController();
  String _query = "";
  bool _isSearch = false;
  AsyncValue<List<MangaModel?>>? _getManga;
  int _length = 0;
  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 2 && _isSearch && _query.isNotEmpty) {
      _getManga = ref.watch(
          searchMangaProvider(source: widget.source, query: _query, page: 1));
    } else if (_selectedIndex == 1 && !_isSearch && _query.isEmpty) {
      _getManga = ref
          .watch(getLatestUpdatesMangaProvider(source: widget.source, page: 1));
    } else if (_selectedIndex == 0 && !_isSearch && _query.isEmpty) {
      _getManga = ref.watch(getPopularMangaProvider(
        source: widget.source,
        page: 1,
      ));
    }
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
        appBar: AppBar(
          title: _isSearch ? null : Text('${widget.source.name}'),
          actions: [
            _isSearch
                ? SeachFormTextField(
                    onFieldSubmitted: (submit) {
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
                      setState(() {});
                    },
                    onPressed: () {
                      setState(() {
                        _isSearch = false;
                        _query = "";
                        _selectedIndex = 0;
                        _page = 1;
                        _textEditingController.clear();
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
                color: secondaryColor(context),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height * 0.8),
            child: Column(
              children: [
                SizedBox(
                  width: mediaWidth(context, 1),
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return MangasCardSelector(
                        icon: _types(context)[index].icon,
                        selected: _selectedIndex == index,
                        text: _types(context)[index].title,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = index;
                            _page = 1;
                          });
                        },
                      );
                    },
                  ),
                ),
                Container(
                  color: primaryColor(context),
                  height: 1,
                  width: mediaWidth(context, 1),
                )
              ],
            ),
          ),
        ),
        body: _getManga!.when(
          data: (data) {
            Widget buildProgressIndicator() {
              return !(data.isNotEmpty && (data.last!.hasNextPage ?? true))
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
                      : isTablet(context)
                          ? Padding(
                              padding: const EdgeInsets.all(4),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () {
                                    if (mounted) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                    }
                                    _loadMore().then((value) {
                                      if (mounted) {
                                        setState(() {
                                          data.addAll(value);
                                          _isLoading = false;
                                        });
                                      }
                                    });
                                  },
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Load more"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Icon(Icons.arrow_forward_outlined),
                                    ],
                                  )),
                            )
                          : Container();
            }

            if (data.isEmpty) {
              return Center(child: Text(l10n.no_result));
            }
            _scrollController.addListener(() {
              if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent) {
                if (data.isNotEmpty && (data.last!.hasNextPage ?? true)) {
                  if (mounted) {
                    setState(() {
                      _isLoading = true;
                    });
                  }
                  _loadMore().then((value) {
                    if (mounted) {
                      setState(() {
                        data.addAll(value);
                        _isLoading = false;
                      });
                    }
                  });
                }
              }
            });

            _length = widget.source.isFullData! ? _fullDataLength : data.length;
            _length = (data.length < _length ? data.length : _length);
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
                        manga: data[index]!,
                        source: widget.source,
                      );
                    },
                  )),
                ],
              ),
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}

class MangaHomeImageCard extends ConsumerStatefulWidget {
  final MangaModel manga;
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
      getMangaDetail: widget.manga
        ..lang = widget.source.lang
        ..source = widget.source.name,
      lang: widget.source.lang!,
      isManga: widget.isManga,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
