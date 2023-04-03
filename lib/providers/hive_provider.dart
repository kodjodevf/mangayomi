import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/constant.dart';
import 'package:mangayomi/models/model_manga.dart';

final hiveBoxManga = Provider<Box<ModelManga>>((ref) {
  return Hive.box<ModelManga>(HiveConstant.hiveBoxManga);
});

final hiveBoxMangaInfo = Provider<Box>((ref) {
  return Hive.box(HiveConstant.hiveBoxMangaInfo);
});
