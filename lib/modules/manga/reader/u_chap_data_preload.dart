import 'dart:io';
import 'dart:typed_data';

import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

class UChapDataPreload {
  Chapter? chapter;
  Directory? directory;
  PageUrl? pageUrl;
  bool? isLocale;
  Uint8List? archiveImage;
  int? index;
  GetChapterPagesModel? chapterUrlModel;
  int? pageIndex;
  Uint8List? cropImage;
  bool isTransitionPage;
  Chapter? nextChapter;
  String? mangaName;
  bool? isLastChapter;

  UChapDataPreload(
    this.chapter,
    this.directory,
    this.pageUrl,
    this.isLocale,
    this.archiveImage,
    this.index,
    this.chapterUrlModel,
    this.pageIndex, {
    this.cropImage,
    this.isTransitionPage = false,
    this.nextChapter,
    this.mangaName,
    this.isLastChapter = false,
  });

  UChapDataPreload.transition({
    required Chapter currentChapter,
    required this.nextChapter,
    required String this.mangaName,
    required int this.pageIndex,
    this.isLastChapter = false,
  }) : chapter = currentChapter,
       isTransitionPage = true,
       directory = null,
       pageUrl = null,
       isLocale = null,
       archiveImage = null,
       index = null,
       chapterUrlModel = null,
       cropImage = null;
}
