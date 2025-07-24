import 'package:isar/isar.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/constant.dart';
part 'settings.g.dart';

@collection
@Name("Settings")
class Settings {
  Id? id;

  int? updatedAt;

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

  bool? followSystemTheme;

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

  int? concurrentDownloads;

  String? downloadLocation;

  List<FilterScanlator>? filterScanlatorList;

  final sources = IsarLinks<Source>();

  bool? autoExtensionsUpdates;

  bool? cropBorders;

  L10nLocale? locale;

  L10nLocale? defaultSubtitleLang;

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

  bool? checkForAppUpdates;

  bool? checkForExtensionUpdates;

  @enumerated
  late ScaleType scaleType;

  @enumerated
  late BackgroundColor backgroundColor;

  List<PersonalPageMode>? personalPageModeList;

  int? startDatebackup;

  int? backupFrequency;

  List<int>? backupListOptions;

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

  List<Repo>? mangaExtensionsRepo;

  List<Repo>? animeExtensionsRepo;

  List<Repo>? novelExtensionsRepo;

  @enumerated
  late SectionType disableSectionType;

  bool? useLibass;

  String? hwdecMode;

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

  int? novelFontSize;

  @enumerated
  late NovelTextAlign novelTextAlign;

  List<String>? navigationOrder;

  List<String>? hideItems;

  bool? clearChapterCacheOnAppLaunch;

  String? lastTrackerLibraryLocation;

  bool? mergeLibraryNavMobile;

  bool? enableDiscordRpc;

  bool? hideDiscordRpcInIncognito;

  bool? rpcShowReadingWatchingProgress;

  bool? rpcShowTitle;

  bool? rpcShowCoverImage;

  Settings({
    this.id = 227,
    this.updatedAt = 0,
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
    this.followSystemTheme = false,
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
    this.concurrentDownloads = 2,
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
    this.checkForAppUpdates = true,
    this.checkForExtensionUpdates = true,
    this.backgroundColor = BackgroundColor.black,
    this.personalPageModeList,
    this.backupFrequency,
    this.backupListOptions,
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
    this.hwdecMode = "auto",
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
    this.novelFontSize = 14,
    this.novelTextAlign = NovelTextAlign.left,
    this.navigationOrder,
    this.hideItems,
    this.clearChapterCacheOnAppLaunch = false,
    this.mangaExtensionsRepo,
    this.animeExtensionsRepo,
    this.novelExtensionsRepo,
    this.lastTrackerLibraryLocation,
    this.mergeLibraryNavMobile = false,
    this.enableDiscordRpc = true,
    this.hideDiscordRpcInIncognito = true,
    this.rpcShowReadingWatchingProgress = true,
    this.rpcShowTitle = true,
    this.rpcShowCoverImage = true,
  });

  Settings.fromJson(Map<String, dynamic> json) {
    updatedAt = json["updatedAt"];
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
    checkForAppUpdates = json['checkForAppUpdates'];
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
    concurrentDownloads = json['concurrentDownloads'];
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
    locale = json['locale'] != null
        ? L10nLocale.fromJson(json['locale'])
        : null;
    defaultSubtitleLang = json['defaultSubtitleLang'] != null
        ? L10nLocale.fromJson(json['defaultSubtitleLang'])
        : null;
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
    followSystemTheme = json['followSystemTheme'];
    userAgent = json['userAgent'];
    backupFrequency = json['backupFrequency'];
    backupListOptions = json['backupListOptions']?.cast<int>();
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
    colorFilterBlendMode =
        ColorFilterBlendMode.values[json['colorFilterBlendMode'] ??
            ColorFilterBlendMode.none.index];
    playerSubtitleSettings = json['playerSubtitleSettings'] != null
        ? PlayerSubtitleSettings.fromJson(json['playerSubtitleSettings'])
        : null;
    mangaHomeDisplayType =
        DisplayType.values[json['mangaHomeDisplayType'] ??
            DisplayType.comfortableGrid.index];
    appFontFamily = json['appFontFamily'];
    mangaGridSize = json['mangaGridSize'];
    animeGridSize = json['animeGridSize'];
    disableSectionType =
        SectionType.values[json['disableSectionType'] ?? SectionType.all.index];
    useLibass = json['useLibass'];
    hwdecMode = json['hwdecMode'];
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
    if (json['novelFontSize'] != null) {
      novelFontSize = json['novelFontSize'];
    }
    novelTextAlign = NovelTextAlign
        .values[json['novelTextAlign'] ?? NovelTextAlign.left.index];
    if (json['navigationOrder'] != null) {
      navigationOrder = (json['navigationOrder'] as List).cast<String>();
    }
    if (json['hideItems'] != null) {
      hideItems = (json['hideItems'] as List).cast<String>();
    }
    clearChapterCacheOnAppLaunch = json['clearChapterCacheOnAppLaunch'];
    if (json['mangaExtensionsRepo'] != null) {
      mangaExtensionsRepo = json['mangaExtensionsRepo'] is String
          ? [Repo(jsonUrl: json['mangaExtensionsRepo'])]
          : (json['mangaExtensionsRepo'] as List)
                .map((e) => Repo.fromJson(e))
                .toList();
    }
    if (json['animeExtensionsRepo'] != null) {
      animeExtensionsRepo = json['animeExtensionsRepo'] is String
          ? [Repo(jsonUrl: json['animeExtensionsRepo'])]
          : (json['animeExtensionsRepo'] as List)
                .map((e) => Repo.fromJson(e))
                .toList();
    }
    if (json['novelExtensionsRepo'] != null) {
      novelExtensionsRepo = json['novelExtensionsRepo'] is String
          ? [Repo(jsonUrl: json['novelExtensionsRepo'])]
          : (json['novelExtensionsRepo'] as List)
                .map((e) => Repo.fromJson(e))
                .toList();
    }
    lastTrackerLibraryLocation = json['lastTrackerLibraryLocation'];
    mergeLibraryNavMobile = json['mergeLibraryNavMobile'];
    enableDiscordRpc = json['enableDiscordRpc'];
    hideDiscordRpcInIncognito = json['hideDiscordRpcInIncognito'];
    rpcShowReadingWatchingProgress = json['rpcShowReadingWatchingProgress'];
    rpcShowTitle = json['rpcShowTitle'];
    rpcShowCoverImage = json['rpcShowCoverImage'];
  }

