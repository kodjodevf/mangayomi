// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsCollection on Isar {
  IsarCollection<Settings> get settings => this.collection();
}

const SettingsSchema = CollectionSchema(
  name: r'Settings',
  id: -8656046621518759136,
  properties: {
    r'chapterFilterBookmarkedList': PropertySchema(
      id: 0,
      name: r'chapterFilterBookmarkedList',
      type: IsarType.objectList,
      target: r'ChapterFilterBookmarked',
    ),
    r'chapterFilterDownloadedList': PropertySchema(
      id: 1,
      name: r'chapterFilterDownloadedList',
      type: IsarType.objectList,
      target: r'ChapterFilterDownloaded',
    ),
    r'chapterFilterUnreadList': PropertySchema(
      id: 2,
      name: r'chapterFilterUnreadList',
      type: IsarType.objectList,
      target: r'ChapterFilterUnread',
    ),
    r'chapterPageIndexList': PropertySchema(
      id: 3,
      name: r'chapterPageIndexList',
      type: IsarType.objectList,
      target: r'ChapterPageIndex',
    ),
    r'chapterPageUrlsList': PropertySchema(
      id: 4,
      name: r'chapterPageUrlsList',
      type: IsarType.objectList,
      target: r'ChapterPageurls',
    ),
    r'cookiesList': PropertySchema(
      id: 5,
      name: r'cookiesList',
      type: IsarType.objectList,
      target: r'Cookie',
    ),
    r'dateFormat': PropertySchema(
      id: 6,
      name: r'dateFormat',
      type: IsarType.string,
    ),
    r'displayType': PropertySchema(
      id: 7,
      name: r'displayType',
      type: IsarType.byte,
      enumMap: _SettingsdisplayTypeEnumValueMap,
    ),
    r'flexColorSchemeBlendLevel': PropertySchema(
      id: 8,
      name: r'flexColorSchemeBlendLevel',
      type: IsarType.double,
    ),
    r'flexSchemeColorIndex': PropertySchema(
      id: 9,
      name: r'flexSchemeColorIndex',
      type: IsarType.long,
    ),
    r'incognitoMode': PropertySchema(
      id: 10,
      name: r'incognitoMode',
      type: IsarType.bool,
    ),
    r'libraryDownloadedChapters': PropertySchema(
      id: 11,
      name: r'libraryDownloadedChapters',
      type: IsarType.bool,
    ),
    r'libraryFilterMangasBookMarkedType': PropertySchema(
      id: 12,
      name: r'libraryFilterMangasBookMarkedType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasDownloadType': PropertySchema(
      id: 13,
      name: r'libraryFilterMangasDownloadType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasStartedType': PropertySchema(
      id: 14,
      name: r'libraryFilterMangasStartedType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasUnreadType': PropertySchema(
      id: 15,
      name: r'libraryFilterMangasUnreadType',
      type: IsarType.long,
    ),
    r'libraryShowCategoryTabs': PropertySchema(
      id: 16,
      name: r'libraryShowCategoryTabs',
      type: IsarType.bool,
    ),
    r'libraryShowContinueReadingButton': PropertySchema(
      id: 17,
      name: r'libraryShowContinueReadingButton',
      type: IsarType.bool,
    ),
    r'libraryShowLanguage': PropertySchema(
      id: 18,
      name: r'libraryShowLanguage',
      type: IsarType.bool,
    ),
    r'libraryShowNumbersOfItems': PropertySchema(
      id: 19,
      name: r'libraryShowNumbersOfItems',
      type: IsarType.bool,
    ),
    r'relativeTimesTamps': PropertySchema(
      id: 20,
      name: r'relativeTimesTamps',
      type: IsarType.long,
    ),
    r'showPagesNumber': PropertySchema(
      id: 21,
      name: r'showPagesNumber',
      type: IsarType.bool,
    ),
    r'sortChapterList': PropertySchema(
      id: 22,
      name: r'sortChapterList',
      type: IsarType.objectList,
      target: r'SortChapter',
    ),
    r'sortLibraryManga': PropertySchema(
      id: 23,
      name: r'sortLibraryManga',
      type: IsarType.object,
      target: r'SortLibraryManga',
    ),
    r'themeIsDark': PropertySchema(
      id: 24,
      name: r'themeIsDark',
      type: IsarType.bool,
    ),
    r'userAgent': PropertySchema(
      id: 25,
      name: r'userAgent',
      type: IsarType.string,
    )
  },
  estimateSize: _settingsEstimateSize,
  serialize: _settingsSerialize,
  deserialize: _settingsDeserialize,
  deserializeProp: _settingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'SortLibraryManga': SortLibraryMangaSchema,
    r'SortChapter': SortChapterSchema,
    r'ChapterFilterDownloaded': ChapterFilterDownloadedSchema,
    r'ChapterFilterUnread': ChapterFilterUnreadSchema,
    r'ChapterFilterBookmarked': ChapterFilterBookmarkedSchema,
    r'ChapterPageurls': ChapterPageurlsSchema,
    r'ChapterPageIndex': ChapterPageIndexSchema,
    r'Cookie': CookieSchema
  },
  getId: _settingsGetId,
  getLinks: _settingsGetLinks,
  attach: _settingsAttach,
  version: '3.1.0+1',
);

int _settingsEstimateSize(
  Settings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.chapterFilterBookmarkedList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ChapterFilterBookmarked]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += ChapterFilterBookmarkedSchema.estimateSize(
              value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.chapterFilterDownloadedList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ChapterFilterDownloaded]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += ChapterFilterDownloadedSchema.estimateSize(
              value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.chapterFilterUnreadList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ChapterFilterUnread]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += ChapterFilterUnreadSchema.estimateSize(
              value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.chapterPageIndexList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ChapterPageIndex]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              ChapterPageIndexSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.chapterPageUrlsList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ChapterPageurls]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              ChapterPageurlsSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.cookiesList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Cookie]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += CookieSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.dateFormat;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.sortChapterList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[SortChapter]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              SortChapterSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.sortLibraryManga;
    if (value != null) {
      bytesCount += 3 +
          SortLibraryMangaSchema.estimateSize(
              value, allOffsets[SortLibraryManga]!, allOffsets);
    }
  }
  {
    final value = object.userAgent;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _settingsSerialize(
  Settings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<ChapterFilterBookmarked>(
    offsets[0],
    allOffsets,
    ChapterFilterBookmarkedSchema.serialize,
    object.chapterFilterBookmarkedList,
  );
  writer.writeObjectList<ChapterFilterDownloaded>(
    offsets[1],
    allOffsets,
    ChapterFilterDownloadedSchema.serialize,
    object.chapterFilterDownloadedList,
  );
  writer.writeObjectList<ChapterFilterUnread>(
    offsets[2],
    allOffsets,
    ChapterFilterUnreadSchema.serialize,
    object.chapterFilterUnreadList,
  );
  writer.writeObjectList<ChapterPageIndex>(
    offsets[3],
    allOffsets,
    ChapterPageIndexSchema.serialize,
    object.chapterPageIndexList,
  );
  writer.writeObjectList<ChapterPageurls>(
    offsets[4],
    allOffsets,
    ChapterPageurlsSchema.serialize,
    object.chapterPageUrlsList,
  );
  writer.writeObjectList<Cookie>(
    offsets[5],
    allOffsets,
    CookieSchema.serialize,
    object.cookiesList,
  );
  writer.writeString(offsets[6], object.dateFormat);
  writer.writeByte(offsets[7], object.displayType.index);
  writer.writeDouble(offsets[8], object.flexColorSchemeBlendLevel);
  writer.writeLong(offsets[9], object.flexSchemeColorIndex);
  writer.writeBool(offsets[10], object.incognitoMode);
  writer.writeBool(offsets[11], object.libraryDownloadedChapters);
  writer.writeLong(offsets[12], object.libraryFilterMangasBookMarkedType);
  writer.writeLong(offsets[13], object.libraryFilterMangasDownloadType);
  writer.writeLong(offsets[14], object.libraryFilterMangasStartedType);
  writer.writeLong(offsets[15], object.libraryFilterMangasUnreadType);
  writer.writeBool(offsets[16], object.libraryShowCategoryTabs);
  writer.writeBool(offsets[17], object.libraryShowContinueReadingButton);
  writer.writeBool(offsets[18], object.libraryShowLanguage);
  writer.writeBool(offsets[19], object.libraryShowNumbersOfItems);
  writer.writeLong(offsets[20], object.relativeTimesTamps);
  writer.writeBool(offsets[21], object.showPagesNumber);
  writer.writeObjectList<SortChapter>(
    offsets[22],
    allOffsets,
    SortChapterSchema.serialize,
    object.sortChapterList,
  );
  writer.writeObject<SortLibraryManga>(
    offsets[23],
    allOffsets,
    SortLibraryMangaSchema.serialize,
    object.sortLibraryManga,
  );
  writer.writeBool(offsets[24], object.themeIsDark);
  writer.writeString(offsets[25], object.userAgent);
}

Settings _settingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Settings(
    chapterFilterDownloadedList: reader.readObjectList<ChapterFilterDownloaded>(
      offsets[1],
      ChapterFilterDownloadedSchema.deserialize,
      allOffsets,
      ChapterFilterDownloaded(),
    ),
    chapterPageIndexList: reader.readObjectList<ChapterPageIndex>(
      offsets[3],
      ChapterPageIndexSchema.deserialize,
      allOffsets,
      ChapterPageIndex(),
    ),
    chapterPageUrlsList: reader.readObjectList<ChapterPageurls>(
      offsets[4],
      ChapterPageurlsSchema.deserialize,
      allOffsets,
      ChapterPageurls(),
    ),
    cookiesList: reader.readObjectList<Cookie>(
      offsets[5],
      CookieSchema.deserialize,
      allOffsets,
      Cookie(),
    ),
    dateFormat: reader.readStringOrNull(offsets[6]),
    displayType:
        _SettingsdisplayTypeValueEnumMap[reader.readByteOrNull(offsets[7])] ??
            DisplayType.compactGrid,
    flexColorSchemeBlendLevel: reader.readDoubleOrNull(offsets[8]),
    flexSchemeColorIndex: reader.readLongOrNull(offsets[9]),
    id: id,
    incognitoMode: reader.readBoolOrNull(offsets[10]),
    libraryDownloadedChapters: reader.readBoolOrNull(offsets[11]),
    libraryFilterMangasBookMarkedType: reader.readLongOrNull(offsets[12]),
    libraryFilterMangasDownloadType: reader.readLongOrNull(offsets[13]),
    libraryFilterMangasStartedType: reader.readLongOrNull(offsets[14]),
    libraryFilterMangasUnreadType: reader.readLongOrNull(offsets[15]),
    libraryShowCategoryTabs: reader.readBoolOrNull(offsets[16]),
    libraryShowContinueReadingButton: reader.readBoolOrNull(offsets[17]),
    libraryShowLanguage: reader.readBoolOrNull(offsets[18]),
    libraryShowNumbersOfItems: reader.readBoolOrNull(offsets[19]),
    relativeTimesTamps: reader.readLongOrNull(offsets[20]),
    showPagesNumber: reader.readBoolOrNull(offsets[21]),
    sortChapterList: reader.readObjectList<SortChapter>(
      offsets[22],
      SortChapterSchema.deserialize,
      allOffsets,
      SortChapter(),
    ),
    sortLibraryManga: reader.readObjectOrNull<SortLibraryManga>(
      offsets[23],
      SortLibraryMangaSchema.deserialize,
      allOffsets,
    ),
    themeIsDark: reader.readBoolOrNull(offsets[24]),
    userAgent: reader.readStringOrNull(offsets[25]),
  );
  object.chapterFilterBookmarkedList =
      reader.readObjectList<ChapterFilterBookmarked>(
    offsets[0],
    ChapterFilterBookmarkedSchema.deserialize,
    allOffsets,
    ChapterFilterBookmarked(),
  );
  object.chapterFilterUnreadList = reader.readObjectList<ChapterFilterUnread>(
    offsets[2],
    ChapterFilterUnreadSchema.deserialize,
    allOffsets,
    ChapterFilterUnread(),
  );
  return object;
}

