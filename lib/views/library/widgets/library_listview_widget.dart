import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/widgets/listview_widget.dart';

class LibraryListViewWidget extends StatelessWidget {
  final List<ModelManga> entriesManga;
  const LibraryListViewWidget({super.key, required this.entriesManga});

  @override
  Widget build(BuildContext context) {
    return ListViewWidget(
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5)),
                        child: cachedNetworkImage(
                            imageUrl: entriesManga[index].imageUrl!,
                            width: 30,
                            height: 40,
                            fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                            width: mediaWidth(context, 0.7),
                            child: Text(entriesManga[index].name!)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Theme.of(context).cardColor),
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text(
                            entriesManga[index].chapterDate!.length.toString()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    ;
  }
}
