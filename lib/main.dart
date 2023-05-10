// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';
import 'dart:io';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download_model.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:mangayomi/views/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/views/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/views/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/views/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:path_provider/path_provider.dart';

late Isar isar;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initDB();
  runApp(const ProviderScope(child: MyApp()));
}

_initDB() async {
  if (Platform.isAndroid || Platform.isIOS) {
    await Hive.initFlutter();
    await FastCachedImageConfig.init();
  } else {
    await Hive.initFlutter("Mangayomi/databases");
    await FastCachedImageConfig.init(subDir: "Mangayomi/databases");
  }
  final dir = await getApplicationDocumentsDirectory();
  if (Platform.isAndroid || Platform.isIOS) {
    isar = Isar.openSync(
      [MangaSchema, ChapterSchema, CategorySchema, HistorySchema],
      directory: dir.path,
    );
  } else {
    isar = await Isar.open(
        [MangaSchema, ChapterSchema, CategorySchema, HistorySchema],
        directory: "${dir.path}/Mangayomi/databases", name: "mangayomiDb");
  }
  Hive.registerAdapter(SourceModelAdapter());
  Hive.registerAdapter(ReaderModeAdapter());
  Hive.registerAdapter(TypeSourceAdapter());
  Hive.registerAdapter(DownloadModelAdapter());
  await Hive.openBox<ReaderMode>(HiveConstant.hiveBoxReaderMode);
  await Hive.openBox<SourceModel>(HiveConstant.hiveBoxMangaSource);
  await Hive.openBox<DownloadModel>(HiveConstant.hiveBoxDownloads);
  await Hive.openBox(HiveConstant.hiveBoxAppSettings);
  await Hive.openBox(HiveConstant.hiveBoxMangaInfo);
}

_iniDateFormatting() {
  initializeDateFormatting("en", null);
  initializeDateFormatting("fr", null);
  initializeDateFormatting("ar", null);
  initializeDateFormatting("es", null);
  initializeDateFormatting("pt", null);
  initializeDateFormatting("ru", null);
  initializeDateFormatting("hi", null);
  initializeDateFormatting("id", null);
  initializeDateFormatting("it", null);
  initializeDateFormatting("de", null);
  initializeDateFormatting("ja", null);
  initializeDateFormatting("zh", null);
  initializeDateFormatting("pl", null);
  initializeDateFormatting("tr", null);
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    _iniDateFormatting();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final isThemeLight = ref.watch(themeModeStateProvider);
    final blendLevel = ref.watch(blendLevelStateProvider);
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
    return MaterialApp.router(
      darkTheme: themeDark,
      themeMode: isThemeLight ? ThemeMode.light : ThemeMode.dark,
      theme: themeLight,
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      title: 'MangaYomi',
    );
  }
}
