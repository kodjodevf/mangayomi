import 'package:media_kit/media_kit.dart';

/// The video/audio/subtitle track combination the player was (or should be)
/// opened with. `isLocal` distinguishes an already-loaded local video track
/// (just switch tracks on the existing media) from an external quality
/// option (needs the media reopened at a different URL).
class VideoPrefs {
  String? title;
  VideoTrack? videoTrack;
  SubtitleTrack? subtitle;
  AudioTrack? audio;
  bool isLocal;
  final Map<String, String>? headers;
  VideoPrefs({
    this.videoTrack,
    this.isLocal = true,
    this.headers,
    this.subtitle,
    this.audio,
    this.title,
  });
}
