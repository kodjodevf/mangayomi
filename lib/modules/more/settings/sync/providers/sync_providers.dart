import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'sync_providers.g.dart';

@riverpod
class Synching extends _$Synching {
  @override
  SyncPreference build({required int? syncId}) {
    return isar.syncPreferences.getSync(syncId!) ?? SyncPreference(syncId: 1);
  }

  void login(SyncPreference syncPreference) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(syncPreference);
    });
    ref.invalidateSelf();
    ref.invalidate(syncServerProvider(syncId: syncId!));
  }

  void logout() {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(state..authToken = null);
    });
    ref.invalidateSelf();
    ref.invalidate(syncServerProvider(syncId: syncId!));
  }

  void setLastUpload(int timestamp) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(state..lastUpload = timestamp);
    });
  }

  void setLastDownload(int timestamp) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(state..lastDownload = timestamp);
    });
  }

  void setLastSync(int timestamp) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(state..lastSync = timestamp);
    });
  }

  void setServer(String? server) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(state..server = server);
    });
  }

  void setSyncOn(bool value) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(state..syncOn = value);
    });
  }

  void setAutoSyncFrequency(int value) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(state..autoSyncFrequency = value);
    });
    ref.invalidateSelf();
  }

  List<ChangedPart> getAllChangedParts() {
    return isar.changedParts.filter().idIsNotNull().findAllSync();
  }

  List<ChangedPart> getChangedParts(List<ActionType> actionTypes) {
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

  void addChangedPart(
      ActionType action, int? isarId, Object data, bool writeTxn) {
    if (!state.syncOn) {
      return;
    }
    final changedPart = isar.changedParts
        .filter()
        .actionTypeEqualTo(action)
        .isarIdEqualTo(isarId)
        .findFirstSync();
    if (writeTxn) {
      isar.writeTxnSync(() {
        if (changedPart != null) {
          isar.changedParts.putSync(changedPart
            ..data = jsonEncode(data)
            ..clientDate = DateTime.now().millisecondsSinceEpoch);
        } else {
          isar.changedParts.putSync(ChangedPart(
              actionType: action,
              isarId: isarId,
              data: jsonEncode(data),
              clientDate: DateTime.now().millisecondsSinceEpoch));
        }
      });
    } else {
      if (changedPart != null) {
        isar.changedParts.putSync(changedPart
          ..data = jsonEncode(data)
          ..clientDate = DateTime.now().millisecondsSinceEpoch);
      } else {
        isar.changedParts.putSync(ChangedPart(
            actionType: action,
            isarId: isarId,
            data: jsonEncode(data),
            clientDate: DateTime.now().millisecondsSinceEpoch));
      }
    }
  }

  Future<void> addChangedPartAsync(
      ActionType action, int? isarId, Object data, bool writeTxn) async {
    if (!state.syncOn) {
      return;
    }
    final changedPart = isar.changedParts
        .filter()
        .actionTypeEqualTo(action)
        .isarIdEqualTo(isarId)
        .findFirstSync();
    if (writeTxn) {
      await isar.writeTxn(() async {
        if (changedPart != null) {
          await isar.changedParts.put(changedPart
            ..data = jsonEncode(data)
            ..clientDate = DateTime.now().millisecondsSinceEpoch);
        } else {
          await isar.changedParts.put(ChangedPart(
              actionType: action,
              isarId: isarId,
              data: jsonEncode(data),
              clientDate: DateTime.now().millisecondsSinceEpoch));
        }
      });
    } else {
      if (changedPart != null) {
        await isar.changedParts.put(changedPart
          ..data = jsonEncode(data)
          ..clientDate = DateTime.now().millisecondsSinceEpoch);
      } else {
        await isar.changedParts.put(ChangedPart(
            actionType: action,
            isarId: isarId,
            data: jsonEncode(data),
            clientDate: DateTime.now().millisecondsSinceEpoch));
      }
    }
  }

  void clearChangedParts(List<ActionType> actions) {
    var temp = isar.changedParts
        .filter()
        .idIsNotNull()
        .and()
        .actionTypeEqualTo(actions.first);
    for (ActionType action in actions.skip(1)) {
      temp = temp.or().actionTypeEqualTo(action);
    }
    final changedParts = temp.findAllSync().map((cp) => cp.id as Id).toList();
    isar.writeTxnSync(() {
      isar.changedParts.deleteAllSync(changedParts);
    });
  }

  void clearAllChangedParts(bool txn) {
    if (txn) {
      isar.writeTxnSync(() {
        isar.changedParts.clearSync();
      });
    } else {
      isar.changedParts.clearSync();
    }
  }
}
