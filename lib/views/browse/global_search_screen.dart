import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/services/search_manga.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/lang.dart';
import 'package:mangayomi/views/library/search_text_form_field.dart';
import 'package:mangayomi/views/widgets/bottom_text_widget.dart';

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
    final sourceList = ref
        .watch(hiveBoxMangaSourceProvider)
        .values
        .where((element) => element.isAdded == true)
        .toList();
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
                    height: 230,
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

  final SourceModel source;
  const SourceSearchScreen({
    super.key,
    required this.query,
    required this.source,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search =
        ref.watch(searchMangaProvider(source: source.sourceName, query: query));
    return Scaffold(
        body: SizedBox(
      height: 240,
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
            title: Text(source.sourceName),
            subtitle: Text(
              completeLang(source.lang),
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
                  if (data.name.isNotEmpty) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.name.length,
                      itemBuilder: (context, index) {
                        return MangaGlobalImageCard(
                          url: data.url[index]!,
                          name: data.name[index]!,
                          image: data.image[index]!,
                          source: source.sourceName,
                          lang: source.lang,
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
  final String image;
  final String url;
  final String name;
  final String source;
  final String lang;
  const MangaGlobalImageCard({
    super.key,
    required this.url,
    required this.name,
    required this.image,
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
        source: widget.source,
        imageUrl: widget.image,
        title: widget.name,
        url: widget.url,
        lang: widget.lang));

    return getMangaDetail.when(
      data: (data) {
        return GestureDetector(
          onTap: () async {
            final manga = Manga(
                imageUrl: data.imageUrl,
                name: data.name,
                genre: data.genre,
                author: data.author,
                status: data.status,
                description: data.description,
                link: data.url,
                source: data.source,
                lang: widget.lang,
                lastUpdate: DateTime.now().millisecondsSinceEpoch);

            final empty = isar.mangas
                .filter()
                .langEqualTo(widget.lang)
                .nameEqualTo(data.name)
                .sourceEqualTo(data.source)
                .isEmptySync();
            if (empty) {
              isar.writeTxnSync(() {
                isar.mangas.putSync(manga);
                for (var i = 0; i < data.chapters.length; i++) {
                  final chapters = Chapter(
                      name: data.chapters[i].name,
                      url: data.chapters[i].url,
                      dateUpload: data.chapters[i].dateUpload,
                      scanlator: data.chapters[i].scanlator,
                      mangaId: manga.id)
                    ..manga.value = manga;
                  isar.chapters.putSync(chapters);
                  chapters.manga.saveSync();
                }
              });
            }
            final mangaId = isar.mangas
                .filter()
                .langEqualTo(widget.lang)
                .nameEqualTo(data.name)
                .sourceEqualTo(data.source)
                .findFirstSync()!
                .id!;
            context.push('/manga-reader/detail', extra: mangaId);
          },
          child: SizedBox(
            width: 90,
            child: Column(children: [
              cachedNetworkImage(
                  headers: headers(data.source!),
                  imageUrl: data.imageUrl!,
                  width: 80,
                  height: 120,
                  fit: BoxFit.fill),
              BottomTextWidget(
                fontSize: 12.0,
                text: widget.name,
                isLoading: true,
                isComfortableGrid: true,
              )
            ]),
          ),
        );
      },
      loading: () => SizedBox(
        width: 60,
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: Theme.of(context).cardColor,
              width: 80,
              height: 120,
            ),
          ),
          BottomTextWidget(
            fontSize: 12.0,
            text: widget.name,
            isLoading: true,
            isComfortableGrid: true,
          )
        ]),
      ),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
