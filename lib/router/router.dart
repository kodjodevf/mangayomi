import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/manga_type.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/services/webview.dart';
import 'package:mangayomi/views/browse/browse_screen.dart';
import 'package:mangayomi/views/browse/extension/extension_lang.dart';
import 'package:mangayomi/views/browse/global_search_screen.dart';
import 'package:mangayomi/views/general/general_screen.dart';
import 'package:mangayomi/views/history/history_screen.dart';
import 'package:mangayomi/views/library/library_screen.dart';
import 'package:mangayomi/views/manga/detail/manga_reader_detail.dart';
import 'package:mangayomi/views/manga/home/manga_home_screen.dart';
import 'package:mangayomi/views/manga/home/manga_search_screen.dart';
import 'package:mangayomi/views/manga/reader/manga_reader_view.dart';
import 'package:mangayomi/views/more/about_screen.dart';
import 'package:mangayomi/views/more/download_queue/download_queue_screen.dart';
import 'package:mangayomi/views/more/more_screen.dart';
import 'package:mangayomi/views/more/settings/appearance/appearance_screen.dart';
import 'package:mangayomi/views/more/settings/categoties/categories_screen.dart';
import 'package:mangayomi/views/more/settings/settings_screen.dart';
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
              int mangaId = state.extra as int;

              return MangaReaderDetail(
                mangaId: mangaId,
              );
            },
            pageBuilder: (context, state) {
              int mangaId = state.extra as int;

              return CustomTransition(
                  key: state.pageKey,
                  child: MangaReaderDetail(
                    mangaId: mangaId,
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
        GoRoute(
          path: "/settings",
          name: "settings",
          builder: (context, state) {
            return const SettingsScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const SettingsScreen(),
            );
          },
        ),
        GoRoute(
          path: "/appearance",
          name: "appearance",
          builder: (context, state) {
            return const AppearanceScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const AppearanceScreen(),
            );
          },
        ),
        GoRoute(
          path: "/globalSearch",
          name: "globalSearch",
          builder: (context, state) {
            return const GlobalSearchScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const GlobalSearchScreen(),
            );
          },
        ),
        GoRoute(
          path: "/searchResult",
          name: "searchResult",
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            return SearchResultScreen(
              query: data['query']!,
              lang: data['lang']!,
              source: data['source']!,
              viewOnly: data['viewOnly'],
            );
          },
          pageBuilder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            return CustomTransition(
              key: state.pageKey,
              child: SearchResultScreen(
                query: data['query']!,
                lang: data['lang']!,
                source: data['source']!,
                viewOnly: data['viewOnly'],
              ),
            );
          },
        ),
        GoRoute(
          path: "/about",
          name: "about",
          builder: (context, state) {
            return const AboutScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const AboutScreen(),
            );
          },
        ),
        GoRoute(
          path: "/downloadQueue",
          name: "downloadQueue",
          builder: (context, state) {
            return const DownloadQueueScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const DownloadQueueScreen(),
            );
          },
        ),
        GoRoute(
          path: "/mangawebview",
          name: "mangawebview",
          builder: (context, state) {
            final data = state.extra as Map<String, String>;
            return MangaWebView(
              url: data["url"]!,
              source: data["source"]!,
            );
          },
          pageBuilder: (context, state) {
            final data = state.extra as Map<String, String>;
            return CustomTransition(
              key: state.pageKey,
              child: MangaWebView(
                url: data["url"]!,
                source: data["source"]!,
              ),
            );
          },
        ),
        GoRoute(
          path: "/categories",
          name: "categories",
          builder: (context, state) {
            return const CategoriesScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const CategoriesScreen(),
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
