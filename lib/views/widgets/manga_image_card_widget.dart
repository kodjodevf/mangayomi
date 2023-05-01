import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/headers.dart';
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
    final manga = ref.watch(hiveBoxMangaProvider);
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
            chapters: getMangaDetailModel!.chapters,
            categories: [],
            lastRead: '');
        if (manga.get('$lang-${getMangaDetailModel!.url}',
                defaultValue: null) ==
            null) {
          manga.put('$lang-${getMangaDetailModel!.url}', modelManga);
        }

        context.push('/manga-reader/detail', extra: modelManga);
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
