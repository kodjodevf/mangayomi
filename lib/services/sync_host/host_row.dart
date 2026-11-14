import 'package:isar_community/isar.dart';

part 'host_row.g.dart';

/// One synced row as the host keeps it: the wire form a device uploaded,
/// with what the host needs to page through changes and resolve duplicates.
///
/// The host keeps its own database, apart from this device's library: the
/// host device syncs with it like any other device does.
@collection
@Name('SyncHostRow')
class HostRow {
  Id id = Isar.autoIncrement;

  /// The wire entity, such as `manga` or `chapters`; also `settings`, and
  /// the `alias:` entries a duplicate clientId resolves through.
  @Index(composite: [CompositeIndex('clientId')], unique: true)
  @Index(composite: [CompositeIndex('receivedAt')])
  @Index(composite: [CompositeIndex('naturalKey')])
  @Index(composite: [CompositeIndex('parentClientId')])
  late String entity;

  late int clientId;

  /// When the host stored this version, on its own clock, never twice the
  /// same value: what devices page through, in place of the uploading
  /// device's clock, so an edit made offline still reaches the others.
  @Index()
  late int receivedAt;

  /// The uploading device's clock: decides which of two versions wins.
  late int updatedAt;

  bool deleted = false;

  /// What makes two rows the same title or chapter whatever their
  /// clientIds: two devices may each have added it before ever syncing.
  String? naturalKey;

  /// The manga a chapter, track, history or update belongs to, so deleting
  /// the manga deletes them too.
  int? parentClientId;

  /// The row as JSON, absent once deleted. For an alias, the clientId it
  /// stands for is in [parentClientId].
  String? data;
}
