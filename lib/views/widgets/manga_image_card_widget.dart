import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/views/widgets/bottom_text_widget.dart';
import 'package:mangayomi/views/widgets/cover_view_widget.dart';

class MangaImageCardWidget extends StatelessWidget {
  final String lang;
  final bool isLoading;

  final GetManga? getMangaDetailModel;

  const MangaImageCardWidget({
    required this.lang,
    super.key,
    this.isLoading = false,
    required this.getMangaDetailModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final manga = Manga(
            imageUrl: getMangaDetailModel!.imageUrl,
            name: getMangaDetailModel!.name,
            genre: getMangaDetailModel!.genre,
            author: getMangaDetailModel!.author,
            status: getMangaDetailModel!.status,
            description: getMangaDetailModel!.description,
            link: getMangaDetailModel!.url,
            source: getMangaDetailModel!.source,
            lang: lang,
            lastUpdate: DateTime.now().millisecondsSinceEpoch);

        final empty = isar.mangas
            .filter()
            .langEqualTo(lang)
            .nameEqualTo(getMangaDetailModel!.name)
            .sourceEqualTo(getMangaDetailModel!.source)
            .isEmptySync();
        if (empty) {
          isar.writeTxnSync(() {
            isar.mangas.putSync(manga);
            for (var i = 0; i < getMangaDetailModel!.chapters.length; i++) {
              final chapters = Chapter(
                  name: getMangaDetailModel!.chapters[i].name,
                  url: getMangaDetailModel!.chapters[i].url,
                  dateUpload: getMangaDetailModel!.chapters[i].dateUpload,
                  scanlator: getMangaDetailModel!.chapters[i].scanlator,
                  mangaId: manga.id)
                ..manga.value = manga;
              isar.chapters.putSync(chapters);
              chapters.manga.saveSync();
            }
          });
        }
        final mangaId = isar.mangas
            .filter()
            .langEqualTo(lang)
            .nameEqualTo(getMangaDetailModel!.name)
            .sourceEqualTo(getMangaDetailModel!.source)
            .findFirstSync()!
            .id!;
        context.push('/manga-reader/detail', extra: mangaId);
      },
      child: CoverViewWidget(children: [
        cachedNetworkImage(
            headers: headers(getMangaDetailModel!.source!),
            imageUrl: getMangaDetailModel!.imageUrl!,
            width: 200,
            height: 270,
            fit: BoxFit.cover),
        BottomTextWidget(text: getMangaDetailModel!.name!)
      ]),
    );
  }
}
