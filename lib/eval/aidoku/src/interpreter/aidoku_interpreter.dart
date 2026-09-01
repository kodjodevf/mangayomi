import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:wasd/wasd.dart';

import '../imports/canvas.dart';
import '../imports/defaults.dart';
import '../imports/env.dart';
import '../imports/html.dart';
import '../imports/js.dart';
import '../imports/net.dart';
import '../imports/std.dart';
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
import '../models/source_error.dart';
import '../models/source_features.dart';
import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';
import '../store/global_store.dart';
import 'memory_helper.dart';
import 'runner.dart';

/// Configuration for initializing an [AidokuInterpreter].
class InterpreterConfiguration {
  const InterpreterConfiguration({
    this.printHandler,
    this.partialResultHandler,
    this.requestHandler,
  });

  final void Function(String message)? printHandler;
  final void Function(Uint8List data)? partialResultHandler;
  final Future<http.Response> Function(http.Request request)? requestHandler;
}

/// Pure-Dart execution engine for Aidoku WebAssembly source modules.
class AidokuInterpreter implements AidokuRunner {
  AidokuInterpreter._({
    required this.sourceKey,
    required this.bytes,
    required this.config,
    required this._instance,
    required this._store,
    required this._memoryHelper,
    required this._features,
  });

  final String sourceKey;
  final Uint8List bytes;
  final InterpreterConfiguration config;

  final Instance _instance;
  final GlobalStore _store;
  final MemoryHelper _memoryHelper;
  final SourceFeatures _features;

  @override
  SourceFeatures get features => _features;

  /// Compiles and instantiates an Aidoku WASM binary module.
  static Future<AidokuInterpreter> create({
    required Uint8List bytes,
    String sourceKey = '',
    InterpreterConfiguration config = const InterpreterConfiguration(),
  }) async {
    final store = GlobalStore();
    late Memory memory;
    final memoryHelper = MemoryHelper(() => memory);

    final std = StdImports(
      store: store,
      memoryHelper: memoryHelper,
      printHandler: config.printHandler,
    );
    final net = NetImports(
      store: store,
      memoryHelper: memoryHelper,
      customRequestHandler: config.requestHandler,
    );
    final html = HtmlImports(store: store, memoryHelper: memoryHelper);
    final defaults = DefaultsImports(
      store: store,
      memoryHelper: memoryHelper,
      defaultNamespace: sourceKey,
    );
    final env = EnvImports(
      memoryHelper: memoryHelper,
      printHandler: config.printHandler,
      partialResultHandler: config.partialResultHandler,
    );
    final canvas = CanvasImports(store: store, memoryHelper: memoryHelper);
    final js = JsImports(
      store: store,
      memoryHelper: memoryHelper,
      webViewNamespace: sourceKey,
      printHandler: config.printHandler,
    );

    final imports = <String, ModuleImports>{
      StdImports.namespace: std.build(),
      NetImports.namespace: net.build(),
      HtmlImports.namespace: html.build(),
      DefaultsImports.namespace: defaults.build(),
      EnvImports.namespace: env.build(),
      CanvasImports.namespace: canvas.build(),
      JsImports.namespace: js.build(),
    };

    final wasm = await WebAssembly.instantiate(bytes.buffer, imports);
    final instance = wasm.instance;

    final memExport = instance.exports['memory'];
    if (memExport is MemoryImportExportValue) {
      memory = memExport.ref;
    } else {
      throw StateError('WASM module does not export linear memory');
    }

    final features = SourceFeatures(
      providesListings: instance.exports.containsKey('get_manga_list'),
      providesHome: instance.exports.containsKey('get_home'),
      dynamicFilters: instance.exports.containsKey('get_filters'),
      dynamicSettings: instance.exports.containsKey('get_settings'),
      dynamicListings: instance.exports.containsKey('get_listings'),
      processesPages: instance.exports.containsKey('process_page_image'),
      providesImageRequests: instance.exports.containsKey('get_image_request'),
      providesPageDescriptions: instance.exports.containsKey('get_page_description'),
      providesAlternateCovers: instance.exports.containsKey('get_alternate_covers'),
      providesBaseUrl: instance.exports.containsKey('get_base_url'),
      handlesNotifications: instance.exports.containsKey('handle_notification'),
      handlesDeepLinks: instance.exports.containsKey('handle_deep_link'),
      handlesBasicLogin: instance.exports.containsKey('handle_basic_login'),
      handlesWebLogin: instance.exports.containsKey('handle_web_login'),
      handlesMigration: instance.exports.containsKey('handle_key_migration'),
    );

    final interpreter = AidokuInterpreter._(
      sourceKey: sourceKey,
      bytes: bytes,
      config: config,
      instance: instance,
      store: store,
      memoryHelper: memoryHelper,
      features: features,
    );

    await interpreter._start();
    return interpreter;
  }

