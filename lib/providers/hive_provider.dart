import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_provider.g.dart';

@riverpod
Box hiveBoxManga(HiveBoxMangaRef ref) {
  return Hive.box(HiveConstant.hiveBoxMangaInfo);
}



@riverpod
Box hiveBoxSettings(HiveBoxSettingsRef ref) {
  return Hive.box(HiveConstant.hiveBoxAppSettings);
}
