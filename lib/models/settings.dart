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

  List<MCookie>? cookiesList;

  @enumerated
  late ReaderMode defaultReaderMode;

  List<PersonalReaderMode>? personalReaderModeList;

  bool? animatePageTransitions;

  int? doubleTapAnimationSpeed;

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

  bool? fullScreenPlayer;

  bool? updateProgressAfterReading;

  bool? enableAniSkip;

  bool? enableAutoSkip;

  int? aniSkipTimeoutLength;

  String? btServerAddress;

  int? btServerPort;

  bool? fullScreenReader;

  late CustomColorFilter? customColorFilter;

  bool? enableCustomColorFilter;

  @enumerated
  late ColorFilterBlendMode colorFilterBlendMode;

  late PlayerSubtitleSettings? playerSubtitleSettings;

  @enumerated
  late DisplayType mangaHomeDisplayType;

  String? appFontFamily;

  int? mangaGridSize;

  int? animeGridSize;

  int? novelGridSize;

  @enumerated
  late SectionType disableSectionType;

  bool? useLibass;

  int? libraryFilterNovelDownloadType;

  int? libraryFilterNovelUnreadType;

  int? libraryFilterNovelStartedType;

  int? libraryFilterNovelBookMarkedType;

  bool? novelLibraryShowCategoryTabs;

  bool? novelLibraryDownloadedChapters;

  bool? novelLibraryShowLanguage;

  bool? novelLibraryShowNumbersOfItems;

  bool? novelLibraryShowContinueReadingButton;

  bool? novelLibraryLocalSource;

  late SortLibraryManga? sortLibraryNovel;

  @enumerated
  late DisplayType novelDisplayType;

  bool? hideManga;

  bool? hideAnime;

  bool? hideNovel;

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
      this.fullScreenPlayer = false,
      this.updateProgressAfterReading = true,
      this.enableAniSkip,
      this.enableAutoSkip,
      this.aniSkipTimeoutLength,
      this.btServerAddress = "127.0.0.1",
      this.btServerPort,
      this.fullScreenReader = true,
      this.enableCustomColorFilter = false,
      this.customColorFilter,
      this.colorFilterBlendMode = ColorFilterBlendMode.none,
      this.playerSubtitleSettings,
      this.mangaHomeDisplayType = DisplayType.comfortableGrid,
      this.appFontFamily,
      this.mangaGridSize,
      this.animeGridSize,
      this.disableSectionType = SectionType.all,
      this.useLibass = true,
      this.libraryFilterNovelDownloadType = 0,
      this.libraryFilterNovelUnreadType = 0,
      this.libraryFilterNovelStartedType = 0,
      this.libraryFilterNovelBookMarkedType = 0,
      this.novelLibraryShowCategoryTabs = false,
      this.novelLibraryDownloadedChapters = false,
      this.novelLibraryShowLanguage = false,
      this.novelLibraryShowNumbersOfItems = false,
      this.novelLibraryShowContinueReadingButton = false,
      this.novelLibraryLocalSource,
      this.sortLibraryNovel,
      this.novelDisplayType = DisplayType.comfortableGrid,
      this.hideManga = false,
      this.hideAnime = false,
      this.hideNovel = false});

  Settings.fromJson(Map<String, dynamic> json) {
    animatePageTransitions = json['animatePageTransitions'];
    animeDisplayType = DisplayType
        .values[json['animeDisplayType'] ?? DisplayType.compactGrid.index];
    animeLibraryDownloadedChapters = json['animeLibraryDownloadedChapters'];
    animeLibraryLocalSource = json['animeLibraryLocalSource'];
    animeLibraryShowCategoryTabs = json['animeLibraryShowCategoryTabs'];
    animeLibraryShowContinueReadingButton =
        json['animeLibraryShowContinueReadingButton'];
    animeLibraryShowLanguage = json['animeLibraryShowLanguage'];
    animeLibraryShowNumbersOfItems = json['animeLibraryShowNumbersOfItems'];
    autoExtensionsUpdates = json['autoExtensionsUpdates'];
    backgroundColor = BackgroundColor
        .values[json['backgroundColor'] ?? BackgroundColor.black.index];
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
      cookiesList = (json['cookiesList'] as List)
          .map((e) => MCookie.fromJson(e))
          .toList();
    }
    cropBorders = json['cropBorders'];
    dateFormat = json['dateFormat'];
    defaultReaderMode = ReaderMode
        .values[json['defaultReaderMode'] ?? ReaderMode.vertical.index];
    displayType = DisplayType.values[json['displayType']];
    doubleTapAnimationSpeed = json['doubleTapAnimationSpeed'];
    downloadLocation = json['downloadLocation'];
    downloadOnlyOnWifi = json['downloadOnlyOnWifi'];
    filterScanlatorList = (json['filterScanlatorList'] as List?)
        ?.map((e) => FilterScanlator.fromJson(e))
        .toList();
    flexColorSchemeBlendLevel = json['flexColorSchemeBlendLevel'] is double
        ? json['flexColorSchemeBlendLevel']
        : (json['flexColorSchemeBlendLevel'] as int).toDouble();
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
    scaleType =
        ScaleType.values[json['scaleType'] ?? ScaleType.fitScreen.index];
    showPagesNumber = json['showPagesNumber'];
    if (json['sortChapterList'] != null) {
      sortChapterList = (json['sortChapterList'] as List)
          .map((e) => SortChapter.fromJson(e))
          .toList();
    }
    sortLibraryAnime = json['sortLibraryAnime'] != null
        ? SortLibraryManga.fromJson(json['sortLibraryAnime'])
        : null;
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
    defaultPlayBackSpeed = json['defaultPlayBackSpeed'] is double
        ? json['defaultPlayBackSpeed']
        : (json['defaultPlayBackSpeed'] as int).toDouble();
    fullScreenPlayer = json['fullScreenPlayer'];
    updateProgressAfterReading = json['updateProgressAfterReading'];
    enableAniSkip = json['enableAniSkip'];
    enableAutoSkip = json['enableAutoSkip'];
    aniSkipTimeoutLength = json['aniSkipTimeoutLength'];
    btServerAddress = json['btServerAddress'];
    btServerPort = json['btServerPort'];
    customColorFilter = json['customColorFilter'] != null
        ? CustomColorFilter.fromJson(json['customColorFilter'])
        : null;
    enableCustomColorFilter = json['enableCustomColorFilter'];
    colorFilterBlendMode = ColorFilterBlendMode.values[
        json['colorFilterBlendMode'] ?? ColorFilterBlendMode.none.index];
    playerSubtitleSettings = json['playerSubtitleSettings'] != null
        ? PlayerSubtitleSettings.fromJson(json['playerSubtitleSettings'])
        : null;
    mangaHomeDisplayType = DisplayType.values[
        json['mangaHomeDisplayType'] ?? DisplayType.comfortableGrid.index];
    appFontFamily = json['appFontFamily'];
    mangaGridSize = json['mangaGridSize'];
    animeGridSize = json['animeGridSize'];
    disableSectionType =
        SectionType.values[json['disableSectionType'] ?? SectionType.all.index];
    useLibass = json['useLibass'];
    libraryFilterNovelBookMarkedType = json['libraryFilterNovelBookMarkedType'];
    libraryFilterNovelDownloadType = json['libraryFilterNovelDownloadType'];
    libraryFilterNovelStartedType = json['libraryFilterNovelStartedType'];
    libraryFilterNovelUnreadType = json['libraryFilterNovelUnreadType'];
    novelLibraryShowCategoryTabs = json['novelLibraryShowCategoryTabs'];
    novelLibraryDownloadedChapters = json['novelLibraryDownloadedChapters'];
    novelLibraryShowLanguage = json['novelLibraryShowLanguage'];
    novelLibraryShowNumbersOfItems = json['novelLibraryShowNumbersOfItems'];
    novelLibraryShowContinueReadingButton =
        json['novelLibraryShowContinueReadingButton'];
    novelLibraryLocalSource = json['novelLibraryLocalSource'];
    sortLibraryNovel = json['sortLibraryNovel'] != null
        ? SortLibraryManga.fromJson(json['sortLibraryNovel'])
        : null;
    novelDisplayType = DisplayType
        .values[json['novelDisplayType'] ?? DisplayType.comfortableGrid.index];
    hideManga = json['hideManga'];
    hideAnime = json['hideAnime'];
    hideNovel = json['hideNovel'];
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
        'chapterFilterBookmarkedList':
            chapterFilterBookmarkedList?.map((v) => v.toJson()).toList(),
        'chapterFilterDownloadedList':
            chapterFilterDownloadedList?.map((v) => v.toJson()).toList(),
        'chapterFilterUnreadList':
            chapterFilterUnreadList?.map((v) => v.toJson()).toList(),
        'chapterPageIndexList':
            chapterPageIndexList?.map((v) => v.toJson()).toList(),
        'chapterPageUrlsList':
            chapterPageUrlsList?.map((v) => v.toJson()).toList(),
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
        'locale': locale?.toJson(),
        'onlyIncludePinnedSources': onlyIncludePinnedSources,
        'pagePreloadAmount': pagePreloadAmount,
        'personalPageModeList':
            personalPageModeList?.map((v) => v.toJson()).toList(),
        'personalReaderModeList':
            personalReaderModeList?.map((v) => v.toJson()).toList(),
        'pureBlackDarkMode': pureBlackDarkMode,
        'relativeTimesTamps': relativeTimesTamps,
        'saveAsCBZArchive': saveAsCBZArchive,
        'scaleType': scaleType.index,
        'showPagesNumber': showPagesNumber,
        'sortChapterList': sortChapterList?.map((v) => v.toJson()).toList(),
        'autoScrollPages': autoScrollPages?.map((v) => v.toJson()).toList(),
        'sortLibraryAnime': sortLibraryAnime?.toJson(),
        'sortLibraryManga': sortLibraryManga?.toJson(),
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
        'fullScreenPlayer': fullScreenPlayer,
        'updateProgressAfterReading': updateProgressAfterReading,
        'enableAniSkip': enableAniSkip,
        'enableAutoSkip': enableAutoSkip,
        'aniSkipTimeoutLength': aniSkipTimeoutLength,
        'btServerAddress': btServerAddress,
        'btServerPort': btServerPort,
        'fullScreenReader': fullScreenReader,
        if (customColorFilter != null)
          'customColorFilter': customColorFilter!.toJson(),
        'enableCustomColorFilter': enableCustomColorFilter,
        'colorFilterBlendMode': colorFilterBlendMode.index,
        if (playerSubtitleSettings != null)
          'playerSubtitleSettings': playerSubtitleSettings!.toJson(),
        'mangaHomeDisplayType': mangaHomeDisplayType.index,
        'appFontFamily': appFontFamily,
        'mangaGridSize': mangaGridSize,
        'animeGridSize': animeGridSize,
        'disableSectionType': disableSectionType.index,
        'useLibass': useLibass,
        'libraryFilterNovelBookMarkedType': libraryFilterNovelBookMarkedType,
        'libraryFilterNovelDownloadType': libraryFilterNovelDownloadType,
        'libraryFilterNovelStartedType': libraryFilterNovelStartedType,
        'libraryFilterNovelUnreadType': libraryFilterNovelUnreadType,
        'novelLibraryShowCategoryTabs': novelLibraryShowCategoryTabs,
        'novelLibraryDownloadedChapters': novelLibraryDownloadedChapters,
        'novelLibraryShowLanguage': novelLibraryShowLanguage,
        'novelLibraryShowNumbersOfItems': novelLibraryShowNumbersOfItems,
        'novelLibraryShowContinueReadingButton':
            novelLibraryShowContinueReadingButton,
        'novelLibraryLocalSource': novelLibraryLocalSource,
        'sortLibraryNovel': sortLibraryNovel?.toJson(),
        'novelDisplayType': novelDisplayType.index,
        'hideManga': hideManga,
        'hideAnime': hideAnime,
        'hideNovel': hideNovel
      };
}

