import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/widgets/migrate_screen.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/search_.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class GlobalSearchScreen extends ConsumerStatefulWidget {
  final String? search;
  final ItemType itemType;
  const GlobalSearchScreen({this.search, required this.itemType, super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  String _query = "";
  final _textEditingController = TextEditingController();
  late final List<Source> sourceList =
      ref.read(onlyIncludePinnedSourceStateProvider)
      ? isar.sources
            .filter()
            .isPinnedEqualTo(true)
            .and()
            .itemTypeEqualTo(widget.itemType)
            .findAllSync()
      : isar.sources
            .filter()
            .idIsNotNull()
            .and()
            .isAddedEqualTo(true)
            .and()
            .itemTypeEqualTo(widget.itemType)
            .findAllSync();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.search ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.isNotEmpty ? _query : widget.search ?? "";

    return Scaffold(
      appBar: AppBar(
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
          ),
        ],
      ),
      body: _query.isNotEmpty || widget.search != null
          ? SuperListView.builder(
              itemCount: sourceList.length,
              extentPrecalculationPolicy: SuperPrecalculationPolicy(),
              itemBuilder: (context, index) {
                final source = sourceList[index];
                return SizedBox(
                  height: 260,
                  child: SourceSearchScreen(
                    key: ValueKey(query),
                    query: query,
                    source: source,
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

class SourceSearchScreen extends ConsumerStatefulWidget {
  final String query;

  final Source source;
  const SourceSearchScreen({
    super.key,
    required this.query,
    required this.source,
  });

  @override
  ConsumerState<SourceSearchScreen> createState() => _SourceSearchScreenState();
}

class _SourceSearchScreenState extends ConsumerState<SourceSearchScreen> {
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
              onTap: () {
                Navigator.push(
                  context,
                  createRoute(
                    page: MangaHomeScreen(
                      query: widget.query,
                      source: widget.source,
                      isSearch: true,
                    ),
                  ),
                );
              },
              title: Text(widget.source.name!),
              subtitle: Text(
                completeLanguageName(widget.source.lang!),
                style: const TextStyle(fontSize: 10),
              ),
              trailing: const Icon(Icons.arrow_forward_sharp),
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
                              return MangaGlobalImageCard(
                                manga: pages!.list[index],
                                source: widget.source,
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

class MangaGlobalImageCard extends ConsumerStatefulWidget {
  final MManga manga;
  final Source source;

  const MangaGlobalImageCard({
    super.key,
    required this.manga,
    required this.source,
  });

  @override
  ConsumerState<MangaGlobalImageCard> createState() =>
      _MangaGlobalImageCardState();
}

class _MangaGlobalImageCardState extends ConsumerState<MangaGlobalImageCard>
    with AutomaticKeepAliveClientMixin<MangaGlobalImageCard> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final getMangaDetail = widget.manga;
    return GestureDetector(
      onTap: () async {
        pushToMangaReaderDetail(
          ref: ref,
          context: context,
          getManga: getMangaDetail,
          lang: widget.source.lang!,
          itemType: widget.source.itemType,
          useMaterialRoute: true,
          source: widget.source.name!,
          sourceId: widget.source.id,
        );
      },
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
}
