import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/get_source_preference.dart';

void setPreferenceSetting(SourcePreference sourcePreference, Source source) {
  final sourcePref = isar.sourcePreferences
      .filter()
      .sourceIdEqualTo(source.id)
      .keyEqualTo(sourcePreference.key)
      .findFirstSync();
  isar.writeTxnSync(() {
    if (source.sourceCodeLanguage == SourceCodeLanguage.mihon &&
        source.preferenceList != null) {
      final prefs = (jsonDecode(source.preferenceList!) as List)
          .map((e) => SourcePreference.fromJson(e))
          .toList();
      final idx = prefs.indexWhere((e) => e.key == sourcePreference.key);
      if (idx != -1) {
        prefs[idx] = sourcePreference..id = null;
        isar.sources.putSync(
          source
            ..preferenceList = jsonEncode(
              prefs.map((e) => e.toJson()).toList(),
            ),
        );
      }
    }
    if (sourcePref != null) {
      isar.sourcePreferences.putSync(sourcePreference);
    } else {
      isar.sourcePreferences.putSync(sourcePreference..sourceId = source.id);
    }
  });
}

getPreferenceValue(int sourceId, String key) {
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
  SourcePreference? sourcePreference = isar.sourcePreferences
      .filter()
      .sourceIdEqualTo(sourceId)
      .keyEqualTo(key)
      .findFirstSync();
  if (sourcePreference == null) {
    final source = isar.sources.getSync(sourceId)!;
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
  SourcePreferenceStringValue? sourcePreferenceStringValue = isar
      .sourcePreferenceStringValues
      .filter()
      .sourceIdEqualTo(sourceId)
      .keyEqualTo(key)
      .findFirstSync();
  if (sourcePreferenceStringValue == null) {
    setSourcePreferenceStringValue(sourceId, key, defaultValue);
    return defaultValue;
  }

  return sourcePreferenceStringValue.value ?? "";
}

void setSourcePreferenceStringValue(int sourceId, String key, String value) {
  final sourcePref = isar.sourcePreferenceStringValues
      .filter()
      .sourceIdEqualTo(sourceId)
      .keyEqualTo(key)
      .findFirstSync();
  isar.writeTxnSync(() {
    if (sourcePref != null) {
      isar.sourcePreferenceStringValues.putSync(sourcePref..value = value);
    } else {
      isar.sourcePreferenceStringValues.putSync(
        SourcePreferenceStringValue()
          ..key = key
          ..sourceId = sourceId
          ..value = value,
      );
    }
  });
}
