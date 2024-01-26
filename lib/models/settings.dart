import 'package:isar/isar.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/constant.dart';
part 'settings.g.dart';

@collection
@Name("Settings")
class Settings {
  Id? id;

  @enumerated
  late DisplayType displayType;

  int? libraryFilterMangasDownloadType;

  int? libraryFilterMangasUnreadType;

  int? libraryFilterMangasStartedType;

  int? libraryFilterMangasBookMarkedType;

  bool? libraryShowCategoryTabs;

  bool? libraryDownloadedChapters;

  bool? libraryShowLanguage;

  bool? libraryShowNumbersOfItems;

  bool? libraryShowContinueReadingButton;

  bool? libraryLocalSource;

  SortLibraryManga? sortLibraryManga;

  List<SortChapter>? sortChapterList;

  List<ChapterFilterDownloaded>? chapterFilterDownloadedList;

  List<ChapterFilterUnread>? chapterFilterUnreadList;

  List<ChapterFilterBookmarked>? chapterFilterBookmarkedList;

  double? flexColorSchemeBlendLevel;

  String? dateFormat;

  int? relativeTimesTamps;

  int? flexSchemeColorIndex;

  bool? themeIsDark;

  bool? incognitoMode;

  List<ChapterPageurls>? chapterPageUrlsList;

  bool? showPagesNumber;

  List<ChapterPageIndex>? chapterPageIndexList;

  String? userAgent;

  List<Cookie>? cookiesList;

  @enumerated
  late ReaderMode defaultReaderMode;

  List<PersonalReaderMode>? personalReaderModeList;

  bool? animatePageTransitions;

  int? doubleTapAnimationSpeed;

  bool? showNSFW;

  bool? onlyIncludePinnedSources;

  bool? pureBlackDarkMode;

  bool? downloadOnlyOnWifi;

  bool? saveAsCBZArchive;

  String? downloadLocation;

  List<FilterScanlator>? filterScanlatorList;

  final sources = IsarLinks<Source>();

  bool? autoExtensionsUpdates;

  bool? cropBorders;

  L10nLocale? locale;

  @enumerated
  late DisplayType animeDisplayType;

  int? libraryFilterAnimeDownloadType;

  int? libraryFilterAnimeUnreadType;

  int? libraryFilterAnimeStartedType;

  int? libraryFilterAnimeBookMarkedType;

  bool? animeLibraryShowCategoryTabs;

  bool? animeLibraryDownloadedChapters;

  bool? animeLibraryShowLanguage;

  bool? animeLibraryShowNumbersOfItems;

  bool? animeLibraryShowContinueReadingButton;

  bool? animeLibraryLocalSource;

  late SortLibraryManga? sortLibraryAnime;

  int? pagePreloadAmount;

  bool? checkForExtensionUpdates;

  @enumerated
  late ScaleType scaleType;

  @enumerated
  late BackgroundColor backgroundColor;

  List<PersonalPageMode>? personalPageModeList;

  int? startDatebackup;

  int? backupFrequency;

  List<int>? backupFrequencyOptions;

  String? autoBackupLocation;

  bool? usePageTapZones;

  List<AutoScrollPages>? autoScrollPages;

  int? markEpisodeAsSeenType;

  int? defaultSkipIntroLength;

  int? defaultDoubleTapToSkipLength;

  double? defaultPlayBackSpeed;

  bool? updateProgressAfterReading;

  bool? enableAniSkip;

  bool? enableAutoSkip;

  int? aniSkipTimeoutLength;

  String? btServerAddress;

  int? btServerPort;

