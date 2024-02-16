import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/messages/crop_borders.pb.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'crop_borders_provider.g.dart';

int nextId = 0;

@Riverpod(keepAlive: true)
Future<Uint8List?> cropBorders(CropBordersRef ref,
    {required UChapDataPreload datas, required bool cropBorder}) async {
  Uint8List? imageBytes;

  if (cropBorder) {
    imageBytes = await datas.getImageBytes;

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
