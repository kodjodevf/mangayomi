import 'package:isar/isar.dart';
part 'track_preference.g.dart';

@collection
@Name("Track Preference")
class TrackPreference {
  Id? syncId;

  String? username;

  String? oAuth;

  String? prefs;

  TrackPreference({
    this.syncId,
    this.username,
    this.oAuth,
    this.prefs,
  });
}
