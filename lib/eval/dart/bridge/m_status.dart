import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/models/manga.dart';

class $MStatus implements $Instance {
  static $MStatus $wrap(Runtime runtime, $Value? target, List<$Value?> args) => $MStatus.wrap(args[0]!.$value);
  static const $type = BridgeTypeRef(BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'MStatus'));
  static const $declaration = BridgeEnumDef($type,
      values: ['ongoing', 'completed', 'canceled', 'unknown', 'onHiatus', 'publishingFinished'],
      methods: {},
      getters: {},
      setters: {},
      fields: {});
  static final $values = Status.values.asNameMap().map(
        (key, value) => MapEntry(key, $MStatus.wrap(value)),
      );
  const $MStatus.wrap(this.$value);

  @override
  final Status $value;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'index':
        return $int($value.index);
      case 'name':
        return $String($value.name);
      case 'hashCode':
        return $int($value.hashCode);
    }
    throw UnimplementedError();
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    throw UnimplementedError('Cannot set property on an enum');
  }

  @override
  get $reified => $value;

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);
}
