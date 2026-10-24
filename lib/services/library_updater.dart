import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/security_state_provider.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/background_work/background_work.dart';
import 'package:mangayomi/services/library_update_rules.dart';
import 'package:mangayomi/services/update_errors_provider.dart';
import 'package:mangayomi/services/update_manga_detail_providers.dart';
import 'package:mangayomi/utils/log/logger.dart';

/// Tracks whether a library update is running and lets the UI request its
/// cancellation. The update loop checks [LibraryUpdateState.cancelRequested]
/// between entries and stops early.
class LibraryUpdateState {
  final bool running;
  final bool cancelRequested;
  const LibraryUpdateState({
    this.running = false,
    this.cancelRequested = false,
  });
  LibraryUpdateState copyWith({bool? running, bool? cancelRequested}) =>
      LibraryUpdateState(
        running: running ?? this.running,
        cancelRequested: cancelRequested ?? this.cancelRequested,
      );
}

/// What a library update did.
class LibraryUpdateResult {
  const LibraryUpdateResult({this.failures = const [], this.queued = 0});

  /// The entries that failed to update.
  final List<UpdateError> failures;

  /// New chapters added to the download queue; the queue itself is started
  /// by the caller.
  final int queued;
}

class LibraryUpdateNotifier extends Notifier<LibraryUpdateState> {
  @override
  LibraryUpdateState build() => const LibraryUpdateState();
  void begin() => state = const LibraryUpdateState(running: true);
  void requestCancel() {
    if (state.running) state = state.copyWith(cancelRequested: true);
  }

  void end() => state = const LibraryUpdateState();

  /// Refreshes every entry in [mangaList], reporting progress through
  /// [onProgress] rather than touching the UI, so the same loop can run both
  /// behind the library's update button and unattended on launch.
  ///
  /// Returns the entries that failed and the new chapters queued for
  /// download. Honours the Stop button: the caller has already marked the run
  /// as started, and this checks for a cancellation between entries.
  ///
  /// Entries the update restrictions leave out are dropped first; with
  /// [wholeLibrary], so are those in a category set to skip updates.
  Future<LibraryUpdateResult> runUpdate({
    required List<Manga> mangaList,
    required String itemtype,
    bool wholeLibrary = false,
    void Function(int done, int failed, int total)? onProgress,
  }) async {
    mangaList = filterForUpdate(mangaList, wholeLibrary: wholeLibrary);
    final settings = settingsRepository.current;
    final downloadNew = settings.downloadNewChapters ?? false;
    final failures = <UpdateError>[];
    var queued = 0;
    BackgroundWork.begin(BackgroundWorkKind.libraryUpdate);
    try {
      for (var i = 0; i < mangaList.length; i++) {
        // Stop early if the user pressed Stop.
        if (state.cancelRequested) break;
        final manga = mangaList[i];
        try {
          // The chapters known before the update, to tell the new ones apart.
          // An entry with none yet is new to the library: its whole list is
          // "new", and downloading all of it is not what was asked.
          final before =
              downloadNew &&
                  downloadsNewChaptersOf(
                    manga,
                    included:
                        settings.downloadNewChaptersCategories ?? const [],
                    excluded:
                        settings.downloadNewChaptersExcludedCategories ??
                        const [],
                  )
              ? {
                  for (final chapter in chapterRepository.getAllByMangaId(
                    manga.id,
                  ))
                    chapter.id,
                }
              : const <int?>{};
          await ref.read(
            updateMangaDetailProvider(
              mangaId: manga.id,
              isInit: false,
              showToast: false,
            ).future,
          );
          if (before.isNotEmpty) {
            queued += await _queueNewChapters(manga, before);
          }
        } catch (e) {
          AppLogger.log(
            "Failed to update $itemtype:",
            logLevel: LogLevel.error,
          );
          AppLogger.log(e.toString(), logLevel: LogLevel.error);
          failures.add(
            UpdateError(
              mangaId: manga.id!,
              name: manga.name ?? "Unknown $itemtype",
              error: e.toString(),
            ),
          );
        }
        onProgress?.call(i + 1, failures.length, mangaList.length);
        BackgroundWork.report(
          BackgroundWorkKind.libraryUpdate,
          BackgroundWorkProgress(
            done: i + 1,
            total: mangaList.length,
            detail: manga.name,
          ),
        );
      }
    } finally {
      BackgroundWork.end(BackgroundWorkKind.libraryUpdate);
    }
    return LibraryUpdateResult(failures: failures, queued: queued);
  }