enum SectionType { all, anime, manga }

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
class MCookie {
  String? host;
  String? cookie;
  MCookie({this.host, this.cookie});

  MCookie.fromJson(Map<String, dynamic> json) {
    host = json['host'];
    cookie = json['cookie'];
  }

  Map<String, dynamic> toJson() => {'host': host, 'cookie': cookie};
}

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
  String? chapterUrl;
  List<String>? urls;
  List<String>? headers;

  ChapterPageurls({this.chapterId, this.urls});
  ChapterPageurls.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    urls = json['headers']?.cast<String>();
    urls = json['headers']?.cast<String>();
  }

  Map<String, dynamic> toJson() =>
      {'chapterId': chapterId, 'urls': urls, 'headers': headers};
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

enum ReaderMode {
  vertical,
  ltr,
  rtl,
  verticalContinuous,
  webtoon,
  horizontalContinuous
}

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

@embedded
class CustomColorFilter {
  int? a;
  int? r;
  int? g;
  int? b;
  CustomColorFilter({this.a, this.r, this.g, this.b});
  CustomColorFilter.fromJson(Map<String, dynamic> json) {
    a = json['a'];
    r = json['r'];
    g = json['g'];
    b = json['b'];
  }

  Map<String, dynamic> toJson() => {'a': a, 'r': r, 'g': g, 'b': b};
}

