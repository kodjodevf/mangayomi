import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/anime/anime_player_view.dart';
import 'package:mangayomi/modules/browse/extension/edit_code.dart';
import 'package:mangayomi/modules/browse/extension/extension_detail.dart';
import 'package:mangayomi/modules/browse/extension/widgets/create_extension.dart';
import 'package:mangayomi/modules/browse/sources/sources_filter_screen.dart';
import 'package:mangayomi/modules/manga/detail/widgets/migrate_screen.dart';
import 'package:mangayomi/modules/more/data_and_storage/create_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/data_and_storage.dart';
import 'package:mangayomi/modules/more/settings/appearance/custom_navigation_settings.dart';
import 'package:mangayomi/modules/more/settings/browse/source_repositories.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/statistics/statistics_screen.dart';
import 'package:mangayomi/modules/novel/novel_reader_view.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_screen.dart';
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
  final hiddenItems = ref.read(hideItemsStateProvider);
  final initLocation = ref
      .watch(navigationOrderStateProvider)
      .where((e) => !hiddenItems.contains(e))
      .first;

  return GoRouter(
    observers: [BotToastNavigatorObserver()],
    initialLocation: initLocation,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: router,
    routes: router._routes,
    navigatorKey: navigatorKey,
    onException: (context, state, router) => router.go(initLocation),
  );
}

@riverpod
class RouterCurrentLocationState extends _$RouterCurrentLocationState {
  bool _didSubscribe = false;
  @override
  String? build() {
    // Delay listener‐registration until after the first frame.
    if (!_didSubscribe) {
      _didSubscribe = true;
      // Schedule the registration to run after the first build/frame:
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _listener();
      });
    }
    return null;
  }

  void _listener() {
    final router = ref.read(routerProvider);
    router.routerDelegate.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RouteMatchList matches =
            router.routerDelegate.currentConfiguration;
        final RouteMatch lastMatch = matches.last;
        final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
            ? lastMatch.matches
            : matches;
        state = matchList.uri.toString();
      });
    });
  }

  void refresh() {
    _listener();
  }
}

class RouterNotifier extends ChangeNotifier {
  List<RouteBase> get _routes => [
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        _genericRoute<String?>(
          name: "MangaLibrary",
          builder: (id) =>
              LibraryScreen(itemType: ItemType.manga, presetInput: id),
        ),
        _genericRoute<String?>(
          name: "AnimeLibrary",
          builder: (id) =>
              LibraryScreen(itemType: ItemType.anime, presetInput: id),
        ),
        _genericRoute<String?>(
          name: "NovelLibrary",
          builder: (id) =>
              LibraryScreen(itemType: ItemType.novel, presetInput: id),
        ),
        _genericRoute<String?>(
          name: "trackerLibrary",
          builder: (id) => TrackerLibraryScreen(presetInput: id),
        ),
        _genericRoute(name: "history", child: const HistoryScreen()),
        _genericRoute(name: "updates", child: const UpdatesScreen()),
        _genericRoute(name: "browse", child: const BrowseScreen()),
        _genericRoute(name: "more", child: const MoreScreen()),
      ],
    ),
    _genericRoute<(Source?, bool)>(
      name: "mangaHome",
      builder: (id) => MangaHomeScreen(source: id.$1!, isLatest: id.$2),
    ),
    _genericRoute<int>(
      path: "/manga-reader/detail",
      builder: (id) => MangaReaderDetail(mangaId: id),
    ),
    _genericRoute<int>(
      name: "mangaReaderView",
      builder: (id) => MangaReaderView(chapterId: id),
    ),
    _genericRoute<int>(
      name: "animePlayerView",
      builder: (id) => AnimePlayerView(episodeId: id),
    ),
    _genericRoute<int>(
      name: "novelReaderView",
      builder: (id) => NovelReaderView(chapterId: id),
    ),
    _genericRoute<ItemType>(
      name: "ExtensionLang",
      builder: (itemType) => ExtensionsLang(itemType: itemType),
    ),
    _genericRoute(name: "settings", child: const SettingsScreen()),
    _genericRoute(name: "appearance", child: const AppearanceScreen()),
    _genericRoute<Source>(
      name: "extension_detail",
      builder: (source) => ExtensionDetail(source: source),
    ),
    _genericRoute<ItemType>(
      name: "globalSearch",
      builder: (itemType) => GlobalSearchScreen(itemType: itemType),
    ),
    _genericRoute(name: "about", child: const AboutScreen()),
    _genericRoute(name: "track", child: const TrackScreen()),
    _genericRoute(name: "sync", child: const SyncScreen()),
    _genericRoute<ItemType>(
      name: "sourceFilter",
      builder: (itemType) => SourcesFilterScreen(itemType: itemType),
    ),
    _genericRoute(name: "downloadQueue", child: const DownloadQueueScreen()),
    _genericRoute<Map<String, dynamic>>(
      name: "mangawebview",
      builder: (data) => MangaWebView(url: data["url"]!, title: data['title']!),
    ),
    _genericRoute<(bool, int)>(
      name: "categories",
      builder: (data) => CategoriesScreen(data: data),
    ),
    _genericRoute(name: "statistics", child: const StatisticsScreen()),
    _genericRoute(name: "general", child: const GeneralScreen()),
    _genericRoute(name: "readerMode", child: const ReaderScreen()),
    _genericRoute(name: "browseS", child: const BrowseSScreen()),
    _genericRoute<ItemType>(
      name: "SourceRepositories",
      builder: (itemType) => SourceRepositories(itemType: itemType),
    ),
    _genericRoute(name: "downloads", child: const DownloadsScreen()),
    _genericRoute(name: "dataAndStorage", child: const DataAndStorage()),
    _genericRoute(name: "manageTrackers", child: const ManageTrackersScreen()),
    _genericRoute<TrackPreference>(
      name: "trackingDetail",
      builder: (trackerPref) => TrackingDetail(trackerPref: trackerPref),
    ),
    _genericRoute(name: "playerMode", child: const PlayerScreen()),
    _genericRoute<int>(
      name: "codeEditor",
      builder: (sourceId) => CodeEditorPage(sourceId: sourceId),
    ),
    _genericRoute(name: "createExtension", child: const CreateExtension()),
    _genericRoute(name: "createBackup", child: const CreateBackup()),
    _genericRoute(
      name: "customNavigationSettings",
      child: const CustomNavigationSettings(),
    ),
    _genericRoute<Manga>(
      name: "migrate",
      builder: (manga) => MigrationScreen(manga: manga),
    ),
    _genericRoute<(Manga, TrackSearch)>(
      name: "migrate/tracker",
      builder: (data) => MigrationScreen(manga: data.$1, trackSearch: data.$2),
    ),
  ];

  GoRoute _genericRoute<T>({
    String? name,
    String? path,
    Widget Function(T extra)? builder,
    Widget? child,
  }) {
    return GoRoute(
      path: path ?? (name != null ? "/$name" : "/"),
      name: name,
      builder: (context, state) {
        if (builder != null) {
          final id = state.extra as T;
          return builder(id);
        } else {
          return child!;
        }
      },
      pageBuilder: (context, state) {
        final pageChild = builder != null ? builder(state.extra as T) : child!;
        return transitionPage(key: state.pageKey, child: pageChild);
      },
    );
  }
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
