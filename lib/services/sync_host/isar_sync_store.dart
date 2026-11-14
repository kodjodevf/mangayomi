import 'package:isar_community/isar.dart';
import 'package:mangayomi_sync/mangayomi_sync.dart';

import 'host_row.dart';

/// The host's rows in an Isar database of their own, next to the library's.
class IsarSyncStore implements SyncStore {
  IsarSyncStore(this._db);

  final Isar _db;

  IsarCollection<HostRow> get _rows => _db.hostRows;

  @override
  T transaction<T>(T Function() body) => _db.writeTxnSync(body);

  @override
  StoredRow? get(String entity, int clientId) =>
      _toStored(_rows.getByEntityClientIdSync(entity, clientId));

  @override
  void put(StoredRow row) {
    final existing = _rows.getByEntityClientIdSync(row.entity, row.clientId);
    _rows.putSync(
      HostRow()
        ..id = existing?.id ?? Isar.autoIncrement
        ..entity = row.entity
        ..clientId = row.clientId
        ..receivedAt = row.receivedAt
        ..updatedAt = row.updatedAt
        ..deleted = row.deleted
        ..naturalKey = row.naturalKey
        ..parentClientId = row.parentClientId
        ..data = row.data,
    );
  }

  @override
  StoredRow? liveByNaturalKey(String entity, String naturalKey) => _toStored(
    _rows
        .where()
        .entityNaturalKeyEqualTo(entity, naturalKey)
        .filter()
        .deletedEqualTo(false)
        .findFirstSync(),
  );

  @override
  List<StoredRow> liveChildren(String entity, int parent) => [
    for (final row
        in _rows
            .where()
            .entityParentClientIdEqualTo(entity, parent)
            .filter()
            .deletedEqualTo(false)
            .findAllSync())
      _toStored(row)!,
  ];

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> _changes(
    String? entity,
    bool deleted,
    int after,
  ) => entity == null
      ? _rows
            .where()
            .receivedAtGreaterThan(after)
            .filter()
            .deletedEqualTo(deleted)
      : _rows
            .where()
            .entityEqualToReceivedAtGreaterThan(entity, after)
            .filter()
            .deletedEqualTo(deleted);

  @override
  List<StoredRow> changes({
    String? entity,
    required bool deleted,
    required int after,
    required int limit,
  }) => [
    for (final row in _changes(
      entity,
      deleted,
      after,
    ).limit(limit).findAllSync())
      _toStored(row)!,
  ];

  @override
  int countChanges({
    String? entity,
    required bool deleted,
    required int after,
  }) => _changes(entity, deleted, after).countSync();

  static StoredRow? _toStored(HostRow? row) => row == null
      ? null
      : StoredRow(
          entity: row.entity,
          clientId: row.clientId,
          receivedAt: row.receivedAt,
          updatedAt: row.updatedAt,
          deleted: row.deleted,
          naturalKey: row.naturalKey,
          parentClientId: row.parentClientId,
          data: row.data,
        );
}
