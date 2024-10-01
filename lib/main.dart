import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/app_font_family.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mangayomi/src/rust/frb_generated.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

late Isar isar;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await RustLib.init();
  if (!(Platform.isAndroid || Platform.isIOS)) {
    await windowManager.ensureInitialized();
  }

  isar = await StorageProvider().initDB(null, inspector: kDebugMode);
  await StorageProvider().requestPermission();
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
  @override
  void initState() {
    iniDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final syncOnAppLaunch = ref.watch(syncOnAppLaunchStateProvider);
    if (syncOnAppLaunch) {
      ref.read(syncServerProvider(syncId: 1).notifier).checkForSync(true);
    }
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
        dialogBackgroundSchemeColor: SchemeColor.background,
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
        dialogBackgroundSchemeColor: SchemeColor.background,
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
}
