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

  TrackPreference.fromJson(Map<String, dynamic> json) {
    syncId = json['syncId'];
    username = json['username'];
    oAuth = json['oAuth'];
    prefs = json['prefs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['syncId'] = syncId;
    data['username'] = username;
    data['oAuth'] = oAuth;
    data['prefs'] = prefs;

    return data;
  }
}
