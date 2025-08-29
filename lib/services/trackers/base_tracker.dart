import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';

abstract class BaseTracker {
  Future<bool> checkRefresh();
  Future<Track?> findLibItem(Track track, bool isManga);
  Future<Track> update(Track track, bool isManga);
  List<TrackStatus> statusList(bool isManga);
  Future<List<TrackSearch>> search(String query, bool isManga);
  Future<List<TrackSearch>> fetchGeneralData({
    bool isManga,
    String rankingType,
  });
  Future<List<TrackSearch>> fetchUserData({bool isManga});

  /// Anilist
  (int, int) getScoreValue();

  /// Anilist
  String displayScore(int score);
}
