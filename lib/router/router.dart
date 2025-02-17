import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/anime/anime_player_view.dart';
import 'package:mangayomi/modules/browse/extension/edit_code.dart';
import 'package:mangayomi/modules/browse/extension/extension_detail.dart';
import 'package:mangayomi/modules/browse/extension/widgets/create_extension.dart';
import 'package:mangayomi/modules/browse/sources/sources_filter_screen.dart';
import 'package:mangayomi/modules/more/data_and_storage/create_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/data_and_storage.dart';
import 'package:mangayomi/modules/more/settings/appearance/custom_navigation_settings.dart';
import 'package:mangayomi/modules/more/settings/browse/source_repositories.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_view.dart';
import 'package:mangayomi/modules/updates/updates_screen.dart';
import 'package:mangayomi/modules/more/categories/categories_screen.dart';
import 'package:mangayomi/modules/more/settings/downloads/downloads_screen.dart';
import 'package:mangayomi/modules/more/settings/player/player_screen.dart';
import 'package:mangayomi/modules/more/settings/sync/sync.dart';
import 'package:mangayomi/modules/more/settings/track/track.dart';
import 'package:mangayomi/modules/more/settings/track/manage_trackers/manage_trackers.dart';
import 'package:mangayomi/modules/more/settings/track/manage_trackers/tracking_detail.dart';
import 'package:mangayomi/modules/webview/webview.dart';
import 'package:mangayomi/modules/browse/browse_screen.dart';
import 'package:mangayomi/modules/browse/extension/extension_lang.dart';
import 'package:mangayomi/modules/browse/global_search/global_search_screen.dart';
import 'package:mangayomi/modules/main_view/main_screen.dart';
import 'package:mangayomi/modules/history/history_screen.dart';
import 'package:mangayomi/modules/library/library_screen.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_main.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
part 'router.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
@riverpod
GoRouter router(Ref ref) {
  final router = RouterNotifier();
  final initLocation = ref.watch(navigationOrderStateProvider).first;

  return GoRouter(
      observers: [BotToastNavigatorObserver()],
      initialLocation: initLocation,
      debugLogDiagnostics: kDebugMode,
      refreshListenable: router,
      routes: router._routes,
      navigatorKey: navigatorKey,
      onException: (context, state, router) => router.go(initLocation),);
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
                  itemType: ItemType.manga,
                ),
                pageBuilder: (context, state) => transitionPage(
                  key: state.pageKey,
                  child: const LibraryScreen(
                    itemType: ItemType.manga,
                  ),
                ),
              ),
              GoRoute(
                name: "AnimeLibrary",
                path: '/AnimeLibrary',
                builder: (context, state) => const LibraryScreen(
                  itemType: ItemType.anime,
                ),
                pageBuilder: (context, state) => transitionPage(
                  key: state.pageKey,
                  child: const LibraryScreen(
                    itemType: ItemType.anime,
                  ),
                ),
              ),
              GoRoute(
                name: "NovelLibrary",
                path: '/NovelLibrary',
                builder: (context, state) => const LibraryScreen(
                  itemType: ItemType.novel,
                ),
                pageBuilder: (context, state) => transitionPage(
                  key: state.pageKey,
                  child: const LibraryScreen(
                    itemType: ItemType.novel,
                  ),
                ),
              ),
              GoRoute(
                name: "history",
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
                pageBuilder: (context, state) => transitionPage(
                  key: state.pageKey,
                  child: const HistoryScreen(),
                ),
              ),
              GoRoute(
                name: "updates",
                path: '/updates',
                builder: (context, state) => const UpdatesScreen(),
                pageBuilder: (context, state) => transitionPage(
                  key: state.pageKey,
                  child: const UpdatesScreen(),
                ),
              ),
              GoRoute(
                name: "browse",
                path: '/browse',
                builder: (context, state) => const BrowseScreen(),
                pageBuilder: (context, state) => transitionPage(
                  key: state.pageKey,
                  child: const BrowseScreen(),
                ),
              ),
              GoRoute(
                name: "more",
                path: '/more',
                builder: (context, state) => const MoreScreen(),
                pageBuilder: (context, state) => transitionPage(
                  key: state.pageKey,
                  child: const MoreScreen(),
                ),
              ),
            ]),
        GoRoute(
            path: "/mangaHome",
            name: "mangaHome",
            builder: (context, state) {
              final source = state.extra as (Source?, bool);
              return MangaHomeScreen(
                source: source.$1!,
                isLatest: source.$2,
              );
            },
            pageBuilder: (context, state) {
              final source = state.extra as (Source?, bool);
              return transitionPage(
                key: state.pageKey,
                child: MangaHomeScreen(
                  source: source.$1!,
                  isLatest: source.$2,
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

              return transitionPage(
                  key: state.pageKey,
                  child: MangaReaderDetail(
                    mangaId: mangaId,
                  ));
            }),
        GoRoute(
          path: "/mangaReaderView",
          name: "mangaReaderView",
          builder: (context, state) {
            final chapterId = state.extra as int;
            return MangaReaderView(
              chapterId: chapterId,
            );
          },
          pageBuilder: (context, state) {
            final chapterId = state.extra as int;
            return transitionPage(
              key: state.pageKey,
              child: MangaReaderView(
                chapterId: chapterId,
              ),
            );
          },
        ),
        GoRoute(
          path: "/animePlayerView",
          name: "animePlayerView",
          builder: (context, state) {
            final episodeId = state.extra as int;
            return AnimePlayerView(
              episodeId: episodeId,
            );
          },
          pageBuilder: (context, state) {
            final episodeId = state.extra as int;
            return transitionPage(
              key: state.pageKey,
              child: AnimePlayerView(
                episodeId: episodeId,
              ),
            );
          },
        ),
        GoRoute(
          path: "/novelReaderView",
          name: "novelReaderView",
          builder: (context, state) {
            final chapterId = state.extra as int;
            return NovelReaderView(
              chapterId: chapterId,
            );
          },
          pageBuilder: (context, state) {
            final chapterId = state.extra as int;
            return transitionPage(
              key: state.pageKey,
              child: NovelReaderView(
                chapterId: chapterId,
              ),
            );
          },
        ),
        GoRoute(
          path: "/ExtensionLang",
          name: "ExtensionLang",
          builder: (context, state) {
            final itemType = state.extra as ItemType;
            return ExtensionsLang(
              itemType: itemType,
            );
          },
          pageBuilder: (context, state) {
            final itemType = state.extra as ItemType;
            return transitionPage(
              key: state.pageKey,
              child: ExtensionsLang(
                itemType: itemType,
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
            return transitionPage(
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
            return transitionPage(
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
            return transitionPage(
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
            final itemType = state.extra as ItemType;
            return GlobalSearchScreen(
              itemType: itemType,
            );
          },
          pageBuilder: (context, state) {
            final itemType = state.extra as ItemType;
            return transitionPage(
              key: state.pageKey,
              child: GlobalSearchScreen(
                itemType: itemType,
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
            return transitionPage(
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
            return transitionPage(
              key: state.pageKey,
              child: const TrackScreen(),
            );
          },
        ),
        GoRoute(
          path: "/sync",
          name: "sync",
          builder: (context, state) {
            return const SyncScreen();
          },
          pageBuilder: (context, state) {
            return transitionPage(
              key: state.pageKey,
              child: const SyncScreen(),
            );
          },
        ),
        GoRoute(
          path: "/sourceFilter",
          name: "sourceFilter",
          builder: (context, state) {
            final itemType = state.extra as ItemType;
            return SourcesFilterScreen(
              itemType: itemType,
            );
          },
          pageBuilder: (context, state) {
            final itemType = state.extra as ItemType;
            return transitionPage(
              key: state.pageKey,
              child: SourcesFilterScreen(
                itemType: itemType,
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
            return transitionPage(
              key: state.pageKey,
              child: const DownloadQueueScreen(),
            );
          },
        ),
        GoRoute(
          path: "/mangawebview",
          name: "mangawebview",
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            return MangaWebView(
              url: data["url"]!,
              title: data['title']!,
            );
          },
          pageBuilder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            return transitionPage(
              key: state.pageKey,
              child: MangaWebView(
                url: data["url"]!,
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
            return transitionPage(
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
            return transitionPage(
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
            return transitionPage(
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
            return transitionPage(
              key: state.pageKey,
              child: const BrowseSScreen(),
            );
          },
        ),
        GoRoute(
          path: "/SourceRepositories",
          name: "SourceRepositories",
          builder: (context, state) {
            final itemType = state.extra as ItemType;
            return SourceRepositories(
              itemType: itemType,
            );
          },
          pageBuilder: (context, state) {
            final itemType = state.extra as ItemType;
            return transitionPage(
              key: state.pageKey,
              child: SourceRepositories(
                itemType: itemType,
              ),
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
            return transitionPage(
              key: state.pageKey,
              child: const DownloadsScreen(),
            );
          },
        ),
        GoRoute(
          path: "/dataAndStorage",
          name: "dataAndStorage",
          builder: (context, state) {
            return const DataAndStorage();
          },
          pageBuilder: (context, state) {
            return transitionPage(
              key: state.pageKey,
              child: const DataAndStorage(),
            );
          },
        ),
        GoRoute(
          path: "/manageTrackers",
          name: "manageTrackers",
          builder: (context, state) {
            return const ManageTrackersScreen();
          },
          pageBuilder: (context, state) {
            return transitionPage(
              key: state.pageKey,
              child: const ManageTrackersScreen(),
            );
          },
        ),
        GoRoute(
          path: "/trackingDetail",
          name: "trackingDetail",
          builder: (context, state) {
            final trackerPref = state.extra as TrackPreference;
            return TrackingDetail(trackerPref: trackerPref);
          },
          pageBuilder: (context, state) {
            final trackerPref = state.extra as TrackPreference;
            return transitionPage(
              key: state.pageKey,
              child: TrackingDetail(trackerPref: trackerPref),
            );
          },
        ),
        GoRoute(
          path: "/playerMode",
          name: "playerMode",
          builder: (context, state) {
            return const PlayerScreen();
          },
          pageBuilder: (context, state) {
            return transitionPage(
              key: state.pageKey,
              child: const PlayerScreen(),
            );
          },
        ),
        GoRoute(
          path: "/codeEditor",
          name: "codeEditor",
          builder: (context, state) {
            final sourceId = state.extra as int?;
            return CodeEditorPage(sourceId: sourceId);
          },
          pageBuilder: (context, state) {
            final sourceId = state.extra as int?;
            return transitionPage(
              key: state.pageKey,
              child: CodeEditorPage(sourceId: sourceId),
            );
          },
        ),
        GoRoute(
          path: "/createExtension",
          name: "createExtension",
          builder: (context, state) {
            return const CreateExtension();
          },
          pageBuilder: (context, state) {
            return transitionPage(
              key: state.pageKey,
              child: const CreateExtension(),
            );
          },
        ),
        GoRoute(
          path: "/createBackup",
          name: "createBackup",
          builder: (context, state) {
            return const CreateBackup();
          },
          pageBuilder: (context, state) {
            return transitionPage(
              key: state.pageKey,
              child: const CreateBackup(),
            );
          },
        ),
        GoRoute(
          path: "/customNavigationSettings",
          name: "customNavigationSettings",
          builder: (context, state) {
            return const CustomNavigationSettings();
          },
          pageBuilder: (context, state) {
            return transitionPage(
              key: state.pageKey,
              child: const CustomNavigationSettings(),
            );
          },
        ),
      ];
}

Page transitionPage({required LocalKey key, required child}) {
  return Platform.isIOS
      ? CupertinoPage(key: key, child: child)
      : CustomTransition(child: child, key: key);
}

class CustomTransition extends CustomTransitionPage {
  CustomTransition({required LocalKey super.key, required super.child})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}

Route createRoute({required Widget page}) {
  return Platform.isIOS
      ? CupertinoPageRoute(builder: (context) => page)
      : PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}
