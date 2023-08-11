import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/anime/anime_stream_view.dart';
import 'package:mangayomi/modules/browse/extension/extension_detail.dart';
import 'package:mangayomi/modules/browse/sources/sources_filter_screen.dart';
import 'package:mangayomi/modules/more/categories/categories_screen.dart';
import 'package:mangayomi/modules/more/settings/downloads/downloads_screen.dart';
import 'package:mangayomi/modules/more/settings/track/track.dart';
import 'package:mangayomi/modules/updates/updates_screen.dart';
import 'package:mangayomi/modules/webview/webview.dart';
import 'package:mangayomi/modules/browse/browse_screen.dart';
import 'package:mangayomi/modules/browse/extension/extension_lang.dart';
import 'package:mangayomi/modules/browse/global_search/global_search_screen.dart';
import 'package:mangayomi/modules/main_view/main_screen.dart';
import 'package:mangayomi/modules/history/history_screen.dart';
import 'package:mangayomi/modules/library/library_screen.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_main.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/modules/manga/home/manga_search_screen.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/more/about/about_screen.dart';
import 'package:mangayomi/modules/more/download_queue/download_queue_screen.dart';
import 'package:mangayomi/modules/more/more_screen.dart';
import 'package:mangayomi/modules/more/settings/appearance/appearance_screen.dart';
import 'package:mangayomi/modules/more/settings/browse/browse_screen.dart';
import 'package:mangayomi/modules/more/settings/general/general_screen.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/modules/more/settings/settings_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final router = RouterNotifier();

  return GoRouter(
    observers: [BotToastNavigatorObserver()],
    initialLocation: '/MangaLibrary',
    debugLogDiagnostics: false,
    refreshListenable: router,
    routes: router._routes,
  );
}

@riverpod
class RouterCurrentLocationState extends _$RouterCurrentLocationState {
  @override
  String? build(BuildContext context) {
    _listener();
    return null;
  }

  _listener() {
    final router = GoRouter.of(context);
    router.routerDelegate.addListener(() {
      final RouteMatch lastMatch =
          router.routerDelegate.currentConfiguration.last;
      final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
          ? lastMatch.matches
          : router.routerDelegate.currentConfiguration;
      state = matchList.uri.toString();
    });
  }
}

