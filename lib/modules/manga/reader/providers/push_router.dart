import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/source_repository.dart';

Future<void> pushMangaReaderView({
  required BuildContext context,
  required Chapter chapter,
  bool startAtEnd = false,
}) async {
  final sourceExist = sourceRepository.isNotEmptyActiveByItemTypeLangName(
    chapter.manga.value!.itemType,
    chapter.manga.value!.lang!,
    chapter.manga.value!.source!,
  );
  final extra = startAtEnd
      ? {'chapterId': chapter.id!, 'startAtEnd': true}
      : chapter.id!;
  if (sourceExist || chapter.manga.value!.isLocalArchive!) {
    switch (chapter.manga.value!.itemType) {
      case ItemType.manga:
        await context.push('/mangaReaderView', extra: extra);
        break;
      case ItemType.anime:
        await context.push('/animePlayerView', extra: chapter.id!);
        break;
      case ItemType.novel:
        await context.push('/novelReaderView', extra: extra);
        break;
    }
  }
}

void pushReplacementMangaReaderView({
  required BuildContext context,
  required Chapter chapter,
  bool startAtEnd = false,
}) {
  final extra = startAtEnd
      ? {'chapterId': chapter.id!, 'startAtEnd': true}
      : chapter.id!;
  switch (chapter.manga.value!.itemType) {
    case ItemType.manga:
      context.pushReplacement('/mangaReaderView', extra: extra);
      break;
    case ItemType.anime:
      context.pushReplacement('/animePlayerView', extra: chapter.id!);
      break;
    case ItemType.novel:
      context.pushReplacement('/novelReaderView', extra: extra);
      break;
  }
}
