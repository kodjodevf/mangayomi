import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/storage_usage.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/app_font_family.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mangayomi/src/rust/frb_generated.dart';
import 'package:mangayomi/utils/url_protocol/api.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path/path.dart' as p;

late Isar isar;
WebViewEnvironment? webViewEnvironment;
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux) {
    if (runWebViewTitleBarWidget(args)) {
      return;
    }
  }
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
              userDataFolder: p.join(document.path, 'flutter_inappwebview')));
    }
  }
  isar = await StorageProvider().initDB(null, inspector: kDebugMode);
  await StorageProvider().requestPermission();
  await StorageProvider().deleteBtDirectory();
  GoogleFonts.aBeeZee();

  runApp(const ProviderScope(child: MyApp()));
}

void iniDateFormatting() {
  initializeDateFormatting();
  final supportedLocales = DateFormat.allLocalesWithSymbols();
  for (var locale in supportedLocales) {
    initializeDateFormatting(locale);
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    iniDateFormatting();
    initDeepLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(clearChapterCacheOnAppLaunchStateProvider)) {
        ref
            .read(totalChapterCacheSizeStateProvider.notifier)
            .clearCache(showToast: false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeModeStateProvider);
    final blendLevel = ref.watch(blendLevelStateProvider);
    final appFontFamily = ref.watch(appFontFamilyProvider);
    final pureBlackDarkMode = ref.watch(pureBlackDarkModeStateProvider);
    final locale = ref.watch(l10nLocaleStateProvider);
    ThemeData themeLight = FlexThemeData.light(
      colors: ref.watch(flexSchemeColorStateProvider),
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: blendLevel.toInt(),
      appBarOpacity: 0.00,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        thinBorderWidth: 2.0,
        unselectedToggleIsColored: true,
        inputDecoratorRadius: 24.0,
        chipRadius: 24.0,
      ),
      useMaterial3ErrorColors: true,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      fontFamily: appFontFamily,
    );
    ThemeData themeDark = FlexThemeData.dark(
      colors: ref.watch(flexSchemeColorStateProvider),
      surfaceMode: FlexSurfaceMode.level,
      blendLevel: blendLevel.toInt(),
      appBarOpacity: 0.00,
      scaffoldBackground: pureBlackDarkMode ? Colors.black : null,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        thinBorderWidth: 2.0,
        unselectedToggleIsColored: true,
        inputDecoratorRadius: 24.0,
        chipRadius: 24.0,
      ),
      useMaterial3ErrorColors: true,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      fontFamily: appFontFamily,
    );
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      darkTheme: themeDark,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: themeLight,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: BotToastInit(),
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      title: 'MangaYomi',
    );
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    final l10n = l10nLocalizations(context);
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      switch (uri.host) {
        case "add-repo":
          final repoName = uri.queryParameters["repo_name"];
          final repoUrl = uri.queryParameters["repo_url"];
          final mangaRepoUrls = uri.queryParametersAll["manga_url"];
          final animeRepoUrls = uri.queryParametersAll["anime_url"];
          final novelRepoUrls = uri.queryParametersAll["novel_url"];
          if (mangaRepoUrls != null) {
            final mangaRepos =
                ref.read(extensionsRepoStateProvider(ItemType.manga)).toList();
            mangaRepos.addAll(mangaRepoUrls.map(
                (e) => Repo(name: repoName, jsonUrl: e, website: repoUrl)));
            ref
                .read(extensionsRepoStateProvider(ItemType.manga).notifier)
                .set(mangaRepos);
          }
          if (animeRepoUrls != null) {
            final animeRepos =
                ref.read(extensionsRepoStateProvider(ItemType.anime)).toList();
            animeRepos.addAll(animeRepoUrls.map(
                (e) => Repo(name: repoName, jsonUrl: e, website: repoUrl)));
            ref
                .read(extensionsRepoStateProvider(ItemType.anime).notifier)
                .set(animeRepos);
          }
          if (novelRepoUrls != null) {
            final novelRepos =
                ref.read(extensionsRepoStateProvider(ItemType.novel)).toList();
            novelRepos.addAll(novelRepoUrls.map(
                (e) => Repo(name: repoName, jsonUrl: e, website: repoUrl)));
            ref
                .read(extensionsRepoStateProvider(ItemType.novel).notifier)
                .set(novelRepos);
          }
          botToast(l10n?.repo_added ?? "Source repository added!");
          break;
        default:
      }
    });
  }
}