P _settingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<ChapterFilterBookmarked>(
        offset,
        ChapterFilterBookmarkedSchema.deserialize,
        allOffsets,
        ChapterFilterBookmarked(),
      )) as P;
    case 1:
      return (reader.readObjectList<ChapterFilterDownloaded>(
        offset,
        ChapterFilterDownloadedSchema.deserialize,
        allOffsets,
        ChapterFilterDownloaded(),
      )) as P;
    case 2:
      return (reader.readObjectList<ChapterFilterUnread>(
        offset,
        ChapterFilterUnreadSchema.deserialize,
        allOffsets,
        ChapterFilterUnread(),
      )) as P;
    case 3:
      return (reader.readObjectList<ChapterPageIndex>(
        offset,
        ChapterPageIndexSchema.deserialize,
        allOffsets,
        ChapterPageIndex(),
      )) as P;
    case 4:
      return (reader.readObjectList<ChapterPageurls>(
        offset,
        ChapterPageurlsSchema.deserialize,
        allOffsets,
        ChapterPageurls(),
      )) as P;
    case 5:
      return (reader.readObjectList<Cookie>(
        offset,
        CookieSchema.deserialize,
        allOffsets,
        Cookie(),
      )) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (_SettingsdisplayTypeValueEnumMap[reader.readByteOrNull(offset)] ??
          DisplayType.compactGrid) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset)) as P;
    case 16:
      return (reader.readBoolOrNull(offset)) as P;
    case 17:
      return (reader.readBoolOrNull(offset)) as P;
    case 18:
      return (reader.readBoolOrNull(offset)) as P;
    case 19:
      return (reader.readBoolOrNull(offset)) as P;
    case 20:
      return (reader.readLongOrNull(offset)) as P;
    case 21:
      return (reader.readBoolOrNull(offset)) as P;
    case 22:
      return (reader.readObjectList<SortChapter>(
        offset,
        SortChapterSchema.deserialize,
        allOffsets,
        SortChapter(),
      )) as P;
    case 23:
      return (reader.readObjectOrNull<SortLibraryManga>(
        offset,
        SortLibraryMangaSchema.deserialize,
        allOffsets,
      )) as P;
    case 24:
      return (reader.readBoolOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SettingsdisplayTypeEnumValueMap = {
  'compactGrid': 0,
  'comfortableGrid': 1,
  'coverOnlyGrid': 2,
  'list': 3,
};
const _SettingsdisplayTypeValueEnumMap = {
  0: DisplayType.compactGrid,
  1: DisplayType.comfortableGrid,
  2: DisplayType.coverOnlyGrid,
  3: DisplayType.list,
};

Id _settingsGetId(Settings object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _settingsGetLinks(Settings object) {
  return [];
}

void _settingsAttach(IsarCollection<dynamic> col, Id id, Settings object) {
  object.id = id;
}

extension SettingsQueryWhereSort on QueryBuilder<Settings, Settings, QWhere> {
  QueryBuilder<Settings, Settings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsQueryWhere on QueryBuilder<Settings, Settings, QWhereClause> {
  QueryBuilder<Settings, Settings, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Settings, Settings, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idBetween(
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

extension SettingsQueryFilter
    on QueryBuilder<Settings, Settings, QFilterCondition> {
  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterBookmarkedListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterFilterBookmarkedList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterBookmarkedListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterFilterBookmarkedList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterBookmarkedListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterBookmarkedList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterBookmarkedListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterBookmarkedList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterBookmarkedListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterBookmarkedList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterBookmarkedListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterBookmarkedList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterBookmarkedListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterBookmarkedList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterBookmarkedListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterBookmarkedList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterDownloadedListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterFilterDownloadedList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterDownloadedListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterFilterDownloadedList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterDownloadedListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterDownloadedList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterDownloadedListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterDownloadedList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterDownloadedListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterDownloadedList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterDownloadedListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterDownloadedList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterDownloadedListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterDownloadedList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterDownloadedListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterDownloadedList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterUnreadListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterFilterUnreadList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterUnreadListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterFilterUnreadList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterUnreadListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterUnreadList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterUnreadListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterUnreadList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterUnreadListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterUnreadList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterUnreadListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterUnreadList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterUnreadListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterUnreadList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterUnreadListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterFilterUnreadList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageIndexListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterPageIndexList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageIndexListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterPageIndexList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageIndexListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageIndexList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageIndexListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageIndexList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageIndexListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageIndexList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageIndexListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageIndexList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageIndexListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageIndexList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageIndexListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageIndexList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageUrlsListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterPageUrlsList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageUrlsListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterPageUrlsList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageUrlsListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageUrlsList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageUrlsListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageUrlsList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageUrlsListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageUrlsList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageUrlsListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageUrlsList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageUrlsListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageUrlsList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageUrlsListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chapterPageUrlsList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cookiesListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cookiesList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      cookiesListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cookiesList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      cookiesListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cookiesList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cookiesListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cookiesList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      cookiesListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cookiesList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      cookiesListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cookiesList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      cookiesListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cookiesList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      cookiesListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cookiesList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateFormat',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      dateFormatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateFormat',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatEqualTo(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatGreaterThan(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatLessThan(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatBetween(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatStartsWith(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatEndsWith(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatContains(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatMatches(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateFormat',
        value: '',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      dateFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateFormat',
        value: '',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> displayTypeEqualTo(
      DisplayType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      displayTypeGreaterThan(
    DisplayType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> displayTypeLessThan(
    DisplayType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> displayTypeBetween(
    DisplayType lower,
    DisplayType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexColorSchemeBlendLevelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'flexColorSchemeBlendLevel',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexColorSchemeBlendLevelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'flexColorSchemeBlendLevel',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexColorSchemeBlendLevelEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flexColorSchemeBlendLevel',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexColorSchemeBlendLevelGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'flexColorSchemeBlendLevel',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexColorSchemeBlendLevelLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'flexColorSchemeBlendLevel',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexColorSchemeBlendLevelBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'flexColorSchemeBlendLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexSchemeColorIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'flexSchemeColorIndex',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexSchemeColorIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'flexSchemeColorIndex',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexSchemeColorIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flexSchemeColorIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexSchemeColorIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'flexSchemeColorIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexSchemeColorIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'flexSchemeColorIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      flexSchemeColorIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'flexSchemeColorIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      incognitoModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'incognitoMode',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      incognitoModeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'incognitoMode',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> incognitoModeEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'incognitoMode',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryDownloadedChaptersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'libraryDownloadedChapters',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryDownloadedChaptersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'libraryDownloadedChapters',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryDownloadedChaptersEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libraryDownloadedChapters',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasBookMarkedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'libraryFilterMangasBookMarkedType',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasBookMarkedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'libraryFilterMangasBookMarkedType',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasBookMarkedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libraryFilterMangasBookMarkedType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasBookMarkedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'libraryFilterMangasBookMarkedType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasBookMarkedTypeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'libraryFilterMangasBookMarkedType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasBookMarkedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'libraryFilterMangasBookMarkedType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasDownloadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'libraryFilterMangasDownloadType',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasDownloadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'libraryFilterMangasDownloadType',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasDownloadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libraryFilterMangasDownloadType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasDownloadTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'libraryFilterMangasDownloadType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasDownloadTypeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'libraryFilterMangasDownloadType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasDownloadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'libraryFilterMangasDownloadType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasStartedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'libraryFilterMangasStartedType',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasStartedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'libraryFilterMangasStartedType',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasStartedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libraryFilterMangasStartedType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasStartedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'libraryFilterMangasStartedType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasStartedTypeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'libraryFilterMangasStartedType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasStartedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'libraryFilterMangasStartedType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasUnreadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'libraryFilterMangasUnreadType',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasUnreadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'libraryFilterMangasUnreadType',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasUnreadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libraryFilterMangasUnreadType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasUnreadTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'libraryFilterMangasUnreadType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasUnreadTypeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'libraryFilterMangasUnreadType',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryFilterMangasUnreadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'libraryFilterMangasUnreadType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowCategoryTabsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'libraryShowCategoryTabs',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowCategoryTabsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'libraryShowCategoryTabs',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowCategoryTabsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libraryShowCategoryTabs',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowContinueReadingButtonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'libraryShowContinueReadingButton',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowContinueReadingButtonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'libraryShowContinueReadingButton',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowContinueReadingButtonEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libraryShowContinueReadingButton',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'libraryShowLanguage',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'libraryShowLanguage',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowLanguageEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libraryShowLanguage',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowNumbersOfItemsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'libraryShowNumbersOfItems',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowNumbersOfItemsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'libraryShowNumbersOfItems',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      libraryShowNumbersOfItemsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'libraryShowNumbersOfItems',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      relativeTimesTampsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relativeTimesTamps',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      relativeTimesTampsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relativeTimesTamps',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      relativeTimesTampsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relativeTimesTamps',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      relativeTimesTampsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relativeTimesTamps',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      relativeTimesTampsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relativeTimesTamps',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      relativeTimesTampsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relativeTimesTamps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      showPagesNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'showPagesNumber',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      showPagesNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'showPagesNumber',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      showPagesNumberEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showPagesNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sortChapterListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sortChapterList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sortChapterListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sortChapterList',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sortChapterListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sortChapterList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sortChapterListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sortChapterList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sortChapterListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sortChapterList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sortChapterListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sortChapterList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sortChapterListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sortChapterList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sortChapterListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sortChapterList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sortLibraryMangaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sortLibraryManga',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sortLibraryMangaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sortLibraryManga',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> themeIsDarkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'themeIsDark',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      themeIsDarkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'themeIsDark',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> themeIsDarkEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeIsDark',
        value: value,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userAgent',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userAgent',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userAgent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userAgent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userAgent',
        value: '',
      ));
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      userAgentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userAgent',
        value: '',
      ));
    });
  }
}

extension SettingsQueryObject
    on QueryBuilder<Settings, Settings, QFilterCondition> {
  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterBookmarkedListElement(
          FilterQuery<ChapterFilterBookmarked> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'chapterFilterBookmarkedList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterDownloadedListElement(
          FilterQuery<ChapterFilterDownloaded> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'chapterFilterDownloadedList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterFilterUnreadListElement(FilterQuery<ChapterFilterUnread> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'chapterFilterUnreadList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageIndexListElement(FilterQuery<ChapterPageIndex> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'chapterPageIndexList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      chapterPageUrlsListElement(FilterQuery<ChapterPageurls> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'chapterPageUrlsList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cookiesListElement(
      FilterQuery<Cookie> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'cookiesList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
      sortChapterListElement(FilterQuery<SortChapter> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sortChapterList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sortLibraryManga(
      FilterQuery<SortLibraryManga> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sortLibraryManga');
    });
  }
}

extension SettingsQueryLinks
    on QueryBuilder<Settings, Settings, QFilterCondition> {}

extension SettingsQuerySortBy on QueryBuilder<Settings, Settings, QSortBy> {
  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDateFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDateFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByFlexColorSchemeBlendLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexColorSchemeBlendLevel', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByFlexColorSchemeBlendLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexColorSchemeBlendLevel', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFlexSchemeColorIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeColorIndex', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByFlexSchemeColorIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeColorIndex', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByIncognitoMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incognitoMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByIncognitoModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incognitoMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryFilterMangasBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryFilterMangasBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryFilterMangasDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryFilterMangasDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryFilterMangasStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryFilterMangasStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryFilterMangasUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryFilterMangasUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasUnreadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowContinueReadingButton', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowContinueReadingButton', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByRelativeTimesTamps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimesTamps', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      sortByRelativeTimesTampsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimesTamps', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByShowPagesNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPagesNumber', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByShowPagesNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPagesNumber', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByThemeIsDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeIsDark', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByThemeIsDarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeIsDark', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUserAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAgent', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUserAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAgent', Sort.desc);
    });
  }
}

extension SettingsQuerySortThenBy
    on QueryBuilder<Settings, Settings, QSortThenBy> {
  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDateFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDateFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateFormat', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByFlexColorSchemeBlendLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexColorSchemeBlendLevel', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByFlexColorSchemeBlendLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexColorSchemeBlendLevel', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFlexSchemeColorIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeColorIndex', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByFlexSchemeColorIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flexSchemeColorIndex', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByIncognitoMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incognitoMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByIncognitoModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incognitoMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryFilterMangasBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryFilterMangasBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryFilterMangasDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryFilterMangasDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryFilterMangasStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryFilterMangasStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryFilterMangasUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryFilterMangasUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterMangasUnreadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowContinueReadingButton', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowContinueReadingButton', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByRelativeTimesTamps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimesTamps', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
      thenByRelativeTimesTampsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relativeTimesTamps', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByShowPagesNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPagesNumber', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByShowPagesNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showPagesNumber', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByThemeIsDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeIsDark', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByThemeIsDarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeIsDark', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUserAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAgent', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUserAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAgent', Sort.desc);
    });
  }
}

extension SettingsQueryWhereDistinct
    on QueryBuilder<Settings, Settings, QDistinct> {
  QueryBuilder<Settings, Settings, QDistinct> distinctByDateFormat(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateFormat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByFlexColorSchemeBlendLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flexColorSchemeBlendLevel');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByFlexSchemeColorIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flexSchemeColorIndex');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByIncognitoMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'incognitoMode');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByLibraryFilterMangasBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterMangasBookMarkedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByLibraryFilterMangasDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterMangasDownloadType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByLibraryFilterMangasStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterMangasStartedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByLibraryFilterMangasUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterMangasUnreadType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryShowLanguage');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
      distinctByLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByRelativeTimesTamps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relativeTimesTamps');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByShowPagesNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showPagesNumber');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByThemeIsDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeIsDark');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUserAgent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userAgent', caseSensitive: caseSensitive);
    });
  }
}

