// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fvp/mdk.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import 'package:fvp/mdk.dart' as mdk;

final _log = Logger('fvp');

class MdkVideoPlayer extends mdk.Player {
  final streamCtl = StreamController<VideoEvent>();

  @override
  void dispose() {
    onMediaStatus(null);
    onEvent(null);
    onStateChanged(null);
    streamCtl.close();
    super.dispose();
  }

  MdkVideoPlayer() : super() {
    onMediaStatus((oldValue, newValue) {
      _log.fine(
          '$hashCode player$nativeHandle onMediaStatus: $oldValue => $newValue');
      if (!oldValue.test(mdk.MediaStatus.loaded) &&
          newValue.test(mdk.MediaStatus.loaded)) {
        // initialized event must be sent only once. keep_open=1 is another solution
        if ((textureId.value ?? -1) >= 0) {
          return true;
        }
        final info = mediaInfo;
        var size = const Size(0, 0);
        if (info.video != null) {
          final vc = info.video![0].codec;
          size = Size(vc.width.toDouble(),
              (vc.height.toDouble() / vc.par).roundToDouble());
          if (info.video![0].rotation % 180 == 90) {
            size = Size(size.height, size.width);
          }
        }
        streamCtl.add(VideoEvent(
            eventType: VideoEventType.initialized,
            duration: Duration(
                microseconds: isLive
// int max for live streams, duration.inMicroseconds == 9223372036854775807
                    ? double.maxFinite.toInt()
                    : info.duration * 1000),
            size: size));
      } else if (!oldValue.test(mdk.MediaStatus.buffering) &&
          newValue.test(mdk.MediaStatus.buffering)) {
        streamCtl.add(VideoEvent(eventType: VideoEventType.bufferingStart));
      } else if (!oldValue.test(mdk.MediaStatus.buffered) &&
          newValue.test(mdk.MediaStatus.buffered)) {
        streamCtl.add(VideoEvent(eventType: VideoEventType.bufferingEnd));
      }
      return true;
    });

    onEvent((ev) {
      _log.fine(
          '$hashCode player$nativeHandle onEvent: ${ev.category} - ${ev.detail} - ${ev.error}');
      if (ev.category == "reader.buffering") {
        final pos = position;
        final bufLen = buffered();
        streamCtl.add(
            VideoEvent(eventType: VideoEventType.bufferingUpdate, buffered: [
          DurationRange(
              Duration(microseconds: pos), Duration(milliseconds: pos + bufLen))
        ]));
      }
    });

    onStateChanged((oldValue, newValue) {
      _log.fine(
          '$hashCode player$nativeHandle onPlaybackStateChanged: $oldValue => $newValue');
      if (newValue == mdk.PlaybackState.stopped) {
        // FIXME: keep_open no stopped
        streamCtl.add(VideoEvent(eventType: VideoEventType.completed));
        return;
      }
      streamCtl.add(VideoEvent(
          eventType: VideoEventType.isPlayingStateUpdate,
          isPlaying: newValue == mdk.PlaybackState.playing));
    });
  }
}

extension MdkExtensions on MdkVideoPlayer {
  void loadVideo(String uri, String? subtitle,
      {required Map<String, String> httpHeaders}) async {
    const vd = {
      'windows': ['MFT:d3d=11', "D3D11", 'CUDA', 'FFmpeg'],
      'macos': ['VT', 'FFmpeg'],
      'ios': ['VT', 'FFmpeg'],
      'linux': ['VAAPI', 'CUDA', 'VDPAU', 'FFmpeg'],
      'android': ['AMediaCodec', 'FFmpeg'],
    };
    List<String> decoders = vd[Platform.operatingSystem]!;

    _log.fine('$hashCode player${nativeHandle} create($uri)');

    setProperty('video.decoder', 'shader_resource=0');
    setProperty('avformat.strict', 'experimental');
    setProperty('avio.protocol_whitelist',
        'file,rtmp,http,https,tls,rtp,tcp,udp,crypto,httpproxy,data,concatf,concat,subfile');
    setProperty('avformat.rtsp_transport', 'tcp');

    videoDecoders = decoders;

    if (httpHeaders.isNotEmpty) {
      String headers = '';
      httpHeaders.forEach((key, value) {
        headers += '$key: $value\r\n';
      });
      setProperty('avio.headers', headers);
    }
    media = uri;
    if (subtitle != null) {
      setMedia(subtitle, MediaType.subtitle);
    }
    int ret = await prepare();
    if (ret < 0) {
      dispose();
      throw PlatformException(
        code: 'media open error',
        message: 'invalid or unsupported media',
      );
    }
    updateTexture();
  }

  Future<void> setLooping(bool looping) async {
    loop = looping ? -1 : 0;
  }

  Future<void> play() async {
    state = PlaybackState.playing;
  }

  Future<void> pause() async {
    state = PlaybackState.paused;
  }

  Future<void> setVolume(double volume) async {
    volume = volume;
  }

  Future<void> setPlaybackSpeed(double speed) async {
    playbackRate = speed;
  }

  Future<void> seekTo(Duration pos) async {
    if (isLive) {
      final bufMax = buffered();

      if (pos.inMilliseconds <= position ||
          pos.inMilliseconds > position + bufMax) {
        _log.fine(
            'seekTo: $pos out of live stream buffered range [$position, ${position + bufMax}]');
        return;
      }
    }
    seek(
        position: pos.inMilliseconds,
        flags: const SeekFlag(SeekFlag.fromStart | SeekFlag.inCache));
  }

  Future<Duration> getPosition() async {
    final bufLen = buffered();
    final ranges = bufferedTimeRanges();
    streamCtl.add(VideoEvent(
        eventType: VideoEventType.bufferingUpdate,
        buffered: ranges +
            [
              DurationRange(Duration(milliseconds: position),
                  Duration(milliseconds: position + bufLen))
            ]));
    return Duration(milliseconds: position);
  }

  Stream<VideoEvent> videoEventsFor() {
    return streamCtl.stream;
  }

  Widget buildView() {
    return ValueListenableBuilder<int?>(
      valueListenable: textureId,
      builder: (context, id, _) =>
          id == null ? const SizedBox.shrink() : Texture(textureId: id),
    );
  }

  void setSubtitleFromUri(String? uri) {
    if (uri != null) {
      setMedia(uri, MediaType.subtitle);
    }
  }
}
