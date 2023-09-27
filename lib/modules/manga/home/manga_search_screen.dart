import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/search_manga.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:mangayomi/utils/media_query.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  final String query;
  final Source source;
  final bool viewOnly;
  const SearchResultScreen({
    super.key,
    required this.query,
    required this.source,
    this.viewOnly = false,
  });

  @override
  ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  int _length = 0;
  Future<List<MangaModel?>> _loadMore() async {
    List<MangaModel?> mangaResList = [];
    mangaResList = await ref.watch(searchMangaProvider(
            source: widget.source, query: widget.query, page: _page)
        .future);
    if (_isLoading) {
      if (mounted) {
        setState(() {
          _page = _page + 1;
        });
      }
    }
    return mangaResList;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final search = ref.watch(searchMangaProvider(
        source: widget.source, query: widget.query, page: _page));
    return Scaffold(
        appBar: widget.viewOnly
            ? AppBar(
                title: Text(widget.query),
              )
            : null,
        body: search.when(
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
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
                                    ref.invalidate(searchMangaProvider(
                                        source: widget.source,
                                        query: widget.query,
                                        page: 1));
                                  },
                                  icon: const Icon(Icons.refresh)),
                              Text(l10n.refresh)
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
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
              _length = data.length;
              _length = (data.length < _length ? data.length : _length);
              return GridViewWidget(
                controller: _scrollController,
                itemCount: _length + 1,
                itemBuilder: (context, index) {
                  if (index == _length) {
                    return buildProgressIndicator();
                  }
                  return MangaHomeImageCard(
                    manga: data[index]!,
                    source: widget.source,
                    isManga: widget.source.isManga ?? true,
                  );
                },
              );
            }));
  }
}
