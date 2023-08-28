import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';

class $TrackModel implements TrackModel, $Instance {
  $TrackModel.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:bridge_lib/bridge_lib.dart', 'TrackModel'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation($type),
            params: [],
            namedParams: [
              BridgeParameter(
                  'file',
                  BridgeTypeAnnotation(
                      BridgeTypeRef.type(RuntimeTypes.stringType)),
                  false),
              BridgeParameter(
                  'label',
                  BridgeTypeAnnotation(
                      BridgeTypeRef.type(RuntimeTypes.stringType)),
                  false),
            ]))
      },
      // Specify class fields
      fields: {
        'file': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'label': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $TrackModel.wrap(TrackModel());
  }

  @override
  final TrackModel $value;

  @override
  TrackModel get $reified => $value;

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
}
