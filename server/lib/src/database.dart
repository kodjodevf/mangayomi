// The server's one SQLite file: the synced rows, the paired devices, and the
// schema version. WAL, so a backup or a read never waits on a sync.
import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:sqlite3/sqlite3.dart';

class ServerDatabase {
  ServerDatabase._(this._db) : store = SqliteSyncStore._(_db);

  /// Opens or creates the database at [path]; `:memory:` for tests.
  factory ServerDatabase.open(String path) {
    final db = sqlite3.open(path);
    try {
      db.execute('PRAGMA journal_mode = WAL');
      db.execute('PRAGMA synchronous = NORMAL');
      db.execute('PRAGMA busy_timeout = 5000');
      _migrate(db);
      return ServerDatabase._(db);
    } catch (_) {
      db.close();
      rethrow;
    }
  }

  final Database _db;
  final SqliteSyncStore store;

  static const schemaVersion = 1;

  static void _migrate(Database db) {
    final version = db.userVersion;
    if (version > schemaVersion) {
      throw StateError(
        'This database was made by a newer server (schema $version): '
        'update the server before using it.',
      );
    }
    if (version < 1) {
      db.execute('''
        BEGIN;
        CREATE TABLE sync_rows (
          entity TEXT NOT NULL,
          client_id INTEGER NOT NULL,
          received_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          deleted INTEGER NOT NULL DEFAULT 0,
          natural_key TEXT,
          parent_client_id INTEGER,
          data TEXT,
          PRIMARY KEY (entity, client_id)
        ) WITHOUT ROWID;
        CREATE INDEX sync_rows_changes
          ON sync_rows (entity, deleted, received_at);
        CREATE INDEX sync_rows_tombstones
          ON sync_rows (deleted, received_at);
        CREATE INDEX sync_rows_natural_key
          ON sync_rows (entity, natural_key) WHERE natural_key IS NOT NULL;
        CREATE INDEX sync_rows_parent
          ON sync_rows (entity, parent_client_id)
          WHERE parent_client_id IS NOT NULL;
        CREATE TABLE devices (
          fingerprint TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          paired_at INTEGER NOT NULL,
          last_sync_at INTEGER
        );
        PRAGMA user_version = 1;
        COMMIT;
      ''');
    }
  }

  // -------------------------------------------------------------------------
  // Paired devices
  // -------------------------------------------------------------------------

  List<PairedDevice> devices() => [
    for (final row in _db.select('SELECT * FROM devices ORDER BY paired_at'))
      PairedDevice(
        fingerprint: row['fingerprint'] as String,
        name: row['name'] as String,
        pairedAt: row['paired_at'] as int,
        lastSyncAt: row['last_sync_at'] as int?,
      ),
  ];

  bool hasDevice(String fingerprint) => _db.select(
    'SELECT 1 FROM devices WHERE fingerprint = ?',
    [fingerprint],
  ).isNotEmpty;

  void addDevice(PairedDevice device) => _db.execute(
    'INSERT INTO devices (fingerprint, name, paired_at) VALUES (?, ?, ?) '
    'ON CONFLICT (fingerprint) DO UPDATE SET name = excluded.name, '
    'paired_at = excluded.paired_at',
    [device.fingerprint, device.name, device.pairedAt],
  );

  /// Whether a device had [fingerprint].
  bool removeDevice(String fingerprint) {
    _db.execute('DELETE FROM devices WHERE fingerprint = ?', [fingerprint]);
    return _db.updatedRows > 0;
  }

  void deviceSynced(String fingerprint, int at) => _db.execute(
    'UPDATE devices SET last_sync_at = ? WHERE fingerprint = ?',
    [at, fingerprint],
  );

  // -------------------------------------------------------------------------
  // Upkeep
  // -------------------------------------------------------------------------

  /// A consistent copy of the whole database at [path], taken while the
  /// server keeps running.
  void backupTo(String path) => _db.execute('VACUUM INTO ?', [path]);

  /// Rows and tombstones kept, for the status page.
  ({int rows, int tombstones}) counts() {
    final row = _db
        .select(
          "SELECT SUM(deleted = 0 AND data IS NOT NULL) AS live, SUM(deleted) AS "
          "dead FROM sync_rows WHERE entity NOT IN ('meta', 'settings') "
          "AND entity NOT LIKE 'alias:%'",
        )
        .first;
    return (
      rows: (row['live'] as int?) ?? 0,
      tombstones: (row['dead'] as int?) ?? 0,
    );
  }

