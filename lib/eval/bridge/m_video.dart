import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/model/m_track.dart';
import 'package:mangayomi/eval/model/m_video.dart';
import 'package:mangayomi/eval/bridge/m_track.dart';

class $MVideo implements MVideo, $Instance {
  $MVideo.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:bridge_lib/bridge_lib.dart', 'MVideo'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
        ))
      },
      // Specify class fields
      fields: {
        'url': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'quality': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'originalUrl': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'headers': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.mapType, [
          BridgeTypeRef.type(RuntimeTypes.stringType),
          BridgeTypeRef.type(RuntimeTypes.stringType)
        ]))),
        'subtitles': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [$MTrack.$type]))),
        'audios': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [$MTrack.$type]))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $MVideo.wrap(MVideo());
  }

  @override
  final MVideo $value;

  @override
  MVideo get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'url':
        return $String($value.url!);
      case 'quality':
        return $String($value.quality!);
      case 'originalUrl':
        return $String($value.originalUrl!);
      case 'headers':
        return $Map.wrap($value.headers!);
      case 'subtitles':
        return $List.wrap($value.subtitles!
            .map((e) =>
                $MTrack.wrap(MTrack(file: e.file, label: e.label)))
            .toList());
      case 'audios':
        return $List.wrap($value.audios!
            .map((e) =>
                $MTrack.wrap(MTrack(file: e.file, label: e.label)))
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
        $value.headers = (value.$reified as Map).isNotEmpty
            ? (value.$reified as Map)
                .map((key, value) => MapEntry(key.toString(), value.toString()))
            : {};
      case 'subtitles':
        $value.subtitles = (value.$reified as List).isNotEmpty
            ? (value.$reified as List)
                .map((e) => MTrack()
                  ..file = e.file
                  ..label = e.label)
                .toList()
            : [];
      case 'audios':
        $value.audios = (value.$reified as List).isNotEmpty
            ? (value.$reified as List)
                .map((e) => MTrack()
                  ..file = e.file
                  ..label = e.label)
                .toList()
            : [];

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get url => $value.url;

  @override
  List<MTrack>? get subtitles => $value.subtitles;

  @override
  List<MTrack>? get audios => $value.audios;

  @override
  String? get quality => $value.quality;

  @override
  Map<String, String>? get headers => $value.headers;

  @override
  String? get originalUrl => $value.originalUrl;

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
}
