import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/widgets/play_or_pause_button.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/push_router.dart';
import 'package:shiori/shiori.dart';

/// The controls in the middle of the picture: the previous and the next
/// episode, and play in the accent between them, the one control the eye
/// goes to. A jump within the episode is a double tap on either side.
List<Widget> mobilePrimaryButtonBar(
  BuildContext context,
  GlobalKey<VideoState> key,
  AnimeStreamController streamController,
  VideoController controller, {
  FocusNode? playPauseFocus,
}) {
  final hasPrevEpisode =
      streamController.getEpisodeIndex().$1 + 1 !=
      streamController.getEpisodesLength(streamController.getEpisodeIndex().$2);
  final hasNextEpisode = streamController.getEpisodeIndex().$1 != 0;
  final isFullScreen = isFullscreen(context);
  final l10n = context.l10n;
  void open(Chapter episode) {
    if (isFullScreen) key.currentState?.exitFullscreen();
    pushReplacementMangaReaderView(context: context, chapter: episode);
  }

  return [
    const Spacer(flex: 2),
    ShioriOverlayIconButton(
      onPressed: hasPrevEpisode
          ? () => open(streamController.getPrevEpisode())
          : null,
      tooltip: l10n.previous_episode,
      size: 30,
      icon: const Icon(Symbols.skip_previous_rounded, fill: 1),
    ),
    const Spacer(),
    CustomPlayOrPauseButton(controller: controller, focusNode: playPauseFocus),
    const Spacer(),
    ShioriOverlayIconButton(
      onPressed: hasNextEpisode
          ? () => open(streamController.getNextEpisode())
          : null,
      tooltip: l10n.next_episode,
      size: 30,
      icon: const Icon(Symbols.skip_next_rounded, fill: 1),
    ),
    const Spacer(flex: 2),
  ];
}
