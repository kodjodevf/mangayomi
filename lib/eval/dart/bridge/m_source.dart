import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/model/m_source.dart';

class $MSource implements MSource, $Instance {
  $MSource.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'MSource'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: []))
      },
      fields: {
        'id':
            BridgeFieldDef(BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int))),
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'baseUrl': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'lang': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'isFullData':
            BridgeFieldDef(BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool))),
        'hasCloudflare':
            BridgeFieldDef(BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool))),
        'dateFormat': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'dateFormatLocale': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'apiUrl': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'additionalParams': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $MSource.wrap(MSource());
  }

  @override
  final MSource $value;

  @override
  MSource get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'id':
        return $int($value.id!);
      case 'name':
        return $String($value.name!);
      case 'baseUrl':
        return $String($value.baseUrl!);
      case 'lang':
        return $String($value.lang!);
      case 'isFullData':
        return $bool($value.isFullData!);
      case 'hasCloudflare':
        return $bool($value.hasCloudflare!);
      case 'dateFormat':
        return $String($value.dateFormat!);
      case 'dateFormatLocale':
        return $String($value.dateFormatLocale!);
      case 'apiUrl':
        return $String($value.apiUrl!);
      case 'additionalParams':
        return $String($value.additionalParams!);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'id':
        $value.id = value.$reified;
      case 'name':
        $value.name = value.$reified;
      case 'baseUrl':
        $value.baseUrl = value.$reified;
      case 'lang':
        $value.lang = value.$reified;
      case 'isFullData':
        $value.isFullData = value.$reified;
      case 'hasCloudflare':
        $value.hasCloudflare = value.$reified;
      case 'dateFormat':
        $value.dateFormat = value.$reified;
      case 'dateFormatLocale':
        $value.dateFormatLocale = value.$reified;
      case 'apiUrl':
        $value.apiUrl = value.$reified;
      case 'additionalParams':
        $value.additionalParams = value.$reified;
      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get apiUrl => $value.apiUrl;

  @override
  String? get baseUrl => $value.baseUrl;

  @override
  String? get dateFormat => $value.dateFormat;

  @override
  String? get dateFormatLocale => $value.dateFormatLocale;

  @override
  bool? get hasCloudflare => $value.hasCloudflare;

  @override
  int? get id => $value.id;

  @override
  bool? get isFullData => $value.isFullData;

  @override
  String? get lang => $value.lang;

  @override
  String? get name => $value.name;

  @override
  String? get additionalParams => $value.additionalParams;

  @override
  set apiUrl(String? apiUrl) {}

  @override
  set baseUrl(String? baseUrl) {}

  @override
  set dateFormat(String? dateFormat) {}

  @override
  set dateFormatLocale(String? dateFormatLocale) {}

  @override
  set hasCloudflare(bool? hasCloudflare) {}

  @override
  set id(int? id) {}

  @override
  set isFullData(bool? isFullData) {}

  @override
  set lang(String? lang) {}

  @override
  set name(String? name) {}

  @override
  set additionalParams(String? additionalParams) {}

  @override
  Map<String, dynamic> toJson() => {
        'apiUrl': apiUrl,
        'baseUrl': baseUrl,
        'dateFormat': dateFormat,
        'dateFormatLocale': dateFormatLocale,
        'hasCloudflare': hasCloudflare,
        'id': id,
        'isFullData': isFullData,
        'lang': lang,
        'name': name,
        'additionalParams': additionalParams
      };
}
