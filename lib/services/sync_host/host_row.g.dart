// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_row.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetHostRowCollection on Isar {
  IsarCollection<HostRow> get hostRows => this.collection();
}

const HostRowSchema = CollectionSchema(
  name: r'SyncHostRow',
  id: 3814599180475054033,
  properties: {
    r'clientId': PropertySchema(id: 0, name: r'clientId', type: IsarType.long),
    r'data': PropertySchema(id: 1, name: r'data', type: IsarType.string),
    r'deleted': PropertySchema(id: 2, name: r'deleted', type: IsarType.bool),
    r'entity': PropertySchema(id: 3, name: r'entity', type: IsarType.string),
    r'naturalKey': PropertySchema(
      id: 4,
      name: r'naturalKey',
      type: IsarType.string,
    ),
    r'parentClientId': PropertySchema(
      id: 5,
      name: r'parentClientId',
      type: IsarType.long,
    ),
    r'receivedAt': PropertySchema(
      id: 6,
      name: r'receivedAt',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.long,
    ),
  },

  estimateSize: _hostRowEstimateSize,
  serialize: _hostRowSerialize,
  deserialize: _hostRowDeserialize,
  deserializeProp: _hostRowDeserializeProp,
  idName: r'id',
  indexes: {
    r'entity_clientId': IndexSchema(
      id: 5447400269679559209,
      name: r'entity_clientId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entity',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'clientId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'entity_receivedAt': IndexSchema(
      id: -8122596750726217368,
      name: r'entity_receivedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entity',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'receivedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'entity_naturalKey': IndexSchema(
      id: 138597242367321157,
      name: r'entity_naturalKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entity',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'naturalKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'entity_parentClientId': IndexSchema(
      id: -2502218124833600095,
      name: r'entity_parentClientId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entity',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'parentClientId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'receivedAt': IndexSchema(
      id: -6277795886715409418,
      name: r'receivedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'receivedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _hostRowGetId,
  getLinks: _hostRowGetLinks,
  attach: _hostRowAttach,
  version: '3.4.1',
);

int _hostRowEstimateSize(
  HostRow object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.data;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.entity.length * 3;
  {
    final value = object.naturalKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _hostRowSerialize(
  HostRow object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.clientId);
  writer.writeString(offsets[1], object.data);
  writer.writeBool(offsets[2], object.deleted);
  writer.writeString(offsets[3], object.entity);
  writer.writeString(offsets[4], object.naturalKey);
  writer.writeLong(offsets[5], object.parentClientId);
  writer.writeLong(offsets[6], object.receivedAt);
  writer.writeLong(offsets[7], object.updatedAt);
}

HostRow _hostRowDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HostRow();
  object.clientId = reader.readLong(offsets[0]);
  object.data = reader.readStringOrNull(offsets[1]);
  object.deleted = reader.readBool(offsets[2]);
  object.entity = reader.readString(offsets[3]);
  object.id = id;
  object.naturalKey = reader.readStringOrNull(offsets[4]);
  object.parentClientId = reader.readLongOrNull(offsets[5]);
  object.receivedAt = reader.readLong(offsets[6]);
  object.updatedAt = reader.readLong(offsets[7]);
  return object;
}

P _hostRowDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hostRowGetId(HostRow object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _hostRowGetLinks(HostRow object) {
  return [];
}

void _hostRowAttach(IsarCollection<dynamic> col, Id id, HostRow object) {
  object.id = id;
}

extension HostRowByIndex on IsarCollection<HostRow> {
  Future<HostRow?> getByEntityClientId(String entity, int clientId) {
    return getByIndex(r'entity_clientId', [entity, clientId]);
  }

  HostRow? getByEntityClientIdSync(String entity, int clientId) {
    return getByIndexSync(r'entity_clientId', [entity, clientId]);
  }

  Future<bool> deleteByEntityClientId(String entity, int clientId) {
    return deleteByIndex(r'entity_clientId', [entity, clientId]);
  }

  bool deleteByEntityClientIdSync(String entity, int clientId) {
    return deleteByIndexSync(r'entity_clientId', [entity, clientId]);
  }

  Future<List<HostRow?>> getAllByEntityClientId(
    List<String> entityValues,
    List<int> clientIdValues,
  ) {
    final len = entityValues.length;
    assert(
      clientIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([entityValues[i], clientIdValues[i]]);
    }

    return getAllByIndex(r'entity_clientId', values);
  }

  List<HostRow?> getAllByEntityClientIdSync(
    List<String> entityValues,
    List<int> clientIdValues,
  ) {
    final len = entityValues.length;
    assert(
      clientIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([entityValues[i], clientIdValues[i]]);
    }

    return getAllByIndexSync(r'entity_clientId', values);
  }

  Future<int> deleteAllByEntityClientId(
    List<String> entityValues,
    List<int> clientIdValues,
  ) {
    final len = entityValues.length;
    assert(
      clientIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([entityValues[i], clientIdValues[i]]);
    }

    return deleteAllByIndex(r'entity_clientId', values);
  }

  int deleteAllByEntityClientIdSync(
    List<String> entityValues,
    List<int> clientIdValues,
  ) {
    final len = entityValues.length;
    assert(
      clientIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([entityValues[i], clientIdValues[i]]);
    }

    return deleteAllByIndexSync(r'entity_clientId', values);
  }

  Future<Id> putByEntityClientId(HostRow object) {
    return putByIndex(r'entity_clientId', object);
  }

  Id putByEntityClientIdSync(HostRow object, {bool saveLinks = true}) {
    return putByIndexSync(r'entity_clientId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEntityClientId(List<HostRow> objects) {
    return putAllByIndex(r'entity_clientId', objects);
  }

  List<Id> putAllByEntityClientIdSync(
    List<HostRow> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'entity_clientId', objects, saveLinks: saveLinks);
  }
}

extension HostRowQueryWhereSort on QueryBuilder<HostRow, HostRow, QWhere> {
  QueryBuilder<HostRow, HostRow, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhere> anyReceivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'receivedAt'),
      );
    });
  }
}

