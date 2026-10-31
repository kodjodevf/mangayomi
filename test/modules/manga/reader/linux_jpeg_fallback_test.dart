import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/src/subsampling_image_resolver.dart';

/// A 6 by 4 JPEG.
final _jpeg = base64Decode(
  '/9j/4AAQSkZJRgABAQABLAEsAAD/4QCARXhpZgAATU0AKgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAIdpAAQAAAABAAAATgAAAAAAAAEsAAAAAQAAASwAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAAAagAwAEAAAAAQAAAAQAAAAA/+0AOFBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAAAOEJJTQQlAAAAAAAQ1B2M2Y8AsgTpgAmY7PhCfv/AABEIAAQABgMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2wBDAAYGBgYGBgoGBgoOCgoKDhIODg4OEhcSEhISEhccFxcXFxcXHBwcHBwcHBwiIiIiIiInJycnJywsLCwsLCwsLCz/2wBDAQcHBwsKCxMKChMuHxofLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi7/3QAEAAH/2gAMAwEAAhEDEQA/APabC3ll8QahG11PtU5AD8cn6du3pXR/2cf+fm4/77/+tWNpn/Ix6l+H866quRH1MorTTovyP//Z',
);

void main() {
  test('a JPEG is told from other images by its first bytes', () {
    expect(isJpegImage(_jpeg), isTrue);
    expect(isJpegImage(Uint8List.fromList([0x89, 0x50, 0x4E, 0x47])), isFalse);
    expect(isJpegImage(Uint8List(0)), isFalse);
  });

  testWidgets('a JPEG the native decoder cannot read becomes a PNG Flutter '
      'decoded (#1071)', (tester) async {
    await tester.runAsync(() async {
      final png = await decodeWithFlutterToPng(_jpeg);
      expect(png.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
      final codec = await ui.instantiateImageCodec(png);
      final frame = await codec.getNextFrame();
      expect([frame.image.width, frame.image.height], [6, 4]);
      frame.image.dispose();
      codec.dispose();
    });
  });
}
