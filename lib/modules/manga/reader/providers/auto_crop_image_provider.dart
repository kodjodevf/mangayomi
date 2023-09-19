import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auto_crop_image_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Uint8List?> autoCropImageBorder(AutoCropImageBorderRef ref,
    {required UChapDataPreload datas, required bool cropBorder}) async {
  final ReceivePort receivePort = ReceivePort();
  (Uint8List?, SendPort)? data;
  try {
    if (cropBorder) {
      if (datas.archiveImage != null) {
        data = (datas.archiveImage, receivePort.sendPort);
      } else if (datas.isLocale!) {
        data = (
          File('${datas.path!.path}${padIndex(datas.index! + 1)}.jpg')
              .readAsBytesSync(),
          receivePort.sendPort
        );
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
      await Isolate.spawn(_autocropImageIsolate, data);
      return await receivePort.first as Uint8List?;
    }
    return null;
  } on Object {
    receivePort.close();
    return null;
  }
}

Future<Uint8List?> _autocropImageIsolate((Uint8List?, SendPort?)? datas) async {
  SendPort? resultPort = datas!.$2;

  Uint8List? img = datas.$1;

  if (img == null) {
    Isolate.exit(resultPort, null);
  }

  Image? croppedImage;

  Image? image = decodeImage(img);

  int left = 0;
  int top = 0;
  int right = image!.width;
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

  Uint8List? encodeImage = encodeJpg(croppedImage);
  Isolate.exit(resultPort, encodeImage);
}
