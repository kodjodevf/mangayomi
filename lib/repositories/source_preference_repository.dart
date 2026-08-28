import 'dart:async';
import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class SourcePreferenceRepository {
  SourcePreference? findByKey(int? sourceId, String? key) => isar
      .sourcePreferences
      .filter()
      .sourceIdEqualTo(sourceId)
      .keyEqualTo(key)
      .findFirstSync();

  List<SourcePreference> getAll() =>
      isar.sourcePreferences.filter().idIsNotNull().findAllSync();

  SourcePreferenceStringValue? findStringValueByKey(
    int? sourceId,
    String? key,
  ) => isar.sourcePreferenceStringValues
      .filter()
      .sourceIdEqualTo(sourceId)
      .keyEqualTo(key)
      .findFirstSync();

  // Also updates the source's embedded preferenceList (mihon sources keep a
  // JSON copy there) alongside the top-level SourcePreference row.
  Future<void> save(
    SourcePreference sourcePreference,
    Source source,
    SourcePreference? existing,
  ) => dbWriteQueue.run(
    () => isar.writeTxn(() async {
      if (source.sourceCodeLanguage == SourceCodeLanguage.mihon &&
          source.preferenceList != null) {
        final prefs = (jsonDecode(source.preferenceList!) as List)
            .map((e) => SourcePreference.fromJson(e))
            .toList();
        final idx = prefs.indexWhere((e) => e.key == sourcePreference.key);
        if (idx != -1) {
          prefs[idx] = sourcePreference..id = null;
          await isar.sources.put(
            source
              ..preferenceList = jsonEncode(
                prefs.map((e) => e.toJson()).toList(),
              ),
          );
        }
      }
      if (existing != null) {
        await isar.sourcePreferences.put(sourcePreference);
      } else {
        await isar.sourcePreferences.put(
          sourcePreference..sourceId = source.id,
        );
      }
    }),
  );

  Future<void> saveStringValue(
    int sourceId,
    String key,
    String value,
    SourcePreferenceStringValue? existing,
  ) => dbWriteQueue.run(
    () => isar.writeTxn(() async {
      if (existing != null) {
        await isar.sourcePreferenceStringValues.put(existing..value = value);
      } else {
        await isar.sourcePreferenceStringValues.put(
          SourcePreferenceStringValue()
            ..key = key
            ..sourceId = sourceId
            ..value = value,
        );
      }
    }),
  );

  Future<T> transaction<T>(FutureOr<T> Function() body) =>
      dbWriteQueue.run(body);

  // Sync primitives below are for callers already inside a write transaction
  // opened by another repository's transaction()/writeTransaction() (e.g.
  // restoreRepository) — they don't queue on their own.
  void putAllSync(List<SourcePreference> preferences) =>
      isar.sourcePreferences.putAllSync(preferences);

  void clearSync() => isar.sourcePreferences.clearSync();
}

final sourcePreferenceRepository = SourcePreferenceRepository();
