// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_preference.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncPreferenceCollection on Isar {
  IsarCollection<SyncPreference> get syncPreferences => this.collection();
}

const SyncPreferenceSchema = CollectionSchema(
  name: r'Sync Preference',
  id: 2788277548653279925,
  properties: {
    r'authToken': PropertySchema(
      id: 0,
      name: r'authToken',
      type: IsarType.string,
    ),
    r'autoSyncFrequency': PropertySchema(
      id: 1,
      name: r'autoSyncFrequency',
      type: IsarType.long,
    ),
    r'email': PropertySchema(id: 2, name: r'email', type: IsarType.string),
    r'lastSyncHistory': PropertySchema(
      id: 3,
      name: r'lastSyncHistory',
      type: IsarType.long,
    ),
    r'lastSyncManga': PropertySchema(
      id: 4,
      name: r'lastSyncManga',
      type: IsarType.long,
    ),
    r'lastSyncUpdate': PropertySchema(
      id: 5,
      name: r'lastSyncUpdate',
      type: IsarType.long,
    ),
    r'server': PropertySchema(id: 6, name: r'server', type: IsarType.string),
    r'syncHistories': PropertySchema(
      id: 7,
      name: r'syncHistories',
      type: IsarType.bool,
    ),
    r'syncOn': PropertySchema(id: 8, name: r'syncOn', type: IsarType.bool),
    r'syncSettings': PropertySchema(
      id: 9,
      name: r'syncSettings',
      type: IsarType.bool,
    ),
    r'syncUpdates': PropertySchema(
      id: 10,
      name: r'syncUpdates',
      type: IsarType.bool,
    ),
  },

  estimateSize: _syncPreferenceEstimateSize,
  serialize: _syncPreferenceSerialize,
  deserialize: _syncPreferenceDeserialize,
  deserializeProp: _syncPreferenceDeserializeProp,
  idName: r'syncId',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _syncPreferenceGetId,
  getLinks: _syncPreferenceGetLinks,
  attach: _syncPreferenceAttach,
  version: '3.1.0+1',
);

int _syncPreferenceEstimateSize(
  SyncPreference object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.authToken;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.server;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _syncPreferenceSerialize(
  SyncPreference object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.authToken);
  writer.writeLong(offsets[1], object.autoSyncFrequency);
  writer.writeString(offsets[2], object.email);
  writer.writeLong(offsets[3], object.lastSyncHistory);
  writer.writeLong(offsets[4], object.lastSyncManga);
  writer.writeLong(offsets[5], object.lastSyncUpdate);
  writer.writeString(offsets[6], object.server);
  writer.writeBool(offsets[7], object.syncHistories);
  writer.writeBool(offsets[8], object.syncOn);
  writer.writeBool(offsets[9], object.syncSettings);
  writer.writeBool(offsets[10], object.syncUpdates);
}

SyncPreference _syncPreferenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncPreference(
    authToken: reader.readStringOrNull(offsets[0]),
    autoSyncFrequency: reader.readLongOrNull(offsets[1]) ?? 0,
    email: reader.readStringOrNull(offsets[2]),
    lastSyncHistory: reader.readLongOrNull(offsets[3]),
    lastSyncManga: reader.readLongOrNull(offsets[4]),
    lastSyncUpdate: reader.readLongOrNull(offsets[5]),
    server: reader.readStringOrNull(offsets[6]),
    syncId: id,
    syncOn: reader.readBoolOrNull(offsets[8]) ?? false,
  );
  object.syncHistories = reader.readBool(offsets[7]);
  object.syncSettings = reader.readBool(offsets[9]);
  object.syncUpdates = reader.readBool(offsets[10]);
  return object;
}

P _syncPreferenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _syncPreferenceGetId(SyncPreference object) {
  return object.syncId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _syncPreferenceGetLinks(SyncPreference object) {
  return [];
}

void _syncPreferenceAttach(
  IsarCollection<dynamic> col,
  Id id,
  SyncPreference object,
) {
  object.syncId = id;
}

extension SyncPreferenceQueryWhereSort
    on QueryBuilder<SyncPreference, SyncPreference, QWhere> {
  QueryBuilder<SyncPreference, SyncPreference, QAfterWhere> anySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SyncPreferenceQueryWhere
    on QueryBuilder<SyncPreference, SyncPreference, QWhereClause> {
  QueryBuilder<SyncPreference, SyncPreference, QAfterWhereClause> syncIdEqualTo(
    Id syncId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: syncId, upper: syncId),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterWhereClause>
  syncIdNotEqualTo(Id syncId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: syncId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: syncId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: syncId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: syncId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterWhereClause>
  syncIdGreaterThan(Id syncId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: syncId, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterWhereClause>
  syncIdLessThan(Id syncId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: syncId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterWhereClause> syncIdBetween(
    Id lowerSyncId,
    Id upperSyncId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerSyncId,
          includeLower: includeLower,
          upper: upperSyncId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SyncPreferenceQueryFilter
    on QueryBuilder<SyncPreference, SyncPreference, QFilterCondition> {
  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'authToken'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'authToken'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'authToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'authToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'authToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'authToken',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'authToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'authToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'authToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'authToken',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'authToken', value: ''),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  authTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'authToken', value: ''),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  autoSyncFrequencyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoSyncFrequency', value: value),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  autoSyncFrequencyGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'autoSyncFrequency',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  autoSyncFrequencyLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'autoSyncFrequency',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  autoSyncFrequencyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'autoSyncFrequency',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'email'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'email'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'email',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'email',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncHistoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSyncHistory'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncHistoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSyncHistory'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncHistoryEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSyncHistory', value: value),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncHistoryGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSyncHistory',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncHistoryLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSyncHistory',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncHistoryBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSyncHistory',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncMangaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSyncManga'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncMangaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSyncManga'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncMangaEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSyncManga', value: value),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncMangaGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSyncManga',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncMangaLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSyncManga',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncMangaBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSyncManga',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncUpdateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastSyncUpdate'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncUpdateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastSyncUpdate'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncUpdateEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastSyncUpdate', value: value),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncUpdateGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastSyncUpdate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncUpdateLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastSyncUpdate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  lastSyncUpdateBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastSyncUpdate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'server'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'server'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'server',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'server',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'server',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'server', value: ''),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  serverIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'server', value: ''),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  syncHistoriesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncHistories', value: value),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  syncIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'syncId'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  syncIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'syncId'),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  syncIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncId', value: value),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  syncIdGreaterThan(Id? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'syncId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  syncIdLessThan(Id? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'syncId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  syncIdBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'syncId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  syncOnEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncOn', value: value),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  syncSettingsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncSettings', value: value),
      );
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterFilterCondition>
  syncUpdatesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncUpdates', value: value),
      );
    });
  }
}

