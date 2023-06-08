import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/services/search_manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/source_list.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/lang.dart';
import 'package:mangayomi/modules/library/search_text_form_field.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({
    super.key,
  });

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  String query = "";
  final _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final sourceList = ref.watch(onlyIncludePinnedSourceStateProvider)
        ? isar.sources.filter().isPinnedEqualTo(true).findAllSync()
        : sourcesList;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          SeachFormTextField(
            onChanged: (value) {},
            onPressed: () {
              Navigator.pop(context);
            },
            onFieldSubmitted: (value) {
              setState(() {
                query = value;
              });
            },
            onSuffixPressed: () {
              _textEditingController.clear();
              setState(() {
                query = "";
              });
            },
            controller: _textEditingController,
          )
        ],
      ),
      body: query.isNotEmpty
          ? ListView(
              children: [
                for (var i = 0; i < sourceList.length; i++)
                  SizedBox(
                    height: 260,
                    child: SourceSearchScreen(
                      query: query,
                      source: sourceList[i],
                    ),
                  ),
              ],
            )
          : Container(),
    );
  }
}

class SourceSearchScreen extends ConsumerWidget {
  final String query;

  final Source source;
  const SourceSearchScreen({
    super.key,
    required this.query,
    required this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(searchMangaProvider(
        source: source.sourceName!, query: query, lang: source.lang!));
    return Scaffold(
        body: SizedBox(
      height: 260,
      child: Column(
        children: [
          ListTile(
            dense: true,
            onTap: () {
              Map<String, dynamic> data = {
                'query': query,
                'source': source.sourceName,
                'lang': source.lang,
                'viewOnly': true,
              };
              context.push('/searchResult', extra: data);
            },
            title: Text(source.sourceName!),
            subtitle: Text(
              completeLang(source.lang!),
              style: const TextStyle(fontSize: 10),
            ),
            trailing: const Icon(Icons.arrow_forward_sharp),
          ),
          Flexible(
            child: search.when(
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                error: (error, stackTrace) =>
                    Center(child: Text(error.toString())),
                data: (data) {
                  if (data.isNotEmpty) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return MangaGlobalImageCard(
                          manga: data[index]!,
                          source: source.sourceName!,
                          lang: source.lang!,
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text("No result"),
                  );
                }),
          ),
        ],
      ),
    ));
  }
}

class MangaGlobalImageCard extends ConsumerStatefulWidget {
  final GetManga manga;
  final String source;
  final String lang;
  const MangaGlobalImageCard({
    super.key,
    required this.manga,
    required this.source,
    required this.lang,
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
    final getMangaDetail = ref.watch(getMangaDetailProvider(
        source: widget.source, manga: widget.manga, lang: widget.lang));

    return getMangaDetail.when(
      data: (data) {
        return GestureDetector(
          onTap: () async {
            pushToMangaReaderDetail(
                context: context, getManga: data, lang: widget.lang);
          },
          child: StreamBuilder(
              stream: isar.mangas
                  .filter()
                  .langEqualTo(widget.lang)
                  .nameEqualTo(data.name)
                  .sourceEqualTo(data.source)
                  .favoriteEqualTo(true)
                  .watch(fireImmediately: true),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Column(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: cachedNetworkImage(
                                headers: ref.watch(
                                    headersProvider(source: data.source!)),
                                imageUrl: data.imageUrl!,
                                width: 100,
                                height: 140,
                                fit: BoxFit.fill),
                          ),
                          BottomTextWidget(
                            fontSize: 12.0,
                            text: widget.manga.name!,
                            isLoading: true,
                            isComfortableGrid: true,
                          )
                        ]),
                      ),
                      Container(
                        width: 100,
                        height: 140,
                        color: snapshot.hasData && snapshot.data!.isNotEmpty
                            ? Colors.black.withOpacity(0.7)
                            : null,
                      ),
                      if (snapshot.hasData && snapshot.data!.isNotEmpty)
                        Positioned(
                            top: 0,
                            left: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: primaryColor(context),
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    "In library",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            )),
                    ],
                  ),
                );
              }),
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SizedBox(
          width: 100,
          child: Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Theme.of(context).cardColor,
                width: 100,
                height: 140,
              ),
            ),
            BottomTextWidget(
              fontSize: 12.0,
              text: widget.manga.name!,
              isLoading: true,
              isComfortableGrid: true,
            )
          ]),
        ),
      ),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
