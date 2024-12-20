import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/model/filter.dart';

class $FilterList implements FilterList, $Instance {
  $FilterList.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'FilterList'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter(
              'filters',
              BridgeTypeAnnotation(BridgeTypeRef(
                  CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
              false),
        ]))
      },
      fields: {
        'filters': BridgeFieldDef(
          BridgeTypeAnnotation(BridgeTypeRef(
              CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
        ),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $FilterList.wrap(args[0]!.$value);
  }

  @override
  final FilterList $value;

  @override
  FilterList get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'filters':
        return $List.wrap($value.filters);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'filters':
        $value.filters = (value.$reified as List)
            .map((e) => e is $Value ? e.$reified : e)
            .toList();
      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  List<dynamic> get filters => $value.filters;

  @override
  set filters(List<dynamic> filters) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $SelectFilter implements SelectFilter, $Instance {
  $SelectFilter.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'SelectFilter'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter('type',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter('name',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter('state',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), false),
          BridgeParameter(
              'values',
              BridgeTypeAnnotation(BridgeTypeRef(
                  CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
              false),
        ]))
      },
      fields: {
        'type': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'state': BridgeFieldDef(BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.int),
        )),
        'values': BridgeFieldDef(
          BridgeTypeAnnotation(BridgeTypeRef(
              CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
        ),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $SelectFilter.wrap(SelectFilter(
        args[0]!.$value,
        args[1]!.$value,
        args[2]!.$value,
        (args[3]!.$value as List).map((e) {
          if (e is $Value) {
            final value = e.$reified;
            if (value is Map) {
              Map<String, dynamic> map = {};
              map = value.map((key, value) => MapEntry(key.toString(), value));
              if (map['type'] == 'SelectOption') {
                final filter = map['filter'] as Map;
                return SelectFilterOption.fromJson(filter
                    .map((key, value) => MapEntry(key.toString(), value)));
              }
            }
            return value;
          }
          return e;
        }).toList(),
        null));
  }

  @override
  final SelectFilter $value;

  @override
  SelectFilter get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'name':
        return $String($value.name);
      case 'type':
        return $String($value.type ?? '');
      case 'state':
        return $int($value.state);
      case 'values':
        return $List.wrap($value.values);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'type':
        $value.type = value.$reified;
      case 'name':
        $value.name = value.$reified;
      case 'state':
        $value.state = value.$reified;
      case 'values':
        $value.values = value.$reified;
      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get type => $value.type ?? '';

  @override
  String get name => $value.name;

  @override
  int get state => $value.state;

  @override
  String? get typeName => $value.typeName;

  @override
  set typeName(String? typeName) {}

  @override
  List<dynamic> get values => $value.values;

  @override
  set name(String name) {}

  @override
  set type(String? type) {}

  @override
  set state(int state) {}

  @override
  set values(List<dynamic> values) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $SelectFilterOption implements SelectFilterOption, $Instance {
  $SelectFilterOption.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(BridgeTypeSpec(
      'package:mangayomi/bridge_lib.dart', 'SelectFilterOption'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter('name',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter('value',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
        ]))
      },
      fields: {
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'value': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $SelectFilterOption
        .wrap(SelectFilterOption(args[0]!.$value, args[1]!.$value, null));
  }

  @override
  final SelectFilterOption $value;

  @override
  SelectFilterOption get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'name':
        return $String($value.name);
      case 'value':
        return $String($value.value);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'value':
        $value.value = value.$reified;
      case 'name':
        $value.name = value.$reified;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String get value => $value.value;

  @override
  String get name => $value.name;

  @override
  String? get typeName => $value.typeName;

  @override
  set typeName(String? typeName) {}

  @override
  set name(String name) {}

  @override
  set value(String value) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $SeparatorFilter implements SeparatorFilter, $Instance {
  $SeparatorFilter.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'SeparatorFilter'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter('type',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), true),
        ]))
      },
      fields: {
        'type': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $SeparatorFilter
        .wrap(SeparatorFilter(null, type: args[0]?.$value ?? ''));
  }

  @override
  final SeparatorFilter $value;

  @override
  SeparatorFilter get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'type':
        return $String($value.type ?? '');
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'type':
        $value.type = value.$reified;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get type => $value.type ?? '';

  @override
  String? get typeName => $value.typeName;

  @override
  set typeName(String? typeName) {}

  @override
  set type(String? type) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $HeaderFilter implements HeaderFilter, $Instance {
  $HeaderFilter.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'HeaderFilter'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter('name',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter('type',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), true),
        ]))
      },
      fields: {
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'type': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $HeaderFilter
        .wrap(HeaderFilter(args[0]!.$value, null, type: args[1]?.$value ?? ''));
  }

  @override
  final HeaderFilter $value;

  @override
  HeaderFilter get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'type':
        return $String($value.type ?? '');
      case 'name':
        return $String($value.name);

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
      case 'type':
        $value.type = value.$reified;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String get name => $value.name;

  @override
  set name(String name) {}

  @override
  set type(String? type) {}

  @override
  String? get type => $value.type ?? '';

  @override
  String? get typeName => $value.typeName;

  @override
  set typeName(String? typeName) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $TextFilter implements TextFilter, $Instance {
  $TextFilter.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'TextFilter'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter('type',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter('name',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
        ]))
      },
      fields: {
        'type': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $TextFilter.wrap(TextFilter(args[0]!.$value, args[1]!.$value, null));
  }

  @override
  final TextFilter $value;

  @override
  TextFilter get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'type':
        return $String($value.type ?? '');
      case 'name':
        return $String($value.name);
      case 'state':
        return $String($value.state);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'type':
        $value.type = value.$reified;
      case 'name':
        $value.name = value.$reified;
      case 'state':
        $value.state = value.$reified;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get type => $value.type ?? '';
  @override
  String get name => $value.name;

  @override
  String get state => $value.state;

  @override
  String? get typeName => $value.typeName;

  @override
  set typeName(String? typeName) {}

  @override
  set type(String? type) {}

  @override
  set name(String name) {}

  @override
  set state(String state) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $SortFilter implements SortFilter, $Instance {
  $SortFilter.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'SortFilter'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter('type',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter('name',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter(
              'state', BridgeTypeAnnotation($SortState.$type), false),
          BridgeParameter(
              'values',
              BridgeTypeAnnotation(BridgeTypeRef(
                  CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
              false),
        ]))
      },
      fields: {
        'type': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'state': BridgeFieldDef(BridgeTypeAnnotation($SortState.$type)),
        'values': BridgeFieldDef(
          BridgeTypeAnnotation(BridgeTypeRef(
              CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
        ),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $SortFilter.wrap(SortFilter(
        args[0]!.$value,
        args[1]!.$value,
        args[2]!.$value,
        (args[3]!.$value as List)
            .map((e) =>
                SelectFilterOption(e.$reified.name, e.$reified.value, null))
            .toList(),
        null));
  }

  @override
  final SortFilter $value;

  @override
  SortFilter get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'type':
        return $String($value.type ?? '');
      case 'name':
        return $String($value.name);
      case 'state':
        return $SortState.wrap($value.state);
      case 'values':
        return $List.wrap($value.values);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'type':
        $value.type = value.$reified;
      case 'name':
        $value.name = value.$reified;
      case 'state':
        $value.state = value.$reified;
      case 'values':
        $value.values = value.$reified;
      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get type => $value.type ?? '';

  @override
  String get name => $value.name;

  @override
  SortState get state => $value.state;

  @override
  List<dynamic> get values => $value.values;

  @override
  String? get typeName => $value.typeName;

  @override
  set typeName(String? typeName) {}

  @override
  set type(String? type) {}

  @override
  set name(String name) {}

  @override
  set state(SortState state) {}

  @override
  set values(List<dynamic> values) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $SortState implements SortState, $Instance {
  $SortState.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'SortState'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter('index',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), false),
          BridgeParameter('ascending',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)), false),
        ]))
      },
      fields: {
        'index': BridgeFieldDef(BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.int),
        )),
        'ascending': BridgeFieldDef(BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.bool),
        )),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $SortState.wrap(SortState(args[0]!.$value, args[1]!.$value, null));
  }

  @override
  final SortState $value;

  @override
  SortState get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'index':
        return $int($value.index);
      case 'ascending':
        return $bool($value.ascending);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'index':
        $value.index = value.$reified;
      case 'ascending':
        $value.ascending = value.$reified;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  int get index => $value.index;

  @override
  bool get ascending => $value.ascending;

  @override
  String? get typeName => $value.typeName;

  @override
  set typeName(String? typeName) {}

  @override
  set ascending(bool ascending) {}

  @override
  set index(int index) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $TriStateFilter implements TriStateFilter, $Instance {
  $TriStateFilter.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'TriStateFilter'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter('name',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter('value',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter('type',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), true),
        ], namedParams: [
          BridgeParameter(
              'state', BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), true)
        ]))
      },
      fields: {
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'value': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'type': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'state': BridgeFieldDef(BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.int),
        )),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $TriStateFilter.wrap(TriStateFilter(
        args[2]?.$value ?? '', args[0]!.$value, args[1]!.$value, null,
        state: args[3]?.$value ?? 0));
  }

  @override
  final TriStateFilter $value;

  @override
  TriStateFilter get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'type':
        return $String($value.type ?? '');
      case 'name':
        return $String($value.name);
      case 'state':
        return $int($value.state);
      case 'value':
        return $String($value.value);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'type':
        $value.type = value.$reified;
      case 'name':
        $value.name = value.$reified;
      case 'state':
        $value.state = value.$reified;
      case 'value':
        $value.value = value.$reified;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get type => $value.type ?? '';

  @override
  String get name => $value.name;

  @override
  set name(String name) {}

  @override
  int get state => $value.state;

  @override
  String get value => $value.value;

  @override
  String? get typeName => $value.typeName;

  @override
  set typeName(String? typeName) {}

  @override
  set state(int state) {}

  @override
  set type(String? type) {}

  @override
  set value(String value) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $GroupFilter implements GroupFilter, $Instance {
  $GroupFilter.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'GroupFilter'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter('type',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter('name',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter(
              'state',
              BridgeTypeAnnotation(BridgeTypeRef(
                  CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
              false),
        ]))
      },
      fields: {
        'type': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'state': BridgeFieldDef(
          BridgeTypeAnnotation(BridgeTypeRef(
              CoreTypes.list, [BridgeTypeRef(CoreTypes.dynamic)])),
        ),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $GroupFilter.wrap(GroupFilter(
        args[0]!.$value,
        args[1]!.$value,
        (args[2]!.$value as List).map((e) {
          if (e is $Value) {
            final value = e.$reified;
            if (value is Map) {
              Map<String, dynamic> map = {};
              map = value.map((key, value) => MapEntry(key.toString(), value));
              if (map['type'] == 'TriState') {
                final filter = map['filter'] as Map;
                return TriStateFilter.fromJson(filter
                    .map((key, value) => MapEntry(key.toString(), value)));
              } else if (map['type'] == 'CheckBox') {
                final filter = map['filter'] as Map;
                return CheckBoxFilter.fromJson(filter
                    .map((key, value) => MapEntry(key.toString(), value)));
              }
            }
            return value;
          }
          return e;
        }).toList(),
        null));
  }

  @override
  final GroupFilter $value;

  @override
  GroupFilter get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'type':
        return $String($value.type ?? '');
      case 'name':
        return $String($value.name);
      case 'state':
        return $List.wrap($value.state.map((e) => e).toList());

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'type':
        $value.type = value.$reified;
      case 'name':
        $value.name = value.$reified;
      case 'state':
        $value.state = value.$reified;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get type => $value.type ?? '';

  @override
  String get name => $value.name;

  @override
  List<dynamic> get state => $value.state;

  @override
  String? get typeName => $value.typeName;

  @override
  set typeName(String? typeName) {}

  @override
  set type(String? type) {}

  @override
  set name(String name) {}

  @override
  set state(List<dynamic> state) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $CheckBoxFilter implements CheckBoxFilter, $Instance {
  $CheckBoxFilter.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'CheckBoxFilter'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(
            BridgeFunctionDef(returns: BridgeTypeAnnotation($type), params: [
          BridgeParameter('name',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter('value',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
          BridgeParameter('type',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), true),
        ], namedParams: [
          BridgeParameter('state',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)), true),
        ]))
      },
      fields: {
        'name': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'value': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'type': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'state': BridgeFieldDef(BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.bool),
        )),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $CheckBoxFilter.wrap(CheckBoxFilter(
        args[2]?.$value ?? '', args[0]!.$value, args[1]!.$value, null,
        state: args[3]?.$value ?? false));
  }

  @override
  final CheckBoxFilter $value;

  @override
  CheckBoxFilter get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'type':
        return $String($value.type ?? '');
      case 'name':
        return $String($value.name);
      case 'state':
        return $bool($value.state);
      case 'value':
        return $String($value.value);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      case 'type':
        $value.type = value.$reified;
      case 'name':
        $value.name = value.$reified;
      case 'state':
        $value.state = value.$reified;
      case 'value':
        $value.value = value.$reified;

      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  String? get type => $value.type ?? '';

  @override
  String get name => $value.name;

  @override
  set name(String name) {}

  @override
  bool get state => $value.state;

  @override
  String get value => $value.value;

  @override
  String? get typeName => $value.typeName;

  @override
  set typeName(String? typeName) {}

  @override
  set type(String? type) {}

  @override
  set state(bool state) {}

  @override
  set value(String value) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
