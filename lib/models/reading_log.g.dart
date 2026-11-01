// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetReadingLogCollection on Isar {
  IsarCollection<ReadingLog> get readingLogs => this.collection();
}

const ReadingLogSchema = CollectionSchema(
  name: r'ReadingLog',
  id: 7493231817925098844,
  properties: {
    r'at': PropertySchema(id: 0, name: r'at', type: IsarType.long),
    r'chapterId': PropertySchema(
      id: 1,
      name: r'chapterId',
      type: IsarType.long,
    ),
    r'itemType': PropertySchema(
      id: 2,
      name: r'itemType',
      type: IsarType.byte,
      enumMap: _ReadingLogitemTypeEnumValueMap,
    ),
    r'kind': PropertySchema(
      id: 3,
      name: r'kind',
      type: IsarType.byte,
      enumMap: _ReadingLogkindEnumValueMap,
    ),
    r'mangaId': PropertySchema(id: 4, name: r'mangaId', type: IsarType.long),
    r'seconds': PropertySchema(id: 5, name: r'seconds', type: IsarType.long),
  },

  estimateSize: _readingLogEstimateSize,
  serialize: _readingLogSerialize,
  deserialize: _readingLogDeserialize,
  deserializeProp: _readingLogDeserializeProp,
  idName: r'id',
  indexes: {
    r'mangaId': IndexSchema(
      id: 7466570075891278896,
      name: r'mangaId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mangaId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'itemType': IndexSchema(
      id: 4177129349728551858,
      name: r'itemType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'itemType',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'at': IndexSchema(
      id: 1454144528255648370,
      name: r'at',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'at',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _readingLogGetId,
  getLinks: _readingLogGetLinks,
  attach: _readingLogAttach,
  version: '3.4.1',
);

int _readingLogEstimateSize(
  ReadingLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _readingLogSerialize(
  ReadingLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.at);
  writer.writeLong(offsets[1], object.chapterId);
  writer.writeByte(offsets[2], object.itemType.index);
  writer.writeByte(offsets[3], object.kind.index);
  writer.writeLong(offsets[4], object.mangaId);
  writer.writeLong(offsets[5], object.seconds);
}

ReadingLog _readingLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingLog(
    at: reader.readLong(offsets[0]),
    chapterId: reader.readLongOrNull(offsets[1]),
    id: id,
    itemType:
        _ReadingLogitemTypeValueEnumMap[reader.readByteOrNull(offsets[2])] ??
        ItemType.manga,
    kind:
        _ReadingLogkindValueEnumMap[reader.readByteOrNull(offsets[3])] ??
        ReadingLogKind.time,
    mangaId: reader.readLongOrNull(offsets[4]),
    seconds: reader.readLongOrNull(offsets[5]) ?? 0,
  );
  return object;
}

P _readingLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (_ReadingLogitemTypeValueEnumMap[reader.readByteOrNull(offset)] ??
              ItemType.manga)
          as P;
    case 3:
      return (_ReadingLogkindValueEnumMap[reader.readByteOrNull(offset)] ??
              ReadingLogKind.time)
          as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ReadingLogitemTypeEnumValueMap = {'manga': 0, 'anime': 1, 'novel': 2};
const _ReadingLogitemTypeValueEnumMap = {
  0: ItemType.manga,
  1: ItemType.anime,
  2: ItemType.novel,
};
const _ReadingLogkindEnumValueMap = {'time': 0, 'completion': 1};
const _ReadingLogkindValueEnumMap = {
  0: ReadingLogKind.time,
  1: ReadingLogKind.completion,
};

Id _readingLogGetId(ReadingLog object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _readingLogGetLinks(ReadingLog object) {
  return [];
}

void _readingLogAttach(IsarCollection<dynamic> col, Id id, ReadingLog object) {
  object.id = id;
}

extension ReadingLogQueryWhereSort
    on QueryBuilder<ReadingLog, ReadingLog, QWhere> {
  QueryBuilder<ReadingLog, ReadingLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhere> anyMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'mangaId'),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhere> anyItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'itemType'),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhere> anyAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IndexWhereClause.any(indexName: r'at'));
    });
  }
}

