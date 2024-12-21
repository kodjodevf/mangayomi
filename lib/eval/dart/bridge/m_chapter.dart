import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';

class $MChapter implements MChapter, $Instance {
  $MChapter.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'MChapter'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation($type),
            params: [],
            namedParams: [
              BridgeParameter('name',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('url',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('dateUpload',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('scanlator',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), true),
            ]))
      },
      // Specify class fields
      fields: {
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'url': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'dateUpload': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'scanlator': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $MChapter.wrap(MChapter(
      name: args[0]?.$reified,
      url: args[1]?.$reified,
      dateUpload: args[2]?.$reified,
      scanlator: args[3]?.$reified,
    ));
  }

  @override
  final MChapter $value;

  @override
  MChapter get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'name':
        return $String($value.name!);
      case 'url':
        return $String($value.url!);
      case 'dateUpload':
        return $String($value.dateUpload!);
      case 'scanlator':
        return $String($value.scanlator!);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'name':
        $value.name = value.$reified;
      case 'url':
        $value.url = value.$reified;
      case 'dateUpload':
        $value.dateUpload = value.$reified;
      case 'scanlator':
        $value.scanlator = value.$reified;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get name => $value.name;

  @override
  String? get url => $value.url;

  @override
  String? get dateUpload => $value.dateUpload;

  @override
  String? get scanlator => $value.scanlator;
  @override
  set name(String? name) {}

  @override
  set url(String? url) {}
  @override
  set dateUpload(String? dateUpload) {}

  @override
  set scanlator(String? scanlator) {}

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        'dateUpload': dateUpload,
        'scanlator': scanlator
      };
}
