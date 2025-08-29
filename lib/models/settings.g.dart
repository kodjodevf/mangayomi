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
    r'algorithmWeights': PropertySchema(
      id: 0,
      name: r'algorithmWeights',
      type: IsarType.object,

      target: r'AlgorithmWeights',
    ),
    r'androidProxyServer': PropertySchema(
      id: 1,
      name: r'androidProxyServer',
      type: IsarType.string,
    ),
    r'aniSkipTimeoutLength': PropertySchema(
      id: 2,
      name: r'aniSkipTimeoutLength',
      type: IsarType.long,
    ),
    r'animatePageTransitions': PropertySchema(
      id: 3,
      name: r'animatePageTransitions',
      type: IsarType.bool,
    ),
    r'animeDisplayType': PropertySchema(
      id: 4,
      name: r'animeDisplayType',
      type: IsarType.byte,
      enumMap: _SettingsanimeDisplayTypeEnumValueMap,
    ),
    r'animeExtensionsRepo': PropertySchema(
      id: 5,
      name: r'animeExtensionsRepo',
      type: IsarType.objectList,

      target: r'Repo',
    ),
    r'animeGridSize': PropertySchema(
      id: 6,
      name: r'animeGridSize',
      type: IsarType.long,
    ),
    r'animeLibraryDownloadedChapters': PropertySchema(
      id: 7,
      name: r'animeLibraryDownloadedChapters',
      type: IsarType.bool,
    ),
    r'animeLibraryLocalSource': PropertySchema(
      id: 8,
      name: r'animeLibraryLocalSource',
      type: IsarType.bool,
    ),
    r'animeLibraryShowCategoryTabs': PropertySchema(
      id: 9,
      name: r'animeLibraryShowCategoryTabs',
      type: IsarType.bool,
    ),
    r'animeLibraryShowContinueReadingButton': PropertySchema(
      id: 10,
      name: r'animeLibraryShowContinueReadingButton',
      type: IsarType.bool,
    ),
    r'animeLibraryShowLanguage': PropertySchema(
      id: 11,
      name: r'animeLibraryShowLanguage',
      type: IsarType.bool,
    ),
    r'animeLibraryShowNumbersOfItems': PropertySchema(
      id: 12,
      name: r'animeLibraryShowNumbersOfItems',
      type: IsarType.bool,
    ),
    r'appFontFamily': PropertySchema(
      id: 13,
      name: r'appFontFamily',
      type: IsarType.string,
    ),
    r'audioChannels': PropertySchema(
      id: 14,
      name: r'audioChannels',
      type: IsarType.byte,
      enumMap: _SettingsaudioChannelsEnumValueMap,
    ),
    r'audioPreferredLanguages': PropertySchema(
      id: 15,
      name: r'audioPreferredLanguages',
      type: IsarType.string,
    ),
    r'autoBackupLocation': PropertySchema(
      id: 16,
      name: r'autoBackupLocation',
      type: IsarType.string,
    ),
    r'autoExtensionsUpdates': PropertySchema(
      id: 17,
      name: r'autoExtensionsUpdates',
      type: IsarType.bool,
    ),
    r'autoScrollPages': PropertySchema(
      id: 18,
      name: r'autoScrollPages',
      type: IsarType.objectList,

      target: r'AutoScrollPages',
    ),
    r'backgroundColor': PropertySchema(
      id: 19,
      name: r'backgroundColor',
      type: IsarType.byte,
      enumMap: _SettingsbackgroundColorEnumValueMap,
    ),
    r'backupFrequency': PropertySchema(
      id: 20,
      name: r'backupFrequency',
      type: IsarType.long,
    ),
    r'backupListOptions': PropertySchema(
      id: 21,
      name: r'backupListOptions',
      type: IsarType.longList,
    ),
    r'btServerAddress': PropertySchema(
      id: 22,
      name: r'btServerAddress',
      type: IsarType.string,
    ),
    r'btServerPort': PropertySchema(
      id: 23,
      name: r'btServerPort',
      type: IsarType.long,
    ),
    r'chapterFilterBookmarkedList': PropertySchema(
      id: 24,
      name: r'chapterFilterBookmarkedList',
      type: IsarType.objectList,

      target: r'ChapterFilterBookmarked',
    ),
    r'chapterFilterDownloadedList': PropertySchema(
      id: 25,
      name: r'chapterFilterDownloadedList',
      type: IsarType.objectList,

      target: r'ChapterFilterDownloaded',
    ),
    r'chapterFilterUnreadList': PropertySchema(
      id: 26,
      name: r'chapterFilterUnreadList',
      type: IsarType.objectList,

      target: r'ChapterFilterUnread',
    ),
    r'chapterPageIndexList': PropertySchema(
      id: 27,
      name: r'chapterPageIndexList',
      type: IsarType.objectList,

      target: r'ChapterPageIndex',
    ),
    r'chapterPageUrlsList': PropertySchema(
      id: 28,
      name: r'chapterPageUrlsList',
      type: IsarType.objectList,

      target: r'ChapterPageurls',
    ),
    r'checkForAppUpdates': PropertySchema(
      id: 29,
      name: r'checkForAppUpdates',
      type: IsarType.bool,
    ),
    r'checkForExtensionUpdates': PropertySchema(
      id: 30,
      name: r'checkForExtensionUpdates',
      type: IsarType.bool,
    ),
    r'clearChapterCacheOnAppLaunch': PropertySchema(
      id: 31,
      name: r'clearChapterCacheOnAppLaunch',
      type: IsarType.bool,
    ),
    r'colorFilterBlendMode': PropertySchema(
      id: 32,
      name: r'colorFilterBlendMode',
      type: IsarType.byte,
      enumMap: _SettingscolorFilterBlendModeEnumValueMap,
    ),
    r'concurrentDownloads': PropertySchema(
      id: 33,
      name: r'concurrentDownloads',
      type: IsarType.long,
    ),
    r'cookiesList': PropertySchema(
      id: 34,
      name: r'cookiesList',
      type: IsarType.objectList,

      target: r'MCookie',
    ),
    r'cropBorders': PropertySchema(
      id: 35,
      name: r'cropBorders',
      type: IsarType.bool,
    ),
    r'customColorFilter': PropertySchema(
      id: 36,
      name: r'customColorFilter',
      type: IsarType.object,

      target: r'CustomColorFilter',
    ),
    r'customDns': PropertySchema(
      id: 37,
      name: r'customDns',
      type: IsarType.string,
    ),
    r'dateFormat': PropertySchema(
      id: 38,
      name: r'dateFormat',
      type: IsarType.string,
    ),
    r'debandingType': PropertySchema(
      id: 39,
      name: r'debandingType',
      type: IsarType.byte,
      enumMap: _SettingsdebandingTypeEnumValueMap,
    ),
    r'defaultDoubleTapToSkipLength': PropertySchema(
      id: 40,
      name: r'defaultDoubleTapToSkipLength',
      type: IsarType.long,
    ),
    r'defaultPlayBackSpeed': PropertySchema(
      id: 41,
      name: r'defaultPlayBackSpeed',
      type: IsarType.double,
    ),
    r'defaultReaderMode': PropertySchema(
      id: 42,
      name: r'defaultReaderMode',
      type: IsarType.byte,
      enumMap: _SettingsdefaultReaderModeEnumValueMap,
    ),
    r'defaultSkipIntroLength': PropertySchema(
      id: 43,
      name: r'defaultSkipIntroLength',
      type: IsarType.long,
    ),
    r'defaultSubtitleLang': PropertySchema(
      id: 44,
      name: r'defaultSubtitleLang',
      type: IsarType.object,

      target: r'L10nLocale',
    ),
    r'disableSectionType': PropertySchema(
      id: 45,
      name: r'disableSectionType',
      type: IsarType.byte,
      enumMap: _SettingsdisableSectionTypeEnumValueMap,
    ),
    r'displayType': PropertySchema(
      id: 46,
      name: r'displayType',
      type: IsarType.byte,
      enumMap: _SettingsdisplayTypeEnumValueMap,
    ),
    r'doubleTapAnimationSpeed': PropertySchema(
      id: 47,
      name: r'doubleTapAnimationSpeed',
      type: IsarType.long,
    ),
    r'downloadLocation': PropertySchema(
      id: 48,
      name: r'downloadLocation',
      type: IsarType.string,
    ),
    r'downloadOnlyOnWifi': PropertySchema(
      id: 49,
      name: r'downloadOnlyOnWifi',
      type: IsarType.bool,
    ),
    r'downloadedOnlyMode': PropertySchema(
      id: 50,
      name: r'downloadedOnlyMode',
      type: IsarType.bool,
    ),
    r'enableAniSkip': PropertySchema(
      id: 51,
      name: r'enableAniSkip',
      type: IsarType.bool,
    ),
    r'enableAudioPitchCorrection': PropertySchema(
      id: 52,
      name: r'enableAudioPitchCorrection',
      type: IsarType.bool,
    ),
    r'enableAutoSkip': PropertySchema(
      id: 53,
      name: r'enableAutoSkip',
      type: IsarType.bool,
    ),
    r'enableCustomColorFilter': PropertySchema(
      id: 54,
      name: r'enableCustomColorFilter',
      type: IsarType.bool,
    ),
    r'enableDiscordRpc': PropertySchema(
      id: 55,
      name: r'enableDiscordRpc',
      type: IsarType.bool,
    ),
    r'enableGpuNext': PropertySchema(
      id: 56,
      name: r'enableGpuNext',
      type: IsarType.bool,
    ),
    r'enableHardwareAcceleration': PropertySchema(
      id: 57,
      name: r'enableHardwareAcceleration',
      type: IsarType.bool,
    ),
    r'filterScanlatorList': PropertySchema(
      id: 58,
      name: r'filterScanlatorList',
      type: IsarType.objectList,

      target: r'FilterScanlator',
    ),
    r'flexColorSchemeBlendLevel': PropertySchema(
      id: 59,
      name: r'flexColorSchemeBlendLevel',
      type: IsarType.double,
    ),
    r'flexSchemeColorIndex': PropertySchema(
      id: 60,
      name: r'flexSchemeColorIndex',
      type: IsarType.long,
    ),
    r'followSystemTheme': PropertySchema(
      id: 61,
      name: r'followSystemTheme',
      type: IsarType.bool,
    ),
    r'fullScreenPlayer': PropertySchema(
      id: 62,
      name: r'fullScreenPlayer',
      type: IsarType.bool,
    ),
    r'fullScreenReader': PropertySchema(
      id: 63,
      name: r'fullScreenReader',
      type: IsarType.bool,
    ),
    r'hideDiscordRpcInIncognito': PropertySchema(
      id: 64,
      name: r'hideDiscordRpcInIncognito',
      type: IsarType.bool,
    ),
    r'hideItems': PropertySchema(
      id: 65,
      name: r'hideItems',
      type: IsarType.stringList,
    ),
    r'hwdecMode': PropertySchema(
      id: 66,
      name: r'hwdecMode',
      type: IsarType.string,
    ),
    r'incognitoMode': PropertySchema(
      id: 67,
      name: r'incognitoMode',
      type: IsarType.bool,
    ),
    r'lastTrackerLibraryLocation': PropertySchema(
      id: 68,
      name: r'lastTrackerLibraryLocation',
      type: IsarType.string,
    ),
    r'libraryDownloadedChapters': PropertySchema(
      id: 69,
      name: r'libraryDownloadedChapters',
      type: IsarType.bool,
    ),
    r'libraryFilterAnimeBookMarkedType': PropertySchema(
      id: 70,
      name: r'libraryFilterAnimeBookMarkedType',
      type: IsarType.long,
    ),
    r'libraryFilterAnimeDownloadType': PropertySchema(
      id: 71,
      name: r'libraryFilterAnimeDownloadType',
      type: IsarType.long,
    ),
    r'libraryFilterAnimeStartedType': PropertySchema(
      id: 72,
      name: r'libraryFilterAnimeStartedType',
      type: IsarType.long,
    ),
    r'libraryFilterAnimeUnreadType': PropertySchema(
      id: 73,
      name: r'libraryFilterAnimeUnreadType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasBookMarkedType': PropertySchema(
      id: 74,
      name: r'libraryFilterMangasBookMarkedType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasDownloadType': PropertySchema(
      id: 75,
      name: r'libraryFilterMangasDownloadType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasStartedType': PropertySchema(
      id: 76,
      name: r'libraryFilterMangasStartedType',
      type: IsarType.long,
    ),
    r'libraryFilterMangasUnreadType': PropertySchema(
      id: 77,
      name: r'libraryFilterMangasUnreadType',
      type: IsarType.long,
    ),
    r'libraryFilterNovelBookMarkedType': PropertySchema(
      id: 78,
      name: r'libraryFilterNovelBookMarkedType',
      type: IsarType.long,
    ),
    r'libraryFilterNovelDownloadType': PropertySchema(
      id: 79,
      name: r'libraryFilterNovelDownloadType',
      type: IsarType.long,
    ),
    r'libraryFilterNovelStartedType': PropertySchema(
      id: 80,
      name: r'libraryFilterNovelStartedType',
      type: IsarType.long,
    ),
    r'libraryFilterNovelUnreadType': PropertySchema(
      id: 81,
      name: r'libraryFilterNovelUnreadType',
      type: IsarType.long,
    ),
    r'libraryLocalSource': PropertySchema(
      id: 82,
      name: r'libraryLocalSource',
      type: IsarType.bool,
    ),
    r'libraryShowCategoryTabs': PropertySchema(
      id: 83,
      name: r'libraryShowCategoryTabs',
      type: IsarType.bool,
    ),
    r'libraryShowContinueReadingButton': PropertySchema(
      id: 84,
      name: r'libraryShowContinueReadingButton',
      type: IsarType.bool,
    ),
    r'libraryShowLanguage': PropertySchema(
      id: 85,
      name: r'libraryShowLanguage',
      type: IsarType.bool,
    ),
    r'libraryShowNumbersOfItems': PropertySchema(
      id: 86,
      name: r'libraryShowNumbersOfItems',
      type: IsarType.bool,
    ),
    r'locale': PropertySchema(
      id: 87,
      name: r'locale',
      type: IsarType.object,

      target: r'L10nLocale',
    ),
    r'mangaExtensionsRepo': PropertySchema(
      id: 88,
      name: r'mangaExtensionsRepo',
      type: IsarType.objectList,

      target: r'Repo',
    ),
    r'mangaGridSize': PropertySchema(
      id: 89,
      name: r'mangaGridSize',
      type: IsarType.long,
    ),
    r'mangaHomeDisplayType': PropertySchema(
      id: 90,
      name: r'mangaHomeDisplayType',
      type: IsarType.byte,
      enumMap: _SettingsmangaHomeDisplayTypeEnumValueMap,
    ),
    r'markEpisodeAsSeenType': PropertySchema(
      id: 91,
      name: r'markEpisodeAsSeenType',
      type: IsarType.long,
    ),
    r'mergeLibraryNavMobile': PropertySchema(
      id: 92,
      name: r'mergeLibraryNavMobile',
      type: IsarType.bool,
    ),
    r'navigationOrder': PropertySchema(
      id: 93,
      name: r'navigationOrder',
      type: IsarType.stringList,
    ),
    r'novelDisplayType': PropertySchema(
      id: 94,
      name: r'novelDisplayType',
      type: IsarType.byte,
      enumMap: _SettingsnovelDisplayTypeEnumValueMap,
    ),
    r'novelExtensionsRepo': PropertySchema(
      id: 95,
      name: r'novelExtensionsRepo',
      type: IsarType.objectList,

      target: r'Repo',
    ),
    r'novelFontSize': PropertySchema(
      id: 96,
      name: r'novelFontSize',
      type: IsarType.long,
    ),
    r'novelGridSize': PropertySchema(
      id: 97,
      name: r'novelGridSize',
      type: IsarType.long,
    ),
    r'novelLibraryDownloadedChapters': PropertySchema(
      id: 98,
      name: r'novelLibraryDownloadedChapters',
      type: IsarType.bool,
    ),
    r'novelLibraryLocalSource': PropertySchema(
      id: 99,
      name: r'novelLibraryLocalSource',
      type: IsarType.bool,
    ),
    r'novelLibraryShowCategoryTabs': PropertySchema(
      id: 100,
      name: r'novelLibraryShowCategoryTabs',
      type: IsarType.bool,
    ),
    r'novelLibraryShowContinueReadingButton': PropertySchema(
      id: 101,
      name: r'novelLibraryShowContinueReadingButton',
      type: IsarType.bool,
    ),
    r'novelLibraryShowLanguage': PropertySchema(
      id: 102,
      name: r'novelLibraryShowLanguage',
      type: IsarType.bool,
    ),
    r'novelLibraryShowNumbersOfItems': PropertySchema(
      id: 103,
      name: r'novelLibraryShowNumbersOfItems',
      type: IsarType.bool,
    ),
    r'novelTextAlign': PropertySchema(
      id: 104,
      name: r'novelTextAlign',
      type: IsarType.byte,
      enumMap: _SettingsnovelTextAlignEnumValueMap,
    ),
    r'onlyIncludePinnedSources': PropertySchema(
      id: 105,
      name: r'onlyIncludePinnedSources',
      type: IsarType.bool,
    ),
    r'pagePreloadAmount': PropertySchema(
      id: 106,
      name: r'pagePreloadAmount',
      type: IsarType.long,
    ),
    r'personalPageModeList': PropertySchema(
      id: 107,
      name: r'personalPageModeList',
      type: IsarType.objectList,

      target: r'PersonalPageMode',
    ),
    r'personalReaderModeList': PropertySchema(
      id: 108,
      name: r'personalReaderModeList',
      type: IsarType.objectList,

      target: r'PersonalReaderMode',
    ),
    r'playerSubtitleSettings': PropertySchema(
      id: 109,
      name: r'playerSubtitleSettings',
      type: IsarType.object,

      target: r'PlayerSubtitleSettings',
    ),
    r'pureBlackDarkMode': PropertySchema(
      id: 110,
      name: r'pureBlackDarkMode',
      type: IsarType.bool,
    ),
    r'relativeTimesTamps': PropertySchema(
      id: 111,
      name: r'relativeTimesTamps',
      type: IsarType.long,
    ),
    r'rpcShowCoverImage': PropertySchema(
      id: 112,
      name: r'rpcShowCoverImage',
      type: IsarType.bool,
    ),
    r'rpcShowReadingWatchingProgress': PropertySchema(
      id: 113,
      name: r'rpcShowReadingWatchingProgress',
      type: IsarType.bool,
    ),
    r'rpcShowTitle': PropertySchema(
      id: 114,
      name: r'rpcShowTitle',
      type: IsarType.bool,
    ),
    r'saveAsCBZArchive': PropertySchema(
      id: 115,
      name: r'saveAsCBZArchive',
      type: IsarType.bool,
    ),
    r'scaleType': PropertySchema(
      id: 116,
      name: r'scaleType',
      type: IsarType.byte,
      enumMap: _SettingsscaleTypeEnumValueMap,
    ),
    r'showPagesNumber': PropertySchema(
      id: 117,
      name: r'showPagesNumber',
      type: IsarType.bool,
    ),
    r'sortChapterList': PropertySchema(
      id: 118,
      name: r'sortChapterList',
      type: IsarType.objectList,

      target: r'SortChapter',
    ),
    r'sortLibraryAnime': PropertySchema(
      id: 119,
      name: r'sortLibraryAnime',
      type: IsarType.object,

      target: r'SortLibraryManga',
    ),
    r'sortLibraryManga': PropertySchema(
      id: 120,
      name: r'sortLibraryManga',
      type: IsarType.object,

      target: r'SortLibraryManga',
    ),
    r'sortLibraryNovel': PropertySchema(
      id: 121,
      name: r'sortLibraryNovel',
      type: IsarType.object,

      target: r'SortLibraryManga',
    ),
    r'startDatebackup': PropertySchema(
      id: 122,
      name: r'startDatebackup',
      type: IsarType.long,
    ),
    r'themeIsDark': PropertySchema(
      id: 123,
      name: r'themeIsDark',
      type: IsarType.bool,
    ),
    r'updateProgressAfterReading': PropertySchema(
      id: 124,
      name: r'updateProgressAfterReading',
      type: IsarType.bool,
    ),
    r'updatedAt': PropertySchema(
      id: 125,
      name: r'updatedAt',
      type: IsarType.long,
    ),
    r'useLibass': PropertySchema(
      id: 126,
      name: r'useLibass',
      type: IsarType.bool,
    ),
    r'useMpvConfig': PropertySchema(
      id: 127,
      name: r'useMpvConfig',
      type: IsarType.bool,
    ),
    r'usePageTapZones': PropertySchema(
      id: 128,
      name: r'usePageTapZones',
      type: IsarType.bool,
    ),
    r'useYUV420P': PropertySchema(
      id: 129,
      name: r'useYUV420P',
      type: IsarType.bool,
    ),
    r'userAgent': PropertySchema(
      id: 130,
      name: r'userAgent',
      type: IsarType.string,
    ),
    r'volumeBoostCap': PropertySchema(
      id: 131,
      name: r'volumeBoostCap',
      type: IsarType.long,
    ),
  },

  estimateSize: _settingsEstimateSize,
  serialize: _settingsSerialize,
  deserialize: _settingsDeserialize,
  deserializeProp: _settingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'sources': LinkSchema(
      id: 4350160784948077250,
      name: r'sources',
      target: r'Sources',
      single: false,
    ),
  },
  embeddedSchemas: {
    r'SortLibraryManga': SortLibraryMangaSchema,
    r'SortChapter': SortChapterSchema,
    r'ChapterFilterDownloaded': ChapterFilterDownloadedSchema,
    r'ChapterFilterUnread': ChapterFilterUnreadSchema,
    r'ChapterFilterBookmarked': ChapterFilterBookmarkedSchema,
    r'ChapterPageurls': ChapterPageurlsSchema,
    r'ChapterPageIndex': ChapterPageIndexSchema,
    r'MCookie': MCookieSchema,
    r'PersonalReaderMode': PersonalReaderModeSchema,
    r'FilterScanlator': FilterScanlatorSchema,
    r'L10nLocale': L10nLocaleSchema,
    r'PersonalPageMode': PersonalPageModeSchema,
    r'AutoScrollPages': AutoScrollPagesSchema,
    r'CustomColorFilter': CustomColorFilterSchema,
    r'PlayerSubtitleSettings': PlayerSubtitleSettingsSchema,
    r'Repo': RepoSchema,
    r'AlgorithmWeights': AlgorithmWeightsSchema,
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
    final value = object.algorithmWeights;
    if (value != null) {
      bytesCount +=
          3 +
          AlgorithmWeightsSchema.estimateSize(
            value,
            allOffsets[AlgorithmWeights]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.androidProxyServer;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.animeExtensionsRepo;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Repo]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += RepoSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.appFontFamily;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.audioPreferredLanguages;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.autoBackupLocation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.autoScrollPages;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[AutoScrollPages]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += AutoScrollPagesSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.backupListOptions;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.btServerAddress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.chapterFilterBookmarkedList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ChapterFilterBookmarked]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += ChapterFilterBookmarkedSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
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
            value,
            offsets,
            allOffsets,
          );
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
            value,
            offsets,
            allOffsets,
          );
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
          bytesCount += ChapterPageIndexSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
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
          bytesCount += ChapterPageurlsSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.cookiesList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[MCookie]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += MCookieSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.customColorFilter;
    if (value != null) {
      bytesCount +=
          3 +
          CustomColorFilterSchema.estimateSize(
            value,
            allOffsets[CustomColorFilter]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.customDns;
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
    final value = object.defaultSubtitleLang;
    if (value != null) {
      bytesCount +=
          3 +
          L10nLocaleSchema.estimateSize(
            value,
            allOffsets[L10nLocale]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.downloadLocation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.filterScanlatorList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[FilterScanlator]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += FilterScanlatorSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.hideItems;
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
    final value = object.hwdecMode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastTrackerLibraryLocation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.locale;
    if (value != null) {
      bytesCount +=
          3 +
          L10nLocaleSchema.estimateSize(
            value,
            allOffsets[L10nLocale]!,
            allOffsets,
          );
    }
  }
  {
    final list = object.mangaExtensionsRepo;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Repo]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += RepoSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.navigationOrder;
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
    final list = object.novelExtensionsRepo;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Repo]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += RepoSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.personalPageModeList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[PersonalPageMode]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += PersonalPageModeSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final list = object.personalReaderModeList;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[PersonalReaderMode]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += PersonalReaderModeSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.playerSubtitleSettings;
    if (value != null) {
      bytesCount +=
          3 +
          PlayerSubtitleSettingsSchema.estimateSize(
            value,
            allOffsets[PlayerSubtitleSettings]!,
            allOffsets,
          );
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
          bytesCount += SortChapterSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.sortLibraryAnime;
    if (value != null) {
      bytesCount +=
          3 +
          SortLibraryMangaSchema.estimateSize(
            value,
            allOffsets[SortLibraryManga]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.sortLibraryManga;
    if (value != null) {
      bytesCount +=
          3 +
          SortLibraryMangaSchema.estimateSize(
            value,
            allOffsets[SortLibraryManga]!,
            allOffsets,
          );
    }
  }
  {
    final value = object.sortLibraryNovel;
    if (value != null) {
      bytesCount +=
          3 +
          SortLibraryMangaSchema.estimateSize(
            value,
            allOffsets[SortLibraryManga]!,
            allOffsets,
          );
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
  writer.writeObject<AlgorithmWeights>(
    offsets[0],
    allOffsets,
    AlgorithmWeightsSchema.serialize,
    object.algorithmWeights,
  );
  writer.writeString(offsets[1], object.androidProxyServer);
  writer.writeLong(offsets[2], object.aniSkipTimeoutLength);
  writer.writeBool(offsets[3], object.animatePageTransitions);
  writer.writeByte(offsets[4], object.animeDisplayType.index);
  writer.writeObjectList<Repo>(
    offsets[5],
    allOffsets,
    RepoSchema.serialize,
    object.animeExtensionsRepo,
  );
  writer.writeLong(offsets[6], object.animeGridSize);
  writer.writeBool(offsets[7], object.animeLibraryDownloadedChapters);
  writer.writeBool(offsets[8], object.animeLibraryLocalSource);
  writer.writeBool(offsets[9], object.animeLibraryShowCategoryTabs);
  writer.writeBool(offsets[10], object.animeLibraryShowContinueReadingButton);
  writer.writeBool(offsets[11], object.animeLibraryShowLanguage);
  writer.writeBool(offsets[12], object.animeLibraryShowNumbersOfItems);
  writer.writeString(offsets[13], object.appFontFamily);
  writer.writeByte(offsets[14], object.audioChannels.index);
  writer.writeString(offsets[15], object.audioPreferredLanguages);
  writer.writeString(offsets[16], object.autoBackupLocation);
  writer.writeBool(offsets[17], object.autoExtensionsUpdates);
  writer.writeObjectList<AutoScrollPages>(
    offsets[18],
    allOffsets,
    AutoScrollPagesSchema.serialize,
    object.autoScrollPages,
  );
  writer.writeByte(offsets[19], object.backgroundColor.index);
  writer.writeLong(offsets[20], object.backupFrequency);
  writer.writeLongList(offsets[21], object.backupListOptions);
  writer.writeString(offsets[22], object.btServerAddress);
  writer.writeLong(offsets[23], object.btServerPort);
  writer.writeObjectList<ChapterFilterBookmarked>(
    offsets[24],
    allOffsets,
    ChapterFilterBookmarkedSchema.serialize,
    object.chapterFilterBookmarkedList,
  );
  writer.writeObjectList<ChapterFilterDownloaded>(
    offsets[25],
    allOffsets,
    ChapterFilterDownloadedSchema.serialize,
    object.chapterFilterDownloadedList,
  );
  writer.writeObjectList<ChapterFilterUnread>(
    offsets[26],
    allOffsets,
    ChapterFilterUnreadSchema.serialize,
    object.chapterFilterUnreadList,
  );
  writer.writeObjectList<ChapterPageIndex>(
    offsets[27],
    allOffsets,
    ChapterPageIndexSchema.serialize,
    object.chapterPageIndexList,
  );
  writer.writeObjectList<ChapterPageurls>(
    offsets[28],
    allOffsets,
    ChapterPageurlsSchema.serialize,
    object.chapterPageUrlsList,
  );
  writer.writeBool(offsets[29], object.checkForAppUpdates);
  writer.writeBool(offsets[30], object.checkForExtensionUpdates);
  writer.writeBool(offsets[31], object.clearChapterCacheOnAppLaunch);
  writer.writeByte(offsets[32], object.colorFilterBlendMode.index);
  writer.writeLong(offsets[33], object.concurrentDownloads);
  writer.writeObjectList<MCookie>(
    offsets[34],
    allOffsets,
    MCookieSchema.serialize,
    object.cookiesList,
  );
  writer.writeBool(offsets[35], object.cropBorders);
  writer.writeObject<CustomColorFilter>(
    offsets[36],
    allOffsets,
    CustomColorFilterSchema.serialize,
    object.customColorFilter,
  );
  writer.writeString(offsets[37], object.customDns);
  writer.writeString(offsets[38], object.dateFormat);
  writer.writeByte(offsets[39], object.debandingType.index);
  writer.writeLong(offsets[40], object.defaultDoubleTapToSkipLength);
  writer.writeDouble(offsets[41], object.defaultPlayBackSpeed);
  writer.writeByte(offsets[42], object.defaultReaderMode.index);
  writer.writeLong(offsets[43], object.defaultSkipIntroLength);
  writer.writeObject<L10nLocale>(
    offsets[44],
    allOffsets,
    L10nLocaleSchema.serialize,
    object.defaultSubtitleLang,
  );
  writer.writeByte(offsets[45], object.disableSectionType.index);
  writer.writeByte(offsets[46], object.displayType.index);
  writer.writeLong(offsets[47], object.doubleTapAnimationSpeed);
  writer.writeString(offsets[48], object.downloadLocation);
  writer.writeBool(offsets[49], object.downloadOnlyOnWifi);
  writer.writeBool(offsets[50], object.downloadedOnlyMode);
  writer.writeBool(offsets[51], object.enableAniSkip);
  writer.writeBool(offsets[52], object.enableAudioPitchCorrection);
  writer.writeBool(offsets[53], object.enableAutoSkip);
  writer.writeBool(offsets[54], object.enableCustomColorFilter);
  writer.writeBool(offsets[55], object.enableDiscordRpc);
  writer.writeBool(offsets[56], object.enableGpuNext);
  writer.writeBool(offsets[57], object.enableHardwareAcceleration);
  writer.writeObjectList<FilterScanlator>(
    offsets[58],
    allOffsets,
    FilterScanlatorSchema.serialize,
    object.filterScanlatorList,
  );
  writer.writeDouble(offsets[59], object.flexColorSchemeBlendLevel);
  writer.writeLong(offsets[60], object.flexSchemeColorIndex);
  writer.writeBool(offsets[61], object.followSystemTheme);
  writer.writeBool(offsets[62], object.fullScreenPlayer);
  writer.writeBool(offsets[63], object.fullScreenReader);
  writer.writeBool(offsets[64], object.hideDiscordRpcInIncognito);
  writer.writeStringList(offsets[65], object.hideItems);
  writer.writeString(offsets[66], object.hwdecMode);
  writer.writeBool(offsets[67], object.incognitoMode);
  writer.writeString(offsets[68], object.lastTrackerLibraryLocation);
  writer.writeBool(offsets[69], object.libraryDownloadedChapters);
  writer.writeLong(offsets[70], object.libraryFilterAnimeBookMarkedType);
  writer.writeLong(offsets[71], object.libraryFilterAnimeDownloadType);
  writer.writeLong(offsets[72], object.libraryFilterAnimeStartedType);
  writer.writeLong(offsets[73], object.libraryFilterAnimeUnreadType);
  writer.writeLong(offsets[74], object.libraryFilterMangasBookMarkedType);
  writer.writeLong(offsets[75], object.libraryFilterMangasDownloadType);
  writer.writeLong(offsets[76], object.libraryFilterMangasStartedType);
  writer.writeLong(offsets[77], object.libraryFilterMangasUnreadType);
  writer.writeLong(offsets[78], object.libraryFilterNovelBookMarkedType);
  writer.writeLong(offsets[79], object.libraryFilterNovelDownloadType);
  writer.writeLong(offsets[80], object.libraryFilterNovelStartedType);
  writer.writeLong(offsets[81], object.libraryFilterNovelUnreadType);
  writer.writeBool(offsets[82], object.libraryLocalSource);
  writer.writeBool(offsets[83], object.libraryShowCategoryTabs);
  writer.writeBool(offsets[84], object.libraryShowContinueReadingButton);
  writer.writeBool(offsets[85], object.libraryShowLanguage);
  writer.writeBool(offsets[86], object.libraryShowNumbersOfItems);
  writer.writeObject<L10nLocale>(
    offsets[87],
    allOffsets,
    L10nLocaleSchema.serialize,
    object.locale,
  );
  writer.writeObjectList<Repo>(
    offsets[88],
    allOffsets,
    RepoSchema.serialize,
    object.mangaExtensionsRepo,
  );
  writer.writeLong(offsets[89], object.mangaGridSize);
  writer.writeByte(offsets[90], object.mangaHomeDisplayType.index);
  writer.writeLong(offsets[91], object.markEpisodeAsSeenType);
  writer.writeBool(offsets[92], object.mergeLibraryNavMobile);
  writer.writeStringList(offsets[93], object.navigationOrder);
  writer.writeByte(offsets[94], object.novelDisplayType.index);
  writer.writeObjectList<Repo>(
    offsets[95],
    allOffsets,
    RepoSchema.serialize,
    object.novelExtensionsRepo,
  );
  writer.writeLong(offsets[96], object.novelFontSize);
  writer.writeLong(offsets[97], object.novelGridSize);
  writer.writeBool(offsets[98], object.novelLibraryDownloadedChapters);
  writer.writeBool(offsets[99], object.novelLibraryLocalSource);
  writer.writeBool(offsets[100], object.novelLibraryShowCategoryTabs);
  writer.writeBool(offsets[101], object.novelLibraryShowContinueReadingButton);
  writer.writeBool(offsets[102], object.novelLibraryShowLanguage);
  writer.writeBool(offsets[103], object.novelLibraryShowNumbersOfItems);
  writer.writeByte(offsets[104], object.novelTextAlign.index);
  writer.writeBool(offsets[105], object.onlyIncludePinnedSources);
  writer.writeLong(offsets[106], object.pagePreloadAmount);
  writer.writeObjectList<PersonalPageMode>(
    offsets[107],
    allOffsets,
    PersonalPageModeSchema.serialize,
    object.personalPageModeList,
  );
  writer.writeObjectList<PersonalReaderMode>(
    offsets[108],
    allOffsets,
    PersonalReaderModeSchema.serialize,
    object.personalReaderModeList,
  );
  writer.writeObject<PlayerSubtitleSettings>(
    offsets[109],
    allOffsets,
    PlayerSubtitleSettingsSchema.serialize,
    object.playerSubtitleSettings,
  );
  writer.writeBool(offsets[110], object.pureBlackDarkMode);
  writer.writeLong(offsets[111], object.relativeTimesTamps);
  writer.writeBool(offsets[112], object.rpcShowCoverImage);
  writer.writeBool(offsets[113], object.rpcShowReadingWatchingProgress);
  writer.writeBool(offsets[114], object.rpcShowTitle);
  writer.writeBool(offsets[115], object.saveAsCBZArchive);
  writer.writeByte(offsets[116], object.scaleType.index);
  writer.writeBool(offsets[117], object.showPagesNumber);
  writer.writeObjectList<SortChapter>(
    offsets[118],
    allOffsets,
    SortChapterSchema.serialize,
    object.sortChapterList,
  );
  writer.writeObject<SortLibraryManga>(
    offsets[119],
    allOffsets,
    SortLibraryMangaSchema.serialize,
    object.sortLibraryAnime,
  );
  writer.writeObject<SortLibraryManga>(
    offsets[120],
    allOffsets,
    SortLibraryMangaSchema.serialize,
    object.sortLibraryManga,
  );
  writer.writeObject<SortLibraryManga>(
    offsets[121],
    allOffsets,
    SortLibraryMangaSchema.serialize,
    object.sortLibraryNovel,
  );
  writer.writeLong(offsets[122], object.startDatebackup);
  writer.writeBool(offsets[123], object.themeIsDark);
  writer.writeBool(offsets[124], object.updateProgressAfterReading);
  writer.writeLong(offsets[125], object.updatedAt);
  writer.writeBool(offsets[126], object.useLibass);
  writer.writeBool(offsets[127], object.useMpvConfig);
  writer.writeBool(offsets[128], object.usePageTapZones);
  writer.writeBool(offsets[129], object.useYUV420P);
  writer.writeString(offsets[130], object.userAgent);
  writer.writeLong(offsets[131], object.volumeBoostCap);
}

Settings _settingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Settings(
    algorithmWeights: reader.readObjectOrNull<AlgorithmWeights>(
      offsets[0],
      AlgorithmWeightsSchema.deserialize,
      allOffsets,
    ),
    androidProxyServer: reader.readStringOrNull(offsets[1]),
    aniSkipTimeoutLength: reader.readLongOrNull(offsets[2]),
    animatePageTransitions: reader.readBoolOrNull(offsets[3]),
    animeDisplayType:
        _SettingsanimeDisplayTypeValueEnumMap[reader.readByteOrNull(
          offsets[4],
        )] ??
        DisplayType.compactGrid,
    animeExtensionsRepo: reader.readObjectList<Repo>(
      offsets[5],
      RepoSchema.deserialize,
      allOffsets,
      Repo(),
    ),
    animeGridSize: reader.readLongOrNull(offsets[6]),
    animeLibraryDownloadedChapters: reader.readBoolOrNull(offsets[7]),
    animeLibraryLocalSource: reader.readBoolOrNull(offsets[8]),
    animeLibraryShowCategoryTabs: reader.readBoolOrNull(offsets[9]),
    animeLibraryShowContinueReadingButton: reader.readBoolOrNull(offsets[10]),
    animeLibraryShowLanguage: reader.readBoolOrNull(offsets[11]),
    animeLibraryShowNumbersOfItems: reader.readBoolOrNull(offsets[12]),
    appFontFamily: reader.readStringOrNull(offsets[13]),
    audioChannels:
        _SettingsaudioChannelsValueEnumMap[reader.readByteOrNull(
          offsets[14],
        )] ??
        AudioChannel.autoSafe,
    audioPreferredLanguages: reader.readStringOrNull(offsets[15]),
    autoBackupLocation: reader.readStringOrNull(offsets[16]),
    autoExtensionsUpdates: reader.readBoolOrNull(offsets[17]),
    autoScrollPages: reader.readObjectList<AutoScrollPages>(
      offsets[18],
      AutoScrollPagesSchema.deserialize,
      allOffsets,
      AutoScrollPages(),
    ),
    backgroundColor:
        _SettingsbackgroundColorValueEnumMap[reader.readByteOrNull(
          offsets[19],
        )] ??
        BackgroundColor.black,
    backupFrequency: reader.readLongOrNull(offsets[20]),
    backupListOptions: reader.readLongList(offsets[21]),
    btServerAddress: reader.readStringOrNull(offsets[22]),
    btServerPort: reader.readLongOrNull(offsets[23]),
    chapterFilterDownloadedList: reader.readObjectList<ChapterFilterDownloaded>(
      offsets[25],
      ChapterFilterDownloadedSchema.deserialize,
      allOffsets,
      ChapterFilterDownloaded(),
    ),
    chapterPageIndexList: reader.readObjectList<ChapterPageIndex>(
      offsets[27],
      ChapterPageIndexSchema.deserialize,
      allOffsets,
      ChapterPageIndex(),
    ),
    chapterPageUrlsList: reader.readObjectList<ChapterPageurls>(
      offsets[28],
      ChapterPageurlsSchema.deserialize,
      allOffsets,
      ChapterPageurls(),
    ),
    checkForAppUpdates: reader.readBoolOrNull(offsets[29]),
    checkForExtensionUpdates: reader.readBoolOrNull(offsets[30]),
    clearChapterCacheOnAppLaunch: reader.readBoolOrNull(offsets[31]),
    colorFilterBlendMode:
        _SettingscolorFilterBlendModeValueEnumMap[reader.readByteOrNull(
          offsets[32],
        )] ??
        ColorFilterBlendMode.none,
    concurrentDownloads: reader.readLongOrNull(offsets[33]),
    cookiesList: reader.readObjectList<MCookie>(
      offsets[34],
      MCookieSchema.deserialize,
      allOffsets,
      MCookie(),
    ),
    cropBorders: reader.readBoolOrNull(offsets[35]),
    customColorFilter: reader.readObjectOrNull<CustomColorFilter>(
      offsets[36],
      CustomColorFilterSchema.deserialize,
      allOffsets,
    ),
    customDns: reader.readStringOrNull(offsets[37]),
    dateFormat: reader.readStringOrNull(offsets[38]),
    debandingType:
        _SettingsdebandingTypeValueEnumMap[reader.readByteOrNull(
          offsets[39],
        )] ??
        DebandingType.none,
    defaultDoubleTapToSkipLength: reader.readLongOrNull(offsets[40]),
    defaultPlayBackSpeed: reader.readDoubleOrNull(offsets[41]),
    defaultReaderMode:
        _SettingsdefaultReaderModeValueEnumMap[reader.readByteOrNull(
          offsets[42],
        )] ??
        ReaderMode.vertical,
    defaultSkipIntroLength: reader.readLongOrNull(offsets[43]),
    disableSectionType:
        _SettingsdisableSectionTypeValueEnumMap[reader.readByteOrNull(
          offsets[45],
        )] ??
        SectionType.all,
    displayType:
        _SettingsdisplayTypeValueEnumMap[reader.readByteOrNull(offsets[46])] ??
        DisplayType.compactGrid,
    doubleTapAnimationSpeed: reader.readLongOrNull(offsets[47]),
    downloadLocation: reader.readStringOrNull(offsets[48]),
    downloadOnlyOnWifi: reader.readBoolOrNull(offsets[49]),
    downloadedOnlyMode: reader.readBoolOrNull(offsets[50]),
    enableAniSkip: reader.readBoolOrNull(offsets[51]),
    enableAudioPitchCorrection: reader.readBoolOrNull(offsets[52]),
    enableAutoSkip: reader.readBoolOrNull(offsets[53]),
    enableCustomColorFilter: reader.readBoolOrNull(offsets[54]),
    enableDiscordRpc: reader.readBoolOrNull(offsets[55]),
    enableGpuNext: reader.readBoolOrNull(offsets[56]),
    enableHardwareAcceleration: reader.readBoolOrNull(offsets[57]),
    flexColorSchemeBlendLevel: reader.readDoubleOrNull(offsets[59]),
    flexSchemeColorIndex: reader.readLongOrNull(offsets[60]),
    followSystemTheme: reader.readBoolOrNull(offsets[61]),
    fullScreenPlayer: reader.readBoolOrNull(offsets[62]),
    fullScreenReader: reader.readBoolOrNull(offsets[63]),
    hideDiscordRpcInIncognito: reader.readBoolOrNull(offsets[64]),
    hideItems: reader.readStringList(offsets[65]),
    hwdecMode: reader.readStringOrNull(offsets[66]),
    id: id,
    incognitoMode: reader.readBoolOrNull(offsets[67]),
    lastTrackerLibraryLocation: reader.readStringOrNull(offsets[68]),
    libraryDownloadedChapters: reader.readBoolOrNull(offsets[69]),
    libraryFilterAnimeBookMarkedType: reader.readLongOrNull(offsets[70]),
    libraryFilterAnimeDownloadType: reader.readLongOrNull(offsets[71]),
    libraryFilterAnimeStartedType: reader.readLongOrNull(offsets[72]),
    libraryFilterAnimeUnreadType: reader.readLongOrNull(offsets[73]),
    libraryFilterMangasBookMarkedType: reader.readLongOrNull(offsets[74]),
    libraryFilterMangasDownloadType: reader.readLongOrNull(offsets[75]),
    libraryFilterMangasStartedType: reader.readLongOrNull(offsets[76]),
    libraryFilterMangasUnreadType: reader.readLongOrNull(offsets[77]),
    libraryFilterNovelBookMarkedType: reader.readLongOrNull(offsets[78]),
    libraryFilterNovelDownloadType: reader.readLongOrNull(offsets[79]),
    libraryFilterNovelStartedType: reader.readLongOrNull(offsets[80]),
    libraryFilterNovelUnreadType: reader.readLongOrNull(offsets[81]),
    libraryLocalSource: reader.readBoolOrNull(offsets[82]),
    libraryShowCategoryTabs: reader.readBoolOrNull(offsets[83]),
    libraryShowContinueReadingButton: reader.readBoolOrNull(offsets[84]),
    libraryShowLanguage: reader.readBoolOrNull(offsets[85]),
    libraryShowNumbersOfItems: reader.readBoolOrNull(offsets[86]),
    mangaExtensionsRepo: reader.readObjectList<Repo>(
      offsets[88],
      RepoSchema.deserialize,
      allOffsets,
      Repo(),
    ),
    mangaGridSize: reader.readLongOrNull(offsets[89]),
    mangaHomeDisplayType:
        _SettingsmangaHomeDisplayTypeValueEnumMap[reader.readByteOrNull(
          offsets[90],
        )] ??
        DisplayType.comfortableGrid,
    markEpisodeAsSeenType: reader.readLongOrNull(offsets[91]),
    mergeLibraryNavMobile: reader.readBoolOrNull(offsets[92]),
    navigationOrder: reader.readStringList(offsets[93]),
    novelDisplayType:
        _SettingsnovelDisplayTypeValueEnumMap[reader.readByteOrNull(
          offsets[94],
        )] ??
        DisplayType.comfortableGrid,
    novelExtensionsRepo: reader.readObjectList<Repo>(
      offsets[95],
      RepoSchema.deserialize,
      allOffsets,
      Repo(),
    ),
    novelFontSize: reader.readLongOrNull(offsets[96]),
    novelLibraryDownloadedChapters: reader.readBoolOrNull(offsets[98]),
    novelLibraryLocalSource: reader.readBoolOrNull(offsets[99]),
    novelLibraryShowCategoryTabs: reader.readBoolOrNull(offsets[100]),
    novelLibraryShowContinueReadingButton: reader.readBoolOrNull(offsets[101]),
    novelLibraryShowLanguage: reader.readBoolOrNull(offsets[102]),
    novelLibraryShowNumbersOfItems: reader.readBoolOrNull(offsets[103]),
    novelTextAlign:
        _SettingsnovelTextAlignValueEnumMap[reader.readByteOrNull(
          offsets[104],
        )] ??
        NovelTextAlign.left,
    onlyIncludePinnedSources: reader.readBoolOrNull(offsets[105]),
    pagePreloadAmount: reader.readLongOrNull(offsets[106]),
    personalPageModeList: reader.readObjectList<PersonalPageMode>(
      offsets[107],
      PersonalPageModeSchema.deserialize,
      allOffsets,
      PersonalPageMode(),
    ),
    personalReaderModeList: reader.readObjectList<PersonalReaderMode>(
      offsets[108],
      PersonalReaderModeSchema.deserialize,
      allOffsets,
      PersonalReaderMode(),
    ),
    playerSubtitleSettings: reader.readObjectOrNull<PlayerSubtitleSettings>(
      offsets[109],
      PlayerSubtitleSettingsSchema.deserialize,
      allOffsets,
    ),
    pureBlackDarkMode: reader.readBoolOrNull(offsets[110]),
    relativeTimesTamps: reader.readLongOrNull(offsets[111]),
    rpcShowCoverImage: reader.readBoolOrNull(offsets[112]),
    rpcShowReadingWatchingProgress: reader.readBoolOrNull(offsets[113]),
    rpcShowTitle: reader.readBoolOrNull(offsets[114]),
    saveAsCBZArchive: reader.readBoolOrNull(offsets[115]),
    scaleType:
        _SettingsscaleTypeValueEnumMap[reader.readByteOrNull(offsets[116])] ??
        ScaleType.fitScreen,
    showPagesNumber: reader.readBoolOrNull(offsets[117]),
    sortChapterList: reader.readObjectList<SortChapter>(
      offsets[118],
      SortChapterSchema.deserialize,
      allOffsets,
      SortChapter(),
    ),
    sortLibraryAnime: reader.readObjectOrNull<SortLibraryManga>(
      offsets[119],
      SortLibraryMangaSchema.deserialize,
      allOffsets,
    ),
    sortLibraryManga: reader.readObjectOrNull<SortLibraryManga>(
      offsets[120],
      SortLibraryMangaSchema.deserialize,
      allOffsets,
    ),
    sortLibraryNovel: reader.readObjectOrNull<SortLibraryManga>(
      offsets[121],
      SortLibraryMangaSchema.deserialize,
      allOffsets,
    ),
    startDatebackup: reader.readLongOrNull(offsets[122]),
    themeIsDark: reader.readBoolOrNull(offsets[123]),
    updateProgressAfterReading: reader.readBoolOrNull(offsets[124]),
    updatedAt: reader.readLongOrNull(offsets[125]),
    useLibass: reader.readBoolOrNull(offsets[126]),
    useMpvConfig: reader.readBoolOrNull(offsets[127]),
    usePageTapZones: reader.readBoolOrNull(offsets[128]),
    useYUV420P: reader.readBoolOrNull(offsets[129]),
    userAgent: reader.readStringOrNull(offsets[130]),
    volumeBoostCap: reader.readLongOrNull(offsets[131]),
  );
  object.chapterFilterBookmarkedList = reader
      .readObjectList<ChapterFilterBookmarked>(
        offsets[24],
        ChapterFilterBookmarkedSchema.deserialize,
        allOffsets,
        ChapterFilterBookmarked(),
      );
  object.chapterFilterUnreadList = reader.readObjectList<ChapterFilterUnread>(
    offsets[26],
    ChapterFilterUnreadSchema.deserialize,
    allOffsets,
    ChapterFilterUnread(),
  );
  object.defaultSubtitleLang = reader.readObjectOrNull<L10nLocale>(
    offsets[44],
    L10nLocaleSchema.deserialize,
    allOffsets,
  );
  object.filterScanlatorList = reader.readObjectList<FilterScanlator>(
    offsets[58],
    FilterScanlatorSchema.deserialize,
    allOffsets,
    FilterScanlator(),
  );
  object.locale = reader.readObjectOrNull<L10nLocale>(
    offsets[87],
    L10nLocaleSchema.deserialize,
    allOffsets,
  );
  object.novelGridSize = reader.readLongOrNull(offsets[97]);
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
      return (reader.readObjectOrNull<AlgorithmWeights>(
            offset,
            AlgorithmWeightsSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (_SettingsanimeDisplayTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DisplayType.compactGrid)
          as P;
    case 5:
      return (reader.readObjectList<Repo>(
            offset,
            RepoSchema.deserialize,
            allOffsets,
            Repo(),
          ))
          as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readBoolOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset)) as P;
    case 12:
      return (reader.readBoolOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (_SettingsaudioChannelsValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              AudioChannel.autoSafe)
          as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readBoolOrNull(offset)) as P;
    case 18:
      return (reader.readObjectList<AutoScrollPages>(
            offset,
            AutoScrollPagesSchema.deserialize,
            allOffsets,
            AutoScrollPages(),
          ))
          as P;
    case 19:
      return (_SettingsbackgroundColorValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              BackgroundColor.black)
          as P;
    case 20:
      return (reader.readLongOrNull(offset)) as P;
    case 21:
      return (reader.readLongList(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readLongOrNull(offset)) as P;
    case 24:
      return (reader.readObjectList<ChapterFilterBookmarked>(
            offset,
            ChapterFilterBookmarkedSchema.deserialize,
            allOffsets,
            ChapterFilterBookmarked(),
          ))
          as P;
    case 25:
      return (reader.readObjectList<ChapterFilterDownloaded>(
            offset,
            ChapterFilterDownloadedSchema.deserialize,
            allOffsets,
            ChapterFilterDownloaded(),
          ))
          as P;
    case 26:
      return (reader.readObjectList<ChapterFilterUnread>(
            offset,
            ChapterFilterUnreadSchema.deserialize,
            allOffsets,
            ChapterFilterUnread(),
          ))
          as P;
    case 27:
      return (reader.readObjectList<ChapterPageIndex>(
            offset,
            ChapterPageIndexSchema.deserialize,
            allOffsets,
            ChapterPageIndex(),
          ))
          as P;
    case 28:
      return (reader.readObjectList<ChapterPageurls>(
            offset,
            ChapterPageurlsSchema.deserialize,
            allOffsets,
            ChapterPageurls(),
          ))
          as P;
    case 29:
      return (reader.readBoolOrNull(offset)) as P;
    case 30:
      return (reader.readBoolOrNull(offset)) as P;
    case 31:
      return (reader.readBoolOrNull(offset)) as P;
    case 32:
      return (_SettingscolorFilterBlendModeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              ColorFilterBlendMode.none)
          as P;
    case 33:
      return (reader.readLongOrNull(offset)) as P;
    case 34:
      return (reader.readObjectList<MCookie>(
            offset,
            MCookieSchema.deserialize,
            allOffsets,
            MCookie(),
          ))
          as P;
    case 35:
      return (reader.readBoolOrNull(offset)) as P;
    case 36:
      return (reader.readObjectOrNull<CustomColorFilter>(
            offset,
            CustomColorFilterSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 37:
      return (reader.readStringOrNull(offset)) as P;
    case 38:
      return (reader.readStringOrNull(offset)) as P;
    case 39:
      return (_SettingsdebandingTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DebandingType.none)
          as P;
    case 40:
      return (reader.readLongOrNull(offset)) as P;
    case 41:
      return (reader.readDoubleOrNull(offset)) as P;
    case 42:
      return (_SettingsdefaultReaderModeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              ReaderMode.vertical)
          as P;
    case 43:
      return (reader.readLongOrNull(offset)) as P;
    case 44:
      return (reader.readObjectOrNull<L10nLocale>(
            offset,
            L10nLocaleSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 45:
      return (_SettingsdisableSectionTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              SectionType.all)
          as P;
    case 46:
      return (_SettingsdisplayTypeValueEnumMap[reader.readByteOrNull(offset)] ??
              DisplayType.compactGrid)
          as P;
    case 47:
      return (reader.readLongOrNull(offset)) as P;
    case 48:
      return (reader.readStringOrNull(offset)) as P;
    case 49:
      return (reader.readBoolOrNull(offset)) as P;
    case 50:
      return (reader.readBoolOrNull(offset)) as P;
    case 51:
      return (reader.readBoolOrNull(offset)) as P;
    case 52:
      return (reader.readBoolOrNull(offset)) as P;
    case 53:
      return (reader.readBoolOrNull(offset)) as P;
    case 54:
      return (reader.readBoolOrNull(offset)) as P;
    case 55:
      return (reader.readBoolOrNull(offset)) as P;
    case 56:
      return (reader.readBoolOrNull(offset)) as P;
    case 57:
      return (reader.readBoolOrNull(offset)) as P;
    case 58:
      return (reader.readObjectList<FilterScanlator>(
            offset,
            FilterScanlatorSchema.deserialize,
            allOffsets,
            FilterScanlator(),
          ))
          as P;
    case 59:
      return (reader.readDoubleOrNull(offset)) as P;
    case 60:
      return (reader.readLongOrNull(offset)) as P;
    case 61:
      return (reader.readBoolOrNull(offset)) as P;
    case 62:
      return (reader.readBoolOrNull(offset)) as P;
    case 63:
      return (reader.readBoolOrNull(offset)) as P;
    case 64:
      return (reader.readBoolOrNull(offset)) as P;
    case 65:
      return (reader.readStringList(offset)) as P;
    case 66:
      return (reader.readStringOrNull(offset)) as P;
    case 67:
      return (reader.readBoolOrNull(offset)) as P;
    case 68:
      return (reader.readStringOrNull(offset)) as P;
    case 69:
      return (reader.readBoolOrNull(offset)) as P;
    case 70:
      return (reader.readLongOrNull(offset)) as P;
    case 71:
      return (reader.readLongOrNull(offset)) as P;
    case 72:
      return (reader.readLongOrNull(offset)) as P;
    case 73:
      return (reader.readLongOrNull(offset)) as P;
    case 74:
      return (reader.readLongOrNull(offset)) as P;
    case 75:
      return (reader.readLongOrNull(offset)) as P;
    case 76:
      return (reader.readLongOrNull(offset)) as P;
    case 77:
      return (reader.readLongOrNull(offset)) as P;
    case 78:
      return (reader.readLongOrNull(offset)) as P;
    case 79:
      return (reader.readLongOrNull(offset)) as P;
    case 80:
      return (reader.readLongOrNull(offset)) as P;
    case 81:
      return (reader.readLongOrNull(offset)) as P;
    case 82:
      return (reader.readBoolOrNull(offset)) as P;
    case 83:
      return (reader.readBoolOrNull(offset)) as P;
    case 84:
      return (reader.readBoolOrNull(offset)) as P;
    case 85:
      return (reader.readBoolOrNull(offset)) as P;
    case 86:
      return (reader.readBoolOrNull(offset)) as P;
    case 87:
      return (reader.readObjectOrNull<L10nLocale>(
            offset,
            L10nLocaleSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 88:
      return (reader.readObjectList<Repo>(
            offset,
            RepoSchema.deserialize,
            allOffsets,
            Repo(),
          ))
          as P;
    case 89:
      return (reader.readLongOrNull(offset)) as P;
    case 90:
      return (_SettingsmangaHomeDisplayTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DisplayType.comfortableGrid)
          as P;
    case 91:
      return (reader.readLongOrNull(offset)) as P;
    case 92:
      return (reader.readBoolOrNull(offset)) as P;
    case 93:
      return (reader.readStringList(offset)) as P;
    case 94:
      return (_SettingsnovelDisplayTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DisplayType.comfortableGrid)
          as P;
    case 95:
      return (reader.readObjectList<Repo>(
            offset,
            RepoSchema.deserialize,
            allOffsets,
            Repo(),
          ))
          as P;
    case 96:
      return (reader.readLongOrNull(offset)) as P;
    case 97:
      return (reader.readLongOrNull(offset)) as P;
    case 98:
      return (reader.readBoolOrNull(offset)) as P;
    case 99:
      return (reader.readBoolOrNull(offset)) as P;
    case 100:
      return (reader.readBoolOrNull(offset)) as P;
    case 101:
      return (reader.readBoolOrNull(offset)) as P;
    case 102:
      return (reader.readBoolOrNull(offset)) as P;
    case 103:
      return (reader.readBoolOrNull(offset)) as P;
    case 104:
      return (_SettingsnovelTextAlignValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              NovelTextAlign.left)
          as P;
    case 105:
      return (reader.readBoolOrNull(offset)) as P;
    case 106:
      return (reader.readLongOrNull(offset)) as P;
    case 107:
      return (reader.readObjectList<PersonalPageMode>(
            offset,
            PersonalPageModeSchema.deserialize,
            allOffsets,
            PersonalPageMode(),
          ))
          as P;
    case 108:
      return (reader.readObjectList<PersonalReaderMode>(
            offset,
            PersonalReaderModeSchema.deserialize,
            allOffsets,
            PersonalReaderMode(),
          ))
          as P;
    case 109:
      return (reader.readObjectOrNull<PlayerSubtitleSettings>(
            offset,
            PlayerSubtitleSettingsSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 110:
      return (reader.readBoolOrNull(offset)) as P;
    case 111:
      return (reader.readLongOrNull(offset)) as P;
    case 112:
      return (reader.readBoolOrNull(offset)) as P;
    case 113:
      return (reader.readBoolOrNull(offset)) as P;
    case 114:
      return (reader.readBoolOrNull(offset)) as P;
    case 115:
      return (reader.readBoolOrNull(offset)) as P;
    case 116:
      return (_SettingsscaleTypeValueEnumMap[reader.readByteOrNull(offset)] ??
              ScaleType.fitScreen)
          as P;
    case 117:
      return (reader.readBoolOrNull(offset)) as P;
    case 118:
      return (reader.readObjectList<SortChapter>(
            offset,
            SortChapterSchema.deserialize,
            allOffsets,
            SortChapter(),
          ))
          as P;
    case 119:
      return (reader.readObjectOrNull<SortLibraryManga>(
            offset,
            SortLibraryMangaSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 120:
      return (reader.readObjectOrNull<SortLibraryManga>(
            offset,
            SortLibraryMangaSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 121:
      return (reader.readObjectOrNull<SortLibraryManga>(
            offset,
            SortLibraryMangaSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 122:
      return (reader.readLongOrNull(offset)) as P;
    case 123:
      return (reader.readBoolOrNull(offset)) as P;
    case 124:
      return (reader.readBoolOrNull(offset)) as P;
    case 125:
      return (reader.readLongOrNull(offset)) as P;
    case 126:
      return (reader.readBoolOrNull(offset)) as P;
    case 127:
      return (reader.readBoolOrNull(offset)) as P;
    case 128:
      return (reader.readBoolOrNull(offset)) as P;
    case 129:
      return (reader.readBoolOrNull(offset)) as P;
    case 130:
      return (reader.readStringOrNull(offset)) as P;
    case 131:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SettingsanimeDisplayTypeEnumValueMap = {
  'compactGrid': 0,
  'comfortableGrid': 1,
  'coverOnlyGrid': 2,
  'list': 3,
};
const _SettingsanimeDisplayTypeValueEnumMap = {
  0: DisplayType.compactGrid,
  1: DisplayType.comfortableGrid,
  2: DisplayType.coverOnlyGrid,
  3: DisplayType.list,
};
const _SettingsaudioChannelsEnumValueMap = {
  'auto': 0,
  'autoSafe': 1,
  'mono': 2,
  'stereo': 3,
  'reverseStereo': 4,
};
const _SettingsaudioChannelsValueEnumMap = {
  0: AudioChannel.auto,
  1: AudioChannel.autoSafe,
  2: AudioChannel.mono,
  3: AudioChannel.stereo,
  4: AudioChannel.reverseStereo,
};
const _SettingsbackgroundColorEnumValueMap = {
  'black': 0,
  'grey': 1,
  'white': 2,
  'automatic': 3,
};
const _SettingsbackgroundColorValueEnumMap = {
  0: BackgroundColor.black,
  1: BackgroundColor.grey,
  2: BackgroundColor.white,
  3: BackgroundColor.automatic,
};
const _SettingscolorFilterBlendModeEnumValueMap = {
  'none': 0,
  'multiply': 1,
  'screen': 2,
  'overlay': 3,
  'colorDodge': 4,
  'lighten': 5,
  'colorBurn': 6,
  'darken': 7,
  'difference': 8,
  'saturation': 9,
  'softLight': 10,
  'plus': 11,
  'exclusion': 12,
};
const _SettingscolorFilterBlendModeValueEnumMap = {
  0: ColorFilterBlendMode.none,
  1: ColorFilterBlendMode.multiply,
  2: ColorFilterBlendMode.screen,
  3: ColorFilterBlendMode.overlay,
  4: ColorFilterBlendMode.colorDodge,
  5: ColorFilterBlendMode.lighten,
  6: ColorFilterBlendMode.colorBurn,
  7: ColorFilterBlendMode.darken,
  8: ColorFilterBlendMode.difference,
  9: ColorFilterBlendMode.saturation,
  10: ColorFilterBlendMode.softLight,
  11: ColorFilterBlendMode.plus,
  12: ColorFilterBlendMode.exclusion,
};
const _SettingsdebandingTypeEnumValueMap = {'none': 0, 'cpu': 1, 'gpu': 2};
const _SettingsdebandingTypeValueEnumMap = {
  0: DebandingType.none,
  1: DebandingType.cpu,
  2: DebandingType.gpu,
};
const _SettingsdefaultReaderModeEnumValueMap = {
  'vertical': 0,
  'ltr': 1,
  'rtl': 2,
  'verticalContinuous': 3,
  'webtoon': 4,
  'horizontalContinuous': 5,
};
const _SettingsdefaultReaderModeValueEnumMap = {
  0: ReaderMode.vertical,
  1: ReaderMode.ltr,
  2: ReaderMode.rtl,
  3: ReaderMode.verticalContinuous,
  4: ReaderMode.webtoon,
  5: ReaderMode.horizontalContinuous,
};
const _SettingsdisableSectionTypeEnumValueMap = {
  'all': 0,
  'anime': 1,
  'manga': 2,
};
const _SettingsdisableSectionTypeValueEnumMap = {
  0: SectionType.all,
  1: SectionType.anime,
  2: SectionType.manga,
};
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
const _SettingsmangaHomeDisplayTypeEnumValueMap = {
  'compactGrid': 0,
  'comfortableGrid': 1,
  'coverOnlyGrid': 2,
  'list': 3,
};
const _SettingsmangaHomeDisplayTypeValueEnumMap = {
  0: DisplayType.compactGrid,
  1: DisplayType.comfortableGrid,
  2: DisplayType.coverOnlyGrid,
  3: DisplayType.list,
};
const _SettingsnovelDisplayTypeEnumValueMap = {
  'compactGrid': 0,
  'comfortableGrid': 1,
  'coverOnlyGrid': 2,
  'list': 3,
};
const _SettingsnovelDisplayTypeValueEnumMap = {
  0: DisplayType.compactGrid,
  1: DisplayType.comfortableGrid,
  2: DisplayType.coverOnlyGrid,
  3: DisplayType.list,
};
const _SettingsnovelTextAlignEnumValueMap = {
  'left': 0,
  'center': 1,
  'right': 2,
  'block': 3,
};
const _SettingsnovelTextAlignValueEnumMap = {
  0: NovelTextAlign.left,
  1: NovelTextAlign.center,
  2: NovelTextAlign.right,
  3: NovelTextAlign.block,
};
const _SettingsscaleTypeEnumValueMap = {
  'fitScreen': 0,
  'stretch': 1,
  'fitWidth': 2,
  'fitHeight': 3,
  'originalSize': 4,
  'smartFit': 5,
};
const _SettingsscaleTypeValueEnumMap = {
  0: ScaleType.fitScreen,
  1: ScaleType.stretch,
  2: ScaleType.fitWidth,
  3: ScaleType.fitHeight,
  4: ScaleType.originalSize,
  5: ScaleType.smartFit,
};

Id _settingsGetId(Settings object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _settingsGetLinks(Settings object) {
  return [object.sources];
}

void _settingsAttach(IsarCollection<dynamic> col, Id id, Settings object) {
  object.id = id;
  object.sources.attach(col, col.isar.collection<Source>(), r'sources', id);
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
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
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

  QueryBuilder<Settings, Settings, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
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

extension SettingsQueryFilter
    on QueryBuilder<Settings, Settings, QFilterCondition> {
  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  algorithmWeightsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'algorithmWeights'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  algorithmWeightsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'algorithmWeights'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'androidProxyServer'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'androidProxyServer'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'androidProxyServer',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'androidProxyServer',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'androidProxyServer',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'androidProxyServer', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  androidProxyServerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'androidProxyServer', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'aniSkipTimeoutLength'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'aniSkipTimeoutLength'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'aniSkipTimeoutLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'aniSkipTimeoutLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'aniSkipTimeoutLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  aniSkipTimeoutLengthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'aniSkipTimeoutLength',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animatePageTransitionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'animatePageTransitions'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animatePageTransitionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'animatePageTransitions'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animatePageTransitionsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animatePageTransitions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeDisplayTypeEqualTo(DisplayType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'animeDisplayType', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeDisplayTypeGreaterThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'animeDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeDisplayTypeLessThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'animeDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeDisplayTypeBetween(
    DisplayType lower,
    DisplayType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'animeDisplayType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'animeExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'animeExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'animeExtensionsRepo',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'animeExtensionsRepo', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'animeExtensionsRepo', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'animeExtensionsRepo', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'animeExtensionsRepo',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'animeExtensionsRepo',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeGridSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'animeGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeGridSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'animeGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> animeGridSizeEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'animeGridSize', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeGridSizeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'animeGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> animeGridSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'animeGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> animeGridSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'animeGridSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryDownloadedChaptersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'animeLibraryDownloadedChapters',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryDownloadedChaptersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'animeLibraryDownloadedChapters',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryDownloadedChaptersEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryDownloadedChapters',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryLocalSourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'animeLibraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryLocalSourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'animeLibraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryLocalSourceEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryLocalSource',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowCategoryTabsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'animeLibraryShowCategoryTabs'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowCategoryTabsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'animeLibraryShowCategoryTabs',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowCategoryTabsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryShowCategoryTabs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowContinueReadingButtonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'animeLibraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowContinueReadingButtonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'animeLibraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowContinueReadingButtonEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryShowContinueReadingButton',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'animeLibraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'animeLibraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowLanguageEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryShowLanguage',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowNumbersOfItemsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'animeLibraryShowNumbersOfItems',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowNumbersOfItemsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'animeLibraryShowNumbersOfItems',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeLibraryShowNumbersOfItemsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'animeLibraryShowNumbersOfItems',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'appFontFamily'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'appFontFamily'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'appFontFamily',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'appFontFamily',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> appFontFamilyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'appFontFamily',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'appFontFamily', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  appFontFamilyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'appFontFamily', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> audioChannelsEqualTo(
    AudioChannel value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'audioChannels', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioChannelsGreaterThan(AudioChannel value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'audioChannels',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> audioChannelsLessThan(
    AudioChannel value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'audioChannels',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> audioChannelsBetween(
    AudioChannel lower,
    AudioChannel upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'audioChannels',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'audioPreferredLanguages'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'audioPreferredLanguages'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'audioPreferredLanguages',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'audioPreferredLanguages',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'audioPreferredLanguages',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'audioPreferredLanguages',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  audioPreferredLanguagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'audioPreferredLanguages',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoBackupLocation'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoBackupLocation'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'autoBackupLocation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'autoBackupLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'autoBackupLocation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoBackupLocation', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoBackupLocationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'autoBackupLocation', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoExtensionsUpdatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoExtensionsUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoExtensionsUpdatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoExtensionsUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoExtensionsUpdatesEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'autoExtensionsUpdates',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoScrollPages'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoScrollPages'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'autoScrollPages', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'autoScrollPages', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'autoScrollPages', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'autoScrollPages', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'autoScrollPages',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'autoScrollPages',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backgroundColorEqualTo(BackgroundColor value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backgroundColor', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backgroundColorGreaterThan(BackgroundColor value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backgroundColor',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backgroundColorLessThan(BackgroundColor value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backgroundColor',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backgroundColorBetween(
    BackgroundColor lower,
    BackgroundColor upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backgroundColor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backupFrequency'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backupFrequency'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backupFrequency', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backupFrequency',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backupFrequency',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupFrequencyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backupFrequency',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backupListOptions'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backupListOptions'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backupListOptions', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backupListOptions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backupListOptions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backupListOptions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'backupListOptions', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'backupListOptions', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'backupListOptions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'backupListOptions', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'backupListOptions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  backupListOptionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'backupListOptions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'btServerAddress'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'btServerAddress'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'btServerAddress',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'btServerAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'btServerAddress',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'btServerAddress', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'btServerAddress', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> btServerPortIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'btServerPort'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerPortIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'btServerPort'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> btServerPortEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'btServerPort', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  btServerPortGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'btServerPort',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> btServerPortLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'btServerPort',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> btServerPortBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'btServerPort',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterFilterBookmarkedList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'chapterFilterBookmarkedList',
        ),
      );
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
      return query.listLength(r'chapterFilterBookmarkedList', 0, true, 0, true);
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
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterFilterDownloadedList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterDownloadedListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'chapterFilterDownloadedList',
        ),
      );
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
      return query.listLength(r'chapterFilterDownloadedList', 0, true, 0, true);
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
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterFilterUnreadList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterUnreadListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterFilterUnreadList'),
      );
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
      return query.listLength(r'chapterFilterUnreadList', 0, true, 0, true);
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
  chapterFilterUnreadListLengthLessThan(int length, {bool include = false}) {
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
  chapterFilterUnreadListLengthGreaterThan(int length, {bool include = false}) {
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
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterPageIndexList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterPageIndexList'),
      );
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
      return query.listLength(r'chapterPageIndexList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'chapterPageIndexList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageIndexListLengthLessThan(int length, {bool include = false}) {
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
  chapterPageIndexListLengthGreaterThan(int length, {bool include = false}) {
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
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterPageUrlsList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageUrlsListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterPageUrlsList'),
      );
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
      return query.listLength(r'chapterPageUrlsList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageUrlsListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'chapterPageUrlsList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageUrlsListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'chapterPageUrlsList', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterPageUrlsListLengthGreaterThan(int length, {bool include = false}) {
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForAppUpdatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'checkForAppUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForAppUpdatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'checkForAppUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForAppUpdatesEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'checkForAppUpdates', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForExtensionUpdatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'checkForExtensionUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForExtensionUpdatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'checkForExtensionUpdates'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  checkForExtensionUpdatesEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'checkForExtensionUpdates',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  clearChapterCacheOnAppLaunchIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'clearChapterCacheOnAppLaunch'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  clearChapterCacheOnAppLaunchIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'clearChapterCacheOnAppLaunch',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  clearChapterCacheOnAppLaunchEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'clearChapterCacheOnAppLaunch',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  colorFilterBlendModeEqualTo(ColorFilterBlendMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'colorFilterBlendMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  colorFilterBlendModeGreaterThan(
    ColorFilterBlendMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'colorFilterBlendMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  colorFilterBlendModeLessThan(
    ColorFilterBlendMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'colorFilterBlendMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  colorFilterBlendModeBetween(
    ColorFilterBlendMode lower,
    ColorFilterBlendMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'colorFilterBlendMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'concurrentDownloads'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'concurrentDownloads'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'concurrentDownloads', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'concurrentDownloads',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'concurrentDownloads',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  concurrentDownloadsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'concurrentDownloads',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cookiesListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cookiesList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cookiesListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cookiesList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cookiesListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cookiesList', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cookiesListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cookiesList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cookiesListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cookiesList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cookiesListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cookiesList', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cookiesListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cookiesList', length, include, 999999, true);
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cropBordersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cropBorders'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  cropBordersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cropBorders'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> cropBordersEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cropBorders', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  customColorFilterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customColorFilter'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  customColorFilterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customColorFilter'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customDns'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customDns'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'customDns',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'customDns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'customDns',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customDnsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customDns', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  customDnsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customDns', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dateFormat'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  dateFormatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dateFormat'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatEqualTo(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatGreaterThan(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatLessThan(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatBetween(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatStartsWith(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatEndsWith(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatContains(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatMatches(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> dateFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateFormat', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  dateFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dateFormat', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> debandingTypeEqualTo(
    DebandingType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'debandingType', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  debandingTypeGreaterThan(DebandingType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'debandingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> debandingTypeLessThan(
    DebandingType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'debandingType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> debandingTypeBetween(
    DebandingType lower,
    DebandingType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'debandingType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'defaultDoubleTapToSkipLength'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'defaultDoubleTapToSkipLength',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultDoubleTapToSkipLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultDoubleTapToSkipLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultDoubleTapToSkipLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultDoubleTapToSkipLengthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultDoubleTapToSkipLength',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'defaultPlayBackSpeed'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'defaultPlayBackSpeed'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultPlayBackSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultPlayBackSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultPlayBackSpeed',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultPlayBackSpeedBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultPlayBackSpeed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultReaderModeEqualTo(ReaderMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'defaultReaderMode', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultReaderModeGreaterThan(ReaderMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultReaderMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultReaderModeLessThan(ReaderMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultReaderMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultReaderModeBetween(
    ReaderMode lower,
    ReaderMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultReaderMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'defaultSkipIntroLength'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'defaultSkipIntroLength'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultSkipIntroLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultSkipIntroLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultSkipIntroLength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSkipIntroLengthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultSkipIntroLength',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSubtitleLangIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'defaultSubtitleLang'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  defaultSubtitleLangIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'defaultSubtitleLang'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  disableSectionTypeEqualTo(SectionType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'disableSectionType', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  disableSectionTypeGreaterThan(SectionType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'disableSectionType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  disableSectionTypeLessThan(SectionType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'disableSectionType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  disableSectionTypeBetween(
    SectionType lower,
    SectionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'disableSectionType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> displayTypeEqualTo(
    DisplayType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'displayType', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  displayTypeGreaterThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'displayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> displayTypeLessThan(
    DisplayType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'displayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> displayTypeBetween(
    DisplayType lower,
    DisplayType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'displayType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doubleTapAnimationSpeedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'doubleTapAnimationSpeed'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doubleTapAnimationSpeedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'doubleTapAnimationSpeed'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doubleTapAnimationSpeedEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'doubleTapAnimationSpeed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doubleTapAnimationSpeedGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'doubleTapAnimationSpeed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doubleTapAnimationSpeedLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'doubleTapAnimationSpeed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  doubleTapAnimationSpeedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'doubleTapAnimationSpeed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'downloadLocation'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'downloadLocation'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'downloadLocation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'downloadLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'downloadLocation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'downloadLocation', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadLocationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'downloadLocation', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadOnlyOnWifiIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'downloadOnlyOnWifi'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadOnlyOnWifiIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'downloadOnlyOnWifi'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadOnlyOnWifiEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'downloadOnlyOnWifi', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadedOnlyModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'downloadedOnlyMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadedOnlyModeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'downloadedOnlyMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  downloadedOnlyModeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'downloadedOnlyMode', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAniSkipIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableAniSkip'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAniSkipIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'enableAniSkip'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> enableAniSkipEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'enableAniSkip', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAudioPitchCorrectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableAudioPitchCorrection'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAudioPitchCorrectionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'enableAudioPitchCorrection',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAudioPitchCorrectionEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'enableAudioPitchCorrection',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAutoSkipIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableAutoSkip'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableAutoSkipIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'enableAutoSkip'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> enableAutoSkipEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'enableAutoSkip', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableCustomColorFilterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableCustomColorFilter'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableCustomColorFilterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'enableCustomColorFilter'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableCustomColorFilterEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'enableCustomColorFilter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableDiscordRpcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableDiscordRpc'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableDiscordRpcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'enableDiscordRpc'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableDiscordRpcEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'enableDiscordRpc', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableGpuNextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableGpuNext'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableGpuNextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'enableGpuNext'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> enableGpuNextEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'enableGpuNext', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableHardwareAccelerationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'enableHardwareAcceleration'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableHardwareAccelerationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'enableHardwareAcceleration',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  enableHardwareAccelerationEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'enableHardwareAcceleration',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'filterScanlatorList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'filterScanlatorList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'filterScanlatorList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'filterScanlatorList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'filterScanlatorList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'filterScanlatorList', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'filterScanlatorList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'filterScanlatorList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexColorSchemeBlendLevelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'flexColorSchemeBlendLevel'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexColorSchemeBlendLevelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'flexColorSchemeBlendLevel'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexColorSchemeBlendLevelEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'flexColorSchemeBlendLevel',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexColorSchemeBlendLevelGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'flexColorSchemeBlendLevel',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexColorSchemeBlendLevelLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'flexColorSchemeBlendLevel',
          value: value,

          epsilon: epsilon,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'flexColorSchemeBlendLevel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexSchemeColorIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'flexSchemeColorIndex'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexSchemeColorIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'flexSchemeColorIndex'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexSchemeColorIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'flexSchemeColorIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexSchemeColorIndexGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'flexSchemeColorIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  flexSchemeColorIndexLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'flexSchemeColorIndex',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'flexSchemeColorIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  followSystemThemeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'followSystemTheme'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  followSystemThemeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'followSystemTheme'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  followSystemThemeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'followSystemTheme', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenPlayerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fullScreenPlayer'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenPlayerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fullScreenPlayer'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenPlayerEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fullScreenPlayer', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenReaderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fullScreenReader'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenReaderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fullScreenReader'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  fullScreenReaderEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fullScreenReader', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideDiscordRpcInIncognitoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hideDiscordRpcInIncognito'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideDiscordRpcInIncognitoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hideDiscordRpcInIncognito'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideDiscordRpcInIncognitoEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hideDiscordRpcInIncognito',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hideItemsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hideItems'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hideItemsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hideItems'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hideItems',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'hideItems',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'hideItems',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hideItems', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'hideItems', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'hideItems', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hideItemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'hideItems', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'hideItems', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'hideItems', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'hideItems', length, include, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hideItemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'hideItems',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hwdecMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hwdecMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hwdecMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'hwdecMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'hwdecMode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> hwdecModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hwdecMode', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  hwdecModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'hwdecMode', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  incognitoModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'incognitoMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  incognitoModeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'incognitoMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> incognitoModeEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'incognitoMode', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastTrackerLibraryLocation'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'lastTrackerLibraryLocation',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastTrackerLibraryLocation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lastTrackerLibraryLocation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lastTrackerLibraryLocation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastTrackerLibraryLocation',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  lastTrackerLibraryLocationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'lastTrackerLibraryLocation',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryDownloadedChaptersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryDownloadedChapters'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryDownloadedChaptersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryDownloadedChapters'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryDownloadedChaptersEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryDownloadedChapters',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterAnimeBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterAnimeBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterAnimeBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterAnimeBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeBookMarkedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterAnimeBookMarkedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterAnimeDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterAnimeDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterAnimeDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterAnimeDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeDownloadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterAnimeDownloadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterAnimeStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterAnimeStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterAnimeStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterAnimeStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeStartedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterAnimeStartedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryFilterAnimeUnreadType'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterAnimeUnreadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterAnimeUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterAnimeUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterAnimeUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterAnimeUnreadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterAnimeUnreadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasBookMarkedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterMangasBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasBookMarkedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterMangasBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasBookMarkedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasBookMarkedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterMangasBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasBookMarkedTypeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterMangasBookMarkedType',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterMangasBookMarkedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasDownloadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterMangasDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasDownloadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterMangasDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasDownloadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasDownloadTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterMangasDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasDownloadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterMangasDownloadType',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterMangasDownloadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasStartedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterMangasStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasStartedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterMangasStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasStartedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasStartedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterMangasStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasStartedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterMangasStartedType',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterMangasStartedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasUnreadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterMangasUnreadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasUnreadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterMangasUnreadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasUnreadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterMangasUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasUnreadTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterMangasUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterMangasUnreadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterMangasUnreadType',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterMangasUnreadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterNovelBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterNovelBookMarkedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterNovelBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterNovelBookMarkedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelBookMarkedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterNovelBookMarkedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterNovelDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterNovelDownloadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterNovelDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterNovelDownloadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelDownloadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterNovelDownloadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryFilterNovelStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterNovelStartedType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterNovelStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterNovelStartedType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelStartedTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterNovelStartedType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryFilterNovelUnreadType'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryFilterNovelUnreadType',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryFilterNovelUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryFilterNovelUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryFilterNovelUnreadType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryFilterNovelUnreadTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryFilterNovelUnreadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryLocalSourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryLocalSourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryLocalSourceEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'libraryLocalSource', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowCategoryTabsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryShowCategoryTabs'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowCategoryTabsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryShowCategoryTabs'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowCategoryTabsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryShowCategoryTabs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowContinueReadingButtonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'libraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowContinueReadingButtonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'libraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowContinueReadingButtonEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryShowContinueReadingButton',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowLanguageEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'libraryShowLanguage', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowNumbersOfItemsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryShowNumbersOfItems'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowNumbersOfItemsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryShowNumbersOfItems'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  libraryShowNumbersOfItemsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'libraryShowNumbersOfItems',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> localeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'locale'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> localeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'locale'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mangaExtensionsRepo',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'mangaExtensionsRepo', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'mangaExtensionsRepo', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'mangaExtensionsRepo', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mangaExtensionsRepo',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mangaExtensionsRepo',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaGridSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaGridSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> mangaGridSizeEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaGridSize', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaGridSizeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> mangaGridSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> mangaGridSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaGridSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaHomeDisplayTypeEqualTo(DisplayType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mangaHomeDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaHomeDisplayTypeGreaterThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaHomeDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaHomeDisplayTypeLessThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaHomeDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaHomeDisplayTypeBetween(
    DisplayType lower,
    DisplayType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaHomeDisplayType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'markEpisodeAsSeenType'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'markEpisodeAsSeenType'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'markEpisodeAsSeenType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'markEpisodeAsSeenType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'markEpisodeAsSeenType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  markEpisodeAsSeenTypeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'markEpisodeAsSeenType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mergeLibraryNavMobileIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mergeLibraryNavMobile'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mergeLibraryNavMobileIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mergeLibraryNavMobile'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mergeLibraryNavMobileEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mergeLibraryNavMobile',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'navigationOrder'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'navigationOrder'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'navigationOrder',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'navigationOrder',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'navigationOrder',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'navigationOrder', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'navigationOrder', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'navigationOrder', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'navigationOrder', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'navigationOrder', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'navigationOrder', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'navigationOrder',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  navigationOrderLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'navigationOrder',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelDisplayTypeEqualTo(DisplayType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelDisplayType', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelDisplayTypeGreaterThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelDisplayTypeLessThan(DisplayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelDisplayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelDisplayTypeBetween(
    DisplayType lower,
    DisplayType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelDisplayType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelExtensionsRepo'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'novelExtensionsRepo',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'novelExtensionsRepo', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'novelExtensionsRepo', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'novelExtensionsRepo', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'novelExtensionsRepo',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'novelExtensionsRepo',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelFontSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelFontSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelFontSizeEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelFontSize', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelFontSizeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelFontSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelFontSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelFontSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelFontSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelFontSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelGridSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelGridSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelGridSize'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelGridSizeEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelGridSize', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelGridSizeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelGridSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelGridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelGridSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelGridSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryDownloadedChaptersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'novelLibraryDownloadedChapters',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryDownloadedChaptersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'novelLibraryDownloadedChapters',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryDownloadedChaptersEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryDownloadedChapters',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryLocalSourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelLibraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryLocalSourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelLibraryLocalSource'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryLocalSourceEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryLocalSource',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowCategoryTabsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelLibraryShowCategoryTabs'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowCategoryTabsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'novelLibraryShowCategoryTabs',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowCategoryTabsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryShowCategoryTabs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowContinueReadingButtonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'novelLibraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowContinueReadingButtonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'novelLibraryShowContinueReadingButton',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowContinueReadingButtonEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryShowContinueReadingButton',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'novelLibraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'novelLibraryShowLanguage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowLanguageEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryShowLanguage',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowNumbersOfItemsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'novelLibraryShowNumbersOfItems',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowNumbersOfItemsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'novelLibraryShowNumbersOfItems',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelLibraryShowNumbersOfItemsEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'novelLibraryShowNumbersOfItems',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelTextAlignEqualTo(
    NovelTextAlign value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'novelTextAlign', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelTextAlignGreaterThan(NovelTextAlign value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'novelTextAlign',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelTextAlignLessThan(NovelTextAlign value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'novelTextAlign',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> novelTextAlignBetween(
    NovelTextAlign lower,
    NovelTextAlign upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'novelTextAlign',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  onlyIncludePinnedSourcesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'onlyIncludePinnedSources'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  onlyIncludePinnedSourcesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'onlyIncludePinnedSources'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  onlyIncludePinnedSourcesEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'onlyIncludePinnedSources',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pagePreloadAmountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pagePreloadAmount'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pagePreloadAmountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pagePreloadAmount'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pagePreloadAmountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pagePreloadAmount', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pagePreloadAmountGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pagePreloadAmount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pagePreloadAmountLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pagePreloadAmount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pagePreloadAmountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pagePreloadAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'personalPageModeList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'personalPageModeList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalPageModeList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'personalPageModeList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'personalPageModeList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalPageModeList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalPageModeList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalPageModeList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'personalReaderModeList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'personalReaderModeList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalReaderModeList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'personalReaderModeList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalReaderModeList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalReaderModeList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalReaderModeList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'personalReaderModeList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  playerSubtitleSettingsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'playerSubtitleSettings'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  playerSubtitleSettingsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'playerSubtitleSettings'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pureBlackDarkModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pureBlackDarkMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pureBlackDarkModeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pureBlackDarkMode'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  pureBlackDarkModeEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pureBlackDarkMode', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  relativeTimesTampsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'relativeTimesTamps'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  relativeTimesTampsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'relativeTimesTamps'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  relativeTimesTampsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'relativeTimesTamps', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  relativeTimesTampsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'relativeTimesTamps',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  relativeTimesTampsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'relativeTimesTamps',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'relativeTimesTamps',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowCoverImageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'rpcShowCoverImage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowCoverImageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'rpcShowCoverImage'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowCoverImageEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rpcShowCoverImage', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowReadingWatchingProgressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'rpcShowReadingWatchingProgress',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowReadingWatchingProgressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'rpcShowReadingWatchingProgress',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowReadingWatchingProgressEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rpcShowReadingWatchingProgress',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> rpcShowTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'rpcShowTitle'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  rpcShowTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'rpcShowTitle'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> rpcShowTitleEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rpcShowTitle', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  saveAsCBZArchiveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'saveAsCBZArchive'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  saveAsCBZArchiveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'saveAsCBZArchive'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  saveAsCBZArchiveEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'saveAsCBZArchive', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> scaleTypeEqualTo(
    ScaleType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scaleType', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> scaleTypeGreaterThan(
    ScaleType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scaleType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> scaleTypeLessThan(
    ScaleType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scaleType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> scaleTypeBetween(
    ScaleType lower,
    ScaleType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scaleType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  showPagesNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'showPagesNumber'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  showPagesNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'showPagesNumber'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  showPagesNumberEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'showPagesNumber', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sortChapterList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sortChapterList'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sortChapterList', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sortChapterList', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sortChapterList', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sortChapterList', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListLengthGreaterThan(int length, {bool include = false}) {
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
  sortLibraryAnimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sortLibraryAnime'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortLibraryAnimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sortLibraryAnime'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortLibraryMangaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sortLibraryManga'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortLibraryMangaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sortLibraryManga'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortLibraryNovelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sortLibraryNovel'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortLibraryNovelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sortLibraryNovel'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startDatebackup'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startDatebackup'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startDatebackup', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startDatebackup',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startDatebackup',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  startDatebackupBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startDatebackup',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> themeIsDarkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'themeIsDark'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  themeIsDarkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'themeIsDark'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> themeIsDarkEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'themeIsDark', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateProgressAfterReadingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updateProgressAfterReading'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateProgressAfterReadingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'updateProgressAfterReading',
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  updateProgressAfterReadingEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'updateProgressAfterReading',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'updatedAt'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useLibassIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'useLibass'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useLibassIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'useLibass'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useLibassEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'useLibass', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useMpvConfigIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'useMpvConfig'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  useMpvConfigIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'useMpvConfig'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useMpvConfigEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'useMpvConfig', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  usePageTapZonesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'usePageTapZones'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  usePageTapZonesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'usePageTapZones'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  usePageTapZonesEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'usePageTapZones', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useYUV420PIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'useYUV420P'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  useYUV420PIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'useYUV420P'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> useYUV420PEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'useYUV420P', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'userAgent'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'userAgent'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userAgent',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userAgent',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userAgent',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> userAgentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userAgent', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  userAgentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userAgent', value: ''),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  volumeBoostCapIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'volumeBoostCap'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  volumeBoostCapIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'volumeBoostCap'),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> volumeBoostCapEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'volumeBoostCap', value: value),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  volumeBoostCapGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'volumeBoostCap',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  volumeBoostCapLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'volumeBoostCap',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> volumeBoostCapBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'volumeBoostCap',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SettingsQueryObject
    on QueryBuilder<Settings, Settings, QFilterCondition> {
  QueryBuilder<Settings, Settings, QAfterFilterCondition> algorithmWeights(
    FilterQuery<AlgorithmWeights> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'algorithmWeights');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  animeExtensionsRepoElement(FilterQuery<Repo> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'animeExtensionsRepo');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  autoScrollPagesElement(FilterQuery<AutoScrollPages> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'autoScrollPages');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterBookmarkedListElement(FilterQuery<ChapterFilterBookmarked> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'chapterFilterBookmarkedList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  chapterFilterDownloadedListElement(FilterQuery<ChapterFilterDownloaded> q) {
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
    FilterQuery<MCookie> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'cookiesList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> customColorFilter(
    FilterQuery<CustomColorFilter> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'customColorFilter');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> defaultSubtitleLang(
    FilterQuery<L10nLocale> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'defaultSubtitleLang');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  filterScanlatorListElement(FilterQuery<FilterScanlator> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'filterScanlatorList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> locale(
    FilterQuery<L10nLocale> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'locale');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  mangaExtensionsRepoElement(FilterQuery<Repo> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'mangaExtensionsRepo');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  novelExtensionsRepoElement(FilterQuery<Repo> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'novelExtensionsRepo');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalPageModeListElement(FilterQuery<PersonalPageMode> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'personalPageModeList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  personalReaderModeListElement(FilterQuery<PersonalReaderMode> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'personalReaderModeList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  playerSubtitleSettings(FilterQuery<PlayerSubtitleSettings> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'playerSubtitleSettings');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sortChapterListElement(FilterQuery<SortChapter> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sortChapterList');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sortLibraryAnime(
    FilterQuery<SortLibraryManga> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sortLibraryAnime');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sortLibraryManga(
    FilterQuery<SortLibraryManga> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sortLibraryManga');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sortLibraryNovel(
    FilterQuery<SortLibraryManga> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sortLibraryNovel');
    });
  }
}

extension SettingsQueryLinks
    on QueryBuilder<Settings, Settings, QFilterCondition> {
  QueryBuilder<Settings, Settings, QAfterFilterCondition> sources(
    FilterQuery<Source> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'sources');
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sourcesLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sources', length, true, length, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sourcesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sources', 0, true, 0, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sourcesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sources', 0, false, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sourcesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sources', 0, true, length, include);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition>
  sourcesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'sources', length, include, 999999, true);
    });
  }

  QueryBuilder<Settings, Settings, QAfterFilterCondition> sourcesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'sources',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension SettingsQuerySortBy on QueryBuilder<Settings, Settings, QSortBy> {
  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAndroidProxyServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidProxyServer', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAndroidProxyServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidProxyServer', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAniSkipTimeoutLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniSkipTimeoutLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAniSkipTimeoutLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniSkipTimeoutLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimatePageTransitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animatePageTransitions', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimatePageTransitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animatePageTransitions', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAnimeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAnimeDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAnimeGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAnimeGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryLocalSource', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'animeLibraryShowContinueReadingButton',
        Sort.asc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'animeLibraryShowContinueReadingButton',
        Sort.desc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAnimeLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAppFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appFontFamily', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAppFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appFontFamily', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAudioChannels() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioChannels', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAudioChannelsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioChannels', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAudioPreferredLanguages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPreferredLanguages', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAudioPreferredLanguagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPreferredLanguages', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAutoBackupLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoBackupLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupLocation', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByAutoExtensionsUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoExtensionsUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByAutoExtensionsUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoExtensionsUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBackgroundColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBackgroundColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBackupFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFrequency', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBackupFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFrequency', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBtServerAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerAddress', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBtServerAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerAddress', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBtServerPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerPort', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByBtServerPortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerPort', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCheckForAppUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForAppUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByCheckForAppUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForAppUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByCheckForExtensionUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForExtensionUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByCheckForExtensionUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForExtensionUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByClearChapterCacheOnAppLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearChapterCacheOnAppLaunch', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByClearChapterCacheOnAppLaunchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearChapterCacheOnAppLaunch', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByColorFilterBlendMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorFilterBlendMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByColorFilterBlendModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorFilterBlendMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concurrentDownloads', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByConcurrentDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concurrentDownloads', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCropBorders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropBorders', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCropBordersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropBorders', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCustomDns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDns', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByCustomDnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDns', Sort.desc);
    });
  }

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

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDebandingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debandingType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDebandingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debandingType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDefaultDoubleTapToSkipLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDoubleTapToSkipLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDefaultDoubleTapToSkipLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDoubleTapToSkipLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDefaultPlayBackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlayBackSpeed', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDefaultPlayBackSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlayBackSpeed', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDefaultReaderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReaderMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDefaultReaderModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReaderMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDefaultSkipIntroLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSkipIntroLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDefaultSkipIntroLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSkipIntroLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDisableSectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableSectionType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDisableSectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableSectionType', Sort.desc);
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
  sortByDoubleTapAnimationSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doubleTapAnimationSpeed', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDoubleTapAnimationSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doubleTapAnimationSpeed', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDownloadLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDownloadLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocation', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDownloadOnlyOnWifi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadOnlyOnWifi', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDownloadOnlyOnWifiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadOnlyOnWifi', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByDownloadedOnlyMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedOnlyMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByDownloadedOnlyModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedOnlyMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableAniSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAniSkip', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableAniSkipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAniSkip', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByEnableAudioPitchCorrection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAudioPitchCorrection', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByEnableAudioPitchCorrectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAudioPitchCorrection', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableAutoSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAutoSkip', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableAutoSkipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAutoSkip', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByEnableCustomColorFilter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCustomColorFilter', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByEnableCustomColorFilterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCustomColorFilter', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableDiscordRpc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDiscordRpc', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableDiscordRpcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDiscordRpc', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableGpuNext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableGpuNext', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByEnableGpuNextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableGpuNext', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByEnableHardwareAcceleration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHardwareAcceleration', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByEnableHardwareAccelerationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHardwareAcceleration', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFollowSystemTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followSystemTheme', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFollowSystemThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followSystemTheme', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFullScreenPlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenPlayer', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFullScreenPlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenPlayer', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFullScreenReader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenReader', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByFullScreenReaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenReader', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByHideDiscordRpcInIncognito() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideDiscordRpcInIncognito', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByHideDiscordRpcInIncognitoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideDiscordRpcInIncognito', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByHwdecMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hwdecMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByHwdecModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hwdecMode', Sort.desc);
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
  sortByLastTrackerLibraryLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTrackerLibraryLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLastTrackerLibraryLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTrackerLibraryLocation', Sort.desc);
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
  sortByLibraryFilterAnimeBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterAnimeUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeUnreadType', Sort.desc);
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
  sortByLibraryFilterNovelBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryFilterNovelUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelUnreadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryLocalSource', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByMangaGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByMangaGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByMangaHomeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaHomeDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByMangaHomeDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaHomeDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByMarkEpisodeAsSeenType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markEpisodeAsSeenType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByMarkEpisodeAsSeenTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markEpisodeAsSeenType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByMergeLibraryNavMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mergeLibraryNavMobile', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByMergeLibraryNavMobileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mergeLibraryNavMobile', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryLocalSource', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'novelLibraryShowContinueReadingButton',
        Sort.asc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'novelLibraryShowContinueReadingButton',
        Sort.desc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByNovelLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelTextAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTextAlign', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByNovelTextAlignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTextAlign', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByOnlyIncludePinnedSources() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlyIncludePinnedSources', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByOnlyIncludePinnedSourcesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlyIncludePinnedSources', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByPagePreloadAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pagePreloadAmount', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByPagePreloadAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pagePreloadAmount', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByPureBlackDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pureBlackDarkMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByPureBlackDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pureBlackDarkMode', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByRpcShowCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowCoverImage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByRpcShowCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowCoverImage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByRpcShowReadingWatchingProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowReadingWatchingProgress', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByRpcShowReadingWatchingProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowReadingWatchingProgress', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByRpcShowTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowTitle', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByRpcShowTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowTitle', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortBySaveAsCBZArchive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveAsCBZArchive', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortBySaveAsCBZArchiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveAsCBZArchive', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByScaleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scaleType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByScaleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scaleType', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByStartDatebackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDatebackup', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByStartDatebackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDatebackup', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByUpdateProgressAfterReading() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateProgressAfterReading', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  sortByUpdateProgressAfterReadingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateProgressAfterReading', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseLibass() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useLibass', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseLibassDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useLibass', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseMpvConfig() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMpvConfig', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseMpvConfigDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMpvConfig', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUsePageTapZones() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usePageTapZones', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUsePageTapZonesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usePageTapZones', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseYUV420P() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYUV420P', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByUseYUV420PDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYUV420P', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByVolumeBoostCap() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeBoostCap', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> sortByVolumeBoostCapDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeBoostCap', Sort.desc);
    });
  }
}

extension SettingsQuerySortThenBy
    on QueryBuilder<Settings, Settings, QSortThenBy> {
  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAndroidProxyServer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidProxyServer', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAndroidProxyServerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'androidProxyServer', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAniSkipTimeoutLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniSkipTimeoutLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAniSkipTimeoutLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aniSkipTimeoutLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimatePageTransitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animatePageTransitions', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimatePageTransitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animatePageTransitions', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAnimeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAnimeDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAnimeGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAnimeGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryLocalSource', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'animeLibraryShowContinueReadingButton',
        Sort.asc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'animeLibraryShowContinueReadingButton',
        Sort.desc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAnimeLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'animeLibraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAppFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appFontFamily', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAppFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appFontFamily', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAudioChannels() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioChannels', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAudioChannelsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioChannels', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAudioPreferredLanguages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPreferredLanguages', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAudioPreferredLanguagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPreferredLanguages', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAutoBackupLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoBackupLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoBackupLocation', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByAutoExtensionsUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoExtensionsUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByAutoExtensionsUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoExtensionsUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBackgroundColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBackgroundColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBackupFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFrequency', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBackupFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFrequency', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBtServerAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerAddress', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBtServerAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerAddress', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBtServerPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerPort', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByBtServerPortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'btServerPort', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCheckForAppUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForAppUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByCheckForAppUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForAppUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByCheckForExtensionUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForExtensionUpdates', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByCheckForExtensionUpdatesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkForExtensionUpdates', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByClearChapterCacheOnAppLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearChapterCacheOnAppLaunch', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByClearChapterCacheOnAppLaunchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clearChapterCacheOnAppLaunch', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByColorFilterBlendMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorFilterBlendMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByColorFilterBlendModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorFilterBlendMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concurrentDownloads', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByConcurrentDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'concurrentDownloads', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCropBorders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropBorders', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCropBordersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cropBorders', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCustomDns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDns', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByCustomDnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customDns', Sort.desc);
    });
  }

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

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDebandingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debandingType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDebandingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debandingType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDefaultDoubleTapToSkipLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDoubleTapToSkipLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDefaultDoubleTapToSkipLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDoubleTapToSkipLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDefaultPlayBackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlayBackSpeed', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDefaultPlayBackSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPlayBackSpeed', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDefaultReaderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReaderMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDefaultReaderModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReaderMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDefaultSkipIntroLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSkipIntroLength', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDefaultSkipIntroLengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultSkipIntroLength', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDisableSectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableSectionType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDisableSectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disableSectionType', Sort.desc);
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
  thenByDoubleTapAnimationSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doubleTapAnimationSpeed', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDoubleTapAnimationSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doubleTapAnimationSpeed', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDownloadLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDownloadLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadLocation', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDownloadOnlyOnWifi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadOnlyOnWifi', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDownloadOnlyOnWifiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadOnlyOnWifi', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByDownloadedOnlyMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedOnlyMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByDownloadedOnlyModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedOnlyMode', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableAniSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAniSkip', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableAniSkipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAniSkip', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByEnableAudioPitchCorrection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAudioPitchCorrection', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByEnableAudioPitchCorrectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAudioPitchCorrection', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableAutoSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAutoSkip', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableAutoSkipDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableAutoSkip', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByEnableCustomColorFilter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCustomColorFilter', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByEnableCustomColorFilterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableCustomColorFilter', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableDiscordRpc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDiscordRpc', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableDiscordRpcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableDiscordRpc', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableGpuNext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableGpuNext', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByEnableGpuNextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableGpuNext', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByEnableHardwareAcceleration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHardwareAcceleration', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByEnableHardwareAccelerationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enableHardwareAcceleration', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFollowSystemTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followSystemTheme', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFollowSystemThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followSystemTheme', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFullScreenPlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenPlayer', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFullScreenPlayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenPlayer', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFullScreenReader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenReader', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByFullScreenReaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullScreenReader', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByHideDiscordRpcInIncognito() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideDiscordRpcInIncognito', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByHideDiscordRpcInIncognitoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideDiscordRpcInIncognito', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByHwdecMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hwdecMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByHwdecModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hwdecMode', Sort.desc);
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
  thenByLastTrackerLibraryLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTrackerLibraryLocation', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLastTrackerLibraryLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTrackerLibraryLocation', Sort.desc);
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
  thenByLibraryFilterAnimeBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterAnimeUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterAnimeUnreadType', Sort.desc);
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
  thenByLibraryFilterNovelBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelBookMarkedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelBookMarkedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelBookMarkedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelDownloadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelDownloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelDownloadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelStartedType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelStartedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelStartedType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelUnreadType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryFilterNovelUnreadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryFilterNovelUnreadType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryLocalSource', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByMangaGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByMangaGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByMangaHomeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaHomeDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByMangaHomeDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaHomeDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByMarkEpisodeAsSeenType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markEpisodeAsSeenType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByMarkEpisodeAsSeenTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'markEpisodeAsSeenType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByMergeLibraryNavMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mergeLibraryNavMobile', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByMergeLibraryNavMobileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mergeLibraryNavMobile', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelDisplayType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelDisplayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelDisplayType', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelFontSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelGridSize', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelGridSize', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryDownloadedChapters', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryDownloadedChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryDownloadedChapters', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryLocalSource', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryLocalSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryLocalSource', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowCategoryTabs', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowCategoryTabsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowCategoryTabs', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'novelLibraryShowContinueReadingButton',
        Sort.asc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowContinueReadingButtonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        r'novelLibraryShowContinueReadingButton',
        Sort.desc,
      );
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowLanguage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowLanguage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowNumbersOfItems', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByNovelLibraryShowNumbersOfItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelLibraryShowNumbersOfItems', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelTextAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTextAlign', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByNovelTextAlignDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'novelTextAlign', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByOnlyIncludePinnedSources() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlyIncludePinnedSources', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByOnlyIncludePinnedSourcesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onlyIncludePinnedSources', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByPagePreloadAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pagePreloadAmount', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByPagePreloadAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pagePreloadAmount', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByPureBlackDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pureBlackDarkMode', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByPureBlackDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pureBlackDarkMode', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByRpcShowCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowCoverImage', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByRpcShowCoverImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowCoverImage', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByRpcShowReadingWatchingProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowReadingWatchingProgress', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByRpcShowReadingWatchingProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowReadingWatchingProgress', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByRpcShowTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowTitle', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByRpcShowTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpcShowTitle', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenBySaveAsCBZArchive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveAsCBZArchive', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenBySaveAsCBZArchiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saveAsCBZArchive', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByScaleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scaleType', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByScaleTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scaleType', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByStartDatebackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDatebackup', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByStartDatebackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDatebackup', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByUpdateProgressAfterReading() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateProgressAfterReading', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy>
  thenByUpdateProgressAfterReadingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateProgressAfterReading', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseLibass() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useLibass', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseLibassDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useLibass', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseMpvConfig() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMpvConfig', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseMpvConfigDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMpvConfig', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUsePageTapZones() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usePageTapZones', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUsePageTapZonesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'usePageTapZones', Sort.desc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseYUV420P() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYUV420P', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByUseYUV420PDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYUV420P', Sort.desc);
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

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByVolumeBoostCap() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeBoostCap', Sort.asc);
    });
  }

  QueryBuilder<Settings, Settings, QAfterSortBy> thenByVolumeBoostCapDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volumeBoostCap', Sort.desc);
    });
  }
}

extension SettingsQueryWhereDistinct
    on QueryBuilder<Settings, Settings, QDistinct> {
  QueryBuilder<Settings, Settings, QDistinct> distinctByAndroidProxyServer({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'androidProxyServer',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAniSkipTimeoutLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aniSkipTimeoutLength');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimatePageTransitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animatePageTransitions');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAnimeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeDisplayType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAnimeGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeGridSize');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryLocalSource');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryShowLanguage');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAnimeLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'animeLibraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAppFontFamily({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'appFontFamily',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAudioChannels() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioChannels');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAudioPreferredLanguages({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'audioPreferredLanguages',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByAutoBackupLocation({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'autoBackupLocation',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByAutoExtensionsUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoExtensionsUpdates');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByBackgroundColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backgroundColor');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByBackupFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backupFrequency');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByBackupListOptions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backupListOptions');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByBtServerAddress({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'btServerAddress',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByBtServerPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'btServerPort');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByCheckForAppUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkForAppUpdates');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByCheckForExtensionUpdates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkForExtensionUpdates');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByClearChapterCacheOnAppLaunch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clearChapterCacheOnAppLaunch');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByColorFilterBlendMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorFilterBlendMode');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByConcurrentDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'concurrentDownloads');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByCropBorders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cropBorders');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByCustomDns({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customDns', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDateFormat({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateFormat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDebandingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debandingType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByDefaultDoubleTapToSkipLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultDoubleTapToSkipLength');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDefaultPlayBackSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultPlayBackSpeed');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDefaultReaderMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultReaderMode');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByDefaultSkipIntroLength() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultSkipIntroLength');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDisableSectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'disableSectionType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByDoubleTapAnimationSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doubleTapAnimationSpeed');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDownloadLocation({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'downloadLocation',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDownloadOnlyOnWifi() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadOnlyOnWifi');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByDownloadedOnlyMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadedOnlyMode');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByEnableAniSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableAniSkip');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByEnableAudioPitchCorrection() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableAudioPitchCorrection');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByEnableAutoSkip() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableAutoSkip');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByEnableCustomColorFilter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableCustomColorFilter');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByEnableDiscordRpc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableDiscordRpc');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByEnableGpuNext() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableGpuNext');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByEnableHardwareAcceleration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enableHardwareAcceleration');
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

  QueryBuilder<Settings, Settings, QDistinct> distinctByFollowSystemTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followSystemTheme');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByFullScreenPlayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullScreenPlayer');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByFullScreenReader() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullScreenReader');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByHideDiscordRpcInIncognito() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hideDiscordRpcInIncognito');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByHideItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hideItems');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByHwdecMode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hwdecMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByIncognitoMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'incognitoMode');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLastTrackerLibraryLocation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'lastTrackerLibraryLocation',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterAnimeBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterAnimeBookMarkedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterAnimeDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterAnimeDownloadType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterAnimeStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterAnimeStartedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterAnimeUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterAnimeUnreadType');
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
  distinctByLibraryFilterNovelBookMarkedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterNovelBookMarkedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterNovelDownloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterNovelDownloadType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterNovelStartedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterNovelStartedType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByLibraryFilterNovelUnreadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryFilterNovelUnreadType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryLocalSource');
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

  QueryBuilder<Settings, Settings, QDistinct> distinctByMangaGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaGridSize');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByMangaHomeDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaHomeDisplayType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByMarkEpisodeAsSeenType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'markEpisodeAsSeenType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByMergeLibraryNavMobile() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mergeLibraryNavMobile');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNavigationOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'navigationOrder');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelDisplayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelDisplayType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelFontSize');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelGridSize');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryDownloadedChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryLocalSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryLocalSource');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryShowCategoryTabs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryShowContinueReadingButton() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryShowLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryShowLanguage');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByNovelLibraryShowNumbersOfItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelLibraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByNovelTextAlign() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'novelTextAlign');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByOnlyIncludePinnedSources() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onlyIncludePinnedSources');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByPagePreloadAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pagePreloadAmount');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByPureBlackDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pureBlackDarkMode');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByRelativeTimesTamps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relativeTimesTamps');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByRpcShowCoverImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rpcShowCoverImage');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByRpcShowReadingWatchingProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rpcShowReadingWatchingProgress');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByRpcShowTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rpcShowTitle');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctBySaveAsCBZArchive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saveAsCBZArchive');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByScaleType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scaleType');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByShowPagesNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showPagesNumber');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByStartDatebackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDatebackup');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByThemeIsDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeIsDark');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct>
  distinctByUpdateProgressAfterReading() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updateProgressAfterReading');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUseLibass() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useLibass');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUseMpvConfig() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useMpvConfig');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUsePageTapZones() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'usePageTapZones');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUseYUV420P() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useYUV420P');
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByUserAgent({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userAgent', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Settings, Settings, QDistinct> distinctByVolumeBoostCap() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volumeBoostCap');
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

  QueryBuilder<Settings, AlgorithmWeights?, QQueryOperations>
  algorithmWeightsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'algorithmWeights');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  androidProxyServerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'androidProxyServer');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  aniSkipTimeoutLengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aniSkipTimeoutLength');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animatePageTransitionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animatePageTransitions');
    });
  }

  QueryBuilder<Settings, DisplayType, QQueryOperations>
  animeDisplayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeDisplayType');
    });
  }

  QueryBuilder<Settings, List<Repo>?, QQueryOperations>
  animeExtensionsRepoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeExtensionsRepo');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> animeGridSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeGridSize');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryDownloadedChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryLocalSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryLocalSource');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryShowCategoryTabsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryShowContinueReadingButtonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryShowLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryShowLanguage');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  animeLibraryShowNumbersOfItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'animeLibraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> appFontFamilyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appFontFamily');
    });
  }

  QueryBuilder<Settings, AudioChannel, QQueryOperations>
  audioChannelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioChannels');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  audioPreferredLanguagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioPreferredLanguages');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  autoBackupLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoBackupLocation');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  autoExtensionsUpdatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoExtensionsUpdates');
    });
  }

  QueryBuilder<Settings, List<AutoScrollPages>?, QQueryOperations>
  autoScrollPagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoScrollPages');
    });
  }

  QueryBuilder<Settings, BackgroundColor, QQueryOperations>
  backgroundColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backgroundColor');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> backupFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupFrequency');
    });
  }

  QueryBuilder<Settings, List<int>?, QQueryOperations>
  backupListOptionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupListOptions');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> btServerAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'btServerAddress');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> btServerPortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'btServerPort');
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

  QueryBuilder<Settings, bool?, QQueryOperations> checkForAppUpdatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkForAppUpdates');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  checkForExtensionUpdatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkForExtensionUpdates');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  clearChapterCacheOnAppLaunchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clearChapterCacheOnAppLaunch');
    });
  }

  QueryBuilder<Settings, ColorFilterBlendMode, QQueryOperations>
  colorFilterBlendModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorFilterBlendMode');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> concurrentDownloadsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'concurrentDownloads');
    });
  }

  QueryBuilder<Settings, List<MCookie>?, QQueryOperations>
  cookiesListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cookiesList');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> cropBordersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cropBorders');
    });
  }

  QueryBuilder<Settings, CustomColorFilter?, QQueryOperations>
  customColorFilterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customColorFilter');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> customDnsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customDns');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> dateFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateFormat');
    });
  }

  QueryBuilder<Settings, DebandingType, QQueryOperations>
  debandingTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debandingType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  defaultDoubleTapToSkipLengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultDoubleTapToSkipLength');
    });
  }

  QueryBuilder<Settings, double?, QQueryOperations>
  defaultPlayBackSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultPlayBackSpeed');
    });
  }

  QueryBuilder<Settings, ReaderMode, QQueryOperations>
  defaultReaderModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultReaderMode');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  defaultSkipIntroLengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultSkipIntroLength');
    });
  }

  QueryBuilder<Settings, L10nLocale?, QQueryOperations>
  defaultSubtitleLangProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultSubtitleLang');
    });
  }

  QueryBuilder<Settings, SectionType, QQueryOperations>
  disableSectionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'disableSectionType');
    });
  }

  QueryBuilder<Settings, DisplayType, QQueryOperations> displayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  doubleTapAnimationSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doubleTapAnimationSpeed');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> downloadLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadLocation');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> downloadOnlyOnWifiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadOnlyOnWifi');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> downloadedOnlyModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadedOnlyMode');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> enableAniSkipProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableAniSkip');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  enableAudioPitchCorrectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableAudioPitchCorrection');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> enableAutoSkipProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableAutoSkip');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  enableCustomColorFilterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableCustomColorFilter');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> enableDiscordRpcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableDiscordRpc');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> enableGpuNextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableGpuNext');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  enableHardwareAccelerationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enableHardwareAcceleration');
    });
  }

  QueryBuilder<Settings, List<FilterScanlator>?, QQueryOperations>
  filterScanlatorListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filterScanlatorList');
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

  QueryBuilder<Settings, bool?, QQueryOperations> followSystemThemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followSystemTheme');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> fullScreenPlayerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullScreenPlayer');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> fullScreenReaderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullScreenReader');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  hideDiscordRpcInIncognitoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hideDiscordRpcInIncognito');
    });
  }

  QueryBuilder<Settings, List<String>?, QQueryOperations> hideItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hideItems');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> hwdecModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hwdecMode');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> incognitoModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'incognitoMode');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations>
  lastTrackerLibraryLocationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTrackerLibraryLocation');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  libraryDownloadedChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterAnimeBookMarkedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterAnimeBookMarkedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterAnimeDownloadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterAnimeDownloadType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterAnimeStartedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterAnimeStartedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterAnimeUnreadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterAnimeUnreadType');
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

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterNovelBookMarkedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterNovelBookMarkedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterNovelDownloadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterNovelDownloadType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterNovelStartedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterNovelStartedType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  libraryFilterNovelUnreadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryFilterNovelUnreadType');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> libraryLocalSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryLocalSource');
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

  QueryBuilder<Settings, L10nLocale?, QQueryOperations> localeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locale');
    });
  }

  QueryBuilder<Settings, List<Repo>?, QQueryOperations>
  mangaExtensionsRepoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaExtensionsRepo');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> mangaGridSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaGridSize');
    });
  }

  QueryBuilder<Settings, DisplayType, QQueryOperations>
  mangaHomeDisplayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaHomeDisplayType');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations>
  markEpisodeAsSeenTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'markEpisodeAsSeenType');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  mergeLibraryNavMobileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mergeLibraryNavMobile');
    });
  }

  QueryBuilder<Settings, List<String>?, QQueryOperations>
  navigationOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'navigationOrder');
    });
  }

  QueryBuilder<Settings, DisplayType, QQueryOperations>
  novelDisplayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelDisplayType');
    });
  }

  QueryBuilder<Settings, List<Repo>?, QQueryOperations>
  novelExtensionsRepoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelExtensionsRepo');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> novelFontSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelFontSize');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> novelGridSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelGridSize');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryDownloadedChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryDownloadedChapters');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryLocalSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryLocalSource');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryShowCategoryTabsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryShowCategoryTabs');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryShowContinueReadingButtonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryShowContinueReadingButton');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryShowLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryShowLanguage');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  novelLibraryShowNumbersOfItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelLibraryShowNumbersOfItems');
    });
  }

  QueryBuilder<Settings, NovelTextAlign, QQueryOperations>
  novelTextAlignProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'novelTextAlign');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  onlyIncludePinnedSourcesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onlyIncludePinnedSources');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> pagePreloadAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pagePreloadAmount');
    });
  }

  QueryBuilder<Settings, List<PersonalPageMode>?, QQueryOperations>
  personalPageModeListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personalPageModeList');
    });
  }

  QueryBuilder<Settings, List<PersonalReaderMode>?, QQueryOperations>
  personalReaderModeListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personalReaderModeList');
    });
  }

  QueryBuilder<Settings, PlayerSubtitleSettings?, QQueryOperations>
  playerSubtitleSettingsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerSubtitleSettings');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> pureBlackDarkModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pureBlackDarkMode');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> relativeTimesTampsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relativeTimesTamps');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> rpcShowCoverImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rpcShowCoverImage');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  rpcShowReadingWatchingProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rpcShowReadingWatchingProgress');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> rpcShowTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rpcShowTitle');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> saveAsCBZArchiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saveAsCBZArchive');
    });
  }

  QueryBuilder<Settings, ScaleType, QQueryOperations> scaleTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scaleType');
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
  sortLibraryAnimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortLibraryAnime');
    });
  }

  QueryBuilder<Settings, SortLibraryManga?, QQueryOperations>
  sortLibraryMangaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortLibraryManga');
    });
  }

  QueryBuilder<Settings, SortLibraryManga?, QQueryOperations>
  sortLibraryNovelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortLibraryNovel');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> startDatebackupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDatebackup');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> themeIsDarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeIsDark');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations>
  updateProgressAfterReadingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updateProgressAfterReading');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> useLibassProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useLibass');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> useMpvConfigProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useMpvConfig');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> usePageTapZonesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'usePageTapZones');
    });
  }

  QueryBuilder<Settings, bool?, QQueryOperations> useYUV420PProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useYUV420P');
    });
  }

  QueryBuilder<Settings, String?, QQueryOperations> userAgentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userAgent');
    });
  }

  QueryBuilder<Settings, int?, QQueryOperations> volumeBoostCapProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volumeBoostCap');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MCookieSchema = Schema(
  name: r'MCookie',
  id: -1854909335245943751,
  properties: {
    r'cookie': PropertySchema(id: 0, name: r'cookie', type: IsarType.string),
    r'host': PropertySchema(id: 1, name: r'host', type: IsarType.string),
  },

  estimateSize: _mCookieEstimateSize,
  serialize: _mCookieSerialize,
  deserialize: _mCookieDeserialize,
  deserializeProp: _mCookieDeserializeProp,
);