  /// Queues the unread chapters of [manga] that are not in [before], oldest
  /// first, and returns how many were queued.
  Future<int> _queueNewChapters(Manga manga, Set<int?> before) async {
    final fresh =
        chapterRepository
            .getAllByMangaId(manga.id)
            .where((c) => !before.contains(c.id) && c.isRead != true)
            .toList()
          ..sort((a, b) => a.id!.compareTo(b.id!));
    var queued = 0;
    for (final chapter in fresh) {
      if (await downloadRepository.enqueue(chapter) != null) queued++;
    }
    return queued;
  }

  /// Runs the scheduled library refresh when one is due, then records when it
  /// started so the next launch knows to leave it alone. Resolves to the
  /// run's result, or null when none ran.
  Future<LibraryUpdateResult?> autoUpdateIfDue() async {
    if (!ref.read(appUnlockedStateProvider)) return null;

    final settings = settingsRepository.current;
    if (!isLibraryUpdateDue(
      intervalHours: settings.autoLibraryUpdateInterval ?? 0,
      lastRun: settings.lastAutoLibraryUpdate,
      now: DateTime.now().millisecondsSinceEpoch,
    )) {
      return null;
    }

    if (state.running) return null;
    begin();

    try {
      if (settings.autoLibraryUpdateWifiOnly ?? true) {
        final connectivity = await Connectivity().checkConnectivity();
        final unmetered =
            connectivity.contains(ConnectivityResult.wifi) ||
            connectivity.contains(ConnectivityResult.ethernet);
        if (!unmetered) {
          AppLogger.log(
            "Scheduled library update skipped: metered connection.",
          );
          return null;
        }
      }

      // Local archives have no source to refresh from, so they're left out.
      final entries = <Manga>[];
      for (final itemType in ItemType.values) {
        entries.addAll(
          await mangaRepository.getFavoritesNonLocalArchiveByItemType(itemType),
        );
      }
      if (entries.isEmpty) return null;

      // Stamped before the run rather than after: a run cut short by the app
      // closing shouldn't make every following launch start over. Nothing above
      // stamps, so a run that never starts stays due.
      await settingsRepository.update(
        (s) => s.lastAutoLibraryUpdate = DateTime.now().millisecondsSinceEpoch,
      );

      AppLogger.log(
        "Starting scheduled library update (${entries.length} entries)...",
      );
      final result = await runUpdate(
        mangaList: entries,
        itemtype: "Library",
        wholeLibrary: true,
      );
      ref.read(updateErrorsProvider.notifier).set(result.failures);
      AppLogger.log(
        "Scheduled library update finished, ${result.failures.length} of "
        "${entries.length} failed.",
      );
      return result;
    } finally {
      end();
    }
  }
}

/// [mangaList] without the entries the update restrictions leave out; with
/// [wholeLibrary], also without those in a category set to skip updates.
List<Manga> filterForUpdate(
  List<Manga> mangaList, {
  bool wholeLibrary = false,
}) {
  final rules = LibraryUpdateRules.fromSettings(
    settingsRepository.current,
    skippedCategoryIds: wholeLibrary
        ? {
            for (final category in categoryRepository.getAll())
              if (category.shouldUpdate == false) category.id!,
          }
        : const {},
  );
  if (rules.isEmpty) return mangaList;
  return [
    for (final manga in mangaList)
      if (rules.allows(manga, chapterRepository.getAllByMangaId(manga.id)))
        manga,
  ];
}

final libraryUpdateProvider =
    NotifierProvider<LibraryUpdateNotifier, LibraryUpdateState>(
      LibraryUpdateNotifier.new,
    );

/// The refresh intervals offered in settings, in hours. 0 means never.
const libraryUpdateIntervals = <int>[0, 12, 24, 48, 168];

/// Whether a scheduled refresh is due, given the configured [intervalHours]
/// (0 meaning never), when the last one started, and the current time. All
/// times are epoch milliseconds.
///
/// A library that has never refreshed automatically counts as due, so turning
/// the setting on runs one at the next opportunity rather than a day later.
bool isLibraryUpdateDue({
  required int intervalHours,
  required int? lastRun,
  required int now,
}) {
  if (intervalHours <= 0) return false;
  return now - (lastRun ?? 0) >= intervalHours * Duration.millisecondsPerHour;
}

/// Runs the scheduled library refresh when one is due, then records when it
/// started so the next launch knows to leave it alone.
Future<LibraryUpdateResult?> autoUpdateLibraryIfDue(dynamic ref) =>
    ref.read(libraryUpdateProvider.notifier).autoUpdateIfDue();
