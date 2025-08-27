// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTrackCollection on Isar {
  IsarCollection<Track> get tracks => this.collection();
}

const TrackSchema = CollectionSchema(
  name: r'Track',
  id: 6244076704169336260,
  properties: {
    r'finishedReadingDate': PropertySchema(
      id: 0,
      name: r'finishedReadingDate',
      type: IsarType.long,
    ),
    r'isManga': PropertySchema(id: 1, name: r'isManga', type: IsarType.bool),
    r'itemType': PropertySchema(
      id: 2,
      name: r'itemType',
      type: IsarType.byte,
      enumMap: _TrackitemTypeEnumValueMap,
    ),
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
    r'mangaId': PropertySchema(id: 5, name: r'mangaId', type: IsarType.long),
    r'mediaId': PropertySchema(id: 6, name: r'mediaId', type: IsarType.long),
    r'score': PropertySchema(id: 7, name: r'score', type: IsarType.long),
    r'startedReadingDate': PropertySchema(
      id: 8,
      name: r'startedReadingDate',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 9,
      name: r'status',
      type: IsarType.byte,
      enumMap: _TrackstatusEnumValueMap,
    ),
    r'syncId': PropertySchema(id: 10, name: r'syncId', type: IsarType.long),
    r'title': PropertySchema(id: 11, name: r'title', type: IsarType.string),
    r'totalChapter': PropertySchema(
      id: 12,
      name: r'totalChapter',
      type: IsarType.long,
    ),
    r'trackingUrl': PropertySchema(
      id: 13,
      name: r'trackingUrl',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.long,
    ),
  },

  estimateSize: _trackEstimateSize,
  serialize: _trackSerialize,
  deserialize: _trackDeserialize,
  deserializeProp: _trackDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _trackGetId,
  getLinks: _trackGetLinks,
  attach: _trackAttach,
  version: '3.1.0+1',
);

int _trackEstimateSize(
  Track object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
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

void _trackSerialize(
  Track object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.finishedReadingDate);
  writer.writeBool(offsets[1], object.isManga);
  writer.writeByte(offsets[2], object.itemType.index);
  writer.writeLong(offsets[3], object.lastChapterRead);
  writer.writeLong(offsets[4], object.libraryId);
  writer.writeLong(offsets[5], object.mangaId);
  writer.writeLong(offsets[6], object.mediaId);
  writer.writeLong(offsets[7], object.score);
  writer.writeLong(offsets[8], object.startedReadingDate);
  writer.writeByte(offsets[9], object.status.index);
  writer.writeLong(offsets[10], object.syncId);
  writer.writeString(offsets[11], object.title);
  writer.writeLong(offsets[12], object.totalChapter);
  writer.writeString(offsets[13], object.trackingUrl);
  writer.writeLong(offsets[14], object.updatedAt);
}

Track _trackDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Track(
    finishedReadingDate: reader.readLongOrNull(offsets[0]),
    id: id,
    isManga: reader.readBoolOrNull(offsets[1]),
    itemType:
        _TrackitemTypeValueEnumMap[reader.readByteOrNull(offsets[2])] ??
        ItemType.manga,
    lastChapterRead: reader.readLongOrNull(offsets[3]),
    libraryId: reader.readLongOrNull(offsets[4]),
    mangaId: reader.readLongOrNull(offsets[5]),
    mediaId: reader.readLongOrNull(offsets[6]),
    score: reader.readLongOrNull(offsets[7]),
    startedReadingDate: reader.readLongOrNull(offsets[8]),
    status:
        _TrackstatusValueEnumMap[reader.readByteOrNull(offsets[9])] ??
        TrackStatus.reading,
    syncId: reader.readLongOrNull(offsets[10]),
    title: reader.readStringOrNull(offsets[11]),
    totalChapter: reader.readLongOrNull(offsets[12]),
    trackingUrl: reader.readStringOrNull(offsets[13]),
    updatedAt: reader.readLongOrNull(offsets[14]),
  );
  return object;
}