class RouterNotifier extends ChangeNotifier {
  List<RouteBase> get _routes => [
        ShellRoute(
            builder: (context, state, child) => MainScreen(child: child),
            routes: [
              GoRoute(
                name: "MangaLibrary",
                path: '/MangaLibrary',
                builder: (context, state) => const LibraryScreen(
                  isManga: true,
                ),
                pageBuilder: (context, state) => CustomTransition(
                  key: state.pageKey,
                  child: const LibraryScreen(
                    isManga: true,
                  ),
                ),
              ),
              GoRoute(
                name: "AnimeLibrary",
                path: '/AnimeLibrary',
                builder: (context, state) => const LibraryScreen(
                  isManga: false,
                ),
                pageBuilder: (context, state) => CustomTransition(
                  key: state.pageKey,
                  child: const LibraryScreen(
                    isManga: false,
                  ),
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
          name: "updates",
          path: '/updates',
          builder: (context, state) => const UpdatesScreen(),
          pageBuilder: (context, state) => CustomTransition(
            key: state.pageKey,
            child: const UpdatesScreen(),
          ),
        ),
        GoRoute(
            path: "/mangaHome",
            name: "mangaHome",
            builder: (context, state) {
              final source = state.extra as Source?;
              return MangaHomeScreen(
                source: source!,
              );
            },
            pageBuilder: (context, state) {
              final source = state.extra as Source?;
              return CustomTransition(
                key: state.pageKey,
                child: MangaHomeScreen(
                  source: source!,
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
            final chapter = state.extra as Chapter;
            return MangaReaderView(
              chapter: chapter,
            );
          },
          pageBuilder: (context, state) {
            final chapter = state.extra as Chapter;
            return CustomTransition(
              key: state.pageKey,
              child: MangaReaderView(
                chapter: chapter,
              ),
            );
          },
        ),
        GoRoute(
          path: "/animestreamview",
          name: "animestreamview",
          builder: (context, state) {
            final episode = state.extra as Chapter;
            return AnimeStreamView(
              episode: episode,
            );
          },
          pageBuilder: (context, state) {
            final episode = state.extra as Chapter;
            return CustomTransition(
              key: state.pageKey,
              child: AnimeStreamView(
                episode: episode,
              ),
            );
          },
        ),
        GoRoute(
          path: "/ExtensionLang",
          name: "ExtensionLang",
          builder: (context, state) {
            final isManga = state.extra as bool;
            return ExtensionsLang(
              isManga: isManga,
            );
          },
          pageBuilder: (context, state) {
            final isManga = state.extra as bool;
            return CustomTransition(
              key: state.pageKey,
              child: ExtensionsLang(
                isManga: isManga,
              ),
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
          path: "/extension_detail",
          name: "extension_detail",
          builder: (context, state) {
            final source = state.extra as Source;
            return ExtensionDetail(
              source: source,
            );
          },
          pageBuilder: (context, state) {
            final source = state.extra as Source;
            return CustomTransition(
              key: state.pageKey,
              child: ExtensionDetail(
                source: source,
              ),
            );
          },
        ),
        GoRoute(
          path: "/globalSearch",
          name: "globalSearch",
          builder: (context, state) {
            final isManga = state.extra as bool;
            return GlobalSearchScreen(
              isManga: isManga,
            );
          },
          pageBuilder: (context, state) {
            final isManga = state.extra as bool;
            return CustomTransition(
              key: state.pageKey,
              child: GlobalSearchScreen(
                isManga: isManga,
              ),
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
          path: "/track",
          name: "track",
          builder: (context, state) {
            return const TrackScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const TrackScreen(),
            );
          },
        ),
        GoRoute(
          path: "/sourceFilter",
          name: "sourceFilter",
          builder: (context, state) {
            final isManga = state.extra as bool;
            return SourcesFilterScreen(
              isManga: isManga,
            );
          },
          pageBuilder: (context, state) {
            final isManga = state.extra as bool;
            return CustomTransition(
              key: state.pageKey,
              child: SourcesFilterScreen(
                isManga: isManga,
              ),
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
                sourceId: data["sourceId"]!,
                title: data['title']!);
          },
          pageBuilder: (context, state) {
            final data = state.extra as Map<String, String>;
            return CustomTransition(
              key: state.pageKey,
              child: MangaWebView(
                url: data["url"]!,
                sourceId: data["sourceId"]!,
                title: data['title']!,
              ),
            );
          },
        ),
        GoRoute(
          path: "/categories",
          name: "categories",
          builder: (context, state) {
            final data = state.extra as (bool, int);
            return CategoriesScreen(data: data);
          },
          pageBuilder: (context, state) {
            final data = state.extra as (bool, int);
            return CustomTransition(
              key: state.pageKey,
              child: CategoriesScreen(
                data: data,
              ),
            );
          },
        ),
        GoRoute(
          path: "/general",
          name: "general",
          builder: (context, state) {
            return const GeneralScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const GeneralScreen(),
            );
          },
        ),
        GoRoute(
          path: "/readerMode",
          name: "readerMode",
          builder: (context, state) {
            return const ReaderScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const ReaderScreen(),
            );
          },
        ),
        GoRoute(
          path: "/browseS",
          name: "browseS",
          builder: (context, state) {
            return const BrowseSScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const BrowseSScreen(),
            );
          },
        ),
        GoRoute(
          path: "/downloads",
          name: "downloads",
          builder: (context, state) {
            return const DownloadsScreen();
          },
          pageBuilder: (context, state) {
            return CustomTransition(
              key: state.pageKey,
              child: const DownloadsScreen(),
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
