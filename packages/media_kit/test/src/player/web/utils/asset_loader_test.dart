import 'package:test/test.dart';

import 'package:media_kit/src/player/web/utils/asset_loader.dart';

void main() {
  test(
    'asset-loader-encode-asset-key',
    () {
      expect(
        AssetLoader.encodeAssetKey('asset://videos/video_0.mp4'),
        equals('videos/video_0.mp4'),
      );
      expect(
        AssetLoader.encodeAssetKey('asset:///videos/video_0.mp4'),
        equals('videos/video_0.mp4'),
      );
      // Non ASCII characters.
      expect(
        AssetLoader.encodeAssetKey('asset://audios/う.wav'),
        equals('audios/%E3%81%86.wav'),
      );
      expect(
        AssetLoader.encodeAssetKey('asset:///audios/う.wav'),
        equals('audios/%E3%81%86.wav'),
      );
    },
  );
}
