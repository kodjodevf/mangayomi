// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCategoryCollection on Isar {
  IsarCollection<Category> get categorys => this.collection();
}

const CategorySchema = CollectionSchema(
  name: r'Category',
  id: 5751694338128944171,
  properties: {
    r'forItemType': PropertySchema(
      id: 0,
      name: r'forItemType',
      type: IsarType.byte,
      enumMap: _CategoryforItemTypeEnumValueMap,
    ),
    r'forManga': PropertySchema(id: 1, name: r'forManga', type: IsarType.bool),
    r'hide': PropertySchema(id: 2, name: r'hide', type: IsarType.bool),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
    r'pos': PropertySchema(id: 4, name: r'pos', type: IsarType.long),
    r'shouldUpdate': PropertySchema(
      id: 5,
      name: r'shouldUpdate',
      type: IsarType.bool,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.long,
    ),
  },

  estimateSize: _categoryEstimateSize,
  serialize: _categorySerialize,
  deserialize: _categoryDeserialize,
  deserializeProp: _categoryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _categoryGetId,
  getLinks: _categoryGetLinks,
  attach: _categoryAttach,
  version: '3.3.0',
);

int _categoryEstimateSize(
  Category object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _categorySerialize(
  Category object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.forItemType.index);
  writer.writeBool(offsets[1], object.forManga);
  writer.writeBool(offsets[2], object.hide);
  writer.writeString(offsets[3], object.name);
  writer.writeLong(offsets[4], object.pos);
  writer.writeBool(offsets[5], object.shouldUpdate);
  writer.writeLong(offsets[6], object.updatedAt);
}

Category _categoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Category(
    forItemType:
        _CategoryforItemTypeValueEnumMap[reader.readByteOrNull(offsets[0])] ??
        ItemType.manga,
    hide: reader.readBoolOrNull(offsets[2]),
    id: id,
    name: reader.readStringOrNull(offsets[3]),
    pos: reader.readLongOrNull(offsets[4]),
    shouldUpdate: reader.readBoolOrNull(offsets[5]),
    updatedAt: reader.readLongOrNull(offsets[6]),
  );
  object.forManga = reader.readBoolOrNull(offsets[1]);
  return object;
}

P _categoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_CategoryforItemTypeValueEnumMap[reader.readByteOrNull(offset)] ??
              ItemType.manga)
          as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CategoryforItemTypeEnumValueMap = {'manga': 0, 'anime': 1, 'novel': 2};
const _CategoryforItemTypeValueEnumMap = {
  0: ItemType.manga,
  1: ItemType.anime,
  2: ItemType.novel,
};

Id _categoryGetId(Category object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _categoryGetLinks(Category object) {
  return [];
}

void _categoryAttach(IsarCollection<dynamic> col, Id id, Category object) {
  object.id = id;
}

extension CategoryQueryWhereSort on QueryBuilder<Category, Category, QWhere> {
  QueryBuilder<Category, Category, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CategoryQueryWhere on QueryBuilder<Category, Category, QWhereClause> {
  QueryBuilder<Category, Category, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Category, Category, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Category, Category, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterWhereClause> idBetween(
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

extension CategoryQueryFilter
    on QueryBuilder<Category, Category, QFilterCondition> {
  QueryBuilder<Category, Category, QAfterFilterCondition> forItemTypeEqualTo(
    ItemType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'forItemType', value: value),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition>
  forItemTypeGreaterThan(ItemType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'forItemType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> forItemTypeLessThan(
    ItemType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'forItemType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> forItemTypeBetween(
    ItemType lower,
    ItemType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'forItemType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> forMangaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'forManga'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> forMangaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'forManga'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> forMangaEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'forManga', value: value),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> hideIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hide'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> hideIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hide'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> hideEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hide', value: value),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Category, Category, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Category, Category, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Category, Category, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> posIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pos'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> posIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pos'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> posEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pos', value: value),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> posGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pos',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> posLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pos',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> posBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pos',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> shouldUpdateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'shouldUpdate'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition>
  shouldUpdateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'shouldUpdate'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> shouldUpdateEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shouldUpdate', value: value),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> updatedAtEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<Category, Category, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Category, Category, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Category, Category, QAfterFilterCondition> updatedAtBetween(
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

extension CategoryQueryObject
    on QueryBuilder<Category, Category, QFilterCondition> {}

extension CategoryQueryLinks
    on QueryBuilder<Category, Category, QFilterCondition> {}

extension CategoryQuerySortBy on QueryBuilder<Category, Category, QSortBy> {
  QueryBuilder<Category, Category, QAfterSortBy> sortByForItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forItemType', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByForItemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forItemType', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByForManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forManga', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByForMangaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forManga', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByHide() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hide', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByHideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hide', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByPosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByShouldUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shouldUpdate', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByShouldUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shouldUpdate', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CategoryQuerySortThenBy
    on QueryBuilder<Category, Category, QSortThenBy> {
  QueryBuilder<Category, Category, QAfterSortBy> thenByForItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forItemType', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByForItemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forItemType', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByForManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forManga', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByForMangaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forManga', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByHide() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hide', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByHideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hide', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByPosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByShouldUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shouldUpdate', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByShouldUpdateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shouldUpdate', Sort.desc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Category, Category, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CategoryQueryWhereDistinct
    on QueryBuilder<Category, Category, QDistinct> {
  QueryBuilder<Category, Category, QDistinct> distinctByForItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forItemType');
    });
  }

  QueryBuilder<Category, Category, QDistinct> distinctByForManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forManga');
    });
  }

  QueryBuilder<Category, Category, QDistinct> distinctByHide() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hide');
    });
  }

  QueryBuilder<Category, Category, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Category, Category, QDistinct> distinctByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pos');
    });
  }

  QueryBuilder<Category, Category, QDistinct> distinctByShouldUpdate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shouldUpdate');
    });
  }

  QueryBuilder<Category, Category, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension CategoryQueryProperty
    on QueryBuilder<Category, Category, QQueryProperty> {
  QueryBuilder<Category, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Category, ItemType, QQueryOperations> forItemTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forItemType');
    });
  }

  QueryBuilder<Category, bool?, QQueryOperations> forMangaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forManga');
    });
  }

  QueryBuilder<Category, bool?, QQueryOperations> hideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hide');
    });
  }

  QueryBuilder<Category, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Category, int?, QQueryOperations> posProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pos');
    });
  }

  QueryBuilder<Category, bool?, QQueryOperations> shouldUpdateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shouldUpdate');
    });
  }

  QueryBuilder<Category, int?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
