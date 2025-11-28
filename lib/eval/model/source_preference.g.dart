// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_preference.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSourcePreferenceCollection on Isar {
  IsarCollection<SourcePreference> get sourcePreferences => this.collection();
}

const SourcePreferenceSchema = CollectionSchema(
  name: r'SourcePreferences',
  id: 4736855879043243045,
  properties: {
    r'checkBoxPreference': PropertySchema(
      id: 0,
      name: r'checkBoxPreference',
      type: IsarType.object,

      target: r'CheckBoxPreference',
    ),
    r'editTextPreference': PropertySchema(
      id: 1,
      name: r'editTextPreference',
      type: IsarType.object,

      target: r'EditTextPreference',
    ),
    r'key': PropertySchema(id: 2, name: r'key', type: IsarType.string),
    r'listPreference': PropertySchema(
      id: 3,
      name: r'listPreference',
      type: IsarType.object,

      target: r'ListPreference',
    ),
    r'multiSelectListPreference': PropertySchema(
      id: 4,
      name: r'multiSelectListPreference',
      type: IsarType.object,

      target: r'MultiSelectListPreference',
    ),
    r'sourceId': PropertySchema(id: 5, name: r'sourceId', type: IsarType.long),
    r'switchPreferenceCompat': PropertySchema(
      id: 6,
      name: r'switchPreferenceCompat',
      type: IsarType.object,

      target: r'SwitchPreferenceCompat',
    ),
  },

  estimateSize: _sourcePreferenceEstimateSize,
  serialize: _sourcePreferenceSerialize,
  deserialize: _sourcePreferenceDeserialize,
  deserializeProp: _sourcePreferenceDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'CheckBoxPreference': CheckBoxPreferenceSchema,
    r'SwitchPreferenceCompat': SwitchPreferenceCompatSchema,
    r'ListPreference': ListPreferenceSchema,
    r'MultiSelectListPreference': MultiSelectListPreferenceSchema,
    r'EditTextPreference': EditTextPreferenceSchema,
  },

  getId: _sourcePreferenceGetId,
  getLinks: _sourcePreferenceGetLinks,
  attach: _sourcePreferenceAttach,
  version: '3.3.0',
);

