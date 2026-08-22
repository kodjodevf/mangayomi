import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_avif_platform_interface/flutter_avif_platform_interface.dart';

bool isAvifImage(Uint8List bytes) {
  // ISO Base Media File Format (ISOBMFF) file (container for MP4, HEIF, AVIF, QuickTime, ...)
  final isNotISOBMFF =
      bytes.length < 12 ||
      bytes[4] != 0x66 || // 'f'
      bytes[5] != 0x74 || // 't'
      bytes[6] != 0x79 || // 'y'
      bytes[7] != 0x70; // 'p'
  if (isNotISOBMFF) return false;

  final boxSize = ByteData.sublistView(bytes, 0, 4).getUint32(0);
  final end = boxSize == 0 || boxSize > bytes.length ? bytes.length : boxSize;

  bool isAvifBrand(int offset) =>
      offset + 4 <= end &&
      bytes[offset] == 0x61 && // 'a'
      bytes[offset + 1] == 0x76 && // 'v'
      bytes[offset + 2] == 0x69 && // 'i'
      (bytes[offset + 3] == 0x66 || bytes[offset + 3] == 0x73); // 'f' or 's'

  if (isAvifBrand(8)) return true;
  for (var offset = 16; offset + 4 <= end; offset += 4) {
    if (isAvifBrand(offset)) return true;
  }
  return false;
}

Future<Uint8List> decodeAvifToPng(Uint8List bytes) async {
  if (!isAvifImage(bytes)) {
    throw ArgumentError.value(bytes, 'bytes', 'Not an AVIF image');
  }

  final frame = await FlutterAvifPlatform.api.decodeSingleFrameImage(
    avifBytes: bytes,
  );
  if (frame.width == 0 || frame.height == 0) {
    throw StateError('libavif returned an empty frame');
  }

  final image = await _imageFromRgba(frame.data, frame.width, frame.height);
  try {
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    if (png == null) throw StateError('Failed to encode decoded AVIF as PNG');
    return png.buffer.asUint8List(png.offsetInBytes, png.lengthInBytes);
  } finally {
    image.dispose();
  }
}

Future<ui.Image> _imageFromRgba(List<int> rgba, int width, int height) {
  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    rgba is Uint8List ? rgba : Uint8List.fromList(rgba),
    width,
    height,
    ui.PixelFormat.rgba8888,
    completer.complete,
  );
  return completer.future;
}
