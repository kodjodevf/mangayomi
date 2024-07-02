// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';
import 'package:fvp/fvp.dart';
import 'package:fvp/mdk.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:video_player/video_player.dart';

extension VideoPlayerControllerExtension on VideoPlayerController {
  Player? get mdkPlayer => mdkPlayers[textureId];

  List<(bool, Track)> subtitles(List<Track>? subs) {
    List<(bool, Track)> subtitles = [];
    for (SubtitleStreamInfo subtitle in mdkPlayer?.mediaInfo.subtitle ?? []) {
      if (!subtitles.any(
          (element) => element.$2.label == subtitle.metadata["language"])) {
        subtitles.add((
          true,
          Track(
              label: subtitle.metadata["language"],
              file: (subtitle.index - 2).toString())
        ));
      }
    }
    for (Track subtitle in subs ?? []) {
      subtitles.add((false, subtitle));
    }
    subtitles.sort((a, b) => a.$2.file!.compareTo(b.$2.file!));
    return subtitles.toSet().toList();
  }

  List<(bool, Track)> audios(List<Track>? auds) {
    List<(bool, Track)> audios = [];
    for (AudioStreamInfo audio in mdkPlayer?.mediaInfo.audio ?? []) {
      if (!audios
          .any((element) => element.$2.label == audio.metadata["language"])) {
        audios.add((
          true,
          Track(
              label: audio.metadata["language"],
              file: (audio.index - 2).toString())
        ));
      }
    }
    for (Track audio in auds ?? []) {
      audios.add((false, audio));
    }
    audios.sort((a, b) => a.$2.file!.compareTo(b.$2.file!));
    return audios.toSet().toList();
  }

  void setSubtitle(int index) {
    mdkPlayer?.setActiveTracks(MediaType.subtitle, [index]);
  }

  void setAudio(int index) {
    mdkPlayer?.setActiveTracks(MediaType.audio, [index]);
  }

  void setAudioUrl(String uri) {
    mdkPlayer?.setMedia(uri, MediaType.audio);
  }

  void setSubtitleUrl(String uri) {
    mdkPlayer?.setMedia(uri, MediaType.subtitle);
  }
}

extension VideoModelExtension on Video {
  VideoPlayerController loadVideo(Track? subtitle) {
    return originalUrl.startsWith('http')
        ? VideoPlayerController.networkUrl(Uri.parse(originalUrl),
            httpHeaders: headers ?? {},
            closedCaptionFile: subtitle?.loadCaption())
        : VideoPlayerController.file(File(originalUrl),
            httpHeaders: headers ?? {},
            closedCaptionFile: subtitle?.loadCaption());
  }
}

extension TrackModelExtension on Track {
  Future<ClosedCaptionFile>? loadCaption() async {
    String fileContents = "";
    fileContents =
        utf8.decode((await MClient.init().get(Uri.parse(file!))).bodyBytes);
    if (file!.endsWith(".srt")) {
      return SubRipCaptionFile(fileContents);
    }
    return WebVTTCaptionFile(fileContents);
  }
}