  Settings(
      {this.id = 227,
      this.displayType = DisplayType.compactGrid,
      this.libraryFilterMangasDownloadType = 0,
      this.libraryFilterMangasUnreadType = 0,
      this.libraryFilterMangasStartedType = 0,
      this.libraryFilterMangasBookMarkedType = 0,
      this.libraryShowCategoryTabs = false,
      this.libraryDownloadedChapters = false,
      this.libraryShowLanguage = false,
      this.libraryShowNumbersOfItems = false,
      this.libraryShowContinueReadingButton = false,
      this.sortLibraryManga,
      this.sortChapterList,
      this.chapterFilterDownloadedList,
      this.flexColorSchemeBlendLevel = 10.0,
      this.dateFormat = "M/d/y",
      this.relativeTimesTamps = 2,
      this.flexSchemeColorIndex = 2,
      this.themeIsDark = false,
      this.incognitoMode = false,
      this.chapterPageUrlsList,
      this.showPagesNumber = true,
      this.chapterPageIndexList,
      this.userAgent = defaultUserAgent,
      this.cookiesList,
      this.defaultReaderMode = ReaderMode.vertical,
      this.personalReaderModeList,
      this.animatePageTransitions = true,
      this.doubleTapAnimationSpeed = 1,
      this.showNSFW = true,
      this.onlyIncludePinnedSources = false,
      this.pureBlackDarkMode = false,
      this.downloadOnlyOnWifi = false,
      this.saveAsCBZArchive = false,
      this.downloadLocation = "",
      this.cropBorders = false,
      this.libraryLocalSource,
      this.autoExtensionsUpdates = false,
      this.animeDisplayType = DisplayType.compactGrid,
      this.libraryFilterAnimeDownloadType = 0,
      this.libraryFilterAnimeUnreadType = 0,
      this.libraryFilterAnimeStartedType = 0,
      this.libraryFilterAnimeBookMarkedType = 0,
      this.animeLibraryShowCategoryTabs = false,
      this.animeLibraryDownloadedChapters = false,
      this.animeLibraryShowLanguage = false,
      this.animeLibraryShowNumbersOfItems = false,
      this.animeLibraryShowContinueReadingButton = false,
      this.animeLibraryLocalSource,
      this.sortLibraryAnime,
      this.pagePreloadAmount = 6,
      this.scaleType = ScaleType.fitScreen,
      this.checkForExtensionUpdates = true,
      this.backgroundColor = BackgroundColor.black,
      this.personalPageModeList,
      this.backupFrequency,
      this.backupFrequencyOptions,
      this.autoBackupLocation,
      this.startDatebackup,
      this.usePageTapZones = true,
      this.autoScrollPages,
      this.markEpisodeAsSeenType = 85,
      this.defaultSkipIntroLength = 85,
      this.defaultDoubleTapToSkipLength = 10,
      this.defaultPlayBackSpeed = 1.0,
      this.updateProgressAfterReading = true,
      this.enableAniSkip,
      this.enableAutoSkip,
      this.aniSkipTimeoutLength,
      this.btServerAddress = "127.0.0.1",
      this.btServerPort});

