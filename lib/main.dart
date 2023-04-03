import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/constant.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/router/router.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ModelMangaAdapter());
  await Hive.openBox<ModelManga>(
    HiveConstant.hiveBoxManga,
  );
  await Hive.openBox(
    HiveConstant.hiveBoxMangaInfo,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: FlexThemeData.light(
        colors: ThemeAA.schemes[6].light,
        surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
        blendLevel: 24,
        appBarOpacity: 0.00,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 24,
          thinBorderWidth: 2.0,
          unselectedToggleIsColored: true,
          inputDecoratorRadius: 24.0,
          chipRadius: 24.0,
          dialogBackgroundSchemeColor: SchemeColor.background,
        ),
        useMaterial3ErrorColors: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      title: 'MangaYomi',
    );
  }
}

class ThemeAA {
  static const List<FlexSchemeData> schemes = <FlexSchemeData>[
    ...FlexColor.schemesList,
  ];
}
