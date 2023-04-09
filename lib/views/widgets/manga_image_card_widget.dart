import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/views/widgets/bottom_text_widget.dart';
import 'package:mangayomi/views/widgets/cover_view_widget.dart';

class MangaImageCardWidget extends ConsumerStatefulWidget {
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
  ConsumerState<MangaImageCardWidget> createState() =>
      _MangaImageCardWidgetState();
}

class _MangaImageCardWidgetState extends ConsumerState<MangaImageCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final modelManga = ModelManga(
            imageUrl: widget.getMangaDetailModel!.imageUrl,
            name: widget.getMangaDetailModel!.name,
            genre: widget.getMangaDetailModel!.genre,
            author: widget.getMangaDetailModel!.author,
            chapterDate: widget.getMangaDetailModel!.chapterDate,
            chapterTitle: widget.getMangaDetailModel!.chapterTitle,
            chapterUrl: widget.getMangaDetailModel!.chapterUrl,
            status: widget.getMangaDetailModel!.status,
            description: widget.getMangaDetailModel!.description,
            favorite: false,
            link: widget.getMangaDetailModel!.url,
            source: widget.getMangaDetailModel!.source,
            lang: widget.lang);
        if (mounted) {
          context.push('/manga-reader/detail', extra: modelManga);
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
