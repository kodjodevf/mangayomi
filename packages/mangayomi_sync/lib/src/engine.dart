// What a host or sync server does with a sync request (`/api/sync/v1`): a
// row is stored when it is newer than the stored one by the uploading
// device's clock, a title or chapter two devices added apart becomes one (the
// response tells the device the id to adopt), and deleting a title deletes
// what belongs to it.
//
// Devices page through changes by when the store took them, on the host's
// own clock, never by the uploading device's: an edit made offline and
// uploaded later carries an older time than the other devices' last sync,
// and paging by it, they would never see it.
import 'dart:convert';
import 'dart:math';

import 'store.dart';
import 'validation.dart';

class SyncEngine {
  SyncEngine(this._store, {int Function()? clock, this.pageSize = 2000})
    : _clock = clock ?? (() => DateTime.now().millisecondsSinceEpoch);

  final SyncStore _store;
  final int Function() _clock;

  /// Rows of one entity per response.
  final int pageSize;

  /// How far ahead of the host's clock an `updatedAt` may be. Beyond, it is
  /// taken as now: a row dated years ahead would otherwise win against every
  /// later edit, for good.
  static const maxClockSkew = Duration(days: 1);

  static const _meta = 'meta';
  static const _settings = 'settings';
  static const _children = ['chapters', 'tracks', 'histories', 'updates'];

  late int _lastStamp;

  /// Applies [request], a decoded JSON sync request, and answers with the
  /// response a device expects. Throws [SyncRequestInvalid] for a request to
  /// refuse, before anything is stored.
  Map<String, dynamic> handle(Object? request) {
    final valid = validateSyncRequest(request);
    return _store.transaction(() {
      _lastStamp = _store.get(_meta, 0)?.receivedAt ?? 0;
      final response = _handle(valid);
      _store.put(
        StoredRow(
          entity: _meta,
          clientId: 0,
          receivedAt: _lastStamp,
          updatedAt: 0,
        ),
      );
      return response;
    });
  }

  /// The newest stamp given out: what a device that synced now has seen.
  int get lastStamp => _store.get(_meta, 0)?.receivedAt ?? 0;

  /// A time on the host's clock that no row had before, so paging never
  /// skips or repeats one, even when the clock goes back.
  int _stamp() => _lastStamp = max(_clock(), _lastStamp + 1);

  Map<String, dynamic> _handle(ValidSyncRequest request) {
    final applied = {for (final entity in syncEntities) entity: <int>{}};
    final mangaRemap = <int, int>{};
    final chapterRemap = <int, int>{};

    for (final row in request.rows['categories']!) {
      if (_upsert('categories', row)) {
        applied['categories']!.add(row['clientId']);
      }
    }

    for (final row in request.rows['manga']!) {
      final incoming = row['clientId'] as int;
      final clientId = _adopt('manga', incoming, _mangaKey(row), mangaRemap);
      row['clientId'] = clientId;
      if (_upsert('manga', row, naturalKey: _mangaKey(row))) {
        applied['manga']!.add(clientId);
      }
    }

    for (final row in request.rows['chapters']!) {
      final manga = _liveParent(row);
      if (manga == null) continue;
      final key = _chapterKey(manga, row);
      final clientId = _adopt(
        'chapters',
        row['clientId'] as int,
        key,
        chapterRemap,
      );
      row['clientId'] = clientId;
      if (_upsert('chapters', row, naturalKey: key, parent: manga)) {
        applied['chapters']!.add(clientId);
      }
    }

    for (final entity in ['tracks', 'updates']) {
      for (final row in request.rows[entity]!) {
        final manga = _liveParent(row);
        if (manga == null) continue;
        if (_upsert(entity, row, parent: manga)) {
          applied[entity]!.add(row['clientId']);
        }
      }
    }

    for (final row in request.rows['histories']!) {
      final manga = _liveParent(row);
      final chapter = _canonical('chapters', row['chapterClientId'] as int);
      if (manga == null || !_live('chapters', chapter)) continue;
      row['chapterClientId'] = chapter;
      if (_upsert('histories', row, parent: manga)) {
        applied['histories']!.add(row['clientId']);
      }
    }

    final settings = request.settings;
    final settingsApplied =
        settings != null &&
        _upsert(_settings, {
          'clientId': 1,
          'updatedAt': settings['updatedAt'],
          'data': settings['data'],
        });

    for (final entity in syncEntities) {
      for (final id in request.deleted[entity] ?? const <int>[]) {
        _delete(entity, _canonical(entity, id));
      }
    }

    return _pull(request, applied, settingsApplied, mangaRemap, chapterRemap);
  }