extension SettingsQueryProperty
    on QueryBuilder<Settings, Settings, QQueryProperty> {
  QueryBuilder<Settings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Settings, List<ChapterFilterBookmarked>?, QQueryOperations>
      chapterFilterBookmarkedListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterFilterBookmarkedList');
    });
  }

  QueryBuilder<Settings, List<ChapterFilterDownloaded>?, QQueryOperations>
      chapterFilterDownloadedListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterFilterDownloadedList');
    });
  }

  QueryBuilder<Settings, List<ChapterFilterUnread>?, QQueryOperations>
      chapterFilterUnreadListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterFilterUnreadList');
    });
  }

  QueryBuilder<Settings, List<ChapterPageIndex>?, QQueryOperations>
      chapterPageIndexListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterPageIndexList');
    });
  }

  QueryBuilder<Settings, List<ChapterPageurls>?, QQueryOperations>
      chapterPageUrlsListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterPageUrlsList');
    });
  }

  QueryBuilder<Settings, List<Cookie>?, QQueryOperations>
      cookiesListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cookiesList');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> dateFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateFormat');
    });
  }

  QueryBuilder<Settings, DisplayType, QQueryOperations> displayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayType');
    });
  }

  QueryBuilder<Settings, double?, QQueryOperations>
      flexColorSchemeBlendLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flexColorSchemeBlendLevel');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
      flexSchemeColorIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flexSchemeColorIndex');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> incognitoModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'incognitoMode');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
      libraryDownloadedChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
      libraryFilterMangasBookMarkedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterMangasBookMarkedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
      libraryFilterMangasDownloadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterMangasDownloadType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
      libraryFilterMangasStartedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterMangasStartedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
      libraryFilterMangasUnreadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterMangasUnreadType');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
      libraryShowCategoryTabsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
      libraryShowContinueReadingButtonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
      libraryShowLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryShowLanguage');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
      libraryShowNumbersOfItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> relativeTimesTampsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relativeTimesTamps');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> showPagesNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showPagesNumber');
    });
  }

  QueryBuilder<Settings, List<SortChapter>?, QQueryOperations>
      sortChapterListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortChapterList');
    });
  }

  QueryBuilder<Settings, SortLibraryManga?, QQueryOperations>
      sortLibraryMangaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortLibraryManga');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> themeIsDarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeIsDark');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> userAgentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userAgent');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SortLibraryMangaSchema = Schema(
  name: r'SortLibraryManga',
  id: -8485569296691672246,
  properties: {
    r'index': PropertySchema(
      id: 0,
      name: r'index',
      type: IsarType.long,
    ),
    r'reverse': PropertySchema(
      id: 1,
      name: r'reverse',
      type: IsarType.bool,
    )
  },
  estimateSize: _sortLibraryMangaEstimateSize,
  serialize: _sortLibraryMangaSerialize,
  deserialize: _sortLibraryMangaDeserialize,
  deserializeProp: _sortLibraryMangaDeserializeProp,
);

