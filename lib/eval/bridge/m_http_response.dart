import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/model/m_http_response.dart';

class $MHttpResponse implements MHttpResponse, $Instance {
  $MHttpResponse.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:bridge_lib/bridge_lib.dart', 'MHttpResponse'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
        ))
      },
      // Specify class fields
      fields: {
        'body': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.stringType))),
        'statusCode': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.intType))),
        'hasError': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef.type(RuntimeTypes.boolType))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $MHttpResponse.wrap(MHttpResponse());
  }

  @override
  final MHttpResponse $value;

  @override
  MHttpResponse get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'body':
        return $String($value.body!);
      case 'statusCode':
        return $int($value.statusCode!);
      case 'hasError':
        return $bool($value.hasError!);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'body':
        $value.body = value.$reified;
      case 'statusCode':
        $value.statusCode = value.$reified;
      case 'hasError':
        $value.hasError = value.$reified;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get body => $value.body;

  @override
  int? get statusCode => $value.statusCode;
  @override
  bool? get hasError => $value.hasError;

  @override
  set body(String? body) {}

  @override
  set statusCode(int? statusCode) {}

  @override
  set hasError(bool? hasError) {}
}
