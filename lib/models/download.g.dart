// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadCollection on Isar {
  IsarCollection<Download> get downloads => this.collection();
}

const DownloadSchema = CollectionSchema(
  name: r'Download',
  id: 5905484153212786579,
  properties: {
    r'failed': PropertySchema(id: 0, name: r'failed', type: IsarType.long),
    r'isDownload': PropertySchema(
      id: 1,
      name: r'isDownload',
      type: IsarType.bool,
    ),
    r'isStartDownload': PropertySchema(
      id: 2,
      name: r'isStartDownload',
      type: IsarType.bool,
    ),
    r'succeeded': PropertySchema(
      id: 3,
      name: r'succeeded',
      type: IsarType.long,
    ),
    r'total': PropertySchema(id: 4, name: r'total', type: IsarType.long),
  },

  estimateSize: _downloadEstimateSize,
  serialize: _downloadSerialize,
  deserialize: _downloadDeserialize,
  deserializeProp: _downloadDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'chapter': LinkSchema(
      id: -5548652258422470046,
      name: r'chapter',
      target: r'Chapter',
      single: true,
    ),
  },
  embeddedSchemas: {},

  getId: _downloadGetId,
  getLinks: _downloadGetLinks,
  attach: _downloadAttach,
  version: '3.1.0+1',
);

int _downloadEstimateSize(
  Download object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _downloadSerialize(
  Download object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.failed);
  writer.writeBool(offsets[1], object.isDownload);
  writer.writeBool(offsets[2], object.isStartDownload);
  writer.writeLong(offsets[3], object.succeeded);
  writer.writeLong(offsets[4], object.total);
}

Download _downloadDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Download(
    failed: reader.readLongOrNull(offsets[0]),
    id: id,
    isDownload: reader.readBoolOrNull(offsets[1]),
    isStartDownload: reader.readBoolOrNull(offsets[2]),
    succeeded: reader.readLongOrNull(offsets[3]),
    total: reader.readLongOrNull(offsets[4]),
  );
  return object;
}

P _downloadDeserializeProp<P>(
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
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _downloadGetId(Download object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _downloadGetLinks(Download object) {
  return [object.chapter];
}

void _downloadAttach(IsarCollection<dynamic> col, Id id, Download object) {
  object.id = id;
  object.chapter.attach(col, col.isar.collection<Chapter>(), r'chapter', id);
}

extension DownloadQueryWhereSort on QueryBuilder<Download, Download, QWhere> {
  QueryBuilder<Download, Download, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DownloadQueryWhere on QueryBuilder<Download, Download, QWhereClause> {
  QueryBuilder<Download, Download, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Download, Download, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Download, Download, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterWhereClause> idBetween(
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

extension DownloadQueryFilter
    on QueryBuilder<Download, Download, QFilterCondition> {
  QueryBuilder<Download, Download, QAfterFilterCondition> failedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'failed'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> failedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'failed'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> failedEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'failed', value: value),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> failedGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'failed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> failedLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'failed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> failedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'failed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Download, Download, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Download, Download, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Download, Download, QAfterFilterCondition> isDownloadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isDownload'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
  isDownloadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isDownload'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> isDownloadEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isDownload', value: value),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
  isStartDownloadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isStartDownload'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
  isStartDownloadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isStartDownload'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition>
  isStartDownloadEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isStartDownload', value: value),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> succeededIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'succeeded'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> succeededIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'succeeded'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> succeededEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'succeeded', value: value),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> succeededGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'succeeded',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> succeededLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'succeeded',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> succeededBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'succeeded',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> totalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'total'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> totalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'total'),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> totalEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'total', value: value),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> totalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'total',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> totalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'total',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> totalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'total',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DownloadQueryObject
    on QueryBuilder<Download, Download, QFilterCondition> {}

extension DownloadQueryLinks
    on QueryBuilder<Download, Download, QFilterCondition> {
  QueryBuilder<Download, Download, QAfterFilterCondition> chapter(
    FilterQuery<Chapter> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'chapter');
    });
  }

  QueryBuilder<Download, Download, QAfterFilterCondition> chapterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'chapter', 0, true, 0, true);
    });
  }
}

extension DownloadQuerySortBy on QueryBuilder<Download, Download, QSortBy> {
  QueryBuilder<Download, Download, QAfterSortBy> sortByFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failed', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failed', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByIsDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownload', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByIsDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownload', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByIsStartDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStartDownload', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByIsStartDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStartDownload', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortBySucceeded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'succeeded', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortBySucceededDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'succeeded', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> sortByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }
}

extension DownloadQuerySortThenBy
    on QueryBuilder<Download, Download, QSortThenBy> {
  QueryBuilder<Download, Download, QAfterSortBy> thenByFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failed', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failed', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByIsDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownload', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByIsDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDownload', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByIsStartDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStartDownload', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByIsStartDownloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStartDownload', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenBySucceeded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'succeeded', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenBySucceededDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'succeeded', Sort.desc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.asc);
    });
  }

  QueryBuilder<Download, Download, QAfterSortBy> thenByTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'total', Sort.desc);
    });
  }
}

extension DownloadQueryWhereDistinct
    on QueryBuilder<Download, Download, QDistinct> {
  QueryBuilder<Download, Download, QDistinct> distinctByFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'failed');
    });
  }

  QueryBuilder<Download, Download, QDistinct> distinctByIsDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDownload');
    });
  }

  QueryBuilder<Download, Download, QDistinct> distinctByIsStartDownload() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isStartDownload');
    });
  }

  QueryBuilder<Download, Download, QDistinct> distinctBySucceeded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'succeeded');
    });
  }

  QueryBuilder<Download, Download, QDistinct> distinctByTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'total');
    });
  }
}

extension DownloadQueryProperty
    on QueryBuilder<Download, Download, QQueryProperty> {
  QueryBuilder<Download, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Download, int?, QQueryOperations> failedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'failed');
    });
  }

  QueryBuilder<Download, bool?, QQueryOperations> isDownloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDownload');
    });
  }

  QueryBuilder<Download, bool?, QQueryOperations> isStartDownloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isStartDownload');
    });
  }

  QueryBuilder<Download, int?, QQueryOperations> succeededProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'succeeded');
    });
  }

  QueryBuilder<Download, int?, QQueryOperations> totalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'total');
    });
  }
}
