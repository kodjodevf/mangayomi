import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/utils/playback_media.dart';

void main() {
  group('localFileUri', () {
    test('preserves a named Windows UNC host as URI authority', () {
      expect(
        localFileUri(r'\\NAS\media\Anime\Show\ep 01.mkv', windows: true),
        'file://nas/media/Anime/Show/ep%2001.mkv',
      );
    });

    test('preserves an IP Windows UNC host as URI authority', () {
      expect(
        localFileUri(r'\\192.168.1.10\anime\ep01.mkv', windows: true),
        'file://192.168.1.10/anime/ep01.mkv',
      );
    });

    test('converts drive paths including extensionless files', () {
      expect(
        localFileUri(r'C:\folder.d\video', windows: true),
        'file:///C:/folder.d/video',
      );
    });

    test('converts POSIX paths for macOS and Linux', () {
      expect(
        localFileUri('/Volumes/Anime/Show/ep 01.mkv', windows: false),
        'file:///Volumes/Anime/Show/ep%2001.mkv',
      );
    });

    test('does not reinterpret an existing file URI', () {
      expect(
        localFileUri('file://NAS/media/episode.mkv', windows: true),
        'file://nas/media/episode.mkv',
      );
    });
  });

  test('local media bypasses dependency URI normalization', () {
    final media = playbackMedia(
      r'\\NAS\media\Anime\Show\ep01.mkv',
      isLocal: true,
      windows: true,
    );

    expect(media.uri, 'file://nas/media/Anime/Show/ep01.mkv');
  });

  test('remote media retains normal media_kit handling', () {
    final media = playbackMedia(
      'https://example.com/episode.m3u8',
      isLocal: false,
      windows: true,
    );

    expect(media.uri, 'https://example.com/episode.m3u8');
  });
}
