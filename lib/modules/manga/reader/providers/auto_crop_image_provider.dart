import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auto_crop_image_provider.g.dart';

@riverpod
Future<Uint8List?> autoCropImage(
    AutoCropImageRef ref, String? url, Uint8List? data) async {
  Uint8List? oldImage;
  Uint8List? newImage;
  String path = "";
  File? cachedImage;
  if (url != null) {
    cachedImage = await getCachedImageFile(url);
  }
  if (cachedImage != null) {
    path = cachedImage.path;
  }
  if (path.isNotEmpty) {
    oldImage = File(path).readAsBytesSync();
  } else if (data != null) {
    oldImage = data;
  }
  if (oldImage != null) {
    newImage = await compute(autocropImageIsolate, oldImage);
  }
  return newImage;
}

Future<Uint8List?> autocropImageIsolate(List<int> data) async {
  Image? croppedImage;
  Image? image = decodeImage(data);
  final old = image;
  image = copyCrop(image!, 0, 0, image.width, image.height);

  int left = 0;
  int top = 0;
  int right = image.width - 1;
  int bottom = image.height - 1;

  // Find left coordinate
  for (int x = 0; x < image.width; x++) {
    bool stop = false;
    for (int y = 0; y < image.height; y++) {
      if (image.getPixel(x, y) != getColor(255, 255, 255, 255)) {
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
      if (image.getPixel(x, y) != getColor(255, 255, 255, 255)) {
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
      if (image.getPixel(x, y) != getColor(255, 255, 255, 255)) {
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
      if (image.getPixel(x, y) != getColor(255, 255, 255, 255)) {
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
    left,
    top,
    right - left + 1,
    bottom - top + 1,
  );
  if (old != croppedImage) {
    return encodeJpg(croppedImage) as Uint8List;
  }
  return null;
}