int _mCookieEstimateSize(
  MCookie object,
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
    final value = object.host;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _mCookieSerialize(
  MCookie object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cookie);
  writer.writeString(offsets[1], object.host);
}

MCookie _mCookieDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MCookie(
    cookie: reader.readStringOrNull(offsets[0]),
    host: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _mCookieDeserializeProp<P>(
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

extension MCookieQueryFilter
    on QueryBuilder<MCookie, MCookie, QFilterCondition> {
  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cookie'),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cookie'),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cookie',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'cookie',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'cookie',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cookie', value: ''),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> cookieIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'cookie', value: ''),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'host'),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'host'),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'host',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'host',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'host',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'host', value: ''),
      );
    });
  }

  QueryBuilder<MCookie, MCookie, QAfterFilterCondition> hostIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'host', value: ''),
      );
    });
  }
}

extension MCookieQueryObject
    on QueryBuilder<MCookie, MCookie, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SortLibraryMangaSchema = Schema(
  name: r'SortLibraryManga',
  id: -8485569296691672246,
  properties: {
    r'index': PropertySchema(id: 0, name: r'index', type: IsarType.long),
    r'reverse': PropertySchema(id: 1, name: r'reverse', type: IsarType.bool),
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
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'index'),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  indexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'index'),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  indexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'index', value: value),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  indexGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  indexLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'index',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  reverseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'reverse'),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  reverseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'reverse'),
      );
    });
  }

  QueryBuilder<SortLibraryManga, SortLibraryManga, QAfterFilterCondition>
  reverseEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reverse', value: value),
      );
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
    r'index': PropertySchema(id: 0, name: r'index', type: IsarType.long),
    r'mangaId': PropertySchema(id: 1, name: r'mangaId', type: IsarType.long),
    r'reverse': PropertySchema(id: 2, name: r'reverse', type: IsarType.bool),
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
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'index'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  indexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'index'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> indexEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'index', value: value),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  indexGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> indexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> indexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'index',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> mangaIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> mangaIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  reverseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'reverse'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition>
  reverseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'reverse'),
      );
    });
  }

  QueryBuilder<SortChapter, SortChapter, QAfterFilterCondition> reverseEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reverse', value: value),
      );
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
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'type': PropertySchema(id: 1, name: r'type', type: IsarType.long),
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