  void close() {
    store._closeStatements();
    _db.close();
  }
}

/// The synced rows, as the engine reads and writes them.
class SqliteSyncStore implements SyncStore {
  SqliteSyncStore._(this._db);

  final Database _db;
  final _statements = <String, PreparedStatement>{};
  var _depth = 0;

  PreparedStatement _statement(String sql) =>
      _statements[sql] ??= _db.prepare(sql, persistent: true);

  void _closeStatements() {
    for (final statement in _statements.values) {
      statement.close();
    }
    _statements.clear();
  }

  @override
  T transaction<T>(T Function() body) {
    final savepoint = 'sync_${_depth++}';
    _db.execute('SAVEPOINT $savepoint');
    try {
      final result = body();
      _db.execute('RELEASE $savepoint');
      return result;
    } catch (_) {
      _db.execute('ROLLBACK TO $savepoint');
      _db.execute('RELEASE $savepoint');
      rethrow;
    } finally {
      _depth--;
    }
  }

  static const _columns =
      'entity, client_id, received_at, updated_at, deleted, natural_key, '
      'parent_client_id, data';

  @override
  StoredRow? get(String entity, int clientId) => _first(
    _statement(
      'SELECT $_columns FROM sync_rows WHERE entity = ? AND client_id = ?',
    ).select([entity, clientId]),
  );

  @override
  void put(StoredRow row) =>
      _statement(
        'INSERT OR REPLACE INTO sync_rows ($_columns) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      ).execute([
        row.entity,
        row.clientId,
        row.receivedAt,
        row.updatedAt,
        row.deleted ? 1 : 0,
        row.naturalKey,
        row.parentClientId,
        row.data,
      ]);

  @override
  StoredRow? liveByNaturalKey(String entity, String naturalKey) => _first(
    _statement(
      'SELECT $_columns FROM sync_rows WHERE entity = ? AND natural_key = ? '
      'AND deleted = 0 LIMIT 1',
    ).select([entity, naturalKey]),
  );

  @override
  List<StoredRow> liveChildren(String entity, int parent) => _all(
    _statement(
      'SELECT $_columns FROM sync_rows WHERE entity = ? '
      'AND parent_client_id = ? AND deleted = 0',
    ).select([entity, parent]),
  );

  @override
  List<StoredRow> changes({
    String? entity,
    required bool deleted,
    required int after,
    required int limit,
  }) => _all(
    entity == null
        ? _statement(
            'SELECT $_columns FROM sync_rows WHERE deleted = ? '
            'AND received_at > ? ORDER BY received_at LIMIT ?',
          ).select([deleted ? 1 : 0, after, limit])
        : _statement(
            'SELECT $_columns FROM sync_rows WHERE entity = ? AND deleted = ? '
            'AND received_at > ? ORDER BY received_at LIMIT ?',
          ).select([entity, deleted ? 1 : 0, after, limit]),
  );

  @override
  int countChanges({
    String? entity,
    required bool deleted,
    required int after,
  }) =>
      (entity == null
                  ? _statement(
                      'SELECT COUNT(*) AS n FROM sync_rows WHERE deleted = ? '
                      'AND received_at > ?',
                    ).select([deleted ? 1 : 0, after])
                  : _statement(
                      'SELECT COUNT(*) AS n FROM sync_rows WHERE entity = ? '
                      'AND deleted = ? AND received_at > ?',
                    ).select([entity, deleted ? 1 : 0, after]))
              .first['n']
          as int;

  static StoredRow? _first(ResultSet rows) =>
      rows.isEmpty ? null : _row(rows.first);

  static List<StoredRow> _all(ResultSet rows) => [
    for (final row in rows) _row(row),
  ];

  static StoredRow _row(Row row) => StoredRow(
    entity: row['entity'] as String,
    clientId: row['client_id'] as int,
    receivedAt: row['received_at'] as int,
    updatedAt: row['updated_at'] as int,
    deleted: row['deleted'] == 1,
    naturalKey: row['natural_key'] as String?,
    parentClientId: row['parent_client_id'] as int?,
    data: row['data'] as String?,
  );
}
