// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker_library_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTrackerLibraryCacheCollection on Isar {
  IsarCollection<TrackerLibraryCache> get trackerLibraryCaches =>
      this.collection();
}

const TrackerLibraryCacheSchema = CollectionSchema(
  name: r'Tracker Library Cache',
  id: 5954674730608738374,
  properties: {
    r'key': PropertySchema(id: 0, name: r'key', type: IsarType.string),
    r'tracks': PropertySchema(
      id: 1,
      name: r'tracks',
      type: IsarType.objectList,

      target: r'TrackSearch',
    ),
  },

  estimateSize: _trackerLibraryCacheEstimateSize,
  serialize: _trackerLibraryCacheSerialize,
  deserialize: _trackerLibraryCacheDeserialize,
  deserializeProp: _trackerLibraryCacheDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'TrackSearch': TrackSearchSchema},

  getId: _trackerLibraryCacheGetId,
  getLinks: _trackerLibraryCacheGetLinks,
  attach: _trackerLibraryCacheAttach,
  version: '3.3.2',
);

int _trackerLibraryCacheEstimateSize(
  TrackerLibraryCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.tracks.length * 3;
  {
    final offsets = allOffsets[TrackSearch]!;
    for (var i = 0; i < object.tracks.length; i++) {
      final value = object.tracks[i];
      bytesCount += TrackSearchSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _trackerLibraryCacheSerialize(
  TrackerLibraryCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeObjectList<TrackSearch>(
    offsets[1],
    allOffsets,
    TrackSearchSchema.serialize,
    object.tracks,
  );
}

TrackerLibraryCache _trackerLibraryCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrackerLibraryCache();
  object.key = reader.readString(offsets[0]);
  object.tracks =
      reader.readObjectList<TrackSearch>(
        offsets[1],
        TrackSearchSchema.deserialize,
        allOffsets,
        TrackSearch(),
      ) ??
      [];
  return object;
}

P _trackerLibraryCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readObjectList<TrackSearch>(
                offset,
                TrackSearchSchema.deserialize,
                allOffsets,
                TrackSearch(),
              ) ??
              [])
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _trackerLibraryCacheGetId(TrackerLibraryCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _trackerLibraryCacheGetLinks(
  TrackerLibraryCache object,
) {
  return [];
}

void _trackerLibraryCacheAttach(
  IsarCollection<dynamic> col,
  Id id,
  TrackerLibraryCache object,
) {}

extension TrackerLibraryCacheQueryWhereSort
    on QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QWhere> {
  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TrackerLibraryCacheQueryWhere
    on QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QWhereClause> {
  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TrackerLibraryCacheQueryFilter
    on
        QueryBuilder<
          TrackerLibraryCache,
          TrackerLibraryCache,
          QFilterCondition
        > {
  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  keyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  keyLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'key',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  keyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  keyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'key',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  tracksLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tracks', length, true, length, true);
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  tracksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tracks', 0, true, 0, true);
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  tracksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tracks', 0, false, 999999, true);
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  tracksLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tracks', 0, true, length, include);
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  tracksLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tracks', length, include, 999999, true);
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  tracksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tracks',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension TrackerLibraryCacheQueryObject
    on
        QueryBuilder<
          TrackerLibraryCache,
          TrackerLibraryCache,
          QFilterCondition
        > {
  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterFilterCondition>
  tracksElement(FilterQuery<TrackSearch> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'tracks');
    });
  }
}

extension TrackerLibraryCacheQueryLinks
    on
        QueryBuilder<
          TrackerLibraryCache,
          TrackerLibraryCache,
          QFilterCondition
        > {}

extension TrackerLibraryCacheQuerySortBy
    on QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QSortBy> {
  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterSortBy>
  sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterSortBy>
  sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }
}

extension TrackerLibraryCacheQuerySortThenBy
    on QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QSortThenBy> {
  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterSortBy>
  thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QAfterSortBy>
  thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }
}

extension TrackerLibraryCacheQueryWhereDistinct
    on QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QDistinct> {
  QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QDistinct>
  distinctByKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }
}

extension TrackerLibraryCacheQueryProperty
    on QueryBuilder<TrackerLibraryCache, TrackerLibraryCache, QQueryProperty> {
  QueryBuilder<TrackerLibraryCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TrackerLibraryCache, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<TrackerLibraryCache, List<TrackSearch>, QQueryOperations>
  tracksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tracks');
    });
  }
}