  Settings.fromJson(Map<String, dynamic> json) {
    animatePageTransitions = json['animatePageTransitions'];
    animeDisplayType = DisplayType.values[json['animeDisplayType']];
    animeLibraryDownloadedChapters = json['animeLibraryDownloadedChapters'];
    animeLibraryLocalSource = json['animeLibraryLocalSource'];
    animeLibraryShowCategoryTabs = json['animeLibraryShowCategoryTabs'];
    animeLibraryShowContinueReadingButton =
        json['animeLibraryShowContinueReadingButton'];
    animeLibraryShowLanguage = json['animeLibraryShowLanguage'];
    animeLibraryShowNumbersOfItems = json['animeLibraryShowNumbersOfItems'];
    autoExtensionsUpdates = json['autoExtensionsUpdates'];
    backgroundColor = BackgroundColor.values[json['backgroundColor']];
    if (json['chapterFilterBookmarkedList'] != null) {
      chapterFilterBookmarkedList =
          (json['chapterFilterBookmarkedList'] as List)
              .map((e) => ChapterFilterBookmarked.fromJson(e))
              .toList();
    }
    if (json['chapterFilterDownloadedList'] != null) {
      chapterFilterDownloadedList =
          (json['chapterFilterDownloadedList'] as List)
              .map((e) => ChapterFilterDownloaded.fromJson(e))
              .toList();
    }
    if (json['chapterFilterUnreadList'] != null) {
      chapterFilterUnreadList = (json['chapterFilterUnreadList'] as List)
          .map((e) => ChapterFilterUnread.fromJson(e))
          .toList();
    }
    if (json['chapterPageIndexList'] != null) {
      chapterPageIndexList = (json['chapterPageIndexList'] as List)
          .map((e) => ChapterPageIndex.fromJson(e))
          .toList();
    }
    if (json['chapterPageUrlsList'] != null) {
      chapterPageUrlsList = (json['chapterPageUrlsList'] as List)
          .map((e) => ChapterPageurls.fromJson(e))
          .toList();
    }
    checkForExtensionUpdates = json['checkForExtensionUpdates'];
    if (json['cookiesList'] != null) {
      cookiesList =
          (json['cookiesList'] as List).map((e) => Cookie.fromJson(e)).toList();
    }
    cropBorders = json['cropBorders'];
    dateFormat = json['dateFormat'];
    defaultReaderMode = ReaderMode.values[json['defaultReaderMode']];
    displayType = DisplayType.values[json['displayType']];
    doubleTapAnimationSpeed = json['doubleTapAnimationSpeed'];
    downloadLocation = json['downloadLocation'];
    downloadOnlyOnWifi = json['downloadOnlyOnWifi'];
    if (json['filterScanlatorList'] != null) {
      filterScanlatorList = (json['filterScanlatorList'] as List)
          .map((e) => FilterScanlator.fromJson(e))
          .toList();
    }
    flexColorSchemeBlendLevel = json['flexColorSchemeBlendLevel'];
    flexSchemeColorIndex = json['flexSchemeColorIndex'];
    id = json['id'];
    incognitoMode = json['incognitoMode'];
    libraryDownloadedChapters = json['libraryDownloadedChapters'];
    libraryFilterAnimeBookMarkedType = json['libraryFilterAnimeBookMarkedType'];
    libraryFilterAnimeDownloadType = json['libraryFilterAnimeDownloadType'];
    libraryFilterAnimeStartedType = json['libraryFilterAnimeStartedType'];
    libraryFilterAnimeUnreadType = json['libraryFilterAnimeUnreadType'];
    libraryFilterMangasBookMarkedType =
        json['libraryFilterMangasBookMarkedType'];
    libraryFilterMangasDownloadType = json['libraryFilterMangasDownloadType'];
    libraryFilterMangasStartedType = json['libraryFilterMangasStartedType'];
    libraryFilterMangasUnreadType = json['libraryFilterMangasUnreadType'];
    libraryLocalSource = json['libraryLocalSource'];
    libraryShowCategoryTabs = json['libraryShowCategoryTabs'];
    libraryShowContinueReadingButton = json['libraryShowContinueReadingButton'];
    libraryShowLanguage = json['libraryShowLanguage'];
    libraryShowNumbersOfItems = json['libraryShowNumbersOfItems'];
    locale =
        json['locale'] != null ? L10nLocale.fromJson(json['locale']) : null;
    onlyIncludePinnedSources = json['onlyIncludePinnedSources'];
    pagePreloadAmount = json['pagePreloadAmount'];
    if (json['personalPageModeList'] != null) {
      personalPageModeList = (json['personalPageModeList'] as List)
          .map((e) => PersonalPageMode.fromJson(e))
          .toList();
    }
    if (json['personalReaderModeList'] != null) {
      personalReaderModeList = (json['personalReaderModeList'] as List)
          .map((e) => PersonalReaderMode.fromJson(e))
          .toList();
    }
    pureBlackDarkMode = json['pureBlackDarkMode'];
    relativeTimesTamps = json['relativeTimesTamps'];
    saveAsCBZArchive = json['saveAsCBZArchive'];
    scaleType = ScaleType.values[json['scaleType']];
    showNSFW = json['showNSFW'];
    showPagesNumber = json['showPagesNumber'];
    if (json['sortChapterList'] != null) {
      sortChapterList = (json['sortChapterList'] as List)
          .map((e) => SortChapter.fromJson(e))
          .toList();
    }
    sortLibraryAnime = json['sortLibraryAnime'];
    sortLibraryManga = json['sortLibraryManga'] != null
        ? SortLibraryManga.fromJson(json['sortLibraryManga'])
        : null;
    if (json['autoScrollPages'] != null) {
      autoScrollPages = (json['autoScrollPages'] as List)
          .map((e) => AutoScrollPages.fromJson(e))
          .toList();
    }
    themeIsDark = json['themeIsDark'];
    userAgent = json['userAgent'];
    backupFrequency = json['backupFrequency'];
    backupFrequencyOptions = json['backupFrequencyOptions']?.cast<int>();
    autoBackupLocation = json['autoBackupLocation'];
    startDatebackup = json['startDatebackup'];
    usePageTapZones = json['usePageTapZones'];
    markEpisodeAsSeenType = json['markEpisodeAsSeenType'];
    defaultSkipIntroLength = json['defaultSkipIntroLength'];
    defaultDoubleTapToSkipLength = json['defaultDoubleTapToSkipLength'];
    defaultPlayBackSpeed = json['defaultPlayBackSpeed'];
    updateProgressAfterReading = json['updateProgressAfterReading'];
    enableAniSkip = json['enableAniSkip'];
    enableAutoSkip = json['enableAutoSkip'];
    aniSkipTimeoutLength = json['aniSkipTimeoutLength'];
    btServerAddress = json['btServerAddress'];
    btServerPort = json['btServerPort'];
  }

