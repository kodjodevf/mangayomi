import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/src/rust/api/image.dart';
import 'package:mangayomi/src/rust/frb_generated.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'crop_borders_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Uint8List?> cropBorders(
  Ref ref, {
  required UChapDataPreload data,
  required bool cropBorder,
}) async {
  Uint8List? imageBytes;

  if (cropBorder) {
    imageBytes = await data.getImageBytes;

    if (imageBytes == null) {
      return null;
    }

    return await Isolate.run(() async {
      await RustLib.init();
      final imageRes = processCropImage(image: imageBytes!);
      RustLib.dispose();
      return imageRes;
    });
  }
  return null;
}