extension ChapterFilterDownloadedQueryFilter
    on
        QueryBuilder<
          ChapterFilterDownloaded,
          ChapterFilterDownloaded,
          QFilterCondition
        > {
  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'type'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'type'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    QAfterFilterCondition
  >
  typeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ChapterFilterDownloadedQueryObject
    on
        QueryBuilder<
          ChapterFilterDownloaded,
          ChapterFilterDownloaded,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterFilterUnreadSchema = Schema(
  name: r'ChapterFilterUnread',
  id: 2999193805790237469,
  properties: {
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'type': PropertySchema(id: 1, name: r'type', type: IsarType.long),
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

extension ChapterFilterUnreadQueryFilter
    on
        QueryBuilder<
          ChapterFilterUnread,
          ChapterFilterUnread,
          QFilterCondition
        > {
  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'type'),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'type'),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  typeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  typeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterFilterUnread, ChapterFilterUnread, QAfterFilterCondition>
  typeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ChapterFilterUnreadQueryObject
    on
        QueryBuilder<
          ChapterFilterUnread,
          ChapterFilterUnread,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ChapterFilterBookmarkedSchema = Schema(
  name: r'ChapterFilterBookmarked',
  id: -4183165879060895626,
  properties: {
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'type': PropertySchema(id: 1, name: r'type', type: IsarType.long),
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

extension ChapterFilterBookmarkedQueryFilter
    on
        QueryBuilder<
          ChapterFilterBookmarked,
          ChapterFilterBookmarked,
          QFilterCondition
        > {
  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'type'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'type'),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    QAfterFilterCondition
  >
  typeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ChapterFilterBookmarkedQueryObject
    on
        QueryBuilder<
          ChapterFilterBookmarked,
          ChapterFilterBookmarked,
          QFilterCondition
        > {}

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
    r'chapterUrl': PropertySchema(
      id: 1,
      name: r'chapterUrl',
      type: IsarType.string,
    ),
    r'headers': PropertySchema(
      id: 2,
      name: r'headers',
      type: IsarType.stringList,
    ),
    r'urls': PropertySchema(id: 3, name: r'urls', type: IsarType.stringList),
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
    final value = object.chapterUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.headers;
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
  writer.writeString(offsets[1], object.chapterUrl);
  writer.writeStringList(offsets[2], object.headers);
  writer.writeStringList(offsets[3], object.urls);
}

ChapterPageurls _chapterPageurlsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChapterPageurls(
    chapterId: reader.readLongOrNull(offsets[0]),
    urls: reader.readStringList(offsets[3]),
  );
  object.chapterUrl = reader.readStringOrNull(offsets[1]);
  object.headers = reader.readStringList(offsets[2]);
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
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringList(offset)) as P;
    case 3:
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
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterId'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterId'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chapterId', value: value),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chapterId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterUrl'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterUrl'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chapterUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'chapterUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'chapterUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chapterUrl', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  chapterUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'chapterUrl', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'headers'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'headers'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementGreaterThan(
    String value, {
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

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementLessThan(
    String value, {
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

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementBetween(
    String lower,
    String upper, {
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

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'headers', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'headers', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'headers', length, true, length, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'headers', 0, true, 0, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'headers', 0, false, 999999, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'headers', 0, true, length, include);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'headers', length, include, 999999, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  headersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'headers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'urls'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'urls'),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'urls',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'urls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'urls',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'urls', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'urls', value: ''),
      );
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'urls', length, true, length, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'urls', 0, true, 0, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'urls', 0, false, 999999, true);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'urls', 0, true, length, include);
    });
  }

  QueryBuilder<ChapterPageurls, ChapterPageurls, QAfterFilterCondition>
  urlsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'urls', length, include, 999999, true);
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
    r'index': PropertySchema(id: 1, name: r'index', type: IsarType.long),
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
  final object = ChapterPageIndex(
    chapterId: reader.readLongOrNull(offsets[0]),
    index: reader.readLongOrNull(offsets[1]),
  );
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
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'chapterId'),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  chapterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'chapterId'),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  chapterIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chapterId', value: value),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  chapterIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  chapterIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chapterId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  indexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'index'),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  indexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'index'),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  indexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'index', value: value),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  indexGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ChapterPageIndex, ChapterPageIndex, QAfterFilterCondition>
  indexLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'index',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'index',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ChapterPageIndexQueryObject
    on QueryBuilder<ChapterPageIndex, ChapterPageIndex, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PersonalReaderModeSchema = Schema(
  name: r'PersonalReaderMode',
  id: -1072936262658804338,
  properties: {
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'readerMode': PropertySchema(
      id: 1,
      name: r'readerMode',
      type: IsarType.byte,
      enumMap: _PersonalReaderModereaderModeEnumValueMap,
    ),
  },

  estimateSize: _personalReaderModeEstimateSize,
  serialize: _personalReaderModeSerialize,
  deserialize: _personalReaderModeDeserialize,
  deserializeProp: _personalReaderModeDeserializeProp,
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
    mangaId: reader.readLongOrNull(offsets[0]),
    readerMode:
        _PersonalReaderModereaderModeValueEnumMap[reader.readByteOrNull(
          offsets[1],
        )] ??
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
      return (_PersonalReaderModereaderModeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              ReaderMode.vertical)
          as P;
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
  'horizontalContinuous': 5,
};
const _PersonalReaderModereaderModeValueEnumMap = {
  0: ReaderMode.vertical,
  1: ReaderMode.ltr,
  2: ReaderMode.rtl,
  3: ReaderMode.verticalContinuous,
  4: ReaderMode.webtoon,
  5: ReaderMode.horizontalContinuous,
};

