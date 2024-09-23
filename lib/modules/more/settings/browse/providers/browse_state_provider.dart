import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'browse_state_provider.g.dart';

@riverpod
class OnlyIncludePinnedSourceState extends _$OnlyIncludePinnedSourceState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.onlyIncludePinnedSources!;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(() =>
        isar.settings.putSync(settings!..onlyIncludePinnedSources = value));
  }
}

@riverpod
class AutoUpdateExtensionsState extends _$AutoUpdateExtensionsState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.autoExtensionsUpdates ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..autoExtensionsUpdates = value));
  }
}

@riverpod
class CheckForExtensionsUpdateState extends _$CheckForExtensionsUpdateState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.checkForExtensionUpdates ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(() =>
        isar.settings.putSync(settings!..checkForExtensionUpdates = value));
  }
}

@riverpod
class CustomMangaSourcesIndexUrlState
    extends _$CustomMangaSourcesIndexUrlState {
  @override
  String build() {
    return isar.settings.getSync(227)!.customMangaSourcesIndexUrl ?? "";
  }

  void set(String value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(() =>
        isar.settings.putSync(settings!..customMangaSourcesIndexUrl = value));
  }
}

@riverpod
class CustomAnimeSourcesIndexUrlState
    extends _$CustomAnimeSourcesIndexUrlState {
  @override
  String build() {
    return isar.settings.getSync(227)!.customAnimeSourcesIndexUrl ?? "";
  }

  void set(String value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(() =>
        isar.settings.putSync(settings!..customAnimeSourcesIndexUrl = value));
  }
}
