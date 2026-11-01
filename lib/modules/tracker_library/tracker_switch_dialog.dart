import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/track_state_providers.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:shiori/shiori.dart';

/// Shows a dialog to select and switch the active tracker provider and item type.
void showTrackerSwitchProviderDialog(
  BuildContext context,
  WidgetRef ref, {
  required List<TrackPreference> preferences,
  required AppLocalizations l10n,
}) {
  final hideItems = ref.read(hideItemsStateProvider);
  final animeOnly = ref.read(animeOnlyTvModeProvider);
  final showManga = !animeOnly && !hideItems.contains("/MangaLibrary");
  final showAnime = !hideItems.contains("/AnimeLibrary");

  showDialog(
    context: context,
    builder: (ctx) {
      return ShioriDialog(
        title: l10n.track_library_switch,
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildListTile(
                ctx,
                ref,
                l10n,
                TrackerProviders.myAnimeList.syncId,
                preferences: preferences,
                showManga: showManga,
                showAnime: showAnime,
              ),
              _buildListTile(
                ctx,
                ref,
                l10n,
                TrackerProviders.anilist.syncId,
                preferences: preferences,
                showManga: showManga,
                showAnime: showAnime,
              ),
              _buildListTile(
                ctx,
                ref,
                l10n,
                TrackerProviders.kitsu.syncId,
                preferences: preferences,
                showManga: showManga,
                showAnime: showAnime,
              ),
              _buildListTile(
                ctx,
                ref,
                l10n,
                TrackerProviders.local.syncId,
                preferences: preferences,
                showManga: showManga,
                showAnime: showAnime,
              ),
              if (showAnime || !showManga) ...[
                _buildListTile(
                  ctx,
                  ref,
                  l10n,
                  TrackerProviders.simkl.syncId,
                  preferences: preferences,
                  showManga: showManga,
                  showAnime: showAnime,
                ),
                _buildListTile(
                  ctx,
                  ref,
                  l10n,
                  TrackerProviders.trakt.syncId,
                  preferences: preferences,
                  showManga: showManga,
                  showAnime: showAnime,
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

void _openSwitchTypeDialog(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  int syncId, {
  required List<TrackPreference> preferences,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return ShioriDialog(
        title: l10n.track_library_switch,
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildListTile(
                ctx,
                ref,
                l10n,
                syncId,
                isManga: true,
                preferences: preferences,
              ),
              _buildListTile(
                ctx,
                ref,
                l10n,
                syncId,
                isManga: false,
                preferences: preferences,
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildListTile(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  int syncId, {
  bool? isManga,
  required List<TrackPreference> preferences,
  bool showManga = true,
  bool showAnime = true,
}) {
  final isLoggedIn = preferences.any((p) => p.syncId == syncId);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s4),
    child: ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ShioriShape.card),
      ),
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ShioriShape.card),
          color: trackInfos(syncId).$3,
        ),
        width: 60,
        height: 70,
        child: isManga == null
            ? Image.asset(trackInfos(syncId).$1, height: 30)
            : Icon(
                isManga
                    ? Symbols.collections_bookmark_rounded
                    : Symbols.video_library_rounded,
                size: 30,
              ),
      ),
      title: Text(
        isManga == null
            ? trackInfos(syncId).$2
            : isManga
            ? l10n.manga
            : l10n.anime,
      ),
      enabled: isLoggedIn,
      onTap: () {
        final isAnimeOnlyTracker =
            syncId == TrackerProviders.simkl.syncId ||
            syncId == TrackerProviders.trakt.syncId;
        if (isManga == null && !isAnimeOnlyTracker && showManga && showAnime) {
          context.pop();
          _openSwitchTypeDialog(
            context,
            ref,
            l10n,
            syncId,
            preferences: preferences,
          );
        } else {
          final targetIsManga =
              isManga ?? (!isAnimeOnlyTracker && (showManga || !showAnime));
          ref.read(lastTrackerLibraryLocationStateProvider.notifier).set((
            syncId,
            targetIsManga,
          ));
          context.pop();
        }
      },
    ),
  );
}
