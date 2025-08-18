import 'package:d4rt/d4rt.dart';
import 'package:mangayomi/eval/model/source_preference.dart';

// EditTextPreference
class SourcePreferenceBridge {
  final checkBoxPreferenceBridgedClass = BridgedClass(
    nativeType: CheckBoxPreference,
    name: 'CheckBoxPreference',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return SourcePreference(
          key: namedArgs.get<String?>('key'),
          checkBoxPreference: CheckBoxPreference(
            title: namedArgs.get<String?>('title'),
            summary: namedArgs.get<String?>('summary'),
            value: namedArgs.get<bool?>('value'),
          ),
        );
      },
    },
    getters: {
      'key': (visitor, target) => (target as SourcePreference).key,
      'title': (visitor, target) =>
          (target as SourcePreference).checkBoxPreference?.title,
      'summary': (visitor, target) =>
          (target as SourcePreference).checkBoxPreference?.summary,
      'value': (visitor, target) =>
          (target as SourcePreference).checkBoxPreference?.value,
    },
  );
  final switchPreferenceCompatBridgedClass = BridgedClass(
    nativeType: SwitchPreferenceCompat,
    name: 'SwitchPreferenceCompat',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return SourcePreference(
          key: namedArgs.get<String?>('key'),
          switchPreferenceCompat: SwitchPreferenceCompat(
            title: namedArgs.get<String?>('title'),
            summary: namedArgs.get<String?>('summary'),
            value: namedArgs.get<bool?>('value'),
          ),
        );
      },
    },
    getters: {
      'key': (visitor, target) => (target as SourcePreference).key,
      'title': (visitor, target) =>
          (target as SourcePreference).switchPreferenceCompat?.title,
      'summary': (visitor, target) =>
          (target as SourcePreference).switchPreferenceCompat?.summary,
      'value': (visitor, target) =>
          (target as SourcePreference).switchPreferenceCompat?.value,
    },
  );
  final listPreferenceBridgedClass = BridgedClass(
    nativeType: ListPreference,
    name: 'ListPreference',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return SourcePreference(
          key: namedArgs.get<String?>('key'),
          listPreference: ListPreference(
            title: namedArgs.get<String?>('title'),
            summary: namedArgs.get<String?>('summary'),
            valueIndex: namedArgs.get<int?>('valueIndex'),
            entries: namedArgs.get<List?>('entries')?.cast<String>(),
            entryValues: namedArgs.get<List?>('entryValues')?.cast<String>(),
          ),
        );
      },
    },
    getters: {
      'key': (visitor, target) => (target as SourcePreference).key,
      'title': (visitor, target) =>
          (target as SourcePreference).listPreference?.title,
      'summary': (visitor, target) =>
          (target as SourcePreference).listPreference?.summary,
      'value': (visitor, target) =>
          (target as SourcePreference).listPreference?.valueIndex,
      'entries': (visitor, target) =>
          (target as SourcePreference).listPreference?.entries,
      'entryValues': (visitor, target) =>
          (target as SourcePreference).listPreference?.entryValues,
    },
  );

  final multiSelectListPreferenceBridgedClass = BridgedClass(
    nativeType: MultiSelectListPreference,
    name: 'MultiSelectListPreference',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return SourcePreference(
          key: namedArgs.get<String?>('key'),
          multiSelectListPreference: MultiSelectListPreference(
            title: namedArgs.get<String?>('title'),
            summary: namedArgs.get<String?>('summary'),
            entries: namedArgs.get<List?>('entries')?.cast<String>(),
            entryValues: namedArgs.get<List?>('entryValues')?.cast<String>(),
            values: namedArgs.get<List?>('values')?.cast<String>(),
          ),
        );
      },
    },
    getters: {
      'key': (visitor, target) => (target as SourcePreference).key,
      'title': (visitor, target) =>
          (target as SourcePreference).multiSelectListPreference?.title,
      'summary': (visitor, target) =>
          (target as SourcePreference).multiSelectListPreference?.summary,
      'values': (visitor, target) =>
          (target as SourcePreference).multiSelectListPreference?.values,
      'entries': (visitor, target) =>
          (target as SourcePreference).multiSelectListPreference?.entries,
      'entryValues': (visitor, target) =>
          (target as SourcePreference).multiSelectListPreference?.entryValues,
    },
  );
  final editTextPreferenceBridgedClass = BridgedClass(
    nativeType: EditTextPreference,
    name: 'EditTextPreference',
    constructors: {
      '': (visitor, positionalArgs, namedArgs) {
        return SourcePreference(
          key: namedArgs.get<String?>('key'),
          editTextPreference: EditTextPreference(
            title: namedArgs.get<String?>('title'),
            summary: namedArgs.get<String?>('summary'),
            value: namedArgs.get<String?>('value'),
            dialogTitle: namedArgs.get<String?>('dialogTitle'),
            dialogMessage: namedArgs.get<String?>('dialogMessage'),
            text: namedArgs.get<String?>('text'),
          ),
        );
      },
    },
    getters: {
      'key': (visitor, target) => (target as SourcePreference).key,
      'title': (visitor, target) =>
          (target as SourcePreference).editTextPreference?.title,
      'summary': (visitor, target) =>
          (target as SourcePreference).editTextPreference?.summary,
      'value': (visitor, target) =>
          (target as SourcePreference).editTextPreference?.value,
      'dialogTitle': (visitor, target) =>
          (target as SourcePreference).editTextPreference?.dialogTitle,
      'dialogMessage': (visitor, target) =>
          (target as SourcePreference).editTextPreference?.dialogMessage,
      'text': (visitor, target) =>
          (target as SourcePreference).editTextPreference?.text,
    },
  );

  void registerBridgedClasses(D4rt interpreter) {
    interpreter.registerBridgedClass(
      checkBoxPreferenceBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      switchPreferenceCompatBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      listPreferenceBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      multiSelectListPreferenceBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
    interpreter.registerBridgedClass(
      editTextPreferenceBridgedClass,
      'package:mangayomi/bridge_lib.dart',
    );
  }
}