  // ---------------------------------------------------------------------
  // Writing
  // ---------------------------------------------------------------------

  bool _live(String entity, int clientId) =>
      _store.get(entity, clientId)?.deleted == false;

  /// The clientId [clientId] stands for, once it was found to duplicate a
  /// row stored under another.
  int _canonical(String entity, int clientId) =>
      _store.get('alias:$entity', clientId)?.parentClientId ?? clientId;

  /// The canonical manga [row] belongs to, rewritten into it, or null when
  /// the store has no such manga: nothing to attach the row to.
  int? _liveParent(Map<String, dynamic> row) {
    final manga = _canonical('manga', row['mangaClientId'] as int);
    if (!_live('manga', manga)) return null;
    row['mangaClientId'] = manga;
    return manga;
  }

  /// The clientId to store [incoming] under: the one already stored for the
  /// same [naturalKey] when [incoming] is new, recorded in [remap] for the
  /// device to adopt.
  int _adopt(
    String entity,
    int incoming,
    String? naturalKey,
    Map<int, int> remap,
  ) {
    var clientId = _canonical(entity, incoming);
    if (naturalKey != null && _store.get(entity, clientId) == null) {
      final match = _store.liveByNaturalKey(entity, naturalKey);
      if (match != null && match.clientId != clientId) {
        clientId = match.clientId;
        _store.put(
          StoredRow(
            entity: 'alias:$entity',
            clientId: incoming,
            receivedAt: 0,
            updatedAt: 0,
            parentClientId: clientId,
          ),
        );
      }
    }
    if (clientId != incoming) remap[incoming] = clientId;
    return clientId;
  }

  /// Stores [row] unless the stored version is as new or newer. A newer
  /// version brings a deleted row back.
  bool _upsert(
    String entity,
    Map<String, dynamic> row, {
    String? naturalKey,
    int? parent,
  }) {
    final now = _clock();
    var updatedAt = row['updatedAt'] as int;
    if (updatedAt > now + maxClockSkew.inMilliseconds) updatedAt = now;
    row['updatedAt'] = updatedAt;

    final clientId = row['clientId'] as int;
    final stored = _store.get(entity, clientId);
    if (stored != null && updatedAt <= stored.updatedAt) return false;

    _store.put(
      StoredRow(
        entity: entity,
        clientId: clientId,
        updatedAt: updatedAt,
        receivedAt: _stamp(),
        naturalKey: naturalKey,
        parentClientId: parent,
        data: jsonEncode(row),
      ),
    );
    return true;
  }

  /// Leaves a tombstone for the devices that still have the row, and for a
  /// manga, for everything that belongs to it.
  void _delete(String entity, int clientId) {
    _tombstone(_store.get(entity, clientId), entity, clientId);
    if (entity != 'manga') return;
    for (final child in _children) {
      for (final row in _store.liveChildren(child, clientId)) {
        _tombstone(row, child, row.clientId);
      }
    }
  }

  void _tombstone(StoredRow? stored, String entity, int clientId) {
    if (stored?.deleted == true) return;
    _store.put(
      StoredRow(
        entity: entity,
        clientId: clientId,
        updatedAt: _clock(),
        receivedAt: _stamp(),
        deleted: true,
        // Kept, so a child deleted with its manga is still found by it.
        parentClientId: stored?.parentClientId,
      ),
    );
  }

