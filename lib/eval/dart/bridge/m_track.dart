import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/models/video.dart';

class $MTrack implements Track, $Instance {
  $MTrack.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'MTrack'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
        ))
      },
      // Specify class fields
      fields: {
        'file': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'label': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $MTrack.wrap(Track());
  }

  @override
  final Track $value;

  @override
  Track get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'file':
        return $String($value.file!);
      case 'label':
        return $String($value.label!);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'file':
        $value.file = value.$reified;
      case 'label':
        $value.label = value.$reified;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get file => $value.file;

  @override
  String? get label => $value.label;

  @override
  set file(String? file) {}

  @override
  set label(String? label) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
