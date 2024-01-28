import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mangayomi/messages/generated.dart';
import 'package:window_manager/window_manager.dart';

// Global instance of the Isar database.
late Isar isar;

/// Overrides the default HTTP client to allow all certificates
class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

/// Entry point of the application.
void main(List<String> args) async {
  await Rinf.initialize();
  // Override the default HTTP client.
  HttpOverrides.global = MyHttpoverrides();
  // If running on desktop platforms and web view title bar widget is active, exit.
  if (Platform.isLinux || Platform.isWindows) {
    if (runWebViewTitleBarWidget(args)) {
      return;
    }
  }
  // Ensure widget and media kits are initialized.
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  if (!(Platform.isAndroid || Platform.isIOS)) {
    await windowManager.ensureInitialized();
  }

  // Initialize the Isar database.
  isar = await StorageProvider().initDB(null, inspector: kDebugMode);
  await StorageProvider().requestPermission();

  // Start the app.
  runApp(const ProviderScope(child: MyApp()));
}

/// Initialize date formatting based on available locales.
iniDateFormatting() {
  initializeDateFormatting();
  final supportedLocales = DateFormat.allLocalesWithSymbols();
  for (var locale in supportedLocales) {
    initializeDateFormatting(locale);
  }
}

/// The main app widget. This is a `ConsumerStatefulWidget` which allows it to consume
/// providers from the `flutter_riverpod` package.
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    // Initialize date formatting upon app start.
    iniDateFormatting();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Retrieve theme settings, localization settings, and router from providers.
    // Define light and dark theme data.
    final isDarkTheme = ref.watch(themeModeStateProvider);
    final blendLevel = ref.watch(blendLevelStateProvider);
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
        dialogBackgroundSchemeColor: SchemeColor.background,
      ),
      useMaterial3ErrorColors: true,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      fontFamily: GoogleFonts.aBeeZee().fontFamily,
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
        dialogBackgroundSchemeColor: SchemeColor.background,
      ),
      useMaterial3ErrorColors: true,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      fontFamily: GoogleFonts.aBeeZee().fontFamily,
    );
    final router = ref.watch(routerProvider);
    // Return the main MaterialApp with router, themes, and localization settings.
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
}