extension PersonalReaderModeQueryFilter
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QFilterCondition> {
  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  readerModeEqualTo(ReaderMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'readerMode', value: value),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  readerModeGreaterThan(ReaderMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'readerMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalReaderMode, PersonalReaderMode, QAfterFilterCondition>
  readerModeLessThan(ReaderMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'readerMode',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'readerMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PersonalReaderModeQueryObject
    on QueryBuilder<PersonalReaderMode, PersonalReaderMode, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AutoScrollPagesSchema = Schema(
  name: r'AutoScrollPages',
  id: -2184999012300377466,
  properties: {
    r'autoScroll': PropertySchema(
      id: 0,
      name: r'autoScroll',
      type: IsarType.bool,
    ),
    r'mangaId': PropertySchema(id: 1, name: r'mangaId', type: IsarType.long),
    r'pageOffset': PropertySchema(
      id: 2,
      name: r'pageOffset',
      type: IsarType.double,
    ),
  },

  estimateSize: _autoScrollPagesEstimateSize,
  serialize: _autoScrollPagesSerialize,
  deserialize: _autoScrollPagesDeserialize,
  deserializeProp: _autoScrollPagesDeserializeProp,
);

int _autoScrollPagesEstimateSize(
  AutoScrollPages object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _autoScrollPagesSerialize(
  AutoScrollPages object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoScroll);
  writer.writeLong(offsets[1], object.mangaId);
  writer.writeDouble(offsets[2], object.pageOffset);
}

AutoScrollPages _autoScrollPagesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AutoScrollPages(
    autoScroll: reader.readBoolOrNull(offsets[0]),
    mangaId: reader.readLongOrNull(offsets[1]),
    pageOffset: reader.readDoubleOrNull(offsets[2]),
  );
  return object;
}

P _autoScrollPagesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AutoScrollPagesQueryFilter
    on QueryBuilder<AutoScrollPages, AutoScrollPages, QFilterCondition> {
  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  autoScrollIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'autoScroll'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  autoScrollIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'autoScroll'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  autoScrollEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'autoScroll', value: value),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pageOffset'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pageOffset'),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pageOffset',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pageOffset',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pageOffset',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AutoScrollPages, AutoScrollPages, QAfterFilterCondition>
  pageOffsetBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pageOffset',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension AutoScrollPagesQueryObject
    on QueryBuilder<AutoScrollPages, AutoScrollPages, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RepoSchema = Schema(
  name: r'Repo',
  id: 8520529424681796092,
  properties: {
    r'hashCode': PropertySchema(id: 0, name: r'hashCode', type: IsarType.long),
    r'hidden': PropertySchema(id: 1, name: r'hidden', type: IsarType.bool),
    r'jsonUrl': PropertySchema(id: 2, name: r'jsonUrl', type: IsarType.string),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
    r'website': PropertySchema(id: 4, name: r'website', type: IsarType.string),
  },

  estimateSize: _repoEstimateSize,
  serialize: _repoSerialize,
  deserialize: _repoDeserialize,
  deserializeProp: _repoDeserializeProp,
);

int _repoEstimateSize(
  Repo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.jsonUrl;
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
    final value = object.website;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _repoSerialize(
  Repo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.hashCode);
  writer.writeBool(offsets[1], object.hidden);
  writer.writeString(offsets[2], object.jsonUrl);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.website);
}