extension ReadingLogQueryWhere
    on QueryBuilder<ReadingLog, ReadingLog, QWhereClause> {
  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> idBetween(
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

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'mangaId', value: [null]),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'mangaId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> mangaIdEqualTo(
    int? mangaId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'mangaId', value: [mangaId]),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> mangaIdNotEqualTo(
    int? mangaId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mangaId',
                lower: [],
                upper: [mangaId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mangaId',
                lower: [mangaId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mangaId',
                lower: [mangaId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mangaId',
                lower: [],
                upper: [mangaId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> mangaIdGreaterThan(
    int? mangaId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'mangaId',
          lower: [mangaId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> mangaIdLessThan(
    int? mangaId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'mangaId',
          lower: [],
          upper: [mangaId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> mangaIdBetween(
    int? lowerMangaId,
    int? upperMangaId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'mangaId',
          lower: [lowerMangaId],
          includeLower: includeLower,
          upper: [upperMangaId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> itemTypeEqualTo(
    ItemType itemType,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'itemType', value: [itemType]),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> itemTypeNotEqualTo(
    ItemType itemType,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'itemType',
                lower: [],
                upper: [itemType],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'itemType',
                lower: [itemType],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'itemType',
                lower: [itemType],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'itemType',
                lower: [],
                upper: [itemType],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> itemTypeGreaterThan(
    ItemType itemType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'itemType',
          lower: [itemType],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> itemTypeLessThan(
    ItemType itemType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'itemType',
          lower: [],
          upper: [itemType],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> itemTypeBetween(
    ItemType lowerItemType,
    ItemType upperItemType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'itemType',
          lower: [lowerItemType],
          includeLower: includeLower,
          upper: [upperItemType],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> atEqualTo(int at) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'at', value: [at]),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> atNotEqualTo(int at) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'at',
                lower: [],
                upper: [at],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'at',
                lower: [at],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'at',
                lower: [at],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'at',
                lower: [],
                upper: [at],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> atGreaterThan(
    int at, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'at',
          lower: [at],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> atLessThan(
    int at, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'at',
          lower: [],
          upper: [at],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterWhereClause> atBetween(
    int lowerAt,
    int upperAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'at',
          lower: [lowerAt],
          includeLower: includeLower,
          upper: [upperAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ReadingLogQueryFilter
    on QueryBuilder<ReadingLog, ReadingLog, QFilterCondition> {
  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> atEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'at', value: value),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> atGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'at',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> atLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'at',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> atBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'at',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition>
  chapterIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterId'),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition>
  chapterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterId'),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> chapterIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chapterId', value: value),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition>
  chapterIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> chapterIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> chapterIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chapterId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> idEqualTo(
    Id? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> itemTypeEqualTo(
    ItemType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'itemType', value: value),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition>
  itemTypeGreaterThan(ItemType value, {bool include = false}) {
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

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> itemTypeLessThan(
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

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> itemTypeBetween(
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

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> kindEqualTo(
    ReadingLogKind value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'kind', value: value),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> kindGreaterThan(
    ReadingLogKind value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'kind',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> kindLessThan(
    ReadingLogKind value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'kind',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> kindBetween(
    ReadingLogKind lower,
    ReadingLogKind upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'kind',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> mangaIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
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

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> mangaIdLessThan(
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

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> mangaIdBetween(
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

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> secondsEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'seconds', value: value),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition>
  secondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'seconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> secondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'seconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterFilterCondition> secondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'seconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ReadingLogQueryObject
    on QueryBuilder<ReadingLog, ReadingLog, QFilterCondition> {}

extension ReadingLogQueryLinks
    on QueryBuilder<ReadingLog, ReadingLog, QFilterCondition> {}

extension ReadingLogQuerySortBy
    on QueryBuilder<ReadingLog, ReadingLog, QSortBy> {
  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortByAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.desc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortByChapterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.desc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortByItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortByItemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.desc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortBySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seconds', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> sortBySecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seconds', Sort.desc);
    });
  }
}

extension ReadingLogQuerySortThenBy
    on QueryBuilder<ReadingLog, ReadingLog, QSortThenBy> {
  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenByAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.desc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenByChapterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.desc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenByItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenByItemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.desc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenBySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seconds', Sort.asc);
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QAfterSortBy> thenBySecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seconds', Sort.desc);
    });
  }
}

extension ReadingLogQueryWhereDistinct
    on QueryBuilder<ReadingLog, ReadingLog, QDistinct> {
  QueryBuilder<ReadingLog, ReadingLog, QDistinct> distinctByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'at');
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QDistinct> distinctByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterId');
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QDistinct> distinctByItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemType');
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QDistinct> distinctByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kind');
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QDistinct> distinctByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaId');
    });
  }

  QueryBuilder<ReadingLog, ReadingLog, QDistinct> distinctBySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seconds');
    });
  }
}

extension ReadingLogQueryProperty
    on QueryBuilder<ReadingLog, ReadingLog, QQueryProperty> {
  QueryBuilder<ReadingLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReadingLog, int, QQueryOperations> atProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'at');
    });
  }

  QueryBuilder<ReadingLog, int?, QQueryOperations> chapterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterId');
    });
  }

  QueryBuilder<ReadingLog, ItemType, QQueryOperations> itemTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemType');
    });
  }

  QueryBuilder<ReadingLog, ReadingLogKind, QQueryOperations> kindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kind');
    });
  }

  QueryBuilder<ReadingLog, int?, QQueryOperations> mangaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaId');
    });
  }

  QueryBuilder<ReadingLog, int, QQueryOperations> secondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seconds');
    });
  }
}
