// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changed_items.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChangedItemsCollection on Isar {
  IsarCollection<ChangedItems> get changedItems => this.collection();
}

const ChangedItemsSchema = CollectionSchema(
  name: r'Changed Items',
  id: 5738738771983667580,
  properties: {
    r'deletedCategories': PropertySchema(
      id: 0,
      name: r'deletedCategories',
      type: IsarType.objectList,
      target: r'DeletedCategory',
    ),
    r'deletedMangas': PropertySchema(
      id: 1,
      name: r'deletedMangas',
      type: IsarType.objectList,
      target: r'DeletedManga',
    ),
    r'updatedChapters': PropertySchema(
      id: 2,
      name: r'updatedChapters',
      type: IsarType.objectList,
      target: r'UpdatedChapter',
    )
  },
  estimateSize: _changedItemsEstimateSize,
  serialize: _changedItemsSerialize,
  deserialize: _changedItemsDeserialize,
  deserializeProp: _changedItemsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'DeletedManga': DeletedMangaSchema,
    r'UpdatedChapter': UpdatedChapterSchema,
    r'DeletedCategory': DeletedCategorySchema
  },
  getId: _changedItemsGetId,
  getLinks: _changedItemsGetLinks,
  attach: _changedItemsAttach,
  version: '3.1.0+1',
);

int _changedItemsEstimateSize(
  ChangedItems object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.deletedCategories;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[DeletedCategory]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              DeletedCategorySchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.deletedMangas;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[DeletedManga]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              DeletedMangaSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.updatedChapters;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[UpdatedChapter]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              UpdatedChapterSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  return bytesCount;
}

void _changedItemsSerialize(
  ChangedItems object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<DeletedCategory>(
    offsets[0],
    allOffsets,
    DeletedCategorySchema.serialize,
    object.deletedCategories,
  );
  writer.writeObjectList<DeletedManga>(
    offsets[1],
    allOffsets,
    DeletedMangaSchema.serialize,
    object.deletedMangas,
  );
  writer.writeObjectList<UpdatedChapter>(
    offsets[2],
    allOffsets,
    UpdatedChapterSchema.serialize,
    object.updatedChapters,
  );
}

ChangedItems _changedItemsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChangedItems(
    deletedCategories: reader.readObjectList<DeletedCategory>(
      offsets[0],
      DeletedCategorySchema.deserialize,
      allOffsets,
      DeletedCategory(),
    ),
    deletedMangas: reader.readObjectList<DeletedManga>(
      offsets[1],
      DeletedMangaSchema.deserialize,
      allOffsets,
      DeletedManga(),
    ),
    id: id,
    updatedChapters: reader.readObjectList<UpdatedChapter>(
      offsets[2],
      UpdatedChapterSchema.deserialize,
      allOffsets,
      UpdatedChapter(),
    ),
  );
  return object;
}

P _changedItemsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<DeletedCategory>(
        offset,
        DeletedCategorySchema.deserialize,
        allOffsets,
        DeletedCategory(),
      )) as P;
    case 1:
      return (reader.readObjectList<DeletedManga>(
        offset,
        DeletedMangaSchema.deserialize,
        allOffsets,
        DeletedManga(),
      )) as P;
    case 2:
      return (reader.readObjectList<UpdatedChapter>(
        offset,
        UpdatedChapterSchema.deserialize,
        allOffsets,
        UpdatedChapter(),
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _changedItemsGetId(ChangedItems object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _changedItemsGetLinks(ChangedItems object) {
  return [];
}

void _changedItemsAttach(
    IsarCollection<dynamic> col, Id id, ChangedItems object) {
  object.id = id;
}

extension ChangedItemsQueryWhereSort
    on QueryBuilder<ChangedItems, ChangedItems, QWhere> {
  QueryBuilder<ChangedItems, ChangedItems, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChangedItemsQueryWhere
    on QueryBuilder<ChangedItems, ChangedItems, QWhereClause> {
  QueryBuilder<ChangedItems, ChangedItems, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ChangedItems, ChangedItems, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterWhereClause> idBetween(
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

extension ChangedItemsQueryFilter
    on QueryBuilder<ChangedItems, ChangedItems, QFilterCondition> {
  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedCategoriesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedCategories',
      ));
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedCategoriesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedCategories',
      ));
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedCategoriesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedCategories',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedCategoriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedCategories',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedCategoriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedCategories',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedCategoriesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedCategories',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedCategoriesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedCategories',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedCategoriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedCategories',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedMangasIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedMangas',
      ));
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedMangasIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedMangas',
      ));
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedMangasLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedMangas',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedMangasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedMangas',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedMangasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedMangas',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedMangasLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedMangas',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedMangasLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedMangas',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedMangasLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'deletedMangas',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      updatedChaptersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedChapters',
      ));
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      updatedChaptersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedChapters',
      ));
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      updatedChaptersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'updatedChapters',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      updatedChaptersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'updatedChapters',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      updatedChaptersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'updatedChapters',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      updatedChaptersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'updatedChapters',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      updatedChaptersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'updatedChapters',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      updatedChaptersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'updatedChapters',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ChangedItemsQueryObject
    on QueryBuilder<ChangedItems, ChangedItems, QFilterCondition> {
  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedCategoriesElement(FilterQuery<DeletedCategory> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'deletedCategories');
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      deletedMangasElement(FilterQuery<DeletedManga> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'deletedMangas');
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterFilterCondition>
      updatedChaptersElement(FilterQuery<UpdatedChapter> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'updatedChapters');
    });
  }
}

