import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

// The sync engine's local outbox: one row per pending change to push on the
// next sync. [writeTxn] on the write methods below mirrors the original
// call sites - false means the caller already has a write transaction open
// (e.g. inside another repository's queued transaction) and this must NOT
// open or queue one of its own, since Isar only allows one at a time.
class ChangedPartRepository {
  List<ChangedPart> getAll() =>
      isar.changedParts.filter().idIsNotNull().findAllSync();

  List<ChangedPart> getByActions(List<ActionType> actionTypes) {
    var query = isar.changedParts
        .filter()
        .idIsNotNull()
        .and()
        .actionTypeEqualTo(actionTypes.first);
    for (final at in actionTypes.skip(1)) {
      query = query.or().actionTypeEqualTo(at);
    }
    return query.findAllSync();
  }

  void add(
    ActionType action,
    int? isarId,
    Object data,
    bool writeTxn, {
    int? clientId,
  }) {
    final changedPart = isar.changedParts
        .filter()
        .actionTypeEqualTo(action)
        .isarIdEqualTo(isarId)
        .findFirstSync();
    void putChangedPart() {
      if (changedPart != null) {
        isar.changedParts.putSync(
          changedPart
            ..clientId = clientId ?? changedPart.clientId
            ..data = jsonEncode(data)
            ..clientDate = DateTime.now().millisecondsSinceEpoch,
        );
      } else {
        isar.changedParts.putSync(
          ChangedPart(
            actionType: action,
            isarId: isarId,
            clientId: clientId,
            data: jsonEncode(data),
            clientDate: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
    }

    if (writeTxn) {
      dbWriteQueue.run(() => isar.writeTxnSync(putChangedPart));
    } else {
      putChangedPart();
    }
  }

  Future<void> addAsync(
    ActionType action,
    int? isarId,
    Object data,
    bool writeTxn, {
    int? clientId,
  }) async {
    final changedPart = isar.changedParts
        .filter()
        .actionTypeEqualTo(action)
        .isarIdEqualTo(isarId)
        .findFirstSync();
    Future<void> putChangedPart() async {
      if (changedPart != null) {
        await isar.changedParts.put(
          changedPart
            ..clientId = clientId ?? changedPart.clientId
            ..data = jsonEncode(data)
            ..clientDate = DateTime.now().millisecondsSinceEpoch,
        );
      } else {
        await isar.changedParts.put(
          ChangedPart(
            actionType: action,
            isarId: isarId,
            clientId: clientId,
            data: jsonEncode(data),
            clientDate: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
    }

    if (writeTxn) {
      await dbWriteQueue.run(() => isar.writeTxn(putChangedPart));
    } else {
      await putChangedPart();
    }
  }

  Future<void> clear(List<ActionType> actions, bool txn) async {
    var temp = isar.changedParts.filter().actionTypeEqualTo(actions.first);
    for (ActionType action in actions.skip(1)) {
      temp = temp.or().actionTypeEqualTo(action);
    }
    final ids = await temp.idProperty().findAll();
    if (txn) {
      await dbWriteQueue.run(
        () => isar.writeTxn(() => isar.changedParts.deleteAll(ids)),
      );
    } else {
      await isar.changedParts.deleteAll(ids);
    }
  }

  void clearAll(bool txn) {
    if (txn) {
      dbWriteQueue.run(
        () => isar.writeTxnSync(() => isar.changedParts.clearSync()),
      );
    } else {
      isar.changedParts.clearSync();
    }
  }
}

final changedPartRepository = ChangedPartRepository();
