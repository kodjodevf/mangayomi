import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:shiori/shiori.dart';

class ContinueReaderButton extends ConsumerWidget {
  final Manga entry;

  const ContinueReaderButton({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The button looks the same regardless of history, so the last-read
    // chapter is resolved on tap — a live watch per grid cell made scrolling
    // large libraries churn dozens of query subscriptions.
    final tokens = context.shiori;
    final c = tokens.color;
    final size = tokens.scaled(32);
    return Semantics(
      button: true,
      label: context.l10n.resume,
      child: Material(
        color: c.accent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _resume(context, ref),
          child: SizedBox.square(
            dimension: size,
            child: Icon(
              Symbols.play_arrow_rounded,
              fill: 1,
              size: size * 0.6,
              color: c.onAccent,
            ),
          ),
        ),
      ),
    );
  }

  void _resume(BuildContext context, WidgetRef ref) {
    final incognitoMode = ref.read(incognitoModeStateProvider);
    final history = incognitoMode
        ? null
        : historyRepository.findByMangaId(entry.id!);
    if (history != null && !history.chapter.isLoaded) {
      history.chapter.loadSync();
    }
    final lastReadChapter = history?.chapter.value;
    if (lastReadChapter != null) {
      lastReadChapter.pushToReaderView(context);
    } else {
      entry.chapters.first.pushToReaderView(context);
    }
  }
}
