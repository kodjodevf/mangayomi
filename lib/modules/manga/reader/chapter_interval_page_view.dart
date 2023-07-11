import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/modules/manga/reader/manga_reader_view.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
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
    final l10n = l10nLocalizations(context)!;
    final readerController =
        ReaderController(chapter: uChapDataPreload.chapter!);

    String text = uChapDataPreload.hasPrevPrePage && hasPrevChapter
        ? l10n.current(":")
        : l10n.finished(":");
    final noMoreChapter = uChapDataPreload.hasNextPrePage && !hasNextChapter ||
        uChapDataPreload.hasPrevPrePage && !hasPrevChapter;
    // String noMore = uChapDataPreload.hasNextPrePage && !hasNextChapter
    //     ? l10n.next("")
    //     : l10n.previous("");
    return SizedBox(
      height: mediaHeight(context, 0.27),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (uChapDataPreload.hasPrevPrePage && hasPrevChapter)
            Column(
              children: [
                Text(
                  l10n.previous(":"),
                  style: const TextStyle(
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
              l10n.no_more_chapter,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          if (uChapDataPreload.hasNextPrePage && hasNextChapter)
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
                    Text(
                      l10n.next(":"),
                      style: const TextStyle(
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
