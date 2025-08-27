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
    r'additionalParams': PropertySchema(
      id: 0,
      name: r'additionalParams',
      type: IsarType.string,
    ),
    r'apiUrl': PropertySchema(id: 1, name: r'apiUrl', type: IsarType.string),
    r'appMinVerReq': PropertySchema(
      id: 2,
      name: r'appMinVerReq',
      type: IsarType.string,
    ),
    r'baseUrl': PropertySchema(id: 3, name: r'baseUrl', type: IsarType.string),
    r'dateFormat': PropertySchema(
      id: 4,
      name: r'dateFormat',
      type: IsarType.string,
    ),
    r'dateFormatLocale': PropertySchema(
      id: 5,
      name: r'dateFormatLocale',
      type: IsarType.string,
    ),
    r'filterList': PropertySchema(
      id: 6,
      name: r'filterList',
      type: IsarType.string,
    ),
    r'hasCloudflare': PropertySchema(
      id: 7,
      name: r'hasCloudflare',
      type: IsarType.bool,
    ),
    r'headers': PropertySchema(id: 8, name: r'headers', type: IsarType.string),
    r'iconUrl': PropertySchema(id: 9, name: r'iconUrl', type: IsarType.string),
    r'isActive': PropertySchema(id: 10, name: r'isActive', type: IsarType.bool),
    r'isAdded': PropertySchema(id: 11, name: r'isAdded', type: IsarType.bool),
    r'isFullData': PropertySchema(
      id: 12,
      name: r'isFullData',
      type: IsarType.bool,
    ),
    r'isLocal': PropertySchema(id: 13, name: r'isLocal', type: IsarType.bool),
    r'isManga': PropertySchema(id: 14, name: r'isManga', type: IsarType.bool),
    r'isNsfw': PropertySchema(id: 15, name: r'isNsfw', type: IsarType.bool),
    r'isObsolete': PropertySchema(
      id: 16,
      name: r'isObsolete',
      type: IsarType.bool,
    ),
    r'isPinned': PropertySchema(id: 17, name: r'isPinned', type: IsarType.bool),
    r'isTorrent': PropertySchema(
      id: 18,
      name: r'isTorrent',
      type: IsarType.bool,
    ),
    r'itemType': PropertySchema(
      id: 19,
      name: r'itemType',
      type: IsarType.byte,
      enumMap: _SourceitemTypeEnumValueMap,
    ),
    r'lang': PropertySchema(id: 20, name: r'lang', type: IsarType.string),
    r'lastUsed': PropertySchema(id: 21, name: r'lastUsed', type: IsarType.bool),
    r'name': PropertySchema(id: 22, name: r'name', type: IsarType.string),
    r'notes': PropertySchema(id: 23, name: r'notes', type: IsarType.string),
    r'preferenceList': PropertySchema(
      id: 24,
      name: r'preferenceList',
      type: IsarType.string,
    ),
    r'repo': PropertySchema(
      id: 25,
      name: r'repo',
      type: IsarType.object,

      target: r'Repo',
    ),
    r'sourceCode': PropertySchema(
      id: 26,
      name: r'sourceCode',
      type: IsarType.string,
    ),
    r'sourceCodeLanguage': PropertySchema(
      id: 27,
      name: r'sourceCodeLanguage',
      type: IsarType.byte,
      enumMap: _SourcesourceCodeLanguageEnumValueMap,
    ),
    r'sourceCodeUrl': PropertySchema(
      id: 28,
      name: r'sourceCodeUrl',
      type: IsarType.string,
    ),
    r'supportLatest': PropertySchema(
      id: 29,
      name: r'supportLatest',
      type: IsarType.bool,
    ),
    r'typeSource': PropertySchema(
      id: 30,
      name: r'typeSource',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 31,
      name: r'updatedAt',
      type: IsarType.long,
    ),
    r'version': PropertySchema(id: 32, name: r'version', type: IsarType.string),
    r'versionLast': PropertySchema(
      id: 33,
      name: r'versionLast',
      type: IsarType.string,
    ),
  },

  estimateSize: _sourceEstimateSize,
  serialize: _sourceSerialize,
  deserialize: _sourceDeserialize,
  deserializeProp: _sourceDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'Repo': RepoSchema},

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
    final value = object.additionalParams;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.apiUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.appMinVerReq;
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
    final value = object.filterList;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.headers;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.iconUrl;
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
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.preferenceList;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.repo;
    if (value != null) {
      bytesCount +=
          3 + RepoSchema.estimateSize(value, allOffsets[Repo]!, allOffsets);
    }
  }
  {
    final value = object.sourceCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sourceCodeUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.typeSource;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.version;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.versionLast;
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
  writer.writeString(offsets[0], object.additionalParams);
  writer.writeString(offsets[1], object.apiUrl);
  writer.writeString(offsets[2], object.appMinVerReq);
  writer.writeString(offsets[3], object.baseUrl);
  writer.writeString(offsets[4], object.dateFormat);
  writer.writeString(offsets[5], object.dateFormatLocale);
  writer.writeString(offsets[6], object.filterList);
  writer.writeBool(offsets[7], object.hasCloudflare);
  writer.writeString(offsets[8], object.headers);
  writer.writeString(offsets[9], object.iconUrl);
  writer.writeBool(offsets[10], object.isActive);
  writer.writeBool(offsets[11], object.isAdded);
  writer.writeBool(offsets[12], object.isFullData);
  writer.writeBool(offsets[13], object.isLocal);
  writer.writeBool(offsets[14], object.isManga);
  writer.writeBool(offsets[15], object.isNsfw);
  writer.writeBool(offsets[16], object.isObsolete);
  writer.writeBool(offsets[17], object.isPinned);
  writer.writeBool(offsets[18], object.isTorrent);
  writer.writeByte(offsets[19], object.itemType.index);
  writer.writeString(offsets[20], object.lang);
  writer.writeBool(offsets[21], object.lastUsed);
  writer.writeString(offsets[22], object.name);
  writer.writeString(offsets[23], object.notes);
  writer.writeString(offsets[24], object.preferenceList);
  writer.writeObject<Repo>(
    offsets[25],
    allOffsets,
    RepoSchema.serialize,
    object.repo,
  );
  writer.writeString(offsets[26], object.sourceCode);
  writer.writeByte(offsets[27], object.sourceCodeLanguage.index);
  writer.writeString(offsets[28], object.sourceCodeUrl);
  writer.writeBool(offsets[29], object.supportLatest);
  writer.writeString(offsets[30], object.typeSource);
  writer.writeLong(offsets[31], object.updatedAt);
  writer.writeString(offsets[32], object.version);
  writer.writeString(offsets[33], object.versionLast);
}

