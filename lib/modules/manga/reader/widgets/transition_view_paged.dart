import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/chapter_transition_page.dart';

class TransitionViewPaged extends ConsumerWidget {
  final UChapDataPreload data;
  final ReaderMode? readerMode;

  const TransitionViewPaged({
    super.key,
    required this.data,
    this.readerMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!data.isTransitionPage || data.chapter == null) {
      return const SizedBox.shrink();
    }

    final mode = readerMode ??
        () {
          try {
            return ref
                .read(readerControllerProvider(chapter: data.chapter!).notifier)
                .getReaderMode();
          } catch (_) {}
          return ReaderMode.ltr;
        }();

    return SizedBox.expand(
      child: ChapterTransitionPage(
        currentChapter: data.chapter!,
        nextChapter: data.nextChapter,
        mangaName: data.mangaName ?? '',
        readerMode: mode,
      ),
    );
  }
}
