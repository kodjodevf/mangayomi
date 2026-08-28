import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class SourceRepository {
  Source? getById(int id) => isar.sources.getSync(id);

  List<Source> getAll() => isar.sources.filter().idIsNotNull().findAllSync();

  Future<Source?> findByIdAsync(int id) => isar.sources.get(id);

  List<Source> getAllOrInstalled({bool installedOnly = false}) {
    var sourcesFilter = isar.sources.filter().idIsNotNull();
    if (installedOnly) {
      sourcesFilter = sourcesFilter.isActiveEqualTo(true).isAddedEqualTo(true);
    }
    return sourcesFilter.findAllSync();
  }

  Future<List<Source>> getNonLocalByItemType(ItemType itemType) => isar.sources
      .filter()
      .idIsNotNull()
      .itemTypeEqualTo(itemType)
      .and()
      .isLocalEqualTo(false)
      .findAll();

  Source? findByNameAndLang(String? name, String? lang) =>
      isar.sources.filter().nameEqualTo(name).langEqualTo(lang).findFirstSync();

  List<Source> getInstalledByItemType(ItemType itemType) => isar.sources
      .filter()
      .isAddedEqualTo(true)
      .itemTypeEqualTo(itemType)
      .findAllSync();

  // Use composite index (itemType, isAdded) via where() for an index scan,
  // then narrow to isActive=true with a secondary filter on the small result set.
  Stream<List<Source>> watchAddedAndActiveByItemType(ItemType itemType) => isar
      .sources
      .where()
      .itemTypeIsAddedEqualTo(itemType, true)
      .filter()
      .isActiveEqualTo(true)
      .watch(fireImmediately: true);

  Stream<List<Source>> watchWithCodeByItemType(ItemType itemType) => isar
      .sources
      .filter()
      .sourceCodeIsNotEmpty()
      .and()
      .itemTypeEqualTo(itemType)
      .watch(fireImmediately: true);

  bool isNotEmptyActiveByItemTypeLangName(
    ItemType itemType,
    String lang,
    String name,
  ) => isar.sources
      .where()
      .itemTypeIsAddedEqualTo(itemType, true)
      .filter()
      .langContains(lang, caseSensitive: false)
      .and()
      .nameContains(name, caseSensitive: false)
      .and()
      .isActiveEqualTo(true)
      .isNotEmptySync();

  Stream<List<Source>> watchActiveByItemTypeLangName(
    ItemType itemType,
    String lang,
    String name,
  ) => isar.sources
      .where()
      .itemTypeIsAddedEqualTo(itemType, true)
      .filter()
      .langContains(lang, caseSensitive: false)
      .and()
      .nameContains(name, caseSensitive: false)
      .and()
      .isActiveEqualTo(true)
      .watch(fireImmediately: true);

  Stream<List<Source>> watchActiveExcludingHiddenItemTypes({
    required bool hideManga,
    required bool hideAnime,
    required bool hideNovel,
  }) => isar.sources
      .where()
      .isActiveEqualTo(true)
      .filter()
      .optional(hideManga, (q) => q.not().itemTypeEqualTo(ItemType.manga))
      .optional(hideAnime, (q) => q.not().itemTypeEqualTo(ItemType.anime))
      .optional(hideNovel, (q) => q.not().itemTypeEqualTo(ItemType.novel))
      .watch(fireImmediately: true);

  List<Source> getPinnedByItemType(ItemType itemType) => isar.sources
      .filter()
      .isPinnedEqualTo(true)
      .and()
      .itemTypeEqualTo(itemType)
      .findAllSync();

  List<Source> getAddedByItemType(ItemType itemType) =>
      isar.sources.where().itemTypeIsAddedEqualTo(itemType, true).findAllSync();

  List<Id> getOrphanedLocalIds() => isar.sources
      .filter()
      .idIsNotNull()
      .isLocalEqualTo(true)
      .isAddedEqualTo(false)
      .idProperty()
      .findAllSync();

  List<Source> getByItemType(ItemType itemType) =>
      isar.sources.filter().itemTypeEqualTo(itemType).findAllSync();

  Stream<List<Source>> watchByItemType(ItemType itemType) =>
      isar.sources.filter().itemTypeEqualTo(itemType).watch(fireImmediately: true);

  Stream<List<Source>> watchActiveByItemType(ItemType itemType) => isar.sources
      .where()
      .isActiveEqualTo(true)
      .filter()
      .itemTypeEqualTo(itemType)
      .watch(fireImmediately: true);

  // where().isActiveEqualTo() uses the isActive index for an efficient primary
  // scan; itemType and repo-visibility are secondary filters on the smaller set.
  Stream<List<Source>> watchActiveVisibleByItemType(ItemType itemType) => isar
      .sources
      .where()
      .isActiveEqualTo(true)
      .filter()
      .itemTypeEqualTo(itemType)
      .group(
        (q) => q.repoIsNull().or().repo(
          (q) => q.hiddenIsNull().or().hiddenEqualTo(false),
        ),
      )
      .watch(fireImmediately: true);

  // Stamps updatedAt for callers that just want to persist a mutated Source
  // they already hold, without setting the timestamp themselves.
  Future<void> save(Source source) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      source.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.sources.putSync(source);
    });
  });

  Future<void> delete(int id) =>
      dbWriteQueue.run(() => isar.writeTxn(() => isar.sources.delete(id)));

  Future<void> clearAll() =>
      dbWriteQueue.run(() => isar.writeTxnSync(() => isar.sources.clearSync()));

  // Sync primitive below is for callers already inside a write transaction
  // opened by another repository's transaction()/writeTransaction() (e.g.
  // restoreRepository) — it doesn't queue on its own.
  void putAllSync(List<Source> sources) => isar.sources.putAllSync(sources);

  void clearSync() => isar.sources.clearSync();

  // Marks source as the last one tapped into within itemType, so it sorts
  // first next time; every other source of that itemType loses the flag.
  Future<void> markLastUsed(ItemType itemType, int? sourceId) =>
      dbWriteQueue.run(() => isar.writeTxn(() async {
        final sources = await isar.sources
            .filter()
            .idIsNotNull()
            .itemTypeEqualTo(itemType)
            .findAll();
        final updated = sources.map((src) {
          return src
            ..lastUsed = src.id == sourceId
            ..updatedAt = DateTime.now().millisecondsSinceEpoch;
        }).toList();
        await isar.sources.putAll(updated);
      }));

  Future<void> putAll(List<Source> sources) => dbWriteQueue.run(
    () => isar.writeTxnSync(() => isar.sources.putAllSync(sources)),
  );

  Future<void> deleteAll(List<int> ids) =>
      dbWriteQueue.run(() => isar.writeTxn(() => isar.sources.deleteAll(ids)));

  // Obsolete/local sources have nothing to reinstall from, so they're fully
  // deleted; everything else just gets its code/flags cleared so it drops
  // back to "not installed" without losing its browse-list entry. Either way
  // its preferences (both value tables) are wiped, since they're meaningless
  // once the source is gone or has no code to read them.
  Future<void> uninstall(WidgetRef ref, Source source) => dbWriteQueue.run(() {
    final sourcePrefsIds = isar.sourcePreferences
        .filter()
        .sourceIdEqualTo(source.id!)
        .idProperty()
        .findAllSync();
    final sourcePrefsStringIds = isar.sourcePreferenceStringValues
        .filter()
        .sourceIdEqualTo(source.id!)
        .idProperty()
        .findAllSync();
    isar.writeTxnSync(() {
      if ((source.isObsolete ?? false) || (source.isLocal ?? false)) {
        isar.sources.deleteSync(source.id!);
        ref
            .read(synchingProvider(syncId: 1).notifier)
            .addChangedPart(ActionType.removeExtension, source.id, "{}", false);
      } else {
        isar.sources.putSync(
          source
            ..sourceCode = ""
            ..isAdded = false
            ..isPinned = false
            ..updatedAt = DateTime.now().millisecondsSinceEpoch,
        );
      }
      isar.sourcePreferences.deleteAllSync(sourcePrefsIds);
      isar.sourcePreferenceStringValues.deleteAllSync(sourcePrefsStringIds);
    });
  });

  // Escape hatch for source-rooted transactions too specific to name.
  Future<T> transaction<T>(FutureOr<T> Function() body) =>
      dbWriteQueue.run(body);
}

final sourceRepository = SourceRepository();
