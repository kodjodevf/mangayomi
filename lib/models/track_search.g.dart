// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_search.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TrackSearchSchema = Schema(
  name: r'TrackSearch',
  id: 7335576978136013571,
  properties: {
    r'coverUrl': PropertySchema(
      id: 0,
      name: r'coverUrl',
      type: IsarType.string,
    ),
    r'finishedReadingDate': PropertySchema(
      id: 1,
      name: r'finishedReadingDate',
      type: IsarType.long,
    ),
    r'id': PropertySchema(id: 2, name: r'id', type: IsarType.long),
    r'lastChapterRead': PropertySchema(
      id: 3,
      name: r'lastChapterRead',
      type: IsarType.long,
    ),
    r'libraryId': PropertySchema(
      id: 4,
      name: r'libraryId',
      type: IsarType.long,
    ),
    r'mediaId': PropertySchema(id: 5, name: r'mediaId', type: IsarType.long),
    r'publishingStatus': PropertySchema(
      id: 6,
      name: r'publishingStatus',
      type: IsarType.string,
    ),
    r'publishingType': PropertySchema(
      id: 7,
      name: r'publishingType',
      type: IsarType.string,
    ),
    r'score': PropertySchema(id: 8, name: r'score', type: IsarType.double),
    r'startDate': PropertySchema(
      id: 9,
      name: r'startDate',
      type: IsarType.string,
    ),
    r'startedReadingDate': PropertySchema(
      id: 10,
      name: r'startedReadingDate',
      type: IsarType.long,
    ),
    r'status': PropertySchema(id: 11, name: r'status', type: IsarType.string),
    r'summary': PropertySchema(id: 12, name: r'summary', type: IsarType.string),
    r'syncId': PropertySchema(id: 13, name: r'syncId', type: IsarType.long),
    r'title': PropertySchema(id: 14, name: r'title', type: IsarType.string),
    r'totalChapter': PropertySchema(
      id: 15,
      name: r'totalChapter',
      type: IsarType.long,
    ),
    r'trackingUrl': PropertySchema(
      id: 16,
      name: r'trackingUrl',
      type: IsarType.string,
    ),
  },

  estimateSize: _trackSearchEstimateSize,
  serialize: _trackSearchSerialize,
  deserialize: _trackSearchDeserialize,
  deserializeProp: _trackSearchDeserializeProp,
);

int _trackSearchEstimateSize(
  TrackSearch object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.coverUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.publishingStatus;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.publishingType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.startDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.status;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.summary;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.trackingUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _trackSearchSerialize(
  TrackSearch object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.coverUrl);
  writer.writeLong(offsets[1], object.finishedReadingDate);
  writer.writeLong(offsets[2], object.id);
  writer.writeLong(offsets[3], object.lastChapterRead);
  writer.writeLong(offsets[4], object.libraryId);
  writer.writeLong(offsets[5], object.mediaId);
  writer.writeString(offsets[6], object.publishingStatus);
  writer.writeString(offsets[7], object.publishingType);
  writer.writeDouble(offsets[8], object.score);
  writer.writeString(offsets[9], object.startDate);
  writer.writeLong(offsets[10], object.startedReadingDate);
  writer.writeString(offsets[11], object.status);
  writer.writeString(offsets[12], object.summary);
  writer.writeLong(offsets[13], object.syncId);
  writer.writeString(offsets[14], object.title);
  writer.writeLong(offsets[15], object.totalChapter);
  writer.writeString(offsets[16], object.trackingUrl);
}

TrackSearch _trackSearchDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrackSearch(
    coverUrl: reader.readStringOrNull(offsets[0]),
    finishedReadingDate: reader.readLongOrNull(offsets[1]),
    id: reader.readLongOrNull(offsets[2]),
    lastChapterRead: reader.readLongOrNull(offsets[3]),
    libraryId: reader.readLongOrNull(offsets[4]),
    mediaId: reader.readLongOrNull(offsets[5]),
    publishingStatus: reader.readStringOrNull(offsets[6]),
    publishingType: reader.readStringOrNull(offsets[7]),
    score: reader.readDoubleOrNull(offsets[8]),
    startDate: reader.readStringOrNull(offsets[9]),
    startedReadingDate: reader.readLongOrNull(offsets[10]),
    status: reader.readStringOrNull(offsets[11]),
    summary: reader.readStringOrNull(offsets[12]),
    syncId: reader.readLongOrNull(offsets[13]),
    title: reader.readStringOrNull(offsets[14]),
    totalChapter: reader.readLongOrNull(offsets[15]),
    trackingUrl: reader.readStringOrNull(offsets[16]),
  );
  return object;
}

P _trackSearchDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TrackSearchQueryFilter
    on QueryBuilder<TrackSearch, TrackSearch, QFilterCondition> {
  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'coverUrl'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'coverUrl'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> coverUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> coverUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coverUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> coverUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'coverUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coverUrl', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'coverUrl', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'finishedReadingDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'finishedReadingDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'finishedReadingDate', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'finishedReadingDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'finishedReadingDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'finishedReadingDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastChapterRead'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastChapterRead'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastChapterRead', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastChapterRead',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastChapterRead',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastChapterRead',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'libraryId', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  mediaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mediaId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  mediaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mediaId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> mediaIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mediaId', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  mediaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mediaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> mediaIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mediaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> mediaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mediaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'publishingStatus'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'publishingStatus'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'publishingStatus',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'publishingStatus',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'publishingStatus', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'publishingStatus', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'publishingType'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'publishingType'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'publishingType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'publishingType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'publishingType', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'publishingType', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> scoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'score'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  scoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'score'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> scoreEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'score',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  scoreGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'score',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> scoreLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'score',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> scoreBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'score',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'startDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startDate', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'startDate', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startedReadingDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startedReadingDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startedReadingDate', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startedReadingDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startedReadingDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startedReadingDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'status'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'status'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  statusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  statusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'summary',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'summary',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> syncIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'syncId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  syncIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'syncId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> syncIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncId', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  syncIdGreaterThan(int? value, {bool include = false}) {
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

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> syncIdLessThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> syncIdBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'title'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'title'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'totalChapter'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'totalChapter'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalChapter', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalChapter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalChapter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalChapter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'trackingUrl'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'trackingUrl'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'trackingUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'trackingUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'trackingUrl', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'trackingUrl', value: ''),
      );
    });
  }
}

extension TrackSearchQueryObject
    on QueryBuilder<TrackSearch, TrackSearch, QFilterCondition> {}
