import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/modules/manga/reader/manga_reader_view.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/utils/media_query.dart';

class ChapterIntervalPageView extends ConsumerWidget {
  final bool hasPrevChapter;
  final bool hasNextChapter;
  final UChapDataPreload uChapDataPreload;

  final VoidCallback onTap;
  const ChapterIntervalPageView(
      {super.key,
      required this.uChapDataPreload,
      required this.hasPrevChapter,
      required this.hasNextChapter,
      required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readerController =
        ReaderController(chapter: uChapDataPreload.chapter!);

    String text = uChapDataPreload.isPrevPrePage && hasPrevChapter
        ? "Current:"
        : "Finished:";
    final noMoreChapter = uChapDataPreload.isNextPrePage && !hasNextChapter ||
        uChapDataPreload.isPrevPrePage && !hasPrevChapter;
    String noMore =
        uChapDataPreload.isNextPrePage && !hasNextChapter ? "Next" : "Previous";
    return SizedBox(
      height: mediaHeight(context, 0.27),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (uChapDataPreload.isPrevPrePage && hasPrevChapter)
            Column(
              children: [
                const Text(
                  "Previous:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12),
                ),
                Text(readerController.getPrevChapter().name!,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                    Wrap(
                      children: [
                        Text(
                          uChapDataPreload.chapter!.name!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        const Icon(
                          FontAwesomeIcons.circleCheck,
                          color: Colors.white,
                          size: 17,
                        ),
                      ],
                    ),
                    // ElevatedButton(onPressed: onTap, child: const Text("Retry")),
                  ],
                ),
              ],
            ),
          if (noMoreChapter)
            Text(
              "There is no $noMore chapter",
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          if (uChapDataPreload.isNextPrePage && hasNextChapter)
            Column(
              children: [
                Column(
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          uChapDataPreload.chapter!.name!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        const Icon(
                          FontAwesomeIcons.circleCheck,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Next:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      readerController.getNextChapter().name!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // ElevatedButton(
                    //     onPressed: onTap,
                    //     child: const Text("Load Next chapter")),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