Repo _repoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Repo(
    hidden: reader.readBoolOrNull(offsets[1]),
    jsonUrl: reader.readStringOrNull(offsets[2]),
    name: reader.readStringOrNull(offsets[3]),
    website: reader.readStringOrNull(offsets[4]),
  );
  return object;
}

P _repoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension RepoQueryFilter on QueryBuilder<Repo, Repo, QFilterCondition> {
  QueryBuilder<Repo, Repo, QAfterFilterCondition> hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hashCode', value: value),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hashCode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hashCode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hashCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hiddenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hidden'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hiddenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hidden'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> hiddenEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hidden', value: value),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'jsonUrl'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'jsonUrl'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'jsonUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'jsonUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'jsonUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'jsonUrl', value: ''),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> jsonUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'jsonUrl', value: ''),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'name'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameContains(
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

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'website'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'website'),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'website',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'website',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'website',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'website', value: ''),
      );
    });
  }

  QueryBuilder<Repo, Repo, QAfterFilterCondition> websiteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'website', value: ''),
      );
    });
  }
}

extension RepoQueryObject on QueryBuilder<Repo, Repo, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PersonalPageModeSchema = Schema(
  name: r'PersonalPageMode',
  id: -7061860019786197792,
  properties: {
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'pageMode': PropertySchema(
      id: 1,
      name: r'pageMode',
      type: IsarType.byte,
      enumMap: _PersonalPageModepageModeEnumValueMap,
    ),
  },

  estimateSize: _personalPageModeEstimateSize,
  serialize: _personalPageModeSerialize,
  deserialize: _personalPageModeDeserialize,
  deserializeProp: _personalPageModeDeserializeProp,
);

