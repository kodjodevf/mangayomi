import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/get_source_preference.dart';
import 'package:mangayomi/sources/source_test.dart';

void setPreferenceSetting(SourcePreference sourcePreference, Source source) {
  final sourcePref = isar.sourcePreferences
      .filter()
      .sourceIdEqualTo(source.id)
      .keyEqualTo(sourcePreference.key)
      .findFirstSync();
  isar.writeTxnSync(() {
    if (sourcePref != null) {
      isar.sourcePreferences.putSync(sourcePreference);
    } else {
      isar.sourcePreferences.putSync(sourcePreference..sourceId = source.id);
    }
  });
}

getPreferenceValue(String key, int sourceId) {
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
  final source =
      useTestSourceCode ? testSourceModel : isar.sources.getSync(sourceId)!;
  if (sourcePreference == null) {
    sourcePreference = getSourcePreference(source: source)
        .firstWhere((element) => element.key == key, orElse: () => throw ());
    setPreferenceSetting(sourcePreference, source);
  }

  return sourcePreference;
}
