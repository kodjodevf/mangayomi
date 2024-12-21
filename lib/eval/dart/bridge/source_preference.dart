import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';

class $CheckBoxPreference implements SourcePreference, $Instance {
  $CheckBoxPreference.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(BridgeTypeSpec(
      'package:mangayomi/bridge_lib.dart', 'CheckBoxPreference'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation($type),
            params: [],
            namedParams: [
              BridgeParameter('key',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('title',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('summary',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('value',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)), false),
            ]))
      },
      fields: {
        'key': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'title': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'summary': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'value':
            BridgeFieldDef(BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $CheckBoxPreference.wrap(SourcePreference(
        key: args[0]!.$value,
        checkBoxPreference: CheckBoxPreference(
            title: args[1]!.$value,
            summary: args[2]!.$value,
            value: args[3]!.$value)));
  }

  @override
  final SourcePreference $value;

  @override
  SourcePreference get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'key':
        return $String($value.key!);
      case 'title':
        return $String($value.checkBoxPreference!.title!);
      case 'summary':
        return $String($value.checkBoxPreference!.summary!);
      case 'value':
        return $bool($value.checkBoxPreference!.value!);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  CheckBoxPreference? get checkBoxPreference => $value.checkBoxPreference;

  @override
  EditTextPreference? get editTextPreference => $value.editTextPreference;

  @override
  ListPreference? get listPreference => $value.listPreference;

  @override
  MultiSelectListPreference? get multiSelectListPreference =>
      $value.multiSelectListPreference;

  @override
  SwitchPreferenceCompat? get switchPreferenceCompat =>
      $value.switchPreferenceCompat;

  @override
  Id? get id => $value.id;

  @override
  String? get key => $value.key;

  @override
  int? get sourceId => $value.sourceId;

  @override
  set checkBoxPreference(CheckBoxPreference? checkBoxPreference) {}

  @override
  set editTextPreference(EditTextPreference? editTextPreference) {}

  @override
  set id(Id? id) {}

  @override
  set key(String? key) {}

  @override
  set listPreference(ListPreference? listPreference) {}

  @override
  set multiSelectListPreference(
      MultiSelectListPreference? multiSelectListPreference) {}

  @override
  set sourceId(int? sourceId) {}

  @override
  set switchPreferenceCompat(SwitchPreferenceCompat? switchPreferenceCompat) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $SwitchPreferenceCompat implements SourcePreference, $Instance {
  $SwitchPreferenceCompat.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(BridgeTypeSpec(
      'package:mangayomi/bridge_lib.dart', 'SwitchPreferenceCompat'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation($type),
            params: [],
            namedParams: [
              BridgeParameter('key',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('title',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('summary',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('value',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool)), false),
            ]))
      },
      fields: {
        'key': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'title': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'summary': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'value':
            BridgeFieldDef(BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $SwitchPreferenceCompat.wrap(SourcePreference(
        key: args[0]!.$value,
        switchPreferenceCompat: SwitchPreferenceCompat(
            title: args[1]!.$value,
            summary: args[2]!.$value,
            value: args[3]!.$value)));
  }

  @override
  final SourcePreference $value;

  @override
  SourcePreference get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'key':
        return $String($value.key!);
      case 'title':
        return $String($value.checkBoxPreference!.title!);
      case 'summary':
        return $String($value.checkBoxPreference!.summary!);
      case 'value':
        return $bool($value.checkBoxPreference!.value!);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  CheckBoxPreference? get checkBoxPreference => $value.checkBoxPreference;

  @override
  EditTextPreference? get editTextPreference => $value.editTextPreference;

  @override
  ListPreference? get listPreference => $value.listPreference;

  @override
  MultiSelectListPreference? get multiSelectListPreference =>
      $value.multiSelectListPreference;

  @override
  SwitchPreferenceCompat? get switchPreferenceCompat =>
      $value.switchPreferenceCompat;

  @override
  Id? get id => $value.id;

  @override
  String? get key => $value.key;

  @override
  int? get sourceId => $value.sourceId;

  @override
  set checkBoxPreference(CheckBoxPreference? checkBoxPreference) {}

  @override
  set editTextPreference(EditTextPreference? editTextPreference) {}

  @override
  set id(Id? id) {}

  @override
  set key(String? key) {}

  @override
  set listPreference(ListPreference? listPreference) {}

  @override
  set multiSelectListPreference(
      MultiSelectListPreference? multiSelectListPreference) {}

  @override
  set sourceId(int? sourceId) {}

  @override
  set switchPreferenceCompat(SwitchPreferenceCompat? switchPreferenceCompat) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $ListPreference implements SourcePreference, $Instance {
  $ListPreference.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:mangayomi/bridge_lib.dart', 'ListPreference'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation($type),
            params: [],
            namedParams: [
              BridgeParameter('key',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('title',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('summary',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('valueIndex',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int)), false),
              BridgeParameter(
                  'entries',
                  BridgeTypeAnnotation(BridgeTypeRef(
                      CoreTypes.list, [BridgeTypeRef(CoreTypes.string)])),
                  false),
              BridgeParameter(
                  'entryValues',
                  BridgeTypeAnnotation(BridgeTypeRef(
                      CoreTypes.list, [BridgeTypeRef(CoreTypes.string)])),
                  false),
            ]))
      },
      fields: {
        'key': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'title': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'summary': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'valueIndex':
            BridgeFieldDef(BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int))),
        'entries': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [BridgeTypeRef(CoreTypes.string)]))),
        'entryValues': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [BridgeTypeRef(CoreTypes.string)]))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $ListPreference.wrap(SourcePreference(
        key: args[0]!.$value,
        listPreference: ListPreference(
            title: args[1]!.$value,
            summary: args[2]!.$value,
            valueIndex: args[3]!.$value,
            entries: (args[4]!.$value as List)
                .map((e) => (e is $Value ? e.$reified : e).toString())
                .toList(),
            entryValues: (args[5]!.$value as List)
                .map((e) => (e is $Value ? e.$reified : e).toString())
                .toList())));
  }

  @override
  final SourcePreference $value;

  @override
  SourcePreference get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'key':
        return $String($value.key!);
      case 'title':
        return $String($value.listPreference!.title!);
      case 'summary':
        return $String($value.listPreference!.summary!);
      case 'valueIndex':
        return $int($value.listPreference!.valueIndex!);
      case 'entries':
        return $List.wrap($value.listPreference!.entries!);
      case 'entryValues':
        return $List.wrap($value.listPreference!.entryValues!);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  CheckBoxPreference? get checkBoxPreference => $value.checkBoxPreference;

  @override
  EditTextPreference? get editTextPreference => $value.editTextPreference;

  @override
  ListPreference? get listPreference => $value.listPreference;

  @override
  MultiSelectListPreference? get multiSelectListPreference =>
      $value.multiSelectListPreference;

  @override
  SwitchPreferenceCompat? get switchPreferenceCompat =>
      $value.switchPreferenceCompat;

  @override
  Id? get id => $value.id;

  @override
  String? get key => $value.key;

  @override
  int? get sourceId => $value.sourceId;

  @override
  set checkBoxPreference(CheckBoxPreference? checkBoxPreference) {}

  @override
  set editTextPreference(EditTextPreference? editTextPreference) {}

  @override
  set id(Id? id) {}

  @override
  set key(String? key) {}

  @override
  set listPreference(ListPreference? listPreference) {}

  @override
  set multiSelectListPreference(
      MultiSelectListPreference? multiSelectListPreference) {}

  @override
  set sourceId(int? sourceId) {}

  @override
  set switchPreferenceCompat(SwitchPreferenceCompat? switchPreferenceCompat) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $MultiSelectListPreference implements SourcePreference, $Instance {
  $MultiSelectListPreference.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(BridgeTypeSpec(
      'package:mangayomi/bridge_lib.dart', 'MultiSelectListPreference'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation($type),
            params: [],
            namedParams: [
              BridgeParameter('key',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('title',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('summary',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter(
                  'entries',
                  BridgeTypeAnnotation(BridgeTypeRef(
                      CoreTypes.list, [BridgeTypeRef(CoreTypes.string)])),
                  false),
              BridgeParameter(
                  'entryValues',
                  BridgeTypeAnnotation(BridgeTypeRef(
                      CoreTypes.list, [BridgeTypeRef(CoreTypes.string)])),
                  false),
              BridgeParameter(
                  'values',
                  BridgeTypeAnnotation(BridgeTypeRef(
                      CoreTypes.list, [BridgeTypeRef(CoreTypes.string)])),
                  false),
            ]))
      },
      fields: {
        'key': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'title': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'summary': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'entries': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [BridgeTypeRef(CoreTypes.string)]))),
        'entryValues': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [BridgeTypeRef(CoreTypes.string)]))),
        'values': BridgeFieldDef(BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [BridgeTypeRef(CoreTypes.string)]))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $MultiSelectListPreference.wrap(SourcePreference(
        key: args[0]!.$value,
        multiSelectListPreference: MultiSelectListPreference(
            title: args[1]!.$value,
            summary: args[2]!.$value,
            entries: (args[3]!.$value as List)
                .map((e) => (e is $Value ? e.$reified : e).toString())
                .toList(),
            entryValues: (args[4]!.$value as List)
                .map((e) => (e is $Value ? e.$reified : e).toString())
                .toList(),
            values: (args[5]!.$value as List)
                .map((e) => (e is $Value ? e.$reified : e).toString())
                .toList())));
  }

  @override
  final SourcePreference $value;

  @override
  SourcePreference get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'key':
        return $String($value.key!);
      case 'title':
        return $String($value.multiSelectListPreference!.title!);
      case 'summary':
        return $String($value.multiSelectListPreference!.summary!);
      case 'entries':
        return $List.wrap($value.multiSelectListPreference!.entries!);
      case 'entryValues':
        return $List.wrap($value.multiSelectListPreference!.entryValues!);
      case 'values':
        return $List.wrap($value.multiSelectListPreference!.values!);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  CheckBoxPreference? get checkBoxPreference => $value.checkBoxPreference;

  @override
  EditTextPreference? get editTextPreference => $value.editTextPreference;

  @override
  ListPreference? get listPreference => $value.listPreference;

  @override
  MultiSelectListPreference? get multiSelectListPreference =>
      $value.multiSelectListPreference;

  @override
  SwitchPreferenceCompat? get switchPreferenceCompat =>
      $value.switchPreferenceCompat;

  @override
  Id? get id => $value.id;

  @override
  String? get key => $value.key;

  @override
  int? get sourceId => $value.sourceId;

  @override
  set checkBoxPreference(CheckBoxPreference? checkBoxPreference) {}

  @override
  set editTextPreference(EditTextPreference? editTextPreference) {}

  @override
  set id(Id? id) {}

  @override
  set key(String? key) {}

  @override
  set listPreference(ListPreference? listPreference) {}

  @override
  set multiSelectListPreference(
      MultiSelectListPreference? multiSelectListPreference) {}

  @override
  set sourceId(int? sourceId) {}

  @override
  set switchPreferenceCompat(SwitchPreferenceCompat? switchPreferenceCompat) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class $EditTextPreference implements SourcePreference, $Instance {
  $EditTextPreference.wrap(this.$value) : _superclass = $Object($value);

  static const $type = BridgeTypeRef(BridgeTypeSpec(
      'package:mangayomi/bridge_lib.dart', 'EditTextPreference'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation($type),
            params: [],
            namedParams: [
              BridgeParameter('key',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('title',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('summary',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('value',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('dialogTitle',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('dialogMessage',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
              BridgeParameter('text',
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string)), false),
            ]))
      },
      fields: {
        'key': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'title': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'summary': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'value': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'dialogTitle': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'dialogMessage': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
        'text': BridgeFieldDef(
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string))),
      },
      wrap: true);

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $EditTextPreference.wrap(SourcePreference(
        key: args[0]!.$value,
        editTextPreference: EditTextPreference(
            title: args[1]!.$value,
            summary: args[2]!.$value,
            value: args[3]!.$value,
            dialogTitle: args[4]!.$value,
            dialogMessage: args[5]!.$value,
            text: args[6]!.$value)));
  }

  @override
  final SourcePreference $value;

  @override
  SourcePreference get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'key':
        return $String($value.key!);
      case 'title':
        return $String($value.editTextPreference!.title!);
      case 'summary':
        return $String($value.editTextPreference!.summary!);
      case 'value':
        return $String($value.editTextPreference!.value!);
      case 'dialogTitle':
        return $String($value.editTextPreference!.dialogTitle!);
      case 'dialogMessage':
        return $String($value.editTextPreference!.dialogMessage!);
      case 'text':
        return $String($value.editTextPreference!.text!);

      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    switch (identifier) {
      default:
        _superclass.$setProperty(runtime, identifier, value);
    }
  }

  @override
  CheckBoxPreference? get checkBoxPreference => $value.checkBoxPreference;

  @override
  EditTextPreference? get editTextPreference => $value.editTextPreference;

  @override
  ListPreference? get listPreference => $value.listPreference;

  @override
  MultiSelectListPreference? get multiSelectListPreference =>
      $value.multiSelectListPreference;

  @override
  SwitchPreferenceCompat? get switchPreferenceCompat =>
      $value.switchPreferenceCompat;

  @override
  Id? get id => $value.id;

  @override
  String? get key => $value.key;

  @override
  int? get sourceId => $value.sourceId;

  @override
  set checkBoxPreference(CheckBoxPreference? checkBoxPreference) {}

  @override
  set editTextPreference(EditTextPreference? editTextPreference) {}

  @override
  set id(Id? id) {}

  @override
  set key(String? key) {}

  @override
  set listPreference(ListPreference? listPreference) {}

  @override
  set multiSelectListPreference(
      MultiSelectListPreference? multiSelectListPreference) {}

  @override
  set sourceId(int? sourceId) {}

  @override
  set switchPreferenceCompat(SwitchPreferenceCompat? switchPreferenceCompat) {}

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