int _personalPageModeEstimateSize(
  PersonalPageMode object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _personalPageModeSerialize(
  PersonalPageMode object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeByte(offsets[1], object.pageMode.index);
}

PersonalPageMode _personalPageModeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PersonalPageMode(
    mangaId: reader.readLongOrNull(offsets[0]),
    pageMode:
        _PersonalPageModepageModeValueEnumMap[reader.readByteOrNull(
          offsets[1],
        )] ??
        PageMode.onePage,
  );
  return object;
}

P _personalPageModeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (_PersonalPageModepageModeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              PageMode.onePage)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PersonalPageModepageModeEnumValueMap = {'onePage': 0, 'doublePage': 1};
const _PersonalPageModepageModeValueEnumMap = {
  0: PageMode.onePage,
  1: PageMode.doublePage,
};

extension PersonalPageModeQueryFilter
    on QueryBuilder<PersonalPageMode, PersonalPageMode, QFilterCondition> {
  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  pageModeEqualTo(PageMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pageMode', value: value),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  pageModeGreaterThan(PageMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pageMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  pageModeLessThan(PageMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pageMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PersonalPageMode, PersonalPageMode, QAfterFilterCondition>
  pageModeBetween(
    PageMode lower,
    PageMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pageMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PersonalPageModeQueryObject
    on QueryBuilder<PersonalPageMode, PersonalPageMode, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const FilterScanlatorSchema = Schema(
  name: r'FilterScanlator',
  id: 3007689993900015493,
  properties: {
    r'mangaId': PropertySchema(id: 0, name: r'mangaId', type: IsarType.long),
    r'scanlators': PropertySchema(
      id: 1,
      name: r'scanlators',
      type: IsarType.stringList,
    ),
  },

  estimateSize: _filterScanlatorEstimateSize,
  serialize: _filterScanlatorSerialize,
  deserialize: _filterScanlatorDeserialize,
  deserializeProp: _filterScanlatorDeserializeProp,
);

int _filterScanlatorEstimateSize(
  FilterScanlator object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.scanlators;
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

void _filterScanlatorSerialize(
  FilterScanlator object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.mangaId);
  writer.writeStringList(offsets[1], object.scanlators);
}

FilterScanlator _filterScanlatorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FilterScanlator(
    mangaId: reader.readLongOrNull(offsets[0]),
    scanlators: reader.readStringList(offsets[1]),
  );
  return object;
}

P _filterScanlatorDeserializeProp<P>(
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

extension FilterScanlatorQueryFilter
    on QueryBuilder<FilterScanlator, FilterScanlator, QFilterCondition> {
  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mangaId'),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  mangaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'scanlators'),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'scanlators'),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scanlators',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'scanlators',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'scanlators',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scanlators', value: ''),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'scanlators', value: ''),
      );
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scanlators', length, true, length, true);
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scanlators', 0, true, 0, true);
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scanlators', 0, false, 999999, true);
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scanlators', 0, true, length, include);
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scanlators', length, include, 999999, true);
    });
  }

  QueryBuilder<FilterScanlator, FilterScanlator, QAfterFilterCondition>
  scanlatorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scanlators',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension FilterScanlatorQueryObject
    on QueryBuilder<FilterScanlator, FilterScanlator, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const L10nLocaleSchema = Schema(
  name: r'L10nLocale',
  id: -880412678425487799,
  properties: {
    r'countryCode': PropertySchema(
      id: 0,
      name: r'countryCode',
      type: IsarType.string,
    ),
    r'languageCode': PropertySchema(
      id: 1,
      name: r'languageCode',
      type: IsarType.string,
    ),
  },

  estimateSize: _l10nLocaleEstimateSize,
  serialize: _l10nLocaleSerialize,
  deserialize: _l10nLocaleDeserialize,
  deserializeProp: _l10nLocaleDeserializeProp,
);

