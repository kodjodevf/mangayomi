import 'package:d4rt/d4rt.dart';
import 'package:mangayomi/eval/model/filter.dart';

class FilterBridge {
  final filterBridgedClass = BridgedClass(
    nativeType: FilterList,
    name: 'FilterList',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return FilterList(positionalArgs[0] as List);
      },
    },
    methods: {
      'filters': (visitor, target, positionalArgs, namedArgs) =>
          (target as FilterList).filters,
    },
    setters: {
      'filters': (visitor, target, value) =>
          (target as FilterList).filters = value as List,
    },
  );
  final selectFilterBridgedClass = BridgedClass(
    nativeType: SelectFilter,
    name: 'SelectFilter',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return SelectFilter(
          positionalArgs.get<String?>(0),
          positionalArgs.get<String>(1)!,
          positionalArgs.get<int>(2)!,
          positionalArgs.get<List>(3)!,
          positionalArgs.get<String?>(4),
        );
      },
    },
    getters: {
      'type': (visitor, target) => (target as SelectFilter).type,
      'name': (visitor, target) => (target as SelectFilter).name,
      'state': (visitor, target) => (target as SelectFilter).state,
      'values': (visitor, target) => (target as SelectFilter).values,
      'typeName': (visitor, target) => (target as SelectFilter).typeName,
    },
    setters: {
      'state': (visitor, target, value) =>
          (target as SelectFilter).state = value as int,
      'values': (visitor, target, value) =>
          (target as SelectFilter).values = value as List,
      'type': (visitor, target, value) =>
          (target as SelectFilter).type = value as String,
      'name': (visitor, target, value) =>
          (target as SelectFilter).name = value as String,
      'typeName': (visitor, target, value) =>
          (target as SelectFilter).typeName = value as String?,
    },
  );
  final selectFilterOptionBridgedClass = BridgedClass(
    nativeType: SelectFilterOption,
    name: 'SelectFilterOption',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return SelectFilterOption(
          positionalArgs.get<String>(0)!,
          positionalArgs.get<String>(1)!,
          positionalArgs.get<String?>(2),
        );
      },
    },
    getters: {
      'name': (visitor, target) => (target as SelectFilterOption).name,
      'value': (visitor, target) => (target as SelectFilterOption).value,
      'typeName': (visitor, target) => (target as SelectFilterOption).typeName,
    },
    setters: {
      'name': (visitor, target, value) =>
          (target as SelectFilterOption).name = value as String,
      'value': (visitor, target, value) =>
          (target as SelectFilterOption).value = value as String,
      'typeName': (visitor, target, value) =>
          (target as SelectFilterOption).typeName = value as String?,
    },
  );

  final separatorFilterBridgedClass = BridgedClass(
    nativeType: SeparatorFilter,
    name: 'SeparatorFilter',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return SeparatorFilter(
          null,
          type: positionalArgs.get<String?>(0) ?? '',
        );
      },
    },
    getters: {
      'type': (visitor, target) => (target as SeparatorFilter),
      'typeName': (visitor, target) => (target as SeparatorFilter).typeName,
    },
    setters: {
      'type': (visitor, target, value) =>
          (target as SeparatorFilter).type = value as String?,
      'typeName': (visitor, target, value) =>
          (target as SeparatorFilter).typeName = value as String?,
    },
  );

  final headerFilterBridgedClass = BridgedClass(
    nativeType: HeaderFilter,
    name: 'HeaderFilter',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return HeaderFilter(
          positionalArgs.get<String>(0)!,
          null,
          type: positionalArgs.get<String?>(1) ?? '',
        );
      },
    },
    getters: {
      'type': (visitor, target) => (target as HeaderFilter).type,
      'name': (visitor, target) => (target as HeaderFilter).name,
      'typeName': (visitor, target) => (target as HeaderFilter).typeName,
    },
    setters: {
      'type': (visitor, target, value) =>
          (target as HeaderFilter).type = value as String?,
      'name': (visitor, target, value) =>
          (target as HeaderFilter).name = value as String,
      'typeName': (visitor, target, value) =>
          (target as HeaderFilter).typeName = value as String?,
    },
  );

  final textFilterBridgedClass = BridgedClass(
    nativeType: TextFilter,
    name: 'TextFilter',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return TextFilter(
          positionalArgs.get<String>(0),
          positionalArgs.get<String>(1)!,
          positionalArgs.get<String>(2),
          state: namedArgs.get<String?>('state') ?? '',
        );
      },
    },
    getters: {
      'type': (visitor, target) => (target as TextFilter).type,
      'name': (visitor, target) => (target as TextFilter).name,
      'state': (visitor, target) => (target as TextFilter).state,
      'typeName': (visitor, target) => (target as TextFilter).typeName,
    },
    setters: {
      'state': (visitor, target, value) =>
          (target as TextFilter).state = value as String,
      'type': (visitor, target, value) =>
          (target as TextFilter).type = value as String?,
      'name': (visitor, target, value) =>
          (target as TextFilter).name = value as String,
      'typeName': (visitor, target, value) =>
          (target as TextFilter).typeName = value as String?,
    },
  );

  final sortFilterBridgedClass = BridgedClass(
    nativeType: SortFilter,
    name: 'SortFilter',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return SortFilter(
          positionalArgs.get<String>(0),
          positionalArgs.get<String>(1)!,
          positionalArgs.get<SortState>(2)!,
          positionalArgs.get<List>(3)!,
          positionalArgs.get<String?>(4),
        );
      },
    },
    getters: {
      'type': (visitor, target) => (target as SortFilter).type,
      'name': (visitor, target) => (target as SortFilter).name,
      'state': (visitor, target) => (target as SortFilter).state,
      'typeName': (visitor, target) => (target as SortFilter).typeName,
      'values': (visitor, target) => (target as SortFilter).values,
    },
    setters: {
      'type': (visitor, target, value) =>
          (target as SortFilter).type = value as String?,
      'name': (visitor, target, value) =>
          (target as SortFilter).name = value as String,
      'typeName': (visitor, target, value) =>
          (target as SortFilter).typeName = value as String?,
      'values': (visitor, target, value) =>
          (target as SortFilter).values = value as List,
    },
  );
  final sortStateBridgedClass = BridgedClass(
    nativeType: SortState,
    name: 'SortState',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return SortState(
          positionalArgs.get<int>(0)!,
          positionalArgs.get<bool>(1)!,
          positionalArgs.get<String?>(2),
        );
      },
    },
    getters: {
      'index': (visitor, target) => (target as SortState).index,
      'ascending': (visitor, target) => (target as SortState).ascending,
      'typeName': (visitor, target) => (target as SortState).typeName,
    },
    setters: {
      'index': (visitor, target, value) =>
          (target as SortState).index = value as int,
      'ascending': (visitor, target, value) =>
          (target as SortState).ascending = value as bool,
      'typeName': (visitor, target, value) =>
          (target as SortState).typeName = value as String?,
    },
  );

  final triStateFilterBridgedClass = BridgedClass(
    nativeType: TriStateFilter,
    name: 'TriStateFilter',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return TriStateFilter(
          positionalArgs.get<String?>(2),
          positionalArgs.get<String>(0)!,
          positionalArgs.get<String>(1)!,
          positionalArgs.get<String?>(3),
          state: positionalArgs.get<int?>(3) ?? 0,
        );
      },
    },
    getters: {
      'type': (visitor, target) => (target as TriStateFilter).type,
      'name': (visitor, target) => (target as TriStateFilter).name,
      'state': (visitor, target) => (target as TriStateFilter).state,
      'typeName': (visitor, target) => (target as TriStateFilter).typeName,
      'value': (visitor, target) => (target as TriStateFilter).value,
    },
    setters: {
      'state': (visitor, target, value) =>
          (target as TriStateFilter).state = value as int,
      'type': (visitor, target, value) =>
          (target as TriStateFilter).type = value as String?,
      'name': (visitor, target, value) =>
          (target as TriStateFilter).name = value as String,
      'typeName': (visitor, target, value) =>
          (target as TriStateFilter).typeName = value as String?,
    },
  );

  final groupFilterBridgedClass = BridgedClass(
    nativeType: GroupFilter,
    name: 'GroupFilter',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return GroupFilter(
          positionalArgs.get<String?>(0),
          positionalArgs.get<String>(1)!,
          positionalArgs.get<List>(2)!,
          positionalArgs.get<String?>(3),
        );
      },
    },
    getters: {
      'type': (visitor, target) => (target as GroupFilter).type,
      'name': (visitor, target) => (target as GroupFilter).name,
      'state': (visitor, target) => (target as GroupFilter).state,
      'typeName': (visitor, target) => (target as GroupFilter).typeName,
    },
    setters: {
      'type': (visitor, target, value) =>
          (target as GroupFilter).type = value as String?,
      'name': (visitor, target, value) =>
          (target as GroupFilter).name = value as String,
      'typeName': (visitor, target, value) =>
          (target as GroupFilter).typeName = value as String?,
      'state': (visitor, target, value) =>
          (target as GroupFilter).state = value as List,
    },
  );

  final checkBoxFilterBridgedClass = BridgedClass(
    nativeType: CheckBoxFilter,
    name: 'CheckBoxFilter',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return CheckBoxFilter(
          positionalArgs.get<String?>(2) ?? '',
          positionalArgs.get<String>(0)!,
          positionalArgs.get<String>(1)!,
          null,
          state: positionalArgs.get<bool?>(3) ?? false,
        );
      },
    },
    getters: {
      'type': (visitor, target) => (target as CheckBoxFilter).type,
      'name': (visitor, target) => (target as CheckBoxFilter).name,
      'state': (visitor, target) => (target as CheckBoxFilter).state,
      'typeName': (visitor, target) => (target as CheckBoxFilter).typeName,
      'value': (visitor, target) => (target as CheckBoxFilter).value,
    },
    setters: {
      'state': (visitor, target, value) =>
          (target as CheckBoxFilter).state = value as bool,
      'type': (visitor, target, value) =>
          (target as CheckBoxFilter).type = value as String?,
      'name': (visitor, target, value) =>
          (target as CheckBoxFilter).name = value as String,
      'typeName': (visitor, target, value) =>
          (target as CheckBoxFilter).typeName = value as String?,
      'value': (visitor, target, value) =>
          (target as CheckBoxFilter).value = value as String,
    },
  );
  void registerBridgedClasses(D4rt interpreter) {
    interpreter.registerBridgedClass(
      filterBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      selectFilterBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      selectFilterOptionBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      separatorFilterBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      textFilterBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      sortFilterBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      triStateFilterBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      groupFilterBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      checkBoxFilterBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      sortStateBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      headerFilterBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
  }
}
