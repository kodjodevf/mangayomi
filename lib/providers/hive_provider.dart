import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/download_model.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/models/source_model.dart';
import 'package:mangayomi/views/manga/reader/providers/reader_controller_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_provider.g.dart';

@riverpod
Box hiveBoxManga(HiveBoxMangaRef ref) {
  return Hive.box(HiveConstant.hiveBoxMangaInfo);
}

@riverpod
Box<ReaderMode> hiveBoxReaderMode(HiveBoxReaderModeRef ref) {
  return Hive.box<ReaderMode>(HiveConstant.hiveBoxReaderMode);
}

@riverpod
Box<SourceModel> hiveBoxMangaSource(HiveBoxMangaSourceRef ref) {
  return Hive.box<SourceModel>(HiveConstant.hiveBoxMangaSource);
}

@riverpod
Box<DownloadModel> hiveBoxMangaDownloads(HiveBoxMangaDownloadsRef ref) {
  return Hive.box<DownloadModel>(HiveConstant.hiveBoxDownloads);
}

@riverpod
Box hiveBoxSettings(HiveBoxSettingsRef ref) {
  return Hive.box(HiveConstant.hiveBoxAppSettings);
}