extension ChangedItemsQueryLinks
    on QueryBuilder<ChangedItems, ChangedItems, QFilterCondition> {}

extension ChangedItemsQuerySortBy
    on QueryBuilder<ChangedItems, ChangedItems, QSortBy> {}

extension ChangedItemsQuerySortThenBy
    on QueryBuilder<ChangedItems, ChangedItems, QSortThenBy> {
  QueryBuilder<ChangedItems, ChangedItems, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChangedItems, ChangedItems, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ChangedItemsQueryWhereDistinct
    on QueryBuilder<ChangedItems, ChangedItems, QDistinct> {}

extension ChangedItemsQueryProperty
    on QueryBuilder<ChangedItems, ChangedItems, QQueryProperty> {
  QueryBuilder<ChangedItems, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChangedItems, List<DeletedCategory>?, QQueryOperations>
      deletedCategoriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedCategories');
    });
  }

  QueryBuilder<ChangedItems, List<DeletedManga>?, QQueryOperations>
      deletedMangasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedMangas');
    });
  }

  QueryBuilder<ChangedItems, List<UpdatedChapter>?, QQueryOperations>
      updatedChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedChapters');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DeletedMangaSchema = Schema(
  name: r'DeletedManga',
  id: -4943524126252993118,
  properties: {
    r'mangaId': PropertySchema(
      id: 0,
      name: r'mangaId',
      type: IsarType.long,
    )
  },
  estimateSize: _deletedMangaEstimateSize,
  serialize: _deletedMangaSerialize,
  deserialize: _deletedMangaDeserialize,
  deserializeProp: _deletedMangaDeserializeProp,
);

int _deletedMangaEstimateSize(
  DeletedManga object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _deletedMangaSerialize(
  DeletedManga object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
}

DeletedManga _deletedMangaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DeletedManga(
    mangaId: reader.readLongOrNull(offsets[0]),
  );
  return object;
}

