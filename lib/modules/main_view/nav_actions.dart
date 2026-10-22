import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/router/push_router.dart';

final libLocationRegex = RegExp(r"^/(Manga|Anime|Novel)Library$");

/// Nav destinations kept off the anime-only TV layout (the manga & novel
/// libraries). True means "keep this destination".
bool isNotHiddenLibOnTv(String nav) =>
    nav != "/MangaLibrary" && nav != "/NovelLibrary";

/// The ItemType a nav destination maps to, or null for destinations with no
/// single content type to scope a global search to (Updates, History,
/// Browse, More, ...). Shared by the desktop rail and mobile bottom bar's
/// double-tap-for-global-search handling.
ItemType? itemTypeForNavDest(String dest) => switch (dest) {
  "/MangaLibrary" => ItemType.manga,
  "/AnimeLibrary" => ItemType.anime,
  "/NovelLibrary" => ItemType.novel,
  _ => null,
};

/// How close together two taps on the same nav destination need to land to
/// count as a double-tap/double-click, rather than two separate single taps.
const navDoubleTapWindow = Duration(milliseconds: 450);

/// Resumes the most recently read/watched entry from history (optionally filtered by [itemType]),
/// or shows a snackbar if none found.
Future<void> resumeLatestHistory(
  BuildContext context, [
  ItemType? itemType,
]) async {
  // When an itemType is specified (e.g. from the active tab), strictly query that itemType.
  final history = itemType != null
      ? historyRepository.getLatestHistory(itemType)
      : historyRepository.getLatestHistory();
  if (history != null && history.chapterId != null) {
    final chapter = chapterRepository.findByIdSync(history.chapterId!);
    if (chapter != null && chapter.manga.value != null) {
      await pushMangaReaderView(context: context, chapter: chapter);
      return;
    }
  }
  if (context.mounted) {
    botToast(context.l10n.no_next_chapter, second: 2);
  }
}

/// Whether tapping [current] counts as a double-tap on [last], given when
/// [last] landed. Shared by the desktop rail and mobile bottom bar, which
/// each track their own last-tap state (an index vs. a route string) but
/// apply the same timing check to it.
bool isNavDoubleTap<T>(
  T current,
  T? last,
  DateTime? lastTapTime,
  DateTime now,
) {
  return current == last &&
      lastTapTime != null &&
      now.difference(lastTapTime) < navDoubleTapWindow;
}

/// Opens [destination] from a tap on the navigation: a group resolves to the
/// member last visited. A second tap inside the double-tap window opens
/// Global Search on a library, or resumes reading on Activity and History,
/// as it always has on their own routes. Shared by the bottom bar and the
/// rail.
void openNavDestination(
  BuildContext context,
  WidgetRef ref,
  String destination, {
  required bool isDoubleTap,
}) {
  final target = resolveNavDestination(
    destination,
    visible: ref.read(visibleNavDestinationsProvider),
    lastVisited: ref.read(lastNavMemberProvider)[destination],
  );
  if (isDoubleTap &&
      (target == '/history' || destination == NavGroup.activity)) {
    final activeType = ref.read(activeHistoryItemTypeStateProvider);
    unawaited(resumeLatestHistory(context, activeType));
    return;
  }
  final itemType = itemTypeForNavDest(target);
  if (isDoubleTap && itemType != null) {
    context.push('/globalSearch', extra: (null, itemType));
    return;
  }
  GoRouter.of(context).go(target);
}
