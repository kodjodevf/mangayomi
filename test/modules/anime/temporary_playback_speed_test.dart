import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/utils/temporary_playback_speed.dart';

void main() {
  test('moving up selects faster temporary playback speeds', () {
    expect(
      temporaryPlaybackSpeedForDrag(
        initialSpeed: 2.0,
        verticalDelta: -temporaryPlaybackSpeedStepExtent,
      ),
      2.5,
    );
  });

  test('a hold starts at 2x before any drag', () {
    expect(initialTemporaryPlaybackSpeed(), 2.0);
  });

  test('moving down selects slower temporary playback speeds', () {
    expect(
      temporaryPlaybackSpeedForDrag(
        initialSpeed: 2.0,
        verticalDelta: temporaryPlaybackSpeedStepExtent * 2,
      ),
      1.0,
    );
  });

  test('temporary playback speed clamps at both ends', () {
    expect(
      temporaryPlaybackSpeedForDrag(initialSpeed: 2.0, verticalDelta: -1000),
      3.0,
    );
    expect(
      temporaryPlaybackSpeedForDrag(initialSpeed: 2.0, verticalDelta: 1000),
      0.25,
    );
  });

  test('initial speed snaps to the nearest displayed level', () {
    expect(
      temporaryPlaybackSpeedForDrag(initialSpeed: 1.8, verticalDelta: 0),
      2.0,
    );
  });

  test('speed labels avoid unnecessary decimal zeroes', () {
    expect(temporaryPlaybackSpeedLabel(2.0), '2x');
    expect(temporaryPlaybackSpeedLabel(0.75), '0.75x');
  });
}