int _sortLibraryMangaEstimateSize(
  SortLibraryManga object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _sortLibraryMangaSerialize(
  SortLibraryManga object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.index);
  writer.writeBool(offsets[1], object.reverse);
}

SortLibraryManga _sortLibraryMangaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SortLibraryManga(
    index: reader.readLongOrNull(offsets[0]),
    reverse: reader.readBoolOrNull(offsets[1]),
  );
  return object;
}

P _sortLibraryMangaDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SortLibraryMangaQueryFilter
    on QueryBuilder<SortLibraryManga, SortLibraryManga, QFilterCondition> {
  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
      indexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'index',
      ));
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
      indexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'index',
      ));
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
      indexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
      indexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
      indexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
      indexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'index',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
      reverseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reverse',
      ));
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
      reverseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reverse',
      ));
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
      reverseEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reverse',
        value: value,
      ));
    });
  }
}

extension SortLibraryMangaQueryObject
    on QueryBuilder<SortLibraryManga, SortLibraryManga, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SortChapterSchema = Schema(
  name: r'SortChapter',
  id: -468129901904543096,
  properties: {
    r'index': PropertySchema(
      id: 0,
      name: r'index',
      type: IsarType.long,
    ),
    r'mangaId': PropertySchema(
      id: 1,
      name: r'mangaId',
      type: IsarType.long,
    ),
    r'reverse': PropertySchema(
      id: 2,
      name: r'reverse',
      type: IsarType.bool,
    )
  },
  estimateSize: _sortChapterEstimateSize,
  serialize: _sortChapterSerialize,
  deserialize: _sortChapterDeserialize,
  deserializeProp: _sortChapterDeserializeProp,
);

