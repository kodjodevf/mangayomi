import 'dart:io';
import 'dart:isolate';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
// import 'package:image/image.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auto_crop_image_provider.g.dart';

@riverpod
Future<List<Uint8List?>> autoCropBorder(AutoCropBorderRef ref,
    {required List<String?> url,
    required List<Uint8List?> archiveImages,
    required List<bool> isLocaleList,
    required Directory path}) async {
  List<Future<CropBorderClassRes?>> futures = [];
  if (archiveImages.isNotEmpty) {
    for (var i = 0; i < archiveImages.length; i++) {
      futures.add(_cropImageFuture(archiveImages[i], null, i));
    }
  } else if (isLocaleList.contains(true)) {
    for (var i = 0; i < isLocaleList.length; i++) {
      if (isLocaleList[i] == true) {
        Uint8List? image =
            File('${path.path}${padIndex(i + 1)}.jpg').readAsBytesSync();
        futures.add(_cropImageFuture(image, null, i));
      } else {
        futures.add(_cropImageFuture(null, null, i));
      }
    }
  } else {
    for (var i = 0; i < url.length; i++) {
      futures.add(_cropImageFuture(null, url[i], i));
    }
  }
  List<CropBorderClassRes?> result = await Future.wait(futures);

  result.sort((a, b) => a!.index.compareTo(b!.index));
  List<Uint8List?> cropImageRes = [];
  for (var image in result) {
    cropImageRes.add(image!.image);
  }
  return cropImageRes;
}

Future<CropBorderClassRes?> _cropImageFuture(
    Uint8List? image, String? url, int index) async {
  Uint8List? oldImage;
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
  } else if (image != null) {
    oldImage = image;
  }
  if (oldImage != null) {
    var receiverPort = ReceivePort();
    await Isolate.spawn(_autocropImageIsolate,
        CropBorderClass(oldImage, receiverPort.sendPort));
    final newImage = await receiverPort.first as Uint8List?;
    return CropBorderClassRes(newImage, index);
  }

  return null;
}

class CropBorderClassRes {
  final Uint8List? image;
  final int index;

  CropBorderClassRes(this.image, this.index);
}

class CropBorderClass {
  final Uint8List? image;
  final SendPort sendPort;

  CropBorderClass(this.image, this.sendPort);
}

void _autocropImageIsolate(CropBorderClass cropData) async {
  // Image? croppedImage;
  // // Image? image = decodeImage(cropData.image!);
  // // final old = image;
  // // image = copyCrop(image!, 0, 0, image.width, image.height);

  // // int left = 0;
  // // int top = 0;
  // // int right = image.width - 1;
  // // int bottom = image.height - 1;

  // // // Find left coordinate
  // // for (int x = 0; x < image.width; x++) {
  // //   bool stop = false;
  // //   for (int y = 0; y < image.height; y++) {
  // //     if (image.getPixel(x, y) != getColor(255, 255, 255, 255)) {
  // //       stop = true;
  // //       break;
  // //     }
  // //   }
  // //   if (stop) {
  // //     left = x;
  // //     break;
  // //   }
  // // }

  // // // Find top coordinate
  // // for (int y = 0; y < image.height; y++) {
  // //   bool stop = false;
  // //   for (int x = 0; x < image.width; x++) {
  // //     if (image.getPixel(x, y) != getColor(255, 255, 255, 255)) {
  // //       stop = true;
  // //       break;
  // //     }
  // //   }
  // //   if (stop) {
  // //     top = y;
  // //     break;
  // //   }
  // // }

  // // // Find right coordinate
  // // for (int x = image.width - 1; x >= 0; x--) {
  // //   bool stop = false;
  // //   for (int y = 0; y < image.height; y++) {
  // //     if (image.getPixel(x, y) != getColor(255, 255, 255, 255)) {
  // //       stop = true;
  // //       break;
  // //     }
  // //   }
  // //   if (stop) {
  // //     right = x;
  // //     break;
  // //   }
  // // }

  // // // Find bottom coordinate
  // // for (int y = image.height - 1; y >= 0; y--) {
  // //   bool stop = false;
  // //   for (int x = 0; x < image.width; x++) {
  // //     if (image.getPixel(x, y) != getColor(255, 255, 255, 255)) {
  // //       stop = true;
  // //       break;
  // //     }
  // //   }
  // //   if (stop) {
  // //     bottom = y;
  // //     break;
  // //   }
  // // }

  // // // Crop the image
  // // croppedImage = copyCrop(
  // //   image,
  // //   left,
  // //   top,
  // //   right - left + 1,
  // //   bottom - top + 1,
  // // );
  // if (old != croppedImage) {
  //   cropData.sendPort.send(encodeJpg(croppedImage) as Uint8List);
  // } else {
  //   cropData.sendPort.send(null);
  // }
}
