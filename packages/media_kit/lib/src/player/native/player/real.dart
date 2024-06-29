/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:io';
import 'dart:ffi';
import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:meta/meta.dart';
import 'package:image/image.dart';
import 'package:synchronized/synchronized.dart';
import 'package:safe_local_storage/safe_local_storage.dart';

import 'package:media_kit/ffi/ffi.dart';

import 'package:media_kit/src/player/platform_player.dart';

import 'package:media_kit/src/player/native/core/initializer.dart';
import 'package:media_kit/src/player/native/core/native_library.dart';
import 'package:media_kit/src/player/native/core/fallback_bitrate_handler.dart';
import 'package:media_kit/src/player/native/core/initializer_native_event_loop.dart';

import 'package:media_kit/src/player/native/utils/isolates.dart';
import 'package:media_kit/src/player/native/utils/temp_file.dart';
import 'package:media_kit/src/player/native/utils/android_helper.dart';
import 'package:media_kit/src/player/native/utils/android_asset_loader.dart';

import 'package:media_kit/src/models/track.dart';
import 'package:media_kit/src/models/playable.dart';
import 'package:media_kit/src/models/playlist.dart';
import 'package:media_kit/src/models/player_log.dart';
import 'package:media_kit/src/models/media/media.dart';
import 'package:media_kit/src/models/audio_device.dart';
import 'package:media_kit/src/models/audio_params.dart';
import 'package:media_kit/src/models/video_params.dart';
import 'package:media_kit/src/models/player_state.dart';
import 'package:media_kit/src/models/playlist_mode.dart';

import 'package:media_kit/generated/libmpv/bindings.dart' as generated;

/// Initializes the native backend for package:media_kit.
void nativeEnsureInitialized({String? libmpv}) {
  AndroidHelper.ensureInitialized();
  NativeLibrary.ensureInitialized(libmpv: libmpv);
  InitializerNativeEventLoop.ensureInitialized();
}

/// {@template native_player}
///
/// NativePlayer
/// ------------
///
/// Native implementation of [PlatformPlayer].
///
/// {@endtemplate}
class NativePlayer extends PlatformPlayer {
  /// {@macro native_player}
  NativePlayer({required super.configuration})
      : mpv = generated.MPV(DynamicLibrary.open(NativeLibrary.path)) {
    future = _create()
      ..then((_) {
        try {
          configuration.ready?.call();
        } catch (_) {}
      });
  }

