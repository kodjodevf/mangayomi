import 'package:isar/isar.dart';
part 'track_preference.g.dart';

@collection
@Name("Track Preference")
class TrackPreference {
  Id? syncId;

  String? username;

  String? oAuth;

  String? prefs;

  bool? refreshing;

  TrackPreference({
    this.syncId,
    this.username,
    this.oAuth,
    this.prefs,
    this.refreshing,
  });

  TrackPreference.fromJson(Map<String, dynamic> json) {
    syncId = json['syncId'];
    username = json['username'];
    oAuth = json['oAuth'];
    prefs = json['prefs'];
  }

  Map<String, dynamic> toJson() => {
    'syncId': syncId,
    'username': username,
    'oAuth': oAuth,
    'prefs': prefs,
  };
}