int _l10nLocaleEstimateSize(
  L10nLocale object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.countryCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.languageCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _l10nLocaleSerialize(
  L10nLocale object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.countryCode);
  writer.writeString(offsets[1], object.languageCode);
}

L10nLocale _l10nLocaleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = L10nLocale(
    countryCode: reader.readStringOrNull(offsets[0]),
    languageCode: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _l10nLocaleDeserializeProp<P>(
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

extension L10nLocaleQueryFilter
    on QueryBuilder<L10nLocale, L10nLocale, QFilterCondition> {
  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'countryCode'),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'countryCode'),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'countryCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'countryCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'countryCode', value: ''),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  countryCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'countryCode', value: ''),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'languageCode'),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'languageCode'),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'languageCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'languageCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'languageCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'languageCode', value: ''),
      );
    });
  }

  QueryBuilder<L10nLocale, L10nLocale, QAfterFilterCondition>
  languageCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'languageCode', value: ''),
      );
    });
  }
}

extension L10nLocaleQueryObject
    on QueryBuilder<L10nLocale, L10nLocale, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CustomColorFilterSchema = Schema(
  name: r'CustomColorFilter',
  id: -2363592387931876829,
  properties: {
    r'a': PropertySchema(id: 0, name: r'a', type: IsarType.long),
    r'b': PropertySchema(id: 1, name: r'b', type: IsarType.long),
    r'g': PropertySchema(id: 2, name: r'g', type: IsarType.long),
    r'r': PropertySchema(id: 3, name: r'r', type: IsarType.long),
  },

  estimateSize: _customColorFilterEstimateSize,
  serialize: _customColorFilterSerialize,
  deserialize: _customColorFilterDeserialize,
  deserializeProp: _customColorFilterDeserializeProp,
);

