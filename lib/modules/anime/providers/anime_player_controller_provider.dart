import 'package:flutter_riverpod/misc.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/modules/manga/reader/mixins/chapter_controller_mixin.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
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
  final bool incognitoMode = isar.settings.getSync(227)!.incognitoMode!;

  // ---------------------------------------------------------------------------
  // Anime-flavoured aliases (preserve the existing public API)
  // ---------------------------------------------------------------------------

  (int, bool) getEpisodeIndex() => getChapterIndex();

  Chapter getPrevEpisode() => getPrevChapter();
  Chapter getNextEpisode() => getNextChapter();

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
      isar.writeTxnSync(() {
        ep.isRead = isWatch;
        ep.lastPageRead = (duration.inMilliseconds).toString();
        ep.updatedAt = DateTime.now().millisecondsSinceEpoch;
        isar.chapters.putSync(ep);
      });
      if (isWatch) {
        episode.updateTrackChapterRead(ref);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // AniSkip
  // ---------------------------------------------------------------------------

  (int, int)? _getTrackId() {
    final malId = isar.tracks
        .filter()
        .syncIdEqualTo(1)
        .mangaIdEqualTo(episode.manga.value!.id!)
        .findFirstSync()
        ?.mediaId;
    final aniId = isar.tracks
        .filter()
        .syncIdEqualTo(2)
        .mangaIdEqualTo(episode.manga.value!.id!)
        .findFirstSync()
        ?.mediaId;
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
            ChapterRecognition().parseChapterNumber(
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
