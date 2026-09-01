import 'dart:typed_data';

import '../models/chapter.dart';
import '../models/deep_link.dart';
import '../models/filter.dart';
import '../models/filter_value.dart';
import '../models/home.dart';
import '../models/listing.dart';
import '../models/manga.dart';
import '../models/page.dart';
import '../models/response.dart';
import '../models/setting.dart';
import '../models/source_features.dart';

/// Public interface for running Aidoku source modules.
abstract interface class AidokuRunner {
  SourceFeatures get features;

  Future<MangaPageResult> getSearchMangaList(String? query, int page, List<FilterValue> filters);
  Future<Manga> getMangaUpdate(Manga manga, {bool needsDetails = false, bool needsChapters = false});
  Future<List<Page>> getPageList(Manga manga, Chapter chapter);
  Future<MangaPageResult> getMangaList(Listing listing, int page);
  Future<Home> getHome();
  Future<Uint8List?> processPageImage(Response response, {PageContext? context});
  Future<List<Filter>> getSearchFilters();
  Future<List<Setting>> getSettings();
  Future<List<Listing>> getListings();
  Future<String?> getBaseUrl();
  Future<DeepLinkResult?> handleDeepLink(String url);
  Future<bool> handleBasicLogin(String key, String username, String password);
  Future<bool> handleWebLogin(String key, Map<String, String> cookies);
  Future<String> handleMigration(int kind, String mangaKey, String? chapterKey);
  void dispose();
}