int _sourcePreferenceEstimateSize(
  SourcePreference object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.checkBoxPreference;
    if (value != null) {
      bytesCount +=
          3 +
          CheckBoxPreferenceSchema.estimateSize(
            value,
            allOffsets[CheckBoxPreference]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.editTextPreference;
    if (value != null) {
      bytesCount +=
          3 +
          EditTextPreferenceSchema.estimateSize(
            value,
            allOffsets[EditTextPreference]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.key;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.listPreference;
    if (value != null) {
      bytesCount +=
          3 +
          ListPreferenceSchema.estimateSize(
            value,
            allOffsets[ListPreference]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.multiSelectListPreference;
    if (value != null) {
      bytesCount +=
          3 +
          MultiSelectListPreferenceSchema.estimateSize(
            value,
            allOffsets[MultiSelectListPreference]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.switchPreferenceCompat;
    if (value != null) {
      bytesCount +=
          3 +
          SwitchPreferenceCompatSchema.estimateSize(
            value,
            allOffsets[SwitchPreferenceCompat]!,
            allOffsets,
          );
    }
  }
  return bytesCount;
}

void _sourcePreferenceSerialize(
  SourcePreference object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<CheckBoxPreference>(
    offsets[0],
    allOffsets,
    CheckBoxPreferenceSchema.serialize,
    object.checkBoxPreference,
  );
  writer.writeObject<EditTextPreference>(
    offsets[1],
    allOffsets,
    EditTextPreferenceSchema.serialize,
    object.editTextPreference,
  );
  writer.writeString(offsets[2], object.key);
  writer.writeObject<ListPreference>(
    offsets[3],
    allOffsets,
    ListPreferenceSchema.serialize,
    object.listPreference,
  );
  writer.writeObject<MultiSelectListPreference>(
    offsets[4],
    allOffsets,
    MultiSelectListPreferenceSchema.serialize,
    object.multiSelectListPreference,
  );
  writer.writeLong(offsets[5], object.sourceId);
  writer.writeObject<SwitchPreferenceCompat>(
    offsets[6],
    allOffsets,
    SwitchPreferenceCompatSchema.serialize,
    object.switchPreferenceCompat,
  );
}

SourcePreference _sourcePreferenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SourcePreference(
    checkBoxPreference: reader.readObjectOrNull<CheckBoxPreference>(
      offsets[0],
      CheckBoxPreferenceSchema.deserialize,
      allOffsets,
    ),
    editTextPreference: reader.readObjectOrNull<EditTextPreference>(
      offsets[1],
      EditTextPreferenceSchema.deserialize,
      allOffsets,
    ),
    id: id,
    key: reader.readStringOrNull(offsets[2]),
    listPreference: reader.readObjectOrNull<ListPreference>(
      offsets[3],
      ListPreferenceSchema.deserialize,
      allOffsets,
    ),
    multiSelectListPreference: reader
        .readObjectOrNull<MultiSelectListPreference>(
          offsets[4],
          MultiSelectListPreferenceSchema.deserialize,
          allOffsets,
        ),
    sourceId: reader.readLongOrNull(offsets[5]),
    switchPreferenceCompat: reader.readObjectOrNull<SwitchPreferenceCompat>(
      offsets[6],
      SwitchPreferenceCompatSchema.deserialize,
      allOffsets,
    ),
  );
  return object;
}

P _sourcePreferenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<CheckBoxPreference>(
            offset,
            CheckBoxPreferenceSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 1:
      return (reader.readObjectOrNull<EditTextPreference>(
            offset,
            EditTextPreferenceSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readObjectOrNull<ListPreference>(
            offset,
            ListPreferenceSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 4:
      return (reader.readObjectOrNull<MultiSelectListPreference>(
            offset,
            MultiSelectListPreferenceSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readObjectOrNull<SwitchPreferenceCompat>(
            offset,
            SwitchPreferenceCompatSchema.deserialize,
            allOffsets,
          ))
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sourcePreferenceGetId(SourcePreference object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _sourcePreferenceGetLinks(SourcePreference object) {
  return [];
}

void _sourcePreferenceAttach(
  IsarCollection<dynamic> col,
  Id id,
  SourcePreference object,
) {
  object.id = id;
}

extension SourcePreferenceQueryWhereSort
    on QueryBuilder<SourcePreference, SourcePreference, QWhere> {
  QueryBuilder<SourcePreference, SourcePreference, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SourcePreferenceQueryWhere
    on QueryBuilder<SourcePreference, SourcePreference, QWhereClause> {
  QueryBuilder<SourcePreference, SourcePreference, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterWhereClause>
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

  QueryBuilder<SourcePreference, SourcePreference, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterWhereClause> idBetween(
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

extension SourcePreferenceQueryFilter
    on QueryBuilder<SourcePreference, SourcePreference, QFilterCondition> {
  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  checkBoxPreferenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'checkBoxPreference'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  checkBoxPreferenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'checkBoxPreference'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  editTextPreferenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'editTextPreference'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  editTextPreferenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'editTextPreference'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  idGreaterThan(Id? value, {bool include = false}) {
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

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  idLessThan(Id? value, {bool include = false}) {
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

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'key'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'key'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'key',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'key',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  listPreferenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'listPreference'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  listPreferenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'listPreference'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  multiSelectListPreferenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'multiSelectListPreference'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  multiSelectListPreferenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'multiSelectListPreference'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  sourceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sourceId'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  sourceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sourceId'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  sourceIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceId', value: value),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  sourceIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  sourceIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  sourceIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  switchPreferenceCompatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'switchPreferenceCompat'),
      );
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  switchPreferenceCompatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'switchPreferenceCompat'),
      );
    });
  }
}

extension SourcePreferenceQueryObject
    on QueryBuilder<SourcePreference, SourcePreference, QFilterCondition> {
  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  checkBoxPreference(FilterQuery<CheckBoxPreference> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'checkBoxPreference');
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  editTextPreference(FilterQuery<EditTextPreference> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'editTextPreference');
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  listPreference(FilterQuery<ListPreference> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'listPreference');
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  multiSelectListPreference(FilterQuery<MultiSelectListPreference> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'multiSelectListPreference');
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterFilterCondition>
  switchPreferenceCompat(FilterQuery<SwitchPreferenceCompat> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'switchPreferenceCompat');
    });
  }
}

extension SourcePreferenceQueryLinks
    on QueryBuilder<SourcePreference, SourcePreference, QFilterCondition> {}

extension SourcePreferenceQuerySortBy
    on QueryBuilder<SourcePreference, SourcePreference, QSortBy> {
  QueryBuilder<SourcePreference, SourcePreference, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterSortBy>
  sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterSortBy>
  sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterSortBy>
  sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }
}

extension SourcePreferenceQuerySortThenBy
    on QueryBuilder<SourcePreference, SourcePreference, QSortThenBy> {
  QueryBuilder<SourcePreference, SourcePreference, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterSortBy>
  thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterSortBy>
  thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QAfterSortBy>
  thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }
}

extension SourcePreferenceQueryWhereDistinct
    on QueryBuilder<SourcePreference, SourcePreference, QDistinct> {
  QueryBuilder<SourcePreference, SourcePreference, QDistinct> distinctByKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SourcePreference, SourcePreference, QDistinct>
  distinctBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId');
    });
  }
}

extension SourcePreferenceQueryProperty
    on QueryBuilder<SourcePreference, SourcePreference, QQueryProperty> {
  QueryBuilder<SourcePreference, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SourcePreference, CheckBoxPreference?, QQueryOperations>
  checkBoxPreferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkBoxPreference');
    });
  }

  QueryBuilder<SourcePreference, EditTextPreference?, QQueryOperations>
  editTextPreferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'editTextPreference');
    });
  }

  QueryBuilder<SourcePreference, String?, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<SourcePreference, ListPreference?, QQueryOperations>
  listPreferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'listPreference');
    });
  }

  QueryBuilder<SourcePreference, MultiSelectListPreference?, QQueryOperations>
  multiSelectListPreferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'multiSelectListPreference');
    });
  }

  QueryBuilder<SourcePreference, int?, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<SourcePreference, SwitchPreferenceCompat?, QQueryOperations>
  switchPreferenceCompatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'switchPreferenceCompat');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSourcePreferenceStringValueCollection on Isar {
  IsarCollection<SourcePreferenceStringValue>
  get sourcePreferenceStringValues => this.collection();
}

