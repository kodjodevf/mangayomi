import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';

class GlobalSearchScreen extends ConsumerStatefulWidget {
  final bool isManga;
  const GlobalSearchScreen({
    required this.isManga,
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
    List<Source> sourceList = ref.watch(onlyIncludePinnedSourceStateProvider)
        ? isar.sources
            .filter()
            .isPinnedEqualTo(true)
            .and()
            .isMangaEqualTo(widget.isManga)
            .findAllSync()
        : isar.sources
            .filter()
            .idIsNotNull()
            .and()
            .isAddedEqualTo(true)
            .and()
            .isMangaEqualTo(widget.isManga)
            .findAllSync();
    sourceList = sourceList
        .where(
          (element) =>
              ref.watch(showNSFWStateProvider) ? true : element.isNsfw == false,
        )
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
    final l10n = l10nLocalizations(context)!;
    final search = ref.watch(searchProvider(
      source: source,
      page: 1,
      query: query,
    ));
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
                    query: query,
                    source: source,
                    isSearch: true,
                  )));
            },
            title: Text(source.name!),
            subtitle: Text(
              completeLanguageName(source.lang!),
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
                  if (data!.list.isNotEmpty) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.list.length,
                      itemBuilder: (context, index) {
                        return MangaGlobalImageCard(
                          manga: data.list[index],
                          source: source,
                        );
                      },
                    );
                  }
                  return Center(
                    child: Text(l10n.no_result),
                  );
                }),
          ),
        ],
      ),
    ));
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
    final l10n = l10nLocalizations(context)!;
    return GestureDetector(
      onTap: () async {
        pushToMangaReaderDetail(
            context: context,
            getManga: getMangaDetail,
            lang: widget.source.lang!,
            isManga: widget.source.isManga ?? true,
            useMaterialRoute: true,
            source: widget.source.name!);
      },
      child: StreamBuilder(
          stream: isar.mangas
              .filter()
              .langEqualTo(widget.source.lang)
              .nameEqualTo(getMangaDetail.name)
              .sourceEqualTo(widget.source.name)
              .watch(fireImmediately: true),
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Stack(
                children: [
                  SizedBox(
                    width: 110,
                    child: Column(children: [
                      snapshot.hasData &&
                              snapshot.data!.isNotEmpty &&
                              snapshot.data!.first.customCoverImage != null
                          ? Image.memory(snapshot.data!.first.customCoverImage
                              as Uint8List)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: cachedNetworkImage(
                                  headers: ref.watch(headersProvider(
                                      source: widget.source.name!,
                                      lang: widget.source.lang!)),
                                  imageUrl: snapshot.hasData &&
                                          snapshot.data!.isNotEmpty &&
                                          snapshot.data!.first.imageUrl != null
                                      ? toImgUrl(snapshot.data!.first.imageUrl!)
                                      : toImgUrl(getMangaDetail.imageUrl!),
                                  width: 110,
                                  height: 150,
                                  fit: BoxFit.fill),
                            ),
                      BottomTextWidget(
                        fontSize: 12.0,
                        text: widget.manga.name!,
                        isLoading: true,
                        textColor: Theme.of(context).textTheme.bodyLarge!.color,
                        isComfortableGrid: true,
                      )
                    ]),
                  ),
                  Container(
                    width: 110,
                    height: 150,
                    color: snapshot.hasData &&
                            snapshot.data!.isNotEmpty &&
                            snapshot.data!.first.favorite
                        ? Colors.black.withOpacity(0.7)
                        : null,
                  ),
                  if (snapshot.hasData &&
                      snapshot.data!.isNotEmpty &&
                      snapshot.data!.first.favorite)
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                                color: primaryColor(context),
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                l10n.in_library,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        )),
                ],
              ),
            );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
