import 'dart:io';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'downloads_state_provider.g.dart';

@riverpod
class OnlyOnWifiState extends _$OnlyOnWifiState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.downloadOnlyOnWifi ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..downloadOnlyOnWifi = value));
  }
}

@riverpod
class SaveAsCBZArchiveState extends _$SaveAsCBZArchiveState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.saveAsCBZArchive ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..saveAsCBZArchive = value));
  }
}

@riverpod
class DownloadLocationState extends _$DownloadLocationState {
  @override
  (String, String) build() {
    return ("", isar.settings.getSync(227)!.downloadLocation ?? "");
  }

  void set(String location) {
    final settings = isar.settings.getSync(227);
    state = ("${_storageProvider!.path}downloads", location);
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..downloadLocation = location));
  }

  Directory? _storageProvider;

  Future refresh() async {
    _storageProvider = await StorageProvider().getDefaultDirectory();
    final settings = isar.settings.getSync(227);
    state = (
      "${_storageProvider!.path}downloads",
      settings!.downloadLocation ?? ""
    );
  }
}