const SourcePreferenceStringValueSchema = CollectionSchema(
  name: r'SourcePreferenceStringValue',
  id: 8063295595066322236,
  properties: {
    r'key': PropertySchema(id: 0, name: r'key', type: IsarType.string),
    r'sourceId': PropertySchema(id: 1, name: r'sourceId', type: IsarType.long),
    r'value': PropertySchema(id: 2, name: r'value', type: IsarType.string),
  },

  estimateSize: _sourcePreferenceStringValueEstimateSize,
  serialize: _sourcePreferenceStringValueSerialize,
  deserialize: _sourcePreferenceStringValueDeserialize,
  deserializeProp: _sourcePreferenceStringValueDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _sourcePreferenceStringValueGetId,
  getLinks: _sourcePreferenceStringValueGetLinks,
  attach: _sourcePreferenceStringValueAttach,
  version: '3.3.0',
);

int _sourcePreferenceStringValueEstimateSize(
  SourcePreferenceStringValue object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.key;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.value;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _sourcePreferenceStringValueSerialize(
  SourcePreferenceStringValue object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeLong(offsets[1], object.sourceId);
  writer.writeString(offsets[2], object.value);
}

SourcePreferenceStringValue _sourcePreferenceStringValueDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SourcePreferenceStringValue(
    id: id,
    key: reader.readStringOrNull(offsets[0]),
    sourceId: reader.readLongOrNull(offsets[1]),
    value: reader.readStringOrNull(offsets[2]),
  );
  return object;
}

P _sourcePreferenceStringValueDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sourcePreferenceStringValueGetId(SourcePreferenceStringValue object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sourcePreferenceStringValueGetLinks(
  SourcePreferenceStringValue object,
) {
  return [];
}

void _sourcePreferenceStringValueAttach(
  IsarCollection<dynamic> col,
  Id id,
  SourcePreferenceStringValue object,
) {
  object.id = id;
}

extension SourcePreferenceStringValueQueryWhereSort
    on
        QueryBuilder<
          SourcePreferenceStringValue,
          SourcePreferenceStringValue,
          QWhere
        > {
  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SourcePreferenceStringValueQueryWhere
    on
        QueryBuilder<
          SourcePreferenceStringValue,
          SourcePreferenceStringValue,
          QWhereClause
        > {
  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterWhereClause
  >
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

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterWhereClause
  >
  idBetween(
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

extension SourcePreferenceStringValueQueryFilter
    on
        QueryBuilder<
          SourcePreferenceStringValue,
          SourcePreferenceStringValue,
          QFilterCondition
        > {
  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'key'),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'key'),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'key',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'key',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  sourceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sourceId'),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  sourceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sourceId'),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  sourceIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sourceId', value: value),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  sourceIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sourceId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  sourceIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sourceId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  sourceIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sourceId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'value'),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'value'),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'value',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'value',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'value', value: ''),
      );
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterFilterCondition
  >
  valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'value', value: ''),
      );
    });
  }
}

extension SourcePreferenceStringValueQueryObject
    on
        QueryBuilder<
          SourcePreferenceStringValue,
          SourcePreferenceStringValue,
          QFilterCondition
        > {}

extension SourcePreferenceStringValueQueryLinks
    on
        QueryBuilder<
          SourcePreferenceStringValue,
          SourcePreferenceStringValue,
          QFilterCondition
        > {}

extension SourcePreferenceStringValueQuerySortBy
    on
        QueryBuilder<
          SourcePreferenceStringValue,
          SourcePreferenceStringValue,
          QSortBy
        > {
  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension SourcePreferenceStringValueQuerySortThenBy
    on
        QueryBuilder<
          SourcePreferenceStringValue,
          SourcePreferenceStringValue,
          QSortThenBy
        > {
  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QAfterSortBy
  >
  thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension SourcePreferenceStringValueQueryWhereDistinct
    on
        QueryBuilder<
          SourcePreferenceStringValue,
          SourcePreferenceStringValue,
          QDistinct
        > {
  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QDistinct
  >
  distinctByKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QDistinct
  >
  distinctBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId');
    });
  }

  QueryBuilder<
    SourcePreferenceStringValue,
    SourcePreferenceStringValue,
    QDistinct
  >
  distinctByValue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension SourcePreferenceStringValueQueryProperty
    on
        QueryBuilder<
          SourcePreferenceStringValue,
          SourcePreferenceStringValue,
          QQueryProperty
        > {
  QueryBuilder<SourcePreferenceStringValue, int, QQueryOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SourcePreferenceStringValue, String?, QQueryOperations>
  keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<SourcePreferenceStringValue, int?, QQueryOperations>
  sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<SourcePreferenceStringValue, String?, QQueryOperations>
  valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CheckBoxPreferenceSchema = Schema(
  name: r'CheckBoxPreference',
  id: -2147338366782458830,
  properties: {
    r'summary': PropertySchema(id: 0, name: r'summary', type: IsarType.string),
    r'title': PropertySchema(id: 1, name: r'title', type: IsarType.string),
    r'value': PropertySchema(id: 2, name: r'value', type: IsarType.bool),
  },

  estimateSize: _checkBoxPreferenceEstimateSize,
  serialize: _checkBoxPreferenceSerialize,
  deserialize: _checkBoxPreferenceDeserialize,
  deserializeProp: _checkBoxPreferenceDeserializeProp,
);

int _checkBoxPreferenceEstimateSize(
  CheckBoxPreference object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
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
  return bytesCount;
}

void _checkBoxPreferenceSerialize(
  CheckBoxPreference object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.summary);
  writer.writeString(offsets[1], object.title);
  writer.writeBool(offsets[2], object.value);
}

CheckBoxPreference _checkBoxPreferenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CheckBoxPreference(
    summary: reader.readStringOrNull(offsets[0]),
    title: reader.readStringOrNull(offsets[1]),
    value: reader.readBoolOrNull(offsets[2]),
  );
  return object;
}

