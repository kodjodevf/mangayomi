import 'dart:async';

import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/source_preference_repository.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/services/get_source_preference.dart';

import 'package:mangayomi/eval/aidoku/aidoku_ext_dart.dart' as aidoku;

void setPreferenceSetting(SourcePreference sourcePreference, Source source) {
  final sourcePref = sourcePreferenceRepository.findByKey(
    source.id,
    sourcePreference.key,
  );
  unawaited(
    sourcePreferenceRepository
        .save(sourcePreference, source, sourcePref)
        .catchError((_) {}),
  );

  if (source.sourceCodeLanguage == SourceCodeLanguage.aidoku &&
      sourcePreference.key != null) {
    final key = sourcePreference.key!;
    dynamic val;
    if (sourcePreference.listPreference != null) {
      final p = sourcePreference.listPreference!;
      val = (p.entryValues != null &&
              p.valueIndex != null &&
              p.valueIndex! < p.entryValues!.length)
          ? p.entryValues![p.valueIndex!]
          : p.valueIndex;
    } else if (sourcePreference.checkBoxPreference != null) {
      val = sourcePreference.checkBoxPreference!.value;
    } else if (sourcePreference.switchPreferenceCompat != null) {
      val = sourcePreference.switchPreferenceCompat!.value;
    } else if (sourcePreference.multiSelectListPreference != null) {
      val = sourcePreference.multiSelectListPreference!.values;
    } else if (sourcePreference.editTextPreference != null) {
      val = sourcePreference.editTextPreference!.value;
    }
    if (val != null) {
      aidoku.SettingsStore.shared.setValue(key, val);
    }
  }
}

dynamic getPreferenceValue(int sourceId, String key) {
  final sourcePreference = getSourcePreferenceEntry(key, sourceId);

  if (sourcePreference.listPreference != null) {
    final pref = sourcePreference.listPreference!;
    return pref.entryValues![pref.valueIndex!];
  } else if (sourcePreference.checkBoxPreference != null) {
    return sourcePreference.checkBoxPreference!.value;
  } else if (sourcePreference.switchPreferenceCompat != null) {
    return sourcePreference.switchPreferenceCompat!.value;
  } else if (sourcePreference.editTextPreference != null) {
    return sourcePreference.editTextPreference!.value;
  }
  return sourcePreference.multiSelectListPreference!.values;
}

SourcePreference getSourcePreferenceEntry(String key, int sourceId) {
  SourcePreference? sourcePreference = sourcePreferenceRepository.findByKey(
    sourceId,
    key,
  );
  if (sourcePreference == null) {
    final source = sourceRepository.getById(sourceId)!;
    sourcePreference = getSourcePreference(source: source).firstWhere(
      (element) => element.key == key,
      orElse: () => throw "Error when getting source preference",
    );
    setPreferenceSetting(sourcePreference, source);
  }

  return sourcePreference;
}

String getSourcePreferenceStringValue(
  int sourceId,
  String key,
  String defaultValue,
) {
  SourcePreferenceStringValue? sourcePreferenceStringValue =
      sourcePreferenceRepository.findStringValueByKey(sourceId, key);
  if (sourcePreferenceStringValue == null) {
    setSourcePreferenceStringValue(sourceId, key, defaultValue);
    return defaultValue;
  }

  return sourcePreferenceStringValue.value ?? "";
}

void setSourcePreferenceStringValue(int sourceId, String key, String value) {
  final sourcePref = sourcePreferenceRepository.findStringValueByKey(
    sourceId,
    key,
  );
  unawaited(
    sourcePreferenceRepository
        .saveStringValue(sourceId, key, value, sourcePref)
        .catchError((_) {}),
  );
}
