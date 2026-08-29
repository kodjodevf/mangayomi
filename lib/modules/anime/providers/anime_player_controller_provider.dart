import 'package:flutter_riverpod/misc.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/mixins/chapter_controller_mixin.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/services/aniskip.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'anime_player_controller_provider.g.dart';

final fullscreenProvider = StateProvider<bool>(() => false);

@riverpod
class AnimeStreamController extends _$AnimeStreamController
    with ChapterControllerMixin {
  @override
  KeepAliveLink build({required Chapter episode}) {
    _keepAliveLink = ref.keepAlive();
    return _keepAliveLink!;
  }

  KeepAliveLink? _keepAliveLink;
  KeepAliveLink? get keepAliveLink => _keepAliveLink;

  // Bridge the mixin's `chapter` contract to the `episode` build parameter.
  @override
  Chapter get chapter => episode;

  // Keep incognitoMode as a final field (read once, not on every access).
  @override
  final bool incognitoMode = settingsRepository.current.incognitoMode!;

  // ---------------------------------------------------------------------------
  // Anime-flavoured aliases (preserve the existing public API)
  // ---------------------------------------------------------------------------

  (int, bool) getEpisodeIndex() => getChapterIndex();

  Chapter getPrevEpisode() => getPrevChapter();
  Chapter getNextEpisode() => getNextChapter();

  bool get hasPreviousEpisode => hasPreviousChapter;
  bool get hasNextEpisode => hasNextChapter;

  int getEpisodesLength(bool isInFilterList) =>
      getChaptersLength(isInFilterList);

  // ---------------------------------------------------------------------------
  // Playback position
  // ---------------------------------------------------------------------------

  Duration getCurrentPosition() {
    if (incognitoMode) return Duration.zero;
    final position = episode.lastPageRead ?? '0';
    return Duration(
      milliseconds: episode.isRead!
          ? 0
          : int.parse(position.isEmpty ? "0" : position),
    );
  }

  void setCurrentPosition(
    Duration duration,
    Duration? totalDuration, {
    bool save = false,
  }) {
    if (episode.isRead!) return;
    if (incognitoMode) return;
    final markEpisodeAsSeenType = ref.read(markEpisodeAsSeenTypeStateProvider);
    final isWatch =
        totalDuration != null &&
            totalDuration != Duration.zero &&
            duration != Duration.zero
        ? duration.inSeconds >=
              ((totalDuration.inSeconds * markEpisodeAsSeenType) / 100).ceil()
        : false;
    if (isWatch || save) {
      final ep = episode;
      ep.isRead = isWatch;
      ep.lastPageRead = (duration.inMilliseconds).toString();
      chapterRepository.save(ep);
      if (isWatch) {
        episode.updateTrackChapterRead(ref);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // AniSkip
  // ---------------------------------------------------------------------------

  (int, int)? _getTrackId() {
    final malId = trackRepository.getMediaIdBySyncAndManga(
      1,
      episode.manga.value!.id!,
    );
    final aniId = trackRepository.getMediaIdBySyncAndManga(
      2,
      episode.manga.value!.id!,
    );
    return switch (malId) {
      != null => (malId, 1),
      == null => switch (aniId) {
        != null => (aniId, 2),
        _ => null,
      },
      _ => null,
    };
  }

  Future<List<Results>?> getAniSkipResults(
    Function(List<Results>) result,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final id = _getTrackId();
    if (id != null) {
      final res = await ref
          .read(aniSkipProvider.notifier)
          .getResult(
            id,
            ChapterRecognition().parseEpisodeNumber(
              episode.manga.value!.name!,
              episode.name!,
            ),
            0,
          );
      result.call(res ?? []);
      return res;
    }
    return null;
  }
}
