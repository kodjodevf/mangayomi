import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/repositories/history_repository.dart';

// Poster width per density scale (0 compact · 1 comfortable · 2 large); row
// height keeps a poster-plus-title aspect.
/// Matches `GridViewWidget`'s TV default, so an untouched grid-size setting
/// looks the same here as in the classic library.
const double _defaultCardWidth = 150;

/// Card width follows the library's own grid-size setting ("items per row",
/// 0 = default) — the slider in the filter/sort/display sheet drives the TV
/// home too, rather than the home keeping a private density of its own.
double tvCardWidth(BuildContext context, int gridSize) {
  final size = MediaQuery.sizeOf(context);
  final raw = gridSize <= 0
      ? _defaultCardWidth
      : (size.width - 44) / gridSize - 8;
  // A rail is not a grid: cap the card so "1 per row" can't eat the screen.
  final cap = ((size.height * 0.5) / 1.66).clamp(120.0, 400.0);
  return raw.clamp(90.0, cap);
}

double tvRowHeight(BuildContext context, int gridSize) =>
    tvCardWidth(context, gridSize) * 1.66;

int tvGridSize(WidgetRef ref) =>
    ref.watch(libraryGridSizeStateProvider(itemType: ItemType.anime)) ?? 0;

/// Mirrors GridViewWidget: 0 means "default", anything else is an exact number
/// of columns.
SliverGridDelegate tvGridDelegate(int gridSize) => gridSize <= 0
    ? const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: _defaultCardWidth + 10,
        childAspectRatio: 0.60,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      )
    : SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSize,
        childAspectRatio: 0.60,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      );

/// The episode to resume for [manga] — the last from watch history, else the
/// first chapter.
Chapter? tvResumeChapter(Manga manga) {
  final history = historyRepository.getAllByMangaId(manga.id!);
  if (history.isNotEmpty) {
    history.first.chapter.loadSync();
    final ch = history.first.chapter.value;
    if (ch != null) return ch;
  }
  return manga.chapters.isNotEmpty ? manga.chapters.first : null;
}

String tvFormatMs(int ms) {
  final d = Duration(milliseconds: ms);
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '${d.inMinutes}:$s';
}

bool isTvSelectKey(LogicalKeyboardKey k) =>
    k == LogicalKeyboardKey.select ||
    k == LogicalKeyboardKey.enter ||
    k == LogicalKeyboardKey.numpadEnter ||
    k == LogicalKeyboardKey.gameButtonA ||
    k == LogicalKeyboardKey.space;