  Map<String, dynamic> toJson() => {
        'animatePageTransitions': animatePageTransitions,
        'animeDisplayType': animeDisplayType.index,
        'animeLibraryDownloadedChapters': animeLibraryDownloadedChapters,
        'animeLibraryLocalSource': animeLibraryLocalSource,
        'animeLibraryShowCategoryTabs': animeLibraryShowCategoryTabs,
        'animeLibraryShowContinueReadingButton':
            animeLibraryShowContinueReadingButton,
        'animeLibraryShowLanguage': animeLibraryShowLanguage,
        'animeLibraryShowNumbersOfItems': animeLibraryShowNumbersOfItems,
        'autoExtensionsUpdates': autoExtensionsUpdates,
        'backgroundColor': backgroundColor.index,
        if (chapterFilterBookmarkedList != null)
          'chapterFilterBookmarkedList':
              chapterFilterBookmarkedList!.map((v) => v.toJson()).toList(),
        if (chapterFilterDownloadedList != null)
          'chapterFilterDownloadedList':
              chapterFilterDownloadedList!.map((v) => v.toJson()).toList(),
        if (chapterFilterUnreadList != null)
          'chapterFilterUnreadList':
              chapterFilterUnreadList!.map((v) => v.toJson()).toList(),
        if (chapterPageIndexList != null)
          'chapterPageIndexList':
              chapterPageIndexList!.map((v) => v.toJson()).toList(),
        if (chapterPageUrlsList != null)
          'chapterPageUrlsList':
              chapterPageUrlsList!.map((v) => v.toJson()).toList(),
        'checkForExtensionUpdates': checkForExtensionUpdates,
        'cookiesList': cookiesList,
        'cropBorders': cropBorders,
        'dateFormat': dateFormat,
        'defaultReaderMode': defaultReaderMode.index,
        'displayType': displayType.index,
        'doubleTapAnimationSpeed': doubleTapAnimationSpeed,
        'downloadLocation': downloadLocation,
        'downloadOnlyOnWifi': downloadOnlyOnWifi,
        'filterScanlatorList': filterScanlatorList,
        'flexColorSchemeBlendLevel': flexColorSchemeBlendLevel,
        'flexSchemeColorIndex': flexSchemeColorIndex,
        'id': id,
        'incognitoMode': incognitoMode,
        'libraryDownloadedChapters': libraryDownloadedChapters,
        'libraryFilterAnimeBookMarkedType': libraryFilterAnimeBookMarkedType,
        'libraryFilterAnimeDownloadType': libraryFilterAnimeDownloadType,
        'libraryFilterAnimeStartedType': libraryFilterAnimeStartedType,
        'libraryFilterAnimeUnreadType': libraryFilterAnimeUnreadType,
        'libraryFilterMangasBookMarkedType': libraryFilterMangasBookMarkedType,
        'libraryFilterMangasDownloadType': libraryFilterMangasDownloadType,
        'libraryFilterMangasStartedType': libraryFilterMangasStartedType,
        'libraryFilterMangasUnreadType': libraryFilterMangasUnreadType,
        'libraryLocalSource': libraryLocalSource,
        'libraryShowCategoryTabs': libraryShowCategoryTabs,
        'libraryShowContinueReadingButton': libraryShowContinueReadingButton,
        'libraryShowLanguage': libraryShowLanguage,
        'libraryShowNumbersOfItems': libraryShowNumbersOfItems,
        if (locale != null) 'locale': locale!.toJson(),
        'onlyIncludePinnedSources': onlyIncludePinnedSources,
        'pagePreloadAmount': pagePreloadAmount,
        if (personalPageModeList != null)
          'personalPageModeList':
              personalPageModeList!.map((v) => v.toJson()).toList(),
        if (personalReaderModeList != null)
          'personalReaderModeList':
              personalReaderModeList!.map((v) => v.toJson()).toList(),
        'pureBlackDarkMode': pureBlackDarkMode,
        'relativeTimesTamps': relativeTimesTamps,
        'saveAsCBZArchive': saveAsCBZArchive,
        'scaleType': scaleType.index,
        'showNSFW': showNSFW,
        'showPagesNumber': showPagesNumber,
        if (sortChapterList != null)
          'sortChapterList': sortChapterList!.map((v) => v.toJson()).toList(),
        if (autoScrollPages != null)
          'autoScrollPages': autoScrollPages!.map((v) => v.toJson()).toList(),
        'sortLibraryAnime': sortLibraryAnime,
        if (sortLibraryManga != null)
          'sortLibraryManga': sortLibraryManga!.toJson(),
        'themeIsDark': themeIsDark,
        'userAgent': userAgent,
        'backupFrequency': backupFrequency,
        'backupFrequencyOptions': backupFrequencyOptions,
        'autoBackupLocation': autoBackupLocation,
        'startDatebackup': startDatebackup,
        'usePageTapZones': usePageTapZones,
        'markEpisodeAsSeenType': markEpisodeAsSeenType,
        'defaultSkipIntroLength': defaultSkipIntroLength,
        'defaultDoubleTapToSkipLength': defaultDoubleTapToSkipLength,
        'defaultPlayBackSpeed': defaultPlayBackSpeed,
        'updateProgressAfterReading': updateProgressAfterReading,
        'enableAniSkip': enableAniSkip,
        'enableAutoSkip': enableAutoSkip,
        'aniSkipTimeoutLength': aniSkipTimeoutLength,
        'btServerAddress': btServerAddress,
        'btServerPort': btServerPort
      };
}