  Future<void> _start() async {
    final startFn = _instance.exports['start'];
    if (startFn is FunctionImportExportValue) {
      final res = startFn.ref(const []);
      if (res is Future) await res;
    }
  }

  Future<int> _call(String name, [List<Object?> args = const []]) async {
    final fn = _instance.exports[name];
    if (fn is! FunctionImportExportValue) {
      throw SourceErrorUnimplemented();
    }
    final res = fn.ref(args);
    final val = res is Future ? await res : res;
    return (val as num).toInt();
  }

  Uint8List _handleResult(int result) {
    if (result < 0) {
      throw SourceError.fromCode(result);
    }
    final pointer = result;
    final length = _memoryHelper.readUint32(pointer);

    if (length == 0xFFFFFFFF) {
      final strLen = _memoryHelper.readUint32(pointer + 8) - 12;
      final msg = _memoryHelper.readString(pointer + 12, strLen);
      _freeResult(pointer);
      throw SourceErrorMessage(msg);
    }

    final data = _memoryHelper.readBytes(pointer + 8, length - 8);
    _freeResult(pointer);
    return data;
  }

  void _freeResult(int pointer) {
    final freeFn = _instance.exports['free_result'];
    if (freeFn is FunctionImportExportValue) {
      freeFn.ref([pointer]);
    }
  }

  int _storeString(String val) {
    return _store.store(utf8.encode(val));
  }

  int _storePostcard(void Function(PostcardWriter writer) writeFn) {
    final writer = PostcardWriter();
    writeFn(writer);
    return _store.store(writer.toBytes());
  }

  @override
  Future<MangaPageResult> getSearchMangaList(
    String? query,
    int page,
    List<FilterValue> filters,
  ) async {
    final queryPtr = _storeString(query ?? '');
    final filterPtr = _storePostcard((w) => w.writeList(filters, (w2, f) => f.toPostcard(w2)));

    try {
      final result = await _call('get_search_manga_list', [queryPtr, page, filterPtr]);
      final data = _handleResult(result);
      final res = MangaPageResult.fromPostcard(PostcardReader(data));
      res.setSourceKey(sourceKey);
      return res;
    } finally {
      _store.remove(queryPtr);
      _store.remove(filterPtr);
    }
  }

  @override
  Future<Manga> getMangaUpdate(
    Manga manga, {
    bool needsDetails = false,
    bool needsChapters = false,
  }) async {
    final mangaPtr = _storePostcard((w) => manga.toPostcard(w));
    try {
      final result = await _call('get_manga_update', [
        mangaPtr,
        needsDetails ? 1 : 0,
        needsChapters ? 1 : 0,
      ]);
      final data = _handleResult(result);
      final res = Manga.fromPostcard(PostcardReader(data));
      res.sourceKey = sourceKey;
      return res;
    } finally {
      _store.remove(mangaPtr);
    }
  }

  @override
  Future<List<Page>> getPageList(Manga manga, Chapter chapter) async {
    final copyManga = manga.copyWith(chapters: null);
    final mangaPtr = _storePostcard((w) => copyManga.toPostcard(w));
    final chapterPtr = _storePostcard((w) => chapter.toPostcard(w));

    try {
      final result = await _call('get_page_list', [mangaPtr, chapterPtr]);
      final data = _handleResult(result);
      final reader = PostcardReader(data);
      return reader.readList((r) => Page.fromPostcard(r, _store));
    } finally {
      _store.remove(mangaPtr);
      _store.remove(chapterPtr);
    }
  }

  @override
  Future<MangaPageResult> getMangaList(Listing listing, int page) async {
    final listingPtr = _storePostcard((w) => listing.toPostcard(w));
    try {
      final result = await _call('get_manga_list', [listingPtr, page]);
      final data = _handleResult(result);
      final res = MangaPageResult.fromPostcard(PostcardReader(data));
      res.setSourceKey(sourceKey);
      return res;
    } finally {
      _store.remove(listingPtr);
    }
  }

