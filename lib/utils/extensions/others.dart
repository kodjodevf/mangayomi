import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:path/path.dart' as p;

extension FileFormatter on num {
  String formattedFileSize({bool base1024 = true}) {
    if (this <= 0) return "0.00 B";
    final base = base1024 ? 1024 : 1000;
    final units = base1024
        ? ["B", "KiB", "MiB", "GiB", "TiB"]
        : ["B", "kB", "MB", "GB", "TB"];
    int digitGroups = (log(this) / log(base)).floor().clamp(
      0,
      units.length - 1,
    );
    return "${NumberFormat("#,##0.#").format(this / pow(base, digitGroups))} ${units[digitGroups]}";
  }
}

extension LetExtension<T> on T {
  R let<R>(R Function(T) block) {
    return block(this);
  }
}

extension MedianExtension on List<int> {
  int median() {
    final sorted = List<int>.from(this)..sort();
    var middle = sorted.length ~/ 2;
    if (sorted.length % 2 == 1) {
      return sorted[middle];
    } else {
      return ((sorted[middle - 1] + sorted[middle]) / 2).round();
    }
  }

  int arithmeticMean() {
    return isNotEmpty ? (reduce((e1, e2) => e1 + e2) / length).round() : 0;
  }
}

extension ImageProviderExtension on ImageProvider {
  Future<Uint8List?> getBytes(
    BuildContext context, {
    ImageByteFormat format = ImageByteFormat.png,
  }) async {
    final imageStream = resolve(createLocalImageConfiguration(context));
    final Completer<Uint8List?> completer = Completer<Uint8List?>();
    final ImageStreamListener listener = ImageStreamListener((
      imageInfo,
      synchronousCall,
    ) async {
      final bytes = await imageInfo.image.toByteData(format: format);
      if (!completer.isCompleted) {
        completer.complete(bytes?.buffer.asUint8List());
      }
    });
    imageStream.addListener(listener);
    final imageBytes = await completer.future;
    imageStream.removeListener(listener);
    return imageBytes;
  }
}

extension UChapDataPreloadExtensions on UChapDataPreload {
  Future<String?> get getLocalFilePath async {
    if (isTransitionPage) return null;
    if (archiveImage != null) {
      final tempDir = Directory.systemTemp;
      final sourceKey = [
        chapter?.id?.toString(),
        chapter?.archivePath,
        directory?.path,
        chapter?.url,
      ].whereType<String>().where((value) => value.isNotEmpty).join('|');
      final chapterKey = keyToMd5(sourceKey);
      final tempFile = File(
        p.join(
          tempDir.path,
          'mangayomi_archive_${chapterKey}_${index ?? pageIndex}.jpg',
        ),
      );
      if (!tempFile.existsSync()) {
        tempFile.writeAsBytesSync(archiveImage!);
      }
      return tempFile.path;
    }
    if (isLocale == true && directory != null && index != null) {
      return findDownloadedPageFile(directory!, index!)?.path;
    }
    if (pageUrl != null) {
      final cachedImage = await _getCachedImageFile(pageUrl!.url);
      if (cachedImage != null) {
        return cachedImage.path;
      }
    }
    return null;
  }

  Future<Uint8List?> get getImageBytes async {
    Uint8List? imageBytes;
    if (archiveImage != null) {
      imageBytes = archiveImage;
    } else if (isLocale == true && directory != null && index != null) {
      final file = await findDownloadedPageFileAsync(directory!, index!);
      imageBytes = await file?.readAsBytes();
    } else {
      File? cachedImage;
      if (pageUrl != null) {
        cachedImage = await _getCachedImageFile(pageUrl!.url);
        if (cachedImage == null) {
          await Future.delayed(const Duration(seconds: 3));
          cachedImage = await _getCachedImageFile(pageUrl!.url);
        }
      }
      imageBytes = await cachedImage?.readAsBytes();
    }
    return imageBytes;
  }

  ImageProvider<Object> getImageProvider(
    WidgetRef ref,
    bool showCloudFlareError,
  ) {
    final data = this;

    if (data.isTransitionPage) {
      return const AssetImage(transparentAsset) as ImageProvider<Object>;
    }

    final isLocale = data.isLocale!;
    final archiveImage = data.archiveImage;
    return isLocale
        ? archiveImage != null
              ? MemoryImage(archiveImage)
              : FileImage(
                  findDownloadedPageFile(data.directory!, data.index!) ??
                      // Nothing found under any known extension - fall back
                      // to the historical .jpg guess so this still fails via
                      // FileImage's own "file not found" error handling
                      // rather than throwing here.
                      File(
                        p.join(
                          data.directory!.path,
                          "${padIndex(data.index!)}.jpg",
                        ),
                      ),
                )
        : CustomExtendedNetworkImageProvider(
            data.pageUrl!.url.trim(),
            cache: true,
            cacheMaxAge: const Duration(days: 7),
            showCloudFlareError: showCloudFlareError,
            imageCacheFolderName: "cacheimagemanga",
            headers: {
              ...data.pageUrl!.headers ?? {},
              if (ref.context.mounted)
                ...ref.watch(
                  headersProvider(
                    source: data.chapter!.manga.value!.source!,
                    lang: data.chapter!.manga.value!.lang!,
                    sourceId: data.chapter!.manga.value!.sourceId,
                  ),
                ),
            },
          ) as ImageProvider<Object>;
  }
}

Future<File?> _getCachedImageFile(String url, {String? cacheKey}) async {
  try {
    // Cache files are named exactly by their md5 key, so the path can be
    // built directly — listing the whole cache directory to find one file
    // scaled with the cache size.
    final String key = cacheKey ?? keyToMd5(url);
    final Directory cacheImagesDirectory = await StorageProvider()
        .getCacheDirectory('cacheimagemanga');
    final file = File(p.join(cacheImagesDirectory.path, key));
    if (await file.exists()) {
      return file;
    }
  } catch (_) {
    return null;
  }
  return null;
}

/// get md5 from key
String keyToMd5(String key) => md5.convert(utf8.encode(key)).toString();
