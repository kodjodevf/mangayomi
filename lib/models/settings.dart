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
      this.usePageTapZones = true});

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
    themeIsDark = json['themeIsDark'];
    userAgent = json['userAgent'];
    backupFrequency = json['backupFrequency'];
    backupFrequencyOptions = json['backupFrequencyOptions']?.cast<int>();
    autoBackupLocation = json['autoBackupLocation'];
    startDatebackup = json['startDatebackup'];
    usePageTapZones = json['usePageTapZones'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['animatePageTransitions'] = animatePageTransitions;
    data['animeDisplayType'] = animeDisplayType.index;
    data['animeLibraryDownloadedChapters'] = animeLibraryDownloadedChapters;
    data['animeLibraryLocalSource'] = animeLibraryLocalSource;
    data['animeLibraryShowCategoryTabs'] = animeLibraryShowCategoryTabs;
    data['animeLibraryShowContinueReadingButton'] =
        animeLibraryShowContinueReadingButton;
    data['animeLibraryShowLanguage'] = animeLibraryShowLanguage;
    data['animeLibraryShowNumbersOfItems'] = animeLibraryShowNumbersOfItems;
    data['autoExtensionsUpdates'] = autoExtensionsUpdates;
    data['backgroundColor'] = backgroundColor.index;
    if (chapterFilterBookmarkedList != null) {
      data['chapterFilterBookmarkedList'] =
          chapterFilterBookmarkedList!.map((v) => v.toJson()).toList();
    }
    if (chapterFilterDownloadedList != null) {
      data['chapterFilterDownloadedList'] =
          chapterFilterDownloadedList!.map((v) => v.toJson()).toList();
    }
    if (chapterFilterUnreadList != null) {
      data['chapterFilterUnreadList'] =
          chapterFilterUnreadList!.map((v) => v.toJson()).toList();
    }
    if (chapterPageIndexList != null) {
      data['chapterPageIndexList'] =
          chapterPageIndexList!.map((v) => v.toJson()).toList();
    }
    if (chapterPageUrlsList != null) {
      data['chapterPageUrlsList'] =
          chapterPageUrlsList!.map((v) => v.toJson()).toList();
    }
    data['checkForExtensionUpdates'] = checkForExtensionUpdates;
    data['cookiesList'] = cookiesList;
    data['cropBorders'] = cropBorders;
    data['dateFormat'] = dateFormat;
    data['defaultReaderMode'] = defaultReaderMode.index;
    data['displayType'] = displayType.index;
    data['doubleTapAnimationSpeed'] = doubleTapAnimationSpeed;
    data['downloadLocation'] = downloadLocation;
    data['downloadOnlyOnWifi'] = downloadOnlyOnWifi;
    data['filterScanlatorList'] = filterScanlatorList;
    data['flexColorSchemeBlendLevel'] = flexColorSchemeBlendLevel;
    data['flexSchemeColorIndex'] = flexSchemeColorIndex;
    data['id'] = id;
    data['incognitoMode'] = incognitoMode;
    data['libraryDownloadedChapters'] = libraryDownloadedChapters;
    data['libraryFilterAnimeBookMarkedType'] = libraryFilterAnimeBookMarkedType;
    data['libraryFilterAnimeDownloadType'] = libraryFilterAnimeDownloadType;
    data['libraryFilterAnimeStartedType'] = libraryFilterAnimeStartedType;
    data['libraryFilterAnimeUnreadType'] = libraryFilterAnimeUnreadType;
    data['libraryFilterMangasBookMarkedType'] =
        libraryFilterMangasBookMarkedType;
    data['libraryFilterMangasDownloadType'] = libraryFilterMangasDownloadType;
    data['libraryFilterMangasStartedType'] = libraryFilterMangasStartedType;
    data['libraryFilterMangasUnreadType'] = libraryFilterMangasUnreadType;
    data['libraryLocalSource'] = libraryLocalSource;
    data['libraryShowCategoryTabs'] = libraryShowCategoryTabs;
    data['libraryShowContinueReadingButton'] = libraryShowContinueReadingButton;
    data['libraryShowLanguage'] = libraryShowLanguage;
    data['libraryShowNumbersOfItems'] = libraryShowNumbersOfItems;
    if (locale != null) {
      data['locale'] = locale!.toJson();
    }
    data['onlyIncludePinnedSources'] = onlyIncludePinnedSources;
    data['pagePreloadAmount'] = pagePreloadAmount;
    if (personalPageModeList != null) {
      data['personalPageModeList'] =
          personalPageModeList!.map((v) => v.toJson()).toList();
    }
    if (personalReaderModeList != null) {
      data['personalReaderModeList'] =
          personalReaderModeList!.map((v) => v.toJson()).toList();
    }
    data['pureBlackDarkMode'] = pureBlackDarkMode;
    data['relativeTimesTamps'] = relativeTimesTamps;
    data['saveAsCBZArchive'] = saveAsCBZArchive;
    data['scaleType'] = scaleType.index;
    data['showNSFW'] = showNSFW;
    data['showPagesNumber'] = showPagesNumber;
    if (sortChapterList != null) {
      data['sortChapterList'] =
          sortChapterList!.map((v) => v.toJson()).toList();
    }
    data['sortLibraryAnime'] = sortLibraryAnime;
    if (sortLibraryManga != null) {
      data['sortLibraryManga'] = sortLibraryManga!.toJson();
    }
    data['themeIsDark'] = themeIsDark;
    data['userAgent'] = userAgent;
    data['backupFrequency'] = backupFrequency;
    data['backupFrequencyOptions'] = backupFrequencyOptions;
    data['autoBackupLocation'] = autoBackupLocation;
    data['startDatebackup'] = startDatebackup;
    data['usePageTapZones'] = usePageTapZones;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['reverse'] = reverse;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['mangaId'] = mangaId;
    data['reverse'] = reverse;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mangaId'] = mangaId;
    data['type'] = type;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mangaId'] = mangaId;
    data['type'] = type;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mangaId'] = mangaId;
    data['type'] = type;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chapterId'] = chapterId;
    data['urls'] = urls;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chapterId'] = chapterId;
    data['index'] = index;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idSource'] = idSource;
    data['cookie'] = cookie;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mangaId'] = mangaId;
    data['readerMode'] = readerMode.index;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mangaId'] = mangaId;
    data['pageMode'] = pageMode.index;
    return data;
  }
}

enum ReaderMode { vertical, ltr, rtl, verticalContinuous, webtoon }

enum PageMode { onePage, doubleColumm }

@embedded
class FilterScanlator {
  int? mangaId;
  List<String>? scanlators;

  FilterScanlator({this.mangaId, this.scanlators});
  FilterScanlator.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'];
    scanlators = json['scanlators']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mangaId'] = mangaId;
    data['scanlators'] = scanlators;
    return data;
  }
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryCode'] = countryCode;
    data['languageCode'] = languageCode;
    return data;
  }
}
