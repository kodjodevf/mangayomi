import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/utils/audio_track_fallback.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  test('recognizes decoder initialization errors that name a codec', () {
    const message = "Failed to initialize a decoder for codec 'truehd'.";

    expect(isAudioDecoderInitializationError(message), isTrue);
    expect(audioDecoderCodecFromError(message), 'truehd');
  });

  test('recognizes generic audio decode errors', () {
    const message = 'Error decoding audio.';

    expect(isAudioDecoderInitializationError(message), isTrue);
    expect(audioDecoderCodecFromError(message), isNull);
  });

  test('prefers an alternative in the failed track language', () {
    final failed = AudioTrack('2', 'English lossless', 'eng', codec: 'truehd');
    final candidates = audioTrackFallbackCandidates(
      failedTrack: failed,
      availableTracks: [
        failed,
        AudioTrack('3', 'Japanese', 'jpn', codec: 'aac'),
        AudioTrack('4', 'English stereo', 'en', codec: 'aac'),
      ],
      failedCodecs: {'truehd'},
    );

    expect(candidates.map((track) => track.id), ['4', '3']);
  });

  test('skips tracks using codecs and track ids that already failed', () {
    final failed = AudioTrack('2', 'English', 'en', codec: 'eac3');
    final candidates = audioTrackFallbackCandidates(
      failedTrack: failed,
      availableTracks: [
        failed,
        AudioTrack('3', 'English alternate', 'en', codec: 'eac3'),
        AudioTrack('4', 'English stereo', 'en', codec: 'aac'),
      ],
      failedTrackKeys: {
        audioTrackFallbackKey(AudioTrack('4', 'English', 'en')),
      },
      failedCodecs: {'eac3'},
    );

    expect(candidates, isEmpty);
  });
}
