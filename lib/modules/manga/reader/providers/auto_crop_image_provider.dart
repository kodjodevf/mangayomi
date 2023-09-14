import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auto_crop_image_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Uint8List?> autoCropImageBorder(AutoCropImageBorderRef ref,
    {required bool autoCrop,
    required String? url,
    required Uint8List? archiveImages,
    required bool isLocaleList,
    required Directory path,
    required int index}) async {
  if (autoCrop) {
    if (archiveImages != null) {
      return await compute(_cropImageFuture, (archiveImages, null));
    } else if (isLocaleList) {
      return await compute(_cropImageFuture, (
        File('${path.path}${padIndex(index + 1)}.jpg').readAsBytesSync(),
        null
      ));
    }
    return await compute(_cropImageFuture, (null, url));
  }
  return null;
}

Future<Uint8List?> _cropImageFuture((Uint8List?, String?) datas) async {
  Uint8List? oldImage;
  String path = "";
  Uint8List? image = datas.$1;
  File? cachedImage;
  String? url = datas.$2;
  if (url != null) {
    cachedImage = await getCachedImageFile(url);
  }

  if (cachedImage != null) {
    path = cachedImage.path;
  }
  if (path.isNotEmpty) {
    oldImage = File(path).readAsBytesSync();
  } else if (image != null) {
    oldImage = image;
  }
  if (oldImage != null) {
    return await compute(_autocropImageIsolate, oldImage);
  }

  return null;
}

FutureOr<Uint8List?> _autocropImageIsolate(Uint8List? cropData) async {
  Image? croppedImage;
  Image? image = decodeImage(cropData!);
  image =
      copyCrop(image!, x: 0, y: 0, width: image.width, height: image.height);

  int left = 0;
  int top = 0;
  int right = image.width;
  int bottom = image.height;
  // Find left coordinate
  for (int x = 0; x < image.width; x++) {
    bool stop = false;
    for (int y = 0; y < image.height; y++) {
      if (image.getPixel(x, y).toString() != "(255, 255, 255)") {
        stop = true;
        break;
      }
    }
    if (stop) {
      left = x;
      break;
    }
  }

  // Find top coordinate
  for (int y = 0; y < image.height; y++) {
    bool stop = false;
    for (int x = 0; x < image.width; x++) {
      if (image.getPixel(x, y).toString() != "(255, 255, 255)") {
        stop = true;
        break;
      }
    }
    if (stop) {
      top = y;
      break;
    }
  }

  // Find right coordinate
  for (int x = image.width - 1; x >= 0; x--) {
    bool stop = false;
    for (int y = 0; y < image.height; y++) {
      if (image.getPixel(x, y).toString() != "(255, 255, 255)") {
        stop = true;
        break;
      }
    }
    if (stop) {
      right = x;
      break;
    }
  }

  // Find bottom coordinate
  for (int y = image.height - 1; y >= 0; y--) {
    bool stop = false;
    for (int x = 0; x < image.width; x++) {
      if (image.getPixel(x, y).toString() != "(255, 255, 255)") {
        stop = true;
        break;
      }
    }
    if (stop) {
      bottom = y;
      break;
    }
  }

  // Crop the image
  croppedImage = copyCrop(
    image,
    x: left,
    y: top,
    width: right - left,
    height: bottom - top,
  );

  return encodeJpg(croppedImage);
}
