import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/manga/detail/manga_detail_view.dart';

final isExtended = StateProvider.autoDispose<bool>((ref) {
  return true;
});

class MangaDetailsView extends ConsumerStatefulWidget {
  final ModelManga modelManga;
  final Function(bool) isFavorite;
  const MangaDetailsView({
    super.key,
    required this.isFavorite,
    required this.modelManga,
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
      floatingActionButton: widget.modelManga.chapterTitle!.isNotEmpty
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
                              : mediaWidth(context, 0.3),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () {
                              pushMangaReaderView(
                                  context: context,
                                  modelManga: widget.modelManga,
                                  index: int.parse(entries.toString()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  curve: Curves.easeIn,
                                  width: !ref.watch(isExtended)
                                      ? 0
                                      : mediaWidth(context, 0.15),
                                  duration: const Duration(milliseconds: 400),
                                  child: const Text(
                                    "Continue",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                const Icon(
                                  Icons.play_arrow,
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
                        width: !ref.watch(isExtended)
                            ? 60
                            : mediaWidth(context, 0.25),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            pushMangaReaderView(
                                context: context,
                                modelManga: widget.modelManga,
                                index:
                                    widget.modelManga.chapterTitle!.length - 1);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedContainer(
                                curve: Curves.easeIn,
                                width: !ref.watch(isExtended) ? 0 : 30,
                                duration: const Duration(milliseconds: 300),
                                child: const Text(
                                  "Read",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              AnimatedContainer(
                                curve: Curves.easeIn,
                                width: !ref.watch(isExtended) ? 0 : 10,
                                duration: const Duration(milliseconds: 300),
                              ),
                              const Icon(
                                Icons.play_arrow,
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
          : null,
      body: MangaDetailView(
        titleDescription: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.modelManga.author!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.clock,
                  size: 12,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(widget.modelManga.status!),
                const Text(' • '),
                Text(widget.modelManga.source!)
              ],
            )
          ],
        ),
        action: ValueListenableBuilder<Box<ModelManga>>(
          valueListenable: ref.watch(hiveBoxManga).listenable(),
          builder: (context, value, child) {
            final entries = value.values
                .where((element) => element.link == widget.modelManga.link)
                .toList();
            if (entries.isNotEmpty) {
              if (entries[0].favorite == true) {
                _checkFavorite(true);

                return SizedBox(
                  width: mediaWidth(context, 0.4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        elevation: 0),
                    onPressed: () {
                      _setFavorite(false);
                      manga.delete(widget.modelManga.link);
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.favorite,
                          size: 25,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text('In library')
                      ],
                    ),
                  ),
                );
              } else {
                _checkFavorite(false);
                return SizedBox(
                  width: mediaWidth(context, 0.4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        elevation: 0),
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
                    child: Column(
                      children: const [
                        Icon(
                          Icons.favorite_border_rounded,
                          size: 25,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text('Add to library')
                      ],
                    ),
                  ),
                );
              }
            }
            return SizedBox(
              width: mediaWidth(context, 0.4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0),
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
                child: Column(
                  children: const [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 25,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text('Add to library')
                  ],
                ),
              ),
            );
          },
        ),
        modelManga: widget.modelManga,
        listLength: widget.modelManga.chapterUrl!.length + 1,
        isExtended: (value) {
          ref.read(isExtended.notifier).state = value;
        },
      ),
    );
  }
}
