import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/more/settings/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/views/widgets/listview_widget.dart';

class LibraryListViewWidget extends StatelessWidget {
  final List<ModelManga> entriesManga;
  final bool language;
  final bool downloadedChapter;
  final bool continueReaderBtn;
  const LibraryListViewWidget(
      {super.key,
      required this.entriesManga,
      required this.language,
      required this.downloadedChapter,
      required this.continueReaderBtn});

  @override
  Widget build(BuildContext context) {
    return ListViewWidget(
      itemCount: entriesManga.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.push('/manga-reader/detail', extra: entriesManga[index]);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Container(
              height: 45,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5)),
                          child: cachedNetworkImage(
                              imageUrl: entriesManga[index].imageUrl!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(entriesManga[index].name!),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: generalColor(context)),
                      child: SizedBox(
                        height: 22,
                        child: Row(
                          children: [
                            if (downloadedChapter)
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    List nbrDown = [];
                                    for (var i = 0;
                                        i <
                                            entriesManga[index]
                                                .chapters!
                                                .length;
                                        i++) {
                                      final entries = ref
                                          .watch(hiveBoxMangaDownloadsProvider)
                                          .values
                                          .where((element) =>
                                              element
                                                  .modelManga
                                                  .chapters![element.index]
                                                  .name ==
                                              entriesManga[index]
                                                  .chapters![i]
                                                  .name)
                                          .toList();
                                      if (entries.isNotEmpty &&
                                          entries.first.isDownload) {
                                        nbrDown.add(entries.first);
                                      }
                                    }
                                    if (nbrDown.isNotEmpty) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(3),
                                              bottomLeft: Radius.circular(3)),
                                          color: Theme.of(context).hintColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3, right: 3),
                                          child: Text(
                                            nbrDown.length.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Text(
                                entriesManga[index].chapters!.length.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            if (language)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(3),
                                      bottomRight: Radius.circular(3)),
                                  color: Theme.of(context).hintColor,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, right: 3),
                                  child: Text(
                                    entriesManga[index].lang!.toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (continueReaderBtn)
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Consumer(
                          builder: (context, ref, child) {
                            return ValueListenableBuilder<Box>(
                              valueListenable: ref
                                  .watch(hiveBoxMangaInfoProvider)
                                  .listenable(),
                              builder: (context, value, child) {
                                final entries = value.get(
                                    "${entriesManga[index].lang}-${entriesManga[index].source}/${entriesManga[index].name}-chapter_index",
                                    defaultValue: '');
                                final incognitoMode =
                                    ref.watch(incognitoModeStateProvider);

                                if (entries.isNotEmpty && !incognitoMode) {
                                  return GestureDetector(
                                    onTap: () {
                                      pushMangaReaderView(
                                          context: context,
                                          modelManga: entriesManga[index],
                                          index: int.parse(entries.toString()));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: generalColor(context)
                                            .withOpacity(0.7),
                                      ),
                                      child: const Padding(
                                          padding: EdgeInsets.all(7),
                                          child: Icon(
                                            Icons.play_arrow,
                                            size: 19,
                                            color: Colors.white,
                                          )),
                                    ),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    pushMangaReaderView(
                                        context: context,
                                        modelManga: entriesManga[index],
                                        index: entriesManga[index]
                                                .chapters!
                                                .length -
                                            1);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: generalColor(context)
                                          .withOpacity(0.7),
                                    ),
                                    child: const Padding(
                                        padding: EdgeInsets.all(7),
                                        child: Icon(
                                          Icons.play_arrow,
                                          size: 19,
                                          color: Colors.white,
                                        )),
                                  ),
                                );
                              },
                            );
                          },
                        ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
