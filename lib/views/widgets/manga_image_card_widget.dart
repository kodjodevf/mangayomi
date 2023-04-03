import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/utils/cached_network.dart';
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
      onTap: () async {},
      child: CoverViewWidget(children: [
        cachedNetworkImage(
            headers: {
              "Referer": "https://www.mangahere.cc/",
              "Cookie": "isAdult=1"
            },
            imageUrl: widget.getMangaDetailModel!.image!,
            width: 200,
            height: 270,
            fit: BoxFit.cover),
        BottomTextWidget(text: widget.getMangaDetailModel!.name!)
      ]),
    );
  }
}