@embedded
class PlayerSubtitleSettings {
  int? fontSize;
  bool? useBold;
  bool? useItalic;
  int? textColorA;
  int? textColorR;
  int? textColorG;
  int? textColorB;
  int? borderColorA;
  int? borderColorR;
  int? borderColorG;
  int? borderColorB;
  int? backgroundColorA;
  int? backgroundColorR;
  int? backgroundColorG;
  int? backgroundColorB;
  PlayerSubtitleSettings(
      {this.fontSize = 45,
      this.useBold = true,
      this.useItalic = false,
      this.textColorA = 255,
      this.textColorR = 255,
      this.textColorG = 255,
      this.textColorB = 255,
      this.borderColorA = 255,
      this.borderColorR = 0,
      this.borderColorG = 0,
      this.borderColorB = 0,
      this.backgroundColorA = 0,
      this.backgroundColorR = 0,
      this.backgroundColorG = 0,
      this.backgroundColorB = 0});
  PlayerSubtitleSettings.fromJson(Map<String, dynamic> json) {
    fontSize = json['fontSize'];
    useBold = json['useBold'];
    useItalic = json['useItalic'];
    textColorA = json['textColorA'];
    textColorR = json['textColorR'];
    textColorG = json['textColorG'];
    textColorB = json['textColorB'];
    borderColorA = json['borderColorA'];
    borderColorR = json['borderColorR'];
    borderColorG = json['borderColorG'];
    borderColorB = json['borderColorB'];
    backgroundColorA = json['backgroundColorA'];
    backgroundColorR = json['backgroundColorR'];
    backgroundColorG = json['backgroundColorG'];
    backgroundColorB = json['backgroundColorB'];
  }

  Map<String, dynamic> toJson() => {
        'fontSize': fontSize,
        'useBold': useBold,
        'useItalic': useItalic,
        'textColorA': textColorA,
        'textColorR': textColorR,
        'textColorG': textColorG,
        'textColorB': textColorB,
        'borderColorA': borderColorA,
        'borderColorR': borderColorR,
        'borderColorG': borderColorG,
        'borderColorB': borderColorB,
        'backgroundColorA': backgroundColorA,
        'backgroundColorR': backgroundColorR,
        'backgroundColorG': backgroundColorG,
        'backgroundColorB': backgroundColorB
      };
}

enum ColorFilterBlendMode {
  none,
  multiply,
  screen,
  overlay,
  colorDodge,
  lighten,
  colorBurn,
  darken,
  difference,
  saturation,
  softLight,
  plus,
  exclusion
}
