// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_preference.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTrackPreferenceCollection on Isar {
  IsarCollection<TrackPreference> get trackPreferences => this.collection();
}

const TrackPreferenceSchema = CollectionSchema(
  name: r'Track Preference',
  id: -7260395670212271073,
  properties: {
    r'oAuth': PropertySchema(id: 0, name: r'oAuth', type: IsarType.string),
    r'prefs': PropertySchema(id: 1, name: r'prefs', type: IsarType.string),
    r'refreshing': PropertySchema(
      id: 2,
      name: r'refreshing',
      type: IsarType.bool,
    ),
    r'username': PropertySchema(
      id: 3,
      name: r'username',
      type: IsarType.string,
    ),
  },

  estimateSize: _trackPreferenceEstimateSize,
  serialize: _trackPreferenceSerialize,
  deserialize: _trackPreferenceDeserialize,
  deserializeProp: _trackPreferenceDeserializeProp,
  idName: r'syncId',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _trackPreferenceGetId,
  getLinks: _trackPreferenceGetLinks,
  attach: _trackPreferenceAttach,
  version: '3.1.0+1',
);

int _trackPreferenceEstimateSize(
  TrackPreference object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.oAuth;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.prefs;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.username;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _trackPreferenceSerialize(
  TrackPreference object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.oAuth);
  writer.writeString(offsets[1], object.prefs);
  writer.writeBool(offsets[2], object.refreshing);
  writer.writeString(offsets[3], object.username);
}

TrackPreference _trackPreferenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrackPreference(
    oAuth: reader.readStringOrNull(offsets[0]),
    prefs: reader.readStringOrNull(offsets[1]),
    refreshing: reader.readBoolOrNull(offsets[2]),
    syncId: id,
    username: reader.readStringOrNull(offsets[3]),
  );
  return object;
}

P _trackPreferenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _trackPreferenceGetId(TrackPreference object) {
  return object.syncId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _trackPreferenceGetLinks(TrackPreference object) {
  return [];
}

void _trackPreferenceAttach(
  IsarCollection<dynamic> col,
  Id id,
  TrackPreference object,
) {
  object.syncId = id;
}

extension TrackPreferenceQueryWhereSort
    on QueryBuilder<TrackPreference, TrackPreference, QWhere> {
  QueryBuilder<TrackPreference, TrackPreference, QAfterWhere> anySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TrackPreferenceQueryWhere
    on QueryBuilder<TrackPreference, TrackPreference, QWhereClause> {
  QueryBuilder<TrackPreference, TrackPreference, QAfterWhereClause>
  syncIdEqualTo(Id syncId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: syncId, upper: syncId),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterWhereClause>
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

  QueryBuilder<TrackPreference, TrackPreference, QAfterWhereClause>
  syncIdGreaterThan(Id syncId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: syncId, includeLower: include),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterWhereClause>
  syncIdLessThan(Id syncId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: syncId, includeUpper: include),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterWhereClause>
  syncIdBetween(
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

extension TrackPreferenceQueryFilter
    on QueryBuilder<TrackPreference, TrackPreference, QFilterCondition> {
  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'oAuth'),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'oAuth'),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'oAuth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'oAuth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'oAuth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'oAuth',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'oAuth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'oAuth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'oAuth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'oAuth',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'oAuth', value: ''),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  oAuthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'oAuth', value: ''),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'prefs'),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'prefs'),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'prefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'prefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'prefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'prefs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'prefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'prefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'prefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'prefs',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'prefs', value: ''),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  prefsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'prefs', value: ''),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  refreshingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'refreshing'),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  refreshingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'refreshing'),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  refreshingEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'refreshing', value: value),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  syncIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'syncId'),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  syncIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'syncId'),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  syncIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncId', value: value),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
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

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
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

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
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

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'username'),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'username'),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'username',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'username',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'username',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'username', value: ''),
      );
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterFilterCondition>
  usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'username', value: ''),
      );
    });
  }
}

extension TrackPreferenceQueryObject
    on QueryBuilder<TrackPreference, TrackPreference, QFilterCondition> {}

extension TrackPreferenceQueryLinks
    on QueryBuilder<TrackPreference, TrackPreference, QFilterCondition> {}

extension TrackPreferenceQuerySortBy
    on QueryBuilder<TrackPreference, TrackPreference, QSortBy> {
  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy> sortByOAuth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oAuth', Sort.asc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  sortByOAuthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oAuth', Sort.desc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy> sortByPrefs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefs', Sort.asc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  sortByPrefsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefs', Sort.desc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  sortByRefreshing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshing', Sort.asc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  sortByRefreshingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshing', Sort.desc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension TrackPreferenceQuerySortThenBy
    on QueryBuilder<TrackPreference, TrackPreference, QSortThenBy> {
  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy> thenByOAuth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oAuth', Sort.asc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  thenByOAuthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oAuth', Sort.desc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy> thenByPrefs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefs', Sort.asc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  thenByPrefsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefs', Sort.desc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  thenByRefreshing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshing', Sort.asc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  thenByRefreshingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshing', Sort.desc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy> thenBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.asc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  thenBySyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.desc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QAfterSortBy>
  thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension TrackPreferenceQueryWhereDistinct
    on QueryBuilder<TrackPreference, TrackPreference, QDistinct> {
  QueryBuilder<TrackPreference, TrackPreference, QDistinct> distinctByOAuth({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'oAuth', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QDistinct> distinctByPrefs({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prefs', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QDistinct>
  distinctByRefreshing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'refreshing');
    });
  }

  QueryBuilder<TrackPreference, TrackPreference, QDistinct> distinctByUsername({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension TrackPreferenceQueryProperty
    on QueryBuilder<TrackPreference, TrackPreference, QQueryProperty> {
  QueryBuilder<TrackPreference, int, QQueryOperations> syncIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncId');
    });
  }

  QueryBuilder<TrackPreference, String?, QQueryOperations> oAuthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'oAuth');
    });
  }

  QueryBuilder<TrackPreference, String?, QQueryOperations> prefsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prefs');
    });
  }

  QueryBuilder<TrackPreference, bool?, QQueryOperations> refreshingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'refreshing');
    });
  }

  QueryBuilder<TrackPreference, String?, QQueryOperations> usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}
