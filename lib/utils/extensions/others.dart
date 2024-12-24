import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

extension LetExtension<T> on T {
  R let<R>(R Function(T) block) {
    return block(this);
  }
}

extension ImageProviderExtension on ImageProvider {
  Future<Uint8List?> getBytes(BuildContext context,
      {ImageByteFormat format = ImageByteFormat.png}) async {
    final imageStream = resolve(createLocalImageConfiguration(context));
    final Completer<Uint8List?> completer = Completer<Uint8List?>();
    final ImageStreamListener listener = ImageStreamListener(
      (imageInfo, synchronousCall) async {
        final bytes = await imageInfo.image.toByteData(format: format);
        if (!completer.isCompleted) {
          completer.complete(bytes?.buffer.asUint8List());
        }
      },
    );
    imageStream.addListener(listener);
    final imageBytes = await completer.future;
    imageStream.removeListener(listener);
    return imageBytes;
  }
}

extension UChapDataPreloadExtensions on UChapDataPreload {
  Future<Uint8List?> get getImageBytes async {
    Uint8List? imageBytes;
    if (archiveImage != null) {
      imageBytes = archiveImage;
    } else if (isLocale!) {
      imageBytes = File('${directory!.path}${padIndex(index! + 1)}.jpg')
          .readAsBytesSync();
    } else {
      File? cachedImage;
      if (pageUrl != null) {
        cachedImage = await _getCachedImageFile(pageUrl!.url);
      }
      if (cachedImage == null) {
        await Future.delayed(const Duration(seconds: 3));
        cachedImage = await _getCachedImageFile(pageUrl!.url);
      }
      imageBytes = cachedImage?.readAsBytesSync();
    }
    return imageBytes;
  }

  ImageProvider<Object> getImageProvider(
      WidgetRef ref, bool showCloudFlareError) {
    final data = this;
    final isLocale = data.isLocale!;
    final archiveImage = data.archiveImage;
    final cropBorders = ref.watch(cropBordersStateProvider);
    return cropBorders && data.cropImage != null
        ? ExtendedMemoryImageProvider(data.cropImage!)
        : (isLocale
            ? archiveImage != null
                ? ExtendedMemoryImageProvider(archiveImage)
                : ExtendedFileImageProvider(File(
                    '${data.directory!.path}${padIndex(data.index! + 1)}.jpg'))
            : CustomExtendedNetworkImageProvider(
                data.pageUrl!.url.trim().trimLeft().trimRight(),
                cache: true,
                cacheMaxAge: const Duration(days: 7),
                showCloudFlareError: showCloudFlareError,
                imageCacheFolderName: "cacheimagemanga",
                headers: {
                    ...data.pageUrl!.headers ?? {},
                    ...ref.watch(headersProvider(
                        source: data.chapter!.manga.value!.source!,
                        lang: data.chapter!.manga.value!.lang!))
                  })) as ImageProvider<Object>;
  }
}

Future<File?> _getCachedImageFile(String url, {String? cacheKey}) async {
  try {
    final String key = cacheKey ?? keyToMd5(url);
    final Directory cacheImagesDirectory = Directory(join(
        (await getTemporaryDirectory()).path, 'Mangayomi', 'cacheimagemanga'));
    if (cacheImagesDirectory.existsSync()) {
      await for (final FileSystemEntity file in cacheImagesDirectory.list()) {
        if (file.path.endsWith(key)) {
          return File(file.path);
        }
      }
    }
  } catch (_) {
    return null;
  }
  return null;
}
