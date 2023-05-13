import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga_type.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/services/get_popular_manga.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/views/manga/home/manga_search_screen.dart';
import 'package:mangayomi/views/widgets/bottom_text_widget.dart';
import 'package:mangayomi/views/widgets/cover_view_widget.dart';
import 'package:mangayomi/views/widgets/gridview_widget.dart';
import 'package:mangayomi/views/widgets/manga_image_card_widget.dart';

class MangaHomeScreen extends ConsumerStatefulWidget {
  final MangaType mangaType;
  const MangaHomeScreen({required this.mangaType, super.key});

  @override
  ConsumerState<MangaHomeScreen> createState() => _MangaHomeScreenState();
}

class _MangaHomeScreenState extends ConsumerState<MangaHomeScreen> {
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  int _fullDataLength = 20;
  int _page = 1;
  @override
  Widget build(BuildContext context) {
    final getManga = ref.watch(
        getPopularMangaProvider(source: widget.mangaType.source!, page: 1));
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.mangaType.source}'),
          actions: [
            MangaSearchButton(
                source: widget.mangaType.source!, lang: widget.mangaType.lang!),
            IconButton(
              onPressed: () {
                Map<String, String> data = {
                  'url': getMangaBaseUrl(widget.mangaType.source!),
                  'source': widget.mangaType.source!,
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
        ),
        body: getManga.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text("No result"));
            }
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
            final length =
                widget.mangaType.isFullData! ? _fullDataLength : data.length;
            return Column(
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
          getMangaDetailModel: data,
          lang: widget.lang,
        );
      },
      loading: () => CoverViewWidget(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: Theme.of(context).cardColor,
            width: 200,
            height: 270,
          ),
        ),
        BottomTextWidget(
          text: widget.manga.name!,
          isLoading: true,
        )
      ]),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