Source _sourceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Source(
    additionalParams: reader.readStringOrNull(offsets[0]),
    apiUrl: reader.readStringOrNull(offsets[1]),
    appMinVerReq: reader.readStringOrNull(offsets[2]),
    baseUrl: reader.readStringOrNull(offsets[3]),
    dateFormat: reader.readStringOrNull(offsets[4]),
    dateFormatLocale: reader.readStringOrNull(offsets[5]),
    filterList: reader.readStringOrNull(offsets[6]),
    hasCloudflare: reader.readBoolOrNull(offsets[7]),
    headers: reader.readStringOrNull(offsets[8]),
    iconUrl: reader.readStringOrNull(offsets[9]),
    id: id,
    isActive: reader.readBoolOrNull(offsets[10]),
    isAdded: reader.readBoolOrNull(offsets[11]),
    isFullData: reader.readBoolOrNull(offsets[12]),
    isLocal: reader.readBoolOrNull(offsets[13]),
    isManga: reader.readBoolOrNull(offsets[14]),
    isNsfw: reader.readBoolOrNull(offsets[15]),
    isObsolete: reader.readBoolOrNull(offsets[16]),
    isPinned: reader.readBoolOrNull(offsets[17]),
    itemType:
        _SourceitemTypeValueEnumMap[reader.readByteOrNull(offsets[19])] ??
        ItemType.manga,
    lang: reader.readStringOrNull(offsets[20]),
    lastUsed: reader.readBoolOrNull(offsets[21]),
    name: reader.readStringOrNull(offsets[22]),
    notes: reader.readStringOrNull(offsets[23]),
    preferenceList: reader.readStringOrNull(offsets[24]),
    repo: reader.readObjectOrNull<Repo>(
      offsets[25],
      RepoSchema.deserialize,
      allOffsets,
    ),
    sourceCode: reader.readStringOrNull(offsets[26]),
    sourceCodeUrl: reader.readStringOrNull(offsets[28]),
    supportLatest: reader.readBoolOrNull(offsets[29]),
    typeSource: reader.readStringOrNull(offsets[30]),
    updatedAt: reader.readLongOrNull(offsets[31]),
    version: reader.readStringOrNull(offsets[32]),
    versionLast: reader.readStringOrNull(offsets[33]),
  );
  object.sourceCodeLanguage =
      _SourcesourceCodeLanguageValueEnumMap[reader.readByteOrNull(
        offsets[27],
      )] ??
      SourceCodeLanguage.dart;
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
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset)) as P;
    case 12:
      return (reader.readBoolOrNull(offset)) as P;
    case 13:
      return (reader.readBoolOrNull(offset)) as P;
    case 14:
      return (reader.readBoolOrNull(offset)) as P;
    case 15:
      return (reader.readBoolOrNull(offset)) as P;
    case 16:
      return (reader.readBoolOrNull(offset)) as P;
    case 17:
      return (reader.readBoolOrNull(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    case 19:
      return (_SourceitemTypeValueEnumMap[reader.readByteOrNull(offset)] ??
              ItemType.manga)
          as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readBoolOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readObjectOrNull<Repo>(
            offset,
            RepoSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (_SourcesourceCodeLanguageValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              SourceCodeLanguage.dart)
          as P;
    case 28:
      return (reader.readStringOrNull(offset)) as P;
    case 29:
      return (reader.readBoolOrNull(offset)) as P;
    case 30:
      return (reader.readStringOrNull(offset)) as P;
    case 31:
      return (reader.readLongOrNull(offset)) as P;
    case 32:
      return (reader.readStringOrNull(offset)) as P;
    case 33:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SourceitemTypeEnumValueMap = {'manga': 0, 'anime': 1, 'novel': 2};
const _SourceitemTypeValueEnumMap = {
  0: ItemType.manga,
  1: ItemType.anime,
  2: ItemType.novel,
};
const _SourcesourceCodeLanguageEnumValueMap = {
  'dart': 0,
  'javascript': 1,
  'mihon': 2,
};
const _SourcesourceCodeLanguageValueEnumMap = {
  0: SourceCodeLanguage.dart,
  1: SourceCodeLanguage.javascript,
  2: SourceCodeLanguage.mihon,
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
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
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

  QueryBuilder<Source, Source, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
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

extension SourceQueryFilter on QueryBuilder<Source, Source, QFilterCondition> {
  QueryBuilder<Source, Source, QAfterFilterCondition> additionalParamsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'additionalParams'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  additionalParamsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'additionalParams'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> additionalParamsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'additionalParams',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  additionalParamsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'additionalParams',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> additionalParamsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'additionalParams',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> additionalParamsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'additionalParams',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  additionalParamsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'additionalParams',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> additionalParamsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'additionalParams',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> additionalParamsContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'additionalParams',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> additionalParamsMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'additionalParams',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  additionalParamsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'additionalParams', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  additionalParamsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'additionalParams', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'apiUrl'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'apiUrl'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'apiUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'apiUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'apiUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'apiUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'apiUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'apiUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'apiUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'apiUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'apiUrl', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> apiUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'apiUrl', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'appMinVerReq'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'appMinVerReq'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'appMinVerReq',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'appMinVerReq',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'appMinVerReq',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'appMinVerReq',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'appMinVerReq',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'appMinVerReq',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'appMinVerReq',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'appMinVerReq',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'appMinVerReq', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> appMinVerReqIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'appMinVerReq', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'baseUrl'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'baseUrl'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'baseUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'baseUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'baseUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'baseUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'baseUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'baseUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'baseUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'baseUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'baseUrl', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> baseUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'baseUrl', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dateFormat'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dateFormat'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateFormat',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dateFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dateFormat',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateFormat', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dateFormat', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dateFormatLocale'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  dateFormatLocaleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dateFormatLocale'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dateFormatLocale',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  dateFormatLocaleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateFormatLocale',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateFormatLocale',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateFormatLocale',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  dateFormatLocaleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dateFormatLocale',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dateFormatLocale',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dateFormatLocale',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> dateFormatLocaleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dateFormatLocale',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  dateFormatLocaleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateFormatLocale', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  dateFormatLocaleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dateFormatLocale', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'filterList'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'filterList'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'filterList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'filterList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'filterList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'filterList',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'filterList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'filterList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'filterList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'filterList',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'filterList', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> filterListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'filterList', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> hasCloudflareIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hasCloudflare'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> hasCloudflareIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hasCloudflare'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> hasCloudflareEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hasCloudflare', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'headers'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'headers'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'headers',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'headers',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'headers',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'headers', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'headers', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'iconUrl'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'iconUrl'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'iconUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'iconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'iconUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'iconUrl', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> iconUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'iconUrl', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> isActiveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isActive'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isActiveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isActive'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isActiveEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isAddedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isAdded'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isAddedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isAdded'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isAddedEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isAdded', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isFullDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isFullData'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isFullDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isFullData'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isFullDataEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isFullData', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isLocalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isLocal'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isLocalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isLocal'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isLocalEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isLocal', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isMangaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isManga'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isMangaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isManga'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isMangaEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isManga', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isNsfwIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isNsfw'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isNsfwIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isNsfw'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isNsfwEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isNsfw', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isObsoleteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isObsolete'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isObsoleteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isObsolete'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isObsoleteEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isObsolete', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isPinnedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isPinned'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isPinnedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isPinned'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isPinnedEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isPinned', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> isTorrentEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isTorrent', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> itemTypeEqualTo(
    ItemType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'itemType', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> itemTypeGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> itemTypeLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> itemTypeBetween(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> langIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lang'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lang'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lang',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lang',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lang',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lang',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lang',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lang',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lang',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lang',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lang', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> langIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lang', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> lastUsedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastUsed'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> lastUsedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastUsed'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> lastUsedEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastUsed', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameContains(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> preferenceListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'preferenceList'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  preferenceListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'preferenceList'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> preferenceListEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'preferenceList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> preferenceListGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'preferenceList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> preferenceListLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'preferenceList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> preferenceListBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'preferenceList',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> preferenceListStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'preferenceList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> preferenceListEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'preferenceList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> preferenceListContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'preferenceList',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> preferenceListMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'preferenceList',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> preferenceListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'preferenceList', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  preferenceListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'preferenceList', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> repoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'repo'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> repoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'repo'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sourceCode'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sourceCode'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sourceCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sourceCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sourceCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sourceCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sourceCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceCode', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sourceCode', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeLanguageEqualTo(
    SourceCodeLanguage value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceCodeLanguage', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  sourceCodeLanguageGreaterThan(
    SourceCodeLanguage value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceCodeLanguage',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  sourceCodeLanguageLessThan(SourceCodeLanguage value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceCodeLanguage',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeLanguageBetween(
    SourceCodeLanguage lower,
    SourceCodeLanguage upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceCodeLanguage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sourceCodeUrl'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sourceCodeUrl'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sourceCodeUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceCodeUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceCodeUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceCodeUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sourceCodeUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sourceCodeUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sourceCodeUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sourceCodeUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> sourceCodeUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceCodeUrl', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
  sourceCodeUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sourceCodeUrl', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> supportLatestIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'supportLatest'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> supportLatestIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'supportLatest'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> supportLatestEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'supportLatest', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'typeSource'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'typeSource'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'typeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'typeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'typeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'typeSource',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'typeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'typeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'typeSource',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'typeSource',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'typeSource', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeSourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'typeSource', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> versionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'version'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'version'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'version',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'version',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'version', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'version', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'versionLast'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'versionLast'),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'versionLast',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'versionLast',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'versionLast',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'versionLast',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'versionLast',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'versionLast',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'versionLast',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'versionLast',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'versionLast', value: ''),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> versionLastIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'versionLast', value: ''),
      );
    });
  }
}

extension SourceQueryObject on QueryBuilder<Source, Source, QFilterCondition> {
  QueryBuilder<Source, Source, QAfterFilterCondition> repo(
    FilterQuery<Repo> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'repo');
    });
  }
}