enum DisplayType {
  compactGrid,
  comfortableGrid,
  coverOnlyGrid,
  list,
}

enum ScaleType {
  fitScreen,
  stretch,
  fitWidth,
  fitHeight,
  originalSize,
  smartFit,
}

enum BackgroundColor { black, grey, white, automatic }

@embedded
class SortLibraryManga {
  bool? reverse;
  int? index;
  SortLibraryManga({this.reverse = false, this.index = 0});
  SortLibraryManga.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    reverse = json['reverse'];
  }

  Map<String, dynamic> toJson() => {'index': index, 'reverse': reverse};
}

@embedded
class SortChapter {
  int? mangaId;
  bool? reverse;
  int? index;
  SortChapter({this.mangaId, this.reverse = false, this.index = 1});
  SortChapter.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    mangaId = json['mangaId'];
    reverse = json['reverse'];
  }

  Map<String, dynamic> toJson() =>
      {'index': index, 'mangaId': mangaId, 'reverse': reverse};
}

@embedded
class ChapterFilterDownloaded {
  int? mangaId;
  int? type;
  ChapterFilterDownloaded({this.mangaId, this.type = 0});
  ChapterFilterDownloaded.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() => {'mangaId': mangaId, 'type': type};
}

@embedded
class ChapterFilterUnread {
  int? mangaId;
  int? type;
  ChapterFilterUnread({this.mangaId, this.type = 0});
  ChapterFilterUnread.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() => {'mangaId': mangaId, 'type': type};
}

