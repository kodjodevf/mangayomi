import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/views/widgets/bottom_text_widget.dart';
import 'package:mangayomi/views/widgets/cover_view_widget.dart';
import 'package:mangayomi/views/widgets/gridview_widget.dart';

class LibraryGridViewWidget extends StatelessWidget {
  final List<ModelManga> entriesManga;
  const LibraryGridViewWidget({super.key, required this.entriesManga});

  @override
  Widget build(BuildContext context) {
    return GridViewWidget(
      itemCount: entriesManga.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            final model = ModelManga(
                imageUrl: entriesManga[index].imageUrl,
                name: entriesManga[index].name,
                genre: entriesManga[index].genre,
                author: entriesManga[index].author,
                status: entriesManga[index].status,
                chapterDate: entriesManga[index].chapterDate,
                chapterTitle: entriesManga[index].chapterTitle,
                chapterUrl: entriesManga[index].chapterUrl,
                description: entriesManga[index].description,
                favorite: entriesManga[index].favorite,
                link: entriesManga[index].link,
                source: entriesManga[index].source,
                lang: entriesManga[index].lang);

            context.push('/manga-reader/detail', extra: model);
          },
          child: CoverViewWidget(
            children: [
              Stack(
                children: [
                  cachedNetworkImage(
                      imageUrl: entriesManga[index].imageUrl!,
                      width: 200,
                      height: 270,
                      fit: BoxFit.cover),
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: generalColor(context),),
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: Text(entriesManga[index]
                                .chapterDate!
                                .length
                                .toString()),
                          ),
                        ),
                      ))
                ],
              ),
              BottomTextWidget(text: entriesManga[index].name!)
            ],
          ),
        );
      },
    );
    ;
  }
}