int _sortChapterEstimateSize(
  SortChapter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _sortChapterSerialize(
  SortChapter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.index);
  writer.writeLong(offsets[1], object.mangaId);
  writer.writeBool(offsets[2], object.reverse);
}

SortChapter _sortChapterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SortChapter(
    index: reader.readLongOrNull(offsets[0]),
    mangaId: reader.readLongOrNull(offsets[1]),
    reverse: reader.readBoolOrNull(offsets[2]),
  );
  return object;
}

P _sortChapterDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SortChapterQueryFilter
    on QueryBuilder<SortChapter, SortChapter, QFilterCondition> {
  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> indexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'index',
      ));
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
      indexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'index',
      ));
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> indexEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
      indexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> indexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> indexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'index',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
      mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
      mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> mangaIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
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

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> mangaIdLessThan(
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

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> mangaIdBetween(
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

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
      reverseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reverse',
      ));
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
      reverseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reverse',
      ));
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> reverseEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reverse',
        value: value,
      ));
    });
  }
}

extension SortChapterQueryObject
    on QueryBuilder<SortChapter, SortChapter, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterFilterDownloadedSchema = Schema(
  name: r'ChapterFilterDownloaded',
  id: -5772236935601996927,
  properties: {
    r'mangaId': PropertySchema(
      id: 0,
      name: r'mangaId',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 1,
      name: r'type',
      type: IsarType.long,
    )
  },
  estimateSize: _chapterFilterDownloadedEstimateSize,
  serialize: _chapterFilterDownloadedSerialize,
  deserialize: _chapterFilterDownloadedDeserialize,
  deserializeProp: _chapterFilterDownloadedDeserializeProp,
);

