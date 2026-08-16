import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_avif/flutter_avif.dart';

bool isAvifImage(Uint8List bytes) {
  if (bytes.length < 12 ||
      bytes[4] != 0x66 ||
      bytes[5] != 0x74 ||
      bytes[6] != 0x79 ||
      bytes[7] != 0x70) {
    return false;
  }

  final boxSize = ByteData.sublistView(bytes, 0, 4).getUint32(0);
  final end = boxSize == 0 || boxSize > bytes.length ? bytes.length : boxSize;

  bool isAvifBrand(int offset) =>
      offset + 4 <= end &&
      bytes[offset] == 0x61 &&
      bytes[offset + 1] == 0x76 &&
      bytes[offset + 2] == 0x69 &&
      (bytes[offset + 3] == 0x66 || bytes[offset + 3] == 0x73);

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

  final codec = SingleFrameAvifCodec(bytes: bytes);
  ui.Image? image;
  try {
    await codec.ready();
    image = (await codec.getNextFrame()).image;
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    if (png == null) throw StateError('Failed to encode decoded AVIF as PNG');
    return png.buffer.asUint8List(png.offsetInBytes, png.lengthInBytes);
  } finally {
    image?.dispose();
    codec.dispose();
  }
}
