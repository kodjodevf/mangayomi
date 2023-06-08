// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSourceCollection on Isar {
  IsarCollection<Source> get sources => this.collection();
}

const SourceSchema = CollectionSchema(
  name: r'Sources',
  id: 897746782445124704,
  properties: {
    r'apiUrl': PropertySchema(
      id: 0,
      name: r'apiUrl',
      type: IsarType.string,
    ),
    r'baseUrl': PropertySchema(
      id: 1,
      name: r'baseUrl',
      type: IsarType.string,
    ),
    r'dateFormat': PropertySchema(
      id: 2,
      name: r'dateFormat',
      type: IsarType.string,
    ),
    r'dateFormatLocale': PropertySchema(
      id: 3,
      name: r'dateFormatLocale',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 4,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isAdded': PropertySchema(
      id: 5,
      name: r'isAdded',
      type: IsarType.bool,
    ),
    r'isCloudflare': PropertySchema(
      id: 6,
      name: r'isCloudflare',
      type: IsarType.bool,
    ),
    r'isFullData': PropertySchema(
      id: 7,
      name: r'isFullData',
      type: IsarType.bool,
    ),
    r'isNsfw': PropertySchema(
      id: 8,
      name: r'isNsfw',
      type: IsarType.bool,
    ),
    r'isPinned': PropertySchema(
      id: 9,
      name: r'isPinned',
      type: IsarType.bool,
    ),
    r'lang': PropertySchema(
      id: 10,
      name: r'lang',
      type: IsarType.string,
    ),
    r'lastUsed': PropertySchema(
      id: 11,
      name: r'lastUsed',
      type: IsarType.bool,
    ),
    r'logoUrl': PropertySchema(
      id: 12,
      name: r'logoUrl',
      type: IsarType.string,
    ),
    r'sourceName': PropertySchema(
      id: 13,
      name: r'sourceName',
      type: IsarType.string,
    ),
    r'typeSource': PropertySchema(
      id: 14,
      name: r'typeSource',
      type: IsarType.byte,
      enumMap: _SourcetypeSourceEnumValueMap,
    )
  },
  estimateSize: _sourceEstimateSize,
  serialize: _sourceSerialize,
  deserialize: _sourceDeserialize,
  deserializeProp: _sourceDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sourceGetId,
  getLinks: _sourceGetLinks,
  attach: _sourceAttach,
  version: '3.1.0+1',
);

int _sourceEstimateSize(
  Source object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.apiUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.baseUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dateFormat;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dateFormatLocale;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lang;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.logoUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sourceName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _sourceSerialize(
  Source object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.apiUrl);
  writer.writeString(offsets[1], object.baseUrl);
  writer.writeString(offsets[2], object.dateFormat);
  writer.writeString(offsets[3], object.dateFormatLocale);
  writer.writeBool(offsets[4], object.isActive);
  writer.writeBool(offsets[5], object.isAdded);
  writer.writeBool(offsets[6], object.isCloudflare);
  writer.writeBool(offsets[7], object.isFullData);
  writer.writeBool(offsets[8], object.isNsfw);
  writer.writeBool(offsets[9], object.isPinned);
  writer.writeString(offsets[10], object.lang);
  writer.writeBool(offsets[11], object.lastUsed);
  writer.writeString(offsets[12], object.logoUrl);
  writer.writeString(offsets[13], object.sourceName);
  writer.writeByte(offsets[14], object.typeSource.index);
}

Source _sourceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Source(
    apiUrl: reader.readStringOrNull(offsets[0]),
    baseUrl: reader.readStringOrNull(offsets[1]),
    dateFormat: reader.readStringOrNull(offsets[2]),
    dateFormatLocale: reader.readStringOrNull(offsets[3]),
    id: id,
    isActive: reader.readBoolOrNull(offsets[4]),
    isAdded: reader.readBoolOrNull(offsets[5]),
    isCloudflare: reader.readBoolOrNull(offsets[6]),
    isFullData: reader.readBoolOrNull(offsets[7]),
    isNsfw: reader.readBoolOrNull(offsets[8]),
    isPinned: reader.readBoolOrNull(offsets[9]),
    lang: reader.readStringOrNull(offsets[10]),
    lastUsed: reader.readBoolOrNull(offsets[11]),
    logoUrl: reader.readStringOrNull(offsets[12]),
    sourceName: reader.readStringOrNull(offsets[13]),
    typeSource:
        _SourcetypeSourceValueEnumMap[reader.readByteOrNull(offsets[14])] ??
            TypeSource.single,
  );
  return object;
}

P _sourceDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readBoolOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readBoolOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (_SourcetypeSourceValueEnumMap[reader.readByteOrNull(offset)] ??
          TypeSource.single) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SourcetypeSourceEnumValueMap = {
  'single': 0,
  'mangathemesia': 1,
  'comick': 2,
  'mmrcms': 3,
  'heancms': 4,
  'madara': 5,
  'mangadex': 6,
};
const _SourcetypeSourceValueEnumMap = {
  0: TypeSource.single,
  1: TypeSource.mangathemesia,
  2: TypeSource.comick,
  3: TypeSource.mmrcms,
  4: TypeSource.heancms,
  5: TypeSource.madara,
  6: TypeSource.mangadex,
};

