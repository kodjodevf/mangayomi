import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/chapter_transition_page.dart';

class TransitionViewPaged extends ConsumerWidget {
  final UChapDataPreload data;

  const TransitionViewPaged({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!data.isTransitionPage) {
      return const SizedBox.shrink();
    }

    return ChapterTransitionPage(
      currentChapter: data.chapter!,
      nextChapter: data.nextChapter,
      mangaName: data.mangaName ?? '',
    );
  }
}
