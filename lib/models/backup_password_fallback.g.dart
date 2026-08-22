// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_password_fallback.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBackupPasswordFallbackCollection on Isar {
  IsarCollection<BackupPasswordFallback> get backupPasswordFallbacks =>
      this.collection();
}

const BackupPasswordFallbackSchema = CollectionSchema(
  name: r'BackupPasswordFallback',
  id: -8118407212046567982,
  properties: {
    r'password': PropertySchema(
      id: 0,
      name: r'password',
      type: IsarType.string,
    ),
  },

  estimateSize: _backupPasswordFallbackEstimateSize,
  serialize: _backupPasswordFallbackSerialize,
  deserialize: _backupPasswordFallbackDeserialize,
  deserializeProp: _backupPasswordFallbackDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _backupPasswordFallbackGetId,
  getLinks: _backupPasswordFallbackGetLinks,
  attach: _backupPasswordFallbackAttach,
  version: '3.3.2',
);

int _backupPasswordFallbackEstimateSize(
  BackupPasswordFallback object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.password;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _backupPasswordFallbackSerialize(
  BackupPasswordFallback object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.password);
}

BackupPasswordFallback _backupPasswordFallbackDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BackupPasswordFallback();
  object.id = id;
  object.password = reader.readStringOrNull(offsets[0]);
  return object;
}

P _backupPasswordFallbackDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _backupPasswordFallbackGetId(BackupPasswordFallback object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _backupPasswordFallbackGetLinks(
  BackupPasswordFallback object,
) {
  return [];
}

void _backupPasswordFallbackAttach(
  IsarCollection<dynamic> col,
  Id id,
  BackupPasswordFallback object,
) {
  object.id = id;
}

extension BackupPasswordFallbackQueryWhereSort
    on QueryBuilder<BackupPasswordFallback, BackupPasswordFallback, QWhere> {
  QueryBuilder<BackupPasswordFallback, BackupPasswordFallback, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BackupPasswordFallbackQueryWhere
    on
        QueryBuilder<
          BackupPasswordFallback,
          BackupPasswordFallback,
          QWhereClause
        > {
  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
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
    BackupPasswordFallback,
    BackupPasswordFallback,
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
    BackupPasswordFallback,
    BackupPasswordFallback,
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
    BackupPasswordFallback,
    BackupPasswordFallback,
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

extension BackupPasswordFallbackQueryFilter
    on
        QueryBuilder<
          BackupPasswordFallback,
          BackupPasswordFallback,
          QFilterCondition
        > {
  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
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
    BackupPasswordFallback,
    BackupPasswordFallback,
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
    BackupPasswordFallback,
    BackupPasswordFallback,
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
    BackupPasswordFallback,
    BackupPasswordFallback,
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
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'password'),
      );
    });
  }

  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'password'),
      );
    });
  }

  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'password',
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
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'password',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'password', value: ''),
      );
    });
  }

  QueryBuilder<
    BackupPasswordFallback,
    BackupPasswordFallback,
    QAfterFilterCondition
  >
  passwordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'password', value: ''),
      );
    });
  }
}

extension BackupPasswordFallbackQueryObject
    on
        QueryBuilder<
          BackupPasswordFallback,
          BackupPasswordFallback,
          QFilterCondition
        > {}

extension BackupPasswordFallbackQueryLinks
    on
        QueryBuilder<
          BackupPasswordFallback,
          BackupPasswordFallback,
          QFilterCondition
        > {}

extension BackupPasswordFallbackQuerySortBy
    on QueryBuilder<BackupPasswordFallback, BackupPasswordFallback, QSortBy> {
  QueryBuilder<BackupPasswordFallback, BackupPasswordFallback, QAfterSortBy>
  sortByPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.asc);
    });
  }

  QueryBuilder<BackupPasswordFallback, BackupPasswordFallback, QAfterSortBy>
  sortByPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.desc);
    });
  }
}

extension BackupPasswordFallbackQuerySortThenBy
    on
        QueryBuilder<
          BackupPasswordFallback,
          BackupPasswordFallback,
          QSortThenBy
        > {
  QueryBuilder<BackupPasswordFallback, BackupPasswordFallback, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BackupPasswordFallback, BackupPasswordFallback, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BackupPasswordFallback, BackupPasswordFallback, QAfterSortBy>
  thenByPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.asc);
    });
  }

  QueryBuilder<BackupPasswordFallback, BackupPasswordFallback, QAfterSortBy>
  thenByPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'password', Sort.desc);
    });
  }
}

extension BackupPasswordFallbackQueryWhereDistinct
    on QueryBuilder<BackupPasswordFallback, BackupPasswordFallback, QDistinct> {
  QueryBuilder<BackupPasswordFallback, BackupPasswordFallback, QDistinct>
  distinctByPassword({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'password', caseSensitive: caseSensitive);
    });
  }
}

extension BackupPasswordFallbackQueryProperty
    on
        QueryBuilder<
          BackupPasswordFallback,
          BackupPasswordFallback,
          QQueryProperty
        > {
  QueryBuilder<BackupPasswordFallback, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BackupPasswordFallback, String?, QQueryOperations>
  passwordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'password');
    });
  }
}
