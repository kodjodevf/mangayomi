import 'dart:async';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:mangayomi/src/rust/aidoku_wasm/host_js.dart' as rust_js;
import 'package:mangayomi/src/rust/api/aidoku_wasm.dart' as rust;

import '../../aidoku_ext_dart.dart';
import 'js_manager.dart';

/// Native Rust (`wasmi`) execution engine for Aidoku WebAssembly source modules.
class AidokuRustRunner implements AidokuRunner {
  AidokuRustRunner._(this._rustSource, this._features, this._jsManager);

  final rust.AidokuSource _rustSource;
  final SourceFeatures _features;
  final AidokuJsManager _jsManager;

  @override
  SourceFeatures get features => _features;

  /// Creates a new [AidokuRustRunner] from WASM bytes and an HTTP request handler callback.
  static Future<AidokuRustRunner> create({
    required Uint8List bytes,
    required String sourceKey,
    required FutureOr<rust.AidokuNetResponse> Function(rust.AidokuNetRequest)
        requestHandler,
    void Function(String message)? printHandler,
    FutureOr<rust_js.AidokuJsResponse> Function(rust_js.AidokuJsRequest)?
        jsHandler,
  }) async {
    AidokuLogger.log(
      'RustRunner',
      'create: instantiating native Rust WASM module for "$sourceKey" (${bytes.length} bytes)...',
    );
    final jsManager = AidokuJsManager();
    final rustSource = await rust.AidokuSource.create(
      wasmBytes: bytes,
      sourceKey: sourceKey,
      requestHandler: requestHandler,
      printHandler: (msg) {
        AidokuLogger.log('RustRunner:WasmPrint', msg);
        printHandler?.call(msg);
      },
      jsHandler: (req) async {
        if (jsHandler != null) {
          return await jsHandler(req);
        }
        return await jsManager.handleJsRequest(req);
      },
    );

    final rawFeatures = await rustSource.features();
    final sourceFeatures = SourceFeatures(
      providesListings: rawFeatures.providesListings,
      providesHome: rawFeatures.providesHome,
      dynamicFilters: rawFeatures.dynamicFilters,
      dynamicSettings: rawFeatures.dynamicSettings,
      dynamicListings: rawFeatures.dynamicListings,
      processesPages: rawFeatures.processesPages,
      providesImageRequests: rawFeatures.providesImageRequests,
      providesBaseUrl: rawFeatures.providesBaseUrl,
      handlesDeepLinks: rawFeatures.handlesDeepLinks,
      handlesBasicLogin: rawFeatures.handlesBasicLogin,
      handlesWebLogin: rawFeatures.handlesWebLogin,
      handlesMigration: rawFeatures.handlesMigration,
    );

    AidokuLogger.log(
      'RustRunner',
      'create: initialized native Rust source "$sourceKey"',
    );
    return AidokuRustRunner._(rustSource, sourceFeatures, jsManager);
  }

  @override
  Future<MangaPageResult> getSearchMangaList(
    String? query,
    int page,
    List<FilterValue> filters,
  ) async {
    AidokuLogger.log(
      'RustRunner',
      'getSearchMangaList: query="$query", page=$page, filters=${filters.length}',
    );
    final rustFilters = filters.map(_toAidokuFilterValue).toList();
    final res = await _rustSource.searchMangaList(
      query: query,
      page: page,
      filters: rustFilters,
    );
    return _mapMangaPage(res);
  }

  @override
  Future<Manga> getMangaUpdate(
    Manga manga, {
    bool needsDetails = false,
    bool needsChapters = false,
  }) async {
    AidokuLogger.log(
      'RustRunner',
      'getMangaUpdate: manga="${manga.title}" (key: ${manga.key}), details=$needsDetails, chapters=$needsChapters',
    );
    final rustManga = _toAidokuManga(manga);
    final res = await _rustSource.getMangaUpdate(
      manga: rustManga,
      needsDetails: needsDetails,
      needsChapters: needsChapters,
    );
    return _mapManga(res);
  }

  @override
  Future<List<Page>> getPageList(Manga manga, Chapter chapter) async {
    AidokuLogger.log(
      'RustRunner',
      'getPageList: manga="${manga.title}", chapter="${chapter.title}" (${chapter.chapterNumber})',
    );
    final rustManga = _toAidokuManga(manga);
    final rustChapter = _toAidokuChapter(chapter);
    final pages = await _rustSource.getPageList(
      manga: rustManga,
      chapter: rustChapter,
    );
    return pages.map(_mapPage).toList();
  }

