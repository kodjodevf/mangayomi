import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/manga_type.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/views/browse/browse_screen.dart';
import 'package:mangayomi/views/browse/extension/extension_lang.dart';
import 'package:mangayomi/views/general/general_screen.dart';
import 'package:mangayomi/views/history/history_screen.dart';
import 'package:mangayomi/views/library/library_screen.dart';
import 'package:mangayomi/views/manga/detail/manga_reader_detail.dart';
import 'package:mangayomi/views/manga/home/home.dart';
import 'package:mangayomi/views/manga/reader/manga_reader_view.dart';
import 'package:mangayomi/views/more/more_screen.dart';
import 'package:mangayomi/views/updates/updates_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = AsyncRouterNotifier();

  return GoRouter(
    initialLocation: '/library',
    debugLogDiagnostics: false,
    refreshListenable: router,
    routes: router._routes,
  );
});

class AsyncRouterNotifier extends ChangeNotifier {
  List<RouteBase> get _routes => [
        ShellRoute(
            builder: (context, state, child) => GeneralScreen(child: child),
            routes: [
              GoRoute(
                name: "library",
                path: '/library',
                builder: (context, state) => const LibraryScreen(),
                pageBuilder: (context, state) => CustomTransition(
                  key: state.pageKey,
                  child: const LibraryScreen(),
                ),
              ),
              GoRoute(
                name: "updates",
                path: '/updates',
                builder: (context, state) => const UpdatesScreen(),
                pageBuilder: (context, state) => CustomTransition(
                  key: state.pageKey,
                  child: const UpdatesScreen(),
                ),
              ),
              GoRoute(
                name: "history",
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
                pageBuilder: (context, state) => CustomTransition(
                  key: state.pageKey,
                  child: const HistoryScreen(),
                ),
              ),
              GoRoute(
                name: "browse",
                path: '/browse',
                builder: (context, state) => const BrowseScreen(),
                pageBuilder: (context, state) => CustomTransition(
                  key: state.pageKey,
                  child: const BrowseScreen(),
                ),
              ),
              GoRoute(
                name: "more",
                path: '/more',
                builder: (context, state) => const MoreScreen(),
                pageBuilder: (context, state) => CustomTransition(
                  key: state.pageKey,
                  child: const MoreScreen(),
                ),
              ),
            ]),
        GoRoute(
            path: "/mangaHome",
            name: "mangaHome",
            builder: (context, state) {
              final mangaType = state.extra as MangaType?;
              return MangaHomeScreen(
                mangaType: mangaType!,
              );
            },
            pageBuilder: (context, state) {
              final mangaType = state.extra as MangaType?;
              return CustomTransition(
                key: state.pageKey,
                child: MangaHomeScreen(
                  mangaType: mangaType!,
                ),
              );
            }),
        GoRoute(
            path: '/manga-reader/detail',
            builder: (context, state) {
              ModelManga? model;

              model = state.extra as ModelManga;

              return MangaReaderDetail(
                modelManga: model,
              );
            },
            pageBuilder: (context, state) {
              ModelManga? model;

              model = state.extra as ModelManga;

              return CustomTransition(
                  key: state.pageKey,
                  child: MangaReaderDetail(
                    modelManga: model,
                  ));
            }),
        GoRoute(
          path: "/mangareaderview",
          name: "mangareaderview",
          builder: (context, state) {
            final mangaReaderModel = state.extra as MangaReaderModel;
            return MangaReaderView(
              mangaReaderModel: mangaReaderModel,
            );
          },
          pageBuilder: (context, state) {
            final mangaReaderModel = state.extra as MangaReaderModel;
            return CustomTransition(
              key: state.pageKey,
              child: MangaReaderView(
                mangaReaderModel: mangaReaderModel,
              ),
            );
          },
        ),
        GoRoute(
          path: "/extensionLang",
          name: "extensionLang",
          builder: (context, state) {
            return const ExtensionsLang();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const ExtensionsLang(),
            );
          },
        ),
      ];
}

class CustomTransition extends CustomTransitionPage {
  CustomTransition({required LocalKey key, required Widget child})
      : super(
          key: key,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: child,
        );
}