extension SourceQueryLinks on QueryBuilder<Source, Source, QFilterCondition> {}

extension SourceQuerySortBy on QueryBuilder<Source, Source, QSortBy> {
  QueryBuilder<Source, Source, QAfterSortBy> sortByAdditionalParams() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalParams', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByAdditionalParamsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalParams', Sort.desc);
    });
  }

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

  QueryBuilder<Source, Source, QAfterSortBy> sortByAppMinVerReq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appMinVerReq', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByAppMinVerReqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appMinVerReq', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> sortByFilterList() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterList', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByFilterListDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterList', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByHasCloudflare() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCloudflare', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByHasCloudflareDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCloudflare', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByHeaders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headers', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByHeadersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headers', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIconUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIconUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManga', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsMangaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManga', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsObsolete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isObsolete', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsObsoleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isObsolete', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsTorrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTorrent', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByIsTorrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTorrent', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByItemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByPreferenceList() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferenceList', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByPreferenceListDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferenceList', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySourceCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCode', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySourceCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCode', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySourceCodeLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCodeLanguage', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySourceCodeLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCodeLanguage', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySourceCodeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCodeUrl', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySourceCodeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCodeUrl', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySupportLatest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportLatest', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySupportLatestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportLatest', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByVersionLast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versionLast', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByVersionLastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versionLast', Sort.desc);
    });
  }
}

