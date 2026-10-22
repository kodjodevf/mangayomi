import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:shiori/shiori.dart';

Future<void> pushMangaReaderView({
  required BuildContext context,
  required Chapter chapter,
}) async {
  final sourceExist = sourceRepository.isNotEmptyActiveByItemTypeLangName(
    chapter.manga.value!.itemType,
    chapter.manga.value!.lang!,
    chapter.manga.value!.source!,
  );
  if (sourceExist || chapter.manga.value!.isLocalArchive!) {
    switch (chapter.manga.value!.itemType) {
      case ItemType.manga:
        await context.push('/mangaReaderView', extra: chapter.id!);
        break;
      case ItemType.anime:
        await context.push('/animePlayerView', extra: chapter.id!);
        break;
      case ItemType.novel:
        await context.push('/novelReaderView', extra: chapter.id!);
        break;
    }
  } else {
    // A tap that opened nothing used to say nothing: the series' source is
    // not installed. Say so, and offer to move the series to one that is.
    final manga = chapter.manga.value!;
    botToast(
      context.l10n.source_not_added,
      second: 6,
      tone: ShioriToastTone.warning,
      actions: [
        ShioriToastAction(
          context.l10n.migrate,
          () => context.push('/migrate', extra: manga),
        ),
      ],
    );
  }
}

void pushReplacementMangaReaderView({
  required BuildContext context,
  required Chapter chapter,
}) {
  switch (chapter.manga.value!.itemType) {
    case ItemType.manga:
      context.pushReplacement('/mangaReaderView', extra: chapter.id!);
      break;
    case ItemType.anime:
      context.pushReplacement('/animePlayerView', extra: chapter.id!);
      break;
    case ItemType.novel:
      context.pushReplacement('/novelReaderView', extra: chapter.id!);
      break;
  }
}
