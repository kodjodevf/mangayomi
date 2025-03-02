import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/search_.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';

class MigrationScreen extends ConsumerStatefulWidget {
  final Manga manga;
  const MigrationScreen({required this.manga, super.key});

  @override
  ConsumerState<MigrationScreen> createState() => _MigrationScreenScreenState();
}

class _MigrationScreenScreenState extends ConsumerState<MigrationScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    List<Source> sourceList =
        ref.watch(onlyIncludePinnedSourceStateProvider)
            ? isar.sources
                .filter()
                .isPinnedEqualTo(true)
                .and()
                .itemTypeEqualTo(widget.manga.itemType)
                .findAllSync()
            : isar.sources
                .filter()
                .idIsNotNull()
                .and()
                .isAddedEqualTo(true)
                .and()
                .itemTypeEqualTo(widget.manga.itemType)
                .findAllSync();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.migrate)),
      body:
          widget.manga.name != null && widget.manga.author != null
              ? ListView(
                children: [
                  for (var source in sourceList)
                    SizedBox(
                      height: 260,
                      child: SourceSearchScreen(
                        query: widget.manga.name ?? widget.manga.author!,
                        manga: widget.manga,
                        source: source,
                      ),
                    ),
                ],
              )
              : Container(),
    );
  }
}

class SourceSearchScreen extends StatefulWidget {
  final String query;
  final Manga manga;

  final Source source;
  const SourceSearchScreen({
    super.key,
    required this.query,
    required this.manga,
    required this.source,
  });

  @override
  State<SourceSearchScreen> createState() => _SourceSearchScreenState();
}

class _SourceSearchScreenState extends State<SourceSearchScreen> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  String _errorMessage = "";
  bool _isLoading = true;
  MPages? pages;
  _init() async {
    try {
      _errorMessage = "";
      pages = await search(
        source: widget.source,
        page: 1,
        query: widget.query,
        filterList: [],
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
              title: Text(widget.source.name!),
              subtitle: Text(
                completeLanguageName(widget.source.lang!),
                style: const TextStyle(fontSize: 10),
              ),
            ),
            Flexible(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Builder(
                        builder: (context) {
                          if (_errorMessage.isNotEmpty) {
                            return Center(child: Text(_errorMessage));
                          }
                          if (pages!.list.isNotEmpty) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: pages!.list.length,
                              itemBuilder: (context, index) {
                                return MangaGlobalImageCard(
                                  oldManga: widget.manga,
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
  final Manga oldManga;
  final MManga manga;
  final Source source;

  const MangaGlobalImageCard({
    super.key,
    required this.oldManga,
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
    final l10n = l10nLocalizations(context)!;
    final getMangaDetail = widget.manga;
    return GestureDetector(
      onTap: () => _showMigrateDialog(context, l10n),
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
                  color:
                      hasData && snapshot.data!.first.favorite!
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

  void _showMigrateDialog(BuildContext context, dynamic l10n) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.migrate_confirm),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 15),
                Consumer(
                  builder:
                      (context, ref, child) => TextButton(
                        onPressed: () {
                          isar.writeTxnSync(() {
                            final histories =
                                isar.historys
                                    .filter()
                                    .mangaIdEqualTo(widget.oldManga.id)
                                    .findAllSync();
                            for (var history in histories) {
                              isar.historys.deleteSync(history.id!);
                              ref
                                  .read(synchingProvider(syncId: 1).notifier)
                                  .addChangedPart(
                                    ActionType.removeHistory,
                                    history.id,
                                    "{}",
                                    false,
                                  );
                            }
                            for (var chapter in widget.oldManga.chapters) {
                              isar.updates
                                  .filter()
                                  .mangaIdEqualTo(chapter.mangaId)
                                  .chapterNameEqualTo(chapter.name)
                                  .deleteAllSync();
                              isar.chapters.deleteSync(chapter.id!);
                              ref
                                  .read(synchingProvider(syncId: 1).notifier)
                                  .addChangedPart(
                                    ActionType.removeChapter,
                                    chapter.id,
                                    "{}",
                                    false,
                                  );
                            }
                            widget.oldManga.name = widget.manga.name;
                            widget.oldManga.link = widget.manga.link;
                            widget.oldManga.imageUrl = widget.manga.imageUrl;
                            widget.oldManga.lang = widget.source.lang;
                            widget.oldManga.source = widget.source.name;
                            isar.mangas.putSync(widget.oldManga);
                            ref
                                .read(synchingProvider(syncId: 1).notifier)
                                .addChangedPart(
                                  ActionType.updateItem,
                                  widget.oldManga.id,
                                  widget.oldManga.toJson(),
                                  false,
                                );
                          });
                          ref.read(
                            updateMangaDetailProvider(
                              mangaId: widget.oldManga.id,
                              isInit: false,
                            ),
                          );
                          ref.invalidate(
                            getMangaDetailStreamProvider(
                              mangaId: widget.oldManga.id!,
                            ),
                          );
                          Navigator.pop(ctx);
                          Navigator.pop(ctx);
                        },
                        child: Text(l10n.ok),
                      ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
