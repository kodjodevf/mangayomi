import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/models/manga_history.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:mangayomi/views/manga/reader/providers/reader_controller_provider.dart';

final hiveBoxManga = Provider<Box<ModelManga>>((ref) {
  return Hive.box<ModelManga>(HiveConstant.hiveBoxManga);
});

final hiveBoxMangaInfo = Provider<Box>((ref) {
  return Hive.box(HiveConstant.hiveBoxMangaInfo);
});

final hiveBoxMangaHistory = Provider<Box<MangaHistoryModel>>((ref) {
  return Hive.box<MangaHistoryModel>(HiveConstant.hiveBoxMangaHistory);
});
final hiveBoxReaderMode = Provider<Box<ReaderMode>>((ref) {
  return Hive.box<ReaderMode>(HiveConstant.hiveBoxReaderMode);
});
final hiveBoxMangaFilterProvider = Provider<Box>((ref) {
  return Hive.box(HiveConstant.hiveBoxMangaFilter);
});

final hiveBoxMangaSourceProvider = Provider<Box<SourceModel>>((ref) {
  return Hive.box<SourceModel>(HiveConstant.hiveBoxMangaSource);
});
final hiveBoxSettings = Provider<Box>((ref) {
  return Hive.box(HiveConstant.hiveBoxAppSettings);
});
