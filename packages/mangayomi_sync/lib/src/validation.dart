// The checks a sync request goes through before the host stores anything
// from it, field for field those of the sync server's request schema. A
// row keeps only the fields named here, so a device can store nothing else.

/// Thrown for a request the host refuses outright, answered with 400.
class SyncRequestInvalid implements Exception {
  SyncRequestInvalid(this.message);

  final String message;

  @override
  String toString() => 'SyncRequestInvalid: $message';
}

/// The paged entities, in the order they depend on each other.
const syncEntities = [
  'categories',
  'manga',
  'chapters',
  'tracks',
  'histories',
  'updates',
];

/// Rows of one entity a request may carry, as on the sync server.
const maxRowsPerEntity = 5000;

const _maxSafeInteger = 9007199254740991;
const _maxCategoriesPerManga = 200;

const _itemTypes = {'MANGA', 'ANIME', 'NOVEL'};
const _statuses = {
  'ONGOING',
  'COMPLETED',
  'CANCELED',
  'UNKNOWN',
  'ON_HIATUS',
  'PUBLISHING_FINISHED',
};
const _trackStatuses = {
  'READING',
  'COMPLETED',
  'ON_HOLD',
  'DROPPED',
  'PLAN_TO_READ',
  'RE_READING',
  'WATCHING',
  'PLAN_TO_WATCH',
  'RE_WATCHING',
};

enum _Kind {
  clientId,
  integer,
  number,
  boolean,
  text,
  itemType,
  status,
  trackStatus,
  texts,
  clientIds,
  webUrl,
}

class _Field {
  const _Field(
    this.name,
    this.kind, {
    this.required = false,
    this.nullable = true,
    this.max = 0,
  });

  final String name;
  final _Kind kind;
  final bool required;
  final bool nullable;

  /// Longest text, or most entries in a list.
  final int max;
}

const _clientId = _Field(
  'clientId',
  _Kind.clientId,
  required: true,
  nullable: false,
);
const _mangaClientId = _Field(
  'mangaClientId',
  _Kind.clientId,
  required: true,
  nullable: false,
);
const _updatedAt = _Field(
  'updatedAt',
  _Kind.number,
  required: true,
  nullable: false,
);
const _itemType = _Field(
  'itemType',
  _Kind.itemType,
  required: true,
  nullable: false,
);

const _fields = <String, List<_Field>>{
  'categories': [
    _clientId,
    _Field('name', _Kind.text, required: true, nullable: false, max: 200),
    _Field('forItemType', _Kind.itemType, required: true, nullable: false),
    _Field('pos', _Kind.integer),
    _Field('hide', _Kind.boolean, nullable: false),
    _Field('shouldUpdate', _Kind.boolean, nullable: false),
    _updatedAt,
  ],
  'manga': [
    _clientId,
    _Field('source', _Kind.text, max: 200),
    _Field('sourceId', _Kind.integer),
    _Field('link', _Kind.text, max: 2000),
    _itemType,
    _Field('name', _Kind.text, max: 500),
    _Field('imageUrl', _Kind.text, max: 2000),
    _Field('description', _Kind.text, max: 10000),
    _Field('author', _Kind.text, max: 500),
    _Field('artist', _Kind.text, max: 500),
    _Field('status', _Kind.status, nullable: false),
    _Field('genre', _Kind.texts, nullable: false, max: 100),
    _Field('lang', _Kind.text, max: 20),
    _Field('lastUpdate', _Kind.number),
    _Field('favorite', _Kind.boolean, nullable: false),
    _Field('dateAdded', _Kind.number),
    _Field('lastRead', _Kind.number),
    _Field('isLocalArchive', _Kind.boolean, nullable: false),
    _Field('customCoverFromTracker', _Kind.text, max: 2000),
    _Field('smartUpdateDays', _Kind.integer),
    _Field(
      'categoryClientIds',
      _Kind.clientIds,
      nullable: false,
      max: _maxCategoriesPerManga,
    ),
    _updatedAt,
  ],
  'chapters': [
    _clientId,
    _mangaClientId,
    _Field('name', _Kind.text, max: 500),
    _Field('url', _Kind.text, max: 2000),
    _Field('scanlator', _Kind.text, max: 200),
    _Field('dateUpload', _Kind.number),
    _Field('isFiller', _Kind.boolean, nullable: false),
    _Field('thumbnailUrl', _Kind.text, max: 2000),
    _Field('description', _Kind.text, max: 5000),
    _Field('downloadSize', _Kind.integer),
    _Field('duration', _Kind.integer),
    _Field('isRead', _Kind.boolean, nullable: false),
    _Field('isBookmarked', _Kind.boolean, nullable: false),
    _Field('lastPageRead', _Kind.text, max: 50),
    _updatedAt,
  ],
  'tracks': [
    _clientId,
    _mangaClientId,
    _Field('syncId', _Kind.integer),
    _Field('mediaId', _Kind.integer),
    _Field('libraryId', _Kind.integer),
    _Field('title', _Kind.text, max: 500),
    _Field('lastChapterRead', _Kind.number),
    _Field('totalChapter', _Kind.integer),
    _Field('score', _Kind.number),
    _Field('status', _Kind.trackStatus, nullable: false),
    _Field('startedReadingDate', _Kind.number),
    _Field('finishedReadingDate', _Kind.number),
    _Field('trackingUrl', _Kind.webUrl, max: 2000),
    _itemType,
    _updatedAt,
  ],
  'histories': [
    _clientId,
    _mangaClientId,
    _Field('chapterClientId', _Kind.clientId, required: true, nullable: false),
    _itemType,
    _Field('date', _Kind.number),
    _Field('readingTimeSeconds', _Kind.integer, nullable: false),
    _updatedAt,
  ],
  'updates': [
    _clientId,
    _mangaClientId,
    _Field('chapterName', _Kind.text, max: 500),
    _Field('date', _Kind.number),
    _updatedAt,
  ],
};