Id _sourceGetId(Source object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _sourceGetLinks(Source object) {
  return [];
}

void _sourceAttach(IsarCollection<dynamic> col, Id id, Source object) {
  object.id = id;
}

extension SourceQueryWhereSort on QueryBuilder<Source, Source, QWhere> {
  QueryBuilder<Source, Source, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SourceQueryWhere on QueryBuilder<Source, Source, QWhereClause> {
  QueryBuilder<Source, Source, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Source, Source, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> idBetween(
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

extension SourceQueryFilter on QueryBuilder<Source, Source, QFilterCondition> {
  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'apiUrl',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'apiUrl',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'apiUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'apiUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'apiUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'apiUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'apiUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'apiUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'apiUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'apiUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'apiUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'apiUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'baseUrl',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'baseUrl',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'baseUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'baseUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'baseUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateFormat',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateFormat',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateFormat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateFormat',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateFormat',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateFormat',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateFormat',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateFormatLocale',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      dateFormatLocaleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateFormatLocale',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateFormatLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      dateFormatLocaleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateFormatLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateFormatLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateFormatLocale',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      dateFormatLocaleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateFormatLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateFormatLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateFormatLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateFormatLocale',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      dateFormatLocaleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateFormatLocale',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      dateFormatLocaleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateFormatLocale',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> isActiveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isActive',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isActiveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isActive',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isActiveEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isAddedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isAdded',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isAddedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isAdded',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isAddedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isCloudflareIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isCloudflare',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isCloudflareIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isCloudflare',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isCloudflareEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCloudflare',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isFullDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isFullData',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isFullDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isFullData',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isFullDataEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFullData',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isNsfwIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isNsfw',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isNsfwIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isNsfw',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isNsfwEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isNsfw',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isPinnedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isPinned',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isPinnedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isPinned',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isPinnedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPinned',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lang',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lang',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lang',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lang',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lang',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lang',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lang',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> lastUsedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastUsed',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> lastUsedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastUsed',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> lastUsedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUsed',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'logoUrl',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'logoUrl',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logoUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logoUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> logoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceName',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceName',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceName',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceName',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceEqualTo(
      TypeSource value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeSource',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceGreaterThan(
    TypeSource value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeSource',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceLessThan(
    TypeSource value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeSource',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceBetween(
    TypeSource lower,
    TypeSource upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeSource',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SourceQueryObject on QueryBuilder<Source, Source, QFilterCondition> {}

extension SourceQueryLinks on QueryBuilder<Source, Source, QFilterCondition> {}

extension SourceQuerySortBy on QueryBuilder<Source, Source, QSortBy> {
  QueryBuilder<Source, Source, QAfterSortBy> sortByApiUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiUrl', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByApiUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiUrl', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByBaseUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByBaseUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByDateFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByDateFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByDateFormatLocale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormatLocale', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByDateFormatLocaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormatLocale', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdded', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdded', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsCloudflare() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCloudflare', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsCloudflareDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCloudflare', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsFullData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullData', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsFullDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullData', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsNsfw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNsfw', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsNsfwDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNsfw', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByLang() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByLangDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByLastUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByLogoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByLogoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByTypeSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSource', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByTypeSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSource', Sort.desc);
    });
  }
}

extension SourceQuerySortThenBy on QueryBuilder<Source, Source, QSortThenBy> {
  QueryBuilder<Source, Source, QAfterSortBy> thenByApiUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiUrl', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByApiUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiUrl', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByBaseUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByBaseUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseUrl', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByDateFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByDateFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByDateFormatLocale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormatLocale', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByDateFormatLocaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormatLocale', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdded', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdded', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsCloudflare() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCloudflare', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsCloudflareDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCloudflare', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsFullData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullData', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsFullDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullData', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsNsfw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNsfw', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsNsfwDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNsfw', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByLang() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByLangDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lang', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByLastUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsed', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByLogoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByLogoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySourceName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySourceNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceName', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByTypeSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSource', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByTypeSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSource', Sort.desc);
    });
  }
}

extension SourceQueryWhereDistinct on QueryBuilder<Source, Source, QDistinct> {
  QueryBuilder<Source, Source, QDistinct> distinctByApiUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'apiUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByBaseUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByDateFormat(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateFormat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByDateFormatLocale(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateFormatLocale',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAdded');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsCloudflare() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCloudflare');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsFullData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFullData');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsNsfw() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isNsfw');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinned');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByLang(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lang', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUsed');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByLogoUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logoUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySourceName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByTypeSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeSource');
    });
  }
}

extension SourceQueryProperty on QueryBuilder<Source, Source, QQueryProperty> {
  QueryBuilder<Source, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> apiUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'apiUrl');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> baseUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseUrl');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> dateFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateFormat');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> dateFormatLocaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateFormatLocale');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> isAddedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAdded');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> isCloudflareProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCloudflare');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> isFullDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFullData');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> isNsfwProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isNsfw');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> isPinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinned');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> langProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lang');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> lastUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUsed');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> logoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logoUrl');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> sourceNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceName');
    });
  }

  QueryBuilder<Source, TypeSource, QQueryOperations> typeSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeSource');
    });
  }
}