@embedded
class ChapterFilterBookmarked {
  int? mangaId;
  int? type;
  ChapterFilterBookmarked({this.mangaId, this.type = 0});
  ChapterFilterBookmarked.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() => {'mangaId': mangaId, 'type': type};
}

@embedded
class ChapterPageurls {
  int? chapterId;
  List<String>? urls;

  ChapterPageurls({this.chapterId, this.urls});
  ChapterPageurls.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    urls = json['urls']?.cast<String>();
  }

  Map<String, dynamic> toJson() => {'chapterId': chapterId, 'urls': urls};
}

@embedded
class ChapterPageIndex {
  int? chapterId;
  int? index;

  ChapterPageIndex({this.chapterId, this.index});
  ChapterPageIndex.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() => {'chapterId': chapterId, 'index': index};
}

@embedded
class Cookie {
  String? idSource;
  String? cookie;
  Cookie({this.idSource, this.cookie});

  Cookie.fromJson(Map<String, dynamic> json) {
    idSource = json['idSource'];
    cookie = json['cookie'];
  }

  Map<String, dynamic> toJson() => {'idSource': idSource, 'cookie': cookie};
}

@embedded
class PersonalReaderMode {
  int? mangaId;

  @enumerated
  ReaderMode readerMode = ReaderMode.vertical;
  PersonalReaderMode({this.mangaId, this.readerMode = ReaderMode.vertical});

  PersonalReaderMode.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'];
    readerMode = ReaderMode.values[json['readerMode']];
  }

  Map<String, dynamic> toJson() =>
      {'mangaId': mangaId, 'readerMode': readerMode.index};
}

@embedded
class AutoScrollPages {
  int? mangaId;
  double? pageOffset;
  bool? autoScroll;
  AutoScrollPages(
      {this.mangaId, this.pageOffset = 10, this.autoScroll = false});

  AutoScrollPages.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'];
    pageOffset = json['pageOffset'];
    autoScroll = json['autoScroll'];
  }

  Map<String, dynamic> toJson() =>
      {'mangaId': mangaId, 'pageOffset': pageOffset, 'autoScroll': autoScroll};
}

@embedded
class PersonalPageMode {
  int? mangaId;

  @enumerated
  PageMode pageMode = PageMode.onePage;
  PersonalPageMode({this.mangaId, this.pageMode = PageMode.onePage});

  PersonalPageMode.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'];
    pageMode = PageMode.values[json['pageMode']];
  }

  Map<String, dynamic> toJson() =>
      {'mangaId': mangaId, 'pageMode': pageMode.index};
}

enum ReaderMode { vertical, ltr, rtl, verticalContinuous, webtoon }

enum PageMode { onePage, doublePage }

@embedded
class FilterScanlator {
  int? mangaId;
  List<String>? scanlators;

  FilterScanlator({this.mangaId, this.scanlators});
  FilterScanlator.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'];
    scanlators = json['scanlators']?.cast<String>();
  }

  Map<String, dynamic> toJson() =>
      {'mangaId': mangaId, 'scanlators': scanlators};
}

@embedded
class L10nLocale {
  String? languageCode;
  String? countryCode;
  L10nLocale({this.languageCode, this.countryCode});

  L10nLocale.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    languageCode = json['languageCode'];
  }

  Map<String, dynamic> toJson() =>
      {'countryCode': countryCode, 'languageCode': languageCode};
}