/// A sync request once checked: only the known fields, every number where
/// a number belongs, and `updatedAt` a whole number of milliseconds.
class ValidSyncRequest {
  ValidSyncRequest({
    required this.since,
    required this.cursors,
    required this.rows,
    required this.deleted,
    required this.settings,
  });

  final int since;
  final Map<String, String?> cursors;

  /// Per entity, in [syncEntities] order.
  final Map<String, List<Map<String, dynamic>>> rows;
  final Map<String, List<int>> deleted;

  /// `{data, updatedAt}`, when the request carries settings.
  final Map<String, dynamic>? settings;
}

ValidSyncRequest validateSyncRequest(Object? raw) {
  final json = _object(raw);
  if (json == null) throw SyncRequestInvalid('the request is not an object');

  final since = json['since'];
  if (since != null && (since is! int || since < 0)) {
    throw SyncRequestInvalid('since');
  }

  final sessionToken = json['sessionToken'];
  if (sessionToken != null &&
      (sessionToken is! String || sessionToken.length > 500)) {
    throw SyncRequestInvalid('sessionToken');
  }

  final cursors = <String, String?>{};
  final rawCursors = json['cursors'];
  if (rawCursors != null) {
    if (rawCursors is! Map) throw SyncRequestInvalid('cursors');
    for (final MapEntry(:key, :value) in rawCursors.entries) {
      if (value != null && value is! String) {
        throw SyncRequestInvalid('cursors.$key');
      }
      cursors[key as String] = value as String?;
    }
  }

  final rows = <String, List<Map<String, dynamic>>>{};
  for (final entity in syncEntities) {
    final list = json[entity];
    if (list == null) {
      rows[entity] = const [];
      continue;
    }
    if (list is! List || list.length > maxRowsPerEntity) {
      throw SyncRequestInvalid(entity);
    }
    rows[entity] = [
      for (var i = 0; i < list.length; i++)
        _row(list[i], _fields[entity]!, '$entity[$i]'),
    ];
  }

  final deleted = <String, List<int>>{};
  final rawDeleted = json['deleted'];
  if (rawDeleted != null) {
    if (rawDeleted is! Map) throw SyncRequestInvalid('deleted');
    for (final entity in syncEntities) {
      final ids = rawDeleted[entity];
      if (ids == null) continue;
      if (ids is! List || ids.length > maxRowsPerEntity) {
        throw SyncRequestInvalid('deleted.$entity');
      }
      deleted[entity] = [
        for (final id in ids) _checkClientId(id, 'deleted.$entity'),
      ];
    }
  }

  Map<String, dynamic>? settings;
  final rawSettings = json['settings'];
  if (rawSettings != null) {
    final data = rawSettings is Map ? _object(rawSettings['data']) : null;
    if (data == null || rawSettings['updatedAt'] is! num) {
      throw SyncRequestInvalid('settings');
    }
    settings = {
      'data': data,
      'updatedAt': (rawSettings['updatedAt'] as num).toInt(),
    };
  }

  return ValidSyncRequest(
    since: (since as int?) ?? 0,
    cursors: cursors,
    rows: rows,
    deleted: deleted,
    settings: settings,
  );
}

int _checkClientId(Object? value, String at) {
  if (value is int && value > 0 && value <= _maxSafeInteger) return value;
  throw SyncRequestInvalid(at);
}

/// [value] as a JSON object, or null when it is not one.
Map<String, dynamic>? _object(Object? value) {
  if (value is! Map || value.keys.any((key) => key is! String)) return null;
  return value is Map<String, dynamic>
      ? value
      : Map<String, dynamic>.from(value);
}

Map<String, dynamic> _row(Object? value, List<_Field> fields, String at) {
  final raw = _object(value);
  if (raw == null) throw SyncRequestInvalid(at);
  final row = <String, dynamic>{};
  for (final field in fields) {
    final where = '$at.${field.name}';
    if (!raw.containsKey(field.name)) {
      if (field.required) throw SyncRequestInvalid(where);
      continue;
    }
    final value = raw[field.name];
    if (value == null) {
      if (!field.nullable) throw SyncRequestInvalid(where);
      row[field.name] = null;
      continue;
    }
    row[field.name] = _value(value, field, where);
  }
  return row;
}

Object _value(Object value, _Field field, String at) {
  bool fits(String text) => text.length <= field.max;
  switch (field.kind) {
    case _Kind.clientId:
      return _checkClientId(value, at);
    case _Kind.integer:
      if (value is int && value.abs() <= _maxSafeInteger) return value;
    case _Kind.number:
      if (value is num && value.isFinite) {
        // Milliseconds, never fractions of them.
        return field.name == 'updatedAt' ? value.toInt() : value;
      }
    case _Kind.boolean:
      if (value is bool) return value;
    case _Kind.text:
      if (value is String && fits(value)) return value;
    case _Kind.webUrl:
      if (value is String &&
          fits(value) &&
          (value.isEmpty || RegExp(r'^https?://').hasMatch(value))) {
        return value;
      }
    case _Kind.itemType:
      if (_itemTypes.contains(value)) return value;
    case _Kind.status:
      if (_statuses.contains(value)) return value;
    case _Kind.trackStatus:
      if (_trackStatuses.contains(value)) return value;
    case _Kind.texts:
      if (value is List && value.every((e) => e is String && fits(e))) {
        return List<String>.from(value);
      }
    case _Kind.clientIds:
      if (value is List && value.length <= field.max) {
        return [for (final id in value) _checkClientId(id, at)];
      }
  }
  throw SyncRequestInvalid(at);
}
