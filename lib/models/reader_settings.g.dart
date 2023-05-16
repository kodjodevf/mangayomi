// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReaderSettingsCollection on Isar {
  IsarCollection<ReaderSettings> get readerSettings => this.collection();
}

const ReaderSettingsSchema = CollectionSchema(
  name: r'Reader settings',
  id: -7593704226870717670,
  properties: {
    r'defaultReaderMode': PropertySchema(
      id: 0,
      name: r'defaultReaderMode',
      type: IsarType.byte,
      enumMap: _ReaderSettingsdefaultReaderModeEnumValueMap,
    )
  },
  estimateSize: _readerSettingsEstimateSize,
  serialize: _readerSettingsSerialize,
  deserialize: _readerSettingsDeserialize,
  deserializeProp: _readerSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _readerSettingsGetId,
  getLinks: _readerSettingsGetLinks,
  attach: _readerSettingsAttach,
  version: '3.1.0+1',
);

int _readerSettingsEstimateSize(
  ReaderSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _readerSettingsSerialize(
  ReaderSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.defaultReaderMode.index);
}

ReaderSettings _readerSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReaderSettings(
    defaultReaderMode: _ReaderSettingsdefaultReaderModeValueEnumMap[
            reader.readByteOrNull(offsets[0])] ??
        ReaderMode.vertical,
    id: id,
  );
  return object;
}

P _readerSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_ReaderSettingsdefaultReaderModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ReaderMode.vertical) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ReaderSettingsdefaultReaderModeEnumValueMap = {
  'vertical': 0,
  'ltr': 1,
  'rtl': 2,
  'verticalContinuous': 3,
  'webtoon': 4,
};
const _ReaderSettingsdefaultReaderModeValueEnumMap = {
  0: ReaderMode.vertical,
  1: ReaderMode.ltr,
  2: ReaderMode.rtl,
  3: ReaderMode.verticalContinuous,
  4: ReaderMode.webtoon,
};

Id _readerSettingsGetId(ReaderSettings object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _readerSettingsGetLinks(ReaderSettings object) {
  return [];
}

void _readerSettingsAttach(
    IsarCollection<dynamic> col, Id id, ReaderSettings object) {
  object.id = id;
}

extension ReaderSettingsQueryWhereSort
    on QueryBuilder<ReaderSettings, ReaderSettings, QWhere> {
  QueryBuilder<ReaderSettings, ReaderSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReaderSettingsQueryWhere
    on QueryBuilder<ReaderSettings, ReaderSettings, QWhereClause> {
  QueryBuilder<ReaderSettings, ReaderSettings, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterWhereClause> idBetween(
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

extension ReaderSettingsQueryFilter
    on QueryBuilder<ReaderSettings, ReaderSettings, QFilterCondition> {
  QueryBuilder<ReaderSettings, ReaderSettings, QAfterFilterCondition>
      defaultReaderModeEqualTo(ReaderMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultReaderMode',
        value: value,
      ));
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterFilterCondition>
      defaultReaderModeGreaterThan(
    ReaderMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultReaderMode',
        value: value,
      ));
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterFilterCondition>
      defaultReaderModeLessThan(
    ReaderMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultReaderMode',
        value: value,
      ));
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterFilterCondition>
      defaultReaderModeBetween(
    ReaderMode lower,
    ReaderMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultReaderMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterFilterCondition>
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

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterFilterCondition>
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

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterFilterCondition> idBetween(
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
}

extension ReaderSettingsQueryObject
    on QueryBuilder<ReaderSettings, ReaderSettings, QFilterCondition> {}

extension ReaderSettingsQueryLinks
    on QueryBuilder<ReaderSettings, ReaderSettings, QFilterCondition> {}

extension ReaderSettingsQuerySortBy
    on QueryBuilder<ReaderSettings, ReaderSettings, QSortBy> {
  QueryBuilder<ReaderSettings, ReaderSettings, QAfterSortBy>
      sortByDefaultReaderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReaderMode', Sort.asc);
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterSortBy>
      sortByDefaultReaderModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReaderMode', Sort.desc);
    });
  }
}

extension ReaderSettingsQuerySortThenBy
    on QueryBuilder<ReaderSettings, ReaderSettings, QSortThenBy> {
  QueryBuilder<ReaderSettings, ReaderSettings, QAfterSortBy>
      thenByDefaultReaderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReaderMode', Sort.asc);
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterSortBy>
      thenByDefaultReaderModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReaderMode', Sort.desc);
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReaderSettings, ReaderSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ReaderSettingsQueryWhereDistinct
    on QueryBuilder<ReaderSettings, ReaderSettings, QDistinct> {
  QueryBuilder<ReaderSettings, ReaderSettings, QDistinct>
      distinctByDefaultReaderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultReaderMode');
    });
  }
}

