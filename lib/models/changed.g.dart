// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changed.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChangedPartCollection on Isar {
  IsarCollection<ChangedPart> get changedParts => this.collection();
}

const ChangedPartSchema = CollectionSchema(
  name: r'ChangedPart',
  id: 984304309479278230,
  properties: {
    r'actionType': PropertySchema(
      id: 0,
      name: r'actionType',
      type: IsarType.byte,
      enumMap: _ChangedPartactionTypeEnumValueMap,
    ),
    r'clientDate': PropertySchema(
      id: 1,
      name: r'clientDate',
      type: IsarType.long,
    ),
    r'data': PropertySchema(
      id: 2,
      name: r'data',
      type: IsarType.string,
    ),
    r'isarId': PropertySchema(
      id: 3,
      name: r'isarId',
      type: IsarType.long,
    )
  },
  estimateSize: _changedPartEstimateSize,
  serialize: _changedPartSerialize,
  deserialize: _changedPartDeserialize,
  deserializeProp: _changedPartDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _changedPartGetId,
  getLinks: _changedPartGetLinks,
  attach: _changedPartAttach,
  version: '3.1.0+1',
);

int _changedPartEstimateSize(
  ChangedPart object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.data.length * 3;
  return bytesCount;
}

void _changedPartSerialize(
  ChangedPart object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.actionType.index);
  writer.writeLong(offsets[1], object.clientDate);
  writer.writeString(offsets[2], object.data);
  writer.writeLong(offsets[3], object.isarId);
}

ChangedPart _changedPartDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChangedPart(
    actionType:
        _ChangedPartactionTypeValueEnumMap[reader.readByteOrNull(offsets[0])] ??
            ActionType.addItem,
    clientDate: reader.readLong(offsets[1]),
    data: reader.readString(offsets[2]),
    id: id,
    isarId: reader.readLongOrNull(offsets[3]),
  );
  return object;
}

P _changedPartDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_ChangedPartactionTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ActionType.addItem) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ChangedPartactionTypeEnumValueMap = {
  'addItem': 0,
  'removeItem': 1,
  'updateItem': 2,
  'addCategory': 3,
  'removeCategory': 4,
  'renameCategory': 5,
  'addChapter': 6,
  'removeChapter': 7,
  'updateChapter': 8,
  'clearHistory': 9,
  'addHistory': 10,
  'removeHistory': 11,
  'updateHistory': 12,
  'clearUpdates': 13,
  'addUpdate': 14,
  'clearExtension': 15,
  'addExtension': 16,
  'removeExtension': 17,
  'updateExtension': 18,
  'addTrack': 19,
  'removeTrack': 20,
  'updateTrack': 21,
};
const _ChangedPartactionTypeValueEnumMap = {
  0: ActionType.addItem,
  1: ActionType.removeItem,
  2: ActionType.updateItem,
  3: ActionType.addCategory,
  4: ActionType.removeCategory,
  5: ActionType.renameCategory,
  6: ActionType.addChapter,
  7: ActionType.removeChapter,
  8: ActionType.updateChapter,
  9: ActionType.clearHistory,
  10: ActionType.addHistory,
  11: ActionType.removeHistory,
  12: ActionType.updateHistory,
  13: ActionType.clearUpdates,
  14: ActionType.addUpdate,
  15: ActionType.clearExtension,
  16: ActionType.addExtension,
  17: ActionType.removeExtension,
  18: ActionType.updateExtension,
  19: ActionType.addTrack,
  20: ActionType.removeTrack,
  21: ActionType.updateTrack,
};

Id _changedPartGetId(ChangedPart object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _changedPartGetLinks(ChangedPart object) {
  return [];
}

void _changedPartAttach(
    IsarCollection<dynamic> col, Id id, ChangedPart object) {
  object.id = id;
}

extension ChangedPartQueryWhereSort
    on QueryBuilder<ChangedPart, ChangedPart, QWhere> {
  QueryBuilder<ChangedPart, ChangedPart, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChangedPartQueryWhere
    on QueryBuilder<ChangedPart, ChangedPart, QWhereClause> {
  QueryBuilder<ChangedPart, ChangedPart, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ChangedPart, ChangedPart, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterWhereClause> idBetween(
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

extension ChangedPartQueryFilter
    on QueryBuilder<ChangedPart, ChangedPart, QFilterCondition> {
  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition>
      actionTypeEqualTo(ActionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionType',
        value: value,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition>
      actionTypeGreaterThan(
    ActionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionType',
        value: value,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition>
      actionTypeLessThan(
    ActionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionType',
        value: value,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition>
      actionTypeBetween(
    ActionType lower,
    ActionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition>
      clientDateEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition>
      clientDateGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clientDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition>
      clientDateLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clientDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition>
      clientDateBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clientDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> dataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> dataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> dataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> dataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'data',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> dataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> dataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> dataContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> dataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'data',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> dataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition>
      dataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> isarIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition>
      isarIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> isarIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterFilterCondition> isarIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChangedPartQueryObject
    on QueryBuilder<ChangedPart, ChangedPart, QFilterCondition> {}

extension ChangedPartQueryLinks
    on QueryBuilder<ChangedPart, ChangedPart, QFilterCondition> {}

extension ChangedPartQuerySortBy
    on QueryBuilder<ChangedPart, ChangedPart, QSortBy> {
  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> sortByActionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionType', Sort.asc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> sortByActionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionType', Sort.desc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> sortByClientDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientDate', Sort.asc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> sortByClientDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientDate', Sort.desc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> sortByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> sortByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> sortByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> sortByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }
}

extension ChangedPartQuerySortThenBy
    on QueryBuilder<ChangedPart, ChangedPart, QSortThenBy> {
  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> thenByActionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionType', Sort.asc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> thenByActionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionType', Sort.desc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> thenByClientDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientDate', Sort.asc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> thenByClientDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientDate', Sort.desc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> thenByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> thenByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }
}

extension ChangedPartQueryWhereDistinct
    on QueryBuilder<ChangedPart, ChangedPart, QDistinct> {
  QueryBuilder<ChangedPart, ChangedPart, QDistinct> distinctByActionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionType');
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QDistinct> distinctByClientDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientDate');
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QDistinct> distinctByData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'data', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChangedPart, ChangedPart, QDistinct> distinctByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isarId');
    });
  }
}

extension ChangedPartQueryProperty
    on QueryBuilder<ChangedPart, ChangedPart, QQueryProperty> {
  QueryBuilder<ChangedPart, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChangedPart, ActionType, QQueryOperations> actionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionType');
    });
  }

  QueryBuilder<ChangedPart, int, QQueryOperations> clientDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientDate');
    });
  }

  QueryBuilder<ChangedPart, String, QQueryOperations> dataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'data');
    });
  }

  QueryBuilder<ChangedPart, int?, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }
}