  // Fields are joined with the unit separator, not NUL: some stores cut a
  // string at a NUL.
  static String? _mangaKey(Map<String, dynamic> row) {
    final link = row['link'] as String?;
    if (link == null || link.isEmpty) return null;
    return '${row['itemType']}\u001f${row['source'] ?? ''}\u001f$link';
  }

  static String? _chapterKey(int manga, Map<String, dynamic> row) {
    final url = row['url'] as String?;
    if (url == null || url.isEmpty) return null;
    return '$manga\u001f$url';
  }

  // ---------------------------------------------------------------------
  // Reading
  // ---------------------------------------------------------------------

  Map<String, dynamic> _pull(
    ValidSyncRequest request,
    Map<String, Set<int>> applied,
    bool settingsApplied,
    Map<int, int> mangaRemap,
    Map<int, int> chapterRemap,
  ) {
    final since = request.since;
    final response = <String, dynamic>{};
    final cursors = <String, String?>{};
    final totalCounts = <String, int>{};
    var hasMore = false;

    for (final entity in syncEntities) {
      final cursor = int.tryParse(request.cursors[entity] ?? '');
      final rows = _store.changes(
        entity: entity,
        deleted: false,
        after: cursor ?? since,
        limit: pageSize + 1,
      );
      final more = rows.length > pageSize;
      final page = more ? rows.sublist(0, pageSize) : rows;
      hasMore |= more;
      cursors[entity] = more ? '${page.last.receivedAt}' : null;
      if (cursor == null) {
        totalCounts[entity] = _store.countChanges(
          entity: entity,
          deleted: false,
          after: since,
        );
      }
      // What this same request just stored is the device's own: no need to
      // send it back.
      response[entity] = [
        for (final row in page)
          if (!applied[entity]!.contains(row.clientId)) jsonDecode(row.data!),
      ];
    }

    final tombstoneCursor = int.tryParse(request.cursors['tombstones'] ?? '');
    final deleted = _store.changes(
      deleted: true,
      after: tombstoneCursor ?? since,
      limit: pageSize + 1,
    );
    final moreDeleted = deleted.length > pageSize;
    final deletedPage = moreDeleted ? deleted.sublist(0, pageSize) : deleted;
    hasMore |= moreDeleted;
    cursors['tombstones'] = moreDeleted
        ? '${deletedPage.last.receivedAt}'
        : null;
    if (tombstoneCursor == null) {
      totalCounts['tombstones'] = _store.countChanges(
        deleted: true,
        after: since,
      );
    }
    response['tombstones'] = {
      for (final entity in syncEntities)
        entity: [
          for (final row in deletedPage)
            if (row.entity == entity) row.clientId,
        ],
    };

    final settings = _store.get(_settings, 1);
    response['settings'] =
        settings != null && settings.receivedAt > since && !settingsApplied
        ? {
            'data': (jsonDecode(settings.data!) as Map)['data'],
            'updatedAt': settings.updatedAt,
          }
        : null;

    response['hasMore'] = hasMore;
    // Everything stored up to this stamp has now reached the device, its own
    // uploads included: the next sync starts after it. A fresh stamp rather
    // than the last one, so it also moves with the clock and the device keeps
    // uploading only what it changed since.
    response['syncedAt'] = hasMore ? null : _stamp();
    response['cursors'] = cursors;
    response['totalCounts'] = totalCounts;
    if (mangaRemap.isNotEmpty) {
      response['mangaClientIdRemap'] = {
        for (final MapEntry(:key, :value) in mangaRemap.entries) '$key': value,
      };
    }
    if (chapterRemap.isNotEmpty) {
      response['chapterClientIdRemap'] = {
        for (final MapEntry(:key, :value) in chapterRemap.entries)
          '$key': value,
      };
    }
    return response;
  }
}