  /// Disposes the [Player] instance & releases the resources.
  @override
  Future<void> dispose({bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      await pause(synchronized: false);

      await setVideoTrack(VideoTrack.no(), synchronized: false);
      await setAudioTrack(AudioTrack.no(), synchronized: false);
      await setSubtitleTrack(SubtitleTrack.no(), synchronized: false);

      disposed = true;

      await super.dispose();

      Initializer.dispose(ctx);

      Future.delayed(const Duration(seconds: 5), () {
        mpv.mpv_terminate_destroy(ctx);
      });
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Opens a [Media] or [Playlist] into the [Player].
  /// Passing [play] as `true` starts the playback immediately.
  ///
  /// ```dart
  /// await player.open(Media('asset:///assets/videos/sample.mp4'));
  /// await player.open(Media('file:///C:/Users/Hitesh/Music/Sample.mp3'));
  /// await player.open(
  ///   Playlist(
  ///     [
  ///       Media('file:///C:/Users/Hitesh/Music/Sample.mp3'),
  ///       Media('file:///C:/Users/Hitesh/Video/Sample.mkv'),
  ///       Media('https://www.example.com/sample.mp4'),
  ///       Media('rtsp://www.example.com/live'),
  ///     ],
  ///   ),
  /// );
  /// ```
  ///
  @override
  Future<void> open(
    Playable playable, {
    bool play = true,
    bool synchronized = true,
  }) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      final int index;
      final List<Media> playlist = <Media>[];
      if (playable is Media) {
        index = 0;
        playlist.add(playable);
      } else if (playable is Playlist) {
        index = playable.index;
        playlist.addAll(playable.medias);
      } else {
        index = -1;
      }

      // Keep these [Media] objects in memory.
      current = playlist;

      // NOTE: Handled as part of [stop] logic.
      // final commands = [
      //   // Clear existing playlist & change currently playing index to none.
      //   // This causes playback to stop & player to enter the idle state.
      //   'stop',
      //   'playlist-clear',
      //   'playlist-play-index none',
      // ];
      // for (final command in commands) {
      //   final args = command.toNativeUtf8();
      //   mpv.mpv_command_string(
      //     ctx,
      //     args.cast(),
      //   );
      //   calloc.free(args);
      // }

      // Restore original state & reset public [PlayerState] & [PlayerStream] values e.g. width=null, height=null, subtitle=['', ''] etc.
      await stop(
        open: true,
        synchronized: false,
      );

      // Enter paused state.
      {
        final name = 'pause'.toNativeUtf8();
        final value = calloc<Uint8>();
        mpv.mpv_get_property(
          ctx,
          name.cast(),
          generated.mpv_format.MPV_FORMAT_FLAG,
          value.cast(),
        );
        if (value.value == 0) {
          // We are using `cycle pause` because it waits & prevents the race condition.
          final command = 'cycle pause'.toNativeUtf8();
          mpv.mpv_command_string(
            ctx,
            command.cast(),
          );
          // NOTE: Handled as part of [stop] logic.
          // state = state.copyWith(playing: false);
          // if (!playingController.isClosed) {
          //   playingController.add(false);
          // }
        }

        calloc.free(name);
        calloc.free(value);
      }

      // NOTE: Handled as part of [stop] logic.
      // isShuffleEnabled = false;
      // isPlayingStateChangeAllowed = false;

      for (int i = 0; i < playlist.length; i++) {
        await _command(
          [
            'loadfile',
            playlist[i].uri,
            'append',
          ],
        );
      }

      // If [play] is `true`, then exit paused state.
      if (play) {
        isPlayingStateChangeAllowed = true;
        final name = 'pause'.toNativeUtf8();
        final value = calloc<Uint8>();
        mpv.mpv_get_property(
          ctx,
          name.cast(),
          generated.mpv_format.MPV_FORMAT_FLAG,
          value.cast(),
        );
        if (value.value == 1) {
          // We are using `cycle pause` because it waits & prevents the race condition.
          final command = 'cycle pause'.toNativeUtf8();
          mpv.mpv_command_string(
            ctx,
            command.cast(),
          );
        }
        calloc.free(name);
        calloc.free(value);
        state = state.copyWith(playing: true);
        if (!playingController.isClosed) {
          playingController.add(true);
        }
      }

      // Jump to the specified [index] (in both cases either [play] is `true` or `false`).
      {
        final name = 'playlist-pos'.toNativeUtf8();
        final value = calloc<Int64>()..value = index;
        mpv.mpv_set_property(
          ctx,
          name.cast(),
          generated.mpv_format.MPV_FORMAT_INT64,
          value.cast(),
        );
        calloc.free(name);
        calloc.free(value);
      }
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Stops the [Player].
  /// Unloads the current [Media] or [Playlist] from the [Player]. This method is similar to [dispose] but does not release the resources & [Player] is still usable.
  @override
  Future<void> stop({
    bool open = false,
    bool synchronized = true,
  }) async {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      isShuffleEnabled = false;
      isPlayingStateChangeAllowed = false;
      isBufferingStateChangeAllowed = false;

      final commands = [
        'stop',
        'playlist-clear',
        'playlist-play-index none',
      ];
      for (final command in commands) {
        final args = command.toNativeUtf8();
        mpv.mpv_command_string(
          ctx,
          args.cast(),
        );
        calloc.free(args);
      }

      // Reset the remaining attributes.
      state = PlayerState().copyWith(
        volume: state.volume,
        rate: state.rate,
        pitch: state.pitch,
        playlistMode: state.playlistMode,
        audioDevice: state.audioDevice,
        audioDevices: state.audioDevices,
      );
      if (!open) {
        // Do not emit PlayerStream.playlist if invoked from [open].
        if (!playlistController.isClosed) {
          playlistController.add(Playlist([]));
        }
      }
      if (!playingController.isClosed) {
        playingController.add(false);
      }
      if (!completedController.isClosed) {
        completedController.add(false);
      }
      if (!positionController.isClosed) {
        positionController.add(Duration.zero);
      }
      if (!durationController.isClosed) {
        durationController.add(Duration.zero);
      }
      // if (!volumeController.isClosed) {
      //   volumeController.add(0.0);
      // }
      // if (!rateController.isClosed) {
      //   rateController.add(0.0);
      // }
      // if (!pitchController.isClosed) {
      //   pitchController.add(0.0);
      // }
      if (!bufferingController.isClosed) {
        bufferingController.add(false);
      }
      if (!bufferController.isClosed) {
        bufferController.add(Duration.zero);
      }
      // if (!playlistModeController.isClosed) {
      //   playlistModeController.add(PlaylistMode.none);
      // }
      if (!audioParamsController.isClosed) {
        audioParamsController.add(const AudioParams());
      }
      if (!videoParamsController.isClosed) {
        videoParamsController.add(const VideoParams());
      }
      if (!audioBitrateController.isClosed) {
        audioBitrateController.add(null);
      }
      // if (!audioDeviceController.isClosed) {
      //   audioDeviceController.add(AudioDevice.auto());
      // }
      // if (!audioDevicesController.isClosed) {
      //   audioDevicesController.add([AudioDevice.auto()]);
      // }
      if (!trackController.isClosed) {
        trackController.add(Track());
      }
      if (!tracksController.isClosed) {
        tracksController.add(Tracks());
      }
      if (!widthController.isClosed) {
        widthController.add(null);
      }
      if (!heightController.isClosed) {
        heightController.add(null);
      }
      if (!subtitleController.isClosed) {
        subtitleController.add(['', '']);
      }
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Starts playing the [Player].
  @override
  Future<void> play({bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      state = state.copyWith(playing: true);
      if (!playingController.isClosed) {
        playingController.add(true);
      }

      final name = 'pause'.toNativeUtf8();
      final value = calloc<Uint8>();
      mpv.mpv_get_property(
        ctx,
        name.cast(),
        generated.mpv_format.MPV_FORMAT_FLAG,
        value.cast(),
      );
      if (value.value == 1) {
        await playOrPause(
          notify: false,
          synchronized: false,
        );
      }
      calloc.free(name);
      calloc.free(value);
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Pauses the [Player].
  @override
  Future<void> pause({bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      state = state.copyWith(playing: false);
      if (!playingController.isClosed) {
        playingController.add(false);
      }

      final name = 'pause'.toNativeUtf8();
      final value = calloc<Uint8>();
      mpv.mpv_get_property(
        ctx,
        name.cast(),
        generated.mpv_format.MPV_FORMAT_FLAG,
        value.cast(),
      );
      if (value.value == 0) {
        await playOrPause(
          notify: false,
          synchronized: false,
        );
      }
      calloc.free(name);
      calloc.free(value);
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Cycles between [play] & [pause] states of the [Player].
  @override
  Future<void> playOrPause({
    bool notify = true,
    bool synchronized = true,
  }) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      if (notify) {
        // Do not change the [state.playing] value if [playOrPause] was called from [play] or [pause]; where the [state.playing] value is already changed.
        state = state.copyWith(
          playing: !state.playing,
        );
        if (!playingController.isClosed) {
          playingController.add(state.playing);
        }
      }

      isPlayingStateChangeAllowed = true;
      isBufferingStateChangeAllowed = false;

      // This condition is specifically for the case when the internal playlist is ended (with [PlaylistLoopMode.none]), and we want to play the playlist again if play/pause is pressed.
      if (state.completed) {
        await seek(Duration.zero, synchronized: false);
        final name = 'playlist-pos'.toNativeUtf8();
        final value = calloc<Int64>()..value = 0;
        mpv.mpv_set_property(
          ctx,
          name.cast(),
          generated.mpv_format.MPV_FORMAT_INT64,
          value.cast(),
        );
        calloc.free(name);
        calloc.free(value);
      }
      final command = 'cycle pause'.toNativeUtf8();
      mpv.mpv_command_string(
        ctx,
        command.cast(),
      );
      calloc.free(command);
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Appends a [Media] to the [Player]'s playlist.
  @override
  Future<void> add(Media media, {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      // External List<Media>:
      // ---------------------------------------------
      current.add(media);
      // ---------------------------------------------

      final command = 'loadfile ${media.uri} append'.toNativeUtf8();
      mpv.mpv_command_string(
        ctx,
        command.cast(),
      );
      calloc.free(command.cast());
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Removes the [Media] at specified index from the [Player]'s playlist.
  @override
  Future<void> remove(int index, {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      // External List<Media>:
      // ---------------------------------------------
      current.removeAt(index);
      // ---------------------------------------------

      // If we remove the last item in the playlist while playlist mode is none or single, then playback will stop.
      // In this situation, the playlist doesn't seem to be updated, so we manually update it.
      if (state.playlist.index == index &&
          state.playlist.medias.length - 1 == index &&
          [
            PlaylistMode.none,
            PlaylistMode.single,
          ].contains(state.playlistMode)) {
        state = state.copyWith(
          // Allow playOrPause /w state.completed code-path to play the playlist again.
          completed: true,
          playlist: state.playlist.copyWith(
            medias: state.playlist.medias.sublist(
              0,
              state.playlist.medias.length - 1,
            ),
            index: state.playlist.medias.length - 2 < 0
                ? 0
                : state.playlist.medias.length - 2,
          ),
        );
        if (!completedController.isClosed) {
          completedController.add(true);
        }
        if (!playlistController.isClosed) {
          playlistController.add(state.playlist);
        }
      }

      final command = 'playlist-remove $index'.toNativeUtf8();
      mpv.mpv_command_string(
        ctx,
        command.cast(),
      );
      calloc.free(command.cast());
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Jumps to next [Media] in the [Player]'s playlist.
  @override
  Future<void> next({bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      // Do nothing if currently present at the first or last index & playlist mode is [PlaylistMode.none] or [PlaylistMode.single].
      if ([
            PlaylistMode.none,
            PlaylistMode.single,
          ].contains(state.playlistMode) &&
          state.playlist.index == state.playlist.medias.length - 1) {
        return;
      }

      await play(synchronized: false);
      final command = 'playlist-next'.toNativeUtf8();
      mpv.mpv_command_string(
        ctx,
        command.cast(),
      );
      calloc.free(command);
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Jumps to previous [Media] in the [Player]'s playlist.
  @override
  Future<void> previous({bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      // Do nothing if currently present at the first or last index & playlist mode is [PlaylistMode.none] or [PlaylistMode.single].
      if ([
            PlaylistMode.none,
            PlaylistMode.single,
          ].contains(state.playlistMode) &&
          state.playlist.index == 0) {
        return;
      }

      await play(synchronized: false);
      final command = 'playlist-prev'.toNativeUtf8();
      mpv.mpv_command_string(
        ctx,
        command.cast(),
      );
      calloc.free(command);
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Jumps to specified [Media]'s index in the [Player]'s playlist.
  @override
  Future<void> jump(int index, {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      await play(synchronized: false);
      final name = 'playlist-pos'.toNativeUtf8();
      final value = calloc<Int64>()..value = index;
      mpv.mpv_set_property(
        ctx,
        name.cast(),
        generated.mpv_format.MPV_FORMAT_INT64,
        value.cast(),
      );
      calloc.free(name);
      calloc.free(value);
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Moves the playlist [Media] at [from], so that it takes the place of the [Media] [to].
  @override
  Future<void> move(int from, int to, {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      // External List<Media>:
      // ---------------------------------------------
      final map = SplayTreeMap<double, Media>.from(
        current.asMap().map((key, value) => MapEntry(key * 1.0, value)),
      );
      final item = map.remove(from * 1.0);
      if (item != null) {
        map[to - 0.5] = item;
      }
      final values = map.values.toList();
      current = values;
      // ---------------------------------------------

      final command = 'playlist-move $from $to'.toNativeUtf8();
      mpv.mpv_command_string(
        ctx,
        command.cast(),
      );
      calloc.free(command.cast());
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Seeks the currently playing [Media] in the [Player] by specified [Duration].
  @override
  Future<void> seek(Duration duration, {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }

      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      await compute(
        _seek,
        _SeekData(
          ctx.address,
          NativeLibrary.path,
          duration,
        ),
      );

      // It is self explanatory that PlayerState.completed & PlayerStream.completed must enter the false state if seek is called. Typically after EOF.
      // https://github.com/media-kit/media-kit/issues/221
      state = state.copyWith(completed: false);
      if (!completedController.isClosed) {
        completedController.add(false);
      }
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Sets playlist mode.
  @override
  Future<void> setPlaylistMode(PlaylistMode playlistMode,
      {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      final file = 'loop-file'.toNativeUtf8();
      final playlist = 'loop-playlist'.toNativeUtf8();
      final yes = 'yes'.toNativeUtf8();
      final no = 'no'.toNativeUtf8();
      switch (playlistMode) {
        case PlaylistMode.none:
          {
            mpv.mpv_set_property_string(
              ctx,
              file.cast(),
              no.cast(),
            );
            mpv.mpv_set_property_string(
              ctx,
              playlist.cast(),
              no.cast(),
            );
            break;
          }
        case PlaylistMode.single:
          {
            mpv.mpv_set_property_string(
              ctx,
              file.cast(),
              yes.cast(),
            );
            mpv.mpv_set_property_string(
              ctx,
              playlist.cast(),
              no.cast(),
            );
            break;
          }
        case PlaylistMode.loop:
          {
            mpv.mpv_set_property_string(
              ctx,
              file.cast(),
              no.cast(),
            );
            mpv.mpv_set_property_string(
              ctx,
              playlist.cast(),
              yes.cast(),
            );
            break;
          }
        default:
          break;
      }
      calloc.free(file);
      calloc.free(playlist);
      calloc.free(yes);
      calloc.free(no);

      state = state.copyWith(playlistMode: playlistMode);
      if (!playlistModeController.isClosed) {
        playlistModeController.add(playlistMode);
      }
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Sets the playback volume of the [Player]. Defaults to `100.0`.
  @override
  Future<void> setVolume(double volume, {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      {
        final name = 'mute'.toNativeUtf8();
        final value = calloc<Bool>();
        mpv.mpv_get_property(
          ctx,
          name.cast(),
          generated.mpv_format.MPV_FORMAT_FLAG,
          value.cast(),
        );
        if (value.value) {
          // Unmute the player before setting the volume.
          final command = 'cycle mute'.toNativeUtf8();
          mpv.mpv_command_string(
            ctx,
            command.cast(),
          );
          calloc.free(command);
        }
        calloc.free(name);
        calloc.free(value);
      }
      {
        final name = 'volume'.toNativeUtf8();
        final value = calloc<Double>();
        value.value = volume;
        mpv.mpv_set_property(
          ctx,
          name.cast(),
          generated.mpv_format.MPV_FORMAT_DOUBLE,
          value.cast(),
        );
        calloc.free(name);
        calloc.free(value);
      }
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Sets the playback rate of the [Player]. Defaults to `1.0`.
  @override
  Future<void> setRate(double rate, {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      if (rate <= 0.0) {
        throw ArgumentError.value(
          rate,
          'rate',
          'Must be greater than 0.0',
        );
      }

      if (configuration.pitch) {
        // Pitch shift control is enabled.

        state = state.copyWith(
          rate: rate,
        );
        if (!rateController.isClosed) {
          rateController.add(state.rate);
        }
        // Apparently, using scaletempo:scale actually controls the playback rate as intended after setting audio-pitch-correction as FALSE.
        // speed on the other hand, changes the pitch when audio-pitch-correction is set to FALSE.
        // Since, it also alters the actual [speed], the scaletempo:scale is divided by the same value of [pitch] to compensate the speed change.
        var name = 'audio-pitch-correction'.toNativeUtf8();
        final no = 'no'.toNativeUtf8();
        mpv.mpv_set_property_string(
          ctx,
          name.cast(),
          no.cast(),
        );
        calloc.free(name);
        calloc.free(no);
        name = 'af'.toNativeUtf8();
        // Divide by [state.pitch] to compensate the speed change caused by pitch shift.
        final value =
            'scaletempo:scale=${(state.rate / state.pitch).toStringAsFixed(8)}'
                .toNativeUtf8();
        mpv.mpv_set_property_string(
          ctx,
          name.cast(),
          value.cast(),
        );
        calloc.free(name);
        calloc.free(value);
      } else {
        // Pitch shift control is disabled.

        state = state.copyWith(
          rate: rate,
        );
        if (!rateController.isClosed) {
          rateController.add(state.rate);
        }
        final name = 'speed'.toNativeUtf8();
        final value = calloc<Double>();
        value.value = rate;
        mpv.mpv_set_property(
          ctx,
          name.cast(),
          generated.mpv_format.MPV_FORMAT_DOUBLE,
          value.cast(),
        );
        calloc.free(name);
        calloc.free(value);
      }
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Sets the relative pitch of the [Player]. Defaults to `1.0`.
  @override
  Future<void> setPitch(double pitch, {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      if (configuration.pitch) {
        if (pitch <= 0.0) {
          throw ArgumentError.value(
            pitch,
            'pitch',
            'Must be greater than 0.0',
          );
        }

        // Pitch shift control is enabled.

        state = state.copyWith(
          pitch: pitch,
        );
        if (!pitchController.isClosed) {
          pitchController.add(state.pitch);
        }
        // Apparently, using scaletempo:scale actually controls the playback rate as intended after setting audio-pitch-correction as FALSE.
        // speed on the other hand, changes the pitch when audio-pitch-correction is set to FALSE.
        // Since, it also alters the actual [speed], the scaletempo:scale is divided by the same value of [pitch] to compensate the speed change.
        var name = 'audio-pitch-correction'.toNativeUtf8();
        final no = 'no'.toNativeUtf8();
        mpv.mpv_set_property_string(
          ctx,
          name.cast(),
          no.cast(),
        );
        calloc.free(name);
        calloc.free(no);
        name = 'speed'.toNativeUtf8();
        final speed = calloc<Double>()..value = pitch;
        mpv.mpv_set_property(
          ctx,
          name.cast(),
          generated.mpv_format.MPV_FORMAT_DOUBLE,
          speed.cast(),
        );
        calloc.free(name);
        calloc.free(speed);
        name = 'af'.toNativeUtf8();
        // Divide by [state.pitch] to compensate the speed change caused by pitch shift.
        final value =
            'scaletempo:scale=${(state.rate / state.pitch).toStringAsFixed(8)}'
                .toNativeUtf8();
        mpv.mpv_set_property_string(
          ctx,
          name.cast(),
          value.cast(),
        );
        calloc.free(name);
        calloc.free(value);
      } else {
        // Pitch shift control is disabled.
        throw ArgumentError('[PlayerConfiguration.pitch] is false');
      }
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Enables or disables shuffle for [Player]. Default is `false`.
  @override
  Future<void> setShuffle(bool shuffle, {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      if (shuffle == isShuffleEnabled) {
        return;
      }
      isShuffleEnabled = shuffle;

      await _command(
        [
          shuffle ? 'playlist-shuffle' : 'playlist-unshuffle',
        ],
      );
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Sets the current [AudioDevice] for audio output.
  ///
  /// * Currently selected [AudioDevice] can be accessed using [state.audioDevice] or [stream.audioDevice].
  /// * The list of currently available [AudioDevice]s can be obtained accessed using [state.audioDevices] or [stream.audioDevices].
  @override
  Future<void> setAudioDevice(AudioDevice audioDevice,
      {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      final name = 'audio-device'.toNativeUtf8();
      final value = audioDevice.name.toNativeUtf8();
      mpv.mpv_set_property_string(
        ctx,
        name.cast(),
        value.cast(),
      );
      calloc.free(name);
      calloc.free(value);
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Sets the current [VideoTrack] for video output.
  ///
  /// * Currently selected [VideoTrack] can be accessed using [state.track.video] or [stream.track.video].
  /// * The list of currently available [VideoTrack]s can be obtained accessed using [state.tracks.video] or [stream.tracks.video].
  @override
  Future<void> setVideoTrack(VideoTrack track, {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      final name = 'vid'.toNativeUtf8();
      final value = track.id.toNativeUtf8();
      mpv.mpv_set_property_string(
        ctx,
        name.cast(),
        value.cast(),
      );
      calloc.free(name);
      calloc.free(value);
      state = state.copyWith(
        track: state.track.copyWith(
          video: track,
        ),
      );
      if (!trackController.isClosed) {
        trackController.add(state.track);
      }
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Sets the current [AudioTrack] for audio output.
  ///
  /// * Currently selected [AudioTrack] can be accessed using [state.track.audio] or [stream.track.audio].
  /// * The list of currently available [AudioTrack]s can be obtained accessed using [state.tracks.audio] or [stream.tracks.audio].
  /// * External audio track can be loaded using [AudioTrack.uri] constructor.
  ///
  /// ```dart
  /// player.setAudioTrack(
  ///   AudioTrack.uri(
  ///     'https://www.iandevlin.com/html5test/webvtt/v/upc-tobymanley.mp4',
  ///     title: 'English',
  ///     language: 'en',
  ///   ),
  /// );
  /// ```
  ///
  @override
  Future<void> setAudioTrack(AudioTrack track, {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      if (track.uri) {
        await _command(
          [
            'audio-add',
            track.id,
            'select',
            track.title ?? 'external',
            track.language ?? 'auto',
          ],
        );
        state = state.copyWith(
          track: state.track.copyWith(
            audio: track,
          ),
        );
        if (!trackController.isClosed) {
          trackController.add(state.track);
        }
      } else {
        final name = 'aid'.toNativeUtf8();
        final value = track.id.toNativeUtf8();
        mpv.mpv_set_property_string(
          ctx,
          name.cast(),
          value.cast(),
        );
        calloc.free(name);
        calloc.free(value);
        state = state.copyWith(
          track: state.track.copyWith(
            audio: track,
          ),
        );
        if (!trackController.isClosed) {
          trackController.add(state.track);
        }
      }
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Sets the current [SubtitleTrack] for subtitle output.
  ///
  /// * Currently selected [SubtitleTrack] can be accessed using [state.track.subtitle] or [stream.track.subtitle].
  /// * The list of currently available [SubtitleTrack]s can be obtained accessed using [state.tracks.subtitle] or [stream.tracks.subtitle].
  /// * External subtitle track can be loaded using [SubtitleTrack.uri] or [SubtitleTrack.data] constructor.
  ///
  /// ```dart
  /// player.setSubtitleTrack(
  ///   SubtitleTrack.uri(
  ///     'https://www.iandevlin.com/html5test/webvtt/upc-video-subtitles-en.vtt',
  ///     title: 'English',
  ///     language: 'en',
  ///   ),
  /// );
  /// ```
  ///
  @override
  Future<void> setSubtitleTrack(SubtitleTrack track,
      {bool synchronized = true}) {
    Future<void> function() async {
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }
      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      // Reset existing Player.state.subtitle & Player.stream.subtitle.
      state = state.copyWith(
        subtitle: const PlayerState().subtitle,
      );
      if (!subtitleController.isClosed) {
        subtitleController.add(state.subtitle);
      }

      if (track.uri || track.data) {
        final String uri;
        if (track.uri) {
          uri = track.id;
        } else if (track.data) {
          // Save the subtitle data to a temporary [File].
          final temp = await TempFile.create();
          await temp.write_(track.id);
          // Delete the temporary [File] upon [dispose].
          release.add(temp.delete_);
          uri = temp.uri.toString();
        } else {
          return;
        }

        await _command(
          [
            'sub-add',
            uri,
            'select',
            track.title ?? 'external',
            track.language ?? 'auto',
          ],
        );
        state = state.copyWith(
          track: state.track.copyWith(
            subtitle: track,
          ),
        );
        if (!trackController.isClosed) {
          trackController.add(state.track);
        }
      } else {
        final name = 'sid'.toNativeUtf8();
        final value = track.id.toNativeUtf8();
        mpv.mpv_set_property_string(
          ctx,
          name.cast(),
          value.cast(),
        );
        calloc.free(name);
        calloc.free(value);
        state = state.copyWith(
          track: state.track.copyWith(
            subtitle: track,
          ),
        );
        if (!trackController.isClosed) {
          trackController.add(state.track);
        }
      }
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Takes the snapshot of the current video frame & returns encoded image bytes as [Uint8List].
  ///
  /// The [format] parameter specifies the format of the image to be returned. Supported values are:
  /// * `image/jpeg`: Returns a JPEG encoded image.
  /// * `image/png`: Returns a PNG encoded image.
  /// * `null`: Returns BGRA pixel buffer.
  @override
  Future<Uint8List?> screenshot(
      {String? format = 'image/jpeg', bool synchronized = true}) async {
    Future<Uint8List?> function() async {
      if (![
        'image/jpeg',
        'image/png',
        null,
      ].contains(format)) {
        throw ArgumentError.value(
          format,
          'format',
          'Supported values are: image/jpeg, image/png, null',
        );
      }
      if (disposed) {
        throw AssertionError('[Player] has been disposed');
      }

      await waitForPlayerInitialization;
      await waitForVideoControllerInitializationIfAttached;

      return compute(
        _screenshot,
        _ScreenshotData(
          ctx.address,
          NativeLibrary.path,
          format,
        ),
      );
    }

    if (synchronized) {
      return lock.synchronized(function);
    } else {
      return function();
    }
  }

  /// Internal platform specific identifier for this [Player] instance.
  ///
  /// Since, [int] is a primitive type, it can be used to pass this [Player] instance to native code without directly depending upon this library.
  ///
  @override
  Future<int> get handle async {
    await waitForPlayerInitialization;
    return ctx.address;
  }

  /// Sets property for the internal libmpv instance of this [Player].
  /// Please use this method only if you know what you are doing, existing methods in [Player] implementation are suited for the most use cases.
  ///
  /// See:
  /// * https://mpv.io/manual/master/#options
  /// * https://mpv.io/manual/master/#properties
  ///
  Future<void> setProperty(String property, String value) async {
    if (disposed) {
      throw AssertionError('[Player] has been disposed');
    }
    await waitForPlayerInitialization;
    await waitForVideoControllerInitializationIfAttached;

    final name = property.toNativeUtf8();
    final data = value.toNativeUtf8();
    mpv.mpv_set_property_string(
      ctx,
      name.cast(),
      data.cast(),
    );
    calloc.free(name);
    calloc.free(data);
  }

  /// Retrieves the value of a property from the internal libmpv instance of this [Player].
  /// Please use this method only if you know what you are doing, existing methods in [Player] implementation are suited for the most use cases.
  ///
  /// See:
  /// * https://mpv.io/manual/master/#options
  /// * https://mpv.io/manual/master/#properties
  ///
  Future<String> getProperty(String property) async {
    if (disposed) {
      throw AssertionError('[Player] has been disposed');
    }
    await waitForPlayerInitialization;
    await waitForVideoControllerInitializationIfAttached;

    final name = property.toNativeUtf8();
    final value = mpv.mpv_get_property_string(ctx, name.cast());
    if (value != nullptr) {
      final result = value.cast<Utf8>().toDartString();
      calloc.free(name);
      mpv.mpv_free(value.cast());

      return result;
    }

    return "";
  }

  /// Observes property for the internal libmpv instance of this [Player].
  /// Please use this method only if you know what you are doing, existing methods in [Player] implementation are suited for the most use cases.
  ///
  /// See:
  /// * https://mpv.io/manual/master/#options
  /// * https://mpv.io/manual/master/#properties
  ///
  Future<void> observeProperty(
    String property,
    Future<void> Function(String) listener,
  ) async {
    if (disposed) {
      throw AssertionError('[Player] has been disposed');
    }
    await waitForPlayerInitialization;
    await waitForVideoControllerInitializationIfAttached;

    if (observed.containsKey(property)) {
      throw ArgumentError.value(
        property,
        'property',
        'Already observed',
      );
    }
    final reply = property.hashCode;
    observed[property] = listener;
    final name = property.toNativeUtf8();
    mpv.mpv_observe_property(
      ctx,
      reply,
      name.cast(),
      generated.mpv_format.MPV_FORMAT_NONE,
    );
    calloc.free(name);
  }

  /// Unobserves property for the internal libmpv instance of this [Player].
  /// Please use this method only if you know what you are doing, existing methods in [Player] implementation are suited for the most use cases.
  ///
  /// See:
  /// * https://mpv.io/manual/master/#options
  /// * https://mpv.io/manual/master/#properties
  ///
  Future<void> unobserveProperty(String property) async {
    if (disposed) {
      throw AssertionError('[Player] has been disposed');
    }
    await waitForPlayerInitialization;
    await waitForVideoControllerInitializationIfAttached;

    if (!observed.containsKey(property)) {
      throw ArgumentError.value(
        property,
        'property',
        'Not observed',
      );
    }
    final reply = property.hashCode;
    observed.remove(property);
    mpv.mpv_unobserve_property(ctx, reply);
  }

  /// Invokes command for the internal libmpv instance of this [Player].
  /// Please use this method only if you know what you are doing, existing methods in [Player] implementation are suited for the most use cases.
  ///
  /// See:
  /// * https://mpv.io/manual/master/#list-of-input-commands
  ///
  Future<void> command(List<String> command) async {
    if (disposed) {
      throw AssertionError('[Player] has been disposed');
    }
    await waitForPlayerInitialization;
    await waitForVideoControllerInitializationIfAttached;

    await _command(command);
  }

  Future<void> _handler(Pointer<generated.mpv_event> event) async {
    if (event.ref.event_id ==
        generated.mpv_event_id.MPV_EVENT_PROPERTY_CHANGE) {
      final prop = event.ref.data.cast<generated.mpv_event_property>();
      if (prop.ref.name.cast<Utf8>().toDartString() == 'idle-active' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_FLAG) {
        await future;
        // The [Player] has entered the idle state; initialization is complete.
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
      // Following properties are unrelated to the playback lifecycle. Thus, these can be accessed before initialization is complete.
      // e.g. audio-device & audio-device-list seem to be emitted before idle-active.
      if (prop.ref.name.cast<Utf8>().toDartString() == 'audio-device' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_NODE) {
        final value = prop.ref.data.cast<generated.mpv_node>();
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final name = value.ref.u.string.cast<Utf8>().toDartString();
          final audioDevice = AudioDevice(name, '');
          state = state.copyWith(audioDevice: audioDevice);
          if (!audioDeviceController.isClosed) {
            audioDeviceController.add(audioDevice);
          }
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'audio-device-list' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_NODE) {
        final value = prop.ref.data.cast<generated.mpv_node>();
        final audioDevices = <AudioDevice>[];
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_NODE_ARRAY) {
          final list = value.ref.u.list.ref;
          for (int i = 0; i < list.num; i++) {
            if (list.values[i].format ==
                generated.mpv_format.MPV_FORMAT_NODE_MAP) {
              String name = '', description = '';
              final device = list.values[i].u.list.ref;
              for (int j = 0; j < device.num; j++) {
                if (device.values[j].format ==
                    generated.mpv_format.MPV_FORMAT_STRING) {
                  final property = device.keys[j].cast<Utf8>().toDartString();
                  final value =
                      device.values[j].u.string.cast<Utf8>().toDartString();
                  switch (property) {
                    case 'name':
                      name = value;
                      break;
                    case 'description':
                      description = value;
                      break;
                  }
                }
              }
              audioDevices.add(AudioDevice(name, description));
            }
          }
          state = state.copyWith(audioDevices: audioDevices);
          if (!audioDevicesController.isClosed) {
            audioDevicesController.add(audioDevices);
          }
        }
      }
    }

    if (!completer.isCompleted) {
      // Ignore the events which are fired before the initialization.
      return;
    }

    _error(event.ref.error);

    if (event.ref.event_id == generated.mpv_event_id.MPV_EVENT_START_FILE) {
      if (isPlayingStateChangeAllowed) {
        state = state.copyWith(
          playing: true,
          completed: false,
        );
        if (!playingController.isClosed) {
          playingController.add(true);
        }
        if (!completedController.isClosed) {
          completedController.add(false);
        }
      }
      state = state.copyWith(buffering: true);
      if (!bufferingController.isClosed) {
        bufferingController.add(true);
      }
    }
    // NOTE: Now, --keep-open=yes is used. Thus, eof-reached property is used instead of this.
    // if (event.ref.event_id == generated.mpv_event_id.MPV_EVENT_END_FILE) {
    //   // Check for mpv_end_file_reason.MPV_END_FILE_REASON_EOF before modifying state.completed.
    //   if (event.ref.data.cast<generated.mpv_event_end_file>().ref.reason == generated.mpv_end_file_reason.MPV_END_FILE_REASON_EOF) {
    //     if (isPlayingStateChangeAllowed) {
    //       state = state.copyWith(
    //         playing: false,
    //         completed: true,
    //       );
    //       if (!playingController.isClosed) {
    //         playingController.add(false);
    //       }
    //       if (!completedController.isClosed) {
    //         completedController.add(true);
    //       }
    //     }
    //   }
    // }
    if (event.ref.event_id ==
        generated.mpv_event_id.MPV_EVENT_PROPERTY_CHANGE) {
      final prop = event.ref.data.cast<generated.mpv_event_property>();
      if (prop.ref.name.cast<Utf8>().toDartString() == 'pause' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_FLAG) {
        final playing = prop.ref.data.cast<Int8>().value == 0;
        if (isPlayingStateChangeAllowed) {
          state = state.copyWith(playing: playing);
          if (!playingController.isClosed) {
            playingController.add(playing);
          }
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'core-idle' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_FLAG) {
        // Check for [isBufferingStateChangeAllowed] because `pause` causes `core-idle` to be fired.
        final buffering = prop.ref.data.cast<Int8>().value == 1;
        if (buffering) {
          if (isBufferingStateChangeAllowed) {
            state = state.copyWith(buffering: true);
            if (!bufferingController.isClosed) {
              bufferingController.add(true);
            }
          }
        } else {
          state = state.copyWith(buffering: false);
          if (!bufferingController.isClosed) {
            bufferingController.add(false);
          }
        }
        isBufferingStateChangeAllowed = true;
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'paused-for-cache' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_FLAG) {
        final buffering = prop.ref.data.cast<Int8>().value == 1;
        state = state.copyWith(buffering: buffering);
        if (!bufferingController.isClosed) {
          bufferingController.add(buffering);
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'demuxer-cache-time' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_DOUBLE) {
        final buffer = Duration(
          microseconds: prop.ref.data.cast<Double>().value * 1e6 ~/ 1,
        );
        state = state.copyWith(buffer: buffer);
        if (!bufferController.isClosed) {
          bufferController.add(buffer);
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'time-pos' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_DOUBLE) {
        final position = Duration(
            microseconds: prop.ref.data.cast<Double>().value * 1e6 ~/ 1);
        state = state.copyWith(position: position);
        if (!positionController.isClosed) {
          positionController.add(position);
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'duration' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_DOUBLE) {
        final duration = Duration(
            microseconds: prop.ref.data.cast<Double>().value * 1e6 ~/ 1);
        state = state.copyWith(duration: duration);
        if (!durationController.isClosed) {
          durationController.add(duration);
        }
        if (state.playlist.index >= 0 &&
            state.playlist.index < state.playlist.medias.length) {
          final uri = state.playlist.medias[state.playlist.index].uri;
          if (FallbackBitrateHandler.supported(uri)) {
            if (!audioBitrateCache.containsKey(Media.normalizeURI(uri))) {
              audioBitrateCache[uri] =
                  await FallbackBitrateHandler.calculateBitrate(
                uri,
                duration,
              );
            }
            final bitrate = audioBitrateCache[uri];
            if (bitrate != null) {
              state = state.copyWith(audioBitrate: bitrate);
              if (!audioBitrateController.isClosed) {
                audioBitrateController.add(bitrate);
              }
            }
          }
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'playlist' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_NODE) {
        final data = prop.ref.data.cast<generated.mpv_node>();
        final list = data.ref.u.list.ref;
        int index = -1;
        List<Media> playlist = [];
        for (int i = 0; i < list.num; i++) {
          if (list.values[i].format ==
              generated.mpv_format.MPV_FORMAT_NODE_MAP) {
            final map = list.values[i].u.list.ref;
            for (int j = 0; j < map.num; j++) {
              final property = map.keys[j].cast<Utf8>().toDartString();
              if (map.values[j].format ==
                  generated.mpv_format.MPV_FORMAT_FLAG) {
                if (property == 'playing') {
                  final value = map.values[j].u.flag;
                  if (value == 1) {
                    index = i;
                  }
                }
              }
              if (map.values[j].format ==
                  generated.mpv_format.MPV_FORMAT_STRING) {
                if (property == 'filename') {
                  final v = map.values[j].u.string.cast<Utf8>().toDartString();
                  playlist.add(Media(v));
                }
              }
            }
          }
        }

        // Populate start & end attributes from [current].
        try {
          playlist = playlist
              .asMap()
              .map(
                (i, e) => MapEntry(
                  i,
                  e.copyWith(start: current[i].start, end: current[i].end),
                ),
              )
              .values
              .toList();
        } catch (exception, stacktrace) {
          print(exception.toString());
          print(stacktrace.toString());
        }

        if (index >= 0) {
          state = state.copyWith(
            playlist: Playlist(
              playlist,
              index: index,
            ),
          );
          if (!playlistController.isClosed) {
            playlistController.add(
              Playlist(
                playlist,
                index: index,
              ),
            );
          }
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'volume' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_DOUBLE) {
        final volume = prop.ref.data.cast<Double>().value;
        state = state.copyWith(volume: volume);
        if (!volumeController.isClosed) {
          volumeController.add(volume);
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'audio-params' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_NODE) {
        final data = prop.ref.data.cast<generated.mpv_node>();
        final list = data.ref.u.list.ref;
        final params = <String, dynamic>{};
        for (int i = 0; i < list.num; i++) {
          final key = list.keys[i].cast<Utf8>().toDartString();

          switch (key) {
            case 'format':
              {
                params[key] =
                    list.values[i].u.string.cast<Utf8>().toDartString();
                break;
              }
            case 'samplerate':
              {
                params[key] = list.values[i].u.int64;
                break;
              }
            case 'channels':
              {
                params[key] =
                    list.values[i].u.string.cast<Utf8>().toDartString();
                break;
              }
            case 'channel-count':
              {
                params[key] = list.values[i].u.int64;
                break;
              }
            case 'hr-channels':
              {
                params[key] =
                    list.values[i].u.string.cast<Utf8>().toDartString();
                break;
              }
            default:
              {
                break;
              }
          }
        }
        state = state.copyWith(
          audioParams: AudioParams(
            format: params['format'],
            sampleRate: params['samplerate'],
            channels: params['channels'],
            channelCount: params['channel-count'],
            hrChannels: params['hr-channels'],
          ),
        );
        if (!audioParamsController.isClosed) {
          audioParamsController.add(state.audioParams);
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'audio-bitrate' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_DOUBLE) {
        if (state.playlist.index < state.playlist.medias.length &&
            state.playlist.index >= 0) {
          final data = prop.ref.data.cast<Double>().value;
          final uri = state.playlist.medias[state.playlist.index].uri;
          if (!FallbackBitrateHandler.supported(uri)) {
            if (!audioBitrateCache.containsKey(Media.normalizeURI(uri))) {
              audioBitrateCache[Media.normalizeURI(uri)] = data;
            }
            final bitrate = audioBitrateCache[Media.normalizeURI(uri)];
            if (!audioBitrateController.isClosed &&
                bitrate != state.audioBitrate) {
              audioBitrateController.add(bitrate);
              state = state.copyWith(audioBitrate: bitrate);
            }
          }
        } else {
          if (!audioBitrateController.isClosed) {
            audioBitrateController.add(null);
            state = state.copyWith(audioBitrate: null);
          }
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'track-list' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_NODE) {
        final value = prop.ref.data.cast<generated.mpv_node>();
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_NODE_ARRAY) {
          final video = [VideoTrack.auto(), VideoTrack.no()];
          final audio = [AudioTrack.auto(), AudioTrack.no()];
          final subtitle = [SubtitleTrack.auto(), SubtitleTrack.no()];

          final tracks = value.ref.u.list.ref;

          for (int i = 0; i < tracks.num; i++) {
            if (tracks.values[i].format ==
                generated.mpv_format.MPV_FORMAT_NODE_MAP) {
              final map = tracks.values[i].u.list.ref;
              String id = '';
              String type = '';
              String? title;
              String? language;
              bool? image;
              bool? albumart;
              String? codec;
              String? decoder;
              int? w;
              int? h;
              int? channelscount;
              String? channels;
              int? samplerate;
              double? fps;
              int? bitrate;
              int? rotate;
              double? par;
              int? audiochannels;
              for (int j = 0; j < map.num; j++) {
                final property = map.keys[j].cast<Utf8>().toDartString();
                if (map.values[j].format ==
                    generated.mpv_format.MPV_FORMAT_INT64) {
                  switch (property) {
                    case 'id':
                      id = map.values[j].u.int64.toString();
                      break;
                    case 'demux-w':
                      w = map.values[j].u.int64;
                      break;
                    case 'demux-h':
                      h = map.values[j].u.int64;
                      break;
                    case 'demux-channel-count':
                      channelscount = map.values[j].u.int64;
                      break;
                    case 'demux-samplerate':
                      samplerate = map.values[j].u.int64;
                      break;
                    case 'demux-bitrate':
                      bitrate = map.values[j].u.int64;
                      break;
                    case 'demux-rotate':
                      rotate = map.values[j].u.int64;
                      break;
                    case 'audio-channels':
                      audiochannels = map.values[j].u.int64;
                      break;
                  }
                }
                if (map.values[j].format ==
                    generated.mpv_format.MPV_FORMAT_FLAG) {
                  switch (property) {
                    case 'image':
                      image = map.values[j].u.flag > 0;
                      break;
                    case 'albumart':
                      albumart = map.values[j].u.flag > 0;
                      break;
                  }
                }
                if (map.values[j].format ==
                    generated.mpv_format.MPV_FORMAT_DOUBLE) {
                  switch (property) {
                    case 'demux-fps':
                      fps = map.values[j].u.double_;
                      break;
                    case 'demux-par':
                      par = map.values[j].u.double_;
                      break;
                  }
                }
                if (map.values[j].format ==
                    generated.mpv_format.MPV_FORMAT_STRING) {
                  final value =
                      map.values[j].u.string.cast<Utf8>().toDartString();
                  switch (property) {
                    case 'type':
                      type = value;
                      break;
                    case 'title':
                      title = value;
                      break;
                    case 'lang':
                      language = value;
                      break;
                    case 'codec':
                      codec = value;
                      break;
                    case 'decoder-desc':
                      decoder = value;
                      break;
                    case 'demux-channels':
                      channels = value;
                      break;
                  }
                }
              }
              switch (type) {
                case 'video':
                  video.add(
                    VideoTrack(
                      id,
                      title,
                      language,
                      image: image,
                      albumart: albumart,
                      codec: codec,
                      decoder: decoder,
                      w: w,
                      h: h,
                      channelscount: channelscount,
                      channels: channels,
                      samplerate: samplerate,
                      fps: fps,
                      bitrate: bitrate,
                      rotate: rotate,
                      par: par,
                      audiochannels: audiochannels,
                    ),
                  );
                  break;
                case 'audio':
                  audio.add(
                    AudioTrack(
                      id,
                      title,
                      language,
                      image: image,
                      albumart: albumart,
                      codec: codec,
                      decoder: decoder,
                      w: w,
                      h: h,
                      channelscount: channelscount,
                      channels: channels,
                      samplerate: samplerate,
                      fps: fps,
                      bitrate: bitrate,
                      rotate: rotate,
                      par: par,
                      audiochannels: audiochannels,
                    ),
                  );
                  break;
                case 'sub':
                  subtitle.add(
                    SubtitleTrack(
                      id,
                      title,
                      language,
                      image: image,
                      albumart: albumart,
                      codec: codec,
                      decoder: decoder,
                      w: w,
                      h: h,
                      channelscount: channelscount,
                      channels: channels,
                      samplerate: samplerate,
                      fps: fps,
                      bitrate: bitrate,
                      rotate: rotate,
                      par: par,
                      audiochannels: audiochannels,
                    ),
                  );
                  break;
              }
            }
          }

          state = state.copyWith(
            tracks: Tracks(
              video: video,
              audio: audio,
              subtitle: subtitle,
            ),
          );
          if (!tracksController.isClosed) {
            tracksController.add(state.tracks);
          }
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'sub-text' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_NODE) {
        final value = prop.ref.data.cast<generated.mpv_node>();
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          state = state.copyWith(
            subtitle: [
              text,
              state.subtitle[1],
            ],
          );
          if (!subtitleController.isClosed) {
            subtitleController.add(state.subtitle);
          }
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'secondary-sub-text' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_NODE) {
        final value = prop.ref.data.cast<generated.mpv_node>();
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          state = state.copyWith(
            subtitle: [
              state.subtitle[0],
              text,
            ],
          );
          if (!subtitleController.isClosed) {
            subtitleController.add(state.subtitle);
          }
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'eof-reached' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_FLAG) {
        final value = prop.ref.data.cast<Bool>().value;
        if (value) {
          if (isPlayingStateChangeAllowed) {
            state = state.copyWith(
              playing: false,
              completed: true,
            );
            if (!playingController.isClosed) {
              playingController.add(false);
            }
            if (!completedController.isClosed) {
              completedController.add(true);
            }
          }

          state = state.copyWith(
            buffering: false,
            tracks: Tracks(),
            track: Track(),
          );
          if (!bufferingController.isClosed) {
            bufferingController.add(false);
          }
          if (!tracksController.isClosed) {
            tracksController.add(Tracks());
          }
          if (!trackController.isClosed) {
            trackController.add(Track());
          }
        }
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'video-out-params' &&
          prop.ref.format == generated.mpv_format.MPV_FORMAT_NODE) {
        final node = prop.ref.data.cast<generated.mpv_node>().ref;
        final data = <String, dynamic>{};
        for (int i = 0; i < node.u.list.ref.num; i++) {
          final key = node.u.list.ref.keys[i].cast<Utf8>().toDartString();
          final value = node.u.list.ref.values[i];
          switch (value.format) {
            case generated.mpv_format.MPV_FORMAT_INT64:
              data[key] = value.u.int64;
              break;
            case generated.mpv_format.MPV_FORMAT_DOUBLE:
              data[key] = value.u.double_;
              break;
            case generated.mpv_format.MPV_FORMAT_STRING:
              data[key] = value.u.string.cast<Utf8>().toDartString();
              break;
          }
        }

        final params = VideoParams(
          pixelformat: data['pixelformat'],
          hwPixelformat: data['hw-pixelformat'],
          w: data['w'],
          h: data['h'],
          dw: data['dw'],
          dh: data['dh'],
          aspect: data['aspect'],
          par: data['par'],
          colormatrix: data['colormatrix'],
          colorlevels: data['colorlevels'],
          primaries: data['primaries'],
          gamma: data['gamma'],
          sigPeak: data['sig-peak'],
          light: data['light'],
          chromaLocation: data['chroma-location'],
          rotate: data['rotate'],
          stereoIn: data['stereo-in'],
          averageBpp: data['average-bpp'],
          alpha: data['alpha'],
        );

        state = state.copyWith(
          videoParams: params,
        );
        if (!videoParamsController.isClosed) {
          videoParamsController.add(params);
        }

        final dw = params.dw;
        final dh = params.dh;
        final rotate = params.rotate ?? 0;
        if (dw is int && dh is int) {
          final int width;
          final int height;
          if (rotate == 0 || rotate == 180) {
            width = dw;
            height = dh;
          } else {
            // width & height are swapped for 90 or 270 degrees rotation.
            width = dh;
            height = dw;
          }
          state = state.copyWith(
            width: width,
            height: height,
          );
          if (!widthController.isClosed) {
            widthController.add(width);
          }
          if (!heightController.isClosed) {
            heightController.add(height);
          }
        }
      }
      if (observed.containsKey(prop.ref.name.cast<Utf8>().toDartString())) {
        if (prop.ref.format == generated.mpv_format.MPV_FORMAT_NONE) {
          final fn = observed[prop.ref.name.cast<Utf8>().toDartString()];
          if (fn != null) {
            final data = mpv.mpv_get_property_string(ctx, prop.ref.name);
            if (data != nullptr) {
              await fn.call(data.cast<Utf8>().toDartString());
              mpv.mpv_free(data.cast());
            }
          }
        }
      }
    }
    if (event.ref.event_id == generated.mpv_event_id.MPV_EVENT_LOG_MESSAGE) {
      final eventLogMessage =
          event.ref.data.cast<generated.mpv_event_log_message>().ref;
      final prefix = eventLogMessage.prefix.cast<Utf8>().toDartString().trim();
      final level = eventLogMessage.level.cast<Utf8>().toDartString().trim();
      final text = eventLogMessage.text.cast<Utf8>().toDartString().trim();
      if (!logController.isClosed) {
        logController.add(
          PlayerLog(
            prefix: prefix,
            level: level,
            text: text,
          ),
        );
        // --------------------------------------------------
        // Emit error(s) based on the log messages.
        if (level == 'error') {
          if (prefix == 'file') {
            // file:// not found.
            if (!errorController.isClosed) {
              errorController.add(text);
            }
          }
          if (prefix == 'ffmpeg') {
            if (text.startsWith('tcp:')) {
              // http:// error of any kind.
              if (!errorController.isClosed) {
                errorController.add(text);
              }
            }
          }
          if (prefix == 'vd') {
            if (!errorController.isClosed) {
              errorController.add(text);
            }
          }
          if (prefix == 'ad') {
            if (!errorController.isClosed) {
              errorController.add(text);
            }
          }
          if (prefix == 'cplayer') {
            if (!errorController.isClosed) {
              errorController.add(text);
            }
          }
          if (prefix == 'stream') {
            if (!errorController.isClosed) {
              errorController.add(text);
            }
          }
        }
        // --------------------------------------------------
      }
    }
    if (event.ref.event_id == generated.mpv_event_id.MPV_EVENT_HOOK) {
      final prop = event.ref.data.cast<generated.mpv_event_hook>();
      if (prop.ref.name.cast<Utf8>().toDartString() == 'on_load') {
        // --------------------------------------------------
        for (final hook in onLoadHooks) {
          try {
            await hook.call();
          } catch (exception, stacktrace) {
            print(exception);
            print(stacktrace);
          }
        }
        // --------------------------------------------------
        // Handle HTTP headers specified in the [Media].
        try {
          final name = 'path'.toNativeUtf8();
          final uri = mpv.mpv_get_property_string(
            ctx,
            name.cast(),
          );
          // Get the headers for current [Media] by looking up [uri] in the [HashMap].
          final headers = Media(uri.cast<Utf8>().toDartString()).httpHeaders;
          if (headers != null) {
            final property = 'http-header-fields'.toNativeUtf8();
            // Allocate & fill the [mpv_node] with the headers.
            final value = calloc<generated.mpv_node>();
            value.ref.format = generated.mpv_format.MPV_FORMAT_NODE_ARRAY;
            value.ref.u.list = calloc<generated.mpv_node_list>();
            value.ref.u.list.ref.num = headers.length;
            value.ref.u.list.ref.values = calloc<generated.mpv_node>(
              headers.length,
            );
            final entries = headers.entries.toList();
            for (int i = 0; i < entries.length; i++) {
              final k = entries[i].key;
              final v = entries[i].value;
              final data = '$k: $v'.toNativeUtf8();
              value.ref.u.list.ref.values[i].format =
                  generated.mpv_format.MPV_FORMAT_STRING;
              value.ref.u.list.ref.values[i].u.string = data.cast();
            }
            mpv.mpv_set_property(
              ctx,
              property.cast(),
              generated.mpv_format.MPV_FORMAT_NODE,
              value.cast(),
            );
            // Free the allocated memory.
            calloc.free(property);
            for (int i = 0; i < value.ref.u.list.ref.num; i++) {
              calloc.free(value.ref.u.list.ref.values[i].u.string);
            }
            calloc.free(value.ref.u.list.ref.values);
            calloc.free(value.ref.u.list);
            calloc.free(value);
          }
          mpv.mpv_free(uri.cast());
          calloc.free(name);
        } catch (exception, stacktrace) {
          print(exception);
          print(stacktrace);
        }
        // Handle start & end position specified in the [Media].
        try {
          final name = 'playlist-pos'.toNativeUtf8();
          final value = calloc<Int64>();
          value.value = -1;

          mpv.mpv_get_property(
            ctx,
            name.cast(),
            generated.mpv_format.MPV_FORMAT_INT64,
            value.cast(),
          );

          final index = value.value;

          calloc.free(name.cast());
          calloc.free(value.cast());

          if (index >= 0) {
            final start = current[index].start;
            final end = current[index].end;

            if (start != null) {
              try {
                final property = 'start'.toNativeUtf8();
                final value = (start.inMilliseconds / 1000).toStringAsFixed(3).toNativeUtf8();
                mpv.mpv_set_property_string(
                  ctx,
                  property.cast(),
                  value.cast(),
                );
                calloc.free(property);
                calloc.free(value);
              } catch (exception, stacktrace) {
                print(exception);
                print(stacktrace);
              }
            }

            if (end != null) {
              try {
                final property = 'end'.toNativeUtf8();
                final value = (end.inMilliseconds / 1000).toStringAsFixed(3).toNativeUtf8();
                mpv.mpv_set_property_string(
                  ctx,
                  property.cast(),
                  value.cast(),
                );
                calloc.free(property);
                calloc.free(value);
              } catch (exception, stacktrace) {
                print(exception);
                print(stacktrace);
              }
            }
          }
        } catch (exception, stacktrace) {
          print(exception);
          print(stacktrace);
        }
        // --------------------------------------------------
        mpv.mpv_hook_continue(
          ctx,
          prop.ref.id,
        );
      }
      if (prop.ref.name.cast<Utf8>().toDartString() == 'on_unload') {
        // --------------------------------------------------
        for (final hook in onUnloadHooks) {
          try {
            await hook.call();
          } catch (exception, stacktrace) {
            print(exception);
            print(stacktrace);
          }
        }
        // --------------------------------------------------
        // Set http-header-fields as [generated.mpv_format.MPV_FORMAT_NONE] [generated.mpv_node].
        try {
          final property = 'http-header-fields'.toNativeUtf8();
          final value = calloc<generated.mpv_node>();
          value.ref.format = generated.mpv_format.MPV_FORMAT_NONE;
          mpv.mpv_set_property(
            ctx,
            property.cast(),
            generated.mpv_format.MPV_FORMAT_NODE,
            value.cast(),
          );
          calloc.free(property);
          calloc.free(value);
        } catch (exception, stacktrace) {
          print(exception);
          print(stacktrace);
        }
        // Set start & end position as [generated.mpv_format.MPV_FORMAT_NONE] [generated.mpv_node].
        try {
          final property = 'start'.toNativeUtf8();
          final value = 'none'.toNativeUtf8();
          mpv.mpv_set_property_string(
            ctx,
            property.cast(),
            value.cast(),
          );
          calloc.free(property);
          calloc.free(value);
        } catch (exception, stacktrace) {
          print(exception);
          print(stacktrace);
        }
        try {
          final property = 'end'.toNativeUtf8();
          final value = 'none'.toNativeUtf8();
          mpv.mpv_set_property_string(
            ctx,
            property.cast(),
            value.cast(),
          );
          calloc.free(property);
          calloc.free(value);
        } catch (exception, stacktrace) {
          print(exception);
          print(stacktrace);
        }
        // --------------------------------------------------
        mpv.mpv_hook_continue(
          ctx,
          prop.ref.id,
        );
      }
    }
  }

  Future<void> _create() {
    return lock.synchronized(() async {
      // The options which must be set before [MPV.mpv_initialize].
      final options = <String, String>{
        // Set --vid=no by default to prevent redundant video decoding.
        // [VideoController] internally sets --vid=auto upon attachment to enable video rendering & decoding.
        if (!test) 'vid': 'no',
      };

      if (Platform.isAndroid &&
          configuration.libass &&
          configuration.libassAndroidFont != null) {
        try {
          // On Android, the system fonts cannot be picked up by libass/fontconfig. This makes libass subtitle rendering fail.
          // We save the subtitle font to the application's cache directory and set `config` & `config-dir` to use it.
          final subfont = await AndroidAssetLoader.load(
            join(
              'flutter_assets',
              configuration.libassAndroidFont,
            ),
          );
          if (subfont.isNotEmpty) {
            final directory = dirname(subfont);
            // This asset is bundled as part of `package:media_kit_libs_android_video`.
            // Use it if located inside the application bundle, otherwise no worries.
            options.addAll(
              {
                'config': 'yes',
                'config-dir': directory,
              },
            );
            print(subfont);
            print(directory);
          }
        } catch (exception, stacktrace) {
          print(exception);
          print(stacktrace);
        }
      }

      ctx = await Initializer.create(
        NativeLibrary.path,
        _handler,
        options: options,
      );

      // ALL:
      //
      // idle = yes
      // pause = yes
      // keep-open = yes
      // audio-display = no
      // network-timeout = 5
      // scale=bilinear
      // dscale=bilinear
      // dither=no
      // correct-downscaling=no
      // linear-downscaling=no
      // sigmoid-upscaling=no
      // hdr-compute-peak=no
      //
      // ANDROID (Physical Device OR API Level > 25):
      //
      // ao = opensles
      //
      // ANDROID (Emulator AND API Level <= 25):
      //
      // ao = null
      //
      final properties = <String, String>{
        'idle': 'yes',
        'pause': 'yes',
        'keep-open': 'yes',
        'audio-display': 'no',
        'network-timeout': '5',
        // https://github.com/mpv-player/mpv/commit/703f1588803eaa428e09c0e5547b26c0fff476a7
        // https://github.com/mpv-android/mpv-android/commit/9e5c3d8a630290fc41edb8b03aeafa3bc4c45955
        'scale': 'bilinear',
        'dscale': 'bilinear',
        'dither': 'no',
        'cache': 'yes',
        'correct-downscaling': 'no',
        'linear-downscaling': 'no',
        'sigmoid-upscaling': 'no',
        'hdr-compute-peak': 'no',
        if (AndroidHelper.isPhysicalDevice || AndroidHelper.APILevel > 25)
          'ao': 'opensles'
        // Disable audio output on older Android emulators with API Level < 25.
        // OpenSL ES audio output seems to be broken on some of these.
        else if (AndroidHelper.isEmulator && AndroidHelper.APILevel <= 25)
          'ao': 'null',
        'subs-fallback': 'yes',
        'subs-with-matching-audio': 'yes',
      };
      // Other properties based on [PlayerConfiguration].
      properties.addAll(
        {
          if (!configuration.osc) ...{
            'osc': 'no',
            'osd-level': '0',
          },
          'title': configuration.title,
          'demuxer-max-bytes': configuration.bufferSize.toString(),
          'demuxer-max-back-bytes': configuration.bufferSize.toString(),
          if (configuration.vo != null) 'vo': '${configuration.vo}',
          'demuxer-lavf-o': [
            'seg_max_retry=5',
            'strict=experimental',
            'allowed_extensions=ALL',
            'protocol_whitelist=[${configuration.protocolWhitelist.join(',')}]'
          ].join(','),
          'sub-ass': configuration.libass ? 'yes' : 'no',
          'sub-visibility': configuration.libass ? 'yes' : 'no',
          'secondary-sub-visibility': configuration.libass ? 'yes' : 'no',
        },
      );

      if (test) {
        properties['vo'] = 'null';
        properties['ao'] = 'null';
      }

      for (final property in properties.entries) {
        final name = property.key.toNativeUtf8();
        final value = property.value.toNativeUtf8();
        mpv.mpv_set_property_string(
          ctx,
          name.cast(),
          value.cast(),
        );
        calloc.free(name);
        calloc.free(value);
      }

      if (configuration.muted) {
        final name = 'mute'.toNativeUtf8();
        final value = calloc<Bool>()..value = true;
        mpv.mpv_set_property(
          ctx,
          name.cast(),
          generated.mpv_format.MPV_FORMAT_FLAG,
          value.cast(),
        );
        calloc.free(name);
        calloc.free(value);

        state = state.copyWith(volume: 0.0);
        if (!volumeController.isClosed) {
          volumeController.add(0.0);
        }
      }

      // Observe the properties to update the state & feed event stream.
      <String, int>{
        'pause': generated.mpv_format.MPV_FORMAT_FLAG,
        'time-pos': generated.mpv_format.MPV_FORMAT_DOUBLE,
        'duration': generated.mpv_format.MPV_FORMAT_DOUBLE,
        'playlist': generated.mpv_format.MPV_FORMAT_NODE,
        'volume': generated.mpv_format.MPV_FORMAT_DOUBLE,
        'speed': generated.mpv_format.MPV_FORMAT_DOUBLE,
        'core-idle': generated.mpv_format.MPV_FORMAT_FLAG,
        'paused-for-cache': generated.mpv_format.MPV_FORMAT_FLAG,
        'demuxer-cache-time': generated.mpv_format.MPV_FORMAT_DOUBLE,
        'audio-params': generated.mpv_format.MPV_FORMAT_NODE,
        'audio-bitrate': generated.mpv_format.MPV_FORMAT_DOUBLE,
        'audio-device': generated.mpv_format.MPV_FORMAT_NODE,
        'audio-device-list': generated.mpv_format.MPV_FORMAT_NODE,
        'video-out-params': generated.mpv_format.MPV_FORMAT_NODE,
        'track-list': generated.mpv_format.MPV_FORMAT_NODE,
        'eof-reached': generated.mpv_format.MPV_FORMAT_FLAG,
        'idle-active': generated.mpv_format.MPV_FORMAT_FLAG,
        'sub-text': generated.mpv_format.MPV_FORMAT_NODE,
        'secondary-sub-text': generated.mpv_format.MPV_FORMAT_NODE,
      }.forEach(
        (property, format) {
          final name = property.toNativeUtf8();
          mpv.mpv_observe_property(
            ctx,
            0,
            name.cast(),
            format,
          );
          calloc.free(name);
        },
      );

      // https://github.com/mpv-player/mpv/blob/e1727553f164181265f71a20106fbd5e34fa08b0/libmpv/client.h#L1410-L1419
      final levels = {
        MPVLogLevel.error: 'error',
        MPVLogLevel.warn: 'warn',
        MPVLogLevel.info: 'info',
        MPVLogLevel.v: 'v',
        MPVLogLevel.debug: 'debug',
        MPVLogLevel.trace: 'trace',
      };
      final level = levels[configuration.logLevel];
      if (level != null) {
        final min = level.toNativeUtf8();
        mpv.mpv_request_log_messages(ctx, min.cast());
        calloc.free(min);
      }

      // Add libmpv hooks for supporting custom HTTP headers in [Media].
      final load = 'on_load'.toNativeUtf8();
      final unload = 'on_unload'.toNativeUtf8();
      mpv.mpv_hook_add(ctx, 0, load.cast(), 0);
      mpv.mpv_hook_add(ctx, 0, unload.cast(), 0);
      calloc.free(load);
      calloc.free(unload);
    });
  }

  /// Adds an error to the [Player.stream.error].
  void _error(int code) {
    if (code < 0 && !errorController.isClosed) {
      final message = mpv.mpv_error_string(code).cast<Utf8>().toDartString();
      errorController.add(message);
    }
  }

  /// Calls mpv command passed as [args].
  /// Automatically freeds memory after command sending.
  Future<void> _command(List<String> args) async {
    final pointers = args.map<Pointer<Utf8>>((e) => e.toNativeUtf8()).toList();
    final arr = calloc<Pointer<Utf8>>(128);
    for (int i = 0; i < args.length; i++) {
      arr.elementAt(i).value = pointers[i];
    }
    mpv.mpv_command(
      ctx,
      arr.cast(),
    );
    calloc.free(arr);
    pointers.forEach(calloc.free);
  }

  /// Internal generated libmpv C API bindings.
  final generated.MPV mpv;

  /// [Pointer] to [generated.mpv_handle] of this instance.
  Pointer<generated.mpv_handle> ctx = nullptr;

  /// The [Future] to wait for [_create] completion.
  /// This is used to prevent signaling [completer] (from [PlatformPlayer]) before [_create] completes in any hypothetical situation (because `idle-active` may fire before it).
  Future<void>? future;

  /// Whether the [Player] has been disposed. This is used to prevent accessing dangling [ctx] after [dispose].
  bool disposed = false;

  /// A flag to keep track of [setShuffle] calls.
  bool isShuffleEnabled = false;

  /// A flag to prevent changes to [state.playing] due to `loadfile` commands in [open].
  ///
  /// By default, `MPV_EVENT_START_FILE` is fired when a new media source is loaded.
  /// This event modifies the [state.playing] & [stream.playing] to `true`.
  ///
  /// However, the [Player] is in paused state before the media source is loaded.
  /// Thus, [state.playing] should not be changed, unless the user explicitly calls [play] or [playOrPause].
  ///
  /// We set [isPlayingStateChangeAllowed] to `false` at the start of [open] to prevent this unwanted change & set it to `true` at the end of [open].
  /// While [isPlayingStateChangeAllowed] is `false`, any change to [state.playing] & [stream.playing] is ignored.
  bool isPlayingStateChangeAllowed = false;

  /// A flag to prevent changes to [state.buffering] due to `pause` causing `core-idle` to be `true`.
  ///
  /// This is used to prevent [state.buffering] being set to `true` when [pause] or [playOrPause] is called.
  bool isBufferingStateChangeAllowed = true;

  /// Current loaded [Media] queue.
  List<Media> current = <Media>[];

  /// Currently observed properties through [observeProperty].
  final HashMap<String, Future<void> Function(String)> observed =
      HashMap<String, Future<void> Function(String)>();

  /// The methods which must execute synchronously before playback of a source can begin.
  final List<Future<void> Function()> onLoadHooks = [];

  /// The methods which must execute synchronously before playback of a source can end.
  final List<Future<void> Function()> onUnloadHooks = [];

  /// Synchronization & mutual exclusion between methods of this class.
  static final Lock lock = Lock();

  /// [HashMap] for retrieving previously fetched audio-bitrate(s).
  static final HashMap<String, double> audioBitrateCache =
      HashMap<String, double>();

  /// Whether the [NativePlayer] is initialized for unit-testing.
  @visibleForTesting
  static bool test = false;
}

// --------------------------------------------------
// Performance sensitive methods in [Player] are executed in an [Isolate].
// This avoids blocking the Dart event loop for long periods of time.
//
// TODO: Maybe eventually move all methods to [Isolate]?
// --------------------------------------------------

class _SeekData {
  final int ctx;
  final String lib;
  final Duration duration;

  _SeekData(
    this.ctx,
    this.lib,
    this.duration,
  );
}

/// [NativePlayer.seek]
void _seek(_SeekData data) {
  // ---------
  final mpv = generated.MPV(DynamicLibrary.open(data.lib));
  final ctx = Pointer<generated.mpv_handle>.fromAddress(data.ctx);
  // ---------
  final duration = data.duration;
  // ---------
  final value = duration.inMilliseconds / 1000;
  final command = 'seek ${value.toStringAsFixed(4)} absolute'.toNativeUtf8();
  mpv.mpv_command_string(
    ctx,
    command.cast(),
  );
  calloc.free(command);
}

class _ScreenshotData {
  final int ctx;
  final String lib;
  final String? format;

  const _ScreenshotData(
    this.ctx,
    this.lib,
    this.format,
  );
}

/// [NativePlayer.screenshot]
Uint8List? _screenshot(_ScreenshotData data) {
  // ---------
  final mpv = generated.MPV(DynamicLibrary.open(data.lib));
  final ctx = Pointer<generated.mpv_handle>.fromAddress(data.ctx);
  // ---------
  final format = data.format;
  // ---------

  // https://mpv.io/manual/stable/#command-interface-screenshot-raw
  final args = [
    'screenshot-raw',
    'video',
  ];

  final result = calloc<generated.mpv_node>();

  final pointers = args.map<Pointer<Utf8>>((e) {
    return e.toNativeUtf8();
  }).toList();
  final Pointer<Pointer<Utf8>> arr = calloc.allocate(args.join().length);
  for (int i = 0; i < args.length; i++) {
    arr[i] = pointers[i];
  }
  mpv.mpv_command_ret(
    ctx,
    arr.cast(),
    result.cast(),
  );

  Uint8List? image;

  if (result.ref.format == generated.mpv_format.MPV_FORMAT_NODE_MAP) {
    int? w, h, stride;
    Uint8List? bytes;

    final map = result.ref.u.list;
    for (int i = 0; i < map.ref.num; i++) {
      final key = map.ref.keys[i].cast<Utf8>().toDartString();
      final value = map.ref.values[i];
      switch (value.format) {
        case generated.mpv_format.MPV_FORMAT_INT64:
          switch (key) {
            case 'w':
              w = value.u.int64;
              break;
            case 'h':
              h = value.u.int64;
              break;
            case 'stride':
              stride = value.u.int64;
              break;
          }
          break;
        case generated.mpv_format.MPV_FORMAT_BYTE_ARRAY:
          switch (key) {
            case 'data':
              final data = value.u.ba.ref.data.cast<Uint8>();
              bytes = data.asTypedList(value.u.ba.ref.size);
              break;
          }
          break;
      }
    }

    if (w != null && h != null && stride != null && bytes != null) {
      switch (format) {
        case 'image/jpeg':
          {
            final pixels = Image(
              width: w,
              height: h,
              numChannels: 3,
            );
            for (final pixel in pixels) {
              final x = pixel.x;
              final y = pixel.y;
              final i = (y * stride) + (x * 4);
              pixel.b = bytes[i];
              pixel.g = bytes[i + 1];
              pixel.r = bytes[i + 2];
            }
            image = encodeJpg(pixels);
            break;
          }
        case 'image/png':
          {
            final pixels = Image(
              width: w,
              height: h,
              numChannels: 3,
            );
            for (final pixel in pixels) {
              final x = pixel.x;
              final y = pixel.y;
              final i = (y * stride) + (x * 4);
              pixel.b = bytes[i];
              pixel.g = bytes[i + 1];
              pixel.r = bytes[i + 2];
            }
            image = encodePng(pixels);
            break;
          }
        case null:
          {
            image = bytes;
            break;
          }
      }
    }
  }

  pointers.forEach(calloc.free);
  mpv.mpv_free_node_contents(result.cast());

  calloc.free(arr);
  calloc.free(result.cast());

  return image;
}

// --------------------------------------------------
