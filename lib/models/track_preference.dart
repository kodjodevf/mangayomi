import 'package:isar_community/isar.dart';
part 'track_preference.g.dart';

@collection
@Name("Track Preference")
class TrackPreference {
  Id? syncId;

  String? username;

  /// What the service calls this account when it shows it to a person.
  ///
  /// Kept apart from [username] because the two are not the same thing on
  /// every service. AniList's [username] is a numeric viewer id, which two
  /// queries parse as an int, so the readable name needs somewhere else to
  /// live. On MyAnimeList, Simkl and Kitsu they are the same string.
  String? displayName;

  /// The account's avatar, as a URL. Null when the service has none or the
  /// login predates this being stored.
  String? avatarUrl;

  String? oAuth;

  String? prefs;

  bool? refreshing;

  TrackPreference({
    this.syncId,
    this.username,
    this.displayName,
    this.avatarUrl,
    this.oAuth,
    this.prefs,
    this.refreshing,
  });

  TrackPreference.fromJson(Map<String, dynamic> json) {
    syncId = json['syncId'];
    username = json['username'];
    displayName = json['displayName'];
    avatarUrl = json['avatarUrl'];
    oAuth = json['oAuth'];
    prefs = json['prefs'];
  }

  Map<String, dynamic> toJson() => {
    'syncId': syncId,
    'username': username,
    'displayName': displayName,
    'avatarUrl': avatarUrl,
    'oAuth': oAuth,
    'prefs': prefs,
  };
}
