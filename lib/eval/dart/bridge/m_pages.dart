import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/dart/bridge/m_manga.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';

class $MPages implements MPages, $Instance {
  $MPages.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'MPages'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter(
              'list',
              BridgeTypeAnnotation(
                  BridgeTypeRef(CoreTypes.list, [$MManga.$type])),
              false),
          BridgeParameter(
              'hasNextPage',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool),
                  nullable: true),
              true),
        ]))
      },
      fields: {
        'list': BridgeFieldDef(
          BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list, [$MManga.$type])),
        ),
        'hasNextPage': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.bool),
            nullable: true)),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    List<$Value> list = args[0]!.$value;
    return $MPages.wrap(MPages(
        list: list.map((e) => e as MManga).toList(),
        hasNextPage: args[1]?.$value ?? false));
  }

  @override
  final MPages $value;

  @override
  MPages get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'list':
        return $List.wrap($value.list);
      case 'hasNextPage':
        return $bool($value.hasNextPage);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }

  @override
  List<MManga> get list => $value.list;

  @override
  bool get hasNextPage => $value.hasNextPage;

  @override
  set hasNextPage(bool hasNextPage) {}

  @override
  set list(List<MManga> list) {}

  @override
  Map<String, dynamic> toJson() => {
        'list': list.map((v) => v.toJson()).toList(),
        'hasNextPage': hasNextPage,
      };
}