extension ReaderSettingsQueryProperty
    on QueryBuilder<ReaderSettings, ReaderSettings, QQueryProperty> {
  QueryBuilder<ReaderSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReaderSettings, ReaderMode, QQueryOperations>
      defaultReaderModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultReaderMode');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPersonalReaderModeCollection on Isar {
  IsarCollection<PersonalReaderMode> get personalReaderModes =>
      this.collection();
}

const PersonalReaderModeSchema = CollectionSchema(
  name: r'Personal ReaderMode',
  id: -6358434224379634897,
  properties: {
    r'mangaId': PropertySchema(
      id: 0,
      name: r'mangaId',
      type: IsarType.long,
    ),
    r'readerMode': PropertySchema(
      id: 1,
      name: r'readerMode',
      type: IsarType.byte,
      enumMap: _PersonalReaderModereaderModeEnumValueMap,
    )
  },
  estimateSize: _personalReaderModeEstimateSize,
  serialize: _personalReaderModeSerialize,
  deserialize: _personalReaderModeDeserialize,
  deserializeProp: _personalReaderModeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _personalReaderModeGetId,
  getLinks: _personalReaderModeGetLinks,
  attach: _personalReaderModeAttach,
  version: '3.1.0+1',
);

int _personalReaderModeEstimateSize(
  PersonalReaderMode object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _personalReaderModeSerialize(
  PersonalReaderMode object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeByte(offsets[1], object.readerMode.index);
}

PersonalReaderMode _personalReaderModeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PersonalReaderMode(
    id: id,
    mangaId: reader.readLongOrNull(offsets[0]),
    readerMode: _PersonalReaderModereaderModeValueEnumMap[
            reader.readByteOrNull(offsets[1])] ??
        ReaderMode.vertical,
  );
  return object;
}

P _personalReaderModeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (_PersonalReaderModereaderModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ReaderMode.vertical) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PersonalReaderModereaderModeEnumValueMap = {
  'vertical': 0,
  'ltr': 1,
  'rtl': 2,
  'verticalContinuous': 3,
  'webtoon': 4,
};
const _PersonalReaderModereaderModeValueEnumMap = {
  0: ReaderMode.vertical,
  1: ReaderMode.ltr,
  2: ReaderMode.rtl,
  3: ReaderMode.verticalContinuous,
  4: ReaderMode.webtoon,
};

Id _personalReaderModeGetId(PersonalReaderMode object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _personalReaderModeGetLinks(
    PersonalReaderMode object) {
  return [];
}

void _personalReaderModeAttach(
    IsarCollection<dynamic> col, Id id, PersonalReaderMode object) {
  object.id = id;
}

extension PersonalReaderModeQueryWhereSort
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QWhere> {
  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PersonalReaderModeQueryWhere
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QWhereClause> {
  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterWhereClause>
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

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterWhereClause>
      idBetween(
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

extension PersonalReaderModeQueryFilter
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QFilterCondition> {
  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
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

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
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

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
      mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
      mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
      mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
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

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
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

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
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

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
      readerModeEqualTo(ReaderMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readerMode',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
      readerModeGreaterThan(
    ReaderMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readerMode',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
      readerModeLessThan(
    ReaderMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readerMode',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
      readerModeBetween(
    ReaderMode lower,
    ReaderMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readerMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PersonalReaderModeQueryObject
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QFilterCondition> {}

extension PersonalReaderModeQueryLinks
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QFilterCondition> {}

extension PersonalReaderModeQuerySortBy
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QSortBy> {
  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterSortBy>
      sortByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterSortBy>
      sortByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterSortBy>
      sortByReaderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readerMode', Sort.asc);
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterSortBy>
      sortByReaderModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readerMode', Sort.desc);
    });
  }
}

extension PersonalReaderModeQuerySortThenBy
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QSortThenBy> {
  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterSortBy>
      thenByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterSortBy>
      thenByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterSortBy>
      thenByReaderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readerMode', Sort.asc);
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterSortBy>
      thenByReaderModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readerMode', Sort.desc);
    });
  }
}

extension PersonalReaderModeQueryWhereDistinct
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QDistinct> {
  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QDistinct>
      distinctByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaId');
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QDistinct>
      distinctByReaderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readerMode');
    });
  }
}

extension PersonalReaderModeQueryProperty
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QQueryProperty> {
  QueryBuilder<PersonalReaderMode, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PersonalReaderMode, int?, QQueryOperations> mangaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaId');
    });
  }

  QueryBuilder<PersonalReaderMode, ReaderMode, QQueryOperations>
      readerModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readerMode');
    });
  }
}