P _checkBoxPreferenceDeserializeProp<P>(
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
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CheckBoxPreferenceQueryFilter
    on QueryBuilder<CheckBoxPreference, CheckBoxPreference, QFilterCondition> {
  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  summaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  summaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  summaryEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  summaryLessThan(
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  summaryBetween(
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  summaryEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  summaryContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  summaryMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'title'),
      );
    });
  }

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'title'),
      );
    });
  }

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  titleEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  titleLessThan(
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  titleBetween(
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'value'),
      );
    });
  }

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'value'),
      );
    });
  }

  QueryBuilder<CheckBoxPreference, CheckBoxPreference, QAfterFilterCondition>
  valueEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'value', value: value),
      );
    });
  }
}

extension CheckBoxPreferenceQueryObject
    on QueryBuilder<CheckBoxPreference, CheckBoxPreference, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SwitchPreferenceCompatSchema = Schema(
  name: r'SwitchPreferenceCompat',
  id: 3452971972865195760,
  properties: {
    r'summary': PropertySchema(id: 0, name: r'summary', type: IsarType.string),
    r'title': PropertySchema(id: 1, name: r'title', type: IsarType.string),
    r'value': PropertySchema(id: 2, name: r'value', type: IsarType.bool),
  },

  estimateSize: _switchPreferenceCompatEstimateSize,
  serialize: _switchPreferenceCompatSerialize,
  deserialize: _switchPreferenceCompatDeserialize,
  deserializeProp: _switchPreferenceCompatDeserializeProp,
);

int _switchPreferenceCompatEstimateSize(
  SwitchPreferenceCompat object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
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
  return bytesCount;
}

void _switchPreferenceCompatSerialize(
  SwitchPreferenceCompat object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.summary);
  writer.writeString(offsets[1], object.title);
  writer.writeBool(offsets[2], object.value);
}

SwitchPreferenceCompat _switchPreferenceCompatDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SwitchPreferenceCompat(
    summary: reader.readStringOrNull(offsets[0]),
    title: reader.readStringOrNull(offsets[1]),
    value: reader.readBoolOrNull(offsets[2]),
  );
  return object;
}

P _switchPreferenceCompatDeserializeProp<P>(
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
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SwitchPreferenceCompatQueryFilter
    on
        QueryBuilder<
          SwitchPreferenceCompat,
          SwitchPreferenceCompat,
          QFilterCondition
        > {
  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  summaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  summaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  summaryEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  summaryLessThan(
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  summaryBetween(
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  summaryEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  summaryContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  summaryMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'title'),
      );
    });
  }

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'title'),
      );
    });
  }

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  titleEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  titleLessThan(
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  titleBetween(
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  titleStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  titleEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  titleContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  titleMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'value'),
      );
    });
  }

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'value'),
      );
    });
  }

  QueryBuilder<
    SwitchPreferenceCompat,
    SwitchPreferenceCompat,
    QAfterFilterCondition
  >
  valueEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'value', value: value),
      );
    });
  }
}

extension SwitchPreferenceCompatQueryObject
    on
        QueryBuilder<
          SwitchPreferenceCompat,
          SwitchPreferenceCompat,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ListPreferenceSchema = Schema(
  name: r'ListPreference',
  id: -3432819603975074113,
  properties: {
    r'entries': PropertySchema(
      id: 0,
      name: r'entries',
      type: IsarType.stringList,
    ),
    r'entryValues': PropertySchema(
      id: 1,
      name: r'entryValues',
      type: IsarType.stringList,
    ),
    r'summary': PropertySchema(id: 2, name: r'summary', type: IsarType.string),
    r'title': PropertySchema(id: 3, name: r'title', type: IsarType.string),
    r'valueIndex': PropertySchema(
      id: 4,
      name: r'valueIndex',
      type: IsarType.long,
    ),
  },

  estimateSize: _listPreferenceEstimateSize,
  serialize: _listPreferenceSerialize,
  deserialize: _listPreferenceDeserialize,
  deserializeProp: _listPreferenceDeserializeProp,
);

int _listPreferenceEstimateSize(
  ListPreference object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.entries;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.entryValues;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
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
  return bytesCount;
}

void _listPreferenceSerialize(
  ListPreference object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.entries);
  writer.writeStringList(offsets[1], object.entryValues);
  writer.writeString(offsets[2], object.summary);
  writer.writeString(offsets[3], object.title);
  writer.writeLong(offsets[4], object.valueIndex);
}

