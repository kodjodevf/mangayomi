import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/model_manga.dart';

class MangaReaderModel {
  final ModelManga modelManga;
  final int index;
  MangaReaderModel({required this.index, required this.modelManga});
}

pushMangaReaderView(
    {required BuildContext context,
    required ModelManga modelManga,
    required int index}) {
  final mangaReaderModel =
      MangaReaderModel(index: index, modelManga: modelManga);
  context.push('/mangareaderview', extra: mangaReaderModel);
}

pushReplacementMangaReaderView(
    {required BuildContext context,
    required ModelManga modelManga,
    required int index}) {
  final mangaReaderModel =
      MangaReaderModel(index: index, modelManga: modelManga);
  context.pushReplacement('/mangareaderview', extra: mangaReaderModel);
}
