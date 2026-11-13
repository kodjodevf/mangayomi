import 'store.dart';

/// A [SyncStore] in memory: for tests, and a reference for real stores.
class MemorySyncStore implements SyncStore {
  var _rows = <(String, int), StoredRow>{};

  @override
  T transaction<T>(T Function() body) {
    final saved = {for (final e in _rows.entries) e.key: e.value.copy()};
    try {
      return body();
    } catch (_) {
      _rows = saved;
      rethrow;
    }
  }

  @override
  StoredRow? get(String entity, int clientId) =>
      _rows[(entity, clientId)]?.copy();

  @override
  void put(StoredRow row) => _rows[(row.entity, row.clientId)] = row.copy();

  @override
  StoredRow? liveByNaturalKey(String entity, String naturalKey) {
    for (final row in _rows.values) {
      if (row.entity == entity &&
          !row.deleted &&
          row.naturalKey == naturalKey) {
        return row.copy();
      }
    }
    return null;
  }

  @override
  List<StoredRow> liveChildren(String entity, int parent) => [
    for (final row in _rows.values)
      if (row.entity == entity && !row.deleted && row.parentClientId == parent)
        row.copy(),
  ];

  Iterable<StoredRow> _changes(String? entity, bool deleted, int after) =>
      _rows.values.where(
        (row) =>
            (entity == null || row.entity == entity) &&
            row.deleted == deleted &&
            row.receivedAt > after,
      );

  @override
  List<StoredRow> changes({
    String? entity,
    required bool deleted,
    required int after,
    required int limit,
  }) =>
      (_changes(entity, deleted, after).toList()
            ..sort((a, b) => a.receivedAt.compareTo(b.receivedAt)))
          .take(limit)
          .map((row) => row.copy())
          .toList();

  @override
  int countChanges({
    String? entity,
    required bool deleted,
    required int after,
  }) => _changes(entity, deleted, after).length;
}
