import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga_type.dart';
import 'package:mangayomi/services/get_latest_updates_manga.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/services/get_popular_manga.dart';
import 'package:mangayomi/services/search_manga.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/modules/library/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/home/widget/mangas_card_selector.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/cover_view_widget.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';

class MangaHomeScreen extends ConsumerStatefulWidget {
  final MangaType mangaType;
  const MangaHomeScreen({required this.mangaType, super.key});

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
  int _fullDataLength = 20;
  int _page = 1;
  int _selectedIndex = 0;
  final List<TypeMangaSelector> _types = [
    TypeMangaSelector(Icons.favorite, 'Popular'),
    TypeMangaSelector(Icons.new_releases_outlined, 'Latest'),
    TypeMangaSelector(Icons.filter_list_outlined, 'Filter'),
  ];
  final _textEditingController = TextEditingController();
  String _query = "";
  bool _isSearch = false;
  AsyncValue<List<GetManga?>>? _getManga;
  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 2 && _isSearch && _query.isNotEmpty) {
      _getManga = ref.watch(
          searchMangaProvider(source: widget.mangaType.source!, query: _query));
    } else if (_selectedIndex == 1 && !_isSearch && _query.isEmpty) {
      _getManga = ref.watch(getLatestUpdatesMangaProvider(
          source: widget.mangaType.source!, page: 1));
    } else if (_selectedIndex == 0 && !_isSearch && _query.isEmpty) {
      _getManga = ref.watch(
          getPopularMangaProvider(source: widget.mangaType.source!, page: 1));
    }

    return Scaffold(
        appBar: AppBar(
          title: _isSearch ? null : Text('${widget.mangaType.source}'),
          actions: [
            _isSearch
                ? SeachFormTextField(
                    onFieldSubmitted: (submit) {
                      if (submit.isNotEmpty) {
                        setState(() {
                          _selectedIndex = 2;
                          _query = submit;
                        });
                      } else {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      }
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
                      });
                      _textEditingController.clear();
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
                  'url': getMangaBaseUrl(widget.mangaType.source!),
                  'source': widget.mangaType.source!,
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
                        icon: _types[index].icon,
                        selected: _selectedIndex == index,
                        text: _types[index].title,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = index;
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
            if (data.isEmpty) {
              return const Center(child: Text("No result"));
            }
            if (!_isSearch) {
              _scrollController.addListener(() {
                if (_scrollController.position.pixels ==
                    _scrollController.position.maxScrollExtent) {
                  if (!_isLoading) {
                    if (mounted) {
                      setState(() {
                        _isLoading = true;
                      });
                    }

                    if (widget.mangaType.isFullData!) {
                      Future.delayed(const Duration(seconds: 1)).then((value) {
                        _fullDataLength = _fullDataLength + 10;
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      });
                    } else {
                      if (mounted) {
                        setState(() {
                          _page = _page + 1;
                        });
                      }
                      ref
                          .watch(getPopularMangaProvider(
                                  source: widget.mangaType.source!, page: _page)
                              .future)
                          .then(
                        (value) {
                          if (mounted) {
                            setState(() {
                              data.addAll(value);
                              _isLoading = false;
                            });
                          }
                        },
                      );
                    }
                  }
                }
              });
            }

            final length =
                widget.mangaType.isFullData! ? _fullDataLength : data.length;
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Flexible(
                      child: GridViewWidget(
                    controller: _scrollController,
                    itemCount: length,
                    itemBuilder: (context, index) {
                      if (index == length - 1) {
                        return _buildProgressIndicator();
                      }
                      return MangaHomeImageCard(
                        manga: data[index]!,
                        source: widget.mangaType.source!,
                        lang: widget.mangaType.lang!,
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

  Widget _buildProgressIndicator() {
    return _isLoading
        ? const Center(
            child: SizedBox(
              height: 100,
              width: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : Container();
  }
}

class MangaHomeImageCard extends ConsumerStatefulWidget {
  final GetManga manga;
  final String source;
  final String lang;
  const MangaHomeImageCard({
    super.key,
    required this.manga,
    required this.source,
    required this.lang,
  });

  @override
  ConsumerState<MangaHomeImageCard> createState() => _MangaHomeImageCardState();
}

class _MangaHomeImageCardState extends ConsumerState<MangaHomeImageCard>
    with AutomaticKeepAliveClientMixin<MangaHomeImageCard> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final getMangaDetail = ref.watch(getMangaDetailProvider(
        source: widget.source, manga: widget.manga, lang: widget.lang));

    return getMangaDetail.when(
      data: (data) {
        return MangaImageCardWidget(
          getMangaDetail: data,
          lang: widget.lang,
        );
      },
      loading: () => CoverViewWidget(onTap: () {}, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: Theme.of(context).cardColor,
          ),
        ),
        BottomTextWidget(
          text: widget.manga.name!,
        )
      ]),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
