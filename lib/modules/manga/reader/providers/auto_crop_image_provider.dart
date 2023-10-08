import 'dart:io';
import 'package:flutter/foundation.dart';
// import 'package:image/image.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auto_crop_image_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Uint8List?> autoCropImageBorder(AutoCropImageBorderRef ref,
    {required UChapDataPreload datas, required bool cropBorder}) async {
  Uint8List? imageBytes;
  if (cropBorder) {
    if (datas.archiveImage != null) {
      imageBytes = datas.archiveImage;
    } else if (datas.isLocale!) {
      imageBytes = File('${datas.path!.path}${padIndex(datas.index! + 1)}.jpg')
          .readAsBytesSync();
    } else {
      // String path = "";
      // File? cachedImage;
      // if (datas.url != null) {
      //   cachedImage = await getCachedImageFile(datas.url!);
      // }
      // if (cachedImage != null) {
      //   path = cachedImage.path;
      // }
      // if (path.isNotEmpty) {
      //   data = (File(path).readAsBytesSync(), receivePort.sendPort);
      // } else {
      //   data = (null, receivePort.sendPort);
      // }
    }
    if (imageBytes == null) {
      return null;
    }
    final res = await compute(cropImageWithThread, imageBytes);
    return res;
  }
  return null;
}

Future<Uint8List?> cropImageWithThread(
  Uint8List? imageBytes,
) async {
  // Command crop = Command();
  // crop.decodeImage(imageBytes!);
  // Command encode = Command();
  // encode.subCommand = crop;

  // final image = await encode.getImageThread();
  // int left = 0;
  // int top = 0;
  // int right = image!.width;
  // int bottom = image.height;

  // // Find left coordinate
  // for (int x = 0; x < image.width; x++) {
  //   bool stop = false;
  //   for (int y = 0; y < image.height; y++) {
  //     if (image.getPixel(x, y).toString() != "(255, 255, 255)") {
  //       stop = true;
  //       break;
  //     }
  //   }
  //   if (stop) {
  //     left = x;
  //     break;
  //   }
  // }

  // // Find top coordinate
  // for (int y = 0; y < image.height; y++) {
  //   bool stop = false;
  //   for (int x = 0; x < image.width; x++) {
  //     if (image.getPixel(x, y).toString() != "(255, 255, 255)") {
  //       stop = true;
  //       break;
  //     }
  //   }
  //   if (stop) {
  //     top = y;
  //     break;
  //   }
  // }

  // // Find right coordinate
  // for (int x = image.width - 1; x >= 0; x--) {
  //   bool stop = false;
  //   for (int y = 0; y < image.height; y++) {
  //     if (image.getPixel(x, y).toString() != "(255, 255, 255)") {
  //       stop = true;
  //       break;
  //     }
  //   }
  //   if (stop) {
  //     right = x;
  //     break;
  //   }
  // }

  // // Find bottom coordinate
  // for (int y = image.height - 1; y >= 0; y--) {
  //   bool stop = false;
  //   for (int x = 0; x < image.width; x++) {
  //     if (image.getPixel(x, y).toString() != "(255, 255, 255)") {
  //       stop = true;
  //       break;
  //     }
  //   }
  //   if (stop) {
  //     bottom = y;
  //     break;
  //   }
  // }

  // crop.copyCrop(
  //   x: left,
  //   y: top,
  //   width: right - left,
  //   height: bottom - top,
  // );

  // encode.subCommand = crop;
  // encode.encodeJpg();

  // return encode.getBytesThread();
  return null;
}
