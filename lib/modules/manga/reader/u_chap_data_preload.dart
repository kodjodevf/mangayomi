import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/utils/decoded_image_budget.dart';
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
  bool isTransitionPage;
  Chapter? nextChapter;
  String? mangaName;
  bool? isLastChapter;
  Rect? srcRect;

  /// The real on-disk path of this page, for local image-folder chapters
  /// whose pages already exist as standalone files. When set, this page
  /// never needs to be read into memory and copied back out to a temp file -
  /// [getLocalFilePath] returns it directly. Null for everything else
  /// (archive-file entries, downloaded/remote pages), which have no single
  /// real file they can point to up front.
  String? localImagePath;

  /// Cached rendered dimensions (set after image first loads)
  double? loadedHeight;
  double? loadedWidth;

  Image? _decodedImage;

  /// Cached decoded image for MinSubsamplingImage to avoid re-decoding on scroll.
  ///
  /// Bounded by [DecodedImageBudget]: when too many pages hold decoded pixels,
  /// the least recently used are released and re-decoded from the on-disk file
  /// when needed again. Callers keep the existing contract: dispose the old
  /// value yourself before assigning a new one (or null).
  Image? get decodedImage {
    final image = _decodedImage;
    if (image != null) DecodedImageBudget.instance.touch(this);
    return image;
  }

  set decodedImage(Image? image) {
    _decodedImage = image;
    if (image == null) {
      DecodedImageBudget.instance.unregister(this);
    } else {
      DecodedImageBudget.instance.register(
        this,
        image.width * image.height * 4, // RGBA, 4 bytes per pixel
        _releaseDecodedImage,
      );
    }
  }

  /// Called by [DecodedImageBudget] to give the pixels back. Widgets showing
  /// this page hold their own clone, so they are unaffected.
  void _releaseDecodedImage() {
    _decodedImage?.dispose();
    _decodedImage = null;
  }

  /// Cached resolved local file path for SubsamplingScaleImageView to avoid resolving on scroll
  String? resolvedFilePath;

  UChapDataPreload(
    this.chapter,
    this.directory,
    this.pageUrl,
    this.isLocale,
    this.archiveImage,
    this.index,
    this.chapterUrlModel,
    this.pageIndex, {
    this.isTransitionPage = false,
    this.nextChapter,
    this.mangaName,
    this.isLastChapter = false,
    this.srcRect,
    this.localImagePath,
  });

  /// Identifies this page among its neighbours in a list or page view, for
  /// widget keys. The two halves of a split wide page share [index] and only
  /// differ by [srcRect].
  String widgetKey(int fallbackIndex) {
    final half = srcRect == null ? '' : '-${srcRect!.left.round()}';
    return '${chapter?.id ?? "trans"}-${index ?? fallbackIndex}$half';
  }

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
       srcRect = null,
       localImagePath = null;
}