  @override
  Future<MangaPageResult> getMangaList(Listing listing, int page) async {
    AidokuLogger.log(
      'RustRunner',
      'getMangaList: listing="${listing.name}" (id: ${listing.id}), page=$page',
    );
    final res = await _rustSource.getMangaList(
      listingId: listing.id,
      listingName: listing.name,
      page: page,
    );
    return _mapMangaPage(res);
  }

  @override
  Future<Home> getHome() async {
    AidokuLogger.log('RustRunner', 'getHome: not supported natively in Rust, returning empty home');
    return Home(components: const []);
  }

  @override
  Future<Uint8List?> processPageImage(
    Response response, {
    PageContext? context,
  }) async {
    AidokuLogger.log('RustRunner', 'processPageImage: returning null');
    return null;
  }

  @override
  Future<ImageRequestResult?> getImageRequest(
    String url, {
    PageContext? context,
  }) async {
    if (!features.providesImageRequests) return null;
    AidokuLogger.log('RustRunner', 'getImageRequest: url="$url"');
    final ctxEntries = context?.entries
        .map((e) => (e.key, e.value))
        .toList();
    final res = await _rustSource.getImageRequest(
      url: url,
      context: ctxEntries,
    );
    if (res == null) return null;
    return ImageRequestResult(
      url: res.url,
      headers: Map.fromEntries(res.headers.map((e) => MapEntry(e.$1, e.$2))),
      body: res.body != null ? Uint8List.fromList(res.body!) : null,
    );
  }

  @override
  Future<List<Filter>> getSearchFilters() async {
    AidokuLogger.log('RustRunner', 'getSearchFilters: fetching filters');
    final filters = await _rustSource.getFilters();
    return filters.map(_mapFilter).toList();
  }

  @override
  Future<List<Setting>> getSettings() async {
    AidokuLogger.log('RustRunner', 'getSettings: returning empty');
    return const [];
  }

  @override
  Future<List<Listing>> getListings() async {
    AidokuLogger.log('RustRunner', 'getListings: fetching listings');
    final listings = await _rustSource.getListings();
    return listings.map(_mapListing).toList();
  }

  @override
  Future<String?> getBaseUrl() async {
    AidokuLogger.log('RustRunner', 'getBaseUrl: fetching base URL');
    return await _rustSource.getBaseUrl();
  }

  @override
  Future<DeepLinkResult?> handleDeepLink(String url) async {
    AidokuLogger.log('RustRunner', 'handleDeepLink: url="$url"');
    final res = await _rustSource.handleDeepLink(url: url);
    if (res == null) return null;
    return DeepLinkResult(
      mangaKey: res.mangaKey,
      chapterKey: res.chapterKey,
      listing: res.listing != null ? _mapListing(res.listing!) : null,
    );
  }

  @override
  Future<bool> handleBasicLogin(
    String key,
    String username,
    String password,
  ) async {
    AidokuLogger.log('RustRunner', 'handleBasicLogin: key="$key", user="$username"');
    return await _rustSource.handleBasicLogin(
      key: key,
      username: username,
      password: password,
    );
  }

  @override
  Future<bool> handleWebLogin(String key, Map<String, String> cookies) async {
    AidokuLogger.log('RustRunner', 'handleWebLogin: key="$key"');
    final cookieList = cookies.entries.map((e) => (e.key, e.value)).toList();
    return await _rustSource.handleWebLogin(key: key, cookies: cookieList);
  }

  @override
  Future<String> handleMigration(
    int kind,
    String mangaKey,
    String? chapterKey,
  ) async {
    AidokuLogger.log(
      'RustRunner',
      'handleMigration: kind=$kind, mangaKey="$mangaKey", chapterKey="$chapterKey"',
    );
    return await _rustSource.handleMigration(
      kind: kind,
      mangaKey: mangaKey,
      chapterKey: chapterKey,
    );
  }

  @override
  void dispose() {
    AidokuLogger.log('RustRunner', 'dispose: disposing Rust source');
    _rustSource.dispose();
    _jsManager.dispose();
  }

  // --- Static Mapping Helpers ---

  static MangaPageResult _mapMangaPage(rust.AidokuMangaPage p) {
    return MangaPageResult(
      entries: p.entries.map(_mapManga).toList(),
      hasNextPage: p.hasNextPage,
    );
  }

  static Manga _mapManga(rust.AidokuManga m) {
    return Manga(
      key: m.key,
      title: m.title,
      cover: m.cover,
      artists: m.artists,
      authors: m.authors,
      description: m.description,
      url: m.url,
      tags: m.tags,
      status: PublishingStatus.fromValue(m.status),
      contentRating: ContentRating.fromValue(m.contentRating),
      viewer: Viewer.fromValue(m.viewer),
      updateStrategy: UpdateStrategy.fromValue(m.updateStrategy),
      nextUpdateTime: m.nextUpdateTime?.toInt(),
      chapters: m.chapters?.map(_mapChapter).toList(),
    )..sourceKey = m.sourceKey;
  }

