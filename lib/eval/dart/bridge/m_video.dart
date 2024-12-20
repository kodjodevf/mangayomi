import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/dart/bridge/m_track.dart';
import 'package:mangayomi/models/video.dart';

class $MVideo implements Video, $Instance {
  $MVideo.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'MVideo'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
        ))
      },
      // Specify class fields
      fields: {
        'url': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'quality': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'originalUrl': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'headers': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.map, [
              BridgeTypeRef(CoreTypes.string),
              BridgeTypeRef(CoreTypes.string)
            ]),
            nullable: true)),
        'subtitles': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [$MTrack.$type]))),
        'audios': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [$MTrack.$type]))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $MVideo.wrap(Video("", "", ""));
  }

  @override
  final Video $value;

  @override
  Video get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'url':
        return $String($value.url);
      case 'quality':
        return $String($value.quality);
      case 'originalUrl':
        return $String($value.originalUrl);
      case 'headers':
        return $Map.wrap($value.headers ?? {});
      case 'subtitles':
        return $List.wrap($value.subtitles!
            .map((e) => $MTrack.wrap(Track(file: e.file, label: e.label)))
            .toList());
      case 'audios':
        return $List.wrap($value.audios!
            .map((e) => $MTrack.wrap(Track(file: e.file, label: e.label)))
            .toList());

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'url':
        $value.url = value.$reified;
      case 'quality':
        $value.quality = value.$reified;
      case 'originalUrl':
        $value.originalUrl = value.$reified;
      case 'headers':
        $value.headers = (value.$reified as Map)
            .map((key, value) => MapEntry(key.toString(), value.toString()));
      case 'subtitles':
        $value.subtitles = (value.$reified as List)
            .map((e) => Track(file: e.file, label: e.label))
            .toList();

      case 'audios':
        $value.audios = (value.$reified as List)
            .map((e) => Track(file: e.file, label: e.label))
            .toList();

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String get url => $value.url;

  @override
  List<Track>? get subtitles => $value.subtitles;

  @override
  List<Track>? get audios => $value.audios;

  @override
  String get quality => $value.quality;

  @override
  Map<String, String>? get headers => $value.headers;

  @override
  String get originalUrl => $value.originalUrl;

  @override
  set url(String? url) {}

  @override
  set quality(String? quality) {}

  @override
  set headers(Map? headers) {}

  @override
  set originalUrl(String? originalUrl) {}

  @override
  set subtitles(List? subtitles) {}

  @override
  set audios(List? audios) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