  @override
  Future<Home> getHome() async {
    final result = await _call('get_home');
    final data = _handleResult(result);
    final home = Home.fromPostcard(PostcardReader(data));
    home.setSourceKey(sourceKey);
    return home;
  }

  @override
  Future<Uint8List?> processPageImage(Response response, {PageContext? context}) async {
    final respPtr = _storePostcard((w) => response.toPostcard(w));
    final ctxPtr = context != null
        ? _storePostcard((w) => w.writeMap(context, (w2, k) => w2.writeString(k), (w2, v) => w2.writeString(v)))
        : -1;

    try {
      final result = await _call('process_page_image', [respPtr, ctxPtr]);
      final data = _handleResult(result);
      final reader = PostcardReader(data);
      final imageRef = reader.readI32();
      final imgBytes = _store.fetchImage(imageRef);
      _store.remove(imageRef);
      return imgBytes;
    } finally {
      _store.remove(respPtr);
      if (ctxPtr >= 0) _store.remove(ctxPtr);
    }
  }

  @override
  Future<List<Filter>> getSearchFilters() async {
    final result = await _call('get_filters');
    final data = _handleResult(result);
    return PostcardReader(data).readList((r) => Filter.fromPostcard(r));
  }

  @override
  Future<List<Setting>> getSettings() async {
    final result = await _call('get_settings');
    final data = _handleResult(result);
    return PostcardReader(data).readList((r) => Setting.fromPostcard(r));
  }

  @override
  Future<List<Listing>> getListings() async {
    final result = await _call('get_listings');
    final data = _handleResult(result);
    return PostcardReader(data).readList((r) => Listing.fromPostcard(r));
  }

  @override
  Future<String?> getBaseUrl() async {
    final result = await _call('get_base_url');
    final data = _handleResult(result);
    return PostcardReader(data).readString();
  }

  @override
  Future<DeepLinkResult?> handleDeepLink(String url) async {
    final urlPtr = _storeString(url);
    try {
      final result = await _call('handle_deep_link', [urlPtr]);
      final data = _handleResult(result);
      return PostcardReader(data).readOption((r) => DeepLinkResult.fromPostcard(r));
    } finally {
      _store.remove(urlPtr);
    }
  }

  @override
  Future<bool> handleBasicLogin(String key, String username, String password) async {
    final keyPtr = _storeString(key);
    final userPtr = _storeString(username);
    final passPtr = _storeString(password);
    try {
      final result = await _call('handle_basic_login', [keyPtr, userPtr, passPtr]);
      final data = _handleResult(result);
      return PostcardReader(data).readBool();
    } finally {
      _store.remove(keyPtr);
      _store.remove(userPtr);
      _store.remove(passPtr);
    }
  }

  @override
  Future<bool> handleWebLogin(String key, Map<String, String> cookies) async {
    final keyPtr = _storeString(key);
    final keys = cookies.keys.toList();
    final values = keys.map((k) => cookies[k] ?? '').toList();
    final keysPtr = _storePostcard((w) => w.writeList(keys, (w2, s) => w2.writeString(s)));
    final valuesPtr = _storePostcard((w) => w.writeList(values, (w2, s) => w2.writeString(s)));

    try {
      final result = await _call('handle_web_login', [keyPtr, keysPtr, valuesPtr]);
      final data = _handleResult(result);
      return PostcardReader(data).readBool();
    } finally {
      _store.remove(keyPtr);
      _store.remove(keysPtr);
      _store.remove(valuesPtr);
    }
  }

  @override
  Future<String> handleMigration(int kind, String mangaKey, String? chapterKey) async {
    final mangaPtr = _storeString(mangaKey);
    final chPtr = chapterKey != null ? _storeString(chapterKey) : -1;
    try {
      final result = await _call('handle_key_migration', [kind, mangaPtr, chPtr]);
      final data = _handleResult(result);
      return PostcardReader(data).readString();
    } finally {
      _store.remove(mangaPtr);
      if (chPtr >= 0) _store.remove(chPtr);
    }
  }

  @override
  void dispose() {
    _store.clear();
  }
}
