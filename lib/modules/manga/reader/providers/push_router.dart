import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/chapter.dart';

pushMangaReaderView({
  required BuildContext context,
  required Chapter chapter,
}) {
  print(chapter.manga.value!.isManga!);
  if (chapter.manga.value!.isManga!) {
    print("aaz");
    context.pushReplacement('/mangareaderview', extra: chapter);
  } else {
    print("object");
    context.push('/animestreamview', extra: chapter);
  }
}

pushReplacementMangaReaderView({
  required BuildContext context,
  required Chapter chapter,
}) {
  context.pushReplacement('/mangareaderview', extra: chapter);
}
