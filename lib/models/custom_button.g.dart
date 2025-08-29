// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_button.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCustomButtonCollection on Isar {
  IsarCollection<CustomButton> get customButtons => this.collection();
}

const CustomButtonSchema = CollectionSchema(
  name: r'CustomButton',
  id: 3146166780828864477,
  properties: {
    r'codeLongPress': PropertySchema(
      id: 0,
      name: r'codeLongPress',
      type: IsarType.string,
    ),
    r'codePress': PropertySchema(
      id: 1,
      name: r'codePress',
      type: IsarType.string,
    ),
    r'codeStartup': PropertySchema(
      id: 2,
      name: r'codeStartup',
      type: IsarType.string,
    ),
    r'isFavourite': PropertySchema(
      id: 3,
      name: r'isFavourite',
      type: IsarType.bool,
    ),
    r'pos': PropertySchema(id: 4, name: r'pos', type: IsarType.long),
    r'title': PropertySchema(id: 5, name: r'title', type: IsarType.string),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.long,
    ),
  },

  estimateSize: _customButtonEstimateSize,
  serialize: _customButtonSerialize,
  deserialize: _customButtonDeserialize,
  deserializeProp: _customButtonDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _customButtonGetId,
  getLinks: _customButtonGetLinks,
  attach: _customButtonAttach,
  version: '3.1.0+1',
);

int _customButtonEstimateSize(
  CustomButton object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.codeLongPress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.codePress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.codeStartup;
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

void _customButtonSerialize(
  CustomButton object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.codeLongPress);
  writer.writeString(offsets[1], object.codePress);
  writer.writeString(offsets[2], object.codeStartup);
  writer.writeBool(offsets[3], object.isFavourite);
  writer.writeLong(offsets[4], object.pos);
  writer.writeString(offsets[5], object.title);
  writer.writeLong(offsets[6], object.updatedAt);
}

CustomButton _customButtonDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomButton(
    codeLongPress: reader.readStringOrNull(offsets[0]),
    codePress: reader.readStringOrNull(offsets[1]),
    codeStartup: reader.readStringOrNull(offsets[2]),
    id: id,
    isFavourite: reader.readBoolOrNull(offsets[3]),
    pos: reader.readLongOrNull(offsets[4]),
    title: reader.readStringOrNull(offsets[5]),
    updatedAt: reader.readLongOrNull(offsets[6]),
  );
  return object;
}

P _customButtonDeserializeProp<P>(
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
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _customButtonGetId(CustomButton object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _customButtonGetLinks(CustomButton object) {
  return [];
}

void _customButtonAttach(
  IsarCollection<dynamic> col,
  Id id,
  CustomButton object,
) {
  object.id = id;
}

extension CustomButtonQueryWhereSort
    on QueryBuilder<CustomButton, CustomButton, QWhere> {
  QueryBuilder<CustomButton, CustomButton, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CustomButtonQueryWhere
    on QueryBuilder<CustomButton, CustomButton, QWhereClause> {
  QueryBuilder<CustomButton, CustomButton, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<CustomButton, CustomButton, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterWhereClause> idBetween(
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

extension CustomButtonQueryFilter
    on QueryBuilder<CustomButton, CustomButton, QFilterCondition> {
  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'codeLongPress'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'codeLongPress'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'codeLongPress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'codeLongPress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'codeLongPress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'codeLongPress',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'codeLongPress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'codeLongPress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'codeLongPress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'codeLongPress',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'codeLongPress', value: ''),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeLongPressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'codeLongPress', value: ''),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'codePress'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'codePress'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'codePress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'codePress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'codePress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'codePress',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'codePress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'codePress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'codePress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'codePress',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'codePress', value: ''),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codePressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'codePress', value: ''),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'codeStartup'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'codeStartup'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'codeStartup',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'codeStartup',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'codeStartup',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'codeStartup',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'codeStartup',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'codeStartup',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'codeStartup',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'codeStartup',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'codeStartup', value: ''),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  codeStartupIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'codeStartup', value: ''),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> idEqualTo(
    Id? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  isFavouriteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isFavourite'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  isFavouriteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isFavourite'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  isFavouriteEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isFavourite', value: value),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> posIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pos'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  posIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pos'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> posEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pos', value: value),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  posGreaterThan(int? value, {bool include = false}) {
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> posLessThan(
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> posBetween(
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'title'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'title'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> titleContains(
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition> titleMatches(
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  updatedAtEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  updatedAtGreaterThan(int? value, {bool include = false}) {
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  updatedAtLessThan(int? value, {bool include = false}) {
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

  QueryBuilder<CustomButton, CustomButton, QAfterFilterCondition>
  updatedAtBetween(
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

extension CustomButtonQueryObject
    on QueryBuilder<CustomButton, CustomButton, QFilterCondition> {}

extension CustomButtonQueryLinks
    on QueryBuilder<CustomButton, CustomButton, QFilterCondition> {}

extension CustomButtonQuerySortBy
    on QueryBuilder<CustomButton, CustomButton, QSortBy> {
  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> sortByCodeLongPress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codeLongPress', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy>
  sortByCodeLongPressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codeLongPress', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> sortByCodePress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codePress', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> sortByCodePressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codePress', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> sortByCodeStartup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codeStartup', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy>
  sortByCodeStartupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codeStartup', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> sortByIsFavourite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavourite', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy>
  sortByIsFavouriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavourite', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> sortByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> sortByPosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CustomButtonQuerySortThenBy
    on QueryBuilder<CustomButton, CustomButton, QSortThenBy> {
  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByCodeLongPress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codeLongPress', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy>
  thenByCodeLongPressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codeLongPress', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByCodePress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codePress', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByCodePressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codePress', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByCodeStartup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codeStartup', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy>
  thenByCodeStartupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'codeStartup', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByIsFavourite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavourite', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy>
  thenByIsFavouriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavourite', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByPosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pos', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CustomButtonQueryWhereDistinct
    on QueryBuilder<CustomButton, CustomButton, QDistinct> {
  QueryBuilder<CustomButton, CustomButton, QDistinct> distinctByCodeLongPress({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'codeLongPress',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<CustomButton, CustomButton, QDistinct> distinctByCodePress({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'codePress', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QDistinct> distinctByCodeStartup({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'codeStartup', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QDistinct> distinctByIsFavourite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavourite');
    });
  }

  QueryBuilder<CustomButton, CustomButton, QDistinct> distinctByPos() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pos');
    });
  }

  QueryBuilder<CustomButton, CustomButton, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomButton, CustomButton, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension CustomButtonQueryProperty
    on QueryBuilder<CustomButton, CustomButton, QQueryProperty> {
  QueryBuilder<CustomButton, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CustomButton, String?, QQueryOperations>
  codeLongPressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'codeLongPress');
    });
  }

  QueryBuilder<CustomButton, String?, QQueryOperations> codePressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'codePress');
    });
  }

  QueryBuilder<CustomButton, String?, QQueryOperations> codeStartupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'codeStartup');
    });
  }

  QueryBuilder<CustomButton, bool?, QQueryOperations> isFavouriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavourite');
    });
  }

  QueryBuilder<CustomButton, int?, QQueryOperations> posProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pos');
    });
  }

  QueryBuilder<CustomButton, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<CustomButton, int?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