int _chapterFilterDownloadedEstimateSize(
  ChapterFilterDownloaded object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _chapterFilterDownloadedSerialize(
  ChapterFilterDownloaded object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeLong(offsets[1], object.type);
}

ChapterFilterDownloaded _chapterFilterDownloadedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterFilterDownloaded(
    mangaId: reader.readLongOrNull(offsets[0]),
    type: reader.readLongOrNull(offsets[1]),
  );
  return object;
}

P _chapterFilterDownloadedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ChapterFilterDownloadedQueryFilter on QueryBuilder<
    ChapterFilterDownloaded, ChapterFilterDownloaded, QFilterCondition> {
  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> mangaIdGreaterThan(
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

  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> mangaIdLessThan(
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

  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> mangaIdBetween(
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

  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> typeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> typeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> typeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterDownloaded, ChapterFilterDownloaded,
      QAfterFilterCondition> typeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChapterFilterDownloadedQueryObject on QueryBuilder<
    ChapterFilterDownloaded, ChapterFilterDownloaded, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterFilterUnreadSchema = Schema(
  name: r'ChapterFilterUnread',
  id: 2999193805790237469,
  properties: {
    r'mangaId': PropertySchema(
      id: 0,
      name: r'mangaId',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 1,
      name: r'type',
      type: IsarType.long,
    )
  },
  estimateSize: _chapterFilterUnreadEstimateSize,
  serialize: _chapterFilterUnreadSerialize,
  deserialize: _chapterFilterUnreadDeserialize,
  deserializeProp: _chapterFilterUnreadDeserializeProp,
);

int _chapterFilterUnreadEstimateSize(
  ChapterFilterUnread object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _chapterFilterUnreadSerialize(
  ChapterFilterUnread object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeLong(offsets[1], object.type);
}

ChapterFilterUnread _chapterFilterUnreadDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterFilterUnread(
    mangaId: reader.readLongOrNull(offsets[0]),
    type: reader.readLongOrNull(offsets[1]),
  );
  return object;
}

P _chapterFilterUnreadDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ChapterFilterUnreadQueryFilter on QueryBuilder<ChapterFilterUnread,
    ChapterFilterUnread, QFilterCondition> {
  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
      mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
      mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
      mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
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

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
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

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
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

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
      typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
      typeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
      typeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
      typeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
      typeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChapterFilterUnreadQueryObject on QueryBuilder<ChapterFilterUnread,
    ChapterFilterUnread, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterFilterBookmarkedSchema = Schema(
  name: r'ChapterFilterBookmarked',
  id: -4183165879060895626,
  properties: {
    r'mangaId': PropertySchema(
      id: 0,
      name: r'mangaId',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 1,
      name: r'type',
      type: IsarType.long,
    )
  },
  estimateSize: _chapterFilterBookmarkedEstimateSize,
  serialize: _chapterFilterBookmarkedSerialize,
  deserialize: _chapterFilterBookmarkedDeserialize,
  deserializeProp: _chapterFilterBookmarkedDeserializeProp,
);

int _chapterFilterBookmarkedEstimateSize(
  ChapterFilterBookmarked object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _chapterFilterBookmarkedSerialize(
  ChapterFilterBookmarked object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeLong(offsets[1], object.type);
}

ChapterFilterBookmarked _chapterFilterBookmarkedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterFilterBookmarked(
    mangaId: reader.readLongOrNull(offsets[0]),
    type: reader.readLongOrNull(offsets[1]),
  );
  return object;
}

P _chapterFilterBookmarkedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ChapterFilterBookmarkedQueryFilter on QueryBuilder<
    ChapterFilterBookmarked, ChapterFilterBookmarked, QFilterCondition> {
  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mangaId',
      ));
    });
  }

  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mangaId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> mangaIdGreaterThan(
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

  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> mangaIdLessThan(
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

  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> mangaIdBetween(
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

  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> typeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> typeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> typeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterFilterBookmarked, ChapterFilterBookmarked,
      QAfterFilterCondition> typeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChapterFilterBookmarkedQueryObject on QueryBuilder<
    ChapterFilterBookmarked, ChapterFilterBookmarked, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterPageurlsSchema = Schema(
  name: r'ChapterPageurls',
  id: 1038916904093795130,
  properties: {
    r'chapterId': PropertySchema(
      id: 0,
      name: r'chapterId',
      type: IsarType.long,
    ),
    r'urls': PropertySchema(
      id: 1,
      name: r'urls',
      type: IsarType.stringList,
    )
  },
  estimateSize: _chapterPageurlsEstimateSize,
  serialize: _chapterPageurlsSerialize,
  deserialize: _chapterPageurlsDeserialize,
  deserializeProp: _chapterPageurlsDeserializeProp,
);

int _chapterPageurlsEstimateSize(
  ChapterPageurls object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.urls;
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

void _chapterPageurlsSerialize(
  ChapterPageurls object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.chapterId);
  writer.writeStringList(offsets[1], object.urls);
}

ChapterPageurls _chapterPageurlsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterPageurls();
  object.chapterId = reader.readLongOrNull(offsets[0]);
  object.urls = reader.readStringList(offsets[1]);
  return object;
}

P _chapterPageurlsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ChapterPageurlsQueryFilter
    on QueryBuilder<ChapterPageurls, ChapterPageurls, QFilterCondition> {
  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      chapterIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterId',
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      chapterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterId',
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      chapterIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
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

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
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

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
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

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'urls',
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'urls',
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'urls',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'urls',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'urls',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'urls',
        value: '',
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'urls',
        value: '',
      ));
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
      urlsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'urls',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ChapterPageurlsQueryObject
    on QueryBuilder<ChapterPageurls, ChapterPageurls, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterPageIndexSchema = Schema(
  name: r'ChapterPageIndex',
  id: 4458288720043056373,
  properties: {
    r'chapterId': PropertySchema(
      id: 0,
      name: r'chapterId',
      type: IsarType.long,
    ),
    r'index': PropertySchema(
      id: 1,
      name: r'index',
      type: IsarType.long,
    )
  },
  estimateSize: _chapterPageIndexEstimateSize,
  serialize: _chapterPageIndexSerialize,
  deserialize: _chapterPageIndexDeserialize,
  deserializeProp: _chapterPageIndexDeserializeProp,
);

int _chapterPageIndexEstimateSize(
  ChapterPageIndex object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _chapterPageIndexSerialize(
  ChapterPageIndex object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.chapterId);
  writer.writeLong(offsets[1], object.index);
}

ChapterPageIndex _chapterPageIndexDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterPageIndex();
  object.chapterId = reader.readLongOrNull(offsets[0]);
  object.index = reader.readLongOrNull(offsets[1]);
  return object;
}

P _chapterPageIndexDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ChapterPageIndexQueryFilter
    on QueryBuilder<ChapterPageIndex, ChapterPageIndex, QFilterCondition> {
  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
      chapterIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chapterId',
      ));
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
      chapterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chapterId',
      ));
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
      chapterIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
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

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
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

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
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

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
      indexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'index',
      ));
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
      indexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'index',
      ));
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
      indexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
      indexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
      indexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'index',
        value: value,
      ));
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
      indexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'index',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChapterPageIndexQueryObject
    on QueryBuilder<ChapterPageIndex, ChapterPageIndex, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CookieSchema = Schema(
  name: r'Cookie',
  id: -4750069831156363626,
  properties: {
    r'cookie': PropertySchema(
      id: 0,
      name: r'cookie',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 1,
      name: r'source',
      type: IsarType.string,
    )
  },
  estimateSize: _cookieEstimateSize,
  serialize: _cookieSerialize,
  deserialize: _cookieDeserialize,
  deserializeProp: _cookieDeserializeProp,
);

int _cookieEstimateSize(
  Cookie object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cookie;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.source;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _cookieSerialize(
  Cookie object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cookie);
  writer.writeString(offsets[1], object.source);
}

Cookie _cookieDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Cookie();
  object.cookie = reader.readStringOrNull(offsets[0]);
  object.source = reader.readStringOrNull(offsets[1]);
  return object;
}

P _cookieDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CookieQueryFilter on QueryBuilder<Cookie, Cookie, QFilterCondition> {
  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cookie',
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cookie',
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cookie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cookie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cookie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cookie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cookie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cookie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cookie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cookie',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cookie',
        value: '',
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> cookieIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cookie',
        value: '',
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'source',
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'source',
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<Cookie, Cookie, QAfterFilterCondition> sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }
}

extension CookieQueryObject on QueryBuilder<Cookie, Cookie, QFilterCondition> {}
