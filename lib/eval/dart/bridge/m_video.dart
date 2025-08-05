import 'package:d4rt/d4rt.dart';
import 'package:mangayomi/models/video.dart';

class MVideoBridge {
  final mVideoBridgedClass = BridgedClass(
    nativeType: Video,
    name: 'MVideo',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return Video(
          positionalArgs.get<String?>(0) ?? '',
          positionalArgs.get<String?>(1) ?? '',
          positionalArgs.get<String?>(2) ?? '',
          headers: namedArgs.get<Map?>('headers')?.cast(),
          subtitles: namedArgs.get<List<Track>?>('subtitles'),
          audios: namedArgs.get<List<Track>?>('audios'),
        );
      },
    },
    getters: {
      'url': (visitor, target) => (target as Video).url,
      'quality': (visitor, target) => (target as Video).quality,
      'originalUrl': (visitor, target) => (target as Video).originalUrl,
      'headers': (visitor, target) => (target as Video).headers,
      'subtitles': (visitor, target) => (target as Video).subtitles,
      'audios': (visitor, target) => (target as Video).audios,
    },
    setters: {
      'url': (visitor, target, value) =>
          (target as Video).url = value as String,
      'quality': (visitor, target, value) =>
          (target as Video).quality = value as String,
      'originalUrl': (visitor, target, value) =>
          (target as Video).originalUrl = value as String,
      'headers': (visitor, target, value) =>
          (target as Video).headers = (value as Map?)?.cast(),
      'subtitles': (visitor, target, value) =>
          (target as Video).subtitles = (value as List?)?.cast(),
      'audios': (visitor, target, value) =>
          (target as Video).audios = (value as List?)?.cast(),
    },
  );
  void registerBridgedClasses(D4rt interpreter) {
    interpreter.registerBridgedClass(
      mVideoBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
  }
}
