import 'dart:async';
import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/messages/crop_borders.pb.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'crop_borders_provider.g.dart';

int nextId = 0;

@Riverpod(keepAlive: true)
Future<Uint8List?> cropBorders(CropBordersRef ref,
    {required UChapDataPreload datas, required bool cropBorder}) async {
  Uint8List? imageBytes;

  if (cropBorder) {
    if (datas.archiveImage != null) {
      imageBytes = datas.archiveImage;
    } else if (datas.isLocale!) {
      imageBytes = File('${datas.path!.path}${padIndex(datas.index! + 1)}.jpg')
          .readAsBytesSync();
    } else {
      File? cachedImage;
      if (datas.url != null) {
        cachedImage = await getCachedImageFile(datas.url!);
      }
      imageBytes = cachedImage?.readAsBytesSync();
    }
    if (imageBytes == null) {
      return null;
    }

    final currentId = nextId;
    nextId++;
    final completer = Completer<Uint8List>();
    CropBordersInput(
      interactionId: currentId,
    ).sendSignalToRust(imageBytes);
    final stream = CropBordersOutput.rustSignalStream;
    final subscription = stream.listen((rustSignal) {
      if (rustSignal.message.interactionId == currentId) {
        completer.complete(rustSignal.blob!);
      }
    });
    final image = await completer.future;
    subscription.cancel();

    return image;
  }
  return null;
}
