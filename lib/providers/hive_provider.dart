import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/categories.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/models/manga_history.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:mangayomi/views/manga/download/download_model.dart';
import 'package:mangayomi/views/manga/reader/providers/reader_controller_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'hive_provider.g.dart';

@riverpod
Box<ModelManga> hiveBoxManga(HiveBoxMangaRef ref) {
  return Hive.box<ModelManga>(HiveConstant.hiveBoxManga);
}

@riverpod
Box hiveBoxMangaInfo(HiveBoxMangaInfoRef ref) {
  return Hive.box(HiveConstant.hiveBoxMangaInfo);
}

@riverpod
Box<MangaHistoryModel> hiveBoxMangaHistory(HiveBoxMangaHistoryRef ref) {
  return Hive.box<MangaHistoryModel>(HiveConstant.hiveBoxMangaHistory);
}

@riverpod
Box<ReaderMode> hiveBoxReaderMode(HiveBoxReaderModeRef ref) {
  return Hive.box<ReaderMode>(HiveConstant.hiveBoxReaderMode);
}

@riverpod
Box hiveBoxMangaFilter(HiveBoxMangaFilterRef ref) {
  return Hive.box(HiveConstant.hiveBoxMangaFilter);
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

@riverpod
Box<CategoriesModel> hiveBoxCategories(HiveBoxCategoriesRef ref) {
  return Hive.box(HiveConstant.hiveBoxCategories);
}