ListPreference _listPreferenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ListPreference(
    entries: reader.readStringList(offsets[0]),
    entryValues: reader.readStringList(offsets[1]),
    summary: reader.readStringOrNull(offsets[2]),
    title: reader.readStringOrNull(offsets[3]),
    valueIndex: reader.readLongOrNull(offsets[4]),
  );
  return object;
}

P _listPreferenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ListPreferenceQueryFilter
    on QueryBuilder<ListPreference, ListPreference, QFilterCondition> {
  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'entries'),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'entries'),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'entries',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'entries',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entries', value: ''),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'entries', value: ''),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', length, true, length, true);
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', 0, true, 0, true);
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', 0, false, 999999, true);
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', 0, true, length, include);
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', length, include, 999999, true);
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entries',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'entryValues'),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'entryValues'),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'entryValues',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'entryValues',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entryValues', value: ''),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'entryValues', value: ''),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entryValues', length, true, length, true);
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entryValues', 0, true, 0, true);
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entryValues', 0, false, 999999, true);
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entryValues', 0, true, length, include);
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entryValues', length, include, 999999, true);
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  entryValuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryValues',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  summaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  summaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  summaryEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  summaryLessThan(
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  summaryBetween(
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  summaryEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  summaryContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  summaryMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'title'),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'title'),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  titleEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  titleLessThan(
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  titleBetween(
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  valueIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'valueIndex'),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  valueIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'valueIndex'),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  valueIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'valueIndex', value: value),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  valueIndexGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'valueIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  valueIndexLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'valueIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ListPreference, ListPreference, QAfterFilterCondition>
  valueIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'valueIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ListPreferenceQueryObject
    on QueryBuilder<ListPreference, ListPreference, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MultiSelectListPreferenceSchema = Schema(
  name: r'MultiSelectListPreference',
  id: -1920660907164205341,
  properties: {
    r'entries': PropertySchema(
      id: 0,
      name: r'entries',
      type: IsarType.stringList,
    ),
    r'entryValues': PropertySchema(
      id: 1,
      name: r'entryValues',
      type: IsarType.stringList,
    ),
    r'summary': PropertySchema(id: 2, name: r'summary', type: IsarType.string),
    r'title': PropertySchema(id: 3, name: r'title', type: IsarType.string),
    r'values': PropertySchema(
      id: 4,
      name: r'values',
      type: IsarType.stringList,
    ),
  },

  estimateSize: _multiSelectListPreferenceEstimateSize,
  serialize: _multiSelectListPreferenceSerialize,
  deserialize: _multiSelectListPreferenceDeserialize,
  deserializeProp: _multiSelectListPreferenceDeserializeProp,
);

int _multiSelectListPreferenceEstimateSize(
  MultiSelectListPreference object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.entries;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.entryValues;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
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
    final list = object.values;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _multiSelectListPreferenceSerialize(
  MultiSelectListPreference object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.entries);
  writer.writeStringList(offsets[1], object.entryValues);
  writer.writeString(offsets[2], object.summary);
  writer.writeString(offsets[3], object.title);
  writer.writeStringList(offsets[4], object.values);
}

MultiSelectListPreference _multiSelectListPreferenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MultiSelectListPreference(
    entries: reader.readStringList(offsets[0]),
    entryValues: reader.readStringList(offsets[1]),
    summary: reader.readStringOrNull(offsets[2]),
    title: reader.readStringOrNull(offsets[3]),
    values: reader.readStringList(offsets[4]),
  );
  return object;
}

