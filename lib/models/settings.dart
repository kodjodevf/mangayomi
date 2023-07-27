import 'package:isar/isar.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/constant.dart';
part 'settings.g.dart';

@collection
@Name("Settings")
class Settings {
  Id? id;

  @enumerated
  DisplayType displayType;

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
  ReaderMode defaultReaderMode;

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

  bool? autoUpdateExtensions;

  bool? cropBorders;

  L10nLocale? locale;

  @enumerated
  DisplayType animeDisplayType;

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

  SortLibraryManga? sortLibraryAnime;

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
      this.autoUpdateExtensions = false,
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
      this.sortLibraryAnime});
}

enum DisplayType {
  compactGrid,
  comfortableGrid,
  coverOnlyGrid,
  list,
}

@embedded
class SortLibraryManga {
  bool? reverse;
  int? index;
  SortLibraryManga({this.reverse = false, this.index = 0});
}

@embedded
class SortChapter {
  int? mangaId;
  bool? reverse;
  int? index;
  SortChapter({this.mangaId, this.reverse = false, this.index = 1});
}

@embedded
class ChapterFilterDownloaded {
  int? mangaId;
  int? type;
  ChapterFilterDownloaded({this.mangaId, this.type = 0});
}

@embedded
class ChapterFilterUnread {
  int? mangaId;
  int? type;
  ChapterFilterUnread({this.mangaId, this.type = 0});
}

@embedded
class ChapterFilterBookmarked {
  int? mangaId;
  int? type;
  ChapterFilterBookmarked({this.mangaId, this.type = 0});
}

@embedded
class ChapterPageurls {
  int? chapterId;
  List<String>? urls;
}

@embedded
class ChapterPageIndex {
  int? chapterId;
  int? index;
}

@embedded
class Cookie {
  String? idSource;
  String? cookie;
}

@embedded
class PersonalReaderMode {
  int? mangaId;

  @enumerated
  ReaderMode readerMode = ReaderMode.vertical;
}

enum ReaderMode { vertical, ltr, rtl, verticalContinuous, webtoon }

@embedded
class FilterScanlator {
  int? mangaId;
  List<String>? scanlators;
}

@embedded
class L10nLocale {
  String? languageCode;
  String? countryCode;
  L10nLocale({this.languageCode, this.countryCode});
}
