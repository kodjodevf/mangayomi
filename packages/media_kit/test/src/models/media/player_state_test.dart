/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:collection/collection.dart';

import 'package:media_kit/src/models/track.dart';
import 'package:media_kit/src/models/playlist.dart';
import 'package:media_kit/src/models/audio_device.dart';
import 'package:media_kit/src/models/player_state.dart';
import 'package:media_kit/src/models/playlist_mode.dart';

void main() {
  test(
    'player-state-default-values',
    () {
      final state = PlayerState();
      expect(
        state.playlist,
        equals(Playlist([])),
      );
      expect(
        state.playing,
        equals(false),
      );
      expect(
        state.completed,
        equals(false),
      );
      expect(
        state.position,
        equals(Duration.zero),
      );
      expect(
        state.duration,
        equals(Duration.zero),
      );
      expect(
        state.volume,
        equals(100.0),
      );
      expect(
        state.rate,
        equals(1.0),
      );
      expect(
        state.pitch,
        equals(1.0),
      );
      expect(
        state.buffering,
        equals(false),
      );
      expect(
        state.buffer,
        equals(Duration.zero),
      );
      expect(
        state.playlistMode,
        equals(PlaylistMode.none),
      );
      expect(state.audioParams.format, isNull);
      expect(state.audioParams.sampleRate, isNull);
      expect(state.audioParams.channels, isNull);
      expect(state.audioParams.channelCount, isNull);
      expect(state.audioParams.hrChannels, isNull);
      expect(
        state.audioBitrate,
        isNull,
      );
      expect(state.videoParams.pixelformat, isNull);
      expect(state.videoParams.hwPixelformat, isNull);
      expect(state.videoParams.w, isNull);
      expect(state.videoParams.h, isNull);
      expect(state.videoParams.dw, isNull);
      expect(state.videoParams.dh, isNull);
      expect(state.videoParams.aspect, isNull);
      expect(state.videoParams.par, isNull);
      expect(state.videoParams.colormatrix, isNull);
      expect(state.videoParams.colorlevels, isNull);
      expect(state.videoParams.primaries, isNull);
      expect(state.videoParams.gamma, isNull);
      expect(state.videoParams.sigPeak, isNull);
      expect(state.videoParams.light, isNull);
      expect(state.videoParams.chromaLocation, isNull);
      expect(state.videoParams.rotate, isNull);
      expect(state.videoParams.stereoIn, isNull);
      expect(state.videoParams.averageBpp, isNull);
      expect(state.videoParams.alpha, isNull);
      expect(
        state.audioDevice,
        equals(AudioDevice.auto()),
      );
      expect(
        ListEquality().equals(state.audioDevices, [AudioDevice.auto()]),
        isTrue,
      );
      expect(
        ListEquality().equals(state.audioDevices, [AudioDevice.auto()]),
        isTrue,
      );
      expect(
        state.track,
        equals(Track()),
      );
      expect(
        state.tracks,
        equals(Tracks()),
      );
      expect(
        state.track.video,
        equals(VideoTrack.auto()),
      );
      expect(
        state.track.audio,
        equals(AudioTrack.auto()),
      );
      expect(
        state.track.subtitle,
        equals(SubtitleTrack.auto()),
      );
      expect(
        ListEquality().equals(state.tracks.video, [
          VideoTrack.auto(),
          VideoTrack.no(),
        ]),
        isTrue,
      );
      expect(
        ListEquality().equals(state.tracks.audio, [
          AudioTrack.auto(),
          AudioTrack.no(),
        ]),
        isTrue,
      );
      expect(
        ListEquality().equals(state.tracks.subtitle, [
          SubtitleTrack.auto(),
          SubtitleTrack.no(),
        ]),
        isTrue,
      );
      expect(
        state.width,
        isNull,
      );
      expect(
        state.height,
        isNull,
      );
      expect(
        ListEquality().equals(state.subtitle, ['', '']),
        isTrue,
      );
    },
  );
}