P _multiSelectListPreferenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MultiSelectListPreferenceQueryFilter
    on
        QueryBuilder<
          MultiSelectListPreference,
          MultiSelectListPreference,
          QFilterCondition
        > {
  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'entries'),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'entries'),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'entries',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'entries',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'entries',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entries', value: ''),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'entries', value: ''),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', length, true, length, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', 0, true, 0, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', 0, true, length, include);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', length, include, 999999, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entries',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'entryValues'),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'entryValues'),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'entryValues',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'entryValues',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'entryValues',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entryValues', value: ''),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'entryValues', value: ''),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entryValues', length, true, length, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entryValues', 0, true, 0, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entryValues', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entryValues', 0, true, length, include);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entryValues', length, include, 999999, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  entryValuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entryValues',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  summaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  summaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  summaryEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  summaryLessThan(
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  summaryBetween(
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  summaryEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  summaryContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  summaryMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'title'),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'title'),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  titleEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  titleLessThan(
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  titleBetween(
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  titleStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  titleEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  titleContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  titleMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'values'),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'values'),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'values',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'values',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'values',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'values',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'values',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'values',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'values',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'values',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'values', value: ''),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'values', value: ''),
      );
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'values', length, true, length, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'values', 0, true, 0, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'values', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'values', 0, true, length, include);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'values', length, include, 999999, true);
    });
  }

  QueryBuilder<
    MultiSelectListPreference,
    MultiSelectListPreference,
    QAfterFilterCondition
  >
  valuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension MultiSelectListPreferenceQueryObject
    on
        QueryBuilder<
          MultiSelectListPreference,
          MultiSelectListPreference,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const EditTextPreferenceSchema = Schema(
  name: r'EditTextPreference',
  id: 3711993124215876925,
  properties: {
    r'dialogMessage': PropertySchema(
      id: 0,
      name: r'dialogMessage',
      type: IsarType.string,
    ),
    r'dialogTitle': PropertySchema(
      id: 1,
      name: r'dialogTitle',
      type: IsarType.string,
    ),
    r'summary': PropertySchema(id: 2, name: r'summary', type: IsarType.string),
    r'text': PropertySchema(id: 3, name: r'text', type: IsarType.string),
    r'title': PropertySchema(id: 4, name: r'title', type: IsarType.string),
    r'value': PropertySchema(id: 5, name: r'value', type: IsarType.string),
  },

  estimateSize: _editTextPreferenceEstimateSize,
  serialize: _editTextPreferenceSerialize,
  deserialize: _editTextPreferenceDeserialize,
  deserializeProp: _editTextPreferenceDeserializeProp,
);

int _editTextPreferenceEstimateSize(
  EditTextPreference object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dialogMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dialogTitle;
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
    final value = object.text;
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
    final value = object.value;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _editTextPreferenceSerialize(
  EditTextPreference object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dialogMessage);
  writer.writeString(offsets[1], object.dialogTitle);
  writer.writeString(offsets[2], object.summary);
  writer.writeString(offsets[3], object.text);
  writer.writeString(offsets[4], object.title);
  writer.writeString(offsets[5], object.value);
}

EditTextPreference _editTextPreferenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EditTextPreference(
    dialogMessage: reader.readStringOrNull(offsets[0]),
    dialogTitle: reader.readStringOrNull(offsets[1]),
    summary: reader.readStringOrNull(offsets[2]),
    text: reader.readStringOrNull(offsets[3]),
    title: reader.readStringOrNull(offsets[4]),
    value: reader.readStringOrNull(offsets[5]),
  );
  return object;
}

P _editTextPreferenceDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension EditTextPreferenceQueryFilter
    on QueryBuilder<EditTextPreference, EditTextPreference, QFilterCondition> {
  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dialogMessage'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dialogMessage'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dialogMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dialogMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dialogMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dialogMessage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dialogMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dialogMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dialogMessage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dialogMessage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dialogMessage', value: ''),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dialogMessage', value: ''),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dialogTitle'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dialogTitle'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dialogTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dialogTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dialogTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dialogTitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dialogTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dialogTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dialogTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dialogTitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dialogTitle', value: ''),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  dialogTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dialogTitle', value: ''),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  summaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  summaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  summaryEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  summaryLessThan(
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  summaryBetween(
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  summaryEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  summaryContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  summaryMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'text'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'text'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'text',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'text',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'title'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'title'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  titleEqualTo(String? value, {bool caseSensitive = true}) {
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  titleLessThan(
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  titleBetween(
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'value'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'value'),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'value',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'value',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'value',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'value', value: ''),
      );
    });
  }

  QueryBuilder<EditTextPreference, EditTextPreference, QAfterFilterCondition>
  valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'value', value: ''),
      );
    });
  }
}

extension EditTextPreferenceQueryObject
    on QueryBuilder<EditTextPreference, EditTextPreference, QFilterCondition> {}