extension SourceQuerySortThenBy on QueryBuilder<Source, Source, QSortThenBy> {
  QueryBuilder<Source, Source, QAfterSortBy> thenByAdditionalParams() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalParams', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByAdditionalParamsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalParams', Sort.desc);
    });
  }

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

  QueryBuilder<Source, Source, QAfterSortBy> thenByAppMinVerReq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appMinVerReq', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByAppMinVerReqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appMinVerReq', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> thenByFilterList() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterList', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByFilterListDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterList', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByHasCloudflare() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCloudflare', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByHasCloudflareDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCloudflare', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByHeaders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headers', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByHeadersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headers', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIconUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIconUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocal', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManga', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsMangaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManga', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsObsolete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isObsolete', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsObsoleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isObsolete', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsTorrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTorrent', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIsTorrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTorrent', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByItemTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemType', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByPreferenceList() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferenceList', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByPreferenceListDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferenceList', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySourceCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCode', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySourceCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCode', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySourceCodeLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCodeLanguage', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySourceCodeLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCodeLanguage', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySourceCodeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCodeUrl', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySourceCodeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCodeUrl', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySupportLatest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportLatest', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySupportLatestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportLatest', Sort.desc);
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

  QueryBuilder<Source, Source, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByVersionLast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versionLast', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByVersionLastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versionLast', Sort.desc);
    });
  }
}

