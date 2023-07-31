import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';

class $VideoModel implements VideoModel, $Instance {
  $VideoModel.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:bridge_lib/bridge_lib.dart', 'VideoModel'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation($type),
            params: [],
            namedParams: [
              BridgeParameter(
                  'url',
                  BridgeTypeAnnotation(
                      BridgeTypeRef.type(RuntimeTypes.stringType)),
                  false),
              BridgeParameter(
                  'quality',
                  BridgeTypeAnnotation(
                      BridgeTypeRef.type(RuntimeTypes.stringType)),
                  false),
              BridgeParameter(
                  'originalUrl',
                  BridgeTypeAnnotation(
                      BridgeTypeRef.type(RuntimeTypes.stringType)),
                  false),
              BridgeParameter(
                  'headers',
                  BridgeTypeAnnotation(
                      BridgeTypeRef.type(RuntimeTypes.mapType)),
                  false),
            ]))
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
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.mapType))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $VideoModel.wrap(VideoModel());
  }

  @override
  final VideoModel $value;

  @override
  VideoModel get $reified => $value;

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
        $value.headers = value.$reified as Map<String, String>;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get url => $value.url;

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
}