P _deletedMangaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DeletedMangaQueryFilter
    on QueryBuilder<DeletedManga, DeletedManga, QFilterCondition> {
  QueryBuilder<DeletedManga, DeletedManga, QAfterFilterCondition>
      mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<DeletedManga, DeletedManga, QAfterFilterCondition>
      mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<DeletedManga, DeletedManga, QAfterFilterCondition>
      mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeletedManga, DeletedManga, QAfterFilterCondition>
      mangaIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeletedManga, DeletedManga, QAfterFilterCondition>
      mangaIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeletedManga, DeletedManga, QAfterFilterCondition>
      mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mangaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DeletedMangaQueryObject
    on QueryBuilder<DeletedManga, DeletedManga, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const UpdatedChapterSchema = Schema(
  name: r'UpdatedChapter',
  id: -1728004238049586930,
  properties: {
    r'chapterId': PropertySchema(
      id: 0,
      name: r'chapterId',
      type: IsarType.long,
    ),
    r'deleted': PropertySchema(
      id: 1,
      name: r'deleted',
      type: IsarType.bool,
    ),
    r'isBookmarked': PropertySchema(
      id: 2,
      name: r'isBookmarked',
      type: IsarType.bool,
    ),
    r'isRead': PropertySchema(
      id: 3,
      name: r'isRead',
      type: IsarType.bool,
    ),
    r'lastPageRead': PropertySchema(
      id: 4,
      name: r'lastPageRead',
      type: IsarType.string,
    ),
    r'mangaId': PropertySchema(
      id: 5,
      name: r'mangaId',
      type: IsarType.long,
    )
  },
  estimateSize: _updatedChapterEstimateSize,
  serialize: _updatedChapterSerialize,
  deserialize: _updatedChapterDeserialize,
  deserializeProp: _updatedChapterDeserializeProp,
);

int _updatedChapterEstimateSize(
  UpdatedChapter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.lastPageRead;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _updatedChapterSerialize(
  UpdatedChapter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.chapterId);
  writer.writeBool(offsets[1], object.deleted);
  writer.writeBool(offsets[2], object.isBookmarked);
  writer.writeBool(offsets[3], object.isRead);
  writer.writeString(offsets[4], object.lastPageRead);
  writer.writeLong(offsets[5], object.mangaId);
}

UpdatedChapter _updatedChapterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UpdatedChapter(
    chapterId: reader.readLongOrNull(offsets[0]),
    deleted: reader.readBoolOrNull(offsets[1]),
    isBookmarked: reader.readBoolOrNull(offsets[2]),
    isRead: reader.readBoolOrNull(offsets[3]),
    lastPageRead: reader.readStringOrNull(offsets[4]),
    mangaId: reader.readLongOrNull(offsets[5]),
  );
  return object;
}

P _updatedChapterDeserializeProp<P>(
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
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension UpdatedChapterQueryFilter
    on QueryBuilder<UpdatedChapter, UpdatedChapter, QFilterCondition> {
  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      chapterIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterId',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      chapterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterId',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      chapterIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterId',
        value: value,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      chapterIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapterId',
        value: value,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      chapterIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapterId',
        value: value,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      chapterIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      deletedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deleted',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      deletedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deleted',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      deletedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deleted',
        value: value,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      isBookmarkedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isBookmarked',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      isBookmarkedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isBookmarked',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      isBookmarkedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBookmarked',
        value: value,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      isReadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isRead',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      isReadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isRead',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      isReadEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRead',
        value: value,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastPageRead',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastPageRead',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastPageRead',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastPageRead',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastPageRead',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastPageRead',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastPageRead',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastPageRead',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastPageRead',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastPageRead',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastPageRead',
        value: '',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      lastPageReadIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastPageRead',
        value: '',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      mangaIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      mangaIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<UpdatedChapter, UpdatedChapter, QAfterFilterCondition>
      mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mangaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UpdatedChapterQueryObject
    on QueryBuilder<UpdatedChapter, UpdatedChapter, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const DeletedCategorySchema = Schema(
  name: r'DeletedCategory',
  id: -2357965502277606786,
  properties: {
    r'categoryId': PropertySchema(
      id: 0,
      name: r'categoryId',
      type: IsarType.long,
    )
  },
  estimateSize: _deletedCategoryEstimateSize,
  serialize: _deletedCategorySerialize,
  deserialize: _deletedCategoryDeserialize,
  deserializeProp: _deletedCategoryDeserializeProp,
);

int _deletedCategoryEstimateSize(
  DeletedCategory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _deletedCategorySerialize(
  DeletedCategory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.categoryId);
}

DeletedCategory _deletedCategoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DeletedCategory(
    categoryId: reader.readLongOrNull(offsets[0]),
  );
  return object;
}

P _deletedCategoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension DeletedCategoryQueryFilter
    on QueryBuilder<DeletedCategory, DeletedCategory, QFilterCondition> {
  QueryBuilder<DeletedCategory, DeletedCategory, QAfterFilterCondition>
      categoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryId',
      ));
    });
  }

  QueryBuilder<DeletedCategory, DeletedCategory, QAfterFilterCondition>
      categoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categoryId',
      ));
    });
  }

  QueryBuilder<DeletedCategory, DeletedCategory, QAfterFilterCondition>
      categoryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeletedCategory, DeletedCategory, QAfterFilterCondition>
      categoryIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeletedCategory, DeletedCategory, QAfterFilterCondition>
      categoryIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeletedCategory, DeletedCategory, QAfterFilterCondition>
      categoryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DeletedCategoryQueryObject
    on QueryBuilder<DeletedCategory, DeletedCategory, QFilterCondition> {}
