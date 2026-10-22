import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/anime/mixins/anime_mpv_bridge_mixin.dart';
import 'package:mangayomi/modules/anime/mixins/anime_player_settings_mixin.dart';
import 'package:mangayomi/modules/anime/mixins/anime_track_selection_mixin.dart';
import 'package:mangayomi/modules/anime/utils/always_on_top.dart';
import 'package:mangayomi/modules/anime/utils/player_shortcuts.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/anime/widgets/mobile_player_controls_layout.dart';
import 'package:mangayomi/modules/anime/widgets/play_or_pause_button.dart';
import 'package:mangayomi/modules/anime/widgets/player_shortcut_pills.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_controls.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';
import 'package:mangayomi/modules/reader_common/providers/chapter_display.dart';
import 'package:mangayomi/modules/reader_common/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/reader_common/widgets/chapter_bar_title.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/key_bindings.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:shiori/shiori.dart';

/// Builds the top, bottom, TV, and mobile HUD control bars, seek/chapter pills,
/// and keyboard/TV-remote shortcut bindings for the anime player.
mixin AnimePlayerControlsMixin<T extends riv.ConsumerStatefulWidget>
    on
        riv.ConsumerState<T>,
        AlwaysOnTopStateMixin<T>,
        AnimeMpvBridgeMixin<T>,
        AnimeTrackSelectionMixin<T>,
        AnimePlayerSettingsMixin<T> {
  VideoController get controlsVideoController;
  ValueNotifier<Duration?> get controlsTempPosition;
  ValueNotifier<bool> get controlsIsLocked;
  ValueNotifier<int> get controlsReveal;
  FocusNode get controlsTvPanelFocus;
  bool get controlsHasNextEpisode => mpvStreamController.hasNextEpisode;
  VoidCallback get controlsGoBackToDetail;
  VoidCallback get controlsChangeFitLabel;
  Future<void> Function(bool isFullscreen) get controlsToggleFullscreen;
  VoidCallback get controlsOpenTvSettingsPanel;

  bool _playAfterOverlay = false;

  /// Pauses while the episode list or the share sheet is open
  /// ([closed] true once it has closed), and plays again only if it was playing.
  void pauseWhileOpen(bool closed) {
    if (!closed) {
      _playAfterOverlay = mpvBridgePlayer.state.playing;
      mpvBridgePlayer.pause();
    } else if (_playAfterOverlay) {
      _playAfterOverlay = false;
      mpvBridgePlayer.play();
    }
  }

  Widget seekToWidget({bool iconOnly = false}) {
    final defaultSkipIntroLength = ref.watch(
      defaultSkipIntroLengthStateProvider,
    );
    return ValueListenableBuilder(
      valueListenable: mpvCustomButton,
      builder: (context, value, child) {
        if (!(value?.visible ?? true)) return const SizedBox.shrink();

        final label = value?.currentTitle ?? "+$defaultSkipIntroLength";
        void onPressed() {
          if (value != null) {
            value.onPress();
          } else {
            unawaited(mpvSeekBy(defaultSkipIntroLength));
          }
        }

        final onLongPress = value == null ? null : () => value.onLongPress();
        if (iconOnly) {
          return MobilePlayerCompactSeekControl(
            key: const ValueKey('mobile-player-portrait-seek-button'),
            tooltip:
                value?.currentTitle ??
                context.l10n.shortcut_seek_forward(defaultSkipIntroLength),
            seconds: value == null ? defaultSkipIntroLength : null,
            onPressed: onPressed,
            onLongPress: onLongPress,
          );
        }

        // One of the player's pills, so it reads over the video in either
        // theme; a long press is the custom button's second action.
        return PlayerPillButton(
          icon: Symbols.fast_forward_rounded,
          label: label,
          tooltip:
              value?.currentTitle ??
              context.l10n.shortcut_seek_forward(defaultSkipIntroLength),
          onTap: onPressed,
          onLongPress: onLongPress,
        );
      },
    );
  }

  Widget chapterMarkWidget({bool iconOnly = false}) {
    return ValueListenableBuilder(
      valueListenable: mpvCurrentChapterMark,
      builder: (context, value, child) {
        // The marks of the previous video can be gone while the index stays.
        final chapter = value == null
            ? null
            : mpvChapterMarks.value.elementAtOrNull(value);
        if (chapter == null) return const SizedBox.shrink();
        // A chapter with no title of its own is named by its start alone,
        // not " - 00:00".
        final start = Duration(milliseconds: chapter.$2).label();
        final label = chapter.$1.trim().isEmpty
            ? start
            : "${chapter.$1} · $start";
        void onPressed() =>
            openPlayerSettings(context, initialIndex: chaptersSectionIndex);

        // The chapter of the video now, as one of the player's pills; the
        // label is left out where the row is short.
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s4),
          child: PlayerPillButton(
            icon: Symbols.bookmark_rounded,
            label: label,
            showLabel: !iconOnly,
            tooltip: label,
            isCompact: iconOnly,
            onTap: onPressed,
          ),
        );
      },
    );
  }

  /// The episode as the series' list names it: its title, or "Episode 3".
  String episodeLabel() {
    final episode = settingsEpisode;
    final manga = episode.manga.value;
    if (manga == null) return episode.name ?? '';
    return chapterDisplayName(
      episode,
      manga,
      context.l10n,
      byNumber: ref.watch(
        chapterNumberDisplayProvider.select((ids) => ids.contains(manga.id)),
      ),
    );
  }

  Widget tvControls() {
    return TvPlayerControls(
      player: mpvBridgePlayer,
      revealControls: controlsReveal,
      title: settingsEpisode.manga.value?.name ?? '',
      episodeLabel: episodeLabel(),
      // Direct pop, not maybePop: the on-screen back arrow always exits the
      // player, bypassing the PopScope that makes the remote Back hide the
      // panel first.
      onBack: controlsGoBackToDetail,
      onRestart: () => mpvBridgePlayer.seek(Duration.zero),
      onSettings: () {
        // On TV the settings open as the docked side panel; phones/desktop keep
        // the bottom-sheet menu.
        if (isTv) {
          controlsOpenTvSettingsPanel();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) controlsTvPanelFocus.requestFocus();
          });
        } else {
          openPlayerSettings(context);
        }
      },
      hasNext: controlsHasNextEpisode,
      onNext: controlsHasNextEpisode
          ? () => mpvPushToNewEpisode(
              context,
              mpvStreamController.getNextEpisode(),
            )
          : null,
      qualityListenable: selectedVideoPrefs,
      buildQualityOptions: buildTvQualityOptions,
      speedListenable: settingsPlaybackSpeed,
      onSetSpeed: settingsSetPlaybackSpeed,
    );
  }

  bool usesCompactPortraitControls(BuildContext context) {
    return !isDesktop &&
        !isTv &&
        usesCompactPortraitPlayerControls(
          orientation: MediaQuery.orientationOf(context),
          width: MediaQuery.sizeOf(context).width,
        );
  }

  Widget mobileBottomButtonBar(BuildContext context) {
    final compactPortrait = usesCompactPortraitControls(context);
    // The line under the timeline, laid out as desktop's: the chapter on
    // the left; on the right the stream's and the playback's choices, each
    // a pill with its value, then the settings and fullscreen. The lock and
    // the skip sit above the panel (see [mobileAbovePanel]); the episodes
    // are in the middle of the picture and in the top bar.
    return MobilePlayerBottomControlsLayout(
      compactPortrait: compactPortrait,
      lockButton: const SizedBox.shrink(),
      seekButton: const SizedBox.shrink(),
      chapterButton: compactPortrait
          ? const SizedBox.shrink()
          : chapterMarkWidget(),
      shortcutButtons: buildSettingsButtons(
        context,
        iconOnly: compactPortrait,
        pills: compactPortrait
            ? const {
                PlayerPill.subtitles,
                PlayerPill.speed,
                PlayerPill.settings,
                PlayerPill.fullscreen,
              }
            : const {...PlayerPill.values},
      ),
    );
  }

  /// Above the panel, on the left as desktop's skip: the lock and the
  /// skip (+85 s, or the source's own button).
  Widget mobileAbovePanel(BuildContext context) {
    final compactPortrait = usesCompactPortraitControls(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s8),
      child: Row(
        children: [
          KeyedSubtree(
            key: const ValueKey('mobile-player-lock-button'),
            child: ShioriOverlayPill(
              icon: Symbols.lock_open_rounded,
              tooltip: context.l10n.lock,
              onTap: () {
                HapticFeedback.lightImpact();
                controlsIsLocked.value = true;
              },
            ),
          ),
          const SizedBox(width: ShioriSpace.s8),
          seekToWidget(iconOnly: compactPortrait),
        ],
      ),
    );
  }

  Widget desktopBottomButtonBar(BuildContext context) {
    final skipDuration = ref.watch(defaultDoubleTapToSkipLengthStateProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (mpvStreamController.hasPreviousEpisode)
                      ShioriOverlayIconButton(
                        tooltip: context.l10n.previous_episode,
                        size: 22,
                        onPressed: () => mpvPushToNewEpisode(
                          context,
                          mpvStreamController.getPrevEpisode(),
                        ),
                        icon: const Icon(
                          Symbols.skip_previous_rounded,
                          fill: 1,
                        ),
                      ),
                    CustomPlayOrPauseButton(
                      controller: controlsVideoController,
                    ),
                    if (controlsHasNextEpisode)
                      ShioriOverlayIconButton(
                        tooltip: context.l10n.next_episode,
                        size: 22,
                        onPressed: () => mpvPushToNewEpisode(
                          context,
                          mpvStreamController.getNextEpisode(),
                        ),
                        icon: const Icon(Symbols.skip_next_rounded, fill: 1),
                      ),
                    desktopSeekButton(context, -skipDuration),
                    desktopSeekButton(context, skipDuration),
                    CustomMaterialDesktopVolumeButton(
                      controller: controlsVideoController,
                    ),
                    ValueListenableBuilder(
                      valueListenable: controlsTempPosition,
                      builder: (context, value, child) =>
                          CustomMaterialDesktopPositionIndicator(
                            delta: value,
                            controller: controlsVideoController,
                          ),
                    ),
                    chapterMarkWidget(),
                  ],
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: buildSettingsButtons(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Seeks [seconds] back (negative) or on, the count drawn in the arrow.
  Widget desktopSeekButton(BuildContext context, int seconds) {
    final back = seconds < 0;
    final count = seconds.abs();
    return SizedBox(
      height: 50,
      width: 50,
      child: IconButton(
        tooltip: back
            ? context.l10n.shortcut_seek_back(count)
            : context.l10n.shortcut_seek_forward(count),
        onPressed: () => mpvSeekBy(seconds),
        icon: Stack(
          children: [
            Positioned.fill(
              child: Icon(
                back
                    ? Symbols.rotate_left_rounded
                    : Symbols.rotate_right_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: context.shiori.text.badge.fontSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// helper method for [mobileBottomButtonBar] and [desktopBottomButtonBar].
  Widget buildSettingsButtons(
    BuildContext context, {
    bool iconOnly = false,
    Set<PlayerPill> pills = const {...PlayerPill.values},
  }) => PlayerShortcutPills(
    pills: pills,
    videos: trackVideos,
    video: selectedVideoPrefs,
    player: mpvBridgePlayer,
    subtitleTrack: () => effectiveSubtitleTrack,
    audioTrack: () => effectiveAudioTrack,
    playbackSpeed: settingsPlaybackSpeed,
    fit: settingsFit,
    iconOnly: iconOnly,
    onQuality: (context) =>
        openPlayerSettings(context, initialIndex: qualitySectionIndex),
    onSubtitles: (context) =>
        openPlayerSettings(context, initialIndex: subtitleSectionIndex),
    onAudio: (context) =>
        openPlayerSettings(context, initialIndex: audioSectionIndex),
    onSpeed: (context) =>
        openPlayerSettings(context, initialIndex: speedSectionIndex),
    onSettings: openPlayerSettings,
    onChangeFit: controlsChangeFitLabel,
    onToggleFullscreen: controlsToggleFullscreen,
  );

  Widget btnToShowShareScreenshot(
    Chapter episode, {
    void Function(bool)? onChanged,
  }) {
    return IconButton(
      tooltip: context.l10n.share,
      onPressed: () async {
        onChanged?.call(false);
        await settingsShareScreenshot(context, episode);
        onChanged?.call(true);
      },
      icon: Icon(Icons.adaptive.share, color: Colors.white),
    );
  }

  Widget topButtonBar(BuildContext context) {
    final compactPortrait = usesCompactPortraitControls(context);

    Widget episodesButton() {
      return btnToShowChapterListDialog(
        context,
        context.l10n.episodes,
        settingsEpisode,
        // Wider than tall, the list opens beside the video, which keeps
        // playing; the sheet from the bottom covers it, so that pauses.
        onChanged: (closed) {
          final size = MediaQuery.sizeOf(context);
          if (closed || size.width <= size.height) pauseWhileOpen(closed);
        },
        iconColor: Colors.white,
      );
    }

    // The series and the episode, as the readers' bars and the loading
    // state name them.
    final title = Padding(
      padding: EdgeInsetsDirectional.only(
        start: compactPortrait ? 0 : ShioriSpace.s8,
        end: ShioriSpace.s8,
      ),
      child: ChapterBarTitle(chapter: settingsEpisode, onImage: true),
    );

    // The top keeps who and where: the way back, what is playing, and the
    // settings. What is changed while watching is in the panel at the foot;
    // autoplay and sharing are in the settings.
    return MobilePlayerTopSafeArea(
      isDesktop: isDesktop,
      child: MobilePlayerTopControlsLayout(
        compactPortrait: compactPortrait,
        backButton: ShioriOverlayIconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          size: 24,
          onPressed: controlsGoBackToDetail,
          icon: const Icon(Symbols.arrow_back_rounded),
        ),
        title: title,
        wideActions: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (supportsAlwaysOnTop)
              IconButton(
                tooltip: context.l10n.always_on_top,
                icon: const Icon(
                  fill: 1,
                  Symbols.push_pin_rounded,
                  color: Colors.white,
                ),
                onPressed: toggleAlwaysOnTop,
              ),
            episodesButton(),
            // A phone shares from the settings. The settings themselves are
            // in the panel at the foot, on every platform, not here too.
            if (isDesktop)
              btnToShowShareScreenshot(
                settingsEpisode,
                onChanged: pauseWhileOpen,
              ),
          ],
        ),
        portraitActions: MobilePlayerPortraitActionTheme(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              KeyedSubtree(
                key: const ValueKey('mobile-player-portrait-episodes'),
                child: episodesButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Maps keyboard and TV-remote keys to player actions for non-desktop
  /// builds. Only dedicated media keys + the usual mpv-style keys are bound
  /// (no D-pad arrows beyond seek), so it stays additive and doesn't fight
  /// touch input. Reuses the existing player + episode-navigation methods.
  Widget wrapWithPlayerShortcuts(Widget child) {
    void seekBy(int seconds) {
      mpvBridgePlayer.seek(
        mpvBridgePlayer.state.position + Duration(seconds: seconds),
      );
    }

    final bindings = ref.watch(keyBindingsStateProvider);
    final actions = <PlayerShortcut, VoidCallback>{
      PlayerShortcut.playPause: mpvBridgePlayer.playOrPause,
      PlayerShortcut.seekBackLong: () => seekBy(-playerLongSeekSeconds),
      PlayerShortcut.seekForwardLong: () => seekBy(playerLongSeekSeconds),
    };
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        for (final MapEntry(key: shortcut, value: action) in actions.entries)
          for (final combo in bindings[shortcut]!) combo.activator: action,
        const SingleActivator(LogicalKeyboardKey.mediaPlayPause): () {
          mpvBridgePlayer.playOrPause();
        },
        const SingleActivator(LogicalKeyboardKey.mediaPlay): () {
          mpvBridgePlayer.play();
        },
        const SingleActivator(LogicalKeyboardKey.mediaPause): () {
          mpvBridgePlayer.pause();
        },
        // Seek via J/L (or the keys they were rebound to) and the dedicated
        // media keys only. Arrow keys are left unbound so they keep driving
        // d-pad focus traversal on Android TV (and arrow-key focus movement
        // with a keyboard) instead of seeking.
        const SingleActivator(LogicalKeyboardKey.mediaRewind): () =>
            seekBy(-10),
        const SingleActivator(LogicalKeyboardKey.mediaFastForward): () =>
            seekBy(10),
        const SingleActivator(LogicalKeyboardKey.mediaTrackNext): () {
          if (controlsHasNextEpisode && mounted) {
            mpvPushToNewEpisode(context, mpvStreamController.getNextEpisode());
          }
        },
        const SingleActivator(LogicalKeyboardKey.mediaTrackPrevious): () {
          if (mpvStreamController.hasPreviousEpisode && mounted) {
            mpvPushToNewEpisode(context, mpvStreamController.getPrevEpisode());
          }
        },
      },
      child: MouseRegion(
        // Desktop debugging: a mouse has no d-pad, so let hover and clicks
        // reveal the auto-hiding controls (bumping the same notifier the remote
        // does). No-op on a TV, which sends no pointer-hover events.
        onEnter: (_) => controlsReveal.value++,
        onHover: (_) => controlsReveal.value++,
        child: Listener(
          // Reveal on a mouse click (desktop), but NOT on touch. On a touch
          // device the mobile controls handle tap-to-toggle themselves, so
          // revealing here on finger-down makes the following tap immediately
          // hide them again (controls flash and vanish in under a second).
          onPointerDown: (event) {
            if (event.kind == PointerDeviceKind.mouse) controlsReveal.value++;
          },
          child: Focus(autofocus: true, onKeyEvent: onPlayerKey, child: child),
        ),
      ),
    );
  }

  // On a TV remote / keyboard, reveal the on-screen controls when the user
  // presses the d-pad. The arrow keys stay unbound above (so they still drive
  // focus traversal between the control buttons) — we just bump [controlsReveal]
  // so the controls become visible and the focus is on something the user can
  // see. Returns ignored so traversal + the media shortcuts still run.
  KeyEventResult onPlayerKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      final k = event.logicalKey;
      final isNav =
          k == LogicalKeyboardKey.arrowUp ||
          k == LogicalKeyboardKey.arrowDown ||
          k == LogicalKeyboardKey.arrowLeft ||
          k == LogicalKeyboardKey.arrowRight ||
          k == LogicalKeyboardKey.select ||
          k == LogicalKeyboardKey.enter ||
          k == LogicalKeyboardKey.numpadEnter ||
          k == LogicalKeyboardKey.gameButtonA;
      if (isNav) controlsReveal.value++;
    }
    return KeyEventResult.ignored;
  }
}