  Map<String, dynamic> toJson() => {
    'updatedAt': updatedAt,
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
    'chapterFilterBookmarkedList': chapterFilterBookmarkedList
        ?.map((v) => v.toJson())
        .toList(),
    'chapterFilterDownloadedList': chapterFilterDownloadedList
        ?.map((v) => v.toJson())
        .toList(),
    'chapterFilterUnreadList': chapterFilterUnreadList
        ?.map((v) => v.toJson())
        .toList(),
    'chapterPageIndexList': chapterPageIndexList
        ?.map((v) => v.toJson())
        .toList(),
    'chapterPageUrlsList': chapterPageUrlsList?.map((v) => v.toJson()).toList(),
    'checkForAppUpdates': checkForAppUpdates,
    'checkForExtensionUpdates': checkForExtensionUpdates,
    'cookiesList': cookiesList,
    'cropBorders': cropBorders,
    'dateFormat': dateFormat,
    'defaultReaderMode': defaultReaderMode.index,
    'displayType': displayType.index,
    'doubleTapAnimationSpeed': doubleTapAnimationSpeed,
    'downloadLocation': downloadLocation,
    'downloadOnlyOnWifi': downloadOnlyOnWifi,
    'concurrentDownloads': concurrentDownloads,
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
    'defaultSubtitleLang': defaultSubtitleLang?.toJson(),
    'onlyIncludePinnedSources': onlyIncludePinnedSources,
    'pagePreloadAmount': pagePreloadAmount,
    'personalPageModeList': personalPageModeList
        ?.map((v) => v.toJson())
        .toList(),
    'personalReaderModeList': personalReaderModeList
        ?.map((v) => v.toJson())
        .toList(),
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
    'followSystemTheme': followSystemTheme,
    'userAgent': userAgent,
    'backupFrequency': backupFrequency,
    'backupListOptions': backupListOptions,
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
    'hwdecMode': hwdecMode,
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
    'novelFontSize': novelFontSize,
    'novelTextAlign': novelTextAlign.index,
    'navigationOrder': navigationOrder,
    'hideItems': hideItems,
    'clearChapterCacheOnAppLaunch': clearChapterCacheOnAppLaunch,
    'mangaExtensionsRepo': mangaExtensionsRepo?.map((e) => e.toJson()).toList(),
    'animeExtensionsRepo': animeExtensionsRepo?.map((e) => e.toJson()).toList(),
    'novelExtensionsRepo': novelExtensionsRepo?.map((e) => e.toJson()).toList(),
    'lastTrackerLibraryLocation': lastTrackerLibraryLocation,
    'mergeLibraryNavMobile': mergeLibraryNavMobile,
    'enableDiscordRpc': enableDiscordRpc,
    'hideDiscordRpcInIncognito': hideDiscordRpcInIncognito,
    'rpcShowReadingWatchingProgress': rpcShowReadingWatchingProgress,
    'rpcShowTitle': rpcShowTitle,
    'rpcShowCoverImage': rpcShowCoverImage,
  };
}

enum SectionType { all, anime, manga }

enum DisplayType { compactGrid, comfortableGrid, coverOnlyGrid, list }

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

  Map<String, dynamic> toJson() => {
    'index': index,
    'mangaId': mangaId,
    'reverse': reverse,
  };
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

  Map<String, dynamic> toJson() => {
    'chapterId': chapterId,
    'urls': urls,
    'headers': headers,
  };
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

  Map<String, dynamic> toJson() => {
    'mangaId': mangaId,
    'readerMode': readerMode.index,
  };
}

@embedded
class AutoScrollPages {
  int? mangaId;
  double? pageOffset;
  bool? autoScroll;
  AutoScrollPages({
    this.mangaId,
    this.pageOffset = 10,
    this.autoScroll = false,
  });

  AutoScrollPages.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'];
    pageOffset = json['pageOffset'];
    autoScroll = json['autoScroll'];
  }

  Map<String, dynamic> toJson() => {
    'mangaId': mangaId,
    'pageOffset': pageOffset,
    'autoScroll': autoScroll,
  };
}

@embedded
class Repo {
  String? name;
  String? website;
  String? jsonUrl;

  Repo({this.name, this.website, this.jsonUrl});

  Repo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    website = json['website'];
    jsonUrl = json['jsonUrl'];
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'website': website,
    'jsonUrl': jsonUrl,
  };
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

  Map<String, dynamic> toJson() => {
    'mangaId': mangaId,
    'pageMode': pageMode.index,
  };
}

enum ReaderMode {
  vertical,
  ltr,
  rtl,
  verticalContinuous,
  webtoon,
  horizontalContinuous,
}

enum NovelTextAlign { left, center, right, block }

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

  Map<String, dynamic> toJson() => {
    'mangaId': mangaId,
    'scanlators': scanlators,
  };
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

  Map<String, dynamic> toJson() => {
    'countryCode': countryCode,
    'languageCode': languageCode,
  };
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
  PlayerSubtitleSettings({
    this.fontSize = 45,
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
    this.backgroundColorB = 0,
  });
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
    'backgroundColorB': backgroundColorB,
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
  exclusion,
}