int _customColorFilterEstimateSize(
  CustomColorFilter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _customColorFilterSerialize(
  CustomColorFilter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.a);
  writer.writeLong(offsets[1], object.b);
  writer.writeLong(offsets[2], object.g);
  writer.writeLong(offsets[3], object.r);
}

CustomColorFilter _customColorFilterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomColorFilter(
    a: reader.readLongOrNull(offsets[0]),
    b: reader.readLongOrNull(offsets[1]),
    g: reader.readLongOrNull(offsets[2]),
    r: reader.readLongOrNull(offsets[3]),
  );
  return object;
}

P _customColorFilterDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CustomColorFilterQueryFilter
    on QueryBuilder<CustomColorFilter, CustomColorFilter, QFilterCondition> {
  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  aIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'a'),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  aIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'a'),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  aEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'a', value: value),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  aGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'a',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  aLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'a',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  aBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'a',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  bIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'b'),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  bIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'b'),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  bEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'b', value: value),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  bGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'b',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  bLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'b',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  bBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'b',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  gIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'g'),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  gIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'g'),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  gEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'g', value: value),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  gGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'g',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  gLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'g',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  gBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'g',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  rIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'r'),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  rIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'r'),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  rEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'r', value: value),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  rGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'r',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  rLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'r',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CustomColorFilter, CustomColorFilter, QAfterFilterCondition>
  rBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'r',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CustomColorFilterQueryObject
    on QueryBuilder<CustomColorFilter, CustomColorFilter, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PlayerSubtitleSettingsSchema = Schema(
  name: r'PlayerSubtitleSettings',
  id: 3515720443923320399,
  properties: {
    r'backgroundColorA': PropertySchema(
      id: 0,
      name: r'backgroundColorA',
      type: IsarType.long,
    ),
    r'backgroundColorB': PropertySchema(
      id: 1,
      name: r'backgroundColorB',
      type: IsarType.long,
    ),
    r'backgroundColorG': PropertySchema(
      id: 2,
      name: r'backgroundColorG',
      type: IsarType.long,
    ),
    r'backgroundColorR': PropertySchema(
      id: 3,
      name: r'backgroundColorR',
      type: IsarType.long,
    ),
    r'borderColorA': PropertySchema(
      id: 4,
      name: r'borderColorA',
      type: IsarType.long,
    ),
    r'borderColorB': PropertySchema(
      id: 5,
      name: r'borderColorB',
      type: IsarType.long,
    ),
    r'borderColorG': PropertySchema(
      id: 6,
      name: r'borderColorG',
      type: IsarType.long,
    ),
    r'borderColorR': PropertySchema(
      id: 7,
      name: r'borderColorR',
      type: IsarType.long,
    ),
    r'fontSize': PropertySchema(id: 8, name: r'fontSize', type: IsarType.long),
    r'textColorA': PropertySchema(
      id: 9,
      name: r'textColorA',
      type: IsarType.long,
    ),
    r'textColorB': PropertySchema(
      id: 10,
      name: r'textColorB',
      type: IsarType.long,
    ),
    r'textColorG': PropertySchema(
      id: 11,
      name: r'textColorG',
      type: IsarType.long,
    ),
    r'textColorR': PropertySchema(
      id: 12,
      name: r'textColorR',
      type: IsarType.long,
    ),
    r'useBold': PropertySchema(id: 13, name: r'useBold', type: IsarType.bool),
    r'useItalic': PropertySchema(
      id: 14,
      name: r'useItalic',
      type: IsarType.bool,
    ),
  },

  estimateSize: _playerSubtitleSettingsEstimateSize,
  serialize: _playerSubtitleSettingsSerialize,
  deserialize: _playerSubtitleSettingsDeserialize,
  deserializeProp: _playerSubtitleSettingsDeserializeProp,
);

int _playerSubtitleSettingsEstimateSize(
  PlayerSubtitleSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _playerSubtitleSettingsSerialize(
  PlayerSubtitleSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.backgroundColorA);
  writer.writeLong(offsets[1], object.backgroundColorB);
  writer.writeLong(offsets[2], object.backgroundColorG);
  writer.writeLong(offsets[3], object.backgroundColorR);
  writer.writeLong(offsets[4], object.borderColorA);
  writer.writeLong(offsets[5], object.borderColorB);
  writer.writeLong(offsets[6], object.borderColorG);
  writer.writeLong(offsets[7], object.borderColorR);
  writer.writeLong(offsets[8], object.fontSize);
  writer.writeLong(offsets[9], object.textColorA);
  writer.writeLong(offsets[10], object.textColorB);
  writer.writeLong(offsets[11], object.textColorG);
  writer.writeLong(offsets[12], object.textColorR);
  writer.writeBool(offsets[13], object.useBold);
  writer.writeBool(offsets[14], object.useItalic);
}

PlayerSubtitleSettings _playerSubtitleSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlayerSubtitleSettings(
    backgroundColorA: reader.readLongOrNull(offsets[0]),
    backgroundColorB: reader.readLongOrNull(offsets[1]),
    backgroundColorG: reader.readLongOrNull(offsets[2]),
    backgroundColorR: reader.readLongOrNull(offsets[3]),
    borderColorA: reader.readLongOrNull(offsets[4]),
    borderColorB: reader.readLongOrNull(offsets[5]),
    borderColorG: reader.readLongOrNull(offsets[6]),
    borderColorR: reader.readLongOrNull(offsets[7]),
    fontSize: reader.readLongOrNull(offsets[8]),
    textColorA: reader.readLongOrNull(offsets[9]),
    textColorB: reader.readLongOrNull(offsets[10]),
    textColorG: reader.readLongOrNull(offsets[11]),
    textColorR: reader.readLongOrNull(offsets[12]),
    useBold: reader.readBoolOrNull(offsets[13]),
    useItalic: reader.readBoolOrNull(offsets[14]),
  );
  return object;
}

P _playerSubtitleSettingsDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readBoolOrNull(offset)) as P;
    case 14:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PlayerSubtitleSettingsQueryFilter
    on
        QueryBuilder<
          PlayerSubtitleSettings,
          PlayerSubtitleSettings,
          QFilterCondition
        > {
  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backgroundColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backgroundColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorAEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backgroundColorA', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorAGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backgroundColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorALessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backgroundColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorABetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backgroundColorA',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backgroundColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backgroundColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backgroundColorB', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backgroundColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backgroundColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorBBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backgroundColorB',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backgroundColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backgroundColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backgroundColorG', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backgroundColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backgroundColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backgroundColorG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorRIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backgroundColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorRIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backgroundColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorREqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backgroundColorR', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorRGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backgroundColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorRLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backgroundColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  backgroundColorRBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backgroundColorR',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'borderColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'borderColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorAEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderColorA', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorAGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorALessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorABetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderColorA',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'borderColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'borderColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderColorB', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorBBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderColorB',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'borderColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'borderColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderColorG', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderColorG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorRIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'borderColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorRIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'borderColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorREqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderColorR', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorRGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorRLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  borderColorRBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderColorR',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fontSize'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fontSize'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fontSize', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fontSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fontSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  fontSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fontSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'textColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'textColorA'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorAEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textColorA', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorAGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorALessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textColorA',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorABetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textColorA',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'textColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'textColorB'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textColorB', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textColorB',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorBBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textColorB',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'textColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'textColorG'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textColorG', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textColorG',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorGBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textColorG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorRIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'textColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorRIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'textColorR'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorREqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textColorR', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorRGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorRLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textColorR',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  textColorRBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textColorR',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useBoldIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'useBold'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useBoldIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'useBold'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useBoldEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'useBold', value: value),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useItalicIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'useItalic'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useItalicIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'useItalic'),
      );
    });
  }

  QueryBuilder<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    QAfterFilterCondition
  >
  useItalicEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'useItalic', value: value),
      );
    });
  }
}

extension PlayerSubtitleSettingsQueryObject
    on
        QueryBuilder<
          PlayerSubtitleSettings,
          PlayerSubtitleSettings,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AlgorithmWeightsSchema = Schema(
  name: r'AlgorithmWeights',
  id: -2865436974642812672,
  properties: {
    r'genre': PropertySchema(id: 0, name: r'genre', type: IsarType.long),
    r'setting': PropertySchema(id: 1, name: r'setting', type: IsarType.long),
    r'synopsis': PropertySchema(id: 2, name: r'synopsis', type: IsarType.long),
    r'theme': PropertySchema(id: 3, name: r'theme', type: IsarType.long),
  },

  estimateSize: _algorithmWeightsEstimateSize,
  serialize: _algorithmWeightsSerialize,
  deserialize: _algorithmWeightsDeserialize,
  deserializeProp: _algorithmWeightsDeserializeProp,
);

int _algorithmWeightsEstimateSize(
  AlgorithmWeights object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _algorithmWeightsSerialize(
  AlgorithmWeights object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.genre);
  writer.writeLong(offsets[1], object.setting);
  writer.writeLong(offsets[2], object.synopsis);
  writer.writeLong(offsets[3], object.theme);
}

AlgorithmWeights _algorithmWeightsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AlgorithmWeights(
    genre: reader.readLongOrNull(offsets[0]),
    setting: reader.readLongOrNull(offsets[1]),
    synopsis: reader.readLongOrNull(offsets[2]),
    theme: reader.readLongOrNull(offsets[3]),
  );
  return object;
}

P _algorithmWeightsDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AlgorithmWeightsQueryFilter
    on QueryBuilder<AlgorithmWeights, AlgorithmWeights, QFilterCondition> {
  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'genre'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'genre'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'genre', value: value),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'genre',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'genre',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  genreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'genre',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'setting'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'setting'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'setting', value: value),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'setting',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'setting',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  settingBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'setting',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'synopsis'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'synopsis'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'synopsis', value: value),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'synopsis',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'synopsis',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  synopsisBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'synopsis',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'theme'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'theme'),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'theme', value: value),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'theme',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'theme',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AlgorithmWeights, AlgorithmWeights, QAfterFilterCondition>
  themeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'theme',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AlgorithmWeightsQueryObject
    on QueryBuilder<AlgorithmWeights, AlgorithmWeights, QFilterCondition> {}
