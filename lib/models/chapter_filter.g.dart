// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_filter.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChaptersFilterCollection on Isar {
  IsarCollection<ChaptersFilter> get chaptersFilters => this.collection();
}

const ChaptersFilterSchema = CollectionSchema(
  name: r'ChaptersFilter',
  id: -1016921506623071712,
  properties: {
    r'bookmarked': PropertySchema(
      id: 0,
      name: r'bookmarked',
      type: IsarType.long,
    ),
    r'downloaded': PropertySchema(
      id: 1,
      name: r'downloaded',
      type: IsarType.long,
    ),
    r'unread': PropertySchema(
      id: 2,
      name: r'unread',
      type: IsarType.long,
    )
  },
  estimateSize: _chaptersFilterEstimateSize,
  serialize: _chaptersFilterSerialize,
  deserialize: _chaptersFilterDeserialize,
  deserializeProp: _chaptersFilterDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'manga': LinkSchema(
      id: -1307930859387237185,
      name: r'manga',
      target: r'Manga',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _chaptersFilterGetId,
  getLinks: _chaptersFilterGetLinks,
  attach: _chaptersFilterAttach,
  version: '3.1.0+1',
);

int _chaptersFilterEstimateSize(
  ChaptersFilter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _chaptersFilterSerialize(
  ChaptersFilter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bookmarked);
  writer.writeLong(offsets[1], object.downloaded);
  writer.writeLong(offsets[2], object.unread);
}

ChaptersFilter _chaptersFilterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChaptersFilter(
    bookmarked: reader.readLongOrNull(offsets[0]),
    downloaded: reader.readLongOrNull(offsets[1]),
    id: id,
    unread: reader.readLongOrNull(offsets[2]),
  );
  return object;
}

P _chaptersFilterDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _chaptersFilterGetId(ChaptersFilter object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _chaptersFilterGetLinks(ChaptersFilter object) {
  return [object.manga];
}

void _chaptersFilterAttach(
    IsarCollection<dynamic> col, Id id, ChaptersFilter object) {
  object.id = id;
  object.manga.attach(col, col.isar.collection<Manga>(), r'manga', id);
}

extension ChaptersFilterQueryWhereSort
    on QueryBuilder<ChaptersFilter, ChaptersFilter, QWhere> {
  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChaptersFilterQueryWhere
    on QueryBuilder<ChaptersFilter, ChaptersFilter, QWhereClause> {
  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChaptersFilterQueryFilter
    on QueryBuilder<ChaptersFilter, ChaptersFilter, QFilterCondition> {
  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      bookmarkedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bookmarked',
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      bookmarkedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bookmarked',
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      bookmarkedEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookmarked',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      bookmarkedGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookmarked',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      bookmarkedLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookmarked',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      bookmarkedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookmarked',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      downloadedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'downloaded',
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      downloadedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'downloaded',
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      downloadedEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      downloadedGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      downloadedLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloaded',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      downloadedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloaded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      unreadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'unread',
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      unreadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'unread',
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      unreadEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unread',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      unreadGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unread',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      unreadLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unread',
        value: value,
      ));
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      unreadBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unread',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChaptersFilterQueryObject
    on QueryBuilder<ChaptersFilter, ChaptersFilter, QFilterCondition> {}

extension ChaptersFilterQueryLinks
    on QueryBuilder<ChaptersFilter, ChaptersFilter, QFilterCondition> {
  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition> manga(
      FilterQuery<Manga> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'manga');
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterFilterCondition>
      mangaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'manga', 0, true, 0, true);
    });
  }
}

extension ChaptersFilterQuerySortBy
    on QueryBuilder<ChaptersFilter, ChaptersFilter, QSortBy> {
  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy>
      sortByBookmarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarked', Sort.asc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy>
      sortByBookmarkedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarked', Sort.desc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy>
      sortByDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.asc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy>
      sortByDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.desc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy> sortByUnread() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.asc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy>
      sortByUnreadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.desc);
    });
  }
}

extension ChaptersFilterQuerySortThenBy
    on QueryBuilder<ChaptersFilter, ChaptersFilter, QSortThenBy> {
  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy>
      thenByBookmarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarked', Sort.asc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy>
      thenByBookmarkedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarked', Sort.desc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy>
      thenByDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.asc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy>
      thenByDownloadedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloaded', Sort.desc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy> thenByUnread() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.asc);
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QAfterSortBy>
      thenByUnreadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unread', Sort.desc);
    });
  }
}

extension ChaptersFilterQueryWhereDistinct
    on QueryBuilder<ChaptersFilter, ChaptersFilter, QDistinct> {
  QueryBuilder<ChaptersFilter, ChaptersFilter, QDistinct>
      distinctByBookmarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookmarked');
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QDistinct>
      distinctByDownloaded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloaded');
    });
  }

  QueryBuilder<ChaptersFilter, ChaptersFilter, QDistinct> distinctByUnread() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unread');
    });
  }
}

extension ChaptersFilterQueryProperty
    on QueryBuilder<ChaptersFilter, ChaptersFilter, QQueryProperty> {
  QueryBuilder<ChaptersFilter, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChaptersFilter, int?, QQueryOperations> bookmarkedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookmarked');
    });
  }

  QueryBuilder<ChaptersFilter, int?, QQueryOperations> downloadedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloaded');
    });
  }

  QueryBuilder<ChaptersFilter, int?, QQueryOperations> unreadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unread');
    });
  }
}
