import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/avif.dart';

Uint8List _fileTypeBox(
  String majorBrand, [
  List<String> compatible = const [],
]) {
  final bytes = Uint8List(16 + compatible.length * 4);
  ByteData.sublistView(bytes).setUint32(0, bytes.length);
  bytes.setAll(4, 'ftyp'.codeUnits);
  bytes.setAll(8, majorBrand.codeUnits);
  for (var index = 0; index < compatible.length; index++) {
    bytes.setAll(16 + index * 4, compatible[index].codeUnits);
  }
  return bytes;
}

void main() {
  test('detects AVIF major and compatible brands', () {
    expect(isAvifImage(_fileTypeBox('avif')), isTrue);
    expect(isAvifImage(_fileTypeBox('avis')), isTrue);
    expect(isAvifImage(_fileTypeBox('mif1', ['avif'])), isTrue);
    expect(isAvifImage(_fileTypeBox('heic', ['mif1'])), isFalse);
    expect(isAvifImage(Uint8List(11)), isFalse);
  });
}
