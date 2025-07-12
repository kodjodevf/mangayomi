import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/storage_usage.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/src/rust/frb_generated.dart';
import 'package:mangayomi/utils/url_protocol/api.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_provider.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path/path.dart' as p;

late Isar isar;
WebViewEnvironment? webViewEnvironment;
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux && runWebViewTitleBarWidget(args)) return;
  MediaKit.ensureInitialized();
  await RustLib.init();
  if (!(Platform.isAndroid || Platform.isIOS)) {
    await windowManager.ensureInitialized();
  }
  if (Platform.isWindows) {
    registerProtocolHandler("mangayomi");
  }
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    final availableVersion = await WebViewEnvironment.getAvailableVersion();
    if (availableVersion != null) {
      final document = await getApplicationDocumentsDirectory();
      webViewEnvironment = await WebViewEnvironment.create(
        settings: WebViewEnvironmentSettings(
          userDataFolder: p.join(document.path, 'flutter_inappwebview'),
        ),
      );
    }
  }
  isar = await StorageProvider().initDB(null, inspector: kDebugMode);
  if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
    await Hive.initFlutter("databases");
  } else {
    await Hive.initFlutter(p.join("Mangayomi", "databases"));
  }
  Hive.registerAdapter(TrackSearchAdapter());

  runApp(const ProviderScope(child: MyApp()));
  unawaited(_postLaunchInit()); // Defer non-essential async operations
}

Future<void> _postLaunchInit() async {
  await StorageProvider().requestPermission();
  await StorageProvider().deleteBtDirectory();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  Uri? lastUri;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _initDeepLinks();
    unawaited(ref.read(scanLocalLibraryProvider.future));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(clearChapterCacheOnAppLaunchStateProvider)) {
        ref
            .read(totalChapterCacheSizeStateProvider.notifier)
            .clearCache(showToast: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final followSystem = ref.watch(followSystemThemeStateProvider);
    final forcedDark = ref.watch(themeModeStateProvider);
    final themeMode = followSystem
        ? ThemeMode.system
        : (forcedDark ? ThemeMode.dark : ThemeMode.light);
    final locale = ref.watch(l10nLocaleStateProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: BotToastInit(),
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      title: 'MangaYomi',
      scrollBehavior: AllowScrollBehavior(),
    );
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (uri == lastUri) return; // Debouncing Deep Links
      lastUri = uri;
      switch (uri.host) {
        case "add-repo":
          final repoName = uri.queryParameters["repo_name"];
          final repoUrl = uri.queryParameters["repo_url"];
          final mangaRepoUrls = uri.queryParametersAll["manga_url"];
          final animeRepoUrls = uri.queryParametersAll["anime_url"];
          final novelRepoUrls = uri.queryParametersAll["novel_url"];
          final context = navigatorKey.currentContext;
          if (context == null || !context.mounted) return;
          final l10n = context.l10n;
          showDialog(
            context: navigatorKey.currentContext!,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(l10n.add_repo),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${l10n.name}: ${repoName ?? 'Unknown'}"),
                    const SizedBox(height: 8),
                    Text("URL: ${repoUrl ?? 'Unknown'}"),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text(l10n.cancel),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FilledButton(
                    child: Text(l10n.add),
                    onPressed: () async {
                      if (context.mounted) Navigator.of(context).pop();

                      final validUrls = await _checkValidUrls([
                        ...mangaRepoUrls ?? [],
                        ...animeRepoUrls ?? [],
                        ...novelRepoUrls ?? [],
                      ]);

                      if (!validUrls) {
                        botToast(l10n.unsupported_repo);
                        return;
                      }

                      void addRepos(ItemType type, List<String>? urls) {
                        if (urls == null) return;
                        final current = ref.read(
                          extensionsRepoStateProvider(type),
                        );
                        final updated = [
                          ...current,
                          ...urls.map(
                            (e) => Repo(
                              name: repoName,
                              jsonUrl: e,
                              website: repoUrl,
                            ),
                          ),
                        ];
                        ref
                            .read(extensionsRepoStateProvider(type).notifier)
                            .set(updated);
                      }

                      addRepos(ItemType.manga, mangaRepoUrls);
                      addRepos(ItemType.anime, animeRepoUrls);
                      addRepos(ItemType.novel, novelRepoUrls);
                      botToast(l10n.repo_added);
                    },
                  ),
                ],
              );
            },
          );
          break;
        default:
      }
    });
  }

  Future<bool> _checkValidUrls(List<String> urls) async {
    final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
    for (final url in urls) {
      final req = await http.get(Uri.parse(url));
      try {
        final sourceList = (jsonDecode(req.body) as List).map(
          (e) => Source.fromJson(e),
        );
        if (sourceList.firstOrNull?.name == null) {
          return false;
        }
      } catch (err) {
        return false;
      }
    }
    return true;
  }
}

class AllowScrollBehavior extends MaterialScrollBehavior {
  // This allows the scrollable widgets to be scrolled with touch, mouse, stylus,
  // inverted stylus, trackpad, and unknown pointer devices.
  // This is useful for accessibility purposes, such as when using VoiceAccess,
  // which sends pointer events with unknown type when scrolling scrollables.
  // This is also useful for desktop platforms, where touch, stylus, and trackpad
  // interactions are common, and we want to ensure a consistent scrolling experience
  // across all devices.
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.unknown,
  };
}
