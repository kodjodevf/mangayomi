import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class CustomButtonRepository {
  List<CustomButton> getAllSortedByPos() =>
      isar.customButtons.where().sortByPos().findAllSync();

  Stream<List<CustomButton>> watchAllSortedByPos() => isar.customButtons
      .filter()
      .idIsNotNull()
      .sortByPos()
      .watch(fireImmediately: true);

  List<CustomButton> getAll() =>
      isar.customButtons.filter().idIsNotNull().findAllSync();

  Future<CustomButton?> findFirst() =>
      isar.customButtons.filter().idIsNotNull().findFirst();

  Future<int> count() => isar.customButtons.count();

  Future<CustomButton?> findById(int? id) =>
      isar.customButtons.filter().idEqualTo(id).findFirst();

  // Stamps updatedAt for callers that just want to persist a mutated
  // CustomButton they already hold, without setting the timestamp themselves.
  Future<void> save(CustomButton button) => dbWriteQueue.run(() {
    button.updatedAt = DateTime.now().millisecondsSinceEpoch;
    return isar.writeTxn(() => isar.customButtons.put(button));
  });

  Future<void> putAll(List<CustomButton> buttons) => dbWriteQueue.run(
    () => isar.writeTxn(() => isar.customButtons.putAll(buttons)),
  );

  Future<void> delete(int id) => dbWriteQueue.run(
    () => isar.writeTxn(() => isar.customButtons.delete(id)),
  );

  // Sync primitives below are for callers already inside a write transaction
  // opened by another repository's transaction()/writeTransaction() (e.g.
  // restoreRepository) — they don't queue on their own.
  void putAllSync(List<CustomButton> buttons) =>
      isar.customButtons.putAllSync(buttons);

  void clearSync() => isar.customButtons.clearSync();
}

final customButtonRepository = CustomButtonRepository();
