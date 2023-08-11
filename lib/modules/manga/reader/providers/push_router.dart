import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/source.dart';

pushMangaReaderView({
  required BuildContext context,
  required Chapter chapter,
}) {
  final sourceExist = isar.sources
      .filter()
      .langContains(chapter.manga.value!.lang!, caseSensitive: false)
      .and()
      .nameContains(chapter.manga.value!.source!, caseSensitive: false)
      .and()
      .idIsNotNull()
      .and()
      .isActiveEqualTo(true)
      .and()
      .isAddedEqualTo(true)
      .findAllSync()
      .isNotEmpty;
  if (sourceExist || chapter.manga.value!.isLocalArchive!) {
    if (chapter.manga.value!.isManga!) {
      context.push('/mangareaderview', extra: chapter);
    } else {
      context.push('/animestreamview', extra: chapter);
    }
  }
}

pushReplacementMangaReaderView({
  required BuildContext context,
  required Chapter chapter,
}) {
  if (chapter.manga.value!.isManga!) {
    context.pushReplacement('/mangareaderview', extra: chapter);
  } else {
    context.pushReplacement('/animestreamview', extra: chapter);
  }
}
