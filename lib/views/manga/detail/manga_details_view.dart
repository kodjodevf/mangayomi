import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/manga/detail/card_sliver_app_bar.dart';

final isExtended = StateProvider.autoDispose<bool>((ref) {
  return true;
});

class MangaDetailsView extends ConsumerStatefulWidget {
  final bool isManga;
  final ModelManga modelManga;
  final Function(bool) isFavorite;
  const MangaDetailsView({
    super.key,
    required this.isFavorite,
    required this.modelManga,
    required this.isManga,
  });

  @override
  ConsumerState<MangaDetailsView> createState() => _MangaDetailsViewState();
}

class _MangaDetailsViewState extends ConsumerState<MangaDetailsView> {
  bool isFavorite = false;
  bool _isOk = false;
  bool isGplay = false;
  _checkFavorite(bool i) async {
    if (!_isOk) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (mounted) {
        setState(() {
          widget.isFavorite(i);
          isFavorite = i;
          _isOk = true;
        });
      }
    }
  }

  _setFavorite(bool i) async {
    if (mounted) {
      setState(() {
        widget.isFavorite(i);
        isFavorite = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final manga = ref.watch(hiveBoxManga);
    return Scaffold(
      floatingActionButton: widget.isManga
          ? widget.modelManga.chapterTitle!.isNotEmpty
              ? ValueListenableBuilder<Box>(
                  valueListenable: ref.watch(hiveBoxMangaInfo).listenable(),
                  builder: (context, value, child) {
                    final entries = value.get(
                        "${widget.modelManga.source}/${widget.modelManga.name}-chapter_index",
                        defaultValue: '');
                    if (entries.isNotEmpty) {
                      return Consumer(builder: (context, ref, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              height: 50,
                              width: !ref.watch(isExtended)
                                  ? 63
                                  : mediaWidth(context, 0.4),
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeIn,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.easeIn,
                                      width: !ref.watch(isExtended)
                                          ? 0
                                          : mediaWidth(context, 0.2),
                                      duration:
                                          const Duration(milliseconds: 400),
                                      child: Text(
                                        widget.modelManga.chapterTitle![
                                            int.parse(entries.toString())],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                    }
                    return Consumer(builder: (context, ref, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            height: 50,
                            width: !ref.watch(isExtended) ? null : null,
                            duration: const Duration(microseconds: 500),
                            curve: Curves.elasticOut,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AnimatedContainer(
                                    curve: Curves.elasticOut,
                                    width: !ref.watch(isExtended) ? 0 : null,
                                    duration: const Duration(microseconds: 500),
                                    child: Text(
                                      "Read",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    curve: Curves.elasticOut,
                                    width: !ref.watch(isExtended) ? 0 : 10,
                                    duration: const Duration(microseconds: 500),
                                  ),
                                  const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    });
                  },
                )
              : Container()
          : Container(),
      body: CardSliverAppBar(
        height: 200,
        title: Text(widget.modelManga.name!,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        titleDescription: Row(
          children: [
            Flexible(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return index == 0
                      ? Row(
                          children: [
                            CircleAvatar(
                                backgroundColor: Theme.of(context).cardColor,
                                radius: 12,
                                child: const Icon(
                                  FontAwesomeIcons.clock,
                                  size: 13,
                                )),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(widget.modelManga.status!)
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: Theme.of(context).cardColor,
                                  radius: 12,
                                  child: const Icon(
                                    FontAwesomeIcons.user,
                                    size: 13,
                                  )),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(widget.modelManga.author!)
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        ),
        action: widget.isManga
            ? ValueListenableBuilder<Box<ModelManga>>(
                valueListenable: ref.watch(hiveBoxManga).listenable(),
                builder: (context, value, child) {
                  final entries = value.values
                      .where(
                          (element) => element.link == widget.modelManga.link)
                      .toList();
                  if (entries.isNotEmpty) {
                    if (entries[0].favorite == true) {
                      _checkFavorite(true);

                      return IconButton(
                          onPressed: () {
                            _setFavorite(false);
                            manga.delete(widget.modelManga.link);
                          },
                          icon: const Icon(Icons.favorite));
                    } else {
                      _checkFavorite(false);
                      return IconButton(
                          onPressed: () {
                            _setFavorite(true);
                            final model = ModelManga(
                                imageUrl: widget.modelManga.imageUrl,
                                name: widget.modelManga.name,
                                genre: widget.modelManga.genre,
                                author: widget.modelManga.author,
                                status: widget.modelManga.status,
                                chapterDate: widget.modelManga.chapterDate,
                                chapterTitle: widget.modelManga.chapterTitle,
                                chapterUrl: widget.modelManga.chapterUrl,
                                description: widget.modelManga.description,
                                favorite: true,
                                link: widget.modelManga.link,
                                source: widget.modelManga.source,
                                lang: widget.modelManga.lang);
                            manga.put(widget.modelManga.link, model);
                          },
                          icon: const Icon(Icons.favorite_border_rounded));
                    }
                  }
                  return IconButton(
                      onPressed: () {
                        _setFavorite(true);
                        final model = ModelManga(
                            imageUrl: widget.modelManga.imageUrl,
                            name: widget.modelManga.name,
                            genre: widget.modelManga.genre,
                            author: widget.modelManga.author,
                            status: widget.modelManga.status,
                            chapterDate: widget.modelManga.chapterDate,
                            chapterTitle: widget.modelManga.chapterTitle,
                            chapterUrl: widget.modelManga.chapterUrl,
                            description: widget.modelManga.description,
                            favorite: true,
                            link: widget.modelManga.link,
                            source: widget.modelManga.source,
                            lang: widget.modelManga.lang);
                        manga.put(widget.modelManga.link, model);
                      },
                      icon: const Icon(Icons.favorite_border_rounded));
                },
              )
            : Container(),
        chapterTitle: widget.modelManga.chapterTitle,
        genre: widget.modelManga.genre,
        isManga: widget.isManga,
        modelManga: widget.modelManga,
        description: widget.modelManga.description,
        isExtended: (value) {
          ref.read(isExtended.notifier).update((state) => value);
        },
      ),
    );
  }
}