extension SyncPreferenceQueryObject
    on QueryBuilder<SyncPreference, SyncPreference, QFilterCondition> {}

extension SyncPreferenceQueryLinks
    on QueryBuilder<SyncPreference, SyncPreference, QFilterCondition> {}

extension SyncPreferenceQuerySortBy
    on QueryBuilder<SyncPreference, SyncPreference, QSortBy> {
  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy> sortByAuthToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authToken', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortByAuthTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authToken', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortByAutoSyncFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoSyncFrequency', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortByAutoSyncFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoSyncFrequency', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortByLastSyncHistory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncHistory', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortByLastSyncHistoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncHistory', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortByLastSyncManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncManga', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortByLastSyncMangaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncManga', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortByLastSyncUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncUpdate', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortByLastSyncUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncUpdate', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy> sortByServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortByServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortBySyncHistories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncHistories', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortBySyncHistoriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncHistories', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy> sortBySyncOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncOn', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortBySyncOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncOn', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortBySyncSettings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncSettings', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortBySyncSettingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncSettings', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortBySyncUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncUpdates', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  sortBySyncUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncUpdates', Sort.desc);
    });
  }
}

extension SyncPreferenceQuerySortThenBy
    on QueryBuilder<SyncPreference, SyncPreference, QSortThenBy> {
  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy> thenByAuthToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authToken', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenByAuthTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'authToken', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenByAutoSyncFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoSyncFrequency', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenByAutoSyncFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoSyncFrequency', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenByLastSyncHistory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncHistory', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenByLastSyncHistoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncHistory', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenByLastSyncManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncManga', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenByLastSyncMangaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncManga', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenByLastSyncUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncUpdate', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenByLastSyncUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncUpdate', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy> thenByServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenByServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'server', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenBySyncHistories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncHistories', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenBySyncHistoriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncHistories', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy> thenBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenBySyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy> thenBySyncOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncOn', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenBySyncOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncOn', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenBySyncSettings() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncSettings', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenBySyncSettingsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncSettings', Sort.desc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenBySyncUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncUpdates', Sort.asc);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QAfterSortBy>
  thenBySyncUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncUpdates', Sort.desc);
    });
  }
}

extension SyncPreferenceQueryWhereDistinct
    on QueryBuilder<SyncPreference, SyncPreference, QDistinct> {
  QueryBuilder<SyncPreference, SyncPreference, QDistinct> distinctByAuthToken({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'authToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QDistinct>
  distinctByAutoSyncFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoSyncFrequency');
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QDistinct> distinctByEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QDistinct>
  distinctByLastSyncHistory() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncHistory');
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QDistinct>
  distinctByLastSyncManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncManga');
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QDistinct>
  distinctByLastSyncUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncUpdate');
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QDistinct> distinctByServer({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'server', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QDistinct>
  distinctBySyncHistories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncHistories');
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QDistinct> distinctBySyncOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncOn');
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QDistinct>
  distinctBySyncSettings() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncSettings');
    });
  }

  QueryBuilder<SyncPreference, SyncPreference, QDistinct>
  distinctBySyncUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncUpdates');
    });
  }
}

extension SyncPreferenceQueryProperty
    on QueryBuilder<SyncPreference, SyncPreference, QQueryProperty> {
  QueryBuilder<SyncPreference, int, QQueryOperations> syncIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncId');
    });
  }

  QueryBuilder<SyncPreference, String?, QQueryOperations> authTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'authToken');
    });
  }

  QueryBuilder<SyncPreference, int, QQueryOperations>
  autoSyncFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoSyncFrequency');
    });
  }

  QueryBuilder<SyncPreference, String?, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<SyncPreference, int?, QQueryOperations>
  lastSyncHistoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncHistory');
    });
  }

  QueryBuilder<SyncPreference, int?, QQueryOperations> lastSyncMangaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncManga');
    });
  }

  QueryBuilder<SyncPreference, int?, QQueryOperations>
  lastSyncUpdateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncUpdate');
    });
  }

  QueryBuilder<SyncPreference, String?, QQueryOperations> serverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'server');
    });
  }

  QueryBuilder<SyncPreference, bool, QQueryOperations> syncHistoriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncHistories');
    });
  }

  QueryBuilder<SyncPreference, bool, QQueryOperations> syncOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncOn');
    });
  }

  QueryBuilder<SyncPreference, bool, QQueryOperations> syncSettingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncSettings');
    });
  }

  QueryBuilder<SyncPreference, bool, QQueryOperations> syncUpdatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncUpdates');
    });
  }
}
