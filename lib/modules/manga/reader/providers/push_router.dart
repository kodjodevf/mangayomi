import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/chapter.dart';

pushMangaReaderView({
  required BuildContext context,
  required Chapter chapter,
}) {
  if (chapter.manga.value!.isManga!) {
    context.pushReplacement('/mangareaderview', extra: chapter);
  } else {
    context.push('/animestreamview', extra: chapter);
  }
}

pushReplacementMangaReaderView({
  required BuildContext context,
  required Chapter chapter,
}) {
  context.pushReplacement('/mangareaderview', extra: chapter);
}
