import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/chapter_filter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/views/widgets/bottom_text_widget.dart';
import 'package:mangayomi/views/widgets/cover_view_widget.dart';

class MangaImageCardWidget extends StatefulWidget {
  final String lang;
  final bool isLoading;

  final GetMangaDetailModel? getMangaDetailModel;

  const MangaImageCardWidget({
    required this.lang,
    super.key,
    this.isLoading = false,
    required this.getMangaDetailModel,
  });

  @override
  State<MangaImageCardWidget> createState() => _MangaImageCardWidgetState();
}

class _MangaImageCardWidgetState extends State<MangaImageCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final modelManga = Manga(
          imageUrl: widget.getMangaDetailModel!.imageUrl,
          name: widget.getMangaDetailModel!.name,
          genre: widget.getMangaDetailModel!.genre,
          author: widget.getMangaDetailModel!.author,
          status: widget.getMangaDetailModel!.status,
          description: widget.getMangaDetailModel!.description,
          link: widget.getMangaDetailModel!.url,
          source: widget.getMangaDetailModel!.source,
          lang: widget.lang,
        );

        final empty = await isar.mangas
            .filter()
            .langEqualTo(widget.lang)
            .nameEqualTo(widget.getMangaDetailModel!.name)
            .sourceEqualTo(widget.getMangaDetailModel!.source)
            .isEmpty();
        if (empty) {
          await isar.writeTxn(() async {
            await isar.mangas.put(modelManga);
            for (var i = 0;
                i < widget.getMangaDetailModel!.chapters.length;
                i++) {
              final chapters = Chapter(
                  name: widget.getMangaDetailModel!.chapters[i].name,
                  url: widget.getMangaDetailModel!.chapters[i].url,
                  dateUpload:
                      widget.getMangaDetailModel!.chapters[i].dateUpload,
                  scanlator: widget.getMangaDetailModel!.chapters[i].scanlator,
                  mangaId: modelManga.id)
                ..manga.value = modelManga;
              await isar.chapters.put(chapters);
              await chapters.manga.save();
              final chaptersFilters = ChaptersFilter()
                ..manga.value = modelManga;
              await isar.chaptersFilters.put(chaptersFilters);
            }
          });
        }
        final getMangaId = await isar.mangas
            .filter()
            .langEqualTo(widget.lang)
            .nameEqualTo(widget.getMangaDetailModel!.name)
            .sourceEqualTo(widget.getMangaDetailModel!.source)
            .findFirst();
        if (mounted) {
          context.push('/manga-reader/detail', extra: getMangaId!.id);
        }
      },
      child: CoverViewWidget(children: [
        cachedNetworkImage(
            headers: headers(widget.getMangaDetailModel!.source!),
            imageUrl: widget.getMangaDetailModel!.imageUrl!,
            width: 200,
            height: 270,
            fit: BoxFit.cover),
        BottomTextWidget(text: widget.getMangaDetailModel!.name!)
      ]),
    );
  }
}
