import 'dart:async';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class CategoryRepository {
  Stream<List<Category>> watchAll() =>
      isar.categorys.where().watch(fireImmediately: true);

  List<Category> getAll() =>
      isar.categorys.filter().idIsNotNull().findAllSync();

  // Async twin, for callers already inside an async writeTxn/writeTransactionAsync
  // — Isar rejects a sync findAllSync() call from inside an async transaction.
  Future<List<Category>> getAllAsync() =>
      isar.categorys.filter().idIsNotNull().findAll();

  bool isNotEmptyByItemType(ItemType itemType) => isar.categorys
      .filter()
      .idIsNotNull()
      .and()
      .forItemTypeEqualTo(itemType)
      .isNotEmptySync();

  List<Category> getByItemType(ItemType itemType) =>
      isar.categorys.filter().forItemTypeEqualTo(itemType).findAllSync();

  Stream<List<Category>> watchByItemTypeSimple(ItemType itemType) => isar
      .categorys
      .filter()
      .forItemTypeEqualTo(itemType)
      .watch(fireImmediately: true);

  Stream<List<Category>> watchByItemType(ItemType itemType) => isar.categorys
      .filter()
      .idIsNotNull()
      .and()
      .forItemTypeEqualTo(itemType)
      .watch(fireImmediately: true);

  Future<void> setHidden(Category category, bool hidden) => dbWriteQueue.run(
    () {
      isar.writeTxnSync(() => isar.categorys.putSync(category..hide = hidden));
    },
  );

  // Stamps updatedAt for callers that just want to persist a mutated Category
  // they already hold, without setting the timestamp themselves.
  Future<void> save(Category category) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      category.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.categorys.putSync(category);
    });
  });

  Future<void> putAll(List<Category> categories) => dbWriteQueue.run(
    () => isar.writeTxn(() => isar.categorys.putAll(categories)),
  );

  // Uncategorizes every manga that had this category, then deletes it.
  Future<void> remove(Category category) => dbWriteQueue.run(
    () => isar.writeTxn(() async {
      final items = await isar.mangas
          .filter()
          .categoriesElementEqualTo(category.id!)
          .findAll();
      final updatedItems = items.map((manga) {
        final cats = List<int>.from(manga.categories ?? []);
        cats.remove(category.id!);
        manga.categories = cats;
        return manga;
      }).toList();
      await isar.mangas.putAll(updatedItems);
      await isar.categorys.delete(category.id!);
    }),
  );

  Future<void> create(Category category) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      isar.categorys.putSync(category..pos = category.id);
      final nulls = isar.categorys.filter().posIsNull().findAllSync();
      for (final c in nulls) {
        c.pos = c.id;
      }
      if (nulls.isNotEmpty) {
        isar.categorys.putAllSync(nulls);
      }
    });
  });

  // Sync/async primitives below are for callers already inside a write
  // transaction opened by transaction()/writeTransaction() — they don't
  // queue on their own.
  Future<int> putAsync(Category category) => isar.categorys.put(category);

  Future<bool> deleteAsync(int id) => isar.categorys.delete(id);

  int putSync(Category category) => isar.categorys.putSync(category);

  void putAllSync(List<Category> categories) =>
      isar.categorys.putAllSync(categories);

  void clearSync() => isar.categorys.clearSync();

  // Escape hatch for category-rooted transactions too specific to name.
  Future<T> transaction<T>(FutureOr<T> Function() body) =>
      dbWriteQueue.run(body);

  Future<T> writeTransactionAsync<T>(Future<T> Function() body) =>
      dbWriteQueue.run(() => isar.writeTxn(body));
}

final categoryRepository = CategoryRepository();
