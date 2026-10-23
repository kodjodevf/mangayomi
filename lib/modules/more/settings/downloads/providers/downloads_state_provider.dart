import 'dart:io';

import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as path;
part 'downloads_state_provider.g.dart';

@riverpod
class OnlyOnWifiState extends _$OnlyOnWifiState {
  @override
  bool build() {
    return settingsRepository.current.downloadOnlyOnWifi ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.downloadOnlyOnWifi = value);
  }
}

@riverpod
class SaveAsCBZArchiveState extends _$SaveAsCBZArchiveState {
  @override
  bool build() {
    return settingsRepository.current.saveAsCBZArchive ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.saveAsCBZArchive = value);
  }
}

@riverpod
class DeleteDownloadAfterReadingState
    extends _$DeleteDownloadAfterReadingState {
  @override
  bool build() {
    return settingsRepository.current.deleteDownloadAfterReading ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.deleteDownloadAfterReading = value);
  }
}

@riverpod
class DownloadLocationState extends _$DownloadLocationState {
  @override
  (String, String) build() {
    _refresh();
    return ("", settingsRepository.current.downloadLocation ?? "");
  }

  void set(String location) {
    state = (path.join(_storageProvider!.path, 'downloads'), location);
    settingsRepository.update((s) => s.downloadLocation = location);
  }

  Directory? _storageProvider;

  Future _refresh() async {
    _storageProvider = await StorageProvider().getDefaultDirectory();
    state = (
      path.join(_storageProvider!.path, 'downloads'),
      settingsRepository.current.downloadLocation ?? "",
    );
  }
}

@riverpod
class ConcurrentDownloadsState extends _$ConcurrentDownloadsState {
  @override
  int build() {
    return settingsRepository.current.concurrentDownloads ?? 1;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.concurrentDownloads = value);
  }
}

@riverpod
class AllowConcurrentDownloadsState extends _$AllowConcurrentDownloadsState {
  @override
  bool build() {
    return settingsRepository.current.allowConcurrentDownloads ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.allowConcurrentDownloads = value);
  }
}

@riverpod
class AskDownloadDestinationState extends _$AskDownloadDestinationState {
  @override
  bool build() {
    return settingsRepository.current.askDownloadDestination ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.askDownloadDestination = value);
  }
}

@riverpod
class DownloadDelaySecondsState extends _$DownloadDelaySecondsState {
  @override
  int build() {
    return settingsRepository.current.downloadDelaySeconds ?? 0;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.downloadDelaySeconds = value);
  }
}

@riverpod
class DownloadNewChaptersState extends _$DownloadNewChaptersState {
  @override
  bool build() {
    return settingsRepository.current.downloadNewChapters ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.downloadNewChapters = value);
  }
}

@riverpod
class DownloadNewChaptersCategoriesState
    extends _$DownloadNewChaptersCategoriesState {
  @override
  List<int> build() {
    return settingsRepository.current.downloadNewChaptersCategories ?? const [];
  }

  void set(List<int> value) {
    state = value;
    settingsRepository.update((s) => s.downloadNewChaptersCategories = value);
  }
}

@riverpod
class DownloadNewChaptersExcludedCategoriesState
    extends _$DownloadNewChaptersExcludedCategoriesState {
  @override
  List<int> build() {
    return settingsRepository.current.downloadNewChaptersExcludedCategories ??
        const [];
  }

  void set(List<int> value) {
    state = value;
    settingsRepository.update(
      (s) => s.downloadNewChaptersExcludedCategories = value,
    );
  }
}

@riverpod
class DownloadAheadWhileReadingState extends _$DownloadAheadWhileReadingState {
  @override
  int build() {
    return settingsRepository.current.downloadAheadWhileReading ?? 0;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.downloadAheadWhileReading = value);
  }
}

@riverpod
class DeleteAfterReadingSlotState extends _$DeleteAfterReadingSlotState {
  @override
  int build() {
    return settingsRepository.current.deleteAfterReadingSlot ?? 0;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.deleteAfterReadingSlot = value);
  }
}

@riverpod
class DeleteBookmarkedAfterReadingState
    extends _$DeleteBookmarkedAfterReadingState {
  @override
  bool build() {
    return settingsRepository.current.deleteBookmarkedAfterReading ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.deleteBookmarkedAfterReading = value);
  }
}