extension HostRowQueryWhere on QueryBuilder<HostRow, HostRow, QWhereClause> {
  QueryBuilder<HostRow, HostRow, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> idBetween(
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

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> entityEqualToAnyClientId(
    String entity,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'entity_clientId',
          value: [entity],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> entityNotEqualToAnyClientId(
    String entity,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_clientId',
                lower: [],
                upper: [entity],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_clientId',
                lower: [entity],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_clientId',
                lower: [entity],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_clientId',
                lower: [],
                upper: [entity],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> entityClientIdEqualTo(
    String entity,
    int clientId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'entity_clientId',
          value: [entity, clientId],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToClientIdNotEqualTo(String entity, int clientId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_clientId',
                lower: [entity],
                upper: [entity, clientId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_clientId',
                lower: [entity, clientId],
                includeLower: false,
                upper: [entity],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_clientId',
                lower: [entity, clientId],
                includeLower: false,
                upper: [entity],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_clientId',
                lower: [entity],
                upper: [entity, clientId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToClientIdGreaterThan(
    String entity,
    int clientId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entity_clientId',
          lower: [entity, clientId],
          includeLower: include,
          upper: [entity],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToClientIdLessThan(
    String entity,
    int clientId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entity_clientId',
          lower: [entity],
          upper: [entity, clientId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToClientIdBetween(
    String entity,
    int lowerClientId,
    int upperClientId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entity_clientId',
          lower: [entity, lowerClientId],
          includeLower: includeLower,
          upper: [entity, upperClientId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> entityEqualToAnyReceivedAt(
    String entity,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'entity_receivedAt',
          value: [entity],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityNotEqualToAnyReceivedAt(String entity) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_receivedAt',
                lower: [],
                upper: [entity],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_receivedAt',
                lower: [entity],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_receivedAt',
                lower: [entity],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_receivedAt',
                lower: [],
                upper: [entity],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> entityReceivedAtEqualTo(
    String entity,
    int receivedAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'entity_receivedAt',
          value: [entity, receivedAt],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToReceivedAtNotEqualTo(String entity, int receivedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_receivedAt',
                lower: [entity],
                upper: [entity, receivedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_receivedAt',
                lower: [entity, receivedAt],
                includeLower: false,
                upper: [entity],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_receivedAt',
                lower: [entity, receivedAt],
                includeLower: false,
                upper: [entity],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_receivedAt',
                lower: [entity],
                upper: [entity, receivedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToReceivedAtGreaterThan(
    String entity,
    int receivedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entity_receivedAt',
          lower: [entity, receivedAt],
          includeLower: include,
          upper: [entity],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToReceivedAtLessThan(
    String entity,
    int receivedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entity_receivedAt',
          lower: [entity],
          upper: [entity, receivedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToReceivedAtBetween(
    String entity,
    int lowerReceivedAt,
    int upperReceivedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entity_receivedAt',
          lower: [entity, lowerReceivedAt],
          includeLower: includeLower,
          upper: [entity, upperReceivedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> entityEqualToAnyNaturalKey(
    String entity,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'entity_naturalKey',
          value: [entity],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityNotEqualToAnyNaturalKey(String entity) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_naturalKey',
                lower: [],
                upper: [entity],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_naturalKey',
                lower: [entity],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_naturalKey',
                lower: [entity],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_naturalKey',
                lower: [],
                upper: [entity],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToNaturalKeyIsNull(String entity) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'entity_naturalKey',
          value: [entity, null],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToNaturalKeyIsNotNull(String entity) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entity_naturalKey',
          lower: [entity, null],
          includeLower: false,
          upper: [entity],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> entityNaturalKeyEqualTo(
    String entity,
    String? naturalKey,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'entity_naturalKey',
          value: [entity, naturalKey],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToNaturalKeyNotEqualTo(String entity, String? naturalKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_naturalKey',
                lower: [entity],
                upper: [entity, naturalKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_naturalKey',
                lower: [entity, naturalKey],
                includeLower: false,
                upper: [entity],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_naturalKey',
                lower: [entity, naturalKey],
                includeLower: false,
                upper: [entity],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_naturalKey',
                lower: [entity],
                upper: [entity, naturalKey],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToAnyParentClientId(String entity) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'entity_parentClientId',
          value: [entity],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityNotEqualToAnyParentClientId(String entity) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_parentClientId',
                lower: [],
                upper: [entity],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_parentClientId',
                lower: [entity],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_parentClientId',
                lower: [entity],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_parentClientId',
                lower: [],
                upper: [entity],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToParentClientIdIsNull(String entity) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'entity_parentClientId',
          value: [entity, null],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToParentClientIdIsNotNull(String entity) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entity_parentClientId',
          lower: [entity, null],
          includeLower: false,
          upper: [entity],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> entityParentClientIdEqualTo(
    String entity,
    int? parentClientId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'entity_parentClientId',
          value: [entity, parentClientId],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToParentClientIdNotEqualTo(String entity, int? parentClientId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_parentClientId',
                lower: [entity],
                upper: [entity, parentClientId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_parentClientId',
                lower: [entity, parentClientId],
                includeLower: false,
                upper: [entity],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_parentClientId',
                lower: [entity, parentClientId],
                includeLower: false,
                upper: [entity],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'entity_parentClientId',
                lower: [entity],
                upper: [entity, parentClientId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToParentClientIdGreaterThan(
    String entity,
    int? parentClientId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entity_parentClientId',
          lower: [entity, parentClientId],
          includeLower: include,
          upper: [entity],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToParentClientIdLessThan(
    String entity,
    int? parentClientId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entity_parentClientId',
          lower: [entity],
          upper: [entity, parentClientId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause>
  entityEqualToParentClientIdBetween(
    String entity,
    int? lowerParentClientId,
    int? upperParentClientId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'entity_parentClientId',
          lower: [entity, lowerParentClientId],
          includeLower: includeLower,
          upper: [entity, upperParentClientId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> receivedAtEqualTo(
    int receivedAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'receivedAt', value: [receivedAt]),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> receivedAtNotEqualTo(
    int receivedAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'receivedAt',
                lower: [],
                upper: [receivedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'receivedAt',
                lower: [receivedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'receivedAt',
                lower: [receivedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'receivedAt',
                lower: [],
                upper: [receivedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> receivedAtGreaterThan(
    int receivedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'receivedAt',
          lower: [receivedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> receivedAtLessThan(
    int receivedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'receivedAt',
          lower: [],
          upper: [receivedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterWhereClause> receivedAtBetween(
    int lowerReceivedAt,
    int upperReceivedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'receivedAt',
          lower: [lowerReceivedAt],
          includeLower: includeLower,
          upper: [upperReceivedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension HostRowQueryFilter
    on QueryBuilder<HostRow, HostRow, QFilterCondition> {
  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> clientIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'clientId', value: value),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> clientIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'clientId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> clientIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'clientId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> clientIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'clientId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'data'),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'data'),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'data',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'data',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'data',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'data',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'data',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'data',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'data',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'data',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'data', value: ''),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> dataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'data', value: ''),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> deletedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deleted', value: value),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> entityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'entity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> entityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'entity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> entityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'entity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> entityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'entity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> entityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'entity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> entityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'entity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> entityContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'entity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> entityMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'entity',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> entityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entity', value: ''),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> entityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'entity', value: ''),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> idGreaterThan(
    Id value, {
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

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> idBetween(
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

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'naturalKey'),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'naturalKey'),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'naturalKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'naturalKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'naturalKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'naturalKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'naturalKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'naturalKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'naturalKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'naturalKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'naturalKey', value: ''),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> naturalKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'naturalKey', value: ''),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> parentClientIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'parentClientId'),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition>
  parentClientIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'parentClientId'),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> parentClientIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'parentClientId', value: value),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition>
  parentClientIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'parentClientId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> parentClientIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'parentClientId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> parentClientIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'parentClientId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> receivedAtEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'receivedAt', value: value),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> receivedAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'receivedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> receivedAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'receivedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> receivedAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'receivedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> updatedAtEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> updatedAtGreaterThan(
    int value, {
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

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> updatedAtLessThan(
    int value, {
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

  QueryBuilder<HostRow, HostRow, QAfterFilterCondition> updatedAtBetween(
    int lower,
    int upper, {
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

extension HostRowQueryObject
    on QueryBuilder<HostRow, HostRow, QFilterCondition> {}

extension HostRowQueryLinks
    on QueryBuilder<HostRow, HostRow, QFilterCondition> {}

extension HostRowQuerySortBy on QueryBuilder<HostRow, HostRow, QSortBy> {
  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByEntity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByEntityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByNaturalKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naturalKey', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByNaturalKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naturalKey', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByParentClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentClientId', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByParentClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentClientId', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByReceivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByReceivedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension HostRowQuerySortThenBy
    on QueryBuilder<HostRow, HostRow, QSortThenBy> {
  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientId', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleted', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByEntity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByEntityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByNaturalKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naturalKey', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByNaturalKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'naturalKey', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByParentClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentClientId', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByParentClientIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentClientId', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByReceivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByReceivedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedAt', Sort.desc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HostRow, HostRow, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension HostRowQueryWhereDistinct
    on QueryBuilder<HostRow, HostRow, QDistinct> {
  QueryBuilder<HostRow, HostRow, QDistinct> distinctByClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientId');
    });
  }

  QueryBuilder<HostRow, HostRow, QDistinct> distinctByData({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'data', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HostRow, HostRow, QDistinct> distinctByDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deleted');
    });
  }

  QueryBuilder<HostRow, HostRow, QDistinct> distinctByEntity({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entity', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HostRow, HostRow, QDistinct> distinctByNaturalKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'naturalKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HostRow, HostRow, QDistinct> distinctByParentClientId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentClientId');
    });
  }

  QueryBuilder<HostRow, HostRow, QDistinct> distinctByReceivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receivedAt');
    });
  }

  QueryBuilder<HostRow, HostRow, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension HostRowQueryProperty
    on QueryBuilder<HostRow, HostRow, QQueryProperty> {
  QueryBuilder<HostRow, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HostRow, int, QQueryOperations> clientIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientId');
    });
  }

  QueryBuilder<HostRow, String?, QQueryOperations> dataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'data');
    });
  }

  QueryBuilder<HostRow, bool, QQueryOperations> deletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deleted');
    });
  }

  QueryBuilder<HostRow, String, QQueryOperations> entityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entity');
    });
  }

  QueryBuilder<HostRow, String?, QQueryOperations> naturalKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'naturalKey');
    });
  }

  QueryBuilder<HostRow, int?, QQueryOperations> parentClientIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentClientId');
    });
  }

  QueryBuilder<HostRow, int, QQueryOperations> receivedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receivedAt');
    });
  }

  QueryBuilder<HostRow, int, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