  static Chapter _mapChapter(rust.AidokuChapter c) {
    return Chapter(
      key: c.key,
      title: c.title,
      chapterNumber: c.chapterNumber,
      volumeNumber: c.volumeNumber,
      dateUploaded: c.dateUploaded != null
          ? DateTime.fromMillisecondsSinceEpoch(
              c.dateUploaded!.toInt() * 1000,
            )
          : null,
      scanlators: c.scanlators,
      url: c.url,
      language: c.language,
      thumbnail: c.thumbnail,
      locked: c.locked,
    );
  }

  static rust.AidokuManga _toAidokuManga(Manga m) {
    return rust.AidokuManga(
      sourceKey: m.sourceKey ?? '',
      key: m.key,
      title: m.title,
      cover: m.cover,
      artists: m.artists,
      authors: m.authors,
      description: m.description,
      url: m.url,
      tags: m.tags,
      status: m.status.value,
      contentRating: m.contentRating.value,
      viewer: m.viewer.value,
      updateStrategy: m.updateStrategy.value,
      nextUpdateTime: m.nextUpdateTime,
      chapters: m.chapters?.map(_toAidokuChapter).toList(),
    );
  }

  static rust.AidokuChapter _toAidokuChapter(Chapter c) {
    return rust.AidokuChapter(
      key: c.key,
      title: c.title,
      chapterNumber: c.chapterNumber,
      volumeNumber: c.volumeNumber,
      dateUploaded: c.dateUploaded != null
          ? c.dateUploaded!.millisecondsSinceEpoch ~/ 1000
          : null,
      scanlators: c.scanlators,
      url: c.url,
      language: c.language,
      thumbnail: c.thumbnail,
      locked: c.locked,
    );
  }

  static rust.AidokuFilterValue _toAidokuFilterValue(FilterValue f) {
    if (f is FilterValueSelect) {
      return rust.AidokuFilterValue.select(id: f.id, value: f.value);
    } else if (f is FilterValueMultiSelect) {
      return rust.AidokuFilterValue.multiSelect(
        id: f.id,
        included: f.included,
        excluded: f.excluded,
      );
    } else if (f is FilterValueSort) {
      return rust.AidokuFilterValue.sort(
        id: f.value.id,
        index: f.value.index,
        ascending: f.value.ascending,
      );
    } else if (f is FilterValueCheck) {
      return rust.AidokuFilterValue.check(
        id: f.id,
        value: f.value,
      );
    } else if (f is FilterValueText) {
      return rust.AidokuFilterValue.text(id: f.id, value: f.value);
    } else if (f is FilterValueRange) {
      return rust.AidokuFilterValue.range(id: f.id, from: f.from, to: f.to);
    }
    return rust.AidokuFilterValue.text(id: f.id, value: '');
  }

  static Page _mapPage(rust.AidokuPage p) {
    return p.when(
      url: (url, context) {
        final ctx = context.isNotEmpty
            ? Map.fromEntries(context.map((e) => MapEntry(e.$1, e.$2)))
            : null;
        return Page(content: PageContentUrl(url: url, context: ctx));
      },
      text: (text) => Page(content: PageContentText(text)),
      image: (data) =>
          Page(content: PageContentImage(imageRef: 0, imageData: data)),
      zipFile: (url, filePath) =>
          Page(content: PageContentZipFile(url: url, filePath: filePath)),
    );
  }

  static Listing _mapListing(rust.AidokuListing l) {
    return Listing(
      id: l.id,
      name: l.name,
      kind: l.isList ? ListingKind.list : ListingKind.defaultKind,
    );
  }

  static Filter _mapFilter(rust.AidokuFilter f) {
    FilterTypeConfig config;
    switch (f.kind) {
      case 'select':
        config = FilterTypeSelect(
          SelectFilter(options: f.options, defaultValue: f.defaultValue),
        );
        break;
      case 'multi-select':
        config = FilterTypeMultiSelect(
          MultiSelectFilter(options: f.options),
        );
        break;
      case 'sort':
        config = FilterTypeSort(options: f.options);
        break;
      case 'check':
        config = FilterTypeCheck(
          defaultValue: f.defaultValue == 'true' || f.defaultValue == '1',
        );
        break;
      case 'text':
        config = FilterTypeText();
        break;
      default:
        config = FilterTypeNote(f.title ?? '');
    }
    return Filter(id: f.id, title: f.title, config: config);
  }
}
