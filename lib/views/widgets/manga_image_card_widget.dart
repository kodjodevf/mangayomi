import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/views/manga/detail/models/chapter_filter.dart';
import 'package:mangayomi/views/widgets/bottom_text_widget.dart';
import 'package:mangayomi/views/widgets/cover_view_widget.dart';

class MangaImageCardWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final modelManga = ModelManga(
            imageUrl: getMangaDetailModel!.imageUrl,
            name: getMangaDetailModel!.name,
            genre: getMangaDetailModel!.genre,
            author: getMangaDetailModel!.author,
            status: getMangaDetailModel!.status,
            description: getMangaDetailModel!.description,
            favorite: false,
            link: getMangaDetailModel!.url,
            source: getMangaDetailModel!.source,
            lang: lang,
            dateAdded: null,
            lastUpdate: null,
            categories: [],
            lastRead: '');

        final empty = await isar.modelMangas
            .filter()
            .langEqualTo(lang)
            .nameEqualTo(getMangaDetailModel!.name)
            .sourceEqualTo(getMangaDetailModel!.source)
            .isEmpty();
        if (empty) {
          await isar.writeTxn(() async {
            await isar.modelMangas.put(modelManga);
            for (var i = 0; i < getMangaDetailModel!.chapters.length; i++) {
              final chapters = ModelChapters(
                  name: getMangaDetailModel!.chapters[i].name,
                  url: getMangaDetailModel!.chapters[i].url,
                  dateUpload: getMangaDetailModel!.chapters[i].dateUpload,
                  isBookmarked: false,
                  scanlator: getMangaDetailModel!.chapters[i].scanlator,
                  isRead: false,
                  lastPageRead: '',
                  mangaId: modelManga.id)
                ..manga.value = modelManga;
              await isar.modelChapters.put(chapters);
              await chapters.manga.save();
              log(modelManga.id.toString());
              final chaptersFilters = ChaptersFilter()
                ..manga.value = modelManga;
              await isar.chaptersFilters.put(chaptersFilters);
              // await chaptersFilters.manga.save();
            }
          });
        }
        final getMangaId = await isar.modelMangas
            .filter()
            .langEqualTo(lang)
            .nameEqualTo(getMangaDetailModel!.name)
            .sourceEqualTo(getMangaDetailModel!.source)
            .findFirst();
        context.push('/manga-reader/detail', extra: getMangaId!.id);
        log("${getMangaId.id}");
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
