/// One synced row as a host or server keeps it: the wire form a device
/// uploaded, with what is needed to page through changes and resolve
/// duplicates.
class StoredRow {
  StoredRow({
    required this.entity,
    required this.clientId,
    required this.receivedAt,
    required this.updatedAt,
    this.deleted = false,
    this.naturalKey,
    this.parentClientId,
    this.data,
  });

  /// The wire entity, such as `manga` or `chapters`; also the engine's own
  /// bookkeeping entities.
  final String entity;
  final int clientId;

  /// When the store took this version, on the host's clock, never twice the
  /// same value: what devices page through.
  int receivedAt;

  /// The uploading device's clock: decides which of two versions wins.
  int updatedAt;
  bool deleted;

  /// What makes two rows the same title or chapter whatever their clientIds.
  String? naturalKey;

  /// The manga a chapter, track, history or update belongs to; for an alias,
  /// the clientId it stands for.
  int? parentClientId;

  /// The row as JSON, absent once deleted.
  String? data;

  StoredRow copy() => StoredRow(
    entity: entity,
    clientId: clientId,
    receivedAt: receivedAt,
    updatedAt: updatedAt,
    deleted: deleted,
    naturalKey: naturalKey,
    parentClientId: parentClientId,
    data: data,
  );
}

/// Where the engine keeps rows. Synchronous, so one sync request applies in
/// one transaction. Rows are unique by (entity, clientId).
///
/// Only rows of the synced entities are ever deleted, so a query for
/// deleted rows of any entity finds tombstones only.
abstract interface class SyncStore {
  /// Runs [body] atomically: when it throws, nothing it wrote is kept.
  T transaction<T>(T Function() body);

  StoredRow? get(String entity, int clientId);

  /// Inserts [row], or replaces the row with its entity and clientId.
  void put(StoredRow row);

  /// A row of [entity] that is not deleted and has [naturalKey], if any.
  StoredRow? liveByNaturalKey(String entity, String naturalKey);

  /// The rows of [entity] that are not deleted and belong to [parent].
  List<StoredRow> liveChildren(String entity, int parent);

  /// Rows of [entity], or of any entity when null, deleted or not as
  /// [deleted] says, stored after [after]: oldest first, at most [limit].
  List<StoredRow> changes({
    String? entity,
    required bool deleted,
    required int after,
    required int limit,
  });

  /// How many rows [changes] would list without a limit.
  int countChanges({String? entity, required bool deleted, required int after});
}
