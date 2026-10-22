import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/security_state_provider.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
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
  /// Returns the entries that failed. Honours the Stop button: the caller has
  /// already marked the run as started, and this checks for a cancellation
  /// between entries.
  Future<List<UpdateError>> runUpdate({
    required List<Manga> mangaList,
    required String itemtype,
    void Function(int done, int failed, int total)? onProgress,
  }) async {
    final failures = <UpdateError>[];
    for (var i = 0; i < mangaList.length; i++) {
      // Stop early if the user pressed Stop.
      if (state.cancelRequested) break;
      final manga = mangaList[i];
      try {
        await ref.read(
          updateMangaDetailProvider(
            mangaId: manga.id,
            isInit: false,
            showToast: false,
          ).future,
        );
      } catch (e) {
        AppLogger.log("Failed to update $itemtype:", logLevel: LogLevel.error);
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
    }
    return failures;
  }

  /// Runs the scheduled library refresh when one is due, then records when it
  /// started so the next launch knows to leave it alone.
  Future<void> autoUpdateIfDue() async {
    if (!ref.read(appUnlockedStateProvider)) return;

    final settings = settingsRepository.current;
    if (!isLibraryUpdateDue(
      intervalHours: settings.autoLibraryUpdateInterval ?? 0,
      lastRun: settings.lastAutoLibraryUpdate,
      now: DateTime.now().millisecondsSinceEpoch,
    )) {
      return;
    }

    if (state.running) return;
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
          return;
        }
      }

      // Local archives have no source to refresh from, so they're left out.
      final entries = <Manga>[];
      for (final itemType in ItemType.values) {
        entries.addAll(
          await mangaRepository.getFavoritesNonLocalArchiveByItemType(itemType),
        );
      }
      if (entries.isEmpty) return;

      // Stamped before the run rather than after: a run cut short by the app
      // closing shouldn't make every following launch start over. Nothing above
      // stamps, so a run that never starts stays due.
      await settingsRepository.update(
        (s) => s.lastAutoLibraryUpdate = DateTime.now().millisecondsSinceEpoch,
      );

      AppLogger.log(
        "Starting scheduled library update (${entries.length} entries)...",
      );
      final failures = await runUpdate(mangaList: entries, itemtype: "Library");
      ref.read(updateErrorsProvider.notifier).set(failures);
      AppLogger.log(
        "Scheduled library update finished, ${failures.length} of "
        "${entries.length} failed.",
      );
    } finally {
      end();
    }
  }
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
Future<void> autoUpdateLibraryIfDue(dynamic ref) =>
    ref.read(libraryUpdateProvider.notifier).autoUpdateIfDue();