extension SourceQueryWhereDistinct on QueryBuilder<Source, Source, QDistinct> {
  QueryBuilder<Source, Source, QDistinct> distinctByAdditionalParams({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'additionalParams',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByApiUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'apiUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByAppMinVerReq({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appMinVerReq', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByBaseUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByDateFormat({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateFormat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByDateFormatLocale({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'dateFormatLocale',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByFilterList({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filterList', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByHasCloudflare() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasCloudflare');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByHeaders({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'headers', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIconUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconUrl', caseSensitive: caseSensitive);
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

  QueryBuilder<Source, Source, QDistinct> distinctByIsFullData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFullData');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isLocal');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsManga() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isManga');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsNsfw() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isNsfw');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsObsolete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isObsolete');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinned');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByIsTorrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTorrent');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByItemType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemType');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByLang({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lang', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByLastUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUsed');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByPreferenceList({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'preferenceList',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySourceCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySourceCodeLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceCodeLanguage');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySourceCodeUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'sourceCodeUrl',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySupportLatest() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supportLatest');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByTypeSource({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeSource', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByVersion({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByVersionLast({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'versionLast', caseSensitive: caseSensitive);
    });
  }
}

extension SourceQueryProperty on QueryBuilder<Source, Source, QQueryProperty> {
  QueryBuilder<Source, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> additionalParamsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'additionalParams');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> apiUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'apiUrl');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> appMinVerReqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appMinVerReq');
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

  QueryBuilder<Source, String?, QQueryOperations> filterListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filterList');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> hasCloudflareProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasCloudflare');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> headersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'headers');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> iconUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconUrl');
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

  QueryBuilder<Source, bool?, QQueryOperations> isFullDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFullData');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> isLocalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isLocal');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> isMangaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isManga');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> isNsfwProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isNsfw');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> isObsoleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isObsolete');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> isPinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinned');
    });
  }

  QueryBuilder<Source, bool, QQueryOperations> isTorrentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTorrent');
    });
  }

  QueryBuilder<Source, ItemType, QQueryOperations> itemTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemType');
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

  QueryBuilder<Source, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> preferenceListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preferenceList');
    });
  }

  QueryBuilder<Source, Repo?, QQueryOperations> repoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repo');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> sourceCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceCode');
    });
  }

  QueryBuilder<Source, SourceCodeLanguage, QQueryOperations>
  sourceCodeLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceCodeLanguage');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> sourceCodeUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceCodeUrl');
    });
  }

  QueryBuilder<Source, bool?, QQueryOperations> supportLatestProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supportLatest');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> typeSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeSource');
    });
  }

  QueryBuilder<Source, int?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }

  QueryBuilder<Source, String?, QQueryOperations> versionLastProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'versionLast');
    });
  }
}