P _trackDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (_TrackitemTypeValueEnumMap[reader.readByteOrNull(offset)] ??
              ItemType.manga)
          as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (_TrackstatusValueEnumMap[reader.readByteOrNull(offset)] ??
              TrackStatus.reading)
          as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TrackitemTypeEnumValueMap = {'manga': 0, 'anime': 1, 'novel': 2};
const _TrackitemTypeValueEnumMap = {
  0: ItemType.manga,
  1: ItemType.anime,
  2: ItemType.novel,
};
const _TrackstatusEnumValueMap = {
  'reading': 0,
  'completed': 1,
  'onHold': 2,
  'dropped': 3,
  'planToRead': 4,
  'reReading': 5,
  'watching': 6,
  'planToWatch': 7,
  'reWatching': 8,
};
const _TrackstatusValueEnumMap = {
  0: TrackStatus.reading,
  1: TrackStatus.completed,
  2: TrackStatus.onHold,
  3: TrackStatus.dropped,
  4: TrackStatus.planToRead,
  5: TrackStatus.reReading,
  6: TrackStatus.watching,
  7: TrackStatus.planToWatch,
  8: TrackStatus.reWatching,
};

Id _trackGetId(Track object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _trackGetLinks(Track object) {
  return [];
}

void _trackAttach(IsarCollection<dynamic> col, Id id, Track object) {
  object.id = id;
}

extension TrackQueryWhereSort on QueryBuilder<Track, Track, QWhere> {
  QueryBuilder<Track, Track, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TrackQueryWhere on QueryBuilder<Track, Track, QWhereClause> {
  QueryBuilder<Track, Track, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Track, Track, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Track, Track, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterWhereClause> idBetween(
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

extension TrackQueryFilter on QueryBuilder<Track, Track, QFilterCondition> {
  QueryBuilder<Track, Track, QAfterFilterCondition>
  finishedReadingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'finishedReadingDate'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition>
  finishedReadingDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'finishedReadingDate'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> finishedReadingDateEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'finishedReadingDate', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition>
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

  QueryBuilder<Track, Track, QAfterFilterCondition> finishedReadingDateLessThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> finishedReadingDateBetween(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> idGreaterThan(
    Id? value, {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> isMangaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isManga'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> isMangaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isManga'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> isMangaEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isManga', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> itemTypeEqualTo(
    ItemType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'itemType', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> itemTypeGreaterThan(
    ItemType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'itemType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> itemTypeLessThan(
    ItemType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'itemType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> itemTypeBetween(
    ItemType lower,
    ItemType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'itemType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> lastChapterReadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastChapterRead'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> lastChapterReadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastChapterRead'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> lastChapterReadEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastChapterRead', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> lastChapterReadGreaterThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> lastChapterReadLessThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> lastChapterReadBetween(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> libraryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryId'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> libraryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryId'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> libraryIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'libraryId', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> libraryIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> libraryIdLessThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> libraryIdBetween(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> mangaIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> mangaIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> mediaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mediaId'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> mediaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mediaId'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> mediaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mediaId', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> mediaIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> mediaIdLessThan(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> mediaIdBetween(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> scoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'score'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> scoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'score'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> scoreEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'score', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> scoreGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'score',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> scoreLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'score',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> scoreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'score',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> startedReadingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startedReadingDate'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition>
  startedReadingDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startedReadingDate'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> startedReadingDateEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startedReadingDate', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition>
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

  QueryBuilder<Track, Track, QAfterFilterCondition> startedReadingDateLessThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> startedReadingDateBetween(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> statusEqualTo(
    TrackStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> statusGreaterThan(
    TrackStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> statusLessThan(
    TrackStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> statusBetween(
    TrackStatus lower,
    TrackStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> syncIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'syncId'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> syncIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'syncId'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> syncIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncId', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> syncIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> syncIdLessThan(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> syncIdBetween(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'title'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'title'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> titleGreaterThan(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> titleContains(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> titleMatches(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> totalChapterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'totalChapter'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> totalChapterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'totalChapter'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> totalChapterEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalChapter', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> totalChapterGreaterThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> totalChapterLessThan(
    int? value, {
    bool include = false,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> totalChapterBetween(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'trackingUrl'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'trackingUrl'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlGreaterThan(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlLessThan(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlBetween(
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

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'trackingUrl', value: ''),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> trackingUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'trackingUrl', value: ''),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> updatedAtEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> updatedAtGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> updatedAtLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Track, Track, QAfterFilterCondition> updatedAtBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TrackQueryObject on QueryBuilder<Track, Track, QFilterCondition> {}

extension TrackQueryLinks on QueryBuilder<Track, Track, QFilterCondition> {}

extension TrackQuerySortBy on QueryBuilder<Track, Track, QSortBy> {
  QueryBuilder<Track, Track, QAfterSortBy> sortByFinishedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedReadingDate', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByFinishedReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedReadingDate', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByIsManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManga', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByIsMangaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManga', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByItemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByLastChapterRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterRead', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByLastChapterReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterRead', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByLibraryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryId', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByLibraryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryId', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByMediaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByMediaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByStartedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedReadingDate', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByStartedReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedReadingDate', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortBySyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByTotalChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByTotalChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByTrackingUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingUrl', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByTrackingUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingUrl', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TrackQuerySortThenBy on QueryBuilder<Track, Track, QSortThenBy> {
  QueryBuilder<Track, Track, QAfterSortBy> thenByFinishedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedReadingDate', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByFinishedReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedReadingDate', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByIsManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManga', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByIsMangaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManga', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByItemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByLastChapterRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterRead', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByLastChapterReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterRead', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByLibraryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryId', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByLibraryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryId', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByMediaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByMediaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByStartedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedReadingDate', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByStartedReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedReadingDate', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenBySyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByTotalChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByTotalChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByTrackingUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingUrl', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByTrackingUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingUrl', Sort.desc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Track, Track, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TrackQueryWhereDistinct on QueryBuilder<Track, Track, QDistinct> {
  QueryBuilder<Track, Track, QDistinct> distinctByFinishedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finishedReadingDate');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByIsManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isManga');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemType');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByLastChapterRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastChapterRead');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByLibraryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryId');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaId');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByMediaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaId');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByStartedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedReadingDate');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncId');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByTotalChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalChapter');
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByTrackingUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackingUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Track, Track, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension TrackQueryProperty on QueryBuilder<Track, Track, QQueryProperty> {
  QueryBuilder<Track, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Track, int?, QQueryOperations> finishedReadingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finishedReadingDate');
    });
  }

  QueryBuilder<Track, bool?, QQueryOperations> isMangaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isManga');
    });
  }

  QueryBuilder<Track, ItemType, QQueryOperations> itemTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemType');
    });
  }

  QueryBuilder<Track, int?, QQueryOperations> lastChapterReadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastChapterRead');
    });
  }

  QueryBuilder<Track, int?, QQueryOperations> libraryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryId');
    });
  }

  QueryBuilder<Track, int?, QQueryOperations> mangaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaId');
    });
  }

  QueryBuilder<Track, int?, QQueryOperations> mediaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaId');
    });
  }

  QueryBuilder<Track, int?, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<Track, int?, QQueryOperations> startedReadingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedReadingDate');
    });
  }

  QueryBuilder<Track, TrackStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Track, int?, QQueryOperations> syncIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncId');
    });
  }

  QueryBuilder<Track, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Track, int?, QQueryOperations> totalChapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalChapter');
    });
  }

  QueryBuilder<Track, String?, QQueryOperations> trackingUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackingUrl');
    });
  }

  QueryBuilder<Track, int?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
