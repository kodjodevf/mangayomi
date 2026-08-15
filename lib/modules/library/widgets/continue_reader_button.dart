import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';

class ContinueReaderButton extends ConsumerWidget {
  final Manga entry;

  const ContinueReaderButton({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The button looks the same regardless of history, so the last-read
    // chapter is resolved on tap — a live watch per grid cell made scrolling
    // large libraries churn dozens of query subscriptions.
    return GestureDetector(
      onTap: () {
        final incognitoMode = ref.read(incognitoModeStateProvider);
        final history = incognitoMode
            ? null
            : isar.historys.where().mangaIdEqualTo(entry.id!).findFirstSync();
        if (history != null && !history.chapter.isLoaded) {
          history.chapter.loadSync();
        }
        final lastReadChapter = history?.chapter.value;
        if (lastReadChapter != null) {
          lastReadChapter.pushToReaderView(context);
        } else {
          entry.chapters.first.pushToReaderView(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: context.primaryColor.withValues(alpha: 0.9),
        ),
        child: const Padding(
          padding: EdgeInsets.all(7),
          child: Icon(Icons.play_arrow, size: 19, color: Colors.white),
        ),
      ),
    );
  }
}
